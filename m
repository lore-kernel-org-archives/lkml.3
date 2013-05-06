Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3EFT5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab3EFT5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:57:20 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org
Cc: Isaku Yamahata <yamahata@valinux.co.jp>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 1/4] mm: madvise MADV_USERFAULT
Date: Mon,  6 May 2013 21:56:58 +0200
Message-Id: <1367870221-12676-2-git-send-email-aarcange@redhat.com>
In-Reply-To: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MADV_USERFAULT is a new madvise flag that will set VM_USERFAULT in the
vma flags. Whenever VM_USERFAULT is set in an anonymous vma, if
userland touches a still unmapped virtual address, a sigbus signal is
sent instead of allocating a new page. The sigbus signal handler will
then resolve the page fault in userland by calling the remap_anon_pages
syscall.

This functionality is needed to reliably implement postcopy live
migration in KVM (without having to use a special chardevice that
would disable all advanced Linux VM features, like swapping, KSM, THP,
automatic NUMA balancing, etc...).

MADV_USERFAULT could also be used to offload parts of anonymous memory
regions to remote nodes or to implement network distributed shared
memory.

Here I enlarged the vm_flags to 64bit as we run out of bits (noop on
64bit kernels). An alternative is to find some combination of flags
that are mutually exclusive if set.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/alpha/include/uapi/asm/mman.h     |  3 +++
 arch/mips/include/uapi/asm/mman.h      |  3 +++
 arch/parisc/include/uapi/asm/mman.h    |  3 +++
 arch/xtensa/include/uapi/asm/mman.h    |  3 +++
 include/linux/mm.h                     |  1 +
 include/linux/mm_types.h               |  2 +-
 include/uapi/asm-generic/mman-common.h |  3 +++
 mm/huge_memory.c                       | 34 ++++++++++++++++++++++++----------
 mm/madvise.c                           | 16 ++++++++++++++++
 mm/memory.c                            | 10 ++++++++++
 10 files changed, 67 insertions(+), 11 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
index 0086b47..a10313c 100644
--- a/arch/alpha/include/uapi/asm/mman.h
+++ b/arch/alpha/include/uapi/asm/mman.h
@@ -60,6 +60,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
+#define MADV_USERFAULT	18		/* Trigger user faults if not mapped */
+#define MADV_NOUSERFAULT 19		/* Don't trigger user faults */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/arch/mips/include/uapi/asm/mman.h b/arch/mips/include/uapi/asm/mman.h
index cfcb876..d9d11a4 100644
--- a/arch/mips/include/uapi/asm/mman.h
+++ b/arch/mips/include/uapi/asm/mman.h
@@ -84,6 +84,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
+#define MADV_USERFAULT	18		/* Trigger user faults if not mapped */
+#define MADV_NOUSERFAULT 19		/* Don't trigger user faults */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
index 294d251..7bc7b7b 100644
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -66,6 +66,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
 
+#define MADV_USERFAULT	71		/* Trigger user faults if not mapped */
+#define MADV_NOUSERFAULT 72		/* Don't trigger user faults */
+
 /* compatibility flags */
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
index 00eed67..5448d88 100644
--- a/arch/xtensa/include/uapi/asm/mman.h
+++ b/arch/xtensa/include/uapi/asm/mman.h
@@ -90,6 +90,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
+#define MADV_USERFAULT	18		/* Trigger user faults if not mapped */
+#define MADV_NOUSERFAULT 19		/* Don't trigger user faults */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c05d7cf..f5a410e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -110,6 +110,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
 #define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
 #define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
+#define VM_USERFAULT	0x100000000	/* Trigger user faults if not mapped */
 
 #if defined(CONFIG_X86)
 # define VM_PAT		VM_ARCH_1	/* PAT reserves whole VMA at once (x86) */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ace9a5f..bed1c7c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -198,7 +198,7 @@ struct page_frag {
 #endif
 };
 
-typedef unsigned long __nocast vm_flags_t;
+typedef unsigned long long __nocast vm_flags_t;
 
 /*
  * A region containing a mapping of a non-memory backed file under NOMMU
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index 4164529..43f36c0 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -52,6 +52,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
+#define MADV_USERFAULT	18		/* Trigger user faults if not mapped */
+#define MADV_NOUSERFAULT 19		/* Don't trigger user faults */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 03a89a2..f46aad1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -727,6 +727,11 @@ static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 		pte_free(mm, pgtable);
 	} else {
 		pmd_t entry;
+
+		/* Deliver the page fault to userland */
+		if (vma->vm_flags & VM_USERFAULT)
+			goto do_sigbus;
+
 		entry = mk_huge_pmd(page, vma);
 		page_add_new_anon_rmap(page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
@@ -737,6 +742,9 @@ static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 	}
 
 	return 0;
+do_sigbus:
+	spin_unlock(&mm->page_table_lock);
+	return VM_FAULT_SIGBUS;
 }
 
 static inline gfp_t alloc_hugepage_gfpmask(int defrag, gfp_t extra_gfp)
