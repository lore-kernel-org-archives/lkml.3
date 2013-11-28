Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab3K1CpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:45:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab3K1CpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:45:00 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        linux-arch@vger.kernel.org
Subject: [PATCH 1/4] Create generic early_ioremap() support
Date: Wed, 27 Nov 2013 21:44:36 -0500
Message-Id: <1385606679-30446-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1385606679-30446-1-git-send-email-msalter@redhat.com>
References: <1385606679-30446-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch copies generic bits of x86 early_ioremap() support
into a library for potential use by other architectures.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Ingo Molnar <mingo@kernel.org>
CC: linux-arch@vger.kernel.org
---
 include/asm-generic/early_ioremap.h |  40 ++++++
 lib/Kconfig                         |   3 +
 lib/Makefile                        |   1 +
 lib/early_ioremap.c                 | 243 ++++++++++++++++++++++++++++++++++++
 4 files changed, 287 insertions(+)
 create mode 100644 include/asm-generic/early_ioremap.h
 create mode 100644 lib/early_ioremap.c

diff --git a/include/asm-generic/early_ioremap.h b/include/asm-generic/early_ioremap.h
new file mode 100644
index 0000000..e26ce80
--- /dev/null
+++ b/include/asm-generic/early_ioremap.h
@@ -0,0 +1,40 @@
+#ifndef _ASM_EARLY_IOREMAP_H_
+#define _ASM_EARLY_IOREMAP_H_
+
+#include <linux/types.h>
+
+#ifdef CONFIG_GENERIC_EARLY_IOREMAP
+/*
+ * early_ioremap() and early_iounmap() are for temporary early boot-time
+ * mappings, before the real ioremap() is functional.
+ */
+extern void __iomem *early_ioremap(resource_size_t phys_addr,
+				   unsigned long size);
+extern void __iomem *early_memremap(resource_size_t phys_addr,
+				    unsigned long size);
+extern void early_iounmap(void __iomem *addr, unsigned long size);
+
+/* Arch-specific initialization */
+extern void early_ioremap_init(void);
+
+/* Generic initialization called by architecture code */
+extern void early_ioremap_setup(void);
+
+/*
+ * Called as last step in paging_init() so library can act
+ * accordingly for subsequent map/unmap requests.
+ */
+extern void early_ioremap_reset(void);
+
+/*
+ * Weak function called by early_ioremap_reset(). It does nothing, but
+ * architectures may provide their own version to do any needed cleanups.
+ */
+extern void early_ioremap_shutdown(void);
+#else
+static inline void early_ioremap_init(void) { }
+static inline void early_ioremap_setup(void) { }
+static inline void early_ioremap_reset(void) { }
+#endif
+
+#endif /* _ASM_EARLY_IOREMAP_H_ */
diff --git a/lib/Kconfig b/lib/Kconfig
index 991c98b..5ebee09 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -42,6 +42,9 @@ config GENERIC_IO
 	boolean
 	default n
 
