Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3JJPn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:43:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52626 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab3JJPnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:43:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Andrey Vagin <avagin@openvz.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 017/104] tcp: set timestamps for restored skb-s
Date: Thu, 10 Oct 2013 08:41:05 -0700
Message-Id: <1381419752-29733-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 425058e..2c108f7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1124,6 +1124,13 @@ new_segment:
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
1.8.1.2

