Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaGUGGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:06:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:30101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaGUGGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="459362985"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 10/14] ACPI/EC: Cleanup QR_SC command processing by adding a kernel thread to poll EC events.
Date: Mon, 21 Jul 2014 14:06:12 +0800
Message-Id: <c6280a89c21cd3adbe92a8b596cdd23dd67f3433.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is wait code in the QR_SC command processing, which makes it not
suitable to be put into a work queue item. This patch cleans up QR_SC
command processing by using an IRQ polling thread as the replacement for
the queued work item. Using thread allows us to change the EC GPE handler
into the threaded IRQ model when possible.

This poller is also useful for implementing event storm prevention. It is
reported that when the BIOS doesn't provide a _Qxx method to handle the
certain query event, the EVT_SCI interrupt can become a GPE storm hurting
the system performance (see link below, comment 55 and 80). The poller
thread thus can be used to poll EVT_SCI when storm prevention code swiches
EC driver into the polling mode.

The reasons why we do not put a loop in the event poller to poll event
until the returned query value is 0:
  Some platforms return non 0 query value even when EVT_SCI=0, if we put a
  loop in the poller, our command flush mechanism could never execute to
  an end thus the system suspending process could be blocked. One EVT_SCI
  triggering one QR_EC is current logic and has been proven to be working
  for so long time.

The reasons why it is not implemented directly using threaded IRQ are:
1. ACPICA doesn't support threaded IRQ as not all of the OSPMs support
   threaded IRQ while GPE handler registerations are done through ACPICA.
2. The IRQ processing code need to be identical for both the IRQ handler
   and the thread callback, while currently, though the command GPE
   handling is ready for both IRQ and polling mode, the event GPE is only
   handled in the polling mode.
So we use a standalone kernel thread, if the above situations are changed
in the future, we can easily convert the code into the threaded IRQ style.

The old EC_FLAGS_QUERY_PENDING is converted to EC_FLAGS_EVENT_ENABLED in
this patch, so that its naming is consistent with EC_FLAGS_EVENT_PENDING.
The original flag doesn't co-work with EVT_SCI well, this patch refines
its usage by enforcing a event polling wakeup indication as:
  EC_FLAGS_EVENT_ENABLED && EC_FLAGS_EVENT_PENDING
So unless the both of the flags are set, the threaded event poller will
not be woken up.

This patch invokes acpi_enable_gpe() after having detected EVT_SCI and
invokes acpi_disable_gpe() before having the QR_EC command processed.
This is useful for implementing GPE storm prevention for malicous "level
triggered" EVT_SCI. But the storm prevention is not implemented in this
patch.

Since the paired acpi_disable_gpe() invoked for EVT_SCI detection can only
hanppen after a QR_EC command, this patch modifies
acpi_ec_enable_gpe_flushable() to allow such QR_EC command to be proceeded
if the acpi_enable_gpe() has been invoked, which can be determined by the
event polling indication:
  EC_FLAGS_EVENT_ENABLED && EC_FLAGS_EVENT_PENDING
Without checking this reference increment for commands, QR_EC command will
not be executed to decrease the one added for EVT_SCI, thus the system
suspending will be blocked because the reference count equals to 2. Such
check is also common for flushing code.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=78091
Reported-by: Steffen Weber <steffen.weber@gmail.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c       |  195 ++++++++++++++++++++++++++++++++++-------------
 drivers/acpi/internal.h |    1 +
 2 files changed, 145 insertions(+), 51 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 065aabc..f9531ee 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -44,6 +44,7 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/dmi.h>
+#include <linux/kthread.h>
 #include <asm/io.h>
 
 #include "internal.h"
