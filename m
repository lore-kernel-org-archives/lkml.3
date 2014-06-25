Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaFYMfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:35:38 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35119 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaFYMfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:35:37 -0400
From: Chen Yucong <slaoub@gmail.com>
To: mgorman@suse.de
Cc: hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chen Yucong <slaoub@gmail.com>
Subject: [RESEND PATCH] mm: kswapd: clean up the kswapd
Date: Wed, 25 Jun 2014 20:35:17 +0800
Message-Id: <1403699717-23744-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The type of variables(order, new_order, and balanced_order) has some
flaws. According to the *order* argument for kswapd_try_to_sleep() and
balance_pgdat() and the *order* field of scan_control, they should be
defined as 'int' rather than 'unsigned long' or 'unsigned'. At the same
time, the type of the return value of balance_pgdat() should also be
changed from 'unsigned long' to 'int', based on its comment "Returns
the final order kswapd was reclaiming at".

This patch also does minimal cleanup, which makes the kswapd more clarify.

The output of `size' command:

   text    data     bss     dec     hex filename
5773502 1277496  929792 7980790  79c6f6 vmlinux-3.16-rc1
5773502 1277496  929792 7980790  79c6f6 vmlinux-3.16-rc1-fix

The output of checkstack.pl:
        3.16-rc1    3.16-rc1-fix
kswapd    104          104

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 mm/vmscan.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a8ffe4e..37b3453 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3070,8 +3070,7 @@ static bool kswapd_shrink_zone(struct zone *zone,
  * interoperates with the page allocator fallback scheme to ensure that aging
  * of pages is balanced across the zones.
  */
-static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
-							int *classzone_idx)
+static int balance_pgdat(pg_data_t *pgdat, int order, int *classzone_idx)
 {
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
@@ -3332,8 +3331,8 @@ static void kswapd_try_to_sleep(pg_data_t *pgdat, int order, int classzone_idx)
  */
 static int kswapd(void *p)
 {
-	unsigned long order, new_order;
-	unsigned balanced_order;
+	int order, new_order;
+	int balanced_order;
 	int classzone_idx, new_classzone_idx;
 	int balanced_classzone_idx;
 	pg_data_t *pgdat = (pg_data_t*)p;
@@ -3371,34 +3370,37 @@ static int kswapd(void *p)
 	balanced_classzone_idx = classzone_idx;
 	for ( ; ; ) {
 		bool ret;
+		bool sleep = true;
 
 		/*
 		 * If the last balance_pgdat was unsuccessful it's unlikely a
 		 * new request of a similar or harder type will succeed soon
 		 * so consider going to sleep on the basis we reclaimed at
 		 */
-		if (balanced_classzone_idx >= new_classzone_idx &&
-					balanced_order == new_order) {
+		if (balanced_classzone_idx >= classzone_idx &&
+					balanced_order == order) {
 			new_order = pgdat->kswapd_max_order;
 			new_classzone_idx = pgdat->classzone_idx;
-			pgdat->kswapd_max_order =  0;
+			pgdat->kswapd_max_order = 0;
 			pgdat->classzone_idx = pgdat->nr_zones - 1;
+
+			if (order < new_order ||
+					classzone_idx > new_classzone_idx) {
+				/*
+				 * Don't sleep if someone wants a larger 'order'
+				 * allocation or has tighter zone constraints
+				 */
+				order = new_order;
+				classzone_idx = new_classzone_idx;
+				sleep = false;
+			}
 		}
 
-		if (order < new_order || classzone_idx > new_classzone_idx) {
-			/*
-			 * Don't sleep if someone wants a larger 'order'
-			 * allocation or has tigher zone constraints
-			 */
-			order = new_order;
-			classzone_idx = new_classzone_idx;
-		} else {
+		if (sleep) {
 			kswapd_try_to_sleep(pgdat, balanced_order,
 						balanced_classzone_idx);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
-			new_order = order;
-			new_classzone_idx = classzone_idx;
 			pgdat->kswapd_max_order = 0;
 			pgdat->classzone_idx = pgdat->nr_zones - 1;
 		}
-- 
1.7.10.4

