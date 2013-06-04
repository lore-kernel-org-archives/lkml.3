Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3FDXL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:11:57 -0400
Received: from 1wt.eu ([62.212.114.60]:35480 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab3FDWm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:27 -0400
Message-Id: <20130604172134.002162423@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hayes Wang <hayeswang@realtek.com>, Thomas Bork <tom@eisfair.net>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 089/184] r8169: correct settings of rtl8102e.
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Hayes Wang <hayeswang@realtek.com>

Adjust and remove certain settings of RTL8102E which are for previous chips.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Acked-off-by: Francois Romieu <romieu@fr.zoreil.com>
(cherry picked from commit d24e9aafe5d5dfdf6d114b29e67f8afd5fae5ef0)
Cc: Thomas Bork <tom@eisfair.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/r8169.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 3ebe50c..6197140 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3076,7 +3076,7 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_mwi_3;
 	}
 
-	tp->cp_cmd = PCIMulRW | RxChkSum;
+	tp->cp_cmd = RxChkSum;
 
 	if ((sizeof(dma_addr_t) > 4) &&
 	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) && use_dac) {
@@ -3824,8 +3824,7 @@ static void rtl_hw_start_8168(struct net_device *dev)
 	Cxpl_dbg_sel | \
 	ASF | \
 	PktCntrDisable | \
-	PCIDAC | \
-	PCIMulRW)
+	Mac_dbgo_sel)
 
 static void rtl_hw_start_8102e_1(void __iomem *ioaddr, struct pci_dev *pdev)
 {
@@ -3855,8 +3854,6 @@ static void rtl_hw_start_8102e_1(void __iomem *ioaddr, struct pci_dev *pdev)
 	if ((cfg1 & LEDS0) && (cfg1 & LEDS1))
 		RTL_W8(Config1, cfg1 & ~LEDS0);
 
-	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R810X_CPCMD_QUIRK_MASK);
-
 	rtl_ephy_init(ioaddr, e_info_8102e_1, ARRAY_SIZE(e_info_8102e_1));
 }
 
@@ -3868,8 +3865,6 @@ static void rtl_hw_start_8102e_2(void __iomem *ioaddr, struct pci_dev *pdev)
 
 	RTL_W8(Config1, MEMMAP | IOMAP | VPD | PMEnable);
 	RTL_W8(Config3, RTL_R8(Config3) & ~Beacon_en);
-
-	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R810X_CPCMD_QUIRK_MASK);
 }
 
 static void rtl_hw_start_8102e_3(void __iomem *ioaddr, struct pci_dev *pdev)
@@ -3895,6 +3890,8 @@ static void rtl_hw_start_8101(struct net_device *dev)
 		}
 	}
 
+	RTL_W8(Cfg9346, Cfg9346_Unlock);
+
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_07:
 		rtl_hw_start_8102e_1(ioaddr, pdev);
@@ -3909,14 +3906,13 @@ static void rtl_hw_start_8101(struct net_device *dev)
 		break;
 	}
 
-	RTL_W8(Cfg9346, Cfg9346_Unlock);
+	RTL_W8(Cfg9346, Cfg9346_Lock);
 
 	RTL_W8(EarlyTxThres, EarlyTxThld);
 
 	rtl_set_rx_max_size(ioaddr, tp->rx_buf_sz);
 
-	tp->cp_cmd |= rtl_rw_cpluscmd(ioaddr) | PCIMulRW;
-
+	tp->cp_cmd &= ~R810X_CPCMD_QUIRK_MASK;
 	RTL_W16(CPlusCmd, tp->cp_cmd);
 
 	RTL_W16(IntrMitigate, 0x0000);
@@ -3926,14 +3922,10 @@ static void rtl_hw_start_8101(struct net_device *dev)
 	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
 	rtl_set_rx_tx_config_registers(tp);
 
-	RTL_W8(Cfg9346, Cfg9346_Lock);
-
 	RTL_R8(IntrMask);
 
 	rtl_set_rx_mode(dev);
 
-	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
-
 	RTL_W16(MultiIntr, RTL_R16(MultiIntr) & 0xf000);
 
 	RTL_W16(IntrMask, tp->intr_event);
-- 
1.7.12.2.21.g234cd45.dirty



