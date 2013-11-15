Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3KOK0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:26:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab3KOK0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:26:32 -0500
Date: Fri, 15 Nov 2013 10:26:28 +0000
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dave.jiang@intel.com,
        akpm@linux-foundation.org, dhillf@gmail.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH 2/2] mm: thp: give transparent hugepage code a separate
 copy_page
Message-ID: <20131115102628.GD26002@suse.de>
References: <20131114233357.90EE35C1@viggo.jf.intel.com>
 <20131114233400.A729214D@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131114233400.A729214D@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 03:34:00PM -0800, Dave Hansen wrote:
> 
> Changes from v1:
>  * removed explicit might_sleep() in favor of the one that we
>    get from the cond_resched();
> 
> --
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Right now, the migration code in migrate_page_copy() uses 
> copy_huge_page() for hugetlbfs and thp pages:
> 
>        if (PageHuge(page) || PageTransHuge(page))
>                 copy_huge_page(newpage, page);
> 
> So, yay for code reuse.  But:
> 
> void copy_huge_page(struct page *dst, struct page *src)
> {
>         struct hstate *h = page_hstate(src);
> 
> and a non-hugetlbfs page has no page_hstate().  This
> works 99% of the time because page_hstate() determines
> the hstate from the page order alone.  Since the page
> order of a THP page matches the default hugetlbfs page
> order, it works.
> 
> But, if you change the default huge page size on the
> boot command-line (say default_hugepagesz=1G), then
> we might not even *have* a 2MB hstate so page_hstate()
> returns null and copy_huge_page() oopses pretty fast
> since copy_huge_page() dereferences the hstate:
> 
> void copy_huge_page(struct page *dst, struct page *src)
> {
>         struct hstate *h = page_hstate(src);
>         if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
> ...
> 
> This patch creates a copy_high_order_page() which can
> be used on THP pages.
> 
> I believe the bug was introduced in b32967ff101:
> Author: Mel Gorman <mgorman@suse.de>
> Date:   Mon Nov 19 12:35:47 2012 +0000
> mm: numa: Add THP migration for the NUMA working set scanning fault case.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

It is a mild pity that there are variants of this like copy_user_huge_page
for COW. They could be collapsed but the result API would not be pretty.

A rename of copy_huge_page to copy_hugetlbfs_page is justified to avoid
a repeat mistake. Alternatively, there seems to be little reason to add
hugetlbfs and thp specific apis when you could just do something like this
(untested)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0b7656e..784313a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -476,40 +476,6 @@ static int vma_has_reserves(struct vm_area_struct *vma, long chg)
 	return 0;
 }
 
-static void copy_gigantic_page(struct page *dst, struct page *src)
-{
-	int i;
-	struct hstate *h = page_hstate(src);
-	struct page *dst_base = dst;
-	struct page *src_base = src;
-
-	for (i = 0; i < pages_per_huge_page(h); ) {
-		cond_resched();
-		copy_highpage(dst, src);
-
-		i++;
-		dst = mem_map_next(dst, dst_base, i);
-		src = mem_map_next(src, src_base, i);
-	}
-}
-
-void copy_huge_page(struct page *dst, struct page *src)
-{
-	int i;
-	struct hstate *h = page_hstate(src);
-
-	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
-		copy_gigantic_page(dst, src);
-		return;
-	}
-
-	might_sleep();
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		cond_resched();
-		copy_highpage(dst + i, src + i);
-	}
-}
-
 static void enqueue_huge_page(struct hstate *h, struct page *page)
 {
 	int nid = page_to_nid(page);
diff --git a/mm/migrate.c b/mm/migrate.c
index 9167b22..843b96d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -440,6 +440,49 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 	return MIGRATEPAGE_SUCCESS;
 }
 
+static void copy_gigantic_page(struct page *dst, struct page *src,
+				int nr_pages)
+{
+	int i;
+	struct page *dst_base = dst;
+	struct page *src_base = src;
+
+	for (i = 0; i < nr_pages; ) {
+		cond_resched();
+		copy_highpage(dst, src);
+
+		i++;
+		dst = mem_map_next(dst, dst_base, i);
+		src = mem_map_next(src, src_base, i);
+	}
+}
+
+void copy_huge_page(struct page *dst, struct page *src)
+{
+	int i;
+	int nr_pages;
+
+	if (PageHuge(src)) {
+		/* hugetlbfs page */
+		struct hstate *h = page_hstate(src);
+		nr_pages = pages_per_huge_page(h);
+
+		if (unlikely(nr_pages > MAX_ORDER_NR_PAGES)) {
+			copy_gigantic_page(dst, src, nr_pages);
+			return;
+		}
+	} else {
+		/* thp page */
+		BUG_ON(!PageTransHuge(src));
+		nr_pages = HPAGE_PMD_NR;
+	}
+
+	for (i = 0; i < nr_pages; i++) {
+		cond_resched();
+		copy_highpage(dst + i, src + i);
+	}
+}
+
 /*
  * Copy the page to its new location
  */
