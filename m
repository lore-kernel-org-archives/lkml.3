Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaE3CRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:17:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51630 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753989AbaE3CO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:14:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.garrett@nebula.com, mika.westerberg@linux.intel.com
Subject: [PATCH 9/10] ACPI / scan: always register ACPI LPSS scan handler
Date: Fri, 30 May 2014 04:30:12 +0200
Message-ID: <8202338.Lrn5CAprz1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <35042328.kk6ZUUdfyN@vostro.rjw.lan>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com> <35042328.kk6ZUUdfyN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Prevent platform devices from being created for ACPI LPSS devices
if CONFIG_X86_INTEL_LPSS is unset by compiling out the LPSS scan
handler's callbacks only in that case and still compiling its device
ID list in and registering the scan handler in either case.

This change is based on a prototype from Zhang Rui.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

---
drivers/acpi/Makefile    |  2 +-
 drivers/acpi/Makefile    |    2 -
 drivers/acpi/acpi_lpss.c |   65 ++++++++++++++++++++++++++++++++---------------
 drivers/acpi/internal.h  |    4 --
 3 files changed, 46 insertions(+), 25 deletions(-)

Index: linux-pm/drivers/acpi/Makefile
===================================================================
--- linux-pm.orig/drivers/acpi/Makefile
+++ linux-pm/drivers/acpi/Makefile
@@ -39,7 +39,7 @@ acpi-y				+= processor_core.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
 acpi-y				+= pci_root.o pci_link.o pci_irq.o
-acpi-$(CONFIG_X86_INTEL_LPSS)	+= acpi_lpss.o
+acpi-y				+= acpi_lpss.o
 acpi-y				+= acpi_platform.o
 acpi-y				+= acpi_pnp.o
 acpi-y				+= power.o
Index: linux-pm/drivers/acpi/acpi_lpss.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_lpss.c
+++ linux-pm/drivers/acpi/acpi_lpss.c
@@ -25,6 +25,10 @@
 
 ACPI_MODULE_NAME("acpi_lpss");
 
+#ifdef CONFIG_X86_INTEL_LPSS
+
+#define LPSS_PTR(desc) ((unsigned long)&desc)
+
 #define LPSS_CLK_SIZE	0x04
 #define LPSS_LTR_SIZE	0x18
 
@@ -168,40 +172,48 @@ static struct lpss_device_desc byt_i2c_d
 	.shared_clock = &i2c_clock,
 };
 
+#else
+
+#define LPSS_PTR(desc) (NULL)
+
+#endif /* CONFIG_X86_INTEL_LPSS */
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
@@ -666,3 +678,16 @@ void __init acpi_lpss_init(void)
 		acpi_scan_add_handler(&lpss_handler);
 	}
 }
+
+#else
+
+static struct acpi_scan_handler lpss_handler = {
+	.ids = acpi_lpss_device_ids,
+};
+
+void __init acpi_lpss_init(void)
+{
+	acpi_scan_add_handler(&lpss_handler);
+}
+
+#endif /* CONFIG_X86_INTEL_LPSS */
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
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

