Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaGBEbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:31:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaGBEbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:31:21 -0400
Date: Wed, 2 Jul 2014 00:30:57 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH] rmap: fix pgoff calculation to handle hugepage correctly
Message-ID: <20140702043057.GA19813@nhori.redhat.com>
References: <1404225982-22739-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140701180739.GA4985@node.dhcp.inet.fi>
 <20140701185021.GA10356@nhori.bos.redhat.com>
 <20140701201540.GA5953@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701201540.GA5953@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 11:15:40PM +0300, Kirill A. Shutemov wrote:
> On Tue, Jul 01, 2014 at 02:50:21PM -0400, Naoya Horiguchi wrote:
> > On Tue, Jul 01, 2014 at 09:07:39PM +0300, Kirill A. Shutemov wrote:
> > > Why do we need this special case for hugetlb page ->index? Why not use
> > > PAGE_SIZE units there too? Or I miss something?
> > 
> > hugetlb pages are never split, so we use larger page cache size for
> > hugetlbfs file (to avoid large sparse page cache tree.)
> 
> For transparent huge page cache I would like to have native support in
> page cache radix-tree: since huge pages are always naturally aligned we
> can create a leaf node for it several (RADIX_TREE_MAP_SHIFT -
> HPAGE_PMD_ORDER) levels up by tree, which would cover all indexes in the
> range the huge page represents. This approach should fit hugetlb too. And
> -1 special case for hugetlb.
> But I'm not sure when I'll get time to play with this...

So I'm OK that hugetlb page should have ->index in PAGE_CACHE_SIZE
when transparent huge page is merged. I may try to write patches
on top of your tree after I've done a few series in my work queue.

In order to fix the current problem, I suggest a page_to_pgoff() as a
short-term workaround. I found a few other call sites which can call
on hugepage, so this function help us track such callers.
The similar function seems to be introduced in your transparent huge
page cache tree (page_cache_index()). So this function will be finally
overwritten with it.

Thanks,
Naoya Horiguchi
---
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date: Tue, 1 Jul 2014 21:38:22 -0400
Subject: [PATCH v2] rmap: fix pgoff calculation to handle hugepage correctly

I triggered VM_BUG_ON() in vma_address() when I try to migrate an anonymous
hugepage with mbind() in the kernel v3.16-rc3. This is because pgoff's
calculation in rmap_walk_anon() fails to consider compound_order() only to
have an incorrect value.

This patch introduces page_to_pgoff(), which gets the page's offset in
PAGE_CACHE_SIZE. Kirill pointed out that page cache tree should natively
handle hugepages, and in order to make hugetlbfs fit it, page->index of
hugetlbfs page should be in PAGE_CACHE_SIZE. This is beyond this patch,
but page_to_pgoff() contains the point to be fixed in a single function.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/pagemap.h | 12 ++++++++++++
 mm/memory-failure.c     |  4 ++--
 mm/rmap.c               | 10 +++-------
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0a97b583ee8d..e1474ae18c88 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -399,6 +399,18 @@ static inline struct page *read_mapping_page(struct address_space *mapping,
 }
 
 /*
+ * Get the offset in PAGE_SIZE.
+ * (TODO: hugepage should have ->index in PAGE_SIZE)
+ */
+static inline pgoff_t page_to_pgoff(struct page *page)
+{
+	if (unlikely(PageHeadHuge(page)))
+		return page->index << compound_order(page);
+	else
+		return page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+}
+
+/*
  * Return byte-offset into filesystem object for page.
  */
 static inline loff_t page_offset(struct page *page)
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index cd8989c1027e..61f05d745e3d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -435,7 +435,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 	if (av == NULL)	/* Not actually mapped anymore */
 		return;
 
-	pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff = page_to_pgoff(page);
 	read_lock(&tasklist_lock);
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
@@ -469,7 +469,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 	mutex_lock(&mapping->i_mmap_mutex);
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
-		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+		pgoff_t pgoff = page_to_pgoff(page);
 		struct task_struct *t = task_early_kill(tsk, force_early);
 
 		if (!t)
diff --git a/mm/rmap.c b/mm/rmap.c
index b7e94ebbd09e..22a4a7699cdb 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -517,11 +517,7 @@ void page_unlock_anon_vma_read(struct anon_vma *anon_vma)
 static inline unsigned long
 __vma_address(struct page *page, struct vm_area_struct *vma)
 {
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-
-	if (unlikely(is_vm_hugetlb_page(vma)))
-		pgoff = page->index << huge_page_order(page_hstate(page));
-
+	pgoff_t pgoff = page_to_pgoff(page);
 	return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 }
 
@@ -1639,7 +1635,7 @@ static struct anon_vma *rmap_walk_anon_lock(struct page *page,
 static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page_to_pgoff(page);
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
@@ -1680,7 +1676,7 @@ static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << compound_order(page);
+	pgoff_t pgoff = page_to_pgoff(page);
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
-- 
1.9.3

