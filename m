Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaK0Iwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:52:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:42956 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbaK0IuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:50:13 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 85/91] ipv4: avoid parallel route cache gc executions
Date: Thu, 27 Nov 2014 16:43:08 +0800
Message-Id: <1417077794-9299-85-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Ricardo Leitner <mleitner@redhat.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


When rt_intern_hash() has to deal with neighbour cache overflowing,
it triggers the route cache garbage collector in an attempt to free
some references on neighbour entries.

Such call cannot be done async but should also not run in parallel with
an already-running one, so that they don't collapse fighting over the
hash lock entries.

This patch thus blocks parallel executions with spinlocks:
- A call from worker and from rt_intern_hash() are not the same, and
cannot be merged, thus they will wait each other on rt_gc_lock.
- Calls to gc from rt_intern_hash() may happen in parallel but we must
wait for it to finish in order to try again. This dedup and
synchrinozation is then performed by the locking just before calling
__do_rt_garbage_collect().

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 net/ipv4/route.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 90de2f9..9e7909e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -986,6 +986,7 @@ static void __do_rt_garbage_collect(int elasticity, int min_interval)
 	static unsigned long last_gc;
 	static int rover;
 	static int equilibrium;
+	static DEFINE_SPINLOCK(rt_gc_lock);
 	struct rtable *rth;
 	struct rtable __rcu **rthp;
 	unsigned long now = jiffies;
@@ -997,6 +998,8 @@ static void __do_rt_garbage_collect(int elasticity, int min_interval)
 	 * do not make it too frequently.
 	 */
 
+	spin_lock(&rt_gc_lock);
+
 	RT_CACHE_STAT_INC(gc_total);
 
 	if (now - last_gc < min_interval &&
@@ -1089,7 +1092,7 @@ static void __do_rt_garbage_collect(int elasticity, int min_interval)
 	if (net_ratelimit())
 		pr_warn("dst cache overflow\n");
 	RT_CACHE_STAT_INC(gc_dst_overflow);
-	return;
+	goto out;
 
 work_done:
 	expire += min_interval;
@@ -1097,7 +1100,8 @@ work_done:
 	    dst_entries_get_fast(&ipv4_dst_ops) < ipv4_dst_ops.gc_thresh ||
 	    dst_entries_get_slow(&ipv4_dst_ops) < ipv4_dst_ops.gc_thresh)
 		expire = ip_rt_gc_timeout;
-out:	return;
+out:
+	spin_unlock(&rt_gc_lock);
 }
 
 static void __rt_garbage_collect(struct work_struct *w)
@@ -1172,7 +1176,7 @@ static struct rtable *rt_intern_hash(unsigned hash, struct rtable *rt,
 	unsigned long	now;
 	u32 		min_score;
 	int		chain_length;
-	int attempts = !in_softirq();
+	int attempts = 1;
 
 restart:
 	chain_length = 0;
@@ -1308,8 +1312,15 @@ restart:
 			   can be released. Try to shrink route cache,
 			   it is most likely it holds some neighbour records.
 			 */
-			if (attempts-- > 0) {
-				__do_rt_garbage_collect(1, 0);
+			if (!in_softirq() && attempts-- > 0) {
+				static DEFINE_SPINLOCK(lock);
+
+				if (spin_trylock(&lock)) {
+					__do_rt_garbage_collect(1, 0);
+					spin_unlock(&lock);
+				} else {
+					spin_unlock_wait(&lock);
+				}
 				goto restart;
 			}
 
-- 
1.9.1

