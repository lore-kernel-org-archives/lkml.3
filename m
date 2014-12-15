Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaLOOjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:39:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38839 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaLOO2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Roese <sr@denx.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 124/168] net: sun4i-emac: fix memory leak on bad packet
Date: Mon, 15 Dec 2014 14:26:18 +0000
Message-Id: <1418653622-21105-125-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <marc.zyngier@arm.com>

commit 2670cc699a66c4cf268cb3e3f6dfc325ec14f224 upstream.

Upon reception of a new frame, the emac driver checks for a number
of error conditions, and flag the packet as "bad" if any of these
are present. It then allocates a skb unconditionally, but only uses
it if the packet is "good". On the error path, the skb is just forgotten,
and the system leaks memory.

The piece of junk I have on my desk seems to encounter such error
frequently enough so that the box goes OOM after a couple of days,
which makes me grumpy.

Fix this by moving the allocation on the "good_packet" path (and
convert it to netdev_alloc_skb while we're at it).

Tested on a random Allwinner A20 board.

Cc: Stefan Roese <sr@denx.de>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index d81e7167a8b5..29b9f082475d 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -633,8 +633,10 @@ static void emac_rx(struct net_device *dev)
 		}
 
 		/* Move data from EMAC */
-		skb = dev_alloc_skb(rxlen + 4);
-		if (good_packet && skb) {
+		if (good_packet) {
+			skb = netdev_alloc_skb(dev, rxlen + 4);
+			if (!skb)
+				continue;
 			skb_reserve(skb, 2);
 			rdptr = (u8 *) skb_put(skb, rxlen - 4);
 
-- 
2.1.3

