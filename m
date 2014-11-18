Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaKRAHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:07:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49011 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaKRAHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:07:05 -0500
Date: Mon, 17 Nov 2014 16:06:54 -0800
From: tip-bot for Qiaowei Ren <tipbot@zytor.com>
Message-ID: <tip-57319d80e1d328e34cb24868a4f4405661485e30@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, dave@sr71.net, qiaowei.ren@intel.com,
        hpa@zytor.com, dave.hansen@linux.intel.com, tglx@linutronix.de,
        mingo@kernel.org
Reply-To: mingo@kernel.org, tglx@linutronix.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, qiaowei.ren@intel.com, dave@sr71.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <20141114151827.CE440F67@viggo.jf.intel.com>
References: <20141114151827.CE440F67@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86, mpx: Add MPX-specific mmap interface
Git-Commit-ID: 57319d80e1d328e34cb24868a4f4405661485e30
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57319d80e1d328e34cb24868a4f4405661485e30
Gitweb:     http://git.kernel.org/tip/57319d80e1d328e34cb24868a4f4405661485e30
Author:     Qiaowei Ren <qiaowei.ren@intel.com>
AuthorDate: Fri, 14 Nov 2014 07:18:27 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 00:58:53 +0100

x86, mpx: Add MPX-specific mmap interface

We have chosen to perform the allocation of bounds tables in
kernel (See the patch "on-demand kernel allocation of bounds
tables") and to mark these VMAs with VM_MPX.

However, there is currently no suitable interface to actually do
this.  Existing interfaces, like do_mmap_pgoff(), have no way to
set a modified ->vm_ops or ->vm_flags and don't hold mmap_sem
long enough to let a caller do it.

This patch wraps mmap_region() and hold mmap_sem long enough to
make the modifications to the VMA which we need.

Also note the 32/64-bit #ifdef in the header.  We actually need
to do this at runtime eventually.  But, for now, we don't support
running 32-bit binaries on 64-bit kernels.  Support for this will
come in later patches.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-mm@kvack.org
Cc: linux-mips@linux-mips.org
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20141114151827.CE440F67@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig           |  4 +++
 arch/x86/include/asm/mpx.h | 36 +++++++++++++++++++
 arch/x86/mm/Makefile       |  2 ++
 arch/x86/mm/mpx.c          | 86 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 128 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a67..967dfe0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -248,6 +248,10 @@ config HAVE_INTEL_TXT
 	def_bool y
 	depends on INTEL_IOMMU && ACPI
 
+config X86_INTEL_MPX
+	def_bool y
+	depends on CPU_SUP_INTEL
+
 config X86_32_SMP
 	def_bool y
 	depends on X86_32 && SMP
diff --git a/arch/x86/include/asm/mpx.h b/arch/x86/include/asm/mpx.h
new file mode 100644
index 0000000..7d7c5f5
--- /dev/null
+++ b/arch/x86/include/asm/mpx.h
@@ -0,0 +1,36 @@
+#ifndef _ASM_X86_MPX_H
+#define _ASM_X86_MPX_H
+
+#include <linux/types.h>
+#include <asm/ptrace.h>
+
+#ifdef CONFIG_X86_64
+
+/* upper 28 bits [47:20] of the virtual address in 64-bit used to
+ * index into bounds directory (BD).
+ */
+#define MPX_BD_ENTRY_OFFSET	28
+#define MPX_BD_ENTRY_SHIFT	3
+/* bits [19:3] of the virtual address in 64-bit used to index into
+ * bounds table (BT).
+ */
+#define MPX_BT_ENTRY_OFFSET	17
+#define MPX_BT_ENTRY_SHIFT	5
+#define MPX_IGN_BITS		3
+
+#else
+
+#define MPX_BD_ENTRY_OFFSET	20
+#define MPX_BD_ENTRY_SHIFT	2
+#define MPX_BT_ENTRY_OFFSET	10
+#define MPX_BT_ENTRY_SHIFT	4
+#define MPX_IGN_BITS		2
+
+#endif
+
+#define MPX_BD_SIZE_BYTES (1UL<<(MPX_BD_ENTRY_OFFSET+MPX_BD_ENTRY_SHIFT))
+#define MPX_BT_SIZE_BYTES (1UL<<(MPX_BT_ENTRY_OFFSET+MPX_BT_ENTRY_SHIFT))
+
+#define MPX_BNDSTA_ERROR_CODE	0x3
+
+#endif /* _ASM_X86_MPX_H */
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 6a19ad9..ecfdc46 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -30,3 +30,5 @@ obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
 obj-$(CONFIG_MEMTEST)		+= memtest.o
+
+obj-$(CONFIG_X86_INTEL_MPX)	+= mpx.o
diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
new file mode 100644
index 0000000..72d13b0
--- /dev/null
+++ b/arch/x86/mm/mpx.c
@@ -0,0 +1,86 @@
+/*
+ * mpx.c - Memory Protection eXtensions
+ *
+ * Copyright (c) 2014, Intel Corporation.
+ * Qiaowei Ren <qiaowei.ren@intel.com>
+ * Dave Hansen <dave.hansen@intel.com>
+ */
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+#include <linux/sched/sysctl.h>
+
+#include <asm/mman.h>
+#include <asm/mpx.h>
+
+static const char *mpx_mapping_name(struct vm_area_struct *vma)
+{
+	return "[mpx]";
+}
+
+static struct vm_operations_struct mpx_vma_ops = {
+	.name = mpx_mapping_name,
+};
+
+/*
+ * This is really a simplified "vm_mmap". it only handles MPX
+ * bounds tables (the bounds directory is user-allocated).
+ *
+ * Later on, we use the vma->vm_ops to uniquely identify these
+ * VMAs.
+ */
+static unsigned long mpx_mmap(unsigned long len)
+{
+	unsigned long ret;
+	unsigned long addr, pgoff;
+	struct mm_struct *mm = current->mm;
+	vm_flags_t vm_flags;
+	struct vm_area_struct *vma;
+
+	/* Only bounds table and bounds directory can be allocated here */
+	if (len != MPX_BD_SIZE_BYTES && len != MPX_BT_SIZE_BYTES)
+		return -EINVAL;
+
+	down_write(&mm->mmap_sem);
+
+	/* Too many mappings? */
+	if (mm->map_count > sysctl_max_map_count) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Obtain the address to map to. we verify (or select) it and ensure
+	 * that it represents a valid section of the address space.
+	 */
+	addr = get_unmapped_area(NULL, 0, len, 0, MAP_ANONYMOUS | MAP_PRIVATE);
+	if (addr & ~PAGE_MASK) {
+		ret = addr;
+		goto out;
+	}
+
+	vm_flags = VM_READ | VM_WRITE | VM_MPX |
+			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
+
+	/* Set pgoff according to addr for anon_vma */
+	pgoff = addr >> PAGE_SHIFT;
+
+	ret = mmap_region(NULL, addr, len, vm_flags, pgoff);
+	if (IS_ERR_VALUE(ret))
+		goto out;
+
+	vma = find_vma(mm, ret);
+	if (!vma) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	vma->vm_ops = &mpx_vma_ops;
+
+	if (vm_flags & VM_LOCKED) {
+		up_write(&mm->mmap_sem);
+		mm_populate(ret, len);
+		return ret;
+	}
+
+out:
+	up_write(&mm->mmap_sem);
+	return ret;
+}
