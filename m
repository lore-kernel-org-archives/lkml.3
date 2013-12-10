Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab3LJImV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:42:21 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59312 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3LJImQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:42:16 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-68-52a6d3e59140
Date: Tue, 10 Dec 2013 17:45:07 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 2/7] mm/migrate: correct failure handling if
 !hugepage_migration_support()
Message-ID: <20131210084507.GC24992@lge.com>
References: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1386580248-22431-3-git-send-email-iamjoonsoo.kim@lge.com>
 <52a679dd.8886420a.34d4.1b0eSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52a679dd.8886420a.34d4.1b0eSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 10:17:56AM +0800, Wanpeng Li wrote:
> Hi Joonsoo,
> On Mon, Dec 09, 2013 at 06:10:43PM +0900, Joonsoo Kim wrote:
> >We should remove the page from the list if we fail without ENOSYS,
> >since migrate_pages() consider error cases except -ENOMEM and -EAGAIN
> >as permanent failure and it assumes that the page would be removed from
> >the list. Without this patch, we could overcount number of failure.
> >
> >In addition, we should put back the new hugepage if
> >!hugepage_migration_support(). If not, we would leak hugepage memory.
> >
> >Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> >diff --git a/mm/migrate.c b/mm/migrate.c
> >index c6ac87a..b1cfd01 100644
> >--- a/mm/migrate.c
> >+++ b/mm/migrate.c
> >@@ -1011,7 +1011,7 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
> > {
> > 	int rc = 0;
> > 	int *result = NULL;
> >-	struct page *new_hpage = get_new_page(hpage, private, &result);
> >+	struct page *new_hpage;
> > 	struct anon_vma *anon_vma = NULL;
> >
> > 	/*
> >@@ -1021,9 +1021,12 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
> > 	 * tables or check whether the hugepage is pmd-based or not before
> > 	 * kicking migration.
> > 	 */
> >-	if (!hugepage_migration_support(page_hstate(hpage)))
> >+	if (!hugepage_migration_support(page_hstate(hpage))) {
> >+		putback_active_hugepage(hpage);
> > 		return -ENOSYS;
> 
> The memory hotplug(do_migrate_range) and hwpoison(soft_offline_huge_page) callsets both 
> will call putback_movable_pages/putback_active_hugepage for -ENOSYS case.

Hello Wanpeng.

Yes, those callsite handle error case, but error case handling should be done
in unmap_and_move_huge_page(). It is mentioned on patch 1. If we defer to
remove the pages from the list, nr_failed can be overcounted.

Thanks.
