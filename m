Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaGUGGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:06:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:34666 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbaGUGGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="564767303"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 13/14] ACPI/EC: Add unit test support for EC driver hotplug.
Date: Mon, 21 Jul 2014 14:06:37 +0800
Message-Id: <4980f02202570dbd5e63b9b2ee55418bc56265af.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds facility to test future EC modification.
All EC commits should enable TEST_HOTPLUG, and try a build/boot test.
Since EC is currently a built-in module, this is the only mean for us to
test the hotplug code.
The following is the result of the flushing tests:
  ACPI : EC: ===== IRQ (0) =====
  ACPI : EC: EC_SC(R) = 0x20 SCI_EVT=1 BURST=0 CMD=0 IBF=0 OBF=0
# ACPI : EC: 2: Increase poller(set)
  ACPI : EC: ***** Event pending *****
  ACPI : EC: ***** Event poller started *****
* ACPI : EC: 3: Increase command
  ACPI : EC: ***** Command(QR_EC) started *****
  ACPI : EC: ===== TASK (0) =====
  ACPI : EC: EC_SC(R) = 0x20 SCI_EVT=1 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: EC_SC(W) = 0x84
# ACPI : EC: 2: Decrease poller
  ACPI : EC: ***** Event running *****
  ACPI : EC: ===== IRQ (2) =====
  ACPI : EC: EC_SC(R) = 0x01 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=1
  ACPI : EC: EC_DATA(R) = 0x66
  ACPI : EC: ***** Command(QR_EC) stopped *****
* ACPI : EC: 1: Decrease command
  ACPI : EC: ##### Query(0x66) scheduled #####
  ACPI : EC: ***** Event poller stopped *****
  ACPI : EC: ##### Query(0x66) started #####
$ ACPI : EC: 2: Increase command
  ACPI : EC: ***** Command(RD_EC) started *****
  ACPI : EC: ===== TASK (0) =====
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: EC_SC(W) = 0x80
  ACPI : EC: ===== IRQ (0) =====
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: EC_DATA(W) = 0x07
  ACPI : EC: ===== TASK (0) =====
  ACPI : EC: EC_SC(R) = 0x02 SCI_EVT=0 BURST=0 CMD=0 IBF=1 OBF=0
  ACPI : EC: ===== IRQ (2) =====
  ACPI : EC: EC_SC(R) = 0x01 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=1
  ACPI : EC: EC_DATA(R) = 0x00
  ACPI : EC: ***** Command(RD_EC) stopped *****
$ ACPI : EC: 1: Decrease command
  ACPI : EC: Removing EC handlers...
  ACPI : EC: +++++ Stopping EC +++++
  ACPI : EC: 0: Decrease event
@ ACPI : EC: +++++ EC stopped +++++
  ACPI : EC: Installing EC handlers...
  ACPI : EC: +++++ Starting EC +++++
  ACPI : EC: 1: Increase event
  ACPI : EC: +++++ EC started +++++
  ... (other RD_EC commands for _Q66 evaluation)
  ACPI : EC: ##### Query(0x66) stopped #####
We can see the hot plugging succeeded (@) after a command transaction
issued by the EC address space handleri ($). We can also see the reference
count triggered by the EVT_SCI event is correctly flushed (#) across a
QR_EC command issued in the event poller thread (*).

And the tests to trigger EVT_SCI on the fly with system powering on/off,
system suspending/resuming also have passed.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index c2e276f..ea8d3c3 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -32,6 +32,7 @@
 /* Uncomment next line to get verbose printout */
 /* #define DEBUG */
 #define DEBUG_REF 0
+/* #define TEST_HOTPLUG */
 #define pr_fmt(fmt) "ACPI : EC: " fmt
 
 #include <linux/kernel.h>
@@ -139,6 +140,11 @@ static struct acpi_ec_query_handler *
 acpi_ec_get_query_handler(struct acpi_ec_query_handler *handler);
 static void acpi_ec_put_query_handler(struct acpi_ec_query_handler *handler);
 static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data);
+#ifdef TEST_HOTPLUG
+static void acpi_ec_test(struct acpi_ec *ec);
+#else
+static inline void acpi_ec_test(struct acpi_ec *ec) {}
+#endif
 
 struct acpi_ec *boot_ec, *first_ec;
 EXPORT_SYMBOL(first_ec);
@@ -551,6 +557,7 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 		acpi_release_global_lock(glk);
 unlock:
 	mutex_unlock(&ec->mutex);
+	acpi_ec_test(ec);
 	return status;
 }
 
@@ -1248,6 +1255,22 @@ int __init acpi_boot_ec_enable(void)
 	return -EFAULT;
 }
 
+#ifdef TEST_HOTPLUG
+static void acpi_ec_test(struct acpi_ec *ec)
+{
+	/* Unit testing for driver hotplugging */
+	pr_info("Removing EC handlers...\n");
+	acpi_ec_stop(ec);
+	acpi_remove_gpe_handler(NULL, ec->gpe,
+				&acpi_ec_gpe_handler);
+	pr_info("Installing EC handlers...\n");
+	acpi_install_gpe_handler(NULL, ec->gpe,
+				  ACPI_GPE_EDGE_TRIGGERED,
+				  &acpi_ec_gpe_handler, ec);
+	acpi_ec_start(ec);
+}
+#endif
+
 static const struct acpi_device_id ec_device_ids[] = {
 	{"PNP0C09", 0},
 	{"", 0},
-- 
1.7.10

