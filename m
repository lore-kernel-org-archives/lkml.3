Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbaKSVB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:01:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbaKSVBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:01:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Houcheng Lin <houcheng@gmail.com>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.17 123/141] netfilter: nf_log: account for size of NLMSG_DONE attribute
Date: Wed, 19 Nov 2014 12:52:26 -0800
Message-Id: <20141119205154.749395089@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 9dfa1dfe4d5e5e66a991321ab08afe69759d797a upstream.

We currently neither account for the nlattr size, nor do we consider
the size of the trailing NLMSG_DONE when allocating nlmsg skb.

This can result in nflog to stop working, as __nfulnl_send() re-tries
sending forever if it failed to append NLMSG_DONE (which will never
work if buffer is not large enough).

Reported-by: Houcheng Lin <houcheng@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nfnetlink_log.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -649,7 +649,8 @@ nfulnl_log_packet(struct net *net,
 		+ nla_total_size(sizeof(u_int32_t))	/* gid */
 		+ nla_total_size(plen)			/* prefix */
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
-		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp));
+		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
+		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
 		size +=   nla_total_size(skb->dev->hard_header_len)
@@ -692,8 +693,7 @@ nfulnl_log_packet(struct net *net,
 		goto unlock_and_release;
 	}
 
-	if (inst->skb &&
-	    size > skb_tailroom(inst->skb) - sizeof(struct nfgenmsg)) {
+	if (inst->skb && size > skb_tailroom(inst->skb)) {
 		/* either the queue len is too high or we don't have
 		 * enough room in the skb left. flush to userspace. */
 		__nfulnl_flush(inst);


