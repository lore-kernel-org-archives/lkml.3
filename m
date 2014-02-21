Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbaBUMaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:30:55 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56294 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbaBUM0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:26:12 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-87-530745e1dd11
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
Subject: [PATCH v5 02/11] drivers: of: add initialization code for static
 reserved memory
Date: Fri, 21 Feb 2014 13:25:18 +0100
Message-id: <1392985527-6260-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRa0hTYRzGe8/OzjmOBqdl8SohMspCTCeUvaTEiKT3Qx+SQUFBNXV5walt
	TtSixlCbS+dchFZqiho4dsmZeCvQNVQyb2kK3kKlRJ1mbVnotJx+e/6/5wfPhz/DERjIQCYl
	PUumSJemCSke2b/T++X0XCwtEc3mB6BtYw+N1jUFHPTjdTFAr5yDXFTqquWiLm8bQK4SLYna
	rWsADWhcNGotqqCRZ2yOQPaFcS6qLawn0WhHJYUszhkavVnqJlDDxAiBanrzuchbHoQ+Trgp
	ZHbW0chQbiFRwXsnjbZb7SRa7i4kka1ihUSmDi9ASz/7SPExbK42A7y1aQR45akB4FF9CYHb
	X8zQuNiVz8V2UxGFp8ffUbi5/hGe2lng4LE+DRdbvcsELt0W4aoOPcD6tyaA3fagq4du8GIS
	ZWkp2TJFxIU7vOTmsioyc1iU49FOU2rQdFIHGAayZ2CTR6QDfrvxKByetVE6wGMEbAOAzTYD
	vX88IaDJUUj5LIqNhLpV3V72Z2sBdFeTPonDfqWgdqSY8BWH2Ztw2f2Z9i2Q7AloU9/3YT57
	GZa2NNL7w8Gw0hjjw34shp+6FvewYFexalMNgF8DDpjAEZkqIVMZnySPDFdK5UpVelJ4Qobc
	Dva/6GkDdT3nHYBlgPAgPxNSEgFXmq3MlTsAZDhCf353BC0R8BOluXkyRcZthSpNpnQAgvEL
	VIOwa39ebliMGrHWq5knnsdFDQTCh2UuMRMi/peh6tyYGk2ZZ/625HwwZqVGDal/TV4KXjw3
	KN961mmTWKvW1h9flNyyKOLoJZMjIHqTfzwk9spZJ9sy6c3D0dN5dKj2e5KYvOeWfDM8aCuK
	H5K3205FrDbt6M2/r+f0g7thQlKZLI0M5SiU0v/GgNSZowIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for static (defined by 'reg' property) reserved
memory regions declared in device tree.

Memory blocks can be reliably reserved only during early boot. This must
happen before the whole memory management subsystem is initialized,
because we need to ensure that the given contiguous blocks are not yet
allocated by kernel. Also it must happen before kernel mappings for the
whole low memory are created, to ensure that there will be no mappings
(for reserved blocks). Typically, all this happens before device tree
structures are unflattened, so we need to get reserved memory layout
directly from fdt.

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/fdt.c       |  125 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_fdt.h |    3 ++
 2 files changed, 128 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 758b4f8b30b7..12809e20ef71 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -440,6 +440,113 @@ struct boot_param_header *initial_boot_params;
 #ifdef CONFIG_OF_EARLY_FLATTREE
 
 /**
+ * res_mem_reserve_reg() - reserve all memory described in 'reg' property
+ */
+static int __init __reserved_mem_reserve_reg(unsigned long node,
+					     const char *uname)
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
+static int __init __fdt_scan_reserved_mem(unsigned long node, const char *uname,
+					  int depth, void *data)
+{
+	static int found;
+	const char *status;
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
+	__reserved_mem_reserve_reg(node, uname);
+
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
+}
+
+/**
  * of_scan_flat_dt - scan flattened tree blob and call callback on each.
  * @it: callback function
  * @data: context data pointer
@@ -856,6 +963,16 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 	memblock_add(base, size);
 }
 
+int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
+					phys_addr_t size, bool nomap)
+{
+	if (memblock_is_region_reserved(base, size))
+		return -EBUSY;
+	if (nomap)
+		return memblock_remove(base, size);
+	return memblock_reserve(base, size);
+}
+
 /*
  * called from unflatten_device_tree() to bootstrap devicetree itself
  * Architectures can override this definition if memblock isn't used
@@ -864,6 +981,14 @@ void * __init __weak early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
 	return __va(memblock_alloc(size, align));
 }
+#else
+int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
+					phys_addr_t size, bool nomap)
+{
+	pr_error("Reserved memory not supported, ignoring range 0x%llx - 0x%llx%s\n",
+		  base, size, nomap ? " (nomap)" : "");
+	return -ENOSYS;
+}
 #endif
 
 bool __init early_init_dt_scan(void *params)
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index 2b77058a7335..8610ad8d77d2 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -98,7 +98,10 @@ extern int early_init_dt_scan_chosen(unsigned long node, const char *uname,
 				     int depth, void *data);
 extern int early_init_dt_scan_memory(unsigned long node, const char *uname,
 				     int depth, void *data);
+extern void early_init_fdt_scan_reserved_mem(void);
 extern void early_init_dt_add_memory_arch(u64 base, u64 size);
+extern int early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
+					     bool no_map);
 extern void * early_init_dt_alloc_memory_arch(u64 size, u64 align);
 extern u64 dt_mem_next_cell(int s, __be32 **cellp);
 
-- 
1.7.9.5

