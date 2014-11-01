Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaKAXBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:01:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60065 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "Marcelo Ricardo Leitner" <mleitner@redhat.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.931272499@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 079/102] ipv4: move route garbage collector to work queue
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Ricardo Leitner <mleitner@redhat.com>

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
---
 net/ipv4/route.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -151,6 +151,9 @@ static void		 ipv4_link_failure(struct s
 static void		 ip_rt_update_pmtu(struct dst_entry *dst, u32 mtu);
 static int rt_garbage_collect(struct dst_ops *ops);
 
+static void __rt_garbage_collect(struct work_struct *w);
+static DECLARE_WORK(rt_gc_worker, __rt_garbage_collect);
+
 static void ipv4_dst_ifdown(struct dst_entry *dst, struct net_device *dev,
 			    int how)
 {
@@ -979,7 +982,7 @@ static void rt_emergency_hash_rebuild(st
    and when load increases it reduces to limit cache size.
  */
 
-static int rt_garbage_collect(struct dst_ops *ops)
+static void __do_rt_garbage_collect(int elasticity, int min_interval)
 {
 	static unsigned long expire = RT_GC_TIMEOUT;
 	static unsigned long last_gc;
@@ -998,7 +1001,7 @@ static int rt_garbage_collect(struct dst
 
 	RT_CACHE_STAT_INC(gc_total);
 
-	if (now - last_gc < ip_rt_gc_min_interval &&
+	if (now - last_gc < min_interval &&
 	    entries < ip_rt_max_size) {
 		RT_CACHE_STAT_INC(gc_ignored);
 		goto out;
@@ -1006,7 +1009,7 @@ static int rt_garbage_collect(struct dst
 
 	entries = dst_entries_get_slow(&ipv4_dst_ops);
 	/* Calculate number of entries, which we want to expire now. */
-	goal = entries - (ip_rt_gc_elasticity << rt_hash_log);
+	goal = entries - (elasticity << rt_hash_log);
 	if (goal <= 0) {
 		if (equilibrium < ipv4_dst_ops.gc_thresh)
 			equilibrium = ipv4_dst_ops.gc_thresh;
@@ -1023,7 +1026,7 @@ static int rt_garbage_collect(struct dst
 		equilibrium = entries - goal;
 	}
 
-	if (now - last_gc >= ip_rt_gc_min_interval)
+	if (now - last_gc >= min_interval)
 		last_gc = now;
 
 	if (goal <= 0) {
@@ -1088,15 +1091,33 @@ static int rt_garbage_collect(struct dst
 	if (net_ratelimit())
 		printk(KERN_WARNING "dst cache overflow\n");
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
@@ -1291,13 +1312,7 @@ restart:
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
 

