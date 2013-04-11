Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3DKNQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:16:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:45340 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab3DKNQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:16:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,455,1363158000"; 
   d="scan'208";a="284781628"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@sr71.net>
In-Reply-To: <20130410080202.GB21292@blaptop>
References: <51559150.3040407@oracle.com>
 <20130410080202.GB21292@blaptop>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
Content-Transfer-Encoding: 7bit
Message-Id: <20130411131813.17FD7E0085@blue.fi.intel.com>
Date: Thu, 11 Apr 2013 16:18:13 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:
> On Fri, Mar 29, 2013 at 09:04:16AM -0400, Sasha Levin wrote:
> > Hi all,
> > 
> > While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
> > I've stumbled on the following.
> > 
> > It seems that the code in do_huge_pmd_wp_page() was recently modified in
> > "thp: do_huge_pmd_wp_page(): handle huge zero page".
> > 
> > Here's the trace:
> > 
> > [  246.244708] BUG: unable to handle kernel paging request at ffff88009c422000
> > [  246.245743] IP: [<ffffffff81a0a795>] copy_page_rep+0x5/0x10
> > [  246.250569] PGD 7232067 PUD 7235067 PMD bfefe067 PTE 800000009c422060
> > [  246.251529] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > [  246.252325] Dumping ftrace buffer:
> > [  246.252791]    (ftrace buffer empty)
> > [  246.252869] Modules linked in:
> > [  246.252869] CPU 3
> > [  246.252869] Pid: 11985, comm: trinity-child12 Tainted: G        W    3.9.0-rc4-next-20130328-sasha-00014-g91a3267 #319
> > [  246.252869] RIP: 0010:[<ffffffff81a0a795>]  [<ffffffff81a0a795>] copy_page_rep+0x5/0x10
> > [  246.252869] RSP: 0018:ffff88000015bc40  EFLAGS: 00010286
> > [  246.252869] RAX: ffff88000015bfd8 RBX: 0000000002710880 RCX: 0000000000000200
> > [  246.252869] RDX: 0000000000000000 RSI: ffff88009c422000 RDI: ffff88009a422000
> > [  246.252869] RBP: ffff88000015bc98 R08: 0000000002718000 R09: 0000000000000001
> > [  246.252869] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880000000000
> > [  246.252869] R13: ffff88000015bfd8 R14: ffff88000015bfd8 R15: fffffffffff80000
> > [  246.252869] FS:  00007f53db93f700(0000) GS:ffff8800bba00000(0000) knlGS:0000000000000000
> > [  246.252869] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  246.252869] CR2: ffff88009c422000 CR3: 0000000000159000 CR4: 00000000000406e0
> > [  246.252869] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  246.252869] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [  246.252869] Process trinity-child12 (pid: 11985, threadinfo ffff88000015a000, task ffff88009c60b000)
> > [  246.252869] Stack:
> > [  246.252869]  ffffffff81234aae ffff88000015bc88 ffffffff81273639 0000000000a00000
> > [  246.252869]  0000000002718000 ffff8800ab36d050 ffff880000153800 ffffea0002690000
> > [  246.252869]  0000000000a00000 ffff8800ab36d000 ffffea0002710000 ffff88000015bd48
> > [  246.252869] Call Trace:
> > [  246.252869]  [<ffffffff81234aae>] ? copy_user_huge_page+0x1de/0x240
> > [  246.252869]  [<ffffffff81273639>] ? mem_cgroup_charge_common+0xa9/0xc0
> > [  246.252869]  [<ffffffff8126b4d7>] do_huge_pmd_wp_page+0x9f7/0xc60
> > [  246.252869]  [<ffffffff81a0acd9>] ? __const_udelay+0x29/0x30
> > [  246.252869]  [<ffffffff8123364e>] handle_mm_fault+0x26e/0x650
> > [  246.252869]  [<ffffffff8117dc1a>] ? __lock_is_held+0x5a/0x80
> > [  246.252869]  [<ffffffff83db3814>] ? __do_page_fault+0x514/0x5e0
> > [  246.252869]  [<ffffffff83db3870>] __do_page_fault+0x570/0x5e0
> > [  246.252869]  [<ffffffff811c6500>] ? rcu_eqs_exit_common+0x60/0x260
> > [  246.252869]  [<ffffffff811c740e>] ? rcu_eqs_enter_common+0x33e/0x3b0
> > [  246.252869]  [<ffffffff811c679c>] ? rcu_eqs_exit+0x9c/0xb0
> > [  246.252869]  [<ffffffff83db3912>] do_page_fault+0x32/0x50
> > [  246.252869]  [<ffffffff83db2ef0>] do_async_page_fault+0x30/0xc0
> > [  246.252869]  [<ffffffff83db01e8>] async_page_fault+0x28/0x30
> > [  246.252869] Code: 90 90 90 90 90 90 9c fa 65 48 3b 06 75 14 65 48 3b 56 08 75 0d 65 48 89 1e 65 48 89 4e 08 9d b0 01 c3 9d 30
> > c0 c3 b9 00 02 00 00 <f3> 48 a5 c3 0f 1f 80 00 00 00 00 eb ee 66 66 66 90 66 66 66 90
> > [  246.252869] RIP  [<ffffffff81a0a795>] copy_page_rep+0x5/0x10
> > [  246.252869]  RSP <ffff88000015bc40>
> > [  246.252869] CR2: ffff88009c422000
> > [  246.252869] ---[ end trace 09fbe37b108d5766 ]---
> > 
> > And this is the code:
> > 
> >         if (is_huge_zero_pmd(orig_pmd))
> >                 clear_huge_page(new_page, haddr, HPAGE_PMD_NR);
> >         else
> >                 copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR); <--- this
> > 
> > 
> > Thanks,
> > Sasha
> 
> I don't know this issue was already resolved. If so, my reply become a just
> question to Kirill regardless of this BUG.
> 
> When I am looking at the code, I was wonder about the logic of GHZP(aka,
> get_huge_zero_page) reference handling. The logic depends on that page
> allocator never alocate PFN 0.
> 
> Who makes sure it? What happens if allocator allocates PFN 0?
> I don't know all of architecture makes sure it.
> You investigated it for all arches?
> 
> If not, 
> CPU 1                   CPU 2                                   CPU 3
> 
> shrink_huge_zero_page
> huge_zero_refcount = 0;
>                         GHZP
>                         pfn_0_zero_page = alloc_pages 
>                                                          GHZP
>                                                          pfn_some_zero_page = alloc_page
> huge_zero_pfn = 0
>                         huge_zero_pfn = pfn_0
>                         huge_zero_refcount = 2
>                                                         huge_zero_pfn = pfn_some
>                                                         huge_zero_refcount = 2
> 
> So, if you want to stick this logic, at least, don't we need BUG_ON to check
> pfn 0 allocation in get_huge_zero_page?

