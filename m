Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaJSSIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 14:08:41 -0400
Received: from mout.gmx.net ([212.227.15.18]:64317 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaJSSIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 14:08:38 -0400
Message-ID: <5443FD47.7040003@gmx.at>
Date: Sun, 19 Oct 2014 20:04:55 +0200
From: Manfred Schlaegl <manfred.schlaegl@gmx.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manfred Schlaegl <manfred.schlaegl@ginzinger.com>
Subject: [PATCH] ipv6: tcp_v6_iff: fix compilation error on CONFIG_IPV6=n
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:9wAcTJmfUgTuqr4/y2Mu6K8uIrXVJjtXPaYkkf1lEKP/4svIVMX
 /JtvdSU+4vxnro1J86D1EkEGxJLOq4SmZ9JsWUCRsyzmvysMGmuTYuQ7gHj6+7KMycqvjW6
 jJoHY1HkgthItVLmmnhu4Q2yuUFEXNN9QQV8Hi78l81RGa5C562jgyxW065HnC8VBoZZPrj
 9eiONjRQ92OedbnPeP71Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_IPV6=n, then h6 in struct tcp_skb_cb.header is missing which
leads to compilation-errors on tcp_v6_iff like:

In file included from net/core/sock.c:140:0:
include/net/tcp.h: In function ‘tcp_v6_iif’:
include/net/tcp.h:738:32: error: ‘union <anonymous>’ has no member named
‘h6’

This fix solves the problem by removing tcp_v6_iif, in case of
CONFIG_IPV6=n.

Signed-off-by: Manfred Schlaegl <manfred.schlaegl@gmx.at>
---
 include/net/tcp.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index c9766f8..4062b4f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -730,6 +730,7 @@ struct tcp_skb_cb {
 #define TCP_SKB_CB(__skb)      ((struct tcp_skb_cb *)&((__skb)->cb[0]))


+#if IS_ENABLED(CONFIG_IPV6)
 /* This is the variant of inet6_iif() that must be used by TCP,
  * as TCP moves IP6CB into a different location in skb->cb[]
  */
@@ -737,6 +738,7 @@ static inline int tcp_v6_iif(const struct sk_buff *skb)
 {
        return TCP_SKB_CB(skb)->header.h6.iif;
 }
+#endif

 /* Due to TSO, an SKB can be composed of multiple actual
  * packets.  To keep these tracked properly, we use this.
-- 
1.7.10.4

