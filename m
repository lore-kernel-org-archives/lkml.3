Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaBRNkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:40:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:39192 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaBRNkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:40:03 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-51-530362b17fc3
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v3 2/6] drivers: of: add initialization code for reserved memory
Date: Tue, 18 Feb 2014 14:37:57 +0100
Message-id: <1392730681-14695-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
References: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTYRzH8Z6dy47WgdOc7VHJYlFU1HLSiweSiop66sU0JCEhbOphSk7H
	puJCaolKO3nDAkeobbUUh5dcmrrUVDRNsZs3wtRi0kWXaRpSqdSU3n3gy5/fiz9DSKxkIJOY
	nMrrk9VJctqXHFhzcwfrY4nIkIb2vWi1+LkYzWflEOhe90sKFXpsFOpYaQbIk3+TRC21cwAN
	ZnnEqMlsEaOl4Y8i5HSPUsiWayfRkKuURjXdE2L06GunCD0ceyNC1t5sCq2UBKP+sUUaFZXU
	kCinrVuMVpucJJrpzCVRnWWWRA7XCjgegKvLqwH+87sY4NnbRQAPFeSLcMvdCTHO82RT2Okw
	0/j9aCuNH9uv4/E1N4GH+7IoXLsyI8KFqyG4oMEB8KIzGNeXXYjgon3D4vmkxHRef+joZd+E
	luwqoJu5AzIsL17RJmDLEIAPA7nDcKQyj9rwNvh6so4WgC8j4e4DWGxvJr1BwuWIoGk6xWua
	U0Lhm0B7LeVsAC6Wk94Dgiuh4YPG7+vBj4uArpH2dZPcbvhzsGvdLIdh79w7QgDMv7WdsLQ4
	zEsf7ixcGjuwMYVh45SbKAKsFWxyAH9eF6czxGq0SoVBrTWkJWsUcSlaJ1j/26fAZlBlQl2A
	Y4B8Czu/SxQpodTpBqO2C0CGkEvZfdFEpISNVxuv8vqUGH1aEm/oAkEMKZexHTlHzks4jTqV
	v8LzOl7/v4oYn0ATCC9UZlZ6xufbhX73yR3W+i8RPeLQZYff6LPSGIWq7UmQIhzeOvfAfLGH
	DQ7oq/1QImm9xP6Q9Z6u8Hdvl8qMKtW1PVLNr1nBL2pKFVfx2W6eERosx5IVsunMyWWu1rww
	EB7mMISqFixby1ybu28IE0KM8VTUGb+nJ+StBW/lpCFBrdxP6A3qv7loFDqzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
[joshc: rework to implement new DT binding, provide mechanism for
 plugging in new reserved-memory node handlers via
 RESERVEDMEM_OF_DECLARE]
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
[mszyprow: added generic memory reservation code]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/Kconfig                |    5 +
 drivers/of/Makefile               |    1 +
 drivers/of/fdt.c                  |    2 +
 drivers/of/of_reserved_mem.c      |  390 +++++++++++++++++++++++++++++++++++++
 drivers/of/platform.c             |    7 +
 include/asm-generic/vmlinux.lds.h |   11 ++
 include/linux/of_reserved_mem.h   |   65 +++++++
 7 files changed, 481 insertions(+)
 create mode 100644 drivers/of/of_reserved_mem.c
 create mode 100644 include/linux/of_reserved_mem.h

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index c6973f101a3e..f25931dfc6db 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -75,4 +75,9 @@ config OF_MTD
 	depends on MTD
 	def_bool y
 
+config OF_RESERVED_MEM
+	bool
+	help
+	  Helpers to allow for reservation of memory regions
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index efd05102c405..ed9660adad77 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
+obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 758b4f8b30b7..c205c84e51a1 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -907,6 +908,7 @@ void __init unflatten_device_tree(void)
 
 	/* Get pointer to "/chosen" and "/aliases" nodes for use everywhere */
 	of_alias_scan(early_init_dt_alloc_memory_arch);
