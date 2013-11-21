Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3KULT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:19:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:35937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab3KULT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:19:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,743,1378882800"; 
   d="scan'208";a="439129400"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-mm@kvack.org
In-Reply-To: <20131120144014.386293ce24e7b298ebab7b8e@linux-foundation.org>
References: <20131120174211.GF10323@ZenIV.linux.org.uk>
 <20131120174712.GG10323@ZenIV.linux.org.uk>
 <CA+55aFw_SuTAtTM0YTgiGf1pq4v4j5jbB1af=ExxjyFRbAJ4Ow@mail.gmail.com>
 <20131120144014.386293ce24e7b298ebab7b8e@linux-foundation.org>
Subject: Re: [git pull] vfs.git bits and pieces
Content-Transfer-Encoding: 7bit
Message-Id: <20131121111906.B97AEE0090@blue.fi.intel.com>
Date: Thu, 21 Nov 2013 13:19:06 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 20 Nov 2013 14:33:35 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Wed, Nov 20, 2013 at 9:47 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > BTW, something odd happened to mm/memory.c - either a mangled patch
> > > or a lost followup:
> > >
> > >     commit ea1e7ed33708
> > >     mm: create a separate slab for page->ptl allocation
> > >
> > > Fair enough, and yes, it does create that separate slab.  The problem is,
> > > it's still using kmalloc/kfree for those beasts - page_ptl_cachep isn't
> > > used at all...
> > 
> > Ok, it looks straightforward enough to just replace the kmalloc/kfree
> > with using a slab allocation using the page_ptl_cachep pointer. I'd do
> > it myself, but I would like to know how it got lost? Also, much
> > testing to make sure the cachep is initialized early enough.
> 
> agh, I went through hell keeping that patch alive and it appears I lost
> some of it.

Actually, I've lost it while adding BLOATED_SPINLOCKS :(

> > Or should we just revert the commit that added the pointless/unused
> > slab pointer?
> > 
> > Andrew, Kirill, comments?
> 
> Let's just kill it please.  We can try again for 3.14.

I'm okay with that.
Only side note: it's useful not only for debug case, but also for
PREEMPT_RT where spinlock_t is always bloated.

Fixed patch:

>From e624075b47caa2a15998225df7cec953d271b9ac Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Thu, 14 Nov 2013 14:31:53 -0800
Subject: [PATCH] mm: create a separate slab for page->ptl allocation, try two

If DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC are enabled spinlock_t on x86_64
is 72 bytes.  For page->ptl they will be allocated from kmalloc-96 slab,
so we loose 24 on each.  An average system can easily allocate few tens
thousands of page->ptl and overhead is significant.

Let's create a separate slab for page->ptl allocation to solve this.

To make sure that it really works this time, some numbers from my test
machine (just booted, no load):

Before:
  # grep '^\(kmalloc-96\|page->ptl\)' /proc/slabinfo
  kmalloc-96         31987  32190    128   30    1 : tunables  120   60    8 : slabdata   1073   1073     92
After:
  # grep '^\(kmalloc-96\|page->ptl\)' /proc/slabinfo
  page->ptl          27516  28143     72   53    1 : tunables  120   60    8 : slabdata    531    531      9
  kmalloc-96          3853   5280    128   30    1 : tunables  120   60    8 : slabdata    176    176      0

Note that the patch is useful not only for debug case, but also for
PREEMPT_RT, where spinlock_t is always bloated.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h |  9 +++++++++
 init/main.c        |  2 +-
 mm/memory.c        | 11 +++++++++--
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1cedd000cf29..0548eb201e05 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1318,6 +1318,7 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 
 #if USE_SPLIT_PTE_PTLOCKS
 #if BLOATED_SPINLOCKS
+void __init ptlock_cache_init(void);
 extern bool ptlock_alloc(struct page *page);
 extern void ptlock_free(struct page *page);
 
@@ -1326,6 +1327,7 @@ static inline spinlock_t *ptlock_ptr(struct page *page)
 	return page->ptl;
 }
 #else /* BLOATED_SPINLOCKS */
+static inline void ptlock_cache_init(void) {}
 static inline bool ptlock_alloc(struct page *page)
 {
 	return true;
@@ -1378,10 +1380,17 @@ static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
 	return &mm->page_table_lock;
 }
+static inline void ptlock_cache_init(void) {}
 static inline bool ptlock_init(struct page *page) { return true; }
 static inline void pte_lock_deinit(struct page *page) {}
 #endif /* USE_SPLIT_PTE_PTLOCKS */
 
+static inline void pgtable_init(void)
+{
+	ptlock_cache_init();
+	pgtable_cache_init();
+}
+
 static inline bool pgtable_page_ctor(struct page *page)
 {
 	inc_zone_page_state(page, NR_PAGETABLE);
diff --git a/init/main.c b/init/main.c
index febc511e078a..01573fdfa186 100644
--- a/init/main.c
+++ b/init/main.c
@@ -476,7 +476,7 @@ static void __init mm_init(void)
 	mem_init();
 	kmem_cache_init();
 	percpu_init_late();
-	pgtable_cache_init();
+	pgtable_init();
 	vmalloc_init();
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 5d9025f3b3e1..cf6098c10084 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4272,11 +4272,18 @@ void copy_user_huge_page(struct page *dst, struct page *src,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if USE_SPLIT_PTE_PTLOCKS && BLOATED_SPINLOCKS
+static struct kmem_cache *page_ptl_cachep;
+void __init ptlock_cache_init(void)
+{
+	page_ptl_cachep = kmem_cache_create("page->ptl", sizeof(spinlock_t), 0,
+			SLAB_PANIC, NULL);
+}
+
 bool ptlock_alloc(struct page *page)
 {
 	spinlock_t *ptl;
 
-	ptl = kmalloc(sizeof(spinlock_t), GFP_KERNEL);
+	ptl = kmem_cache_alloc(page_ptl_cachep, GFP_KERNEL);
 	if (!ptl)
 		return false;
 	page->ptl = ptl;
@@ -4285,6 +4292,6 @@ bool ptlock_alloc(struct page *page)
 
 void ptlock_free(struct page *page)
 {
-	kfree(page->ptl);
+	kmem_cache_free(page_ptl_cachep, page->ptl);
 }
 #endif
-- 
 Kirill A. Shutemov
