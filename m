Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3FYSx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:53:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3FYSeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 81/95] net_sched: better precise estimation on packet length for untrusted packets
Date: Tue, 25 Jun 2013 11:33:08 -0700
Message-Id: <20130625182202.724012020@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 15e5a030716468dce4032fa0f398d840fa2756f6 ]

gso_segs were reset to zero when kernel receive packets from untrusted
source. But we use this zero value to estimate precise packet len which is
wrong. So this patch tries to estimate the correct gso_segs value before using
it in qdisc_pkt_len_init().

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2592,6 +2592,7 @@ static void qdisc_pkt_len_init(struct sk
 	 */
 	if (shinfo->gso_size)  {
 		unsigned int hdr_len;
+		u16 gso_segs = shinfo->gso_segs;
 
 		/* mac layer + network layer */
 		hdr_len = skb_transport_header(skb) - skb_mac_header(skb);
@@ -2601,7 +2602,12 @@ static void qdisc_pkt_len_init(struct sk
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
 


