Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaKCFQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:16:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:27233 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaKCFQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:16:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,305,1413270000"; 
   d="scan'208";a="600877330"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 6/6] ACPI/EC: Add GPE reference counting debugging messages.
Date: Mon,  3 Nov 2014 13:16:43 +0800
Message-Id: <be7d8548073a305da9f2e995f372783584c85a60.1414988981.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414988981.git.lv.zheng@intel.com>
References: <cover.1414988981.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances debugging with the GPE reference count messages added.
No functional changes.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 7089081..5ac189b 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -31,6 +31,7 @@
 
 /* Uncomment next line to get verbose printout */
 /* #define DEBUG */
+#define DEBUG_REF 0
 #define pr_fmt(fmt) "ACPI : EC: " fmt
 
 #include <linux/kernel.h>
@@ -88,6 +89,13 @@ enum {
 #define ACPI_EC_COMMAND_POLL		0x01 /* Available for command byte */
 #define ACPI_EC_COMMAND_COMPLETE	0x02 /* Completed last byte */
 
+#define ec_debug_ref(ec, fmt, ...)					\
+	do {								\
+		if (DEBUG_REF)						\
+			pr_debug("%lu: " fmt, ec->reference_count,	\
+				 ## __VA_ARGS__);			\
+	} while (0)
+
 /* ec.c is compiled in acpi namespace so this shows up as acpi.ec_delay param */
 static unsigned int ec_delay __read_mostly = ACPI_EC_DELAY;
 module_param(ec_delay, uint, 0644);
@@ -218,6 +226,7 @@ static void acpi_ec_enable_event(struct acpi_ec *ec)
 		spin_unlock_irqrestore(&ec->lock, flags);
 		return;
 	}
+	ec_debug_ref(ec, "Increase poller(enable)\n");
 	set_bit(EC_FLAGS_EVENT_ENABLED, &ec->flags);
 	if (test_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
 		pr_debug("***** Event pending *****\n");
@@ -226,6 +235,7 @@ static void acpi_ec_enable_event(struct acpi_ec *ec)
 		return;
 	}
 	acpi_ec_complete_request(ec);
+	ec_debug_ref(ec, "Decrease poller(enable)\n");
 	spin_unlock_irqrestore(&ec->lock, flags);
 }
 
@@ -234,6 +244,7 @@ static void __acpi_ec_set_event(struct acpi_ec *ec)
 	/* Hold reference for pending event */
 	if (!acpi_ec_submit_flushable_request(ec, false))
 		return;
+	ec_debug_ref(ec, "Increase poller(set)\n");
 	if (!test_and_set_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
 		pr_debug("***** Event pending *****\n");
 		if (test_bit(EC_FLAGS_EVENT_ENABLED, &ec->flags)) {
@@ -242,6 +253,7 @@ static void __acpi_ec_set_event(struct acpi_ec *ec)
 		}
 	}
 	acpi_ec_complete_request(ec);
+	ec_debug_ref(ec, "Decrease poller(set)\n");
 }
 
 static void __acpi_ec_complete_event(struct acpi_ec *ec)
@@ -249,6 +261,7 @@ static void __acpi_ec_complete_event(struct acpi_ec *ec)
 	if (test_and_clear_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
 		/* Unhold reference for pending event */
 		acpi_ec_complete_request(ec);
+		ec_debug_ref(ec, "Decrease poller\n");
 		pr_debug("***** Event running *****\n");
 	}
 }
@@ -471,6 +484,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 		ret = -EINVAL;
 		goto unlock;
 	}
+	ec_debug_ref(ec, "Increase command\n");
 	/* following two actions should be kept atomic */
 	ec->curr = t;
 	pr_debug("***** Command(%s) started *****\n",
@@ -484,6 +498,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	ec->curr = NULL;
 	/* Disable GPE for command processing (IBF=0/OBF=1) */
 	acpi_ec_complete_request(ec);
+	ec_debug_ref(ec, "Decrease command\n");
 unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	return ret;
@@ -659,6 +674,7 @@ static void acpi_ec_start(struct acpi_ec *ec)
 		pr_debug("+++++ Starting EC +++++\n");
 		/* Enable GPE for event processing (SCI_EVT=1) */
 		acpi_ec_submit_request(ec);
+		ec_debug_ref(ec, "Increase event\n");
 		pr_info("+++++ EC started +++++\n");
 	}
 	spin_unlock_irqrestore(&ec->lock, flags);
@@ -688,6 +704,7 @@ static void acpi_ec_stop(struct acpi_ec *ec)
 		spin_lock_irqsave(&ec->lock, flags);
 		/* Disable GPE for event processing (SCI_EVT=1) */
 		acpi_ec_complete_request(ec);
+		ec_debug_ref(ec, "Decrease event\n");
 		clear_bit(EC_FLAGS_STARTED, &ec->flags);
 		clear_bit(EC_FLAGS_STOPPED, &ec->flags);
 		pr_info("+++++ EC stopped +++++\n");
-- 
1.7.10

