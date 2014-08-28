Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaH1TGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:06:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaH1SgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:14 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 26/97] mm: get rid of unnecessary pageblock scanning in setup_zone_migrate_reserve
Date: Thu, 28 Aug 2014 19:34:34 +0100
Message-Id: <1409250945-30874-27-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

commit 943dca1a1fcbccb58de944669b833fd38a6c809b upstream.

Yasuaki Ishimatsu reported memory hot-add spent more than 5 _hours_ on
9TB memory machine since onlining memory sections is too slow.  And we
found out setup_zone_migrate_reserve spent >90% of the time.

The problem is, setup_zone_migrate_reserve scans all pageblocks
unconditionally, but it is only necessary if the number of reserved
block was reduced (i.e.  memory hot remove).

Moreover, maximum MIGRATE_RESERVE per zone is currently 2.  It means
that the number of reserved pageblocks is almost always unchanged.

This patch adds zone->nr_migrate_reserve_block to maintain the number of
MIGRATE_RESERVE pageblocks and it reduces the overhead of
setup_zone_migrate_reserve dramatically.  The following table shows time
of onlining a memory section.

  Amount of memory     | 128GB | 192GB | 256GB|
  ---------------------------------------------
  linux-3.12           |  23.9 |  31.4 | 44.5 |
  This patch           |   8.3 |   8.3 |  8.6 |
  Mel's proposal patch |  10.9 |  19.2 | 31.3 |
  ---------------------------------------------
                                   (millisecond)

  128GB : 4 nodes and each node has 32GB of memory
  192GB : 6 nodes and each node has 32GB of memory
  256GB : 8 nodes and each node has 32GB of memory

  (*1) Mel proposed his idea by the following threads.
       https://lkml.org/lkml/2013/10/30/272

[akpm@linux-foundation.org: tweak comment]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mmzone.h |  6 ++++++
 mm/page_alloc.c        | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5648290..4719985 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -494,6 +494,12 @@ struct zone {
 	unsigned long		managed_pages;
 
 	/*
+	 * Number of MIGRATE_RESEVE page block. To maintain for just
+	 * optimization. Protected by zone->lock.
+	 */
+	int			nr_migrate_reserve_block;
+
+	/*
 	 * rarely used fields:
 	 */
 	const char		*name;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3078eaf..c34b582 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3934,6 +3934,7 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 	struct page *page;
 	unsigned long block_migratetype;
 	int reserve;
+	int old_reserve;
 
 	/*
 	 * Get the start pfn, end pfn and the number of blocks to reserve
@@ -3955,6 +3956,12 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 	 * future allocation of hugepages at runtime.
 	 */
 	reserve = min(2, reserve);
+	old_reserve = zone->nr_migrate_reserve_block;
+
+	/* When memory hot-add, we almost always need to do nothing */
+	if (reserve == old_reserve)
+		return;
+	zone->nr_migrate_reserve_block = reserve;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		if (!pfn_valid(pfn))
@@ -3992,6 +3999,12 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 				reserve--;
 				continue;
 			}
+		} else if (!old_reserve) {
+			/*
+			 * At boot time we don't need to scan the whole zone
+			 * for turning off MIGRATE_RESERVE.
+			 */
+			break;
 		}
 
 		/*
-- 
1.8.4.5

