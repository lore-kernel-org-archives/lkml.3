Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaIFTjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 15:39:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25059 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaIFTju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 15:39:50 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: kirill.shutemov@linux.intel.com, khlebnikov@openvz.org, riel@redhat.com,
        mgorman@suse.de, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz,
        hughd@google.com, vbabka@suse.cz, walken@google.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 1/3] mm: move debug code out of page_alloc.c
Date: Sat,  6 Sep 2014 15:38:44 -0400
Message-Id: <1410032326-4380-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_page() and dump_vma() are not specific to page_alloc.c, move
them out so page_alloc.c won't turn into the unofficial debug
repository.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/Makefile     |    2 +-
 mm/debug.c      |  161 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c |  158 -----------------------------------------------------
 3 files changed, 162 insertions(+), 159 deletions(-)
 create mode 100644 mm/debug.c

diff --git a/mm/Makefile b/mm/Makefile
index b2f18dc..25fdc12 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -18,7 +18,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
 			   compaction.o vmacache.o \
 			   interval_tree.o list_lru.o workingset.o \
-			   iov_iter.o $(mmu-y)
+			   iov_iter.o debug.o $(mmu-y)
 
 obj-y += init-mm.o
 
diff --git a/mm/debug.c b/mm/debug.c
new file mode 100644
index 0000000..c19af12
--- /dev/null
+++ b/mm/debug.c
@@ -0,0 +1,161 @@
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/ftrace_event.h>
+#include <linux/memcontrol.h>
+
+static const struct trace_print_flags pageflag_names[] = {
+	{1UL << PG_locked,		"locked"	},
+	{1UL << PG_error,		"error"		},
+	{1UL << PG_referenced,		"referenced"	},
+	{1UL << PG_uptodate,		"uptodate"	},
+	{1UL << PG_dirty,		"dirty"		},
+	{1UL << PG_lru,			"lru"		},
+	{1UL << PG_active,		"active"	},
+	{1UL << PG_slab,		"slab"		},
+	{1UL << PG_owner_priv_1,	"owner_priv_1"	},
+	{1UL << PG_arch_1,		"arch_1"	},
+	{1UL << PG_reserved,		"reserved"	},
+	{1UL << PG_private,		"private"	},
+	{1UL << PG_private_2,		"private_2"	},
+	{1UL << PG_writeback,		"writeback"	},
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+	{1UL << PG_head,		"head"		},
+	{1UL << PG_tail,		"tail"		},
+#else
+	{1UL << PG_compound,		"compound"	},
+#endif
+	{1UL << PG_swapcache,		"swapcache"	},
+	{1UL << PG_mappedtodisk,	"mappedtodisk"	},
+	{1UL << PG_reclaim,		"reclaim"	},
+	{1UL << PG_swapbacked,		"swapbacked"	},
+	{1UL << PG_unevictable,		"unevictable"	},
+#ifdef CONFIG_MMU
+	{1UL << PG_mlocked,		"mlocked"	},
+#endif
+#ifdef CONFIG_ARCH_USES_PG_UNCACHED
+	{1UL << PG_uncached,		"uncached"	},
+#endif
+#ifdef CONFIG_MEMORY_FAILURE
+	{1UL << PG_hwpoison,		"hwpoison"	},
+#endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	{1UL << PG_compound_lock,	"compound_lock"	},
+#endif
+};
+
+static void dump_flags(unsigned long flags,
+			const struct trace_print_flags *names, int count)
+{
+	const char *delim = "";
+	unsigned long mask;
+	int i;
+
+	printk(KERN_ALERT "flags: %#lx(", flags);
+
+	/* remove zone id */
+	flags &= (1UL << NR_PAGEFLAGS) - 1;
+
+	for (i = 0; i < count && flags; i++) {
+
+		mask = names[i].mask;
+		if ((flags & mask) != mask)
+			continue;
+
+		flags &= ~mask;
+		printk("%s%s", delim, names[i].name);
+		delim = "|";
+	}
+
+	/* check for left over flags */
+	if (flags)
+		printk("%s%#lx", delim, flags);
+
+	printk(")\n");
+}
+
+void dump_page_badflags(struct page *page, const char *reason,
+		unsigned long badflags)
+{
+	printk(KERN_ALERT
+	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
+		page, atomic_read(&page->_count), page_mapcount(page),
+		page->mapping, page->index);
+	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
+	dump_flags(page->flags, pageflag_names, ARRAY_SIZE(pageflag_names));
+	if (reason)
+		pr_alert("page dumped because: %s\n", reason);
+	if (page->flags & badflags) {
+		pr_alert("bad because of flags:\n");
+		dump_flags(page->flags & badflags,
+				pageflag_names, ARRAY_SIZE(pageflag_names));
+	}
+	mem_cgroup_print_bad_page(page);
+}
+
+void dump_page(struct page *page, const char *reason)
+{
+	dump_page_badflags(page, reason, 0);
+}
+EXPORT_SYMBOL(dump_page);
+
+#ifdef CONFIG_DEBUG_VM
+
+static const struct trace_print_flags vmaflags_names[] = {
+	{VM_READ,			"read"		},
+	{VM_WRITE,			"write"		},
+	{VM_EXEC,			"exec"		},
+	{VM_SHARED,			"shared"	},
+	{VM_MAYREAD,			"mayread"	},
+	{VM_MAYWRITE,			"maywrite"	},
+	{VM_MAYEXEC,			"mayexec"	},
+	{VM_MAYSHARE,			"mayshare"	},
+	{VM_GROWSDOWN,			"growsdown"	},
+	{VM_PFNMAP,			"pfnmap"	},
+	{VM_DENYWRITE,			"denywrite"	},
+	{VM_LOCKED,			"locked"	},
+	{VM_IO,				"io"		},
+	{VM_SEQ_READ,			"seqread"	},
+	{VM_RAND_READ,			"randread"	},
+	{VM_DONTCOPY,			"dontcopy"	},
+	{VM_DONTEXPAND,			"dontexpand"	},
+	{VM_ACCOUNT,			"account"	},
+	{VM_NORESERVE,			"noreserve"	},
+	{VM_HUGETLB,			"hugetlb"	},
+	{VM_NONLINEAR,			"nonlinear"	},
+#if defined(CONFIG_X86)
+	{VM_PAT,			"pat"		},
+#elif defined(CONFIG_PPC)
+	{VM_SAO,			"sao"		},
+#elif defined(CONFIG_PARISC) || defined(CONFIG_METAG) || defined(CONFIG_IA64)
+	{VM_GROWSUP,			"growsup"	},
+#elif !defined(CONFIG_MMU)
+	{VM_MAPPED_COPY,		"mappedcopy"	},
+#else
+	{VM_ARCH_1,			"arch_1"	},
+#endif
+	{VM_DONTDUMP,			"dontdump"	},
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	{VM_SOFTDIRTY,			"softdirty"	},
+#endif
+	{VM_MIXEDMAP,			"mixedmap"	},
+	{VM_HUGEPAGE,			"hugepage"	},
+	{VM_NOHUGEPAGE,			"nohugepage"	},
+	{VM_MERGEABLE,			"mergeable"	},
+};
+
+void dump_vma(const struct vm_area_struct *vma)
+{
+	printk(KERN_ALERT
+		"vma %p start %p end %p\n"
+		"next %p prev %p mm %p\n"
+		"prot %lx anon_vma %p vm_ops %p\n"
+		"pgoff %lx file %p private_data %p\n",
+		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
+		vma->vm_prev, vma->vm_mm, vma->vm_page_prot.pgprot,
+		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
+		vma->vm_file, vma->vm_private_data);
+	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
+}
+EXPORT_SYMBOL(dump_vma);
+
+#endif		/* CONFIG_DEBUG_VM */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cb510c0..99b0558 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -53,8 +53,6 @@
 #include <linux/kmemleak.h>
 #include <linux/compaction.h>
 #include <trace/events/kmem.h>
