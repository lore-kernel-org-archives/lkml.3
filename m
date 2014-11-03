Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaKCFQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:16:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:48662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaKCFQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:16:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,305,1413270000"; 
   d="scan'208";a="630109061"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 4/6] ACPI/EC: Add command flushing support.
Date: Mon,  3 Nov 2014 13:16:31 +0800
Message-Id: <b870be347086106c97239781731a805c24967e72.1414988981.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414988981.git.lv.zheng@intel.com>
References: <cover.1414988981.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements command flushing support. It's better to wait all
command transactions to be completed before disabling the EC GPE when the
system is going to be suspended. By doing so, the EC hardware can be
ensured to be in the idle state when the system is resumed.

There is a good indicator for flush support:
All acpi_ec_submit_request() is invoked after checking driver state with
acpi_ec_started() except the first one. This means all code paths can be
flushed as fast as possible by discarding the requests occurred after the
flush operation. The reference increased for such kind of code path is
wrapped by acpi_ec_submit_flushable_request().

The system suspending/resuming test result is as follows:
  ACPI : EC: +++++ Stopping EC +++++
* ACPI : EC: +++++ EC stopped +++++
  ACPI : EC: +++++ Starting EC +++++
# ACPI : EC: +++++ EC started +++++
This is performed by "switching wireless switch on/off" and "plugging power
cord in/out" frequently during the suspending/resuming. The above dmesg
shows that the EC driver is stopped during suspending (*) and is restarted
during resuming (#) correctly.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Ortwin Glück <odi@odi.ch>
---
 drivers/acpi/ec.c       |   72 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/acpi/internal.h |    1 +
 2 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 69e4f35..a76794a 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -144,6 +144,53 @@ static bool acpi_ec_started(struct acpi_ec *ec)
 	       !test_bit(EC_FLAGS_STOPPED, &ec->flags);
 }
 
+static bool acpi_ec_flushed(struct acpi_ec *ec)
+{
+	return ec->reference_count == 1;
+}
+
+/* --------------------------------------------------------------------------
+ *                           GPE Enhancement
+ * -------------------------------------------------------------------------- */
+
+static void acpi_ec_submit_request(struct acpi_ec *ec)
+{
+	ec->reference_count++;
+	if (ec->reference_count == 1)
+		acpi_enable_gpe(NULL, ec->gpe);
+}
+
+static void acpi_ec_complete_request(struct acpi_ec *ec)
+{
+	bool flushed = false;
+
+	ec->reference_count--;
+	if (ec->reference_count == 0)
+		acpi_disable_gpe(NULL, ec->gpe);
+	flushed = acpi_ec_flushed(ec);
+	if (flushed)
+		wake_up(&ec->wait);
+}
+
+/*
+ * acpi_ec_submit_flushable_request() - Increase the reference count unless
+ *                                      the flush operation is not in
+ *                                      progress
+ * @ec: the EC device
+ *
+ * This function must be used before taking a new action that should hold
+ * the reference count.  If this function returns false, then the action
+ * must be discarded or it will prevent the flush operation from being
+ * completed.
+ */
+static bool acpi_ec_submit_flushable_request(struct acpi_ec *ec)
+{
+	if (!acpi_ec_started(ec))
+		return false;
+	acpi_ec_submit_request(ec);
+	return true;
+}
+
 /* --------------------------------------------------------------------------
  *                           Transaction Management
  * -------------------------------------------------------------------------- */
@@ -341,7 +388,8 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
 	spin_lock_irqsave(&ec->lock, tmp);
-	if (!acpi_ec_started(ec)) {
+	/* Enable GPE for command processing (IBF=0/OBF=1) */
+	if (!acpi_ec_submit_flushable_request(ec)) {
 		ret = -EINVAL;
 		goto unlock;
 	}
@@ -360,6 +408,8 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	pr_debug("***** Command(%s) stopped *****\n",
 		 acpi_ec_cmd_string(t->command));
 	ec->curr = NULL;
+	/* Disable GPE for command processing (IBF=0/OBF=1) */
+	acpi_ec_complete_request(ec);
 unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	return ret;
@@ -535,12 +585,24 @@ static void acpi_ec_start(struct acpi_ec *ec)
 	spin_lock_irqsave(&ec->lock, flags);
 	if (!test_and_set_bit(EC_FLAGS_STARTED, &ec->flags)) {
 		pr_debug("+++++ Starting EC +++++\n");
-		acpi_enable_gpe(NULL, ec->gpe);
+		/* Enable GPE for event processing (SCI_EVT=1) */
+		acpi_ec_submit_request(ec);
 		pr_info("+++++ EC started +++++\n");
 	}
 	spin_unlock_irqrestore(&ec->lock, flags);
 }
 
+static bool acpi_ec_stopped(struct acpi_ec *ec)
+{
+	unsigned long flags;
+	bool flushed;
+
+	spin_lock_irqsave(&ec->lock, flags);
+	flushed = acpi_ec_flushed(ec);
+	spin_unlock_irqrestore(&ec->lock, flags);
+	return flushed;
+}
+
 static void acpi_ec_stop(struct acpi_ec *ec)
 {
 	unsigned long flags;
@@ -549,7 +611,11 @@ static void acpi_ec_stop(struct acpi_ec *ec)
 	if (acpi_ec_started(ec)) {
 		pr_debug("+++++ Stopping EC +++++\n");
 		set_bit(EC_FLAGS_STOPPED, &ec->flags);
-		acpi_disable_gpe(NULL, ec->gpe);
+		spin_unlock_irqrestore(&ec->lock, flags);
+		wait_event(ec->wait, acpi_ec_stopped(ec));
+		spin_lock_irqsave(&ec->lock, flags);
+		/* Disable GPE for event processing (SCI_EVT=1) */
+		acpi_ec_complete_request(ec);
 		clear_bit(EC_FLAGS_STARTED, &ec->flags);
 		clear_bit(EC_FLAGS_STOPPED, &ec->flags);
 		pr_info("+++++ EC stopped +++++\n");
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 163e82f..bbcfe0b 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -122,6 +122,7 @@ struct acpi_ec {
 	unsigned long data_addr;
 	unsigned long global_lock;
 	unsigned long flags;
+	unsigned long reference_count;
 	struct mutex mutex;
 	wait_queue_head_t wait;
 	struct list_head list;
-- 
1.7.10

