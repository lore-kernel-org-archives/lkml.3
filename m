Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab3CZG34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:29:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934083Ab3CZG3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:29:37 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mst@redhat.com, Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [net-next 5/5] net_sched: better precise estimation on packet length for untrusted packets
Date: Tue, 26 Mar 2013 14:19:59 +0800
Message-Id: <1364278799-37285-6-git-send-email-jasowang@redhat.com>
In-Reply-To: <1364278799-37285-1-git-send-email-jasowang@redhat.com>
References: <1364278799-37285-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gso_segs were reset to zero when kernel receive packets from untrusted
source. But we use this zero value to estimate precise packet len which is
wrong. So this patch tries to estimate the correct gso_segs value before using
it in qdisc_pkt_len_init().

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 net/core/dev.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index de930b7..f5ad23b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2588,6 +2588,7 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
 	 */
 	if (shinfo->gso_size)  {
 		unsigned int hdr_len;
+		u16 gso_segs = shinfo->gso_segs;
 
 		/* mac layer + network layer */
 		hdr_len = skb_transport_header(skb) - skb_mac_header(skb);
@@ -2597,7 +2598,12 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
 			hdr_len += tcp_hdrlen(skb);
 		else
 			hdr_len += sizeof(struct udphdr);
-		qdisc_skb_cb(skb)->pkt_len += (shinfo->gso_segs - 1) * hdr_len;
+
+		if (shinfo->gso_type & SKB_GSO_DODGY)
+			gso_segs = DIV_ROUND_UP(skb->len - hdr_len,
+						shinfo->gso_size);
+
+		qdisc_skb_cb(skb)->pkt_len += (gso_segs - 1) * hdr_len;
 	}
 }
 
-- 
1.7.1

