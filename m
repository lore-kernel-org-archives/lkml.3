Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaLCLnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:43:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaLCL1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:35 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 061/101] netfilter: nf_log: account for size of NLMSG_DONE attribute
Date: Wed,  3 Dec 2014 12:26:23 +0100
Message-Id: <131172845aa2c804ffa9423455aee585061ea35e.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9dfa1dfe4d5e5e66a991321ab08afe69759d797a upstream.

We currently neither account for the nlattr size, nor do we consider
the size of the trailing NLMSG_DONE when allocating nlmsg skb.

This can result in nflog to stop working, as __nfulnl_send() re-tries
sending forever if it failed to append NLMSG_DONE (which will never
work if buffer is not large enough).

Reported-by: Houcheng Lin <houcheng@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/netfilter/nfnetlink_log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d92cc317bf8b..65791530f460 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -651,7 +651,8 @@ nfulnl_log_packet(struct net *net,
 		+ nla_total_size(sizeof(u_int32_t))	/* gid */
 		+ nla_total_size(plen)			/* prefix */
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
-		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp));
+		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
+		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
 		size +=   nla_total_size(skb->dev->hard_header_len)
@@ -694,8 +695,7 @@ nfulnl_log_packet(struct net *net,
 		goto unlock_and_release;
 	}
 
-	if (inst->skb &&
-	    size > skb_tailroom(inst->skb) - sizeof(struct nfgenmsg)) {
+	if (inst->skb && size > skb_tailroom(inst->skb)) {
 		/* either the queue len is too high or we don't have
 		 * enough room in the skb left. flush to userspace. */
 		__nfulnl_flush(inst);
-- 
2.1.3

