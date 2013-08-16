Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3HPPIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:08:05 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:5058 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab3HPPIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:08:01 -0400
From: Andrey Vagin <avagin@openvz.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH] tcp: set timestamps for restored skb-s
Date: Fri, 16 Aug 2013 19:04:36 +0400
Message-Id: <1376665476-9683-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the repair mode is turned off, the write queue seqs are
updated so that the whole queue is considered to be 'already sent.

The "when" field must be set for such skb. It's used in tcp_rearm_rto
for example. If the "when" field isn't set, the retransmit timeout can
be calculated incorrectly and a tcp connected can stop for two minutes
(TCP_RTO_MAX).

Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 net/ipv4/tcp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5423223..b2f6c74 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1121,6 +1121,13 @@ new_segment:
 					goto wait_for_memory;
 
 				/*
+				 * All packets are restored as if they have
+				 * already been sent.
+				 */
+				if (tp->repair)
+					TCP_SKB_CB(skb)->when = tcp_time_stamp;
+
+				/*
 				 * Check whether we can use HW checksum.
 				 */
 				if (sk->sk_route_caps & NETIF_F_ALL_CSUM)
-- 
1.8.3.1