@@ -75,7 +76,8 @@ enum ec_command {
 					 * when trying to clear the EC */
 
 enum {
-	EC_FLAGS_QUERY_PENDING,		/* Query is pending */
+	EC_FLAGS_EVENT_ENABLED,		/* Event is enabled */
+	EC_FLAGS_EVENT_PENDING,		/* Event is pending */
 	EC_FLAGS_HANDLERS_INSTALLED,	/* Handlers for GPE and
 					 * OpReg are installed */
 	EC_FLAGS_STARTED,		/* Driver is started */
@@ -125,6 +127,7 @@ struct transaction {
 static struct acpi_ec_query_handler *
 acpi_ec_get_query_handler(struct acpi_ec_query_handler *handler);
 static void acpi_ec_put_query_handler(struct acpi_ec_query_handler *handler);
+static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data);
 
 struct acpi_ec *boot_ec, *first_ec;
 EXPORT_SYMBOL(first_ec);
@@ -149,6 +152,12 @@ static bool acpi_ec_has_gpe_storm(struct acpi_ec *ec)
 	return test_bit(EC_FLAGS_COMMAND_STORM, &ec->flags);
 }
 
+static bool acpi_ec_has_pending_event(struct acpi_ec *ec)
+{
+	return test_bit(EC_FLAGS_EVENT_ENABLED, &ec->flags) &&
+	       test_bit(EC_FLAGS_EVENT_PENDING, &ec->flags);
+}
+
 /* --------------------------------------------------------------------------
                              GPE Enhancement
    -------------------------------------------------------------------------- */
@@ -196,6 +205,7 @@ static void acpi_ec_disable_gpe(struct acpi_ec *ec)
 /*
  * acpi_ec_enable_gpe_flushable() - Increase the flushable GPE reference
  * @ec: the EC device
+ * @check_event: whether event flushing should be taken into accounted
  *
  * This function must be used for the references of the operations that can
  * be flushed, i.e., all references other than the first reference which is
@@ -203,14 +213,83 @@ static void acpi_ec_disable_gpe(struct acpi_ec *ec)
  * this flush safe API so that flushable operations occurred after the
  * flush will not be initiated.
  */
-static bool acpi_ec_enable_gpe_flushable(struct acpi_ec *ec)
+static bool acpi_ec_enable_gpe_flushable(struct acpi_ec *ec,
+					 bool check_event)
 {
-	if (!acpi_ec_started(ec))
-		return false;
+	if (!acpi_ec_started(ec)) {
+		if (!check_event || !acpi_ec_has_pending_event(ec))
+			return false;
+	}
 	acpi_ec_enable_gpe(ec);
 	return true;
 }
 
+static void acpi_ec_enable_event(struct acpi_ec *ec)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ec->lock, flags);
+	/* Hold GPE reference for pending event */
+	if (!acpi_ec_enable_gpe_flushable(ec, false)) {
+		spin_unlock_irqrestore(&ec->lock, flags);
+		return;
+	}
+	set_bit(EC_FLAGS_EVENT_ENABLED, &ec->flags);
+	if (test_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
+		pr_debug("***** Event pending *****\n");
+		wake_up_process(ec->thread);
+		spin_unlock_irqrestore(&ec->lock, flags);
+		return;
+	}
+	acpi_ec_disable_gpe(ec);
+	spin_unlock_irqrestore(&ec->lock, flags);
+}
+
+static void __acpi_ec_set_event(struct acpi_ec *ec)
+{
+	/* Hold GPE reference for pending event */
+	if (!acpi_ec_enable_gpe_flushable(ec, false))
+		return;
+	if (!test_and_set_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
+		pr_debug("***** Event pending *****\n");
+		if (test_bit(EC_FLAGS_EVENT_ENABLED, &ec->flags)) {
+			wake_up_process(ec->thread);
+			return;
+		}
+	}
+	acpi_ec_disable_gpe(ec);
+}
+
+static void __acpi_ec_complete_event(struct acpi_ec *ec)
+{
+	if (test_and_clear_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
+		/* Unhold GPE reference for pending event */
+		acpi_ec_disable_gpe(ec);
+		pr_debug("***** Event running *****\n");
+	}
+}
+
+int acpi_ec_wait_for_event(struct acpi_ec *ec)
+{
+	unsigned long flags;
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		spin_lock_irqsave(&ec->lock, flags);
+		if (acpi_ec_has_pending_event(ec)) {
+			spin_unlock_irqrestore(&ec->lock, flags);
+			__set_current_state(TASK_RUNNING);
+			return 0;
+		}
+		spin_unlock_irqrestore(&ec->lock, flags);
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
+
+	return -1;
+}
+
 /* --------------------------------------------------------------------------
                              Transaction Management
    -------------------------------------------------------------------------- */
