Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaJNJmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:42:21 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:59427 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaJNJmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:42:19 -0400
MIME-Version: 1.0
Date: Tue, 14 Oct 2014 17:42:18 +0800
Message-ID: <CAL8JtxD=Vopo7fvKEnfKgOa3T=WyVH=mb_YqX9mES+n-6dJbrQ@mail.gmail.com>
Subject: [PATCH v2] netfilter: release skbuf when nlmsg put fail
From: Houcheng Lin <houcheng@gmail.com>
To: pablo@netfilter.org, Patrick McHardy <kaber@trash.net>,
        kadlec@blackhole.kfki.hu, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Cc: coreteam@netfilter.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When system is under heavy loading, the __nfulnl_send() may may failed
to put nlmsg into skbuf of nfulnl_instance. If not clear the skbuff on failed,
the __nfulnl_send() will still try to put next nlmsg onto this half-full skbuf
and cause the user program can never receive packet.

This patch fix this issue by releasing skbuf immediately after nlmst put
failed.

Signed-off-by: Houcheng Lin <houcheng@gmail.com>
---
 net/netfilter/nfnetlink_log.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index a11c5ff..0ad5d32 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -353,15 +353,17 @@ __nfulnl_send(struct nfulnl_instance *inst)
  NLMSG_DONE,
  sizeof(struct nfgenmsg),
  0);
- if (!nlh)
+ if (!nlh) {
+ WARN_ON(1);
+ kfree_skb(inst->skb);
  goto out;
+ }
  }
  status = nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid,
    MSG_DONTWAIT);
-
+out:
  inst->qlen = 0;
  inst->skb = NULL;
-out:
  return status;
 }

-- 
1.7.9.5
