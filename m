Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaJMGuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:50:35 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:57219 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaJMGud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:50:33 -0400
MIME-Version: 1.0
Date: Mon, 13 Oct 2014 14:50:32 +0800
Message-ID: <CAL8JtxAqDhOXooLtOebSBHtKxwE=sLFqW8B-VgtCzsr-M4OD7g@mail.gmail.com>
Subject: [PATCH] netfilter: release skbuf when nlmsg put fail
From: Houcheng Lin <houcheng@gmail.com>
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        davem@davemloft.net, netfilter-devel@vger.kernel.org
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
 net/netfilter/nfnetlink_log.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index a11c5ff..0cb9ede 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -358,10 +358,9 @@ __nfulnl_send(struct nfulnl_instance *inst)
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
