Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964970AbaFRDS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:18:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:56052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964909AbaFRDSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:18:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,498,1400050800"; 
   d="scan'208";a="549554093"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 9/9] ACPI/EC: Add unit test support for EC driver hotplug.
Date: Wed, 18 Jun 2014 11:18:16 +0800
Message-Id: <9f52bc9b2ea001e14e53038d27b45008af351cd7.1403060601.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1403060601.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds facility to test future EC modification.
All EC commits should enable TEST_HOTPLUG, and try a build/boot test.
Since EC is currently a built-in module, this is the only mean for us to
test the hotplug code.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 92058a1..c5d0797 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -31,6 +31,7 @@
 
 /* Uncomment next line to get verbose printout */
 /* #define DEBUG */
+/* #define TEST_HOTPLUG */
 #define pr_fmt(fmt) "ACPI : EC: " fmt
 
 #include <linux/kernel.h>
@@ -120,6 +121,9 @@ struct transaction {
 	u8 flags;
 };
 
+static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
+			       u32 gpe_number, void *data);
+
 struct acpi_ec *boot_ec, *first_ec;
 EXPORT_SYMBOL(first_ec);
 
@@ -720,6 +724,21 @@ static void acpi_ec_gpe_query(void *ec_cxt)
 	mutex_lock(&ec->mutex);
 	acpi_ec_sync_query(ec, NULL);
 	mutex_unlock(&ec->mutex);
+
+#ifdef TEST_HOTPLUG
+
+	/* Unit testing for driver hotplugging */
+
+	pr_info("Removing EC handlers...\n");
+	acpi_ec_stop(ec);
+	acpi_remove_gpe_handler(NULL, ec->gpe,
+				&acpi_ec_gpe_handler);
+	pr_info("Installing EC handlers...\n");
+	acpi_install_gpe_handler(NULL, ec->gpe,
+				  ACPI_GPE_EDGE_TRIGGERED,
+				  &acpi_ec_gpe_handler, ec);
+	acpi_ec_start(ec);
+#endif
 }
 
 static int ec_check_sci(struct acpi_ec *ec, u8 state)
-- 
1.7.10