I don't think it's related to oops in the thread (I was not able to
reproduce it), but nice catch anyway.

What about the patch below?

=====

>From 4579aefd606b2dd82797af163ce6d08912894b3a Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Thu, 11 Apr 2013 15:47:50 +0300
Subject: [PATCH] thp: fix huge zero page logic for page with pfn == 0

Current implementation of huge zero page uses pfn value 0 to indicate
that the page hasn't allocated yet. It assumes that buddy page allocator
can't return page with pfn == 0.

Let's rework the code to store 'struct page *' of huge zero page, not
its pfn. This way we can avoid the weak assumption.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Minchan Kim <minchan@kernel.org>
---
 mm/huge_memory.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 45eaae0..bc2a548 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -163,25 +163,24 @@ static int start_khugepaged(void)
 }
 
 static atomic_t huge_zero_refcount;
-static unsigned long huge_zero_pfn __read_mostly;
+static struct page *huge_zero_page __read_mostly;
 
-static inline bool is_huge_zero_pfn(unsigned long pfn)
+static inline bool is_huge_zero_page(struct page *page)
 {
-	unsigned long zero_pfn = ACCESS_ONCE(huge_zero_pfn);
-	return zero_pfn && pfn == zero_pfn;
+	return ACCESS_ONCE(huge_zero_page) == page;
 }
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
-	return is_huge_zero_pfn(pmd_pfn(pmd));
+	return is_huge_zero_page(pmd_page(pmd));
 }
 
