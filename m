Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaHKRcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:32:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27224 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbaHKRca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:32:30 -0400
X-IronPort-AV: E=Sophos;i="5.01,843,1400025600"; 
   d="scan'208";a="161325072"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Paul Durrant <paul.durrant@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH] xen-netfront: Fix handling packets on compound pages with skb_linearize
Date: Mon, 11 Aug 2014 18:32:23 +0100
Message-ID: <1407778343-13622-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a long known problem with the netfront/netback interface: if the guest
tries to send a packet which constitues more than MAX_SKB_FRAGS + 1 ring slots,
it gets dropped. The reason is that netback maps these slots to a frag in the
frags array, which is limited by size. Having so many slots can occur since
compound pages were introduced, as the ring protocol slice them up into
individual (non-compound) page aligned slots. The theoretical worst case
scenario looks like this (note, skbs are limited to 64 Kb here):
linear buffer: at most PAGE_SIZE - 17 * 2 bytes, overlapping page boundary,
using 2 slots
first 15 frags: 1 + PAGE_SIZE + 1 bytes long, first and last bytes are at the
end and the beginning of a page, therefore they use 3 * 15 = 45 slots
last 2 frags: 1 + 1 bytes, overlapping page boundary, 2 * 2 = 4 slots
Although I don't think this 51 slots skb can really happen, we need a solution
which can deal with every scenario. In real life there is only a few slots
overdue, but usually it causes the TCP stream to be blocked, as the retry will
most likely have the same buffer layout.
This patch solves this problem by linearizing the packet. This is not the
fastest way, and it can fail much easier as it tries to allocate a big linear
area for the whole packet, but probably easier by an order of magnitude than
anything else. Probably this code path is not touched very frequently anyway.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Wei Liu <wei.liu2@citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Paul Durrant <paul.durrant@citrix.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 055222b..23359ae 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -628,9 +628,10 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	slots = DIV_ROUND_UP(offset + len, PAGE_SIZE) +
 		xennet_count_skb_frag_slots(skb);
 	if (unlikely(slots > MAX_SKB_FRAGS + 1)) {
-		net_alert_ratelimited(
-			"xennet: skb rides the rocket: %d slots\n", slots);
-		goto drop;
+		net_dbg_ratelimited("xennet: skb rides the rocket: %d slots, %d bytes\n",
+				    slots, skb->len);
+		if (skb_linearize(skb))
+			goto drop;
 	}
 
 	spin_lock_irqsave(&queue->tx_lock, flags);
