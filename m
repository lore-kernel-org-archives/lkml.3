Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3LMGvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:51:55 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52563 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3LMGud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:50:33 -0500
X-AuditID: 9c93017e-b7c17ae000003961-ca-52aaae367e84
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 2/6] mm/migrate: correct failure handling if !hugepage_migration_support()
Date: Fri, 13 Dec 2013 15:53:27 +0900
Message-Id: <1386917611-11319-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should remove the page from the list if we fail with ENOSYS,
since migrate_pages() consider error cases except -ENOMEM and -EAGAIN
as permanent failure and it assumes that the page would be removed from
the list. Without this patch, we could overcount number of failure.

In addition, we should put back the new hugepage if
!hugepage_migration_support(). If not, we would leak hugepage memory.

Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/migrate.c b/mm/migrate.c
index c6ac87a..b1cfd01 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1011,7 +1011,7 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 {
 	int rc = 0;
 	int *result = NULL;
-	struct page *new_hpage = get_new_page(hpage, private, &result);
+	struct page *new_hpage;
 	struct anon_vma *anon_vma = NULL;
 
 	/*
@@ -1021,9 +1021,12 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 	 * tables or check whether the hugepage is pmd-based or not before
 	 * kicking migration.
 	 */
-	if (!hugepage_migration_support(page_hstate(hpage)))
+	if (!hugepage_migration_support(page_hstate(hpage))) {
+		putback_active_hugepage(hpage);
 		return -ENOSYS;
+	}
 
+	new_hpage = get_new_page(hpage, private, &result);
 	if (!new_hpage)
 		return -ENOMEM;
 
-- 
1.7.9.5

