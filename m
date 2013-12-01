Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3LALax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 06:30:53 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:53230 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3LALau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 06:30:50 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v3 2/2] m68k: Add support to export bootinfo in procfs
Date: Sun,  1 Dec 2013 12:30:35 +0100
Message-Id: <1385897435-18618-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385897435-18618-1-git-send-email-geert@linux-m68k.org>
References: <1385897435-18618-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add optional support to export the bootinfo used to boot the kernel in a
"bootinfo" file in procfs.  This is useful with kexec.

This is based on the similar feature for ATAGS on ARM.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2:
  - No changes
v3:
  - Rebased on top of current m68k tree

 arch/m68k/Kconfig                |    7 ++++
 arch/m68k/include/asm/bootinfo.h |   12 ++++++
 arch/m68k/kernel/Makefile        |    1 +
 arch/m68k/kernel/bootinfo_proc.c |   80 ++++++++++++++++++++++++++++++++++++++
 arch/m68k/kernel/setup_mm.c      |    2 +
 5 files changed, 102 insertions(+)
 create mode 100644 arch/m68k/kernel/bootinfo_proc.c

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 178dffa9de80..dbdd2231c75d 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -104,6 +104,13 @@ config KEXEC
 	  interface is strongly in flux, so no good recommendation can be
 	  made.
 
+config BOOTINFO_PROC
+	bool "Export bootinfo in procfs"
+	depends on KEXEC && M68KCLASSIC
+	help
+	  Say Y to export the bootinfo used to boot the kernel in a
+	  "bootinfo" file in procfs.  This is useful with kexec.
+
 menu "Platform setup"
 
 source arch/m68k/Kconfig.cpu
diff --git a/arch/m68k/include/asm/bootinfo.h b/arch/m68k/include/asm/bootinfo.h
index 9edc31893fb8..8e213267f8e7 100644
--- a/arch/m68k/include/asm/bootinfo.h
+++ b/arch/m68k/include/asm/bootinfo.h
@@ -13,4 +13,16 @@
 
 #include <uapi/asm/bootinfo.h>
 
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_BOOTINFO_PROC
+extern void save_bootinfo(const struct bi_record *bi);
+#else
+static inline void save_bootinfo(const struct bi_record *bi) {}
+#endif
+
+#endif /* __ASSEMBLY__ */
+
+
 #endif /* _M68K_BOOTINFO_H */
diff --git a/arch/m68k/kernel/Makefile b/arch/m68k/kernel/Makefile
index 7ee5f00a9abb..2d5d9be16273 100644
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -23,4 +23,5 @@ obj-$(CONFIG_PCI) += pcibios.o
 obj-$(CONFIG_HAS_DMA)	+= dma.o
 
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_BOOTINFO_PROC)	+= bootinfo_proc.o
 
diff --git a/arch/m68k/kernel/bootinfo_proc.c b/arch/m68k/kernel/bootinfo_proc.c
new file mode 100644
index 000000000000..7ee853e1432b
--- /dev/null
+++ b/arch/m68k/kernel/bootinfo_proc.c
@@ -0,0 +1,80 @@
+/*
+ * Based on arch/arm/kernel/atags_proc.c
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/printk.h>
+#include <linux/proc_fs.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include <asm/bootinfo.h>
+#include <asm/byteorder.h>
+
+
+static char bootinfo_tmp[1536] __initdata;
+
+static void *bootinfo_copy;
+static size_t bootinfo_size;
+
+static ssize_t bootinfo_read(struct file *file, char __user *buf,
+			  size_t count, loff_t *ppos)
+{
+	return simple_read_from_buffer(buf, count, ppos, bootinfo_copy,
+				       bootinfo_size);
+}
+
+static const struct file_operations bootinfo_fops = {
+	.read = bootinfo_read,
+	.llseek = default_llseek,
+};
+
+void __init save_bootinfo(const struct bi_record *bi)
+{
+	const void *start = bi;
+	size_t size = sizeof(bi->tag);
+
+	while (be16_to_cpu(bi->tag) != BI_LAST) {
+		uint16_t n = be16_to_cpu(bi->size);
+		size += n;
+		bi = (struct bi_record *)((unsigned long)bi + n);
+	}
+
+	if (size > sizeof(bootinfo_tmp)) {
+		pr_err("Cannot save %zu bytes of bootinfo\n", size);
+		return;
+	}
+
+	pr_info("Saving %zu bytes of bootinfo\n", size);
+	memcpy(bootinfo_tmp, start, size);
+	bootinfo_size = size;
+}
+
+static int __init init_bootinfo_procfs(void)
+{
+	/*
+	 * This cannot go into save_bootinfo() because kmalloc and proc don't
+	 * work yet when it is called.
+	 */
+	struct proc_dir_entry *pde;
+
+	if (!bootinfo_size)
+		return -EINVAL;
+
+	bootinfo_copy = kmalloc(bootinfo_size, GFP_KERNEL);
+	if (!bootinfo_copy)
+		return -ENOMEM;
+
+	memcpy(bootinfo_copy, bootinfo_tmp, bootinfo_size);
+
+	pde = proc_create_data("bootinfo", 0400, NULL, &bootinfo_fops, NULL);
+	if (!pde) {
+		kfree(bootinfo_copy);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+arch_initcall(init_bootinfo_procfs);
diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index 28abca421974..5b8ec4d5f8e8 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -146,6 +146,8 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 {
 	uint16_t tag;
 
+	save_bootinfo(record);
+
 	while ((tag = be16_to_cpu(record->tag)) != BI_LAST) {
 		int unknown = 0;
 		const void *data = record->data;
-- 
1.7.9.5

