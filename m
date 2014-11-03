Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaKCFRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:17:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:24253 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaKCFRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:17:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,305,1413270000"; 
   d="scan'208";a="625257373"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 5/6] ACPI/EC: Cleanup QR_SC command processing by adding a kernel thread to poll EC events.
Date: Mon,  3 Nov 2014 13:16:37 +0800
Message-Id: <dc1ae83c60a2b79c8ac7ed633a1519013f3ab635.1414988981.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414988981.git.lv.zheng@intel.com>
References: <cover.1414988981.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is wait code in the QR_SC command processing, which makes it not
suitable to be put into a work queue item (see bug 82611). And there is
case that the SCI_EVT cannot trigger GPE, though all commands have polling
mode implemented, the event cannot be polled (see bug 77431).

So if the QR_SC command can be put into a seperate IRQ thread, then the
work queue will not be blocked by the QR_SC command processing and we can
also trigger polling using the thread. Using IRQ thread also allows us to
change the EC GPE handler into the threaded IRQ model when possible.

This patch thus adds the IRQ polling thread for SCI_EVT polling and removes
QR_SC processing work item.

The reasons why we do not put a loop in the event poller to poll event
until the returned query value is 0:
  Some platforms return non 0 query value even when SCI_EVT=0, if we put a
  loop in the poller, our command flush mechanism could never execute to
  an end thus the system suspending process could be blocked. One SCI_EVT
  triggering one QR_EC is current logic and has been proven to be working
  for so long time.

The reasons why it is not implemented directly using threaded IRQ are:
1. ACPICA doesn't support threaded IRQ as not all of the OSPMs support
   threaded IRQ while GPE handler registerations are done through ACPICA.
2. The IRQ processing code need to be identical for both the IRQ handler
   and the thread callback, while currently, though the command GPE
   handling is ready for both IRQ and polling mode, only the event GPE is
   is polled in the event polling thread and the command is polled in the
   user threads.
So we use a standalone kernel thread, if the above situations are changed
in the future, we can easily convert the code into the threaded IRQ style.

The old EC_FLAGS_QUERY_PENDING is converted to EC_FLAGS_EVENT_ENABLED in
this patch, so that its naming is consistent with EC_FLAGS_EVENT_PENDING.
The original flag doesn't co-work with SCI_EVT well, this patch refines
its usage by enforcing a event polling wakeup indication as:
  EC_FLAGS_EVENT_ENABLED && EC_FLAGS_EVENT_PENDING
So unless the both of the flags are set, the threaded event poller will
not be woken up.

This patch invokes acpi_ec_submit_request() after having detected SCI_EVT
and invokes acpi_ec_complete_request() before having the QR_EC command
processed. This is useful for implementing GPE storm prevention for
malicous "level triggered" SCI_EVT. But the storm prevention is not
implemented in this patch.

Since the acpi_ec_submit_request() invoked after detecting the SCI_EVT is
paired with acpi_ec_complete_request() invoked after completing QR_EC
command, acpi_ec_submit_flushable_request() then need to be modified to
allow QR_EC command to be submitted during this period to revert the
increased reference count. This period can be determined by the event
polling indication:
  EC_FLAGS_EVENT_ENABLED && EC_FLAGS_EVENT_PENDING
Without enhancing this check in acpi_ec_submit_flushable_request(), QR_EC
command will not be executed to decrease the reference count added after
detecting the SCI_EVT, thus the system suspending will be blocked because
the reference count equals to 2. Such check is common for flushing code.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=82611
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=77431
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Ortwin Glück <odi@odi.ch>
---
 drivers/acpi/ec.c       |  194 ++++++++++++++++++++++++++++++++++-------------
 drivers/acpi/internal.h |    1 +
 2 files changed, 144 insertions(+), 51 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index a76794a..7089081 100644
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
 	EC_FLAGS_GPE_STORM,		/* GPE storm detected */
 	EC_FLAGS_HANDLERS_INSTALLED,	/* Handlers for GPE and
 					 * OpReg are installed */
@@ -124,6 +126,7 @@ struct transaction {
 static struct acpi_ec_query_handler *
 acpi_ec_get_query_handler(struct acpi_ec_query_handler *handler);
 static void acpi_ec_put_query_handler(struct acpi_ec_query_handler *handler);
+static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data);
 
 struct acpi_ec *boot_ec, *first_ec;
 EXPORT_SYMBOL(first_ec);
@@ -149,6 +152,12 @@ static bool acpi_ec_flushed(struct acpi_ec *ec)
 	return ec->reference_count == 1;
 }
 
+static bool acpi_ec_has_pending_event(struct acpi_ec *ec)
+{
+	return test_bit(EC_FLAGS_EVENT_ENABLED, &ec->flags) &&
+	       test_bit(EC_FLAGS_EVENT_PENDING, &ec->flags);
+}
+
 /* --------------------------------------------------------------------------
  *                           GPE Enhancement
  * -------------------------------------------------------------------------- */
@@ -177,20 +186,93 @@ static void acpi_ec_complete_request(struct acpi_ec *ec)
  *                                      the flush operation is not in
  *                                      progress
  * @ec: the EC device
+ * @check_event: check whether event is pending
  *
  * This function must be used before taking a new action that should hold
  * the reference count.  If this function returns false, then the action
  * must be discarded or it will prevent the flush operation from being
  * completed.
+ *
+ * During flushing, QR_EC command need to pass this check when there is a
+ * pending event, so that the reference count held for the pending event
+ * can be decreased by the completion of the QR_EC command.
  */
