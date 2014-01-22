Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaAVTCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:02:42 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46074 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaAVTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:01:57 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH RFC 1/4] drivers: of: add initialization code for reserved memory
Date: Wed, 22 Jan 2014 12:58:49 -0600
Message-Id: <1390417133-6650-2-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1390417133-6650-1-git-send-email-joshc@codeaurora.org>
References: <1390417133-6650-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch adds device tree support for contiguous and reserved memory
regions defined in device tree.

Large memory blocks can be reliably reserved only during early boot.
This must happen before the whole memory management subsystem is
initialized, because we need to ensure that the given contiguous blocks
are not yet allocated by kernel. Also it must happen before kernel
mappings for the whole low memory are created, to ensure that there will
be no mappings (for reserved blocks) or mapping with special properties
can be created (for CMA blocks). This all happens before device tree
structures are unflattened, so we need to get reserved memory layout
directly from fdt.

Later, those reserved memory regions are assigned to devices on each
device structure initialization.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
[joshc: rework to implement new DT binding, provide mechanism for
 plugging in new reserved-memory node handlers via
 RESERVEDMEM_OF_DECLARE]
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/of/Kconfig                |   6 ++
 drivers/of/Makefile               |   1 +
 drivers/of/of_reserved_mem.c      | 188 ++++++++++++++++++++++++++++++++++++++
 drivers/of/platform.c             |   4 +
 include/asm-generic/vmlinux.lds.h |  11 +++
 include/linux/of_reserved_mem.h   |  61 +++++++++++++
 6 files changed, 271 insertions(+)
 create mode 100644 drivers/of/of_reserved_mem.c
 create mode 100644 include/linux/of_reserved_mem.h

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index c6973f1..aba13df 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -75,4 +75,10 @@ config OF_MTD
 	depends on MTD
 	def_bool y
 
