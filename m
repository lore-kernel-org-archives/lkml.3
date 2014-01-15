Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaAOW30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:29:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbaAOV5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:22 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 146/166] packet: fix send path when running with proto == 0
Date: Wed, 15 Jan 2014 13:52:40 -0800
Message-Id: <1389822780-4729-147-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 66e56cd46b93ef407c60adcac62cf33b06119d50 ]

Commit e40526cb20b5 introduced a cached dev pointer, that gets
hooked into register_prot_hook(), __unregister_prot_hook() to
update the device used for the send path.

We need to fix this up, as otherwise this will not work with
sockets created with protocol = 0, plus with sll_protocol = 0
passed via sockaddr_ll when doing the bind.

So instead, assign the pointer directly. The compiler can inline
these helper functions automagically.

While at it, also assume the cached dev fast-path as likely(),
and document this variant of socket creation as it seems it is
not widely used (seems not even the author of TX_RING was aware
of that in his reference example [1]). Tested with reproducer
from e40526cb20b5.

 [1] http://wiki.ipxwarzone.com/index.php5?title=Linux_packet_mmap#Example

Fixes: e40526cb20b5 ("packet: fix use after free race in send path when dev is released")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Tested-by: Salam Noureddine <noureddine@aristanetworks.com>
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/networking/packet_mmap.txt | 10 +++++
 net/packet/af_packet.c                   | 65 ++++++++++++++++++++------------
 2 files changed, 50 insertions(+), 25 deletions(-)

diff --git a/Documentation/networking/packet_mmap.txt b/Documentation/networking/packet_mmap.txt
index 94444b1..9bac174 100644
--- a/Documentation/networking/packet_mmap.txt
+++ b/Documentation/networking/packet_mmap.txt
@@ -123,6 +123,16 @@ Transmission process is similar to capture as shown below.
 [shutdown]  close() --------> destruction of the transmission socket and
                               deallocation of all associated resources.
 
+Socket creation and destruction is also straight forward, and is done
+the same way as in capturing described in the previous paragraph:
+
+ int fd = socket(PF_PACKET, mode, 0);
+
+The protocol can optionally be 0 in case we only want to transmit
+via this socket, which avoids an expensive call to packet_rcv().
+In this case, you also need to bind(2) the TX_RING with sll_protocol = 0
+set. Otherwise, htons(ETH_P_ALL) or any other protocol, for example.
+
 Binding the socket to your network interface is mandatory (with zero copy) to
 know the header size of frames used in the circular buffer.
 
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 90c1a21..111217c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -229,6 +229,30 @@ struct packet_skb_cb {
 static void __fanout_unlink(struct sock *sk, struct packet_sock *po);
 static void __fanout_link(struct sock *sk, struct packet_sock *po);
 
+static struct net_device *packet_cached_dev_get(struct packet_sock *po)
+{
+	struct net_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(po->cached_dev);
+	if (likely(dev))
+		dev_hold(dev);
+	rcu_read_unlock();
+
+	return dev;
+}
+
+static void packet_cached_dev_assign(struct packet_sock *po,
+				     struct net_device *dev)
+{
+	rcu_assign_pointer(po->cached_dev, dev);
+}
+
+static void packet_cached_dev_reset(struct packet_sock *po)
+{
+	RCU_INIT_POINTER(po->cached_dev, NULL);
+}
+
 /* register_prot_hook must be invoked with the po->bind_lock held,
  * or from a context in which asynchronous accesses to the packet
  * socket is not possible (packet_create()).
@@ -238,12 +262,10 @@ static void register_prot_hook(struct sock *sk)
 	struct packet_sock *po = pkt_sk(sk);
 
 	if (!po->running) {
-		if (po->fanout) {
+		if (po->fanout)
 			__fanout_link(sk, po);
-		} else {
+		else
 			dev_add_pack(&po->prot_hook);
-			rcu_assign_pointer(po->cached_dev, po->prot_hook.dev);
-		}
 
 		sock_hold(sk);
 		po->running = 1;
@@ -262,12 +284,11 @@ static void __unregister_prot_hook(struct sock *sk, bool sync)
 	struct packet_sock *po = pkt_sk(sk);
 
 	po->running = 0;
-	if (po->fanout) {
+
+	if (po->fanout)
 		__fanout_unlink(sk, po);
-	} else {
+	else
 		__dev_remove_pack(&po->prot_hook);
-		RCU_INIT_POINTER(po->cached_dev, NULL);
-	}
 
 	__sock_put(sk);
 
@@ -1967,19 +1988,6 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	return tp_len;
 }
 
-static struct net_device *packet_cached_dev_get(struct packet_sock *po)
-{
-	struct net_device *dev;
-
-	rcu_read_lock();
-	dev = rcu_dereference(po->cached_dev);
-	if (dev)
-		dev_hold(dev);
-	rcu_read_unlock();
-
-	return dev;
-}
-
 static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 {
 	struct sk_buff *skb;
@@ -1996,7 +2004,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 	mutex_lock(&po->pg_vec_lock);
 
-	if (saddr == NULL) {
+	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
 		addr	= NULL;
@@ -2150,7 +2158,7 @@ static int packet_snd(struct socket *sock,
 	 *	Get and verify the address.
 	 */
 
-	if (saddr == NULL) {
+	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
 		addr	= NULL;
@@ -2358,6 +2366,8 @@ static int packet_release(struct socket *sock)
 
 	spin_lock(&po->bind_lock);
 	unregister_prot_hook(sk, false);
+	packet_cached_dev_reset(po);
+
 	if (po->prot_hook.dev) {
 		dev_put(po->prot_hook.dev);
 		po->prot_hook.dev = NULL;
@@ -2413,14 +2423,17 @@ static int packet_do_bind(struct sock *sk, struct net_device *dev, __be16 protoc
 
 	spin_lock(&po->bind_lock);
 	unregister_prot_hook(sk, true);
+
 	po->num = protocol;
 	po->prot_hook.type = protocol;
 	if (po->prot_hook.dev)
 		dev_put(po->prot_hook.dev);
-	po->prot_hook.dev = dev;
 
+	po->prot_hook.dev = dev;
 	po->ifindex = dev ? dev->ifindex : 0;
 
+	packet_cached_dev_assign(po, dev);
+
 	if (protocol == 0)
 		goto out_unlock;
 
@@ -2533,7 +2546,8 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	po = pkt_sk(sk);
 	sk->sk_family = PF_PACKET;
 	po->num = proto;
-	RCU_INIT_POINTER(po->cached_dev, NULL);
+
+	packet_cached_dev_reset(po);
 
 	sk->sk_destruct = packet_sock_destruct;
 	sk_refcnt_debug_inc(sk);
@@ -3290,6 +3304,7 @@ static int packet_notifier(struct notifier_block *this, unsigned long msg, void
 						sk->sk_error_report(sk);
 				}
 				if (msg == NETDEV_UNREGISTER) {
+					packet_cached_dev_reset(po);
 					po->ifindex = -1;
 					if (po->prot_hook.dev)
 						dev_put(po->prot_hook.dev);
-- 
1.8.3.2