-#include <linux/ftrace_event.h>
-#include <linux/memcontrol.h>
 #include <linux/prefetch.h>
 #include <linux/mm_inline.h>
 #include <linux/migrate.h>
@@ -6591,159 +6589,3 @@ bool is_free_buddy_page(struct page *page)
 }
 #endif
 
-static const struct trace_print_flags pageflag_names[] = {
-	{1UL << PG_locked,		"locked"	},
-	{1UL << PG_error,		"error"		},
-	{1UL << PG_referenced,		"referenced"	},
-	{1UL << PG_uptodate,		"uptodate"	},
-	{1UL << PG_dirty,		"dirty"		},
-	{1UL << PG_lru,			"lru"		},
-	{1UL << PG_active,		"active"	},
-	{1UL << PG_slab,		"slab"		},
-	{1UL << PG_owner_priv_1,	"owner_priv_1"	},
-	{1UL << PG_arch_1,		"arch_1"	},
-	{1UL << PG_reserved,		"reserved"	},
-	{1UL << PG_private,		"private"	},
-	{1UL << PG_private_2,		"private_2"	},
-	{1UL << PG_writeback,		"writeback"	},
-#ifdef CONFIG_PAGEFLAGS_EXTENDED
-	{1UL << PG_head,		"head"		},
-	{1UL << PG_tail,		"tail"		},
-#else
-	{1UL << PG_compound,		"compound"	},
-#endif
-	{1UL << PG_swapcache,		"swapcache"	},
-	{1UL << PG_mappedtodisk,	"mappedtodisk"	},
-	{1UL << PG_reclaim,		"reclaim"	},
-	{1UL << PG_swapbacked,		"swapbacked"	},
-	{1UL << PG_unevictable,		"unevictable"	},
-#ifdef CONFIG_MMU
-	{1UL << PG_mlocked,		"mlocked"	},
-#endif
-#ifdef CONFIG_ARCH_USES_PG_UNCACHED
-	{1UL << PG_uncached,		"uncached"	},
-#endif
-#ifdef CONFIG_MEMORY_FAILURE
-	{1UL << PG_hwpoison,		"hwpoison"	},
-#endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	{1UL << PG_compound_lock,	"compound_lock"	},
-#endif
-};
-
-static void dump_flags(unsigned long flags,
-			const struct trace_print_flags *names, int count)
-{
-	const char *delim = "";
-	unsigned long mask;
-	int i;
-
-	printk(KERN_ALERT "flags: %#lx(", flags);
-
-	/* remove zone id */
-	flags &= (1UL << NR_PAGEFLAGS) - 1;
-
-	for (i = 0; i < count && flags; i++) {
-
-		mask = names[i].mask;
-		if ((flags & mask) != mask)
-			continue;
-
-		flags &= ~mask;
-		printk("%s%s", delim, names[i].name);
-		delim = "|";
-	}
-
-	/* check for left over flags */
-	if (flags)
-		printk("%s%#lx", delim, flags);
-
-	printk(")\n");
-}
-
-void dump_page_badflags(struct page *page, const char *reason,
-		unsigned long badflags)
-{
-	printk(KERN_ALERT
-	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
-		page, atomic_read(&page->_count), page_mapcount(page),
-		page->mapping, page->index);
-	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
-	dump_flags(page->flags, pageflag_names, ARRAY_SIZE(pageflag_names));
-	if (reason)
-		pr_alert("page dumped because: %s\n", reason);
-	if (page->flags & badflags) {
-		pr_alert("bad because of flags:\n");
-		dump_flags(page->flags & badflags,
-				pageflag_names, ARRAY_SIZE(pageflag_names));
-	}
-	mem_cgroup_print_bad_page(page);
-}
-
-void dump_page(struct page *page, const char *reason)
-{
-	dump_page_badflags(page, reason, 0);
-}
-EXPORT_SYMBOL(dump_page);
-
-#ifdef CONFIG_DEBUG_VM
-
-static const struct trace_print_flags vmaflags_names[] = {
-	{VM_READ,			"read"		},
-	{VM_WRITE,			"write"		},
-	{VM_EXEC,			"exec"		},
-	{VM_SHARED,			"shared"	},
-	{VM_MAYREAD,			"mayread"	},
-	{VM_MAYWRITE,			"maywrite"	},
-	{VM_MAYEXEC,			"mayexec"	},
-	{VM_MAYSHARE,			"mayshare"	},
-	{VM_GROWSDOWN,			"growsdown"	},
-	{VM_PFNMAP,			"pfnmap"	},
-	{VM_DENYWRITE,			"denywrite"	},
-	{VM_LOCKED,			"locked"	},
-	{VM_IO,				"io"		},
-	{VM_SEQ_READ,			"seqread"	},
-	{VM_RAND_READ,			"randread"	},
-	{VM_DONTCOPY,			"dontcopy"	},
-	{VM_DONTEXPAND,			"dontexpand"	},
-	{VM_ACCOUNT,			"account"	},
-	{VM_NORESERVE,			"noreserve"	},
-	{VM_HUGETLB,			"hugetlb"	},
-	{VM_NONLINEAR,			"nonlinear"	},
-#if defined(CONFIG_X86)
-	{VM_PAT,			"pat"		},
-#elif defined(CONFIG_PPC)
-	{VM_SAO,			"sao"		},
-#elif defined(CONFIG_PARISC) || defined(CONFIG_METAG) || defined(CONFIG_IA64)
-	{VM_GROWSUP,			"growsup"	},
-#elif !defined(CONFIG_MMU)
-	{VM_MAPPED_COPY,		"mappedcopy"	},
-#else
-	{VM_ARCH_1,			"arch_1"	},
-#endif
-	{VM_DONTDUMP,			"dontdump"	},
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	{VM_SOFTDIRTY,			"softdirty"	},
-#endif
-	{VM_MIXEDMAP,			"mixedmap"	},
-	{VM_HUGEPAGE,			"hugepage"	},
-	{VM_NOHUGEPAGE,			"nohugepage"	},
-	{VM_MERGEABLE,			"mergeable"	},
-};
-
-void dump_vma(const struct vm_area_struct *vma)
-{
-	printk(KERN_ALERT
-		"vma %p start %p end %p\n"
-		"next %p prev %p mm %p\n"
-		"prot %lx anon_vma %p vm_ops %p\n"
-		"pgoff %lx file %p private_data %p\n",
-		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
-		vma->vm_prev, vma->vm_mm, vma->vm_page_prot.pgprot,
-		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
-		vma->vm_file, vma->vm_private_data);
-	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
-}
-EXPORT_SYMBOL(dump_vma);
-
-#endif		/* CONFIG_DEBUG_VM */
-- 
1.7.10.4

