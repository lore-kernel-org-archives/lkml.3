Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3FJIkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:40:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:19651 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab3FJIkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:40:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,835,1363158000"; 
   d="scan'208";a="326940040"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v10 net-next 4/6] tcp: add low latency socket poll support.
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
Date: Mon, 10 Jun 2013 11:40:10 +0300
Message-ID: <20130610084010.6955.14413.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>
References: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds low latency socket poll support for TCP.
In tcp_v[46]_rcv() add a call to sk_mark_ll() to copy the napi_id
from the skb to the sk.
In tcp_recvmsg(), when there is no data in the socket we busy-poll.
This is a good example of how to add busy-poll support to more protocols.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---

 net/ipv4/tcp.c      |    5 +++++
 net/ipv4/tcp_ipv4.c |    2 ++
 net/ipv6/tcp_ipv6.c |    2 ++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bc42469..46ed9af 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -279,6 +279,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
+#include <net/ll_poll.h>
 
 int sysctl_tcp_fin_timeout __read_mostly = TCP_FIN_TIMEOUT;
 
@@ -1553,6 +1554,10 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	struct sk_buff *skb;
 	u32 urg_hole = 0;
 
+	if (sk_valid_ll(sk) && skb_queue_empty(&sk->sk_receive_queue)
+	    && (sk->sk_state == TCP_ESTABLISHED))
+		sk_poll_ll(sk, nonblock);
+
 	lock_sock(sk);
 
 	err = -ENOTCONN;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 289039b4..1063bb8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -75,6 +75,7 @@
 #include <net/netdma.h>
 #include <net/secure_seq.h>
 #include <net/tcp_memcontrol.h>
+#include <net/ll_poll.h>
 
 #include <linux/inet.h>
 #include <linux/ipv6.h>
@@ -1993,6 +1994,7 @@ process:
 	if (sk_filter(sk, skb))
 		goto discard_and_relse;
 
+	sk_mark_ll(sk, skb);
 	skb->dev = NULL;
 
 	bh_lock_sock_nested(sk);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0a17ed9..5cffa5c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -63,6 +63,7 @@
 #include <net/inet_common.h>
 #include <net/secure_seq.h>
 #include <net/tcp_memcontrol.h>
+#include <net/ll_poll.h>
 
 #include <asm/uaccess.h>
 
@@ -1498,6 +1499,7 @@ process:
 	if (sk_filter(sk, skb))
 		goto discard_and_relse;
 
+	sk_mark_ll(sk, skb);
 	skb->dev = NULL;
 
 	bh_lock_sock_nested(sk);

