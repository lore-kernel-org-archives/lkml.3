Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3EUO1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:27:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:17359 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab3EUO1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:27:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,714,1363158000"; 
   d="scan'208";a="340832155"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v4 net-next 2/4] tcp: add TCP support for low latency receive
 poll.
To: Dave Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Or Gerlitz <or.gerlitz@gmail.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 17:27:00 +0300
Message-ID: <20130521142659.18498.1984.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130521142641.18498.52856.stgit@ladj378.jer.intel.com>
References: <20130521142641.18498.52856.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adds busy-poll support for TCP.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---

 net/ipv4/tcp.c       |    9 +++++++++
 net/ipv4/tcp_input.c |    4 ++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index dcb116d..b9cc512 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -279,6 +279,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
+#include <net/ll_poll.h>
 
 int sysctl_tcp_fin_timeout __read_mostly = TCP_FIN_TIMEOUT;
 
@@ -1504,6 +1505,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 			if (offset + 1 != skb->len)
 				continue;
 		}
+		sk_mark_ll(sk, skb);
 		if (tcp_hdr(skb)->fin) {
 			sk_eat_skb(sk, skb, false);
 			++seq;
@@ -1551,6 +1553,12 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	struct sk_buff *skb;
 	u32 urg_hole = 0;
 
+#ifdef CONFIG_INET_LL_RX_POLL
+	if (sk_valid_ll(sk) && skb_queue_empty(&sk->sk_receive_queue)
+	    && (sk->sk_state == TCP_ESTABLISHED))
+		sk_poll_ll(sk, nonblock);
+#endif
+
 	lock_sock(sk);
 
 	err = -ENOTCONN;
@@ -1855,6 +1863,7 @@ do_prequeue:
 					break;
 				}
 			}
+			sk_mark_ll(sk, skb);
 		}
 
 		*seq += used;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b358e8c..f3f293b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -74,6 +74,7 @@
 #include <linux/ipsec.h>
 #include <asm/unaligned.h>
 #include <net/netdma.h>
+#include <net/ll_poll.h>
 
 int sysctl_tcp_timestamps __read_mostly = 1;
 int sysctl_tcp_window_scaling __read_mostly = 1;
@@ -4329,6 +4330,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 				tp->copied_seq += chunk;
 				eaten = (chunk == skb->len);
 				tcp_rcv_space_adjust(sk);
+				sk_mark_ll(sk, skb);
 			}
 			local_bh_disable();
 		}
@@ -4896,6 +4898,7 @@ static int tcp_copy_to_iovec(struct sock *sk, struct sk_buff *skb, int hlen)
 		tp->ucopy.len -= chunk;
 		tp->copied_seq += chunk;
 		tcp_rcv_space_adjust(sk);
+		sk_mark_ll(sk, skb);
 	}
 
 	local_bh_disable();
@@ -4955,6 +4958,7 @@ static bool tcp_dma_try_early_copy(struct sock *sk, struct sk_buff *skb,
 		tp->ucopy.len -= chunk;
 		tp->copied_seq += chunk;
 		tcp_rcv_space_adjust(sk);
+		sk_mark_ll(sk, skb);
 
 		if ((tp->ucopy.len == 0) ||
 		    (tcp_flag_word(tcp_hdr(skb)) & TCP_FLAG_PSH) ||

