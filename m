Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab3JURpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:45:03 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:59775 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3JURpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:45:01 -0400
From: Mariusz Ceier <mceier+kernel@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        "Lad Prabhakar" <prabhakar.csengg@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mariusz Ceier <mceier+kernel@gmail.com>
Subject: [PATCH] davinci_emac.c: Fix IFF_ALLMULTI setup
Date: Mon, 21 Oct 2013 19:45:04 +0200
Message-Id: <1382377504-24688-1-git-send-email-mceier+kernel@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <5265640C.4070201@cogentembedded.com>
References: <5265640C.4070201@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When IFF_ALLMULTI flag is set on interface and IFF_PROMISC isn't,
emac_dev_mcast_set should only enable RX of multicasts and reset
MACHASH registers.

It does this, but afterwards it either sets up multicast MACs
filtering or disables RX of multicasts and resets MACHASH registers
again, rendering IFF_ALLMULTI flag useless.

This patch fixes emac_dev_mcast_set, so that multicast MACs filtering and
disabling of RX of multicasts are skipped when IFF_ALLMULTI flag is set.

Tested with kernel 2.6.37.

Signed-off-by: Mariusz Ceier <mceier+kernel@gmail.com>
---
 drivers/net/ethernet/ti/davinci_emac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 67df09e..6a32ef9 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -876,8 +876,7 @@ static void emac_dev_mcast_set(struct net_device *ndev)
 		    netdev_mc_count(ndev) > EMAC_DEF_MAX_MULTICAST_ADDRESSES) {
 			mbp_enable = (mbp_enable | EMAC_MBP_RXMCAST);
 			emac_add_mcast(priv, EMAC_ALL_MULTI_SET, NULL);
-		}
-		if (!netdev_mc_empty(ndev)) {
+		} else if (!netdev_mc_empty(ndev)) {
 			struct netdev_hw_addr *ha;
 
 			mbp_enable = (mbp_enable | EMAC_MBP_RXMCAST);
-- 
1.8.4

