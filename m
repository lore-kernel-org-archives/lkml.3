Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbaGODPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:15:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:58391 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811AbaGODPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:15:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="569861722"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 08/10] ACPI/EC: Add command flushing support.
Date: Tue, 15 Jul 2014 11:15:14 +0800
Message-Id: <c90441f592d4bef095adab1ed2ba97a4f5de9089.1405391679.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405391678.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405391678.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements command flushing support. It's better to wait all
command transactions to be completed before disabling the EC GPE when the
system is going to be suspended. By doing so, the EC hardware can be
ensured to be in the idle state when the system is resumed.

The system suspending/resuming test result is as follows:
 [   24.950829] ACPI : EC: +++++ Stopping EC +++++
 [   24.950836] ACPI : EC: +++++ EC stopped +++++

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c       |   49 +++++++++++++++++++++++++++++++++++++++++++----
 drivers/acpi/internal.h |    1 +
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 2340ac2..936424a 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -133,6 +133,32 @@ static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
 static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
 
 /* --------------------------------------------------------------------------
+                             GPE Enhancement
+   -------------------------------------------------------------------------- */
+
+static bool acpi_ec_flushed(struct acpi_ec *ec)
+{
+	return !!(ec->reference_count == 1);
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
+/* --------------------------------------------------------------------------
                              Transaction Management
    -------------------------------------------------------------------------- */
 
@@ -325,7 +351,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	/* following two actions should be kept atomic */
 	ec->curr = t;
 	/* Enable GPE for command processing (IBF=0/OBF=1) */
-	acpi_enable_gpe(NULL, ec->gpe);
+	acpi_ec_enable_gpe(ec);
 	pr_debug("***** Command(%s) started *****\n",
 		 acpi_ec_cmd_string(t->command));
 	start_transaction(ec);
@@ -343,7 +369,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	pr_debug("***** Command(%s) stopped *****\n",
 		 acpi_ec_cmd_string(t->command));
 	/* Disable GPE for command processing (IBF=0/OBF=1) */
-	acpi_disable_gpe(NULL, ec->gpe);
+	acpi_ec_disable_gpe(ec);
 	ec->curr = NULL;
 unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
@@ -508,12 +534,24 @@ static void acpi_ec_start(struct acpi_ec *ec)
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
@@ -522,8 +560,11 @@ static void acpi_ec_stop(struct acpi_ec *ec)
 	if (test_bit(EC_FLAGS_STARTED, &ec->flags) &&
 	    !test_and_set_bit(EC_FLAGS_STOPPED, &ec->flags)) {
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

