Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaB1NnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:43:23 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29539 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaB1NnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:43:12 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-29-5310926e2c76
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
Subject: [PATCH v6 02/11] drivers: of: add initialization code for static
 reserved memory
Date: Fri, 28 Feb 2014 14:42:47 +0100
Message-id: <1393594976-16728-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
References: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRW0iTYRyHfbfvtNXwc6l8jbIwYiHmCS9ecklEyGthBYIXeVFTh0puypai
	EjRFZS5PTHKWps5D1NAZy9OWlhtDzbDSqSM8p12o0w5rUTYlx+6e/8Pzu/pTbL4GE1DZsnsS
	uUycE0pwsfcH43PnZRo6OWq7/wjc14yR8HtpORt+e1YFYKvtAw5rnTocjnqGAHRWqzBoMuwC
	OFXqJOFgZSMJf82usaBxfR6HuopODNrNzQTssS2R8OWmhQW7HNMs2DZehkOPNgROOlwE7LZ1
	kLBO24PB8hEbCfcHjRjcslRgsLdxG4N6swfAzR8T2KUTqLulG6B/exqAtuvrALLXVLOQ6ckS
	iaqcZTgy6isJtDg/TKBXnQ/QwsE6G81OlOLI4Nliodr9KPTUXANQTZ8eIJcx5GbALa4oQ5KT
	XSCRR8bf4WYNt6qIvJHYwhLXGK4EM2FqwKEYOpaxGUpIHwczn5Z7CTXgUny6CzCGkia273jI
	YlabqljeiqCjGfWOmvByIK0DjKsF80ZseoVgVNO+6Bidysz1DByuKQqjzzKf2+O9mkcjxm6q
	Bl7N0KeZZo3Iqzl0IqPUruBe5h8mC38coA7w2oCfHgRJ8tPzFGmZ0pgIhViqyJdlRqTnSo3A
	90f3EOgau2AFNAVCj/LqEv2T+bi4QFEktQKGYocG8jZK6WQ+L0NcVCyR596W5+dIFFbAojgC
	Jbi+kzB/Kumcqb6vwc0ZTBMYhLrIvccXE9bDA3ln4lIDCkfFFVP9weHla/etk6JBm+NvvWCx
	N69FSD6KX08RpdS+aFxeDngttp3kqmJGcb/WuN0Gz++3lqDVrw1XlR3P1Zb0n1eK32x8FGrN
	EZfdwiR/zrtM/sy1G/bjd9vdA19CMUWWODqMLVeI/wPn6ImxpQIAAA==
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
Acked-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/fdt.c       |  131 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_fdt.h |    3 ++
 2 files changed, 134 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 758b4f8b30b7..819e11209718 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -440,6 +441,118 @@ struct boot_param_header *initial_boot_params;
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
+	while (len >= t_len) {
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
+/**
+ * __reserved_mem_check_root() - check if #size-cells, #address-cells provided
+ * in /reserved-memory matches the values supported by the current implementation,
+ * also check if ranges property has been provided
+ */
+static int __reserved_mem_check_root(unsigned long node)
+{
+	__be32 *prop;
+
+	prop = of_get_flat_dt_prop(node, "#size-cells", NULL);
+	if (!prop || be32_to_cpup(prop) != dt_root_size_cells)
+		return -EINVAL;
+
+	prop = of_get_flat_dt_prop(node, "#address-cells", NULL);
+	if (!prop || be32_to_cpup(prop) != dt_root_addr_cells)
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
@@ -856,6 +969,16 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
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
@@ -864,6 +987,14 @@ void * __init __weak early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
 	return __va(memblock_alloc(size, align));
 }
+#else
+int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
+					phys_addr_t size, bool nomap)
+{
+	pr_err("Reserved memory not supported, ignoring range 0x%llx - 0x%llx%s\n",
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

