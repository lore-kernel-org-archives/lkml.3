Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964886AbaFRDSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:18:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:52976 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933509AbaFRDSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:18:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,498,1400050800"; 
   d="scan'208";a="446823576"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 8/9] ACPI/EC: Deploy the new GPE handling model.
Date: Wed, 18 Jun 2014 11:18:10 +0800
Message-Id: <dfebf4e33fb5a92fe0fc3b0168b4ef4748c24c61.1403060601.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1403060601.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deploys the following GPE handling model:
1. acpi_enable_gpe()/acpi_disable_gpe():
     This set of APIs are used for EC usage reference counting.
2. acpi_set_gpe(ACPI_GPE_ENABLE)/acpi_set_gpe(ACPI_GPE_DISABLE):
     This set of APIs are used for preventing GPE storm.

For the EC driver, GPE is enabled for the following users:
1. Event monitoring: If we want to query events, acpi_enable_gpe() is
                     invoked to allow EVT_SCI.
2. Command processing: when we receive an upper layer command submission,
                       acpi_enable_gpe() is invoked to allow IBF=0,OBF=1
                       IRQs.
Comments are updated to reflect this model.

For the EC driver, GPE is disabled for the following storms:
1. Command errors: If there are too many IRQs coming during a command
                   processing period and such IRQs are not related to the
                   event (EVT_SCI), acpi_set_gpe(ACPI_GPE_DISABLE) is
                   invoked to prevent further storms during the same
                   command transaction. This is not implemented in a good
                   style. Ideally, we should only enable storm prevention
                   for the current command so that the next command can try
                   the efficient interrupt mode again. This patch doesn't
                   change this much, but introduces a slight modification
                   to clear the storm flag after completing the current
                   command polling process.
2. Event errors: Note currently we haven't implemented the storm prevention
                 for EVT_SCI.

The acpi_set_gpe() should be invoked for an outstanding command,
which means it should be invoked inside of a pair of acpi_enable_gpe()/
acpi_disable_gpe() invocation. This patch thus also moves the storm
prevention logic into acpi_ec_transaction_unlocked().

With the new facility, we are able to flush outstanding commands by waiting
for the GPE to be disabled after we have stopped monitoring the EC events.
The GPE APIs are safe to be invoked with holding the driver's spin lock
which is shared with the GPE handler. Thus this patch invokes
acpi_enable_gpe()/acpi_disable_gpe() within the EC state protection lock so
that the GPE usage changes becomes a part of the EC driver state changes.

The system suspending/resuming test result is as follows:
 [   24.950829] ACPI : EC: +++++ Stopping EC +++++
 [   24.950836] ACPI : EC: +++++ EC stopped +++++

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   82 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 4799ea0..92058a1 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -129,6 +129,29 @@ static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
 static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
 
 /* --------------------------------------------------------------------------
+                             GPE Enhancement
+   -------------------------------------------------------------------------- */
+
+static bool acpi_gpe_disabled(acpi_handle handle, u32 gpe_number)
+{
+	acpi_event_status event_status = 0;
+
+	(void)acpi_get_gpe_status(NULL, gpe_number, &event_status);
+	return !(event_status & ACPI_EVENT_FLAG_ENABLED);
+}
+
+static bool acpi_ec_disable_gpe(struct acpi_ec *ec)
+{
+	bool disabled;
+
+	acpi_disable_gpe(NULL, ec->gpe);
+	disabled = acpi_gpe_disabled(NULL, ec->gpe);
+	if (disabled)
+		wake_up(&ec->wait);
+	return disabled;
+}
+
+/* --------------------------------------------------------------------------
                              Transaction Management
    -------------------------------------------------------------------------- */
 
@@ -314,16 +337,33 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
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
+		clear_bit(EC_FLAGS_GPE_STORM, &ec->flags);
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
+	acpi_ec_disable_gpe(ec);
 	ec->curr = NULL;
 unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
@@ -346,26 +386,11 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
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
@@ -500,9 +525,25 @@ static void acpi_ec_start(struct acpi_ec *ec)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ec->lock, flags);
-	if (!test_and_set_bit(EC_FLAGS_STARTED, &ec->flags))
+	if (!test_and_set_bit(EC_FLAGS_STARTED, &ec->flags)) {
+		pr_debug("+++++ Starting EC +++++\n");
+		/* Enable GPE for event processing (EVT_SCI=1) */
 		acpi_enable_gpe(NULL, ec->gpe);
+		pr_info("+++++ EC started +++++\n");
+	}
+	spin_unlock_irqrestore(&ec->lock, flags);
+}
+
+static bool acpi_ec_stopped(struct acpi_ec *ec)
+{
+	unsigned long flags;
+	bool disabled = false;
+
+	spin_lock_irqsave(&ec->lock, flags);
+	disabled = acpi_gpe_disabled(NULL, ec->gpe);
 	spin_unlock_irqrestore(&ec->lock, flags);
+
+	return disabled;
 }
 
 static void acpi_ec_stop(struct acpi_ec *ec)
@@ -512,9 +553,16 @@ static void acpi_ec_stop(struct acpi_ec *ec)
 	spin_lock_irqsave(&ec->lock, flags);
 	if (test_bit(EC_FLAGS_STARTED, &ec->flags) &&
 	    !test_and_set_bit(EC_FLAGS_STOPPED, &ec->flags)) {
-		acpi_disable_gpe(NULL, ec->gpe);
+		pr_debug("+++++ Stopping EC +++++\n");
+		/* Disable GPE for event processing (EVT_SCI=1) */
+		if (!acpi_ec_disable_gpe(ec)) {
+			spin_unlock_irqrestore(&ec->lock, flags);
+			wait_event(ec->wait, acpi_ec_stopped(ec));
+			spin_lock_irqsave(&ec->lock, flags);
+		}
 		clear_bit(EC_FLAGS_STARTED, &ec->flags);
 		clear_bit(EC_FLAGS_STOPPED, &ec->flags);
+		pr_info("+++++ EC stopped +++++\n");
 	}
 	spin_unlock_irqrestore(&ec->lock, flags);
 }
-- 
1.7.10

