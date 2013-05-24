Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234Ab3EXJjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:39:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14209 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab3EXJh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:37:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,734,1363104000"; 
   d="scan'208";a="7355223"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, mgorman@suse.de, mingo@redhat.com,
        hpa@zytor.com, minchan@kernel.org, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, yinghai@kernel.org, jiang.liu@huawei.com,
        tj@kernel.org, liwanp@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mem-hotplug: Do not free LOCAL_NODE_DATA pages to buddy system in hot-remove procedure.
Date: Fri, 24 May 2013 17:30:07 +0800
Message-Id: <1369387807-17956-5-git-send-email-tangchen@cn.fujitsu.com>
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

In memory hot-remove procedure, we free pagetable pages to buddy system.
But for local pagetable pages, do not free them to buddy system because
they were skipped in offline procedure. The memory block they reside in
could have been offlined, and we won't offline it again.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 mm/memory_hotplug.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 21d6fcb..c30e819 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -119,6 +119,14 @@ void __ref put_page_bootmem(struct page *page)
 		INIT_LIST_HEAD(&page->lru);
 
 		/*
+		 * Do not free pages with local node kernel data (for now, just
+		 * local pagetables) to the buddy system because we skipped
+		 * these pages when offlining the corresponding block.
+		 */
+		if (type == LOCAL_NODE_DATA)
+			return;
+
+		/*
 		 * Please refer to comment for __free_pages_bootmem()
 		 * for why we serialize here.
 		 */
-- 
1.7.1

