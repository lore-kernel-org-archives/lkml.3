Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaGUGGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:06:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:30036 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaGUGGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="459362777"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 06/14] ACPI/EC: Add command flushing support.
Date: Mon, 21 Jul 2014 14:05:41 +0800
Message-Id: <2feb27aa7415c15090c50c6877ae2ba288af3efa.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements command flushing support. It's better to wait all
command transactions to be completed before disabling the EC GPE when the
system is going to be suspended. By doing so, the EC hardware can be
ensured to be in the idle state when the system is resumed.

There is a good indicator for flush support:
All acpi_ec_enable_gpe() is invoked after checking driver state with
acpi_ec_started() except the first one. This means all code paths can be
flushed as fast as possible by discarding the requests occurred after the
flush operation. This kind of GPE enabling is wrapped by
acpi_ec_enable_gpe_flushable().

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
---
 drivers/acpi/ec.c       |   66 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/acpi/internal.h |    1 +
 2 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 8195cd6..c8d205c 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -171,6 +171,46 @@ static void acpi_ec_clear_storm(struct acpi_ec *ec, u8 flag)
 	}
 }
 
+static bool acpi_ec_flushed(struct acpi_ec *ec)
+{
+	return ec->reference_count == 1;
+}
+
+static void acpi_ec_enable_gpe(struct acpi_ec *ec)
+{
+	acpi_enable_gpe(NULL, ec->gpe);
+	ec->reference_count++;
+}
+
+static void acpi_ec_disable_gpe(struct acpi_ec *ec)
+{
+	bool flushed = false;
+
+	ec->reference_count--;
+	acpi_disable_gpe(NULL, ec->gpe);
+	flushed = acpi_ec_flushed(ec);
+	if (flushed)
+		wake_up(&ec->wait);
+}
+
+/*
+ * acpi_ec_enable_gpe_flushable() - Increase the flushable GPE reference
+ * @ec: the EC device
+ *
+ * This function must be used for the references of the operations that can
+ * be flushed, i.e., all references other than the first reference which is
+ * is reversely decreased after the flush operation must be increased using
+ * this flush safe API so that flushable operations occurred after the
+ * flush will not be initiated.
+ */
+static bool acpi_ec_enable_gpe_flushable(struct acpi_ec *ec)
+{
+	if (!acpi_ec_started(ec))
+		return false;
+	acpi_ec_enable_gpe(ec);
+	return true;
+}
+
 /* --------------------------------------------------------------------------
                              Transaction Management
    -------------------------------------------------------------------------- */
@@ -355,12 +395,11 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
 	spin_lock_irqsave(&ec->lock, tmp);
-	if (!acpi_ec_started(ec)) {
+	/* Enable GPE for command processing (IBF=0/OBF=1) */
+	if (!acpi_ec_enable_gpe_flushable(ec)) {
 		ret = -EINVAL;
 		goto unlock;
 	}
-	/* Enable GPE for command processing (IBF=0/OBF=1) */
-	acpi_enable_gpe(NULL, ec->gpe);
 	/* following two actions should be kept atomic */
 	ec->curr = t;
 	pr_debug("***** Command(%s) started *****\n",
@@ -377,7 +416,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 		 acpi_ec_cmd_string(t->command));
 	ec->curr = NULL;
 	/* Disable GPE for command processing (IBF=0/OBF=1) */
-	acpi_disable_gpe(NULL, ec->gpe);
+	acpi_ec_disable_gpe(ec);
 unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	return ret;
@@ -541,12 +580,24 @@ static void acpi_ec_start(struct acpi_ec *ec)
 	if (!test_and_set_bit(EC_FLAGS_STARTED, &ec->flags)) {
 		pr_debug("+++++ Starting EC +++++\n");
 		/* Enable GPE for event processing (EVT_SCI=1) */
-		acpi_enable_gpe(NULL, ec->gpe);
+		acpi_ec_enable_gpe(ec);
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
+
+	return flushed;
+}
+
 static void acpi_ec_stop(struct acpi_ec *ec)
 {
 	unsigned long flags;
@@ -554,8 +605,11 @@ static void acpi_ec_stop(struct acpi_ec *ec)
 	spin_lock_irqsave(&ec->lock, flags);
 	if (acpi_ec_started(ec)) {
 		pr_debug("+++++ Stopping EC +++++\n");
+		spin_unlock_irqrestore(&ec->lock, flags);
+		wait_event(ec->wait, acpi_ec_stopped(ec));
+		spin_lock_irqsave(&ec->lock, flags);
 		/* Disable GPE for event processing (EVT_SCI=1) */
-		acpi_disable_gpe(NULL, ec->gpe);
+		acpi_ec_disable_gpe(ec);
 		clear_bit(EC_FLAGS_STARTED, &ec->flags);
 		clear_bit(EC_FLAGS_STOPPED, &ec->flags);
 		pr_info("+++++ EC stopped +++++\n");
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 151f3e7..2348f9c 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -118,6 +118,7 @@ struct acpi_ec {
 	unsigned long data_addr;
 	unsigned long global_lock;
 	unsigned long flags;
+	unsigned long reference_count;
 	struct mutex mutex;
 	wait_queue_head_t wait;
 	struct list_head list;
-- 
1.7.10

