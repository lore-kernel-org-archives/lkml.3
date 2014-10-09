Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbaJIVdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:33:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59264 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472AbaJIVIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yaniv Rosner <yaniv.rosner@qlogic.com>,
        Yuval Mintz <yuval.mintz@qlogic.com>,
        Ariel Elior <ariel.elior@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Brad Figg <brad.figg@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 116/163] bnx2x: Fix link for KR with swapped polarity lane
Date: Thu,  9 Oct 2014 14:02:21 -0700
Message-Id: <1412888588-26755-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yaniv Rosner <yaniv.rosner@qlogic.com>

commit dad91ee478c7f39e04a33272732147b8c274bb58 upstream.

This avoids clearing the RX polarity setting in KR mode when polarity lane
is swapped, as otherwise this will result in failed link.

Signed-off-by: Yaniv Rosner <yaniv.rosner@qlogic.com>
Signed-off-by: Yuval Mintz <yuval.mintz@qlogic.com>
Signed-off-by: Ariel Elior <ariel.elior@qlogic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: Brad Figg <brad.figg@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c | 25 ++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 11fc795..26bb478 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -3749,7 +3749,8 @@ static void bnx2x_warpcore_restart_AN_KR(struct bnx2x_phy *phy,
 static void bnx2x_warpcore_enable_AN_KR(struct bnx2x_phy *phy,
 					struct link_params *params,
 					struct link_vars *vars) {
-	u16 lane, i, cl72_ctrl, an_adv = 0;
+	u16 lane, i, cl72_ctrl, an_adv = 0, val;
+	u32 wc_lane_config;
 	struct bnx2x *bp = params->bp;
 	static struct bnx2x_reg_set reg_set[] = {
 		{MDIO_WC_DEVAD, MDIO_WC_REG_SERDESDIGITAL_CONTROL1000X2, 0x7},
@@ -3868,15 +3869,27 @@ static void bnx2x_warpcore_enable_AN_KR(struct bnx2x_phy *phy,
 		/* Enable Auto-Detect to support 1G over CL37 as well */
 		bnx2x_cl45_write(bp, phy, MDIO_WC_DEVAD,
 				 MDIO_WC_REG_SERDESDIGITAL_CONTROL1000X1, 0x10);
-
+		wc_lane_config = REG_RD(bp, params->shmem_base +
+					offsetof(struct shmem_region, dev_info.
+					shared_hw_config.wc_lane_config));
+		bnx2x_cl45_read(bp, phy, MDIO_WC_DEVAD,
+				MDIO_WC_REG_RX0_PCI_CTRL + (lane << 4), &val);
 		/* Force cl48 sync_status LOW to avoid getting stuck in CL73
 		 * parallel-detect loop when CL73 and CL37 are enabled.
 		 */
-		CL22_WR_OVER_CL45(bp, phy, MDIO_REG_BANK_AER_BLOCK,
-				  MDIO_AER_BLOCK_AER_REG, 0);
+		val |= 1 << 11;
+
+		/* Restore Polarity settings in case it was run over by
+		 * previous link owner
+		 */
+		if (wc_lane_config &
+		    (SHARED_HW_CFG_RX_LANE0_POL_FLIP_ENABLED << lane))
+			val |= 3 << 2;
+		else
+			val &= ~(3 << 2);
 		bnx2x_cl45_write(bp, phy, MDIO_WC_DEVAD,
-				 MDIO_WC_REG_RXB_ANA_RX_CONTROL_PCI, 0x0800);
-		bnx2x_set_aer_mmd(params, phy);
+				 MDIO_WC_REG_RX0_PCI_CTRL + (lane << 4),
+				 val);
 
 		bnx2x_disable_kr2(params, vars, phy);
 	}
-- 
1.9.1

