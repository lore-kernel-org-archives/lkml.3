Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab3IJJN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:13:29 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53484 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3IJJN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:13:28 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r8A9DIDQ027812, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <micky_ching@realsil.com.cn>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v3] mfd: rtsx: Modify rts5249_optimize_phy
Date: Tue, 10 Sep 2013 17:13:17 +0800
Message-ID: <1378804397-28640-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

In some platforms, specially Thinkpad series, rts5249 won't be
initialized properly. So we need adjust some phy parameters to
improve the compatibility issue.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rts5249.c        |   48 ++++++++++++++++++++++++++++++++++++--
 include/linux/mfd/rtsx_pci.h |   53 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 3b835f5..573de7b 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -130,13 +130,57 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
 {
 	int err;
 
-	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, 0xFE46);
+	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV,
+			PHY_REG_REV_RESV | PHY_REG_REV_RXIDLE_LATCHED |
+			PHY_REG_REV_P1_EN | PHY_REG_REV_RXIDLE_EN |
+			PHY_REG_REV_RX_PWST | PHY_REG_REV_CLKREQ_DLY_TIMER_1_0 |
+			PHY_REG_REV_STOP_CLKRD | PHY_REG_REV_STOP_CLKWR);
 	if (err < 0)
 		return err;
 
 	msleep(1);
 
-	return rtsx_pci_write_phy_register(pcr, PHY_BPCR, 0x05C0);
+	err = rtsx_pci_write_phy_register(pcr, PHY_BPCR,
+			PHY_BPCR_IBRXSEL | PHY_BPCR_IBTXSEL |
+			PHY_BPCR_IB_FILTER | PHY_BPCR_CMIRROR_EN);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_PCR,
+			PHY_PCR_FORCE_CODE | PHY_PCR_OOBS_CALI_50 |
+			PHY_PCR_OOBS_VCM_08 | PHY_PCR_OOBS_SEN_90 |
+			PHY_PCR_RSSI_EN);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_RCR2,
+			PHY_RCR2_EMPHASE_EN | PHY_RCR2_NADJR |
+			PHY_RCR2_CDR_CP_10 | PHY_RCR2_CDR_SR_2 |
+			PHY_RCR2_FREQSEL_12 | PHY_RCR2_CPADJEN |
+			PHY_RCR2_CDR_SC_8 | PHY_RCR2_CALIB_LATE);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_FLD4,
+			PHY_FLD4_FLDEN_SEL | PHY_FLD4_REQ_REF |
+			PHY_FLD4_RXAMP_OFF | PHY_FLD4_REQ_ADDA |
+			PHY_FLD4_BER_COUNT | PHY_FLD4_BER_TIMER |
+			PHY_FLD4_BER_CHK_EN);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_RDR, PHY_RDR_RXDSEL_1_9);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_RCR1,
+			PHY_RCR1_ADP_TIME | PHY_RCR1_VCO_COARSE);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_FLD3,
+			PHY_FLD3_TIMER_4 | PHY_FLD3_TIMER_6 |
+			PHY_FLD3_RXDELINK);
+	if (err < 0)
+		return err;
+	return rtsx_pci_write_phy_register(pcr, PHY_TUNE,
+			PHY_TUNE_TUNEREF_1_0 | PHY_TUNE_VBGSEL_1252 |
+			PHY_TUNE_SDBUS_33 | PHY_TUNE_TUNED18 |
+			PHY_TUNE_TUNED12);
 }
 
 static int rts5249_turn_on_led(struct rtsx_pcr *pcr)
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index d1382df..0ce7721 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -756,6 +756,59 @@
 #define PCR_SETTING_REG2		0x814
 #define PCR_SETTING_REG3		0x747
 
+/* Phy bits */
+#define PHY_PCR_FORCE_CODE			0xB000
+#define PHY_PCR_OOBS_CALI_50			0x0800
+#define PHY_PCR_OOBS_VCM_08			0x0200
+#define PHY_PCR_OOBS_SEN_90			0x0040
+#define PHY_PCR_RSSI_EN				0x0002
+
+#define PHY_RCR1_ADP_TIME			0x0100
+#define PHY_RCR1_VCO_COARSE			0x001F
+
+#define PHY_RCR2_EMPHASE_EN			0x8000
+#define PHY_RCR2_NADJR				0x4000
+#define PHY_RCR2_CDR_CP_10			0x0400
+#define PHY_RCR2_CDR_SR_2			0x0100
+#define PHY_RCR2_FREQSEL_12			0x0040
+#define PHY_RCR2_CPADJEN			0x0020
+#define PHY_RCR2_CDR_SC_8			0x0008
+#define PHY_RCR2_CALIB_LATE			0x0002
+
+#define PHY_RDR_RXDSEL_1_9			0x4000
+
+#define PHY_TUNE_TUNEREF_1_0			0x4000
+#define PHY_TUNE_VBGSEL_1252			0x0C00
+#define PHY_TUNE_SDBUS_33			0x0200
+#define PHY_TUNE_TUNED18			0x01C0
+#define PHY_TUNE_TUNED12			0X0020
+
+#define PHY_BPCR_IBRXSEL			0x0400
+#define PHY_BPCR_IBTXSEL			0x0100
+#define PHY_BPCR_IB_FILTER			0x0080
+#define PHY_BPCR_CMIRROR_EN			0x0040
+
+#define PHY_REG_REV_RESV			0xE000
+#define PHY_REG_REV_RXIDLE_LATCHED		0x1000
+#define PHY_REG_REV_P1_EN			0x0800
+#define PHY_REG_REV_RXIDLE_EN			0x0400
+#define PHY_REG_REV_CLKREQ_DLY_TIMER_1_0	0x0040
+#define PHY_REG_REV_STOP_CLKRD			0x0020
+#define PHY_REG_REV_RX_PWST			0x0008
+#define PHY_REG_REV_STOP_CLKWR			0x0004
+
+#define PHY_FLD3_TIMER_4			0x7800
+#define PHY_FLD3_TIMER_6			0x00E0
+#define PHY_FLD3_RXDELINK			0x0004
+
+#define PHY_FLD4_FLDEN_SEL			0x4000
+#define PHY_FLD4_REQ_REF			0x2000
+#define PHY_FLD4_RXAMP_OFF			0x1000
+#define PHY_FLD4_REQ_ADDA			0x0800
+#define PHY_FLD4_BER_COUNT			0x00E0
+#define PHY_FLD4_BER_TIMER			0x000A
+#define PHY_FLD4_BER_CHK_EN			0x0001
+
 #define rtsx_pci_init_cmd(pcr)		((pcr)->ci = 0)
 
 struct rtsx_pcr;
-- 
1.7.9.5