-static unsigned long get_huge_zero_page(void)
+static struct page *get_huge_zero_page(void)
 {
 	struct page *zero_page;
 retry:
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
-		return ACCESS_ONCE(huge_zero_pfn);
+		return ACCESS_ONCE(huge_zero_page);
 
 	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
@@ -191,7 +190,7 @@ retry:
 	}
 	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	preempt_disable();
-	if (cmpxchg(&huge_zero_pfn, 0, page_to_pfn(zero_page))) {
+	if (cmpxchg(&huge_zero_page, NULL, zero_page)) {
 		preempt_enable();
 		__free_page(zero_page);
 		goto retry;
@@ -200,7 +199,7 @@ retry:
 	/* We take additional reference here. It will be put back by shrinker */
 	atomic_set(&huge_zero_refcount, 2);
 	preempt_enable();
-	return ACCESS_ONCE(huge_zero_pfn);
+	return ACCESS_ONCE(huge_zero_page);
 }
 
 static void put_huge_zero_page(void)
@@ -220,9 +219,9 @@ static int shrink_huge_zero_page(struct shrinker *shrink,
 		return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
 
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
-		unsigned long zero_pfn = xchg(&huge_zero_pfn, 0);
-		BUG_ON(zero_pfn == 0);
-		__free_page(__pfn_to_page(zero_pfn));
+		struct page *zero_page = xchg(&huge_zero_page, NULL);
+		BUG_ON(zero_page == NULL);
+		__free_page(zero_page);
 	}
 
 	return 0;
@@ -764,12 +763,12 @@ static inline struct page *alloc_hugepage(int defrag)
 
 static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
-		unsigned long zero_pfn)
+		struct page *zero_page)
 {
 	pmd_t entry;
 	if (!pmd_none(*pmd))
 		return false;
-	entry = pfn_pmd(zero_pfn, vma->vm_page_prot);
+	entry = mk_pmd(zero_page, vma->vm_page_prot);
 	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	set_pmd_at(mm, haddr, pmd, entry);
@@ -794,20 +793,20 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (!(flags & FAULT_FLAG_WRITE) &&
 				transparent_hugepage_use_zero_page()) {
 			pgtable_t pgtable;
-			unsigned long zero_pfn;
+			struct page *zero_page;
 			bool set;
 			pgtable = pte_alloc_one(mm, haddr);
 			if (unlikely(!pgtable))
 				return VM_FAULT_OOM;
-			zero_pfn = get_huge_zero_page();
-			if (unlikely(!zero_pfn)) {
+			zero_page = get_huge_zero_page();
+			if (unlikely(!zero_page)) {
 				pte_free(mm, pgtable);
 				count_vm_event(THP_FAULT_FALLBACK);
 				goto out;
 			}
 			spin_lock(&mm->page_table_lock);
 			set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
-					zero_pfn);
+					zero_page);
 			spin_unlock(&mm->page_table_lock);
 			if (!set) {
 				pte_free(mm, pgtable);
@@ -886,16 +885,16 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * a page table.
 	 */
 	if (is_huge_zero_pmd(pmd)) {
-		unsigned long zero_pfn;
+		struct page *zero_page;
 		bool set;
 		/*
 		 * get_huge_zero_page() will never allocate a new page here,
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
-		zero_pfn = get_huge_zero_page();
+		zero_page = get_huge_zero_page();
 		set = set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
-				zero_pfn);
+				zero_page);
 		BUG_ON(!set); /* unexpected !pmd_none(dst_pmd) */
 		ret = 0;
 		goto out_unlock;
@@ -1803,7 +1802,7 @@ int split_huge_page(struct page *page)
 	struct anon_vma *anon_vma;
 	int ret = 1;
 
-	BUG_ON(is_huge_zero_pfn(page_to_pfn(page)));
+	BUG_ON(is_huge_zero_page(page));
 	BUG_ON(!PageAnon(page));
 
 	/*
-- 
 Kirill A. Shutemov
