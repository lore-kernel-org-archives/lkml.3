Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbaKSVBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:01:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195AbaKSVBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:01:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Houcheng Lin <houcheng@gmail.com>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.17 125/141] netfilter: nf_log: release skbuff on nlmsg put failure
Date: Wed, 19 Nov 2014 12:52:28 -0800
Message-Id: <20141119205154.915892626@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nfnetlink_log.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -346,26 +346,25 @@ nfulnl_alloc_skb(struct net *net, u32 pe
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


