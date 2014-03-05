Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbaCEPMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:12:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41031 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbaCEO0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 068/131] can: add destructor for self generated skbs
Date: Wed,  5 Mar 2014 14:23:12 +0000
Message-Id: <1394029455-23128-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 0ae89beb283a0db5980d1d4781c7d7be2f2810d6 upstream.

Self generated skbuffs in net/can/bcm.c are setting a skb->sk reference but
no explicit destructor which is enforced since Linux 3.11 with commit
376c7311bdb6 (net: add a temporary sanity check in skb_orphan()).

This patch adds some helper functions to make sure that a destructor is
properly defined when a sock reference is assigned to a CAN related skb.
To create an unshared skb owned by the original sock a common helper function
has been introduced to replace open coded functions to create CAN echo skbs.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Andre Naujoks <nautsch2@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/dev.c        | 15 +++------------
 drivers/net/can/janz-ican3.c | 18 ++++--------------
 drivers/net/can/vcan.c       |  9 ++++-----
 include/linux/can/skb.h      | 38 ++++++++++++++++++++++++++++++++++++++
 net/can/af_can.c             |  3 ++-
 net/can/bcm.c                |  4 ++--
 6 files changed, 53 insertions(+), 34 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 1870c47..539239d 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -324,19 +324,10 @@ void can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	if (!priv->echo_skb[idx]) {
-		struct sock *srcsk = skb->sk;
 
-		if (atomic_read(&skb->users) != 1) {
-			struct sk_buff *old_skb = skb;
-
-			skb = skb_clone(old_skb, GFP_ATOMIC);
-			kfree_skb(old_skb);
-			if (!skb)
-				return;
-		} else
-			skb_orphan(skb);
-
-		skb->sk = srcsk;
+		skb = can_create_echo_skb(skb);
+		if (!skb)
+			return;
 
 		/* make settings for echo to reduce code in irq context */
 		skb->protocol = htons(ETH_P_CAN);
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 36bd6fa..db2ff03 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -19,6 +19,7 @@
 #include <linux/netdevice.h>
 #include <linux/can.h>
 #include <linux/can/dev.h>
+#include <linux/can/skb.h>
 #include <linux/can/error.h>
 
 #include <linux/mfd/janz.h>
@@ -1134,20 +1135,9 @@ static void ican3_handle_message(struct ican3_dev *mod, struct ican3_msg *msg)
  */
 static void ican3_put_echo_skb(struct ican3_dev *mod, struct sk_buff *skb)
 {
-	struct sock *srcsk = skb->sk;
-
-	if (atomic_read(&skb->users) != 1) {
-		struct sk_buff *old_skb = skb;
-
-		skb = skb_clone(old_skb, GFP_ATOMIC);
-		kfree_skb(old_skb);
-		if (!skb)
-			return;
-	} else {
-		skb_orphan(skb);
-	}
-
-	skb->sk = srcsk;
+	skb = can_create_echo_skb(skb);
+	if (!skb)
+		return;
 
 	/* save this skb for tx interrupt echo handling */
 	skb_queue_tail(&mod->echoq, skb);
diff --git a/drivers/net/can/vcan.c b/drivers/net/can/vcan.c
index 0a2a5ee..4e94057 100644
--- a/drivers/net/can/vcan.c
+++ b/drivers/net/can/vcan.c
@@ -46,6 +46,7 @@
 #include <linux/if_ether.h>
 #include <linux/can.h>
 #include <linux/can/dev.h>
+#include <linux/can/skb.h>
 #include <linux/slab.h>
 #include <net/rtnetlink.h>
 
@@ -109,25 +110,23 @@ static netdev_tx_t vcan_tx(struct sk_buff *skb, struct net_device *dev)
 			stats->rx_packets++;
 			stats->rx_bytes += cfd->len;
 		}
-		kfree_skb(skb);
+		consume_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
 	/* perform standard echo handling for CAN network interfaces */
 
 	if (loop) {
-		struct sock *srcsk = skb->sk;
 
-		skb = skb_share_check(skb, GFP_ATOMIC);
+		skb = can_create_echo_skb(skb);
 		if (!skb)
 			return NETDEV_TX_OK;
 
 		/* receive with packet counting */
-		skb->sk = srcsk;
 		vcan_rx(skb, dev);
 	} else {
 		/* no looped packets => no counting */
-		kfree_skb(skb);
+		consume_skb(skb);
 	}
 	return NETDEV_TX_OK;
 }
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 2f0543f..f9bbbb4 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -11,7 +11,9 @@
 #define CAN_SKB_H
 
 #include <linux/types.h>
+#include <linux/skbuff.h>
 #include <linux/can.h>
+#include <net/sock.h>
 
 /*
  * The struct can_skb_priv is used to transport additional information along
@@ -42,4 +44,40 @@ static inline void can_skb_reserve(struct sk_buff *skb)
 	skb_reserve(skb, sizeof(struct can_skb_priv));
 }
 
+static inline void can_skb_destructor(struct sk_buff *skb)
+{
+	sock_put(skb->sk);
+}
+
+static inline void can_skb_set_owner(struct sk_buff *skb, struct sock *sk)
+{
+	if (sk) {
+		sock_hold(sk);
+		skb->destructor = can_skb_destructor;
+		skb->sk = sk;
+	}
+}
+
+/*
+ * returns an unshared skb owned by the original sock to be echo'ed back
+ */
+static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
+{
+	if (skb_shared(skb)) {
+		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
+
+		if (likely(nskb)) {
+			can_skb_set_owner(nskb, skb->sk);
+			consume_skb(skb);
+			return nskb;
+		} else {
+			kfree_skb(skb);
+			return NULL;
+		}
+	}
+
+	/* we can assume to have an unshared skb with proper owner */
+	return skb;
+}
+
 #endif /* CAN_SKB_H */
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 3ab8dd2..ae3f07e 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -57,6 +57,7 @@
 #include <linux/skbuff.h>
 #include <linux/can.h>
 #include <linux/can/core.h>
+#include <linux/can/skb.h>
 #include <linux/ratelimit.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
@@ -290,7 +291,7 @@ int can_send(struct sk_buff *skb, int loop)
 				return -ENOMEM;
 			}
 
-			newskb->sk = skb->sk;
+			can_skb_set_owner(newskb, skb->sk);
 			newskb->ip_summed = CHECKSUM_UNNECESSARY;
 			newskb->pkt_type = PACKET_BROADCAST;
 		}
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 46f20bf..b57452a 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -268,7 +268,7 @@ static void bcm_can_tx(struct bcm_op *op)
 
 	/* send with loopback */
 	skb->dev = dev;
-	skb->sk = op->sk;
+	can_skb_set_owner(skb, op->sk);
 	can_send(skb, 1);
 
 	/* update statistics */
@@ -1223,7 +1223,7 @@ static int bcm_tx_send(struct msghdr *msg, int ifindex, struct sock *sk)
 
 	can_skb_prv(skb)->ifindex = dev->ifindex;
 	skb->dev = dev;
-	skb->sk  = sk;
+	can_skb_set_owner(skb, sk);
 	err = can_send(skb, 1); /* send with loopback */
 	dev_put(dev);
 
-- 
1.9.0

