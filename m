Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaGUGFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:05:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:50912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaGUGFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:05:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="564766945"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 03/14] ACPI/EC: Cleanup command storm prevention using the new GPE handling model.
Date: Mon, 21 Jul 2014 14:05:17 +0800
Message-Id: <7bb1c9caec6364ee2b5b8676cbfc8de6f435f3dd.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
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

For the EC driver, GPE must be disabled for the following storms:
1. Command errors:
   If there are too many IRQs coming during a command processing period and
   such IRQs are not related to the event (EVT_SCI),
   acpi_set_gpe(ACPI_GPE_DISABLE) is invoked to prevent further storms
   during the same command transaction. This is not implemented in a good
   style. Currently once command storming is detected, it is enabled for
   all follow-up commands. Ideally, we should only enable storm prevention
   for the current command so that the next command can try the efficient
   interrupt mode again.
   This patch doesn't change current logic, the correction will be
   implemented by further patches.
2. Event errors:
   There are cases that BIOS doesn't provide a _Qxx method for the returned
   xx query value, in this case, acpi_set_gpe(ACPI_GPE_DISABLE) need to be
   invoked to prevent event IRQ storms.
   This patch doesn't implement this logic, such gap will be implemented by
   further patches.
3. Pending events:
   Though GPE is edge triggered, the underlying firmware may maliciously
   trigger GPE when IRQ is indicated. This makes EC GPE more like a level
   triggered interrupt. In case of event (EVT_SCI), since the Linux EC
   driver responses it (using QR_EC command) in the task context with GPE
   enabled, there are chances for a GPE storm to occur before QR_EC is
   executed.
   If we still want to keep the task context responding logic, for such EC
   hardware/firmware, acpi_set_gpe(ACPI_GPE_DISABLE) should be invoked
   after EVT_SCI interrupt is indicated and acpi_set_gpe(ACPI_GPE_ENABLE)
   should be invoked before the first step of QR_EC has taken place.
   This patch doesn't implement this logic, such gap can be implemented by
   future patches.

The acpi_set_gpe() should be invoked for an outstanding command,
which means it should be invoked inside of a pair of acpi_enable_gpe()/
acpi_disable_gpe() invocation. This patch thus also moves the storm
prevention logic into acpi_ec_transaction_unlocked(). Note that in order to
make it working, ACPI_REENABLE_GPE should be unset when the storming is
indicated.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 54bebbb..4c7a81b 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -321,19 +321,35 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 		ret = -EINVAL;
 		goto unlock;
 	}
+	/* Enable GPE for command processing (IBF=0/OBF=1) */
+	acpi_enable_gpe(NULL, ec->gpe);
 	/* following two actions should be kept atomic */
 	ec->curr = t;
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
 	ec->curr = NULL;
+	/* Disable GPE for command processing (IBF=0/OBF=1) */
+	acpi_disable_gpe(NULL, ec->gpe);
 unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	return ret;
@@ -355,26 +371,11 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
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
@@ -509,8 +510,12 @@ static void acpi_ec_start(struct acpi_ec *ec)
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
 
@@ -520,9 +525,12 @@ static void acpi_ec_stop(struct acpi_ec *ec)
 
 	spin_lock_irqsave(&ec->lock, flags);
 	if (acpi_ec_started(ec)) {
+		pr_debug("+++++ Stopping EC +++++\n");
+		/* Disable GPE for event processing (EVT_SCI=1) */
 		acpi_disable_gpe(NULL, ec->gpe);
 		clear_bit(EC_FLAGS_STARTED, &ec->flags);
 		clear_bit(EC_FLAGS_STOPPED, &ec->flags);
+		pr_info("+++++ EC stopped +++++\n");
 	}
 	spin_unlock_irqrestore(&ec->lock, flags);
 }
@@ -699,13 +707,16 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 {
 	unsigned long flags;
 	struct acpi_ec *ec = data;
+	u32 enable = 0;
 
 	spin_lock_irqsave(&ec->lock, flags);
 	if (advance_transaction(ec))
 		wake_up(&ec->wait);
+	if (!test_bit(EC_FLAGS_GPE_STORM, &ec->flags))
+		enable = ACPI_REENABLE_GPE;
 	spin_unlock_irqrestore(&ec->lock, flags);
 	ec_check_sci(ec, acpi_ec_read_status(ec));
-	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
+	return ACPI_INTERRUPT_HANDLED | enable;
 }
 
 /* --------------------------------------------------------------------------
-- 
1.7.10

