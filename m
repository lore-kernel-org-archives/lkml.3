Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966080AbaFRJvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:51:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:24690 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965513AbaFRJsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:48:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,499,1400050800"; 
   d="scan'208";a="530353737"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v6 01/10] x86, mpx: introduce VM_MPX to indicate that a VMA is MPX specific
Date: Wed, 18 Jun 2014 17:44:07 +0800
Message-Id: <1403084656-27284-2-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPX-enabled application will possibly create a lot of bounds tables
in process address space to save bounds information. These tables
can take up huge swaths of memory (as much as 80% of the memory on
the system) even if we clean them up aggressively. Being this huge,
we need a way to track their memory use. If we want to track them,
we essentially have two options:

1. walk the multi-GB (in virtual space) bounds directory to locate
   all the VMAs and walk them
2. Find a way to distinguish MPX bounds-table VMAs from normal
   anonymous VMAs and use some existing mechanism to walk them

We expect (1) will be prohibitively expensive. For (2), we only
need a single bit, and we've chosen to use a VM_ flag.  We understand
that they are scarce and are open to other options.

There is one potential hybrid approach: check the bounds directory
entry for any anonymous VMA that could possibly contain a bounds table.
This is less expensive than (1), but still requires reading a pointer
out of userspace for every VMA that we iterate over.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/mm/init_64.c |    2 ++
 fs/proc/task_mmu.c    |    1 +
 include/linux/mm.h    |    2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f35c66c..2d41679 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1223,6 +1223,8 @@ int in_gate_area_no_mm(unsigned long addr)
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
+	if (vma->vm_flags & VM_MPX)
+		return "[mpx]";
 	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
 		return "[vdso]";
 	if (vma == &gate_vma)
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 442177b..09266bd 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -543,6 +543,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_GROWSDOWN)]	= "gd",
 		[ilog2(VM_PFNMAP)]	= "pf",
 		[ilog2(VM_DENYWRITE)]	= "dw",
+		[ilog2(VM_MPX)]		= "mp",
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d677706..029c716 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -127,6 +127,8 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
+/* MPX specific bounds table or bounds directory (x86) */
+#define VM_MPX		0x02000000
 #define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-- 
1.7.1

