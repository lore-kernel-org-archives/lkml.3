Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaGUGGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:06:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:54929 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbaGUGG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="546450026"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 11/14] ACPI/EC: Add event storm prevention support.
Date: Mon, 21 Jul 2014 14:06:19 +0800
Message-Id: <9269feb4d4a08b00657ed80e5225aba17b6f5c40.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases that BIOS doesn't provide a _Qxx method for the returned
xx query value, in this case, acpi_set_gpe(ACPI_GPE_DISABLE) need to be
invoked to prevent event IRQ storms. See comment 55 and 80 in the bug link
below.

This patch implements such storm prevention using new GPE APIs.

By always enabling EC event storm prevention, we can perform a unit test,
the test shows that:
1. When EC_FLAGS_EVENT_STORM is indicated, all transactions are handled in
   the task context:
   # ACPI : EC: ===== TASK =====
     ACPI : EC: EC_SC(R) = 0x01 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=1
     ACPI : EC: EC_DATA(R) = 0x66
     ACPI : EC: ***** Command(QR_EC) stopped *****
     ACPI : EC: ##### Query(0x66) scheduled #####
     ACPI : EC: ##### Query(0x66) started #####
     ACPI : EC: ***** Command(RD_EC) started *****
   * ACPI : EC: ===== TASK =====
     ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
     ACPI : EC: EC_SC(W) = 0x80
     ACPI : EC: ===== TASK =====
   * ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
     ACPI : EC: EC_DATA(W) = 0x07
   * ACPI : EC: ===== TASK =====
     ACPI : EC: EC_SC(R) = 0x01 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=1
     ACPI : EC: EC_DATA(R) = 0x88
     ACPI : EC: ***** Command(RD_EC) stopped *****
   When the event storm prevention is enabled, EVT_SCI is polled in the
   task context (#), and the further commands are also handled using the
   polling mode (*) before the storming has been recovered.
2. The event poller thread will poll EVT_SCI every 5 minutes:
   [   35.233628] ACPI : EC: ***** Event poller started *****
   [   40.241432] ACPI : EC: ***** Event poller started *****
   [   45.249182] ACPI : EC: ***** Event poller started *****
   [   50.257009] ACPI : EC: ***** Event poller started *****
   [   55.264782] ACPI : EC: ***** Event poller started *****
   So the timeout facility is functioning correctly.
3. System suspend/resume test is also passed.

Note that this storm is *VERY RARE*, and we even:
1. add a threshold to prevent the event storm prevention from being false
   triggered,
2. allow recovery from first non-false query value.
So this patch doesn't affect the normal EC driver behaviors, all EC
transactions are still handled in the IRQ mode and the storming situation
can be easily recovered if the firmware doesn't maliciously trigger such
storms.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=78091
Reported-by: Steffen Weber <steffen.weber@gmail.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c       |   45 ++++++++++++++++++++++++++++++++++++++-------
 drivers/acpi/internal.h |    1 +
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index f9531ee..2a1eb2a 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -74,6 +74,7 @@ enum ec_command {
 #define ACPI_EC_MSI_UDELAY	550	/* Wait 550us for MSI EC */
 #define ACPI_EC_CLEAR_MAX	100	/* Maximum number of events to query
 					 * when trying to clear the EC */
+#define ACPI_EC_POLL_TIMEOUT	5000	/* Polling event every 5000ms */
 
 enum {
 	EC_FLAGS_EVENT_ENABLED,		/* Event is enabled */
@@ -84,6 +85,8 @@ enum {
 	EC_FLAGS_STOPPED,		/* Driver is stopped */
 	EC_FLAGS_COMMAND_STORM,		/* GPE storms occurred to the
 					 * current command processing */
+	EC_FLAGS_EVENT_STORM,		/* GPE storms occurred to the
+					 * current event processing */
 };
 
 #define ACPI_EC_COMMAND_POLL		0x01 /* Available for command byte */
@@ -149,7 +152,8 @@ static bool acpi_ec_started(struct acpi_ec *ec)
 
 static bool acpi_ec_has_gpe_storm(struct acpi_ec *ec)
 {
-	return test_bit(EC_FLAGS_COMMAND_STORM, &ec->flags);
+	return test_bit(EC_FLAGS_COMMAND_STORM, &ec->flags) ||
+	       test_bit(EC_FLAGS_EVENT_STORM, &ec->flags);
 }
 
 static bool acpi_ec_has_pending_event(struct acpi_ec *ec)
@@ -165,8 +169,10 @@ static bool acpi_ec_has_pending_event(struct acpi_ec *ec)
 static void acpi_ec_set_storm(struct acpi_ec *ec, u8 flag)
 {
 	if (!test_bit(flag, &ec->flags)) {
-		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_DISABLE);
-		pr_debug("+++++ Polling enabled +++++\n");
+		if (!acpi_ec_has_gpe_storm(ec)) {
+			acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_DISABLE);
+			pr_debug("+++++ Polling enabled +++++\n");
+		}
 		set_bit(flag, &ec->flags);
 	}
 }
@@ -175,8 +181,10 @@ static void acpi_ec_clear_storm(struct acpi_ec *ec, u8 flag)
 {
 	if (test_bit(flag, &ec->flags)) {
 		clear_bit(flag, &ec->flags);
-		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_ENABLE);
-		pr_debug("+++++ Polling disabled +++++\n");
+		if (!acpi_ec_has_gpe_storm(ec)) {
+			acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_ENABLE);
+			pr_debug("+++++ Polling disabled +++++\n");
+		}
 	}
 }
 