+config OF_RESERVED_MEM
+	depends on HAVE_MEMBLOCK
+	def_bool y
+	help
+	  Helpers to allow for reservation of memory regions
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index efd0510..ed9660a 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
+obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
new file mode 100644
index 0000000..9fcafb5
--- /dev/null
+++ b/drivers/of/of_reserved_mem.c
@@ -0,0 +1,188 @@
+/*
+ * Device tree based initialization code for reserved memory.
+ *
+ * Copyright (c) 2013, The Linux Foundation. All Rights Reserved.
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Author: Marek Szyprowski <m.szyprowski@samsung.com>
+ * Author: Josh Cartwright <joshc@codeaurora.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License or (at your optional) any later version of the license.
+ */
+#include <linux/memblock.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_platform.h>
+#include <linux/mm.h>
+#include <linux/sizes.h>
+#include <linux/of_reserved_mem.h>
+
+#define MAX_RESERVED_REGIONS	16
+static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
+static int reserved_mem_count;
+
+static int __init rmem_default_early_setup(struct reserved_mem *rmem,
+					   unsigned long node,
+					   const char *uname)
+{
+	unsigned long len;
+	__be32 *prop;
+	int err;
+
+	prop = of_get_flat_dt_prop(node, "reg", &len);
+	if (!prop) {
+		pr_err("reg property missing for reserved-memory node '%s'\n",
+				uname);
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (len < (dt_root_size_cells + dt_root_addr_cells) * sizeof(__be32)) {
+		pr_err("invalid reg property for reserved-memory node '%s'\n",
+				uname);
+		err = -EINVAL;
+		goto out;
+	}
+
+	rmem->base = dt_mem_next_cell(dt_root_addr_cells, &prop);
+	rmem->size = dt_mem_next_cell(dt_root_size_cells, &prop);
+
+	if (of_get_flat_dt_prop(node, "no-map", NULL))
+		err = memblock_remove(rmem->base, rmem->size);
+	else
+		err = memblock_reserve(rmem->base, rmem->size);
+
+	pr_info("Reserved mem: found '%s', memory base %pa, size %ld MiB\n",
+		uname, &rmem->base, (unsigned long)rmem->size / SZ_1M);
+
+out:
+	return err;
+}
+
+static const struct of_device_id rmem_default_id
+	__used __section(__reservedmem_of_table_end) = {
+	.data		= rmem_default_early_setup,
+};
+
+static int __init fdt_scan_reserved_mem(unsigned long node, const char *uname,
+					int depth, void *data)
+{
+	struct reserved_mem *rmem = &reserved_mem[reserved_mem_count];
+	extern const struct of_device_id __reservedmem_of_table[];
+	reservedmem_of_init_fn initfn;
+	const struct of_device_id *id;
+	const char *status;
+
+	if (reserved_mem_count == ARRAY_SIZE(reserved_mem)) {
+		pr_err("Not enough space for reserved-memory regions.\n");
+		return -ENOSPC;
+	}
+
+	status = of_get_flat_dt_prop(node, "status", NULL);
+	if (status && strcmp(status, "okay") != 0)
+		return 0;
+
+	/*
+	 * The default handler above ensures this section is terminated with a
+	 * id whose compatible string is empty
+	 */
+	for (id = __reservedmem_of_table; ; id++) {
+		const char *compat = id->compatible;
+
+		if (!compat[0] || of_flat_dt_is_compatible(node, compat)) {
+			initfn = id->data;
+			break;
+		}
+	}
+
+	if (!initfn(rmem, node, uname)) {
+		strlcpy(rmem->name, uname, sizeof(rmem->name));
+		reserved_mem_count++;
+	}
+
+	return 0;
+}
+
+static struct reserved_mem *find_rmem(struct device_node *np)
+{
+	const char *name;
+	unsigned int i;
+
+	name = kbasename(np->full_name);
+
+	for (i = 0; i < reserved_mem_count; i++)
+		if (strcmp(name, reserved_mem[i].name) == 0)
+			return &reserved_mem[i];
+
+	return NULL;
+}
+
+/**
+ * of_reserved_mem_device_init() - assign reserved memory region to given device
+ *
+ * This function assign memory region pointed by "memory-region" device tree
+ * property to the given device.
+ */
+void of_reserved_mem_device_init(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct reserved_mem *rmem;
+	struct of_phandle_args s;
+	unsigned int i;
+
+	for (i = 0; of_parse_phandle_with_args(np, "memory-region",
+				"#memory-region-cells", i, &s) == 0; i++) {
+
+		rmem = find_rmem(s.np);
+		of_node_put(s.np);
+
+		if (!rmem || !rmem->ops || !rmem->ops->device_init)
+			continue;
+
+		rmem->ops->device_init(rmem, pdev, &s);
+	}
+}
+
+/**
+ * of_reserved_mem_device_release() - release reserved memory device structures
+ *
+ * This function releases structures allocated for memory region handling for
+ * the given device.
+ */
+void of_reserved_mem_device_release(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct reserved_mem *rmem;
+	struct of_phandle_args s;
+	unsigned int i;
+
+	for (i = 0; of_parse_phandle_with_args(np, "memory-region",
+				"#memory-region-cells", i, &s) == 0; i++) {
+
+		rmem = find_rmem(s.np);
+		of_node_put(s.np);
+
+		if (!rmem || !rmem->ops || !rmem->ops->device_release)
+			continue;
+
+		rmem->ops->device_release(rmem, pdev);
+	}
+}
+
+/**
+ * early_init_dt_scan_reserved_mem() - create reserved memory regions
+ *
+ * This function grabs memory from early allocator for device exclusive use
+ * defined in device tree structures. It should be called by arch specific code
+ * once the early allocator (memblock) has been activated and all other
+ * subsystems have already allocated/reserved memory.
+ */
+void __init early_init_dt_scan_reserved_mem(void)
+{
+	of_scan_flat_dt_by_path("/reserved-memory", fdt_scan_reserved_mem,
+				NULL);
+}
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..b6d3cea 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -21,6 +21,7 @@
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/platform_device.h>
 
 const struct of_device_id of_default_bus_match_table[] = {
@@ -220,6 +221,8 @@ static struct platform_device *of_platform_device_create_pdata(
 	dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
 
+	of_reserved_mem_device_init(dev);
+
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
 	 * to do such, possibly using a device notifier
@@ -227,6 +230,7 @@ static struct platform_device *of_platform_device_create_pdata(
 
 	if (of_device_add(dev) != 0) {
 		platform_device_put(dev);
+		of_reserved_mem_device_release(dev);
 		return NULL;
 	}
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bc2121f..f10f64f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -167,6 +167,16 @@
 #define CLK_OF_TABLES()
 #endif
 
+#ifdef CONFIG_OF_RESERVED_MEM
+#define RESERVEDMEM_OF_TABLES()				\
+	. = ALIGN(8);					\
+	VMLINUX_SYMBOL(__reservedmem_of_table) = .;	\
+	*(__reservedmem_of_table)			\
+	*(__reservedmem_of_table_end)
+#else
+#define RESERVEDMEM_OF_TABLES()
+#endif
+
 #define KERNEL_DTB()							\
 	STRUCT_ALIGN();							\
 	VMLINUX_SYMBOL(__dtb_start) = .;				\
@@ -490,6 +500,7 @@
 	TRACE_SYSCALLS()						\
 	MEM_DISCARD(init.rodata)					\
 	CLK_OF_TABLES()							\
+	RESERVEDMEM_OF_TABLES()						\
 	CLKSRC_OF_TABLES()						\
 	KERNEL_DTB()							\
 	IRQCHIP_OF_MATCH_TABLE()
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
new file mode 100644
index 0000000..a2de510
--- /dev/null
+++ b/include/linux/of_reserved_mem.h
@@ -0,0 +1,61 @@
+#ifndef __OF_RESERVED_MEM_H
+#define __OF_RESERVED_MEM_H
+
+struct cma;
+struct platform_device;
+struct of_phandle_args;
+struct reserved_mem_ops;
+
+struct reserved_mem {
+	const struct reserved_mem_ops	*ops;
+	char				name[32];
+	union {
+		struct cma		*cma;
+		struct {
+			phys_addr_t	base;
+			phys_addr_t	size;
+		};
+	};
+};
+
+struct reserved_mem_ops {
+	void	(*device_init)(struct reserved_mem *rmem,
+			       struct platform_device *pdev,
+			       struct of_phandle_args *args);
+	void	(*device_release)(struct reserved_mem *rmem,
+				  struct platform_device *pdev);
+};
+
+typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem,
+				      unsigned long node, const char *uname);
+
+#ifdef CONFIG_OF_RESERVED_MEM
+void of_reserved_mem_device_init(struct platform_device *pdev);
+void of_reserved_mem_device_release(struct platform_device *pdev);
+void early_init_dt_scan_reserved_mem(void);
+
+#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
+	static const struct of_device_id __reservedmem_of_table_##name	\
+		__used __section(__reservedmem_of_table)		\
+		 = { .compatible = compat,				\
+		     .data = (init == (reservedmem_of_init_fn)NULL) ?	\
+				init : init }
+
+#else
+static inline void of_reserved_mem_device_init(struct platform_device *pdev) { }
+
+static inline
+void of_reserved_mem_device_release(struct platform_device *pdev) { }
+
+static inline void early_init_dt_scan_reserved_mem(void) { }
+
+#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
+	static const struct of_device_id __reservedmem_of_table_##name	\
+		__attribute__((unused))					\
+		 = { .compatible = compat,				\
+		     .data = (init == (reservedmem_of_init_fn)NULL) ?	\
+				init : init }
+
+#endif
+
+#endif /* __OF_RESERVED_MEM_H */
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

