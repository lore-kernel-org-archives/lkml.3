Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966170AbaCUBaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:30:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760213AbaCUADU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 012/149] neigh: recompute reachabletime before returning from neigh_periodic_work()
Date: Thu, 20 Mar 2014 17:02:55 -0700
Message-Id: <20140321000437.367230558@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

[ Upstream commit feff9ab2e7fa773b6a3965f77375fe89f7fd85cf ]

If the neigh table's entries is less than gc_thresh1, the function
will return directly, and the reachabletime will not be recompute,
so the reachabletime can be guessed.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -764,9 +764,6 @@ static void neigh_periodic_work(struct w
 	nht = rcu_dereference_protected(tbl->nht,
 					lockdep_is_held(&tbl->lock));
 
-	if (atomic_read(&tbl->entries) < tbl->gc_thresh1)
-		goto out;
-
 	/*
 	 *	periodically recompute ReachableTime from random function
 	 */
@@ -779,6 +776,9 @@ static void neigh_periodic_work(struct w
 				neigh_rand_reach_time(p->base_reachable_time);
 	}
 
+	if (atomic_read(&tbl->entries) < tbl->gc_thresh1)
+		goto out;
+
 	for (i = 0 ; i < (1 << nht->hash_shift); i++) {
 		np = &nht->hash_buckets[i];
 


