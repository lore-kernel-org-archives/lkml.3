Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaFPJ0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:26:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:10325 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbaFPJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:26:37 -0400
Message-ID: <539EB7EA.7020705@huawei.com>
Date: Mon, 16 Jun 2014 17:24:58 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <aquini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3/8] mm: implement page cache limit feature
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add hooks when a page is added to page cache.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/filemap.c |    3 +++
 mm/hugetlb.c |    3 +++
 mm/vmscan.c  |    3 +++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 088358c..0e71a04 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -622,6 +622,9 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 	void *shadow = NULL;
 	int ret;
 
+	if (vm_cache_limit_mbytes && page_cache_over_limit())
+		shrink_page_cache(gfp_mask);
+
 	__set_page_locked(page);
 	ret = __add_to_page_cache_locked(page, mapping, offset,
 					 gfp_mask, &shadow);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c82290b..4dc8173 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2851,6 +2851,9 @@ retry:
 			int err;
 			struct inode *inode = mapping->host;
 
+			if (vm_cache_limit_mbytes && page_cache_over_limit())
+				shrink_page_cache(GFP_KERNEL);
+
 			err = add_to_page_cache(page, mapping, idx, GFP_KERNEL);
 			if (err) {
 				put_page(page);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ad01ff4..707d3e3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2977,6 +2977,9 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 	};
 	count_vm_event(PAGEOUTRUN);
 
+	if (vm_cache_limit_mbytes && page_cache_over_limit())
+		shrink_page_cache(GFP_KERNEL);
+
 	do {
 		unsigned long lru_pages = 0;
 		unsigned long nr_attempted = 0;
-- 
1.6.0.2


