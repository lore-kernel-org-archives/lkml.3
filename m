Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3HZBTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 21:19:19 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:42160 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3HZBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 21:19:12 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 5/8] mm/hwpoison: don't set migration type twice to avoid hold heavy contend zone->lock
Date: Mon, 26 Aug 2013 09:18:48 +0800
Message-Id: <1377479931-7430-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377479931-7430-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377479931-7430-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082601-6102-0000-0000-000004121CD7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 -> v2:
 * add more explanation in patch description.
v2 -> v3:
 * set MIGRATE_ISOLATE only if it's not set. 

Set pageblock migration type will hold zone->lock which is heavy contended
in system to avoid race. However, soft offline page will set pageblock
migration type twice during get page if the page is in used, not hugetlbfs
page and not on lru list. There is unnecessary to set the pageblock migration
type and hold heavy contended zone->lock again if the first round get page
have already set the pageblock to right migration type.

The trick here is migration type is MIGRATE_ISOLATE. There are other two parts 
can change MIGRATE_ISOLATE except hwpoison. One is memory hoplug, however, we 
hold lock_memory_hotplug() which avoid race. The second is CMA which umovable 
page allocation requst can't fallback to. So it's safe here.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memory-failure.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 297965e..f357c91 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1426,7 +1426,8 @@ static int __get_any_page(struct page *p, unsigned long pfn, int flags)
 	 * was free. This flag should be kept set until the source page
 	 * is freed and PG_hwpoison on it is set.
 	 */
-	set_migratetype_isolate(p, true);
+	if (get_pageblock_migratetype(p) != MIGRATE_ISOLATE)
+		set_migratetype_isolate(p, true);
 	/*
 	 * When the target page is a free hugepage, just remove it
 	 * from free hugepage list.
-- 
1.8.1.2

