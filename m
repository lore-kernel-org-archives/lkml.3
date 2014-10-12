Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaJLEv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 00:51:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:18556 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaJLEv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 00:51:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,703,1406617200"; 
   d="scan'208";a="604027242"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v9 01/12] x86, mpx: introduce VM_MPX to indicate that a VMA is MPX specific
Date: Sun, 12 Oct 2014 12:41:44 +0800
Message-Id: <1413088915-13428-2-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPX-enabled applications using large swaths of memory can potentially
have large numbers of bounds tables in process address space to save
bounds information. These tables can take up huge swaths of memory
(as much as 80% of the memory on the system) even if we clean them
up aggressively. In the worst-case scenario, the tables can be 4x the
size of the data structure being tracked. IOW, a 1-page structure can
require 4 bounds-table pages.

Being this huge, our expectation is that folks using MPX are going to
be keen on figuring out how much memory is being dedicated to it. So
we need a way to track memory use for MPX.

If we want to specifically track MPX VMAs we need to be able to
distinguish them from normal VMAs, and keep them from getting merged
with normal VMAs. A new VM_ flag set only on MPX VMAs does both of
those things. With this flag, MPX bounds-table VMAs can be distinguished
from other VMAs, and userspace can also walk /proc/$pid/smaps to get
memory usage for MPX.

Except this flag, we also introduce a specific ->vm_ops for MPX VMAs
(see the patch "add MPX specific mmap interface"), but currently vmas
with different ->vm_ops could be not prevented from merging. We
understand that VM_ flags are scarce and are open to other options.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 fs/proc/task_mmu.c |    1 +
 include/linux/mm.h |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index dfc791c..cc31520 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -549,6 +549,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_GROWSDOWN)]	= "gd",
 		[ilog2(VM_PFNMAP)]	= "pf",
 		[ilog2(VM_DENYWRITE)]	= "dw",
+		[ilog2(VM_MPX)]		= "mp",
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8981cc8..942be8a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -127,6 +127,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
+#define VM_ARCH_2	0x02000000
 #define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
@@ -154,6 +155,11 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
 #endif
 
+#if defined(CONFIG_X86)
+/* MPX specific bounds table or bounds directory */
+# define VM_MPX		VM_ARCH_2
+#endif
+
 #ifndef VM_GROWSUP
 # define VM_GROWSUP	VM_NONE
 #endif
-- 
1.7.1

