Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbbASJEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:04:12 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33404 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbbASJEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:04:07 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J944sX024186, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 2/2] r8152: remove sram_read
Date: Mon, 19 Jan 2015 17:02:46 +0800
Message-ID: <1394712342-15778-128-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-126-Taiwan-albertk@realtek.com>
References: <1394712342-15778-126-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.122]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read OCP register 0xa43a~0xa43b would clear some flags which the hw
would use, and it may let the device lost. However, the unit of
reading is 4 bytes. That is, it would read 0xa438~0xa43b when calling
sram_read() to read OCP_SRAM_DATA.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0aa83fb..bf405f1 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -920,12 +920,6 @@ static void sram_write(struct r8152 *tp, u16 addr, u16 data)
 	ocp_reg_write(tp, OCP_SRAM_DATA, data);
 }
 
-static u16 sram_read(struct r8152 *tp, u16 addr)
-{
-	ocp_reg_write(tp, OCP_SRAM_ADDR, addr);
-	return ocp_reg_read(tp, OCP_SRAM_DATA);
-}
-
 static int read_mii_word(struct net_device *netdev, int phy_id, int reg)
 {
 	struct r8152 *tp = netdev_priv(netdev);
@@ -2512,24 +2506,18 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
 	data = ocp_reg_read(tp, OCP_POWER_CFG);
 	data |= EN_10M_PLLOFF;
 	ocp_reg_write(tp, OCP_POWER_CFG, data);
-	data = sram_read(tp, SRAM_IMPEDANCE);
-	data &= ~RX_DRIVING_MASK;
-	sram_write(tp, SRAM_IMPEDANCE, data);
+	sram_write(tp, SRAM_IMPEDANCE, 0x0b13);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
 	ocp_data |= PFM_PWM_SWITCH;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
 
-	data = sram_read(tp, SRAM_LPF_CFG);
-	data |= LPF_AUTO_TUNE;
-	sram_write(tp, SRAM_LPF_CFG, data);
+	/* Enable LPF corner auto tune */
+	sram_write(tp, SRAM_LPF_CFG, 0xf70f);
 
-	data = sram_read(tp, SRAM_10M_AMP1);
-	data |= GDAC_IB_UPALL;
-	sram_write(tp, SRAM_10M_AMP1, data);
-	data = sram_read(tp, SRAM_10M_AMP2);
-	data |= AMP_DN;
-	sram_write(tp, SRAM_10M_AMP2, data);
+	/* Adjust 10M Amplitude */
+	sram_write(tp, SRAM_10M_AMP1, 0x00af);
+	sram_write(tp, SRAM_10M_AMP2, 0x0208);
 
 	set_bit(PHY_RESET, &tp->flags);
 }
-- 
2.1.0

