Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab3IFDoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 23:44:14 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:38329 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3IFDoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 23:44:13 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r863edPq002084, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <micky_ching@realsil.com.cn>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v2] mfd: rtsx: Modify rts5249_optimize_phy
Date: Fri, 6 Sep 2013 11:40:39 +0800
Message-ID: <e858b38c5b87dd761c764c6214f49cf9a9b5ad1d.1378437776.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1378437776.git.wei_wang@realsil.com.cn>
References: <cover.1378437776.git.wei_wang@realsil.com.cn>
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
 drivers/mfd/rts5249.c        |   35 ++++++++++++++++++++++++++++++++--
 include/linux/mfd/rtsx_pci.h |   43 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 3b835f5..7653638 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -130,13 +130,44 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
 {
 	int err;
 
-	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, 0xFE46);
+	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, REG_REV_RESV |
+			RXIDLE_LATCHED | P1_EN | RXIDLE_EN | RX_PWST |
+			CLKREQ_DLY_TIMER_1_0 | STOP_CLKRD | STOP_CLKWR);
 	if (err < 0)
 		return err;
 
 	msleep(1);
 
-	return rtsx_pci_write_phy_register(pcr, PHY_BPCR, 0x05C0);
+	err = rtsx_pci_write_phy_register(pcr, PHY_BPCR, IBRXSEL | IBTXSEL |
+			IB_FILTER | CMIRROR_EN);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_PCR, FORCE_CODE |
+			OOBS_CALI_50 | OOBS_VCM_08 | OOBS_SEN_90 | RSSI_EN);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_RCR2, EMPHASE_EN | NADJR |
+			CDR_CP_10 | CDR_SR_2 | FREQSEL_12 | CPADJEN |
+			CDR_SC_8 | CALIB_LATE);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_FLD4, FLDEN_SEL | REQ_REF |
+			RXAMP_OFF | REQ_ADDA | BER_COUNT |
+			BER_TIMER | BER_CHK_EN);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_RDR, RXDSEL_1_9);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_RCR1, ADP_TIME | VCO_COARSE);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_FLD3, TIMER_4 | TIMER_6 |
+			RXDELINK);
+	if (err < 0)
+		return err;
+	return rtsx_pci_write_phy_register(pcr, PHY_TUNE, TUNEREF_1_0 |
+			VBGSEL_1252 | SDBUS_33 | TUNED18 | TUNED12);
 }
 
 static int rts5249_turn_on_led(struct rtsx_pcr *pcr)
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index d1382df..de20538 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -719,16 +719,41 @@
 
 /* Phy register */
 #define PHY_PCR				0x00
+#define  FORCE_CODE			0xB000
+#define  OOBS_CALI_50			0x0800
+#define  OOBS_VCM_08			0x0200
+#define  OOBS_SEN_90			0x0040
+#define  RSSI_EN			0x0002
 #define PHY_RCR0			0x01
 #define PHY_RCR1			0x02
+#define  ADP_TIME			0x0100
+#define  VCO_COARSE			0x001F
 #define PHY_RCR2			0x03
+#define  EMPHASE_EN			0x8000
+#define  NADJR				0x4000
+#define  CDR_CP_10			0x0400
+#define  CDR_SR_2			0x0100
+#define  FREQSEL_12			0x0040
+#define  CPADJEN			0x0020
+#define  CDR_SC_8			0x0008
+#define  CALIB_LATE			0x0002
 #define PHY_RTCR			0x04
 #define PHY_RDR				0x05
+#define  RXDSEL_1_9			0x4000
 #define PHY_TCR0			0x06
 #define PHY_TCR1			0x07
 #define PHY_TUNE			0x08
+#define  TUNEREF_1_0			0x4000
+#define  VBGSEL_1252			0x0C00
+#define  SDBUS_33			0x0200
+#define  TUNED18			0x01C0
+#define  TUNED12			0X0020
 #define PHY_IMR				0x09
 #define PHY_BPCR			0x0A
+#define  IBRXSEL			0x0400
+#define  IBTXSEL			0x0100
+#define  IB_FILTER			0x0080
+#define  CMIRROR_EN			0x0040
 #define PHY_BIST			0x0B
 #define PHY_RAW_L			0x0C
 #define PHY_RAW_H			0x0D
@@ -744,11 +769,29 @@
 #define PHY_BRNR2			0x17
 #define PHY_BENR			0x18
 #define PHY_REG_REV			0x19
+#define  REG_REV_RESV			0xE000
+#define  RXIDLE_LATCHED			0x1000
+#define  P1_EN				0x0800
+#define  RXIDLE_EN			0x0400
+#define  CLKREQ_DLY_TIMER_1_0		0x0040
+#define  STOP_CLKRD			0x0020
+#define  RX_PWST			0x0008
+#define  STOP_CLKWR			0x0004
 #define PHY_FLD0			0x1A
 #define PHY_FLD1			0x1B
 #define PHY_FLD2			0x1C
 #define PHY_FLD3			0x1D
+#define  TIMER_4			0x7800
+#define  TIMER_6			0x00E0
+#define  RXDELINK			0x0004
 #define PHY_FLD4			0x1E
+#define  FLDEN_SEL			0x4000
+#define  REQ_REF			0x2000
+#define  RXAMP_OFF			0x1000
+#define  REQ_ADDA			0x0800
+#define  BER_COUNT			0x00E0
+#define  BER_TIMER			0x000A
+#define  BER_CHK_EN			0x0001
 #define PHY_DUM_REG			0x1F
 
 #define LCTLR				0x80
-- 
1.7.9.5

