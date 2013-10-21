Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3JUIuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:50:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39327 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753298Ab3JUIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:32 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.634563927@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 016/149] inetpeer: fix a race in inetpeer_gc_worker()
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 55432d2b543a4b6dfae54f5c432a566877a85d90 ]

commit 5faa5df1fa2024 (inetpeer: Invalidate the inetpeer tree along with
the routing cache) added a race :

Before freeing an inetpeer, we must respect a RCU grace period, and make
sure no user will attempt to increase refcnt.

inetpeer_invalidate_tree() waits for a RCU grace period before inserting
inetpeer tree into gc_list and waking the worker. At that time, no
concurrent lookup can find a inetpeer in this tree.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/inetpeer.h |  5 ++++-
 net/ipv4/inetpeer.c    | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index ac8a4ea..34b06da 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -41,7 +41,10 @@ struct inet_peer {
 	u32			pmtu_orig;
 	u32			pmtu_learned;
 	struct inetpeer_addr_base redirect_learned;
-	struct list_head	gc_list;
+	union {
+		struct list_head	gc_list;
+		struct rcu_head     gc_rcu;
+	};
 	/*
 	 * Once inet_peer is queued for deletion (refcnt == -1), following fields
 	 * are not available: rid, ip_id_count, tcp_ts, tcp_ts_stamp
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index d77a7dd..552e4f8 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -560,6 +560,17 @@ bool inet_peer_xrlim_allow(struct inet_peer *peer, int timeout)
 }
 EXPORT_SYMBOL(inet_peer_xrlim_allow);
 
+static void inetpeer_inval_rcu(struct rcu_head *head)
+{
+	struct inet_peer *p = container_of(head, struct inet_peer, gc_rcu);
+
+	spin_lock_bh(&gc_lock);
+	list_add_tail(&p->gc_list, &gc_list);
+	spin_unlock_bh(&gc_lock);
+
+	schedule_delayed_work(&gc_work, gc_delay);
+}
+
 void inetpeer_invalidate_tree(int family)
 {
 	struct inet_peer *old, *new, *prev;
@@ -576,10 +587,7 @@ void inetpeer_invalidate_tree(int family)
 	prev = cmpxchg(&base->root, old, new);
 	if (prev == old) {
 		base->total = 0;
-		spin_lock(&gc_lock);
-		list_add_tail(&prev->gc_list, &gc_list);
-		spin_unlock(&gc_lock);
-		schedule_delayed_work(&gc_work, gc_delay);
+		call_rcu(&prev->gc_rcu, inetpeer_inval_rcu);
 	}
 
 out:

