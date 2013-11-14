Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3KNCyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 21:54:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47636 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3KNCyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 21:54:25 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52843B0E.60600@jp.fujitsu.com>
Date: Thu, 14 Nov 2013 11:53:02 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <kosaki.motohiro@jp.fujitsu.com>,
        <kosaki.motohiro@gmail.com>, <mgorman@suse.de>
Subject: [PATCH resend] mm: get rid of unnecessary pageblock scanning in setup_zone_migrate_reserve
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I resend this patch.
I added performance result into description of the patch.

------------------------------------------------------------------
Yasuaki Ishimatsu reported memory hot-add spent more than 5 _hours_
on 9TB memory machine since onlining memory sections is too slow.
And we found out setup_zone_migrate_reserve spnet >90% time.

The problem is, setup_zone_migrate_reserve scan all pageblock
unconditionally, but it is only necessary number of reserved block
was reduced (i.e. memory hot remove).
Moreover, maximum MIGRATE_RESERVE per zone are currently 2. It mean,
number of reserved pageblock are almost always unchanged.

This patch adds zone->nr_migrate_reserve_block to maintain number
of MIGRATE_RESERVE pageblock and it reduce an overhead of
setup_zone_migrate_reserve dramatically. Following table shows
time of onlining a memory section.

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

Cc: Mel Gorman <mgorman@suse.de>
Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/mmzone.h |  6 ++++++
 mm/page_alloc.c        | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index bd791e4..67ab5fe 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -490,6 +490,12 @@ struct zone {
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
index 5a98836..da93109 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3908,6 +3908,7 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 	struct page *page;
 	unsigned long block_migratetype;
 	int reserve;
+	int old_reserve;

 	/*
 	 * Get the start pfn, end pfn and the number of blocks to reserve
@@ -3929,6 +3930,12 @@ static void setup_zone_migrate_reserve(struct zone *zone)
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
@@ -3966,6 +3973,12 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 				reserve--;
 				continue;
 			}
+		} else if (!old_reserve) {
+			/*
+			 * When boot time, we don't need scan whole zone
+			 * for turning off MIGRATE_RESERVE.
+			 */
+			break;
 		}

 		/*

