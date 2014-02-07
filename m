Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaBGLwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42500 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaBGLwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Paasch <christoph.paasch@uclouvain.be>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 217/233] tcp: metrics: Avoid duplicate entries with the same destination-IP
Date: Fri,  7 Feb 2014 11:47:16 +0000
Message-Id: <1391773652-25214-218-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Paasch <christoph.paasch@uclouvain.be>

commit 77f99ad16a07aa062c2d30fae57b1fee456f6ef6 upstream.

Because the tcp-metrics is an RCU-list, it may be that two
soft-interrupts are inside __tcp_get_metrics() for the same
destination-IP at the same time. If this destination-IP is not yet part of
the tcp-metrics, both soft-interrupts will end up in tcpm_new and create
a new entry for this IP.
So, we will have two tcp-metrics with the same destination-IP in the list.

This patch checks twice __tcp_get_metrics(). First without holding the
lock, then while holding the lock. The second one is there to confirm
that the entry has not been added by another soft-irq while waiting for
the spin-lock.

Fixes: 51c5d0c4b169b (tcp: Maintain dynamic metrics in local cache.)
Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_metrics.c | 51 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 306dbd9..b500d2d 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -22,6 +22,9 @@
 
 int sysctl_tcp_nometrics_save __read_mostly;
 
+static struct tcp_metrics_block *__tcp_get_metrics(const struct inetpeer_addr *addr,
+						   struct net *net, unsigned int hash);
+
 struct tcp_fastopen_metrics {
 	u16	mss;
 	u16	syn_loss:10;		/* Recurring Fast Open SYN losses */
@@ -130,16 +133,41 @@ static void tcpm_suck_dst(struct tcp_metrics_block *tm, struct dst_entry *dst,
 	}
 }
 
+#define TCP_METRICS_TIMEOUT		(60 * 60 * HZ)
+
+static void tcpm_check_stamp(struct tcp_metrics_block *tm, struct dst_entry *dst)
+{
+	if (tm && unlikely(time_after(jiffies, tm->tcpm_stamp + TCP_METRICS_TIMEOUT)))
+		tcpm_suck_dst(tm, dst, false);
+}
+
+#define TCP_METRICS_RECLAIM_DEPTH	5
+#define TCP_METRICS_RECLAIM_PTR		(struct tcp_metrics_block *) 0x1UL
+
 static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
 					  struct inetpeer_addr *addr,
-					  unsigned int hash,
-					  bool reclaim)
+					  unsigned int hash)
 {
 	struct tcp_metrics_block *tm;
 	struct net *net;
+	bool reclaim = false;
 
 	spin_lock_bh(&tcp_metrics_lock);
 	net = dev_net(dst->dev);
+
+	/* While waiting for the spin-lock the cache might have been populated
+	 * with this entry and so we have to check again.
+	 */
+	tm = __tcp_get_metrics(addr, net, hash);
+	if (tm == TCP_METRICS_RECLAIM_PTR) {
+		reclaim = true;
+		tm = NULL;
+	}
+	if (tm) {
+		tcpm_check_stamp(tm, dst);
+		goto out_unlock;
+	}
+
 	if (unlikely(reclaim)) {
 		struct tcp_metrics_block *oldest;
 
@@ -169,17 +197,6 @@ out_unlock:
 	return tm;
 }
 
-#define TCP_METRICS_TIMEOUT		(60 * 60 * HZ)
-
-static void tcpm_check_stamp(struct tcp_metrics_block *tm, struct dst_entry *dst)
-{
-	if (tm && unlikely(time_after(jiffies, tm->tcpm_stamp + TCP_METRICS_TIMEOUT)))
-		tcpm_suck_dst(tm, dst, false);
-}
-
-#define TCP_METRICS_RECLAIM_DEPTH	5
-#define TCP_METRICS_RECLAIM_PTR		(struct tcp_metrics_block *) 0x1UL
-
 static struct tcp_metrics_block *tcp_get_encode(struct tcp_metrics_block *tm, int depth)
 {
 	if (tm)
@@ -280,7 +297,6 @@ static struct tcp_metrics_block *tcp_get_metrics(struct sock *sk,
 	struct inetpeer_addr addr;
 	unsigned int hash;
 	struct net *net;
-	bool reclaim;
 
 	addr.family = sk->sk_family;
 	switch (addr.family) {
@@ -300,13 +316,10 @@ static struct tcp_metrics_block *tcp_get_metrics(struct sock *sk,
 	hash = hash_32(hash, net->ipv4.tcp_metrics_hash_log);
 
 	tm = __tcp_get_metrics(&addr, net, hash);
-	reclaim = false;
-	if (tm == TCP_METRICS_RECLAIM_PTR) {
-		reclaim = true;
+	if (tm == TCP_METRICS_RECLAIM_PTR)
 		tm = NULL;
-	}
 	if (!tm && create)
-		tm = tcpm_new(dst, &addr, hash, reclaim);
+		tm = tcpm_new(dst, &addr, hash);
 	else
 		tcpm_check_stamp(tm, dst);
 
-- 
1.8.3.2