@@ -312,14 +391,16 @@ static bool advance_transaction(struct acpi_ec *ec)
 			t->flags |= ACPI_EC_COMMAND_COMPLETE;
 			wakeup = true;
 		}
-		return wakeup;
+		goto out;
 	} else {
 		if ((status & ACPI_EC_FLAG_IBF) == 0) {
 			acpi_ec_write_cmd(ec, t->command);
 			t->flags |= ACPI_EC_COMMAND_POLL;
+			if (t->command == ACPI_EC_COMMAND_QUERY)
+				__acpi_ec_complete_event(ec);
 		} else
 			goto err;
-		return wakeup;
+		goto out;
 	}
 err:
 	/*
@@ -335,6 +416,11 @@ err:
 				acpi_ec_set_storm(ec, EC_FLAGS_COMMAND_STORM);
 		}
 	}
+
+out:
+	if (status & ACPI_EC_FLAG_SCI &&
+	    (!t || t->flags & ACPI_EC_COMMAND_COMPLETE))
+		__acpi_ec_set_event(ec);
 	return wakeup;
 }
 
@@ -345,17 +431,6 @@ static void start_transaction(struct acpi_ec *ec)
 	(void)advance_transaction(ec);
 }
 
-static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data);
-
-static int ec_check_sci_sync(struct acpi_ec *ec, u8 state)
-{
-	if (state & ACPI_EC_FLAG_SCI) {
-		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags))
-			return acpi_ec_sync_query(ec, NULL);
-	}
-	return 0;
-}
-
 static int ec_poll(struct acpi_ec *ec)
 {
 	unsigned long flags;
@@ -392,12 +467,14 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 {
 	unsigned long tmp;
 	int ret = 0;
+	bool is_query = !!(t->command == ACPI_EC_COMMAND_QUERY);
+
 	if (EC_FLAGS_MSI)
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
 	spin_lock_irqsave(&ec->lock, tmp);
 	/* Enable GPE for command processing (IBF=0/OBF=1) */
-	if (!acpi_ec_enable_gpe_flushable(ec)) {
+	if (!acpi_ec_enable_gpe_flushable(ec, is_query)) {
 		ret = -EINVAL;
 		goto unlock;
 	}
@@ -406,10 +483,6 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	pr_debug("***** Command(%s) started *****\n",
 		 acpi_ec_cmd_string(t->command));
 	start_transaction(ec);
-	if (ec->curr->command == ACPI_EC_COMMAND_QUERY) {
-		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
-		pr_debug("***** Event stopped *****\n");
-	}
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	ret = ec_poll(ec);
 	spin_lock_irqsave(&ec->lock, tmp);
@@ -444,8 +517,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 
 	status = acpi_ec_transaction_unlocked(ec, t);
 
-	/* check if we received SCI during transaction */
-	ec_check_sci_sync(ec, acpi_ec_read_status(ec));
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
 unlock:
@@ -789,32 +860,9 @@ static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data)
 		*data = value;
 	if (status)
 		return status;
-
 	return acpi_ec_notify_query_handlers(ec, value);
 }
 
-static void acpi_ec_gpe_query(void *ec_cxt)
-{
-	struct acpi_ec *ec = ec_cxt;
-	if (!ec)
-		return;
-	mutex_lock(&ec->mutex);
-	acpi_ec_sync_query(ec, NULL);
-	mutex_unlock(&ec->mutex);
-}
-
-static int ec_check_sci(struct acpi_ec *ec, u8 state)
-{
-	if (state & ACPI_EC_FLAG_SCI) {
-		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags)) {
-			pr_debug("***** Event started *****\n");
-			return acpi_os_execute(OSL_NOTIFY_HANDLER,
-				acpi_ec_gpe_query, ec);
-		}
-	}
-	return 0;
-}
-
 static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	u32 gpe_number, void *data)
 {
@@ -828,10 +876,47 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	if (!acpi_ec_has_gpe_storm(ec))
 		enable = ACPI_REENABLE_GPE;
 	spin_unlock_irqrestore(&ec->lock, flags);
-	ec_check_sci(ec, acpi_ec_read_status(ec));
 	return ACPI_INTERRUPT_HANDLED | enable;
 }
 
