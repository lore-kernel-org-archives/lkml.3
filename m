Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaKPWBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:01:00 -0500
Received: from 1wt.eu ([62.212.114.60]:47935 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaKPWA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:56 -0500
Message-Id: <20141116215330.143419127@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:54:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 36/48] netfilter: nf_log: account for size of NLMSG_DONE
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 attribute

From: Florian Westphal <fw@strlen.de>

We currently neither account for the nlattr size, nor do we consider
the size of the trailing NLMSG_DONE when allocating nlmsg skb.

This can result in nflog to stop working, as __nfulnl_send() re-tries
sending forever if it failed to append NLMSG_DONE (which will never
work if buffer is not large enough).

Reported-by: Houcheng Lin <houcheng@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit 9dfa1dfe4d5e5e66a991321ab08afe69759d797a)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/netfilter/nfnetlink_log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index f900dc3..a5f02eb 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -579,7 +579,8 @@ nfulnl_log_packet(u_int8_t pf,
 		+ nla_total_size(sizeof(u_int32_t))	/* gid */
 		+ nla_total_size(plen)			/* prefix */
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
-		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp));
+		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
+		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
 		size +=   nla_total_size(skb->dev->hard_header_len)
@@ -621,8 +622,7 @@ nfulnl_log_packet(u_int8_t pf,
 		goto unlock_and_release;
 	}
 
-	if (inst->skb &&
-	    size > skb_tailroom(inst->skb) - sizeof(struct nfgenmsg)) {
+	if (inst->skb && size > skb_tailroom(inst->skb)) {
 		/* either the queue len is too high or we don't have
 		 * enough room in the skb left. flush to userspace. */
 		__nfulnl_flush(inst);
-- 
1.7.12.2.21.g234cd45.dirty



