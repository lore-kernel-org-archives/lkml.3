Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaKAXDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:03:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60061 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455AbaKAWj0 (ORCPT
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
Message-ID: <lsq.1414880883.997320952@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 080/102] ipv4: avoid parallel route cache gc executions
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
---
 net/ipv4/route.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -988,6 +988,7 @@ static void __do_rt_garbage_collect(int
 	static unsigned long last_gc;
 	static int rover;
 	static int equilibrium;
+	static DEFINE_SPINLOCK(rt_gc_lock);
 	struct rtable *rth;
 	struct rtable __rcu **rthp;
 	unsigned long now = jiffies;
@@ -999,6 +1000,8 @@ static void __do_rt_garbage_collect(int
 	 * do not make it too frequently.
 	 */
 
+	spin_lock(&rt_gc_lock);
+
 	RT_CACHE_STAT_INC(gc_total);
 
 	if (now - last_gc < min_interval &&
@@ -1091,7 +1094,7 @@ static void __do_rt_garbage_collect(int
 	if (net_ratelimit())
 		printk(KERN_WARNING "dst cache overflow\n");
 	RT_CACHE_STAT_INC(gc_dst_overflow);
-	return;
+	goto out;
 
 work_done:
 	expire += min_interval;
@@ -1099,7 +1102,8 @@ work_done:
 	    dst_entries_get_fast(&ipv4_dst_ops) < ipv4_dst_ops.gc_thresh ||
 	    dst_entries_get_slow(&ipv4_dst_ops) < ipv4_dst_ops.gc_thresh)
 		expire = ip_rt_gc_timeout;
-out:	return;
+out:
+	spin_unlock(&rt_gc_lock);
 }
 
 static void __rt_garbage_collect(struct work_struct *w)
@@ -1174,7 +1178,7 @@ static struct rtable *rt_intern_hash(uns
 	unsigned long	now;
 	u32 		min_score;
 	int		chain_length;
-	int attempts = !in_softirq();
+	int attempts = 1;
 
 restart:
 	chain_length = 0;
@@ -1311,8 +1315,15 @@ restart:
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
 