+static int acpi_ec_event_poller(void *context)
+{
+	struct acpi_ec *ec = context;
+
+	while (!acpi_ec_wait_for_event(ec)) {
+		pr_debug("***** Event poller started *****\n");
+		mutex_lock(&ec->mutex);
+		(void)acpi_ec_sync_query(ec, NULL);
+		mutex_unlock(&ec->mutex);
+		pr_debug("***** Event poller stopped *****\n");
+	}
+
+	return 0;
+}
+
+static int ec_create_event_poller(struct acpi_ec *ec)
+{
+	struct task_struct *t;
+
+	t = kthread_run(acpi_ec_event_poller, ec, "ec/gpe-%lu", ec->gpe);
+	if (IS_ERR(t)) {
+		pr_err("failed to create event poller %lu\n", ec->gpe);
+		return PTR_ERR(t);
+	}
+	get_task_struct(t);
+	ec->thread = t;
+	return 0;
+}
+
+static void ec_delete_event_poller(struct acpi_ec *ec)
+{
+	struct task_struct *t = ec->thread;
+
+	ec->thread = NULL;
+	kthread_stop(t);
+	put_task_struct(t);
+}
+
 /* --------------------------------------------------------------------------
                              Address Space Management
    -------------------------------------------------------------------------- */
@@ -888,7 +973,6 @@ static struct acpi_ec *make_acpi_ec(void)
 	struct acpi_ec *ec = kzalloc(sizeof(struct acpi_ec), GFP_KERNEL);
 	if (!ec)
 		return NULL;
-	ec->flags = 1 << EC_FLAGS_QUERY_PENDING;
 	mutex_init(&ec->mutex);
 	init_waitqueue_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
@@ -946,14 +1030,21 @@ ec_parse_device(acpi_handle handle, u32 Level, void *context, void **retval)
 
 static int ec_install_handlers(struct acpi_ec *ec)
 {
+	int ret;
 	acpi_status status;
+
 	if (test_bit(EC_FLAGS_HANDLERS_INSTALLED, &ec->flags))
 		return 0;
+	ret = ec_create_event_poller(ec);
+	if (ret)
+		return ret;
 	status = acpi_install_gpe_handler(NULL, ec->gpe,
 				  ACPI_GPE_EDGE_TRIGGERED,
 				  &acpi_ec_gpe_handler, ec);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status)) {
+		ec_delete_event_poller(ec);
 		return -ENODEV;
+	}
 
 	acpi_ec_start(ec);
 	status = acpi_install_address_space_handler(ec->handle,
@@ -973,6 +1064,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 			acpi_ec_stop(ec);
 			acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler);
+			ec_delete_event_poller(ec);
 			return -ENODEV;
 		}
 	}
@@ -990,6 +1082,7 @@ static void ec_remove_handlers(struct acpi_ec *ec)
 	if (ACPI_FAILURE(acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler)))
 		pr_err("failed to remove gpe handler\n");
+	ec_delete_event_poller(ec);
 	clear_bit(EC_FLAGS_HANDLERS_INSTALLED, &ec->flags);
 }
 
@@ -1037,7 +1130,7 @@ static int acpi_ec_add(struct acpi_device *device)
 	ret = ec_install_handlers(ec);
 
 	/* EC is fully operational, allow queries */
-	clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
+	acpi_ec_enable_event(ec);
 
 	/* Clear stale _Q events if hardware might require that */
 	if (EC_FLAGS_CLEAR_ON_RESUME) {
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 2348f9c..b2eef49 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -124,6 +124,7 @@ struct acpi_ec {
 	struct list_head list;
 	struct transaction *curr;
 	spinlock_t lock;
+	struct task_struct *thread;
 };
 
 extern struct acpi_ec *first_ec;
-- 
1.7.10

