Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3HVJtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:49:31 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43049 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab3HVJsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:48:46 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 4/6] mm/hwpoison: don't set migration type twice to avoid hold heavy contend zone->lock
Date: Thu, 22 Aug 2013 17:48:25 +0800
Message-Id: <1377164907-24801-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377164907-24801-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377164907-24801-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082209-0260-0000-0000-000003812E2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set pageblock migration type will hold zone->lock which is heavy contended 
in system to avoid race. However, soft offline page will set pageblock 
migration type twice during get page if the page is in used, not hugetlbfs 
page and not on lru list. There is unnecessary to set the pageblock migration
type and hold heavy contended zone->lock again if the first round get page 
have already set the pageblock to right migration type.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memory-failure.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 6bfd51e..3bfb45f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1413,7 +1413,8 @@ static int __get_any_page(struct page *p, unsigned long pfn, int flags)
 	 * was free. This flag should be kept set until the source page
 	 * is freed and PG_hwpoison on it is set.
 	 */
-	set_migratetype_isolate(p, true);
+	if (get_pageblock_migratetype(p) == MIGRATE_ISOLATE)
+		set_migratetype_isolate(p, true);
 	/*
 	 * When the target page is a free hugepage, just remove it
 	 * from free hugepage list.
-- 
1.8.1.2

