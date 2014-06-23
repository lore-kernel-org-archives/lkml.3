Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaFWFPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 01:15:12 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35672 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaFWFPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 01:15:10 -0400
From: Chen Yucong <slaoub@gmail.com>
To: mgorman@suse.de
Cc: hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] mm:kswapd: clean up the kswapd
Date: Mon, 23 Jun 2014 13:14:54 +0800
Message-Id: <1403500494-5110-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the commit 215ddd66 (mm: vmscan: only read new_classzone_idx from
pgdat when reclaiming successfully) and the commit d2ebd0f6b (kswapd: avoid
unnecessary rebalance after an unsuccessful balancing), we can use a boolean
variable for replace balanced_* variables, which makes the kswapd more clarify.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 mm/vmscan.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a8ffe4e..b0a75d1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3332,10 +3332,9 @@ static void kswapd_try_to_sleep(pg_data_t *pgdat, int order, int classzone_idx)
  */
 static int kswapd(void *p)
 {
+	bool balance_is_successful;
 	unsigned long order, new_order;
-	unsigned balanced_order;
 	int classzone_idx, new_classzone_idx;
-	int balanced_classzone_idx;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
 
@@ -3366,9 +3365,7 @@ static int kswapd(void *p)
 	set_freezable();
 
 	order = new_order = 0;
-	balanced_order = 0;
 	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
-	balanced_classzone_idx = classzone_idx;
 	for ( ; ; ) {
 		bool ret;
 
@@ -3377,24 +3374,32 @@ static int kswapd(void *p)
 		 * new request of a similar or harder type will succeed soon
 		 * so consider going to sleep on the basis we reclaimed at
 		 */
-		if (balanced_classzone_idx >= new_classzone_idx &&
-					balanced_order == new_order) {
+		balance_is_successful = false;
+		if (classzone_idx >= new_classzone_idx && order == new_order) {
+			/*
+			 * After the last balance_pgdat, if the `order' stays
+			 * constant and the scanned zones are not less than
+			 * specified by original classzone_idx, then the last
+			 * balance_pgdat was successful.
+			 */
 			new_order = pgdat->kswapd_max_order;
 			new_classzone_idx = pgdat->classzone_idx;
 			pgdat->kswapd_max_order =  0;
 			pgdat->classzone_idx = pgdat->nr_zones - 1;
+			balance_is_successful = true;
 		}
 
-		if (order < new_order || classzone_idx > new_classzone_idx) {
+		if (balance_is_successful && (order < new_order ||
+					classzone_idx > new_classzone_idx)) {
 			/*
 			 * Don't sleep if someone wants a larger 'order'
-			 * allocation or has tigher zone constraints
+			 * allocation or has tighter zone constraints on the
+			 * premise of the last balance_pgdat was successful.
 			 */
 			order = new_order;
 			classzone_idx = new_classzone_idx;
 		} else {
-			kswapd_try_to_sleep(pgdat, balanced_order,
-						balanced_classzone_idx);
+			kswapd_try_to_sleep(pgdat, order, classzone_idx);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
 			new_order = order;
@@ -3413,9 +3418,7 @@ static int kswapd(void *p)
 		 */
 		if (!ret) {
 			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
-			balanced_classzone_idx = classzone_idx;
-			balanced_order = balance_pgdat(pgdat, order,
-						&balanced_classzone_idx);
+			order = balance_pgdat(pgdat, order, &classzone_idx);
 		}
 	}
 
-- 
1.7.10.4

