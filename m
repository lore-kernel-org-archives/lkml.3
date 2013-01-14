Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab3ANJvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:51:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:25007 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676Ab3ANJvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:51:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,466,1355126400"; 
   d="scan'208";a="276566929"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] ACPI: add support for CSRT table
Date: Mon, 14 Jan 2013 11:51:51 +0200
Message-Id: <1358157111-26510-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core System Resources Table (CSRT) is a proprietary ACPI table that
contains resources for certain devices that are not found in the DSDT
table. Typically a shared DMA controller might be found here.

This patch adds support for this table. We go through all entries in the
table and make platform devices of them. The resources from the table are
passed with the platform device.

There is one special resource in the table and it is the DMA request line
base and number of request lines. This information might be needed by the
DMA controller driver as it needs to map the ACPI DMA request line number
to the actual request line understood by the hardware. This range is passed
as IORESOURCE_DMA resource.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/Makefile |    1 +
 drivers/acpi/csrt.c   |  156 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 157 insertions(+)
 create mode 100644 drivers/acpi/csrt.c

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 4ee2e75..474fcfe 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -38,6 +38,7 @@ acpi-y				+= processor_core.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
 acpi-y				+= pci_root.o pci_link.o pci_irq.o
+acpi-y				+= csrt.o
 acpi-y				+= acpi_platform.o
 acpi-y				+= power.o
 acpi-y				+= event.o
diff --git a/drivers/acpi/csrt.c b/drivers/acpi/csrt.c
new file mode 100644
index 0000000..94665f9
--- /dev/null
+++ b/drivers/acpi/csrt.c
@@ -0,0 +1,156 @@
+/*
+ * Support for Core System Resources Table (CSRT)
+ *
+ * Copyright (C) 2013, Intel Corporation
+ * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
+ *	    Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt) "ACPI: CSRT: " fmt
+
+#include <linux/acpi.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sizes.h>
+
+ACPI_MODULE_NAME("CSRT");
+
+static int __init acpi_csrt_parse_shared_info(struct platform_device *pdev,
+					      const struct acpi_csrt_group *grp)
+{
+	const struct acpi_csrt_shared_info *si;
+	struct resource res[3];
+	size_t nres;
+	int ret;
+
+	memset(res, 0, sizeof(res));
+	nres = 0;
+
+	si = (const struct acpi_csrt_shared_info *)&grp[1];
+	if (!si->mmio_base_high && si->mmio_base_low) {
+		/*
+		 * There is no size of the memory resource in shared_info
+		 * so we assume that it is 4k here.
+		 */
+		res[nres].start = (resource_size_t)si->mmio_base_high << 32
+				| si->mmio_base_low;
+		res[nres].end = res[0].start + SZ_4K - 1;
+		res[nres++].flags = IORESOURCE_MEM;
+	}
+
+	if (si->gsi_interrupt) {
+		int irq = acpi_register_gsi(NULL, si->gsi_interrupt,
+					    si->interrupt_mode,
+					    si->interrupt_polarity);
+		res[nres].start = irq;
+		res[nres].end = irq;
+		res[nres++].flags = IORESOURCE_IRQ;
+	}
+
+	if (si->base_request_line || si->num_handshake_signals) {
+		/*
+		 * We pass the driver a DMA resource describing the range
+		 * of request lines the device supports.
+		 */
+		res[nres].start = si->base_request_line;
+		res[nres].end = res[nres].start + si->num_handshake_signals - 1;
+		res[nres++].flags = IORESOURCE_DMA;
+	}
+
+	ret = platform_device_add_resources(pdev, res, nres);
+	if (ret) {
+		if (si->gsi_interrupt)
+			acpi_unregister_gsi(si->gsi_interrupt);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __init
+acpi_csrt_parse_resource_group(const struct acpi_csrt_group *grp)
+{
+	struct platform_device *pdev;
+	char vendor[5], name[16];
+	int ret, i;
+
+	vendor[0] = grp->vendor_id;
+	vendor[1] = grp->vendor_id >> 8;
+	vendor[2] = grp->vendor_id >> 16;
+	vendor[3] = grp->vendor_id >> 24;
+	vendor[4] = '\0';
+
+	if (grp->shared_info_length != sizeof(struct acpi_csrt_shared_info))
+		return -ENODEV;
+
+	snprintf(name, sizeof(name), "%s%04X", vendor, grp->device_id);
+	pdev = platform_device_alloc(name, PLATFORM_DEVID_AUTO);
+	if (!pdev)
+		return -ENOMEM;
+
+	/* Add resources based on the shared info */
+	ret = acpi_csrt_parse_shared_info(pdev, grp);
+	if (ret)
+		goto fail;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto fail;
+
+	for (i = 0; i < pdev->num_resources; i++)
+		dev_dbg(&pdev->dev, "%pR\n", &pdev->resource[i]);
+
+	return 0;
+
+fail:
+	platform_device_put(pdev);
+	return ret;
+}
+
+/*
+ * CSRT or Core System Resources Table is a proprietary ACPI table
+ * introduced by Microsoft. This table can contain devices that are not in
+ * the system DSDT table. In particular DMA controllers might be described
+ * here.
+ *
+ * We present these devices as normal platform devices that don't have ACPI
+ * IDs or handle. The platform device name will be something like
+ * <VENDOR><DEVID>.<n>.auto for example: INTL9C06.0.auto.
+ */
+static int __init acpi_csrt_init(void)
+{
+	struct acpi_csrt_group *grp, *end;
+	struct acpi_table_csrt *csrt;
+	acpi_status status;
+	int ret;
+
+	status = acpi_get_table(ACPI_SIG_CSRT, 0,
+				(struct acpi_table_header **)&csrt);
+	if (ACPI_FAILURE(status)) {
+		if (status == AE_NOT_FOUND)
+			return -ENOENT;
+		return -EINVAL;
+	}
+
+	pr_debug("parsing CSRT table for devices\n");
+
+	grp = (struct acpi_csrt_group *)(csrt + 1);
+	end = (struct acpi_csrt_group *)((void *)csrt + csrt->header.length);
+
+	while (grp < end) {
+		ret = acpi_csrt_parse_resource_group(grp);
+		if (ret)
+			return ret;
+
+		grp = (struct acpi_csrt_group *)((void *)grp + grp->length);
+	}
+
+	return 0;
+}
+subsys_initcall(acpi_csrt_init);
-- 
1.7.10.4

