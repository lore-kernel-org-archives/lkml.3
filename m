Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaEVSEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:04:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:43912 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaEVSDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:03:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,888,1392192000"; 
   d="scan'208";a="516172125"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V7 08/11] ACPI: always register memory hotplug scan handler even if CONFIG_X86_INTEL_LPSS is cleared
Date: Fri, 23 May 2014 02:02:30 +0800
Message-Id: <1400781753-2682-9-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new ACPI device enumeration mechanism, which will be introduced
in a later patch, will enumerate the _HID devices w/o any scan
handler attached to platform bus.
This means that, for the devices that are attached to a configurable
scan handler, we should make sure no platform devices would be
created for them even if the scan handler is compiled out.

Fix this problem for lpss devices by always register the lpss scan handler,
but with meaningful callbacks only when CONFIG_X86_INTEL_LPSS is set.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/Makefile    |  2 +-
 drivers/acpi/acpi_lpss.c | 63 ++++++++++++++++++++++++++++++------------------
 drivers/acpi/internal.h  |  4 ---
 3 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 171efc2..605eff7 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -39,7 +39,7 @@ acpi-y				+= processor_core.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
 acpi-y				+= pci_root.o pci_link.o pci_irq.o
-acpi-$(CONFIG_X86_INTEL_LPSS)	+= acpi_lpss.o
+acpi-y				+= acpi_lpss.o
 acpi-y				+= acpi_platform.o
 acpi-y				+= acpi_pnp.o
 acpi-y				+= power.o
diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 69e29f4..bb5b3f2 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -24,6 +24,8 @@
 
 ACPI_MODULE_NAME("acpi_lpss");
 
+#ifdef CONFIG_X86_INTEL_LPSS
+
 #define LPSS_CLK_SIZE	0x04
 #define LPSS_LTR_SIZE	0x18
 
@@ -159,40 +161,50 @@ static struct lpss_device_desc byt_i2c_dev_desc = {
 	.shared_clock = &i2c_clock,
 };
 
+#define LPSS_PTR(desc) ((unsigned long)&desc)
+
+#else
+
+#define LPSS_PTR(desc) 0
+
+#endif
+
 static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	/* Generic LPSS devices */
-	{ "INTL9C60", (unsigned long)&lpss_dma_desc },
+	{ "INTL9C60", LPSS_PTR(lpss_dma_desc) },
 
 	/* Lynxpoint LPSS devices */
-	{ "INT33C0", (unsigned long)&lpt_dev_desc },
-	{ "INT33C1", (unsigned long)&lpt_dev_desc },
-	{ "INT33C2", (unsigned long)&lpt_dev_desc },
-	{ "INT33C3", (unsigned long)&lpt_dev_desc },
-	{ "INT33C4", (unsigned long)&lpt_uart_dev_desc },
-	{ "INT33C5", (unsigned long)&lpt_uart_dev_desc },
-	{ "INT33C6", (unsigned long)&lpt_sdio_dev_desc },
+	{ "INT33C0", LPSS_PTR(lpt_dev_desc) },
+	{ "INT33C1", LPSS_PTR(lpt_dev_desc) },
+	{ "INT33C2", LPSS_PTR(lpt_dev_desc) },
+	{ "INT33C3", LPSS_PTR(lpt_dev_desc) },
+	{ "INT33C4", LPSS_PTR(lpt_uart_dev_desc) },
+	{ "INT33C5", LPSS_PTR(lpt_uart_dev_desc) },
+	{ "INT33C6", LPSS_PTR(lpt_sdio_dev_desc) },
 	{ "INT33C7", },
 
 	/* BayTrail LPSS devices */
-	{ "80860F09", (unsigned long)&byt_pwm_dev_desc },
-	{ "80860F0A", (unsigned long)&byt_uart_dev_desc },
-	{ "80860F0E", (unsigned long)&byt_spi_dev_desc },
-	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
-	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
+	{ "80860F09", LPSS_PTR(byt_pwm_dev_desc) },
+	{ "80860F0A", LPSS_PTR(byt_uart_dev_desc) },
+	{ "80860F0E", LPSS_PTR(byt_spi_dev_desc) },
+	{ "80860F14", LPSS_PTR(byt_sdio_dev_desc) },
+	{ "80860F41", LPSS_PTR(byt_i2c_dev_desc) },
 	{ "INT33B2", },
 
-	{ "INT3430", (unsigned long)&lpt_dev_desc },
-	{ "INT3431", (unsigned long)&lpt_dev_desc },
-	{ "INT3432", (unsigned long)&lpt_dev_desc },
-	{ "INT3433", (unsigned long)&lpt_dev_desc },
-	{ "INT3434", (unsigned long)&lpt_uart_dev_desc },
-	{ "INT3435", (unsigned long)&lpt_uart_dev_desc },
-	{ "INT3436", (unsigned long)&lpt_sdio_dev_desc },
+	{ "INT3430", LPSS_PTR(lpt_dev_desc) },
+	{ "INT3431", LPSS_PTR(lpt_dev_desc) },
+	{ "INT3432", LPSS_PTR(lpt_dev_desc) },
+	{ "INT3433", LPSS_PTR(lpt_dev_desc) },
+	{ "INT3434", LPSS_PTR(lpt_uart_dev_desc) },
+	{ "INT3435", LPSS_PTR(lpt_uart_dev_desc) },
+	{ "INT3436", LPSS_PTR(lpt_sdio_dev_desc) },
 	{ "INT3437", },
 
 	{ }
 };
 
+#ifdef CONFIG_X86_INTEL_LPSS
+
 static int is_memory(struct acpi_resource *res, void *not_used)
 {
 	struct resource r;
@@ -503,18 +515,23 @@ static void acpi_lpss_unbind(struct device *dev)
 {
 	dev->power.set_latency_tolerance = NULL;
 }
+#endif /* CONFIG_X86_INTEL_LPSS */
 
 static struct acpi_scan_handler lpss_handler = {
 	.ids = acpi_lpss_device_ids,
-	.attach = acpi_lpss_create_device,
-	.bind = acpi_lpss_bind,
-	.unbind = acpi_lpss_unbind,
 };
 
 void __init acpi_lpss_init(void)
 {
+#ifdef CONFIG_X86_INTEL_LPSS
 	if (!lpt_clk_init()) {
 		bus_register_notifier(&platform_bus_type, &acpi_lpss_nb);
+		lpss_handler.attach = acpi_lpss_create_device;
+		lpss_handler.bind = acpi_lpss_bind;
+		lpss_handler.unbind = acpi_lpss_unbind;
 		acpi_scan_add_handler(&lpss_handler);
+		return;
 	}
+#endif
+	acpi_scan_add_handler(&lpss_handler);
 }
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 4a9e999..bc7d102 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -65,11 +65,7 @@ int acpi_debugfs_init(void);
 #else
 static inline void acpi_debugfs_init(void) { return; }
 #endif
-#ifdef CONFIG_X86_INTEL_LPSS
 void acpi_lpss_init(void);
-#else
-static inline void acpi_lpss_init(void) {}
-#endif
 
 acpi_status acpi_hotplug_schedule(struct acpi_device *adev, u32 src);
 bool acpi_queue_hotplug_work(struct work_struct *work);
-- 
1.8.3.2

