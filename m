Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaKAXAx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:00:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60059 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbaKAWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcelo Ricardo Leitner" <mleitner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.609054648@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 081/102] ipv4: disable bh while doing route gc
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

Further tests revealed that after moving the garbage collector to a work
queue and protecting it with a spinlock may leave the system prone to
soft lockups if bottom half gets very busy.

It was reproced with a set of firewall rules that REJECTed packets. If
the NIC bottom half handler ends up running on the same CPU that is
running the garbage collector on a very large cache, the garbage
collector will not be able to do its job due to the amount of work
needed for handling the REJECTs and also won't reschedule.

The fix is to disable bottom half during the garbage collecting, as it
already was in the first place (most calls to it came from softirqs).

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1000,7 +1000,7 @@ static void __do_rt_garbage_collect(int
 	 * do not make it too frequently.
 	 */
 
-	spin_lock(&rt_gc_lock);
+	spin_lock_bh(&rt_gc_lock);
 
 	RT_CACHE_STAT_INC(gc_total);
 
@@ -1103,7 +1103,7 @@ work_done:
 	    dst_entries_get_slow(&ipv4_dst_ops) < ipv4_dst_ops.gc_thresh)
 		expire = ip_rt_gc_timeout;
 out:
-	spin_unlock(&rt_gc_lock);
+	spin_unlock_bh(&rt_gc_lock);
 }
 
 static void __rt_garbage_collect(struct work_struct *w)

