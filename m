Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaEEPnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:43:23 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:45149 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbaEEPnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:43:22 -0400
Date: Mon, 5 May 2014 17:43:18 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: davem@davemloft.net, steffen.klassert@secunet.com, fan.du@windriver.com,
        dborkman@redhat.com, minipli@googlemail.com, tgraf@suug.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH] netdev: pktgen xmit packet through vlan interface
Message-ID: <20140505154318.GC2944@minipsycho.brq.redhat.com>
References: <1399015092-28643-1-git-send-email-zhouzhouyi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399015092-28643-1-git-send-email-zhouzhouyi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fri, May 02, 2014 at 09:18:12AM CEST, zhouzhouyi@gmail.com wrote:
>As http://www.spinics.net/lists/netdev/msg165015.html
>pktgen generates shared packet through vlan interface will cause
>oops because of duplicate entering tc queue.
>
>Try to solve this problem by means of packet clone instead of sharing.

Isn't this prohibited by:
dev->priv_flags         &= ~(IFF_TX_SKB_SHARING);
?

>
>Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
>---
> net/core/pktgen.c |   20 +++++++++++++++++---
> 1 files changed, 17 insertions(+), 3 deletions(-)
>
>diff --git a/net/core/pktgen.c b/net/core/pktgen.c
>index 0304f98..ced07fc 100644
>--- a/net/core/pktgen.c
>+++ b/net/core/pktgen.c
>@@ -3297,6 +3297,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
> 	netdev_tx_t (*xmit)(struct sk_buff *, struct net_device *)
> 		= odev->netdev_ops->ndo_start_xmit;
> 	struct netdev_queue *txq;
>+	struct sk_buff *nskb = NULL;
> 	u16 queue_map;
> 	int ret;
> 
>@@ -3347,8 +3348,18 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
> 		pkt_dev->last_ok = 0;
> 		goto unlock;
> 	}
>-	atomic_inc(&(pkt_dev->skb->users));
>-	ret = (*xmit)(pkt_dev->skb, odev);
>+
>+	if (pkt_dev->clone_skb && is_vlan_dev(odev)) {
>+		nskb = skb_clone(pkt_dev->skb, GFP_ATOMIC);
>+		ret = -ENOMEM;
>+		if (nskb)
>+			ret = (*xmit)(nskb, odev);
>+		else
>+			nskb = ERR_PTR(ret);
>+	} else {
>+		atomic_inc(&(pkt_dev->skb->users));
>+		ret = (*xmit)(pkt_dev->skb, odev);
>+	}
> 
> 	switch (ret) {
> 	case NETDEV_TX_OK:
>@@ -3372,7 +3383,10 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
> 	case NETDEV_TX_LOCKED:
> 	case NETDEV_TX_BUSY:
> 		/* Retry it next time */
>-		atomic_dec(&(pkt_dev->skb->users));
>+		if (nskb && !IS_ERR(nskb))
>+			kfree_skb(nskb);
>+		else
>+			atomic_dec(&(pkt_dev->skb->users));
> 		pkt_dev->last_ok = 0;
> 	}
> unlock:
>-- 
>1.7.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe netdev" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
