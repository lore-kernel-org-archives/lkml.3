Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422940Ab3BANOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:14:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:45610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422625Ab3BANOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:14:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Hockney <bhockney@ix.netcom.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 77/89] netfilter: nfnetlink_log: fix mac address for 6in4 tunnels
Date: Fri,  1 Feb 2013 14:08:32 +0100
Message-Id: <20130201130213.030575476@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Hockney <bhockney@ix.netcom.com>

commit 0c36b48b36dc84d4215dc9d1cde1bda829214ba6 upstream.

For tunnelled ipv6in4 packets, the LOG target (xt_LOG.c) adjusts
the start of the mac field to start at the ethernet header instead
of the ipv4 header for the tunnel. This patch conforms what is
passed by the NFLOG target through nfnetlink to what the LOG target
does. Code borrowed from xt_LOG.c.

Signed-off-by: Bob Hockney <bhockney@ix.netcom.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nfnetlink_log.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -384,6 +384,7 @@ __build_packet_message(struct nfulnl_ins
 	struct nfgenmsg *nfmsg;
 	sk_buff_data_t old_tail = inst->skb->tail;
 	struct sock *sk;
+	const unsigned char *hwhdrp;
 
 	nlh = nlmsg_put(inst->skb, 0, 0,
 			NFNL_SUBSYS_ULOG << 8 | NFULNL_MSG_PACKET,
@@ -485,9 +486,17 @@ __build_packet_message(struct nfulnl_ins
 	if (indev && skb_mac_header_was_set(skb)) {
 		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
 		    nla_put_be16(inst->skb, NFULA_HWLEN,
-				 htons(skb->dev->hard_header_len)) ||
-		    nla_put(inst->skb, NFULA_HWHEADER, skb->dev->hard_header_len,
-			    skb_mac_header(skb)))
+				 htons(skb->dev->hard_header_len)))
+			goto nla_put_failure;
+
+		hwhdrp = skb_mac_header(skb);
+
+		if (skb->dev->type == ARPHRD_SIT)
+			hwhdrp -= ETH_HLEN;
+
+		if (hwhdrp >= skb->head &&
+		    nla_put(inst->skb, NFULA_HWHEADER,
+			    skb->dev->hard_header_len, hwhdrp))
 			goto nla_put_failure;
 	}
 


