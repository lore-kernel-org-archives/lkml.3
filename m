Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbbA2DBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:01:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47010 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965327AbbA2Chr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:47 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zoltan Kiss <zoltan.kiss@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Paul Durrant <paul.durrant@citrix.com>, netdev@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Bader <stefan.bader@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 017/139] xen-netfront: Fix handling packets on compound pages with skb_linearize
Date: Wed, 28 Jan 2015 14:19:20 -0800
Message-Id: <1422483682-15393-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zoltan Kiss <zoltan.kiss@citrix.com>

commit 97a6d1bb2b658ac85ed88205ccd1ab809899884d upstream.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
BugLink: http://bugs.launchpad.net/bugs/1317811
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/xen-netfront.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index d58830b..a3ed8de 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -568,9 +568,10 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
 
 	spin_lock_irqsave(&np->tx_lock, flags);
-- 
1.9.1

