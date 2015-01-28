Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332AbbA1ExD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:53:03 -0500
Received: from mail.kernel.org ([198.145.29.136]:39738 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964900AbbA1EVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:21:53 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 86/91] ipv4: disable bh while doing route gc
Date: Wed, 28 Jan 2015 12:08:58 +0800
Message-Id: <1422418236-12852-171-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Ricardo Leitner <mleitner@redhat.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 net/ipv4/route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9e7909e..6c34bc9 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -998,7 +998,7 @@ static void __do_rt_garbage_collect(int elasticity, int min_interval)
 	 * do not make it too frequently.
 	 */
 
-	spin_lock(&rt_gc_lock);
+	spin_lock_bh(&rt_gc_lock);
 
 	RT_CACHE_STAT_INC(gc_total);
 
@@ -1101,7 +1101,7 @@ work_done:
 	    dst_entries_get_slow(&ipv4_dst_ops) < ipv4_dst_ops.gc_thresh)
 		expire = ip_rt_gc_timeout;
 out:
-	spin_unlock(&rt_gc_lock);
+	spin_unlock_bh(&rt_gc_lock);
 }
 
 static void __rt_garbage_collect(struct work_struct *w)
-- 
1.9.1

