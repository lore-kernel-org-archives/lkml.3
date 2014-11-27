Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaK0IuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:50:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:42945 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205AbaK0IuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:50:10 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 84/91] ipv4: move route garbage collector to work queue
Date: Thu, 27 Nov 2014 16:43:07 +0800
Message-Id: <1417077794-9299-84-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Ricardo Leitner <mleitner@redhat.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


Currently the route garbage collector gets called by dst_alloc() if it
have more entries than the threshold. But it's an expensive call, that
don't really need to be done by then.

Another issue with current way is that it allows running the garbage
collector with the same start parameters on multiple CPUs at once, which
is not optimal. A system may even soft lockup if the cache is big enough
as the garbage collectors will be fighting over the hash lock entries.

This patch thus moves the garbage collector to run asynchronously on a
work queue, much similar to how rt_expire_check runs.

There is one condition left that allows multiple executions, which is
handled by the next patch.

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 net/ipv4/route.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index fd68433..90de2f9 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -150,6 +150,9 @@ static void		 ipv4_link_failure(struct sk_buff *skb);
 static void		 ip_rt_update_pmtu(struct dst_entry *dst, u32 mtu);
 static int rt_garbage_collect(struct dst_ops *ops);
 
+static void __rt_garbage_collect(struct work_struct *w);
+static DECLARE_WORK(rt_gc_worker, __rt_garbage_collect);
+
 static void ipv4_dst_ifdown(struct dst_entry *dst, struct net_device *dev,
 			    int how)
 {
@@ -977,7 +980,7 @@ static void rt_emergency_hash_rebuild(struct net *net)
    and when load increases it reduces to limit cache size.
  */
 
-static int rt_garbage_collect(struct dst_ops *ops)
+static void __do_rt_garbage_collect(int elasticity, int min_interval)
 {
 	static unsigned long expire = RT_GC_TIMEOUT;
 	static unsigned long last_gc;
@@ -996,7 +999,7 @@ static int rt_garbage_collect(struct dst_ops *ops)
 
 	RT_CACHE_STAT_INC(gc_total);
 
-	if (now - last_gc < ip_rt_gc_min_interval &&
+	if (now - last_gc < min_interval &&
 	    entries < ip_rt_max_size) {
 		RT_CACHE_STAT_INC(gc_ignored);
 		goto out;
@@ -1004,7 +1007,7 @@ static int rt_garbage_collect(struct dst_ops *ops)
 
 	entries = dst_entries_get_slow(&ipv4_dst_ops);
 	/* Calculate number of entries, which we want to expire now. */
-	goal = entries - (ip_rt_gc_elasticity << rt_hash_log);
+	goal = entries - (elasticity << rt_hash_log);
 	if (goal <= 0) {
 		if (equilibrium < ipv4_dst_ops.gc_thresh)
 			equilibrium = ipv4_dst_ops.gc_thresh;
@@ -1021,7 +1024,7 @@ static int rt_garbage_collect(struct dst_ops *ops)
 		equilibrium = entries - goal;
 	}
 
-	if (now - last_gc >= ip_rt_gc_min_interval)
+	if (now - last_gc >= min_interval)
 		last_gc = now;
 
 	if (goal <= 0) {
@@ -1086,15 +1089,33 @@ static int rt_garbage_collect(struct dst_ops *ops)
 	if (net_ratelimit())
 		pr_warn("dst cache overflow\n");
 	RT_CACHE_STAT_INC(gc_dst_overflow);
-	return 1;
+	return;
 
 work_done:
-	expire += ip_rt_gc_min_interval;
+	expire += min_interval;
 	if (expire > ip_rt_gc_timeout ||
 	    dst_entries_get_fast(&ipv4_dst_ops) < ipv4_dst_ops.gc_thresh ||
 	    dst_entries_get_slow(&ipv4_dst_ops) < ipv4_dst_ops.gc_thresh)
 		expire = ip_rt_gc_timeout;
-out:	return 0;
+out:	return;
+}
+
+static void __rt_garbage_collect(struct work_struct *w)
+{
+	__do_rt_garbage_collect(ip_rt_gc_elasticity, ip_rt_gc_min_interval);
+}
+
+static int rt_garbage_collect(struct dst_ops *ops)
+{
+	if (!work_pending(&rt_gc_worker))
+		schedule_work(&rt_gc_worker);
+
+	if (dst_entries_get_fast(&ipv4_dst_ops) >= ip_rt_max_size ||
+	    dst_entries_get_slow(&ipv4_dst_ops) >= ip_rt_max_size) {
+		RT_CACHE_STAT_INC(gc_dst_overflow);
+		return 1;
+	}
+	return 0;
 }
 
 /*
@@ -1288,13 +1309,7 @@ restart:
 			   it is most likely it holds some neighbour records.
 			 */
 			if (attempts-- > 0) {
-				int saved_elasticity = ip_rt_gc_elasticity;
-				int saved_int = ip_rt_gc_min_interval;
-				ip_rt_gc_elasticity	= 1;
-				ip_rt_gc_min_interval	= 0;
-				rt_garbage_collect(&ipv4_dst_ops);
-				ip_rt_gc_min_interval	= saved_int;
-				ip_rt_gc_elasticity	= saved_elasticity;
+				__do_rt_garbage_collect(1, 0);
 				goto restart;
 			}
 
-- 
1.9.1

