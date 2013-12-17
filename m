Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3LQSOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:14:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60775 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3LQSOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Salam Noureddine <noureddine@aristanetworks.com>,
        Ben Greear <greearb@candelatech.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 016/103] packet: fix use after free race in send path when dev is released
Date: Tue, 17 Dec 2013 18:12:05 +0000
Message-Id: <1387304012-23805-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit e40526cb20b5ee53419452e1f03d97092f144418 upstream.

Salam reported a use after free bug in PF_PACKET that occurs when
we're sending out frames on a socket bound device and suddenly the
net device is being unregistered. It appears that commit 827d9780
introduced a possible race condition between {t,}packet_snd() and
packet_notifier(). In the case of a bound socket, packet_notifier()
can drop the last reference to the net_device and {t,}packet_snd()
might end up suddenly sending a packet over a freed net_device.

To avoid reverting 827d9780 and thus introducing a performance
regression compared to the current state of things, we decided to
hold a cached RCU protected pointer to the net device and maintain
it on write side via bind spin_lock protected register_prot_hook()
and __unregister_prot_hook() calls.

In {t,}packet_snd() path, we access this pointer under rcu_read_lock
through packet_cached_dev_get() that holds reference to the device
to prevent it from being freed through packet_notifier() while
we're in send path. This is okay to do as dev_put()/dev_hold() are
per-cpu counters, so this should not be a performance issue. Also,
the code simplifies a bit as we don't need need_rls_dev anymore.

Fixes: 827d978037d7 ("af-packet: Use existing netdev reference for bound sockets.")
Reported-by: Salam Noureddine <noureddine@aristanetworks.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Salam Noureddine <noureddine@aristanetworks.com>
Cc: Ben Greear <greearb@candelatech.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: used davem's backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/packet/af_packet.c | 60 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 3673677..c2a5a44 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -294,6 +294,7 @@ struct packet_sock {
 	unsigned int		tp_reserve;
 	unsigned int		tp_loss:1;
 	unsigned int		tp_tstamp;
+	struct net_device __rcu	*cached_dev;
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
 };
 
@@ -349,11 +350,15 @@ static void __fanout_link(struct sock *sk, struct packet_sock *po);
 static void register_prot_hook(struct sock *sk)
 {
 	struct packet_sock *po = pkt_sk(sk);
+
 	if (!po->running) {
-		if (po->fanout)
+		if (po->fanout) {
 			__fanout_link(sk, po);
-		else
+		} else {
 			dev_add_pack(&po->prot_hook);
+			rcu_assign_pointer(po->cached_dev, po->prot_hook.dev);
+		}
+
 		sock_hold(sk);
 		po->running = 1;
 	}
@@ -371,10 +376,13 @@ static void __unregister_prot_hook(struct sock *sk, bool sync)
 	struct packet_sock *po = pkt_sk(sk);
 
 	po->running = 0;
-	if (po->fanout)
+	if (po->fanout) {
 		__fanout_unlink(sk, po);
-	else
+	} else {
 		__dev_remove_pack(&po->prot_hook);
+		RCU_INIT_POINTER(po->cached_dev, NULL);
+	}
+
 	__sock_put(sk);
 
 	if (sync) {
@@ -2050,12 +2058,24 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	return tp_len;
 }
 
+static struct net_device *packet_cached_dev_get(struct packet_sock *po)
+{
+	struct net_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(po->cached_dev);
+	if (dev)
+		dev_hold(dev);
+	rcu_read_unlock();
+
+	return dev;
+}
+
 static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 {
 	struct sk_buff *skb;
 	struct net_device *dev;
 	__be16 proto;
-	bool need_rls_dev = false;
 	int err, reserve = 0;
 	void *ph;
 	struct sockaddr_ll *saddr = (struct sockaddr_ll *)msg->msg_name;
@@ -2069,7 +2089,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 	err = -EBUSY;
 	if (saddr == NULL) {
-		dev = po->prot_hook.dev;
+		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
 		addr	= NULL;
 	} else {
@@ -2083,19 +2103,17 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		proto	= saddr->sll_protocol;
 		addr	= saddr->sll_addr;
 		dev = dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
-		need_rls_dev = true;
 	}
 
 	err = -ENXIO;
 	if (unlikely(dev == NULL))
 		goto out;
-
-	reserve = dev->hard_header_len;
-
 	err = -ENETDOWN;
 	if (unlikely(!(dev->flags & IFF_UP)))
 		goto out_put;
 
+	reserve = dev->hard_header_len;
+
 	size_max = po->tx_ring.frame_size
 		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
 
@@ -2172,8 +2190,7 @@ out_status:
 	__packet_set_status(po, ph, status);
 	kfree_skb(skb);
 out_put:
-	if (need_rls_dev)
-		dev_put(dev);
+	dev_put(dev);
 out:
 	mutex_unlock(&po->pg_vec_lock);
 	return err;
@@ -2211,7 +2228,6 @@ static int packet_snd(struct socket *sock,
 	struct sk_buff *skb;
 	struct net_device *dev;
 	__be16 proto;
-	bool need_rls_dev = false;
 	unsigned char *addr;
 	int err, reserve = 0;
 	struct virtio_net_hdr vnet_hdr = { 0 };
@@ -2227,7 +2243,7 @@ static int packet_snd(struct socket *sock,
 	 */
 
 	if (saddr == NULL) {
-		dev = po->prot_hook.dev;
+		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
 		addr	= NULL;
 	} else {
@@ -2239,19 +2255,17 @@ static int packet_snd(struct socket *sock,
 		proto	= saddr->sll_protocol;
 		addr	= saddr->sll_addr;
 		dev = dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
-		need_rls_dev = true;
 	}
 
 	err = -ENXIO;
-	if (dev == NULL)
+	if (unlikely(dev == NULL))
 		goto out_unlock;
-	if (sock->type == SOCK_RAW)
-		reserve = dev->hard_header_len;
-
 	err = -ENETDOWN;
-	if (!(dev->flags & IFF_UP))
+	if (unlikely(!(dev->flags & IFF_UP)))
 		goto out_unlock;
 
+	if (sock->type == SOCK_RAW)
+		reserve = dev->hard_header_len;
 	if (po->has_vnet_hdr) {
 		vnet_hdr_len = sizeof(vnet_hdr);
 
@@ -2384,15 +2398,14 @@ static int packet_snd(struct socket *sock,
 	if (err > 0 && (err = net_xmit_errno(err)) != 0)
 		goto out_unlock;
 
-	if (need_rls_dev)
-		dev_put(dev);
+	dev_put(dev);
 
 	return len;
 
 out_free:
 	kfree_skb(skb);
 out_unlock:
-	if (dev && need_rls_dev)
+	if (dev)
 		dev_put(dev);
 out:
 	return err;
@@ -2609,6 +2622,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	po = pkt_sk(sk);
 	sk->sk_family = PF_PACKET;
 	po->num = proto;
+	RCU_INIT_POINTER(po->cached_dev, NULL);
 
 	sk->sk_destruct = packet_sock_destruct;
 	sk_refcnt_debug_inc(sk);
-- 
1.8.3.2