+config GENERIC_EARLY_IOREMAP
+	bool
+
 config STMP_DEVICE
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index a459c31..2afe05d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -188,3 +188,4 @@ quiet_cmd_build_OID_registry = GEN     $@
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
diff --git a/lib/early_ioremap.c b/lib/early_ioremap.c
new file mode 100644
index 0000000..54623a7
--- /dev/null
+++ b/lib/early_ioremap.c
@@ -0,0 +1,243 @@
+/*
+ * Provide common bits of early_ioremap() support for architectures needing
+ * temporary mappings during boot before ioremap() is available.
+ *
+ * This is mostly a direct copy of the x86 early_ioremap implementation.
+ *
+ * (C) Copyright 1995 1996 Linus Torvalds
+ *
+ */
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <asm/fixmap.h>
+
+static int early_ioremap_debug __initdata;
+
+static int __init early_ioremap_debug_setup(char *str)
+{
+	early_ioremap_debug = 1;
+
+	return 0;
+}
+early_param("early_ioremap_debug", early_ioremap_debug_setup);
+
+static int after_paging_init __initdata;
+
+void __init __attribute__((weak)) early_ioremap_shutdown(void)
+{
+}
+
+void __init early_ioremap_reset(void)
+{
+	early_ioremap_shutdown();
+	after_paging_init = 1;
+}
+
+/*
+ * Generally, ioremap() is available after paging_init() has been called.
+ * Architectures wanting to allow early_ioremap after paging_init() can
+ * define __late_set_fixmap and __late_clear_fixmap to do the right thing.
+ */
+#ifndef __late_set_fixmap
+static inline void __init __late_set_fixmap(enum fixed_addresses idx,
+					    phys_addr_t phys, pgprot_t prot)
+{
+	BUG();
+}
+#endif
+
+#ifndef __late_clear_fixmap
+static inline void __init __late_clear_fixmap(enum fixed_addresses idx)
+{
+	BUG();
+}
+#endif
+
+static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
+static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
+static unsigned long slot_virt[FIX_BTMAPS_SLOTS] __initdata;
+
+void __init early_ioremap_setup(void)
+{
+	int i;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i]) {
+			WARN_ON(1);
+			break;
+		}
+	}
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
+}
+
+static int __init check_early_ioremap_leak(void)
+{
+	int count = 0;
+	int i;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		if (prev_map[i])
+			count++;
+
+	if (!count)
+		return 0;
+	WARN(1, KERN_WARNING
+	       "Debug warning: early ioremap leak of %d areas detected.\n",
+		count);
+	pr_warn("please boot with early_ioremap_debug and report the dmesg.\n");
+
+	return 1;
+}
+late_initcall(check_early_ioremap_leak);
+
+static void __init __iomem *
+__early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
+{
+	unsigned long offset;
+	resource_size_t last_addr;
+	unsigned int nrpages;
+	enum fixed_addresses idx;
+	int i, slot;
+
+	WARN_ON(system_state != SYSTEM_BOOTING);
+
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (!prev_map[i]) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot < 0) {
+		pr_info("%s(%08llx, %08lx) not found slot\n",
+			__func__, (u64)phys_addr, size);
+		WARN_ON(1);
+		return NULL;
+	}
+
+	if (early_ioremap_debug) {
+		pr_info("%s(%08llx, %08lx) [%d] => ",
+			__func__, (u64)phys_addr, size, slot);
+		dump_stack();
+	}
+
+	/* Don't allow wraparound or zero size */
+	last_addr = phys_addr + size - 1;
+	if (!size || last_addr < phys_addr) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	prev_size[slot] = size;
+	/*
+	 * Mappings have to be page-aligned
+	 */
+	offset = phys_addr & ~PAGE_MASK;
+	phys_addr &= PAGE_MASK;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
+
+	/*
+	 * Mappings have to fit in the FIX_BTMAP area.
+	 */
+	nrpages = size >> PAGE_SHIFT;
+	if (nrpages > NR_FIX_BTMAPS) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	/*
+	 * Ok, go for it..
+	 */
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
+	while (nrpages > 0) {
+		if (after_paging_init)
+			__late_set_fixmap(idx, phys_addr, prot);
+		else
+			__early_set_fixmap(idx, phys_addr, prot);
+		phys_addr += PAGE_SIZE;
+		--idx;
+		--nrpages;
+	}
+	if (early_ioremap_debug)
+		pr_cont("%08lx + %08lx\n", offset, slot_virt[slot]);
+
+	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
+	return prev_map[slot];
+}
+
+/* Remap an IO device */
+void __init __iomem *
+early_ioremap(resource_size_t phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size, FIXMAP_PAGE_IO);
+}
+
+/* Remap memory */
+void __init __iomem *
+early_memremap(resource_size_t phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size, FIXMAP_PAGE_NORMAL);
+}
+
+void __init early_iounmap(void __iomem *addr, unsigned long size)
+{
+	unsigned long virt_addr;
+	unsigned long offset;
+	unsigned int nrpages;
+	enum fixed_addresses idx;
+	int i, slot;
+
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i] == addr) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot < 0) {
+		pr_info("early_iounmap(%p, %08lx) not found slot\n",
+			addr, size);
+		WARN_ON(1);
+		return;
+	}
+
+	if (prev_size[slot] != size) {
+		pr_info("early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
+			addr, size, slot, prev_size[slot]);
+		WARN_ON(1);
+		return;
+	}
+
+	if (early_ioremap_debug) {
+		pr_info("early_iounmap(%p, %08lx) [%d]\n", addr,
+			size, slot);
+		dump_stack();
+	}
+
+	virt_addr = (unsigned long)addr;
+	if (virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)) {
+		WARN_ON(1);
+		return;
+	}
+	offset = virt_addr & ~PAGE_MASK;
+	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
+
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
+	while (nrpages > 0) {
+		if (after_paging_init)
+			__late_clear_fixmap(idx);
+		else
+			__early_set_fixmap(idx, 0, FIXMAP_PAGE_CLEAR);
+		--idx;
+		--nrpages;
+	}
+	prev_map[slot] = NULL;
+}
-- 
1.8.3.1

