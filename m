Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaDALzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:55:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaDALRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 068/144] neigh: recompute reachabletime before returning from neigh_periodic_work()
Date: Tue,  1 Apr 2014 12:14:32 +0100
Message-Id: <1396350948-29910-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

commit feff9ab2e7fa773b6a3965f77375fe89f7fd85cf upstream.

If the neigh table's entries is less than gc_thresh1, the function
will return directly, and the reachabletime will not be recompute,
so the reachabletime can be guessed.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/neighbour.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 72d71c9..577f36d 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -764,9 +764,6 @@ static void neigh_periodic_work(struct work_struct *work)
 	nht = rcu_dereference_protected(tbl->nht,
 					lockdep_is_held(&tbl->lock));
 
-	if (atomic_read(&tbl->entries) < tbl->gc_thresh1)
-		goto out;
-
 	/*
 	 *	periodically recompute ReachableTime from random function
 	 */
@@ -779,6 +776,9 @@ static void neigh_periodic_work(struct work_struct *work)
 				neigh_rand_reach_time(p->base_reachable_time);
 	}
 
+	if (atomic_read(&tbl->entries) < tbl->gc_thresh1)
+		goto out;
+
 	for (i = 0 ; i < (1 << nht->hash_shift); i++) {
 		np = &nht->hash_buckets[i];
 
-- 
1.9.1

