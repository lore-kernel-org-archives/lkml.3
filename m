Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162532Ab3LFNWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:22:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161888Ab3LFNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei WANG <wei_wang@realsil.com.cn>, Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 210/272] mfd: rtsx: Modify rts5249_optimize_phy
Date: Fri,  6 Dec 2013 12:58:19 +0000
Message-Id: <1386334761-25517-211-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei WANG <wei_wang@realsil.com.cn>

commit 26b818511c6562ce372566c219a2ef1afea35fe6 upstream.

In some platforms, specially Thinkpad series, rts5249 won't be
initialized properly. So we need adjust some phy parameters to
improve the compatibility issue.

It is a little different between simulation and real chip. We have
no idea about which configuration is better before tape-out. We set
default settings according to simulation, but need to tune these
parameters after getting the real chip.

I can't explain every change in detail here. The below information is
just a rough description:

PHY_REG_REV: Disable internal clkreq_tx, enable rx_pwst
PHY_BPCR: No change, just turn the magic number to macro definitions
PHY_PCR: Change OOBS sensitivity, from 60mV to 90mV
PHY_RCR2: Control charge-pump current automatically
PHY_FLD4: Use TX cmu reference clock
PHY_RDR: Change RXDSEL from 30nF to 1.9nF
PHY_RCR1: Change the duration between adp_st and asserting cp_en from
0.32 us to 0.64us
PHY_FLD3: Adjust internal timers
PHY_TUNE: Fine tune the regulator12 output voltage

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Cc: wei_wang@realsil.com.cn
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/rts5249.c        | 48 +++++++++++++++++++++++++++++++++++++--
 include/linux/mfd/rtsx_pci.h | 53 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 15dc848..80143e7 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -60,13 +60,57 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
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
index 7a9f708..59063d6 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -726,6 +726,59 @@
 #define PHY_FLD4			0x1E
 #define PHY_DUM_REG			0x1F
 
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
1.8.3.2

