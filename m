Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab3KHCVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:21:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab3KHCVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mariusz Ceier <mceier+kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 39/91] davinci_emac.c: Fix IFF_ALLMULTI setup
Date: Thu,  7 Nov 2013 18:14:54 -0800
Message-Id: <1383876946-2396-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mariusz Ceier <mceier+kernel@gmail.com>

[ Upstream commit d69e0f7ea95fef8059251325a79c004bac01f018 ]

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
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/ti/davinci_emac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 4ebcb24..17a3028 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -878,8 +878,7 @@ static void emac_dev_mcast_set(struct net_device *ndev)
 		    netdev_mc_count(ndev) > EMAC_DEF_MAX_MULTICAST_ADDRESSES) {
 			mbp_enable = (mbp_enable | EMAC_MBP_RXMCAST);
 			emac_add_mcast(priv, EMAC_ALL_MULTI_SET, NULL);
-		}
-		if (!netdev_mc_empty(ndev)) {
+		} else if (!netdev_mc_empty(ndev)) {
 			struct netdev_hw_addr *ha;
 
 			mbp_enable = (mbp_enable | EMAC_MBP_RXMCAST);
-- 
1.8.1.2

