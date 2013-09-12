Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3ILSVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:21:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3ILR7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Andrey Vagin <avagin@openvz.org>
Subject: [ 22/46] tcp: set timestamps for restored skb-s
Date: Thu, 12 Sep 2013 10:58:33 -0700
Message-Id: <20130912175723.433636102@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vagin <avagin@openvz.org>

[ Upstream commit 7ed5c5ae96d23da22de95e1c7a239537acd378b1 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1118,6 +1118,13 @@ new_segment:
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


