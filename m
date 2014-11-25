Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaKYKlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58304 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaKYKlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Houcheng Lin <houcheng@gmail.com>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 066/254] netfilter: nf_log: release skbuff on nlmsg put failure
Date: Tue, 25 Nov 2014 10:36:56 +0000
Message-Id: <1416912004-5928-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Houcheng Lin <houcheng@gmail.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/nfnetlink_log.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 8f415d6889fe..dd9fb9de9f1d 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -346,26 +346,25 @@ nfulnl_alloc_skb(struct net *net, u32 peer_portid, unsigned int inst_size,
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
2.1.0

