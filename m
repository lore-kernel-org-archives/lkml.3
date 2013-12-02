Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3LBTh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:37:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab3LBTSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei WANG <wei_wang@realsil.com.cn>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH 3.12 172/212] mfd: rtsx: Modify rts5249_optimize_phy
Date: Mon,  2 Dec 2013 11:16:03 -0800
Message-Id: <20131202191307.368619315@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/rts5249.c        |   48 +++++++++++++++++++++++++++++++++++++-
 include/linux/mfd/rtsx_pci.h |   53 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 2 deletions(-)

--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -130,13 +130,57 @@ static int rts5249_optimize_phy(struct r
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


