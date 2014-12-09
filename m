Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaLIQrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:47:09 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49403 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788AbaLIQqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:46:22 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB9GkKb8027229, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next 7/9] r8169:update rtl8168dp ephy parameter
Date: Wed, 10 Dec 2014 00:46:01 +0800
Message-ID: <1418143563-7652-8-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418143563-7652-1-git-send-email-hau@realtek.com>
References: <1418143563-7652-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update rtl8168dp ephy parameter to improve pcie compatibility.

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 39 ++++++++----------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index a979519..42eda35 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5730,45 +5730,25 @@ static void rtl_hw_start_8168d(struct rtl8169_private *tp)
 	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
 }
 
-static void rtl_hw_start_8168dp(struct rtl8169_private *tp)
-{
-	void __iomem *ioaddr = tp->mmio_addr;
-	struct pci_dev *pdev = tp->pci_dev;
-
-	rtl_csi_access_enable_1(tp);
-
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
-
-	RTL_W8(MaxTxPacketSize, TxPacketMax);
-
-	rtl_disable_clock_request(pdev);
-}
-
 static void rtl_hw_start_8168d_4(struct rtl8169_private *tp)
 {
 	void __iomem *ioaddr = tp->mmio_addr;
 	struct pci_dev *pdev = tp->pci_dev;
 	static const struct ephy_info e_info_8168d_4[] = {
-		{ 0x0b, ~0,	0x48 },
-		{ 0x19, 0x20,	0x50 },
-		{ 0x0c, ~0,	0x20 }
+		{ 0x0b, 0x0000,	0x0048 },
+		{ 0x19, 0x0020,	0x0050 },
+		{ 0x0c, 0x0100,	0x0020 },
+		{ 0x10, 0x0004,	0x0000 }
 	};
-	int i;
 
 	rtl_csi_access_enable_1(tp);
 
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+	if (tp->dev->mtu <= ETH_DATA_LEN)
+		rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
 
 	RTL_W8(MaxTxPacketSize, TxPacketMax);
 
-	for (i = 0; i < ARRAY_SIZE(e_info_8168d_4); i++) {
-		const struct ephy_info *e = e_info_8168d_4 + i;
-		u16 w;
-
-		w = rtl_ephy_read(tp, e->offset);
-		rtl_ephy_write(tp, 0x03, (w & e->mask) | e->bits);
-	}
+	rtl_ephy_init(tp, e_info_8168d_4, ARRAY_SIZE(e_info_8168d_4));
 
 	rtl_enable_clock_request(pdev);
 }
@@ -6328,11 +6308,8 @@ static void rtl_hw_start_8168(struct net_device *dev)
 		break;
 
 	case RTL_GIGA_MAC_VER_28:
-		rtl_hw_start_8168d_4(tp);
-		break;
-
 	case RTL_GIGA_MAC_VER_31:
-		rtl_hw_start_8168dp(tp);
+		rtl_hw_start_8168d_4(tp);
 		break;
 
 	case RTL_GIGA_MAC_VER_32:
-- 
1.9.1

