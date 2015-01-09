Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbbAIP0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:26:18 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:57156 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899AbbAIP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:26:15 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t09FQCJY025965, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next v2 1/8] r8169:change rtl8168dp jumbo frame patch
Date: Fri, 9 Jan 2015 23:25:59 +0800
Message-ID: <1420817166-9868-2-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420817166-9868-1-git-send-email-hau@realtek.com>
References: <1420817166-9868-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RTL8168DP jumbo frame patch is the same as RTL8168C. So, for RTL8168DP,
change to use RTL8168C jumbo frame patch. Also reomve uncessary function
"r8168dp_hw_jumbo_enable" and "r8168dp_hw_jumbo_disable".

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 3a28059..72d15b8 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4927,20 +4927,6 @@ static void r8168c_hw_jumbo_disable(struct rtl8169_private *tp)
 	rtl_tx_performance_tweak(tp->pci_dev, 0x5 << MAX_READ_REQUEST_SHIFT);
 }
 
-static void r8168dp_hw_jumbo_enable(struct rtl8169_private *tp)
-{
-	void __iomem *ioaddr = tp->mmio_addr;
-
-	RTL_W8(Config3, RTL_R8(Config3) | Jumbo_En0);
-}
-
-static void r8168dp_hw_jumbo_disable(struct rtl8169_private *tp)
-{
-	void __iomem *ioaddr = tp->mmio_addr;
-
-	RTL_W8(Config3, RTL_R8(Config3) & ~Jumbo_En0);
-}
-
 static void r8168e_hw_jumbo_enable(struct rtl8169_private *tp)
 {
 	void __iomem *ioaddr = tp->mmio_addr;
@@ -5014,16 +5000,13 @@ static void rtl_init_jumbo_ops(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_24:
 	case RTL_GIGA_MAC_VER_25:
 	case RTL_GIGA_MAC_VER_26:
-		ops->disable	= r8168c_hw_jumbo_disable;
-		ops->enable	= r8168c_hw_jumbo_enable;
-		break;
 	case RTL_GIGA_MAC_VER_27:
 	case RTL_GIGA_MAC_VER_28:
-		ops->disable	= r8168dp_hw_jumbo_disable;
-		ops->enable	= r8168dp_hw_jumbo_enable;
+	case RTL_GIGA_MAC_VER_31:
+		ops->disable	= r8168c_hw_jumbo_disable;
+		ops->enable	= r8168c_hw_jumbo_enable;
 		break;
-	case RTL_GIGA_MAC_VER_31: /* Wild guess. Needs info from Realtek. */
-	case RTL_GIGA_MAC_VER_32:
+	case RTL_GIGA_MAC_VER_32: /* Wild guess. Needs info from Realtek. */
 	case RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_34:
 		ops->disable	= r8168e_hw_jumbo_disable;
@@ -5758,7 +5741,8 @@ static void rtl_hw_start_8168d_4(struct rtl8169_private *tp)
 
 	rtl_csi_access_enable_1(tp);
 
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+	if (tp->dev->mtu <= ETH_DATA_LEN)
+		rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
 
 	RTL_W8(MaxTxPacketSize, TxPacketMax);
 
-- 
1.9.1

