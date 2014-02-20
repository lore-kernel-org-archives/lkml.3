Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaBTK4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:56:52 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63238 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaBTKw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:52:58 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-15-5305de87028e
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
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
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH v4 1/7] drivers: of: add initialization code for reserved memory
Date: Thu, 20 Feb 2014 11:52:41 +0100
Message-id: <1392893567-31623-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
References: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAy2RW0ySYRiA+37+EyTtD6n+nHNFdZEVafPiW1HW1tbXRc3Nm1YXSkrqAnGg
	LsktR2iKikRtHlLT1KYMtch5YNaU8DCbJkFYS2mNLlJJM9S2Qku0u+d99rzvzUtzBA/xCDoj
	M1umypTKRSQPf7M+4j52z0skxnR7BHDNNEzBH9pCDlx8WgbgY8cEASv8jQQcCPYC6C8vxmFf
	xwKA41o/BXtKqii47P6CQavPQ8DGomYcumy1JGx3zFDw2ewgBlumnBhsGNERMFgZBcemAiS0
	OJooaKxsx2HhSwcF13qsOJwbLMJhZ9U8Ds22IICzS6P42UhkqbcA9Oe3CaD5B0aAXIZyDPXV
	zFCozK8jkNVcQqJpTz+JXjTfQZ/WfRzkHtUSqCM4h6GKtRhUZzMAZOgyAxSwRiXsvMqTpMrk
	Gbky1fEzybz09wU6Mmu1Adwa8nSBAqDTAj3g0iwTx653TWBbvJud9HaSesCjBUwLYL0/Lf+H
	Uowd973e3CCZWFb/XU+GWMg0AjZQj4ciDvOZZIudZZunwpkE1uo3b0Q0jTOH2PutmpDmM4hd
	rn6ChTTL7GNrTZKQ5jIX2bveGSLEgo3EVuMijIDfALaZwS5ZTkqW+nqa4oRYLVWoczLTxClK
	hRVsfXKlF7QMn7QDhgaiMP6VKTxRQEhz1XkKO2BpjkjI7/5IJAr4qdI8jUylTFLlyGVqO8Bo
	bkQBoOLHV0+38k8l6bTZkfX2b3H856Tb9AjzpkYfSOYerG2Lv2Dezij3Gy9JhW2Gv03Ve51y
	51gN+W5lj/7tZeWRr/ahD8K524GbYk330cH8hU5M4qsbnT9sbXLR52/0rmqqrg2cK85/pewP
	20H90jYHpssnJgsXS8PFkT3RCsmSCFenS2OjOSq19B87/xfFpwIAAA==
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
[mszyprow: added generic memory reservation code, refactored code to
 put it directly into fdt.c]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/Kconfig                |    6 +
 drivers/of/Makefile               |    1 +
 drivers/of/fdt.c                  |  145 ++++++++++++++++++
 drivers/of/of_reserved_mem.c      |  296 +++++++++++++++++++++++++++++++++++++
 drivers/of/platform.c             |    7 +
 include/asm-generic/vmlinux.lds.h |   11 ++
 include/linux/of_reserved_mem.h   |   65 ++++++++
 7 files changed, 531 insertions(+)
 create mode 100644 drivers/of/of_reserved_mem.c
 create mode 100644 include/linux/of_reserved_mem.h

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index c6973f101a3e..30a7d87a8077 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -75,4 +75,10 @@ config OF_MTD
 	depends on MTD
 	def_bool y
 
+config OF_RESERVED_MEM
+	depends on OF_EARLY_FLATTREE
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
index 758b4f8b30b7..04efe2ba736f 100644
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
@@ -438,6 +439,150 @@ int __initdata dt_root_size_cells;
 struct boot_param_header *initial_boot_params;
 
 #ifdef CONFIG_OF_EARLY_FLATTREE
