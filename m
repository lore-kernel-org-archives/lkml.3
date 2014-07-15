Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbaGODOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:14:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:53679 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654AbaGODOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="573181459"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 03/10] ACPI/EC: Deploy the new GPE handling model.
Date: Tue, 15 Jul 2014 11:14:41 +0800
Message-Id: <a2ae05ad80e58d21a557328dc8bd5a49bfcdafd3.1405391678.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405391678.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405391678.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deploys the following GPE handling model:
1. acpi_enable_gpe()/acpi_disable_gpe():
   This set of APIs are used for EC usage reference counting.
2. acpi_set_gpe(ACPI_GPE_ENABLE)/acpi_set_gpe(ACPI_GPE_DISABLE):
   This set of APIs are used for preventing GPE storm.
Note that this patch only converts current storm prevention implementations
using new APIs without correcting them.

For the EC driver, GPE is enabled for the following users:
1. Event monitoring (HW exception):
   If we want to query events in interrupt mode, acpi_enable_gpe() is
   invoked to allow EVT_SCI IRQs.
2. Command processing (IO request):
   When we receive an upper layer command submission, acpi_enable_gpe() is
   invoked to allow IBF=0,OBF=1 IRQs.
Comments are updated to reflect this model.

For the EC driver, GPE is disabled for the following storms:
1. Command errors:
   If there are too many IRQs coming during a command processing period and
   such IRQs are not related to the event (EVT_SCI),
   acpi_set_gpe(ACPI_GPE_DISABLE) is invoked to prevent further storms
   during the same command transaction. This is not implemented in a good
   style. Ideally, we should only enable storm prevention for the current
   command so that the next command can try the efficient interrupt mode
   again. This patch doesn't change this logic, it will be done by further
   patches. Such correction will be implemented by further patches.
2. Event errors:
   There are cases that BIOS doesn't provide _Qxx handler for the returned
   query value, in this case, acpi_set_gpe(ACPI_GPE_DISABLE) need to be
   invoked to prevent event IRQ storms. This patch doesn't implement this
   logic, it will be done by further patches. Such gap will be implemented
   by further patches.

The acpi_set_gpe() should be invoked for an outstanding command,
which means it should be invoked inside of a pair of acpi_enable_gpe()/
acpi_disable_gpe() invocation. This patch thus also moves the storm
prevention logic into acpi_ec_transaction_unlocked().

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 323a178..5049981 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -314,16 +314,32 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	}
 	/* following two actions should be kept atomic */
 	ec->curr = t;
+	/* Enable GPE for command processing (IBF=0/OBF=1) */
+	acpi_enable_gpe(NULL, ec->gpe);
 	pr_debug("***** Command(%s) started *****\n",
 		 acpi_ec_cmd_string(t->command));
+	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
+		pr_debug("+++++ Polling enabled +++++\n");
+		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_DISABLE);
+	}
 	start_transaction(ec);
 	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	ret = ec_poll(ec);
 	spin_lock_irqsave(&ec->lock, tmp);
+	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
+		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_ENABLE);
+		pr_debug("+++++ Polling disabled +++++\n");
+	} else if (t->irq_count > ec_storm_threshold) {
+		pr_debug("+++++ Polling scheduled (%d GPE) +++++\n",
+			 t->irq_count);
+		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
+	}
 	pr_debug("***** Command(%s) stopped *****\n",
 		 acpi_ec_cmd_string(t->command));
+	/* Disable GPE for command processing (IBF=0/OBF=1) */
+	acpi_disable_gpe(NULL, ec->gpe);
 	ec->curr = NULL;
 unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
@@ -346,26 +362,11 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 			goto unlock;
 		}
 	}
-	/* disable GPE during transaction if storm is detected */
-	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
-		/* It has to be disabled, so that it doesn't trigger. */
-		acpi_disable_gpe(NULL, ec->gpe);
-	}
 
 	status = acpi_ec_transaction_unlocked(ec, t);
 
 	/* check if we received SCI during transaction */
 	ec_check_sci_sync(ec, acpi_ec_read_status(ec));
-	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
-		msleep(1);
-		/* It is safe to enable the GPE outside of the transaction. */
-		acpi_enable_gpe(NULL, ec->gpe);
-	} else if (t->irq_count > ec_storm_threshold) {
-		pr_info("GPE storm detected(%d GPEs), "
-			"transactions will use polling mode\n",
-			t->irq_count);
-		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
-	}
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
 unlock:
@@ -500,8 +501,12 @@ static void acpi_ec_start(struct acpi_ec *ec)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ec->lock, flags);
-	if (!test_and_set_bit(EC_FLAGS_STARTED, &ec->flags))
+	if (!test_and_set_bit(EC_FLAGS_STARTED, &ec->flags)) {
+		pr_debug("+++++ Starting EC +++++\n");
+		/* Enable GPE for event processing (EVT_SCI=1) */
 		acpi_enable_gpe(NULL, ec->gpe);
+		pr_info("+++++ EC started +++++\n");
+	}
 	spin_unlock_irqrestore(&ec->lock, flags);
 }
 
@@ -512,9 +517,12 @@ static void acpi_ec_stop(struct acpi_ec *ec)
 	spin_lock_irqsave(&ec->lock, flags);
 	if (test_bit(EC_FLAGS_STARTED, &ec->flags) &&
 	    !test_and_set_bit(EC_FLAGS_STOPPED, &ec->flags)) {
+		pr_debug("+++++ Stopping EC +++++\n");
+		/* Disable GPE for event processing (EVT_SCI=1) */
 		acpi_disable_gpe(NULL, ec->gpe);
 		clear_bit(EC_FLAGS_STARTED, &ec->flags);
 		clear_bit(EC_FLAGS_STOPPED, &ec->flags);
+		pr_info("+++++ EC stopped +++++\n");
 	}
 	spin_unlock_irqrestore(&ec->lock, flags);
 }
-- 
1.7.10

