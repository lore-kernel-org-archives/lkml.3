Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab3KHCRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34528 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab3KHCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Yuchung Cheng <ycheng@google.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 12/91] tcp: do not forget FIN in tcp_shifted_skb()
Date: Thu,  7 Nov 2013 18:14:27 -0800
Message-Id: <1383876946-2396-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5e8a402f831dbe7ee831340a91439e46f0d38acd ]

Yuchung found following problem :

 There are bugs in the SACK processing code, merging part in
 tcp_shift_skb_data(), that incorrectly resets or ignores the sacked
 skbs FIN flag. When a receiver first SACK the FIN sequence, and later
 throw away ofo queue (e.g., sack-reneging), the sender will stop
 retransmitting the FIN flag, and hangs forever.

Following packetdrill test can be used to reproduce the bug.

$ cat sack-merge-bug.pkt
`sysctl -q net.ipv4.tcp_fack=0`

// Establish a connection and send 10 MSS.
0.000 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
+.000 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
+.000 bind(3, ..., ...) = 0
+.000 listen(3, 1) = 0

+.050 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
+.000 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK,nop,wscale 6>
+.001 < . 1:1(0) ack 1 win 1024
+.000 accept(3, ..., ...) = 4

+.100 write(4, ..., 12000) = 12000
+.000 shutdown(4, SHUT_WR) = 0
+.000 > . 1:10001(10000) ack 1
+.050 < . 1:1(0) ack 2001 win 257
+.000 > FP. 10001:12001(2000) ack 1
+.050 < . 1:1(0) ack 2001 win 257 <sack 10001:11001,nop,nop>
+.050 < . 1:1(0) ack 2001 win 257 <sack 10001:12002,nop,nop>
// SACK reneg
+.050 < . 1:1(0) ack 12001 win 257
+0 %{ print "unacked: ",tcpi_unacked }%
+5 %{ print "" }%

First, a typo inverted left/right of one OR operation, then
code forgot to advance end_seq if the merged skb carried FIN.

Bug was added in 2.6.29 by commit 832d11c5cd076ab
("tcp: Try to restore large SKBs while SACK processing")

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp_input.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b2263d8..9bef66b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1300,7 +1300,10 @@ static bool tcp_shifted_skb(struct sock *sk, struct sk_buff *skb,
 		tp->lost_cnt_hint -= tcp_skb_pcount(prev);
 	}
 
-	TCP_SKB_CB(skb)->tcp_flags |= TCP_SKB_CB(prev)->tcp_flags;
+	TCP_SKB_CB(prev)->tcp_flags |= TCP_SKB_CB(skb)->tcp_flags;
+	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
+		TCP_SKB_CB(prev)->end_seq++;
+
 	if (skb == tcp_highest_sack(sk))
 		tcp_advance_highest_sack(sk, skb);
 
-- 
1.8.1.2