+#if defined(CONFIG_HAVE_MEMBLOCK)
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
+#else
+int __init __weak
+early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
+				  bool nomap)
+{
+	pr_error("Reserved memory not supported, ignoring range 0x%llx - 0x%llx%s\n",
+		  base, size, nomap ? " (nomap)" : "");
+	return -ENOSYS;
+}
+#endif
+
+/**
+ * res_mem_reserve_reg() - reserve all memory described in 'reg' property
+ */
+static int __init
+__reserved_mem_reserve_reg(unsigned long node, const char *uname,
+		    phys_addr_t *res_base, phys_addr_t *res_size)
+{
+	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
+	phys_addr_t base, size;
+	unsigned long len;
+	__be32 *prop;
+	int nomap;
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
+	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
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
+static int __reserved_mem_check_root(unsigned long node)
+{
+	__be32 *prop;
+
+	prop = of_get_flat_dt_prop(node, "#size-cells", NULL);
+	if (prop && be32_to_cpup(prop) != dt_root_size_cells)
+		return -EINVAL;
+
+	prop = of_get_flat_dt_prop(node, "#address-cells", NULL);
+	if (prop && be32_to_cpup(prop) != dt_root_addr_cells)
+		return -EINVAL;
+
+	prop = of_get_flat_dt_prop(node, "ranges", NULL);
+	if (!prop)
+		return -EINVAL;
+	return 0;
+}
+
+/**
+ * fdt_scan_reserved_mem() - scan a single FDT node for reserved memory
+ */
+static int __init
+__fdt_scan_reserved_mem(unsigned long node, const char *uname, int depth,
+		      void *data)
+{
+	phys_addr_t base = 0, size = 0;
+	static int found;
+	const char *status;
+	int err;
+
+	if (!found && depth == 1 && strcmp(uname, "reserved-memory") == 0) {
+		if (__reserved_mem_check_root(node) != 0) {
+			pr_err("Reserved memory: unsupported node format, ignoring\n");
+			/* break scan */
+			return 1;
+		}
+		found = 1;
+		/* scan next node */
+		return 0;
+	} else if (!found) {
+		/* scan next node */
+		return 0;
+	} else if (found && depth < 2) {
+		/* scanning of /reserved-memory has been finished */
+		return 1;
+	}
+
+	status = of_get_flat_dt_prop(node, "status", NULL);
+	if (status && strcmp(status, "okay") != 0 && strcmp(status, "ok") != 0)
+		return 0;
+
+	err = __reserved_mem_reserve_reg(node, uname, &base, &size);
+	if (err == -ENOENT && of_get_flat_dt_prop(node, "size", NULL) == NULL)
+		goto end;
+
+	fdt_reserved_mem_save_node(node, uname, base, size);
+end:
+	/* scan next node */
+	return 0;
+}
+
+/**
+ * early_init_fdt_scan_reserved_mem() - create reserved memory regions
+ *
+ * This function grabs memory from early allocator for device exclusive use
+ * defined in device tree structures. It should be called by arch specific code
+ * once the early allocator (i.e. memblock) has been fully activated.
+ */
+void __init early_init_fdt_scan_reserved_mem(void)
+{
+	of_scan_flat_dt(__fdt_scan_reserved_mem, NULL);
+	fdt_init_reserved_mem();
+}
 
 /**
  * of_scan_flat_dt - scan flattened tree blob and call callback on each.
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
new file mode 100644
index 000000000000..cacf04810b87
--- /dev/null
+++ b/drivers/of/of_reserved_mem.c
@@ -0,0 +1,296 @@
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
+ * res_mem_save_node() - save fdt node for second pass initialization
+ */
+int __init fdt_reserved_mem_save_node(unsigned long node, const char *uname,
+				      phys_addr_t base, phys_addr_t size)
+{
+	struct reserved_mem *rmem = &reserved_mem[reserved_mem_count];
+
+	if (reserved_mem_count == ARRAY_SIZE(reserved_mem)) {
+		pr_err("Reserved memory: not enough space all defined regions.\n");
+		return -ENOSPC;
+	}
+
+	rmem->fdt_node = node;
+	rmem->name = uname;
+	rmem->base = base;
+	rmem->size = size;
+
+	reserved_mem_count++;
+	return 0;
+}
+
+/**
+ * res_mem_alloc_size() - allocate reserved memory described by 'size', 'align'
+ *			  and 'alloc-ranges' properties
+ */
+static int __init
+__reserved_mem_alloc_size(unsigned long node, const char *uname,
+			  phys_addr_t *res_base, phys_addr_t *res_size)
+{
+	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
+	phys_addr_t start = 0, end = 0;
+	phys_addr_t base = 0, align = 0, size;
+	unsigned long len;
+	__be32 *prop;
+	int nomap;
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
+	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
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
+static int __init __reserved_mem_init_node(struct reserved_mem *rmem)
+{
+	extern const struct of_device_id __reservedmem_of_table[];
+	const struct of_device_id *i;
+
+	for (i = __reservedmem_of_table; i < &__rmem_of_table_sentinel; i++) {
+		reservedmem_of_init_fn initfn = i->data;
+		const char *compat = i->compatible;
+
+		if (!of_flat_dt_is_compatible(rmem->fdt_node, compat))
+			continue;
+
+		if (initfn(rmem, rmem->fdt_node, rmem->name) == 0) {
+			pr_info("Reserved memory: initialized node %s, compatible id %s\n",
+				rmem->name, compat);
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+/**
+ * fdt_init_reserved_mem - allocate and init all saved reserved memory regions
+ */
+void __init fdt_init_reserved_mem(void)
+{
+	int i;
+	for (i = 0; i < reserved_mem_count; i++) {
+		struct reserved_mem *rmem = &reserved_mem[i];
+		unsigned long node = rmem->fdt_node;
+		unsigned long len;
+		__be32 *prop;
+		int err = 0;
+
+		prop = of_get_flat_dt_prop(node, "phandle", &len);
+		if (!prop)
+			prop = of_get_flat_dt_prop(node, "linux,phandle", &len);
+		if (prop)
+			rmem->phandle = of_read_number(prop, len/4);
+
+		if (rmem->size == 0)
+			err = __reserved_mem_alloc_size(node, rmem->name,
+						 &rmem->base, &rmem->size);
+		if (err == 0)
+			__reserved_mem_init_node(rmem);
+	}
+}
+
+static inline struct reserved_mem *__find_rmem(struct device_node *node)
+{
+	unsigned int len, phandle_val;
+	const __be32 *prop;
+	unsigned int i;
+
+	prop = of_get_property(node, "phandle", &len);
+	if (!prop)
+		prop = of_get_property(node, "linux,phandle", &len);
+	if (!prop || len < sizeof(__be32))
+		return NULL;
+
+	phandle_val = be32_to_cpup(prop);
+	for (i = 0; i < reserved_mem_count; i++)
+		if (reserved_mem[i].phandle == phandle_val)
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
+		rmem = __find_rmem(s.np);
+		if (!rmem || !rmem->ops || !rmem->ops->device_init) {
+			of_node_put(s.np);
+			continue;
+		}
+
+		rmem->ops->device_init(rmem, dev, &s);
+		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
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
+		rmem = __find_rmem(s.np);
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
index 000000000000..0bbec4bf23ce
--- /dev/null
+++ b/include/linux/of_reserved_mem.h
@@ -0,0 +1,65 @@
+#ifndef __OF_RESERVED_MEM_H
+#define __OF_RESERVED_MEM_H
+
+struct cma;
+struct device;
+struct of_phandle_args;
+struct reserved_mem_ops;
+
+struct reserved_mem {
+	const char			*name;
+	unsigned long			fdt_node;
+	unsigned long			phandle;
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
+
+void fdt_init_reserved_mem(void);
+void early_init_fdt_scan_reserved_mem(void);
+int fdt_reserved_mem_save_node(unsigned long node, const char *uname,
+			       phys_addr_t base, phys_addr_t size);
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
+static inline void of_reserved_mem_device_release(struct device *pdev) { }
+
+static inline void fdt_init_reserved_mem(void) { }
+static inline void early_init_fdt_scan_reserved_mem(void) { }
+static inline int
+fdt_reserved_mem_save_node(unsigned long node, const char *uname,
+			       phys_addr_t base, phys_addr_t size) { }
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

