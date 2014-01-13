Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaAMQFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:05:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53746 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbaAMQFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Frank Li <Frank.Li@freescale.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 184/208] net: fec: fix potential use after free
Date: Mon, 13 Jan 2014 16:00:25 +0000
Message-Id: <1389628849-1614-185-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 7a2a84518cfb263d2c4171b3d63671f88316adb2 upstream.

skb_tx_timestamp(skb) should be called _before_ TX completion
has a chance to trigger, otherwise it is too late and we access
freed memory.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: de5fb0a05348 ("net: fec: put tx to napi poll function to fix dead lock")
Cc: Frank Li <Frank.Li@freescale.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Frank Li <Frank.Li@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c610a27..2cb8401 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -394,6 +394,8 @@ fec_enet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	else
 		bdp = fec_enet_get_nextdesc(bdp, fep->bufdesc_ex);
 
+	skb_tx_timestamp(skb);
+
 	fep->cur_tx = bdp;
 
 	if (fep->cur_tx == fep->dirty_tx)
@@ -402,8 +404,6 @@ fec_enet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Trigger transmission start */
 	writel(0, fep->hwp + FEC_X_DES_ACTIVE);
 
-	skb_tx_timestamp(skb);
-
 	return NETDEV_TX_OK;
 }
 
-- 
1.8.3.2

