Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3F1S5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:57:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41904 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3F1S5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 091/105] net: sh_eth: fix incorrect RX length error if R8A7740
Date: Fri, 28 Jun 2013 11:51:53 -0700
Message-Id: <1372445527-24414-92-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit dd019897358b815f7828dab90b51d51df4d3658d ]

This patch fixes an issue that the driver increments the "RX length error"
on every buffer in sh_eth_rx() if the R8A7740.
This patch also adds a description about the Receive Frame Status bits.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/renesas/sh_eth.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 3d70586..520161c 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1102,16 +1102,23 @@ static int sh_eth_rx(struct net_device *ndev, u32 intr_status)
 		desc_status = edmac_to_cpu(mdp, rxdesc->status);
 		pkt_len = rxdesc->frame_length;
 
-#if defined(CONFIG_ARCH_R8A7740)
-		desc_status >>= 16;
-#endif
-
 		if (--boguscnt < 0)
 			break;
 
 		if (!(desc_status & RDFEND))
 			ndev->stats.rx_length_errors++;
 
+#if defined(CONFIG_ARCH_R8A7740)
+		/*
+		 * In case of almost all GETHER/ETHERs, the Receive Frame State
+		 * (RFS) bits in the Receive Descriptor 0 are from bit 9 to
+		 * bit 0. However, in case of the R8A7740's GETHER, the RFS
+		 * bits are from bit 25 to bit 16. So, the driver needs right
+		 * shifting by 16.
+		 */
+		desc_status >>= 16;
+#endif
+
 		if (desc_status & (RD_RFS1 | RD_RFS2 | RD_RFS3 | RD_RFS4 |
 				   RD_RFS5 | RD_RFS6 | RD_RFS10)) {
 			ndev->stats.rx_errors++;
-- 
1.8.1.2