+	of_reserved_mem_scan();
 }
 
 /**
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
new file mode 100644
index 000000000000..074d66e41da8
--- /dev/null
+++ b/drivers/of/of_reserved_mem.c
@@ -0,0 +1,390 @@
+/*
+ * Device tree based initialization code for reserved memory.
+ *
+ * Copyright (c) 2013, The Linux Foundation. All Rights Reserved.
+ * Copyright (c) 2013,2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Author: Marek Szyprowski <m.szyprowski@samsung.com>
+ * Author: Josh Cartwright <joshc@codeaurora.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License or (at your optional) any later version of the license.
+ */
+
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
+#if defined(CONFIG_HAVE_MEMBLOCK)
+#include <linux/memblock.h>
+int __init __weak
+early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
+				  bool nomap)
+{
+	if (memblock_is_region_reserved(base, size))
+		return -EBUSY;
+	if (nomap)
+		return memblock_remove(base, size);
+	return memblock_reserve(base, size);
+}
+
+int __init __weak
+early_init_dt_alloc_reserved_memory_arch(phys_addr_t size, phys_addr_t align,
+					 phys_addr_t start, phys_addr_t end,
+					 bool nomap, phys_addr_t *res_base)
+{
+	/*
+	 * We use __memblock_alloc_base() since memblock_alloc_base() panic()s.
+	 */
+	phys_addr_t base = __memblock_alloc_base(size, align, end);
+	if (!base)
+		return -ENOMEM;
+
+	if (base < start) {
+		memblock_free(base, size);
+		return -ENOMEM;
+	}
+
+	*res_base = base;
+	if (nomap)
+		return memblock_remove(base, size);
+	return 0;
+}
+#else
+int __init __weak
+early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
+				  bool nomap)
+{
+	pr_error("Reserved memory not supported, ignoring range 0x%llx - 0x%llx%s\n",
+		  base, size, nomap ? " (nomap)" : "");
+	return -ENOSYS;
+}
+
+int __init __weak
+early_init_dt_alloc_reserved_memory_arch(phys_addr_t size, phys_addr_t align,
+					 phys_addr_t start, phys_addr_t end,
+					 bool nomap, phys_addr_t *res_base)
+{
+	pr_error("Reserved memory not supported, ignoring region 0x%llx%s\n",
+		  size, nomap ? " (nomap)" : "");
+	return -ENOSYS;
+}
+#endif
+
+/**
+ * res_mem_reserve_reg() - reserve all memory described in 'reg' property
+ */
+static int __init
+res_mem_reserve_reg(unsigned long node, const char *uname, int nomap,
+		    phys_addr_t *res_base, phys_addr_t *res_size)
+{
+	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
+	phys_addr_t base, size;
+	unsigned long len;
+	__be32 *prop;
+
+	prop = of_get_flat_dt_prop(node, "reg", &len);
+	if (!prop)
+		return -ENOENT;
+
+	if (len && len % t_len != 0) {
+		pr_err("Reserved memory: invalid reg property in '%s', skipping node.\n",
+		       uname);
+		return -EINVAL;
+	}
+
+	/* store base and size values from the first reg tuple */
+	*res_base = 0;
+	while (len > 0) {
+		base = dt_mem_next_cell(dt_root_addr_cells, &prop);
+		size = dt_mem_next_cell(dt_root_size_cells, &prop);
+
+		if (base && size &&
+		    early_init_dt_reserve_memory_arch(base, size, nomap) == 0)
+			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %ld MiB\n",
+				uname, &base, (unsigned long)size / SZ_1M);
+		else
+			pr_info("Reserved memory: failed to reserve memory for node '%s': base %pa, size %ld MiB\n",
+				uname, &base, (unsigned long)size / SZ_1M);
+
+		len -= t_len;
+
+		if (!(*res_base)) {
+			*res_base = base;
+			*res_size = size;
+		}
+	}
+	return 0;
+}
+
+/**
+ * res_mem_alloc_size() - allocate reserved memory described by 'size', 'align'
+ *			  and 'alloc-ranges' properties
+ */
+static int __init
+res_mem_alloc_size(unsigned long node, const char *uname, int nomap,
+		   phys_addr_t *res_base, phys_addr_t *res_size)
+{
+	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
+	phys_addr_t start = 0, end = 0;
+	phys_addr_t base = 0, align = 0, size;
+	unsigned long len;
+	__be32 *prop;
+	int ret;
+
+	prop = of_get_flat_dt_prop(node, "size", &len);
+	if (!prop)
+		return -EINVAL;
+
+	if (len != dt_root_size_cells * sizeof(__be32)) {
+		pr_err("Reserved memory: invalid size property in '%s' node.\n",
+				uname);
+		return -EINVAL;
+	}
+	size = dt_mem_next_cell(dt_root_size_cells, &prop);
+
+	prop = of_get_flat_dt_prop(node, "align", &len);
+	if (prop) {
+		if (len != dt_root_addr_cells * sizeof(__be32)) {
+			pr_err("Reserved memory: invalid align property in '%s' node.\n",
+				uname);
+			return -EINVAL;
+		}
+		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
+	}
+
+	prop = of_get_flat_dt_prop(node, "alloc-ranges", &len);
+	if (prop) {
+
+		if (len % t_len != 0) {
+			pr_err("Reserved memory: invalid alloc-ranges property in '%s', skipping node.\n",
+			       uname);
+			return -EINVAL;
+		}
+
+		base = 0;
+
+		while (len > 0) {
+			start = dt_mem_next_cell(dt_root_addr_cells, &prop);
+			end = start + dt_mem_next_cell(dt_root_size_cells,
+						       &prop);
+
+			ret = early_init_dt_alloc_reserved_memory_arch(size,
+					align, start, end, nomap, &base);
+			if (ret == 0) {
+				pr_debug("Reserved memory: allocated memory for '%s' node: base %pa, size %ld MiB\n",
+					uname, &base,
+					(unsigned long)size / SZ_1M);
+				break;
+			}
+			len -= t_len;
+		}
+
+	} else {
+		ret = early_init_dt_alloc_reserved_memory_arch(size, align,
+							0, 0, nomap, &base);
+		if (ret == 0)
+			pr_debug("Reserved memory: allocated memory for '%s' node: base %pa, size %ld MiB\n",
+				uname, &base, (unsigned long)size / SZ_1M);
+	}
+
+	if (base == 0) {
+		pr_info("Reserved memory: failed to allocate memory for node '%s'\n",
+			uname);
+		return -ENOMEM;
+	}
+
+	*res_base = base;
+	*res_size = size;
+
+	return 0;
+}
+
+static const struct of_device_id __rmem_of_table_sentinel
+	__used __section(__reservedmem_of_table_end);
+
+/**
+ * res_mem_init_node() - call region specific reserved memory init code
+ */
+static int __init
+res_mem_init_node(unsigned long node, const char *uname, phys_addr_t base,
+		  phys_addr_t size)
+{
+	struct reserved_mem *rmem = &reserved_mem[reserved_mem_count];
+	extern const struct of_device_id __reservedmem_of_table[];
+	const struct of_device_id *i;
+
+	if (reserved_mem_count == ARRAY_SIZE(reserved_mem)) {
+		pr_err("Reserved memory: not enough space all defined regions.\n");
+		return -ENOSPC;
+	}
+
+	rmem->base = base;
+	rmem->size = size;
+
+	for (i = __reservedmem_of_table; i < &__rmem_of_table_sentinel; i++) {
+		reservedmem_of_init_fn initfn = i->data;
+		const char *compat = i->compatible;
+
+		if (!of_flat_dt_is_compatible(node, compat))
+			continue;
+
+		if (initfn(rmem, node, uname) == 0) {
+			pr_info("Reserved memory: initialized node %s, compatible id %s\n",
+				uname, compat);
+			rmem->name = uname;
+			reserved_mem_count++;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+/**
+ * fdt_scan_reserved_mem() - scan a single FDT node for reserved memory
+ */
+static int __init
+fdt_scan_reserved_mem(unsigned long node, const char *uname, int depth,
+		      void *data)
+{
+	phys_addr_t base, size;
+	const char *status;
+	int nomap;
+	int err;
+
+	status = of_get_flat_dt_prop(node, "status", NULL);
+	if (status && strcmp(status, "okay") != 0 && strcmp(status, "ok") != 0)
+		return 0;
+
+	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
+
+	err = res_mem_reserve_reg(node, uname, nomap, &base, &size);
+	if (err == -ENOENT)
+		err = res_mem_alloc_size(node, uname, nomap, &base, &size);
+	if (err)
+		goto end;
+
+	res_mem_init_node(node, uname, base, size);
+end:
+	/* scan next node */
+	return 0;
+}
+
+/**
+ * early_init_dt_scan_reserved_mem() - create reserved memory regions
+ *
+ * This function grabs memory from early allocator for device exclusive use
+ * defined in device tree structures. It should be called by arch specific code
+ * once the early allocator (i.e. memblock) has been fully activated.
+ */
+void __init early_init_dt_scan_reserved_mem(void)
+{
+	of_scan_flat_dt_by_path("/reserved-memory", fdt_scan_reserved_mem,
+				NULL);
+}
+
+/**
+ * of_reserved_mem_scan() - scan and create structures required by reserved
+ *			    memory regions
+ *
+ * This function creates all structures required by reserved memory regions
+ * management code. It should be called by common code once the device tree
+ * has been unflattened.
+ */
+void __init of_reserved_mem_scan(void)
+{
+	struct device_node *root, *np;
+
+	root = of_find_node_by_path("/reserved-memory");
+
+	if (of_n_addr_cells(root) != dt_root_addr_cells ||
+	    of_n_size_cells(root) != dt_root_size_cells)
+		panic("Unsupported address or size cells for /reserved-memory node\n");
+
+	for (np = NULL;;) {
+		const char *name;
+		int i;
+
+		np = of_get_next_available_child(root, np);
+		if (!np)
+			break;
+
+		name = kbasename(np->full_name);
+		for (i = 0; i < reserved_mem_count; i++)
+			if (strcmp(name, reserved_mem[i].name) == 0)
+				reserved_mem[i].node = np;
+	}
+}
+
+static inline struct reserved_mem *find_rmem(struct device_node *phandle)
+{
+	unsigned int i;
+	for (i = 0; i < reserved_mem_count; i++)
+		if (reserved_mem[i].node == phandle)
+			return &reserved_mem[i];
+	return NULL;
+}
+
+/**
+ * of_reserved_mem_device_init() - assign reserved memory region to given device
+ *
+ * This function assign memory region pointed by "memory-region" device tree
+ * property to the given device.
+ */
+void of_reserved_mem_device_init(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct reserved_mem *rmem;
+	struct of_phandle_args s;
+	unsigned int i;
+
+	for (i = 0; of_parse_phandle_with_args(np, "memory-region",
+				"#memory-region-cells", i, &s) == 0; i++) {
+
+		rmem = find_rmem(s.np);
+		if (!rmem || !rmem->ops || !rmem->ops->device_init) {
+			of_node_put(s.np);
+			continue;
+		}
+
+		rmem->ops->device_init(rmem, dev, &s);
+		dev_info(dev, "assigned reserved memory node %s\n",
+			 rmem->name);
+		of_node_put(s.np);
+		break;
+	}
+}
+
+/**
+ * of_reserved_mem_device_release() - release reserved memory device structures
+ *
+ * This function releases structures allocated for memory region handling for
+ * the given device.
+ */
+void of_reserved_mem_device_release(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct reserved_mem *rmem;
+	struct of_phandle_args s;
+	unsigned int i;
+
+	for (i = 0; of_parse_phandle_with_args(np, "memory-region",
+				"#memory-region-cells", i, &s) == 0; i++) {
+
+		rmem = find_rmem(s.np);
+		if (rmem && rmem->ops && rmem->ops->device_release)
+			rmem->ops->device_release(rmem, dev);
+
+		of_node_put(s.np);
+	}
+}
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1daebefa..3df0b1826e8b 100644
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
 
+	of_reserved_mem_device_init(&dev->dev);
+
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
 	 * to do such, possibly using a device notifier
@@ -227,6 +230,7 @@ static struct platform_device *of_platform_device_create_pdata(
 
 	if (of_device_add(dev) != 0) {
 		platform_device_put(dev);
+		of_reserved_mem_device_release(&dev->dev);
 		return NULL;
 	}
 
@@ -282,6 +286,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 	else
 		of_device_make_bus_id(&dev->dev);
 
+	of_reserved_mem_device_init(&dev->dev);
+
 	/* Allow the HW Peripheral ID to be overridden */
 	prop = of_get_property(node, "arm,primecell-periphid", NULL);
 	if (prop)
@@ -308,6 +314,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 	return dev;
 
 err_free:
+	of_reserved_mem_device_release(&dev->dev);
 	amba_device_put(dev);
 	return NULL;
 }
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bc2121fa9132..f10f64fcc815 100644
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
index 000000000000..39a4fb17a5ea
--- /dev/null
+++ b/include/linux/of_reserved_mem.h
@@ -0,0 +1,65 @@
+#ifndef __OF_RESERVED_MEM_H
+#define __OF_RESERVED_MEM_H
+
+struct cma;
+struct platform_device;
+struct of_phandle_args;
+struct reserved_mem_ops;
+
+struct reserved_mem {
+	const char			*name;
+	struct device_node		*node;
+	const struct reserved_mem_ops	*ops;
+	phys_addr_t			base;
+	phys_addr_t			size;
+	void				*priv;
+};
+
+struct reserved_mem_ops {
+	void	(*device_init)(struct reserved_mem *rmem,
+			       struct device *dev,
+			       struct of_phandle_args *args);
+	void	(*device_release)(struct reserved_mem *rmem,
+				  struct device *dev);
+};
+
+typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem,
+				      unsigned long node, const char *uname);
+
+#ifdef CONFIG_OF_RESERVED_MEM
+void of_reserved_mem_device_init(struct device *dev);
+void of_reserved_mem_device_release(struct device *dev);
+void early_init_dt_scan_reserved_mem(void);
+void of_reserved_mem_scan(void);
+
+int of_parse_flat_dt_reg(unsigned long node, const char *uname,
+			 phys_addr_t *base, phys_addr_t *size);
+int of_parse_flat_dt_size(unsigned long node, const char *uname,
+			  phys_addr_t *size);
+
+#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
+	static const struct of_device_id __reservedmem_of_table_##name	\
+		__used __section(__reservedmem_of_table)		\
+		 = { .compatible = compat,				\
+		     .data = (init == (reservedmem_of_init_fn)NULL) ?	\
+				init : init }
+
+#else
+static inline void of_reserved_mem_device_init(struct device *dev) { }
+
+static inline
+void of_reserved_mem_device_release(struct device *pdev) { }
+
+static inline void early_init_dt_scan_reserved_mem(void) { }
+static inline void of_reserved_mem_scan(void) { }
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
1.7.9.5