@@ -272,18 +280,25 @@ static void __acpi_ec_complete_event(struct acpi_ec *ec)
 int acpi_ec_wait_for_event(struct acpi_ec *ec)
 {
 	unsigned long flags;
+	signed long timeout;
+	int storming;
 
 	set_current_state(TASK_INTERRUPTIBLE);
+	timeout = msecs_to_jiffies(ACPI_EC_POLL_TIMEOUT);
 	while (!kthread_should_stop()) {
 		spin_lock_irqsave(&ec->lock, flags);
-		if (acpi_ec_has_pending_event(ec)) {
+		storming = test_bit(EC_FLAGS_EVENT_STORM, &ec->flags);
+		if (acpi_ec_has_pending_event(ec) ||
+		    (storming && !timeout)) {
 			spin_unlock_irqrestore(&ec->lock, flags);
 			__set_current_state(TASK_RUNNING);
 			return 0;
 		}
 		spin_unlock_irqrestore(&ec->lock, flags);
-		schedule();
+		timeout = schedule_timeout(timeout);
 		set_current_state(TASK_INTERRUPTIBLE);
+		if (!storming)
+			timeout = msecs_to_jiffies(ACPI_EC_POLL_TIMEOUT);
 	}
 	__set_current_state(TASK_RUNNING);
 
@@ -682,6 +697,8 @@ static void acpi_ec_stop(struct acpi_ec *ec)
 		spin_unlock_irqrestore(&ec->lock, flags);
 		wait_event(ec->wait, acpi_ec_stopped(ec));
 		spin_lock_irqsave(&ec->lock, flags);
+		/* Event storm may still be indicated */
+		acpi_ec_clear_storm(ec, EC_FLAGS_EVENT_STORM);
 		/* Disable GPE for event processing (EVT_SCI=1) */
 		acpi_ec_disable_gpe(ec);
 		clear_bit(EC_FLAGS_STARTED, &ec->flags);
@@ -833,10 +850,17 @@ static void acpi_ec_run(void *cxt)
 
 static int acpi_ec_notify_query_handlers(struct acpi_ec *ec, u8 query_bit)
 {
+	unsigned long flags;
 	struct acpi_ec_query_handler *handler;
 
 	list_for_each_entry(handler, &ec->list, node) {
 		if (query_bit == handler->query_bit) {
+			spin_lock_irqsave(&ec->lock, flags);
+			if (ec->event_count == ec_storm_threshold) {
+				acpi_ec_clear_storm(ec, EC_FLAGS_EVENT_STORM);
+				ec->event_count = 0;
+			}
+			spin_unlock_irqrestore(&ec->lock, flags);
 			/* have custom handler for this bit */
 			handler = acpi_ec_get_query_handler(handler);
 			pr_debug("##### Query(0x%02x) scheduled #####\n",
@@ -847,6 +871,13 @@ static int acpi_ec_notify_query_handlers(struct acpi_ec *ec, u8 query_bit)
 		}
 	}
 	pr_warn_once("BIOS bug: no handler for query (0x%02x)\n", query_bit);
+	spin_lock_irqsave(&ec->lock, flags);
+	if (ec->event_count < ec_storm_threshold)
+		++ec->event_count;
+	/* Allow triggering on 0 threshold */
+	if (ec->event_count == ec_storm_threshold)
+		acpi_ec_set_storm(ec, EC_FLAGS_EVENT_STORM);
+	spin_unlock_irqrestore(&ec->lock, flags);
 	return 0;
 }
 
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index b2eef49..e72ae6a 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -125,6 +125,7 @@ struct acpi_ec {
 	struct transaction *curr;
 	spinlock_t lock;
 	struct task_struct *thread;
+	unsigned long event_count;
 };
 
 extern struct acpi_ec *first_ec;
-- 
1.7.10