@@ -761,20 +769,17 @@ static inline struct page *alloc_hugepage(int defrag)
 }
 #endif
 
-static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		struct page *zero_page)
 {
 	pmd_t entry;
-	if (!pmd_none(*pmd))
-		return false;
 	entry = mk_pmd(zero_page, vma->vm_page_prot);
 	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	set_pmd_at(mm, haddr, pmd, entry);
 	pgtable_trans_huge_deposit(mm, pgtable);
 	mm->nr_ptes++;
-	return true;
 }
 
 int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -794,6 +799,7 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				transparent_hugepage_use_zero_page()) {
 			pgtable_t pgtable;
 			struct page *zero_page;
+			int ret;
 			bool set;
 			pgtable = pte_alloc_one(mm, haddr);
 			if (unlikely(!pgtable))
@@ -805,14 +811,24 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				goto out;
 			}
 			spin_lock(&mm->page_table_lock);
-			set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
-					zero_page);
+			ret = 0;
+			set = false;
+			if (pmd_none(*pmd)) {
+				if (vma->vm_flags & VM_USERFAULT)
+					ret = VM_FAULT_SIGBUS;
+				else {
+					set_huge_zero_page(pgtable, mm, vma,
+							   haddr, pmd,
+							   zero_page);
+					set = true;
+				}
+			}
 			spin_unlock(&mm->page_table_lock);
 			if (!set) {
 				pte_free(mm, pgtable);
 				put_huge_zero_page();
 			}
-			return 0;
+			return ret;
 		}
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
 					  vma, haddr, numa_node_id(), 0);
@@ -886,16 +902,14 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 */
 	if (is_huge_zero_pmd(pmd)) {
 		struct page *zero_page;
-		bool set;
 		/*
 		 * get_huge_zero_page() will never allocate a new page here,
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
 		zero_page = get_huge_zero_page();
-		set = set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
+		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
 				zero_page);
-		BUG_ON(!set); /* unexpected !pmd_none(dst_pmd) */
 		ret = 0;
 		goto out_unlock;
 	}
diff --git a/mm/madvise.c b/mm/madvise.c
index 7055883..2ecab73 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -93,6 +93,21 @@ static long madvise_behavior(struct vm_area_struct * vma,
 		if (error)
 			goto out;
 		break;
+	case MADV_USERFAULT:
+		if (vma->vm_ops) {
+			error = -EINVAL;
+			goto out;
+		}
+		new_flags |= VM_USERFAULT;
+		break;
+	case MADV_NOUSERFAULT:
+		if (vma->vm_ops) {
+			WARN_ON(new_flags & VM_USERFAULT);
+			error = -EINVAL;
+			goto out;
+		}
+		new_flags &= ~VM_USERFAULT;
+		break;
 	}
 
 	if (new_flags == vma->vm_flags) {
@@ -405,6 +420,7 @@ madvise_behavior_valid(int behavior)
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
 #endif
+	case MADV_USERFAULT:
 	case MADV_DONTDUMP:
 	case MADV_DODUMP:
 		return 1;
diff --git a/mm/memory.c b/mm/memory.c
index f7a1fba..044a57c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3235,6 +3235,9 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 		if (!pte_none(*page_table))
 			goto unlock;
+		/* Deliver the page fault to userland, check inside PT lock */
+		if (vma->vm_flags & VM_USERFAULT)
+			goto sigbus;
 		goto setpte;
 	}
 
@@ -3262,6 +3265,10 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (!pte_none(*page_table))
 		goto release;
 
+	/* Deliver the page fault to userland, check inside PT lock */
+	if (vma->vm_flags & VM_USERFAULT)
+		goto sigbus;
+
 	inc_mm_counter_fast(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, address);
 setpte:
@@ -3280,6 +3287,9 @@ oom_free_page:
 	page_cache_release(page);
 oom:
 	return VM_FAULT_OOM;
+sigbus:
+	pte_unmap_unlock(page_table, ptl);
+	return VM_FAULT_SIGBUS;
 }
 
 /*
