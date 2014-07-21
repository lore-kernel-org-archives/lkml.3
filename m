Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaGUGGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:06:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:50982 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbaGUGGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="564767265"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 12/14] ACPI/EC: Add GPE reference counting debugging messages.
Date: Mon, 21 Jul 2014 14:06:29 +0800
Message-Id: <cac788d713494aeb27c628eeda47b4c66d49e133.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
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
index 2a1eb2a..c2e276f 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -31,6 +31,7 @@
 
 /* Uncomment next line to get verbose printout */
 /* #define DEBUG */
+#define DEBUG_REF 0
 #define pr_fmt(fmt) "ACPI : EC: " fmt
 
 #include <linux/kernel.h>
@@ -92,6 +93,13 @@ enum {
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
@@ -242,6 +250,7 @@ static void acpi_ec_enable_event(struct acpi_ec *ec)
 		spin_unlock_irqrestore(&ec->lock, flags);
 		return;
 	}
+	ec_debug_ref(ec, "Increase poller(enable)\n");
 	set_bit(EC_FLAGS_EVENT_ENABLED, &ec->flags);
 	if (test_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
 		pr_debug("***** Event pending *****\n");
@@ -250,6 +259,7 @@ static void acpi_ec_enable_event(struct acpi_ec *ec)
 		return;
 	}
 	acpi_ec_disable_gpe(ec);
+	ec_debug_ref(ec, "Decrease poller(enable)\n");
 	spin_unlock_irqrestore(&ec->lock, flags);
 }
 
@@ -258,6 +268,7 @@ static void __acpi_ec_set_event(struct acpi_ec *ec)
 	/* Hold GPE reference for pending event */
 	if (!acpi_ec_enable_gpe_flushable(ec, false))
 		return;
+	ec_debug_ref(ec, "Increase poller(set)\n");
 	if (!test_and_set_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
 		pr_debug("***** Event pending *****\n");
 		if (test_bit(EC_FLAGS_EVENT_ENABLED, &ec->flags)) {
@@ -266,6 +277,7 @@ static void __acpi_ec_set_event(struct acpi_ec *ec)
 		}
 	}
 	acpi_ec_disable_gpe(ec);
+	ec_debug_ref(ec, "Decrease poller(set)\n");
 }
 
 static void __acpi_ec_complete_event(struct acpi_ec *ec)
@@ -273,6 +285,7 @@ static void __acpi_ec_complete_event(struct acpi_ec *ec)
 	if (test_and_clear_bit(EC_FLAGS_EVENT_PENDING, &ec->flags)) {
 		/* Unhold GPE reference for pending event */
 		acpi_ec_disable_gpe(ec);
+		ec_debug_ref(ec, "Decrease poller\n");
 		pr_debug("***** Event running *****\n");
 	}
 }
@@ -493,6 +506,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 		ret = -EINVAL;
 		goto unlock;
 	}
+	ec_debug_ref(ec, "Increase command\n");
 	/* following two actions should be kept atomic */
 	ec->curr = t;
 	pr_debug("***** Command(%s) started *****\n",
@@ -508,6 +522,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	ec->curr = NULL;
 	/* Disable GPE for command processing (IBF=0/OBF=1) */
 	acpi_ec_disable_gpe(ec);
+	ec_debug_ref(ec, "Decrease command\n");
 unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	return ret;
@@ -670,6 +685,7 @@ static void acpi_ec_start(struct acpi_ec *ec)
 		pr_debug("+++++ Starting EC +++++\n");
 		/* Enable GPE for event processing (EVT_SCI=1) */
 		acpi_ec_enable_gpe(ec);
+		ec_debug_ref(ec, "Increase event\n");
 		pr_info("+++++ EC started +++++\n");
 	}
 	spin_unlock_irqrestore(&ec->lock, flags);
@@ -701,6 +717,7 @@ static void acpi_ec_stop(struct acpi_ec *ec)
 		acpi_ec_clear_storm(ec, EC_FLAGS_EVENT_STORM);
 		/* Disable GPE for event processing (EVT_SCI=1) */
 		acpi_ec_disable_gpe(ec);
+		ec_debug_ref(ec, "Decrease event\n");
 		clear_bit(EC_FLAGS_STARTED, &ec->flags);
 		clear_bit(EC_FLAGS_STOPPED, &ec->flags);
 		pr_info("+++++ EC stopped +++++\n");
-- 
1.7.10

