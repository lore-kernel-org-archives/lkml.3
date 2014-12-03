Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaLCLnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:43:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbaLCL1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:35 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Houcheng Lin <houcheng@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 063/101] netfilter: nf_log: release skbuff on nlmsg put failure
Date: Wed,  3 Dec 2014 12:26:25 +0100
Message-Id: <37bdac282ed1d1f2641ba9063f50cf42bcb94dc4.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Houcheng Lin <houcheng@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b51d3fa364885a2c1e1668f88776c67c95291820 upstream.

The kernel should reserve enough room in the skb so that the DONE
message can always be appended.  However, in case of e.g. new attribute
erronously not being size-accounted for, __nfulnl_send() will still
try to put next nlmsg into this full skbuf, causing the skb to be stuck
forever and blocking delivery of further messages.

Fix issue by releasing skb immediately after nlmsg_put error and
WARN() so we can track down the cause of such size mismatch.

[ fw@strlen.de: add tailroom/len info to WARN ]

Signed-off-by: Houcheng Lin <houcheng@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/netfilter/nfnetlink_log.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 39010fc1e9c0..09172d7abee2 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -348,26 +348,25 @@ nfulnl_alloc_skb(u32 peer_portid, unsigned int inst_size, unsigned int pkt_size)
 	return skb;
 }
 
-static int
+static void
 __nfulnl_send(struct nfulnl_instance *inst)
 {
-	int status = -1;
-
 	if (inst->qlen > 1) {
 		struct nlmsghdr *nlh = nlmsg_put(inst->skb, 0, 0,
 						 NLMSG_DONE,
 						 sizeof(struct nfgenmsg),
 						 0);
-		if (!nlh)
+		if (WARN_ONCE(!nlh, "bad nlskb size: %u, tailroom %d\n",
+			      inst->skb->len, skb_tailroom(inst->skb))) {
+			kfree_skb(inst->skb);
 			goto out;
+		}
 	}
-	status = nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid,
-				   MSG_DONTWAIT);
-
+	nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid,
+			  MSG_DONTWAIT);
+out:
 	inst->qlen = 0;
 	inst->skb = NULL;
-out:
-	return status;
 }
 
 static void
-- 
2.1.3