-static bool acpi_ec_submit_flushable_request(struct acpi_ec *ec)
+static bool acpi_ec_submit_flushable_request(struct acpi_ec *ec,
+					     bool check_event)
 {
-	if (!acpi_ec_started(ec))
-		return false;
+	if (!acpi_ec_started(ec)) {
+		if (!check_event || !acpi_ec_has_pending_event(ec))
+			return false;
+	}
 	acpi_ec_submit_request(ec);
 	return true;
 }
 
+static void acpi_ec_enable_event(struct acpi_ec *ec)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ec->lock, flags);
+	/* Hold reference for pending event */
+	if (!acpi_ec_submit_flushable_request(ec, false)) {
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
+	acpi_ec_complete_request(ec);
+	spin_unlock_irqrestore(&ec->lock, flags);
+}
+
+static void __acpi_ec_set_event(struct acpi_ec *ec)
+{
+	/* Hold reference for pending event */
+	if (!acpi_ec_submit_flushable_request(ec, false))
+		return;
+	if (!test_and_set_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
+		pr_debug("***** Event pending *****\n");
+		if (test_bit(EC_FLAGS_EVENT_ENABLED, &ec->flags)) {
+			wake_up_process(ec->thread);
+			return;
+		}
+	}
+	acpi_ec_complete_request(ec);
+}
+
+static void __acpi_ec_complete_event(struct acpi_ec *ec)
+{
+	if (test_and_clear_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
+		/* Unhold reference for pending event */
+		acpi_ec_complete_request(ec);
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
+	return -1;
+}
+
 /* --------------------------------------------------------------------------
  *                           Transaction Management
  * -------------------------------------------------------------------------- */
@@ -298,7 +380,7 @@ static bool advance_transaction(struct acpi_ec *ec)
 			t->flags |= ACPI_EC_COMMAND_COMPLETE;
 			wakeup = true;
 		}
-		return wakeup;
+		goto out;
 	} else {
 		if (EC_FLAGS_QUERY_HANDSHAKE &&
 		    !(status & ACPI_EC_FLAG_SCI) &&
@@ -312,9 +394,11 @@ static bool advance_transaction(struct acpi_ec *ec)
 		} else if ((status & ACPI_EC_FLAG_IBF) == 0) {
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
@@ -325,6 +409,10 @@ err:
 		if (in_interrupt() && t)
 			++t->irq_count;
 	}
+out:
+	if (status & ACPI_EC_FLAG_SCI &&
+	    (!t || t->flags & ACPI_EC_COMMAND_COMPLETE))
+		__acpi_ec_set_event(ec);
 	return wakeup;
 }
 
@@ -335,17 +423,6 @@ static void start_transaction(struct acpi_ec *ec)
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
@@ -384,12 +461,13 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	unsigned long tmp;
 	int ret = 0;
 
+	bool is_query = !!(t->command == ACPI_EC_COMMAND_QUERY);
 	if (EC_FLAGS_MSI)
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
 	spin_lock_irqsave(&ec->lock, tmp);
 	/* Enable GPE for command processing (IBF=0/OBF=1) */
-	if (!acpi_ec_submit_flushable_request(ec)) {
+	if (!acpi_ec_submit_flushable_request(ec, is_query)) {
 		ret = -EINVAL;
 		goto unlock;
 	}
@@ -398,10 +476,6 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
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
@@ -440,8 +514,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 
 	status = acpi_ec_transaction_unlocked(ec, t);
 
-	/* check if we received SCI during transaction */
-	ec_check_sci_sync(ec, acpi_ec_read_status(ec));
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
 		msleep(1);
 		/* It is safe to enable the GPE outside of the transaction. */
@@ -792,29 +864,6 @@ static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data)
 	return 0;
 }
 
-static void acpi_ec_gpe_query(void *ec_cxt)
-{
-	struct acpi_ec *ec = ec_cxt;
-
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
@@ -825,10 +874,46 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	if (advance_transaction(ec))
 		wake_up(&ec->wait);
 	spin_unlock_irqrestore(&ec->lock, flags);
-	ec_check_sci(ec, acpi_ec_read_status(ec));
 	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
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
  *                           Address Space Management
  * -------------------------------------------------------------------------- */
@@ -884,7 +969,6 @@ static struct acpi_ec *make_acpi_ec(void)
 
 	if (!ec)
 		return NULL;
-	ec->flags = 1 << EC_FLAGS_QUERY_PENDING;
 	mutex_init(&ec->mutex);
 	init_waitqueue_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
@@ -940,15 +1024,21 @@ ec_parse_device(acpi_handle handle, u32 Level, void *context, void **retval)
 
 static int ec_install_handlers(struct acpi_ec *ec)
 {
+	int ret;
 	acpi_status status;
 
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
@@ -968,6 +1058,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 			acpi_ec_stop(ec);
 			acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler);
+			ec_delete_event_poller(ec);
 			return -ENODEV;
 		}
 	}
@@ -985,6 +1076,7 @@ static void ec_remove_handlers(struct acpi_ec *ec)
 	if (ACPI_FAILURE(acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler)))
 		pr_err("failed to remove gpe handler\n");
+	ec_delete_event_poller(ec);
 	clear_bit(EC_FLAGS_HANDLERS_INSTALLED, &ec->flags);
 }
 
@@ -1032,7 +1124,7 @@ static int acpi_ec_add(struct acpi_device *device)
 	ret = ec_install_handlers(ec);
 
 	/* EC is fully operational, allow queries */
-	clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
+	acpi_ec_enable_event(ec);
 
 	/* Clear stale _Q events if hardware might require that */
 	if (EC_FLAGS_CLEAR_ON_RESUME) {
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index bbcfe0b..20a569c 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -128,6 +128,7 @@ struct acpi_ec {
 	struct list_head list;
 	struct transaction *curr;
 	spinlock_t lock;
+	struct task_struct *thread;
 };
 
 extern struct acpi_ec *first_ec;
-- 
1.7.10

