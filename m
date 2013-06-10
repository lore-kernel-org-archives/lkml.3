Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3FJIkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:40:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:35321 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3FJIkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:40:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,835,1363158000"; 
   d="scan'208";a="350966702"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v10 net-next 3/6] udp: add low latency socket poll support
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 10 Jun 2013 11:40:00 +0300
Message-ID: <20130610084000.6955.20487.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>
References: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add upport for busy-polling on UDP sockets.
In __udp[46]_lib_rcv add a call to sk_mark_ll() to copy the napi_id
from the skb into the sk.
This is done at the earliest possible moment, right after we identify
which socket this skb is for.
In __skb_recv_datagram When there is no data and the user
tries to read we busy poll.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---

 net/core/datagram.c |    4 ++++
 net/ipv4/udp.c      |    6 +++++-
 net/ipv6/udp.c      |    6 +++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index b71423d..9cbaba9 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -56,6 +56,7 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <trace/events/skb.h>
+#include <net/ll_poll.h>
 
 /*
  *	Is a socket 'connection oriented' ?
@@ -207,6 +208,9 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
 		}
 		spin_unlock_irqrestore(&queue->lock, cpu_flags);
 
+		if (sk_valid_ll(sk) && sk_poll_ll(sk, flags & MSG_DONTWAIT))
+			continue;
+
 		/* User doesn't want to wait */
 		error = -EAGAIN;
 		if (!timeo)
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c7338ec..2955b25 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -109,6 +109,7 @@
 #include <trace/events/udp.h>
 #include <linux/static_key.h>
 #include <trace/events/skb.h>
+#include <net/ll_poll.h>
 #include "udp_impl.h"
 
 struct udp_table udp_table __read_mostly;
@@ -1709,7 +1710,10 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	sk = __udp4_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
 
 	if (sk != NULL) {
-		int ret = udp_queue_rcv_skb(sk, skb);
+		int ret;
+
+		sk_mark_ll(sk, skb);
+		ret = udp_queue_rcv_skb(sk, skb);
 		sock_put(sk);
 
 		/* a return value > 0 means to resubmit the input, but
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index b580853..f77e34c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -46,6 +46,7 @@
 #include <net/ip6_checksum.h>
 #include <net/xfrm.h>
 #include <net/inet6_hashtables.h>
+#include <net/ll_poll.h>
 
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -841,7 +842,10 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 */
 	sk = __udp6_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
 	if (sk != NULL) {
-		int ret = udpv6_queue_rcv_skb(sk, skb);
+		int ret;
+
+		sk_mark_ll(sk, skb);
+		ret = udpv6_queue_rcv_skb(sk, skb);
 		sock_put(sk);
 
 		/* a return value > 0 means to resubmit the input, but

