Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab3EXJk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:40:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32075 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3EXJh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:37:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,734,1363104000"; 
   d="scan'208";a="7355219"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, mgorman@suse.de, mingo@redhat.com,
        hpa@zytor.com, minchan@kernel.org, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, yinghai@kernel.org, jiang.liu@huawei.com,
        tj@kernel.org, liwanp@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] mem-hotplug: Skip LOCAL_NODE_DATA pages in memory online procedure.
Date: Fri, 24 May 2013 17:30:06 +0800
Message-Id: <1369387807-17956-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369387807-17956-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1369387807-17956-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 17:25:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 17:36:02,
	Serialize complete at 2013/05/24 17:36:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pages marked as LOCAL_NODE_DATA are skipped when we do memory offline.
So we have to skip them again when we do memory online.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 mm/memory_hotplug.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 075d412..21d6fcb 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -825,12 +825,18 @@ static void generic_online_page(struct page *page)
 static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
 			void *arg)
 {
-	unsigned long i;
+	unsigned long i, magic;
 	unsigned long onlined_pages = *(unsigned long *)arg;
 	struct page *page;
 	if (PageReserved(pfn_to_page(start_pfn)))
 		for (i = 0; i < nr_pages; i++) {
 			page = pfn_to_page(start_pfn + i);
+			magic = (unsigned long)page->lru.next;
+
+			/* Skip pages storing local node kernel data. */
+			if (magic == LOCAL_NODE_DATA)
+				continue;
+
 			(*online_page_callback)(page);
 			onlined_pages++;
 		}
-- 
1.7.1

