Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbbAVHbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:31:34 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:52336 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbbAVHbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:31:10 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M7UuMY001431, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [RESEND PATCH v2 8/9] mfd: rtsx: add support for rts525A
Date: Thu, 22 Jan 2015 15:30:40 +0800
Message-ID: <80af722c3af9b134646c6f50d8db79bb2de3e7e2.1421911636.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421911636.git.micky_ching@realsil.com.cn>
References: <cover.1421911636.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

add support for new chip rts525A.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rts5249.c        | 104 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/mfd/rtsx_pcr.c       |  13 ++++--
 drivers/mfd/rtsx_pcr.h       |   1 +
 include/linux/mfd/rtsx_pci.h |  15 +++++++
 4 files changed, 129 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 97dde92..134e03f 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -97,7 +97,7 @@ static void rtsx_base_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
 
 	if (pm_state == HOST_ENTER_S3) {
-		if (PCI_PID(pcr) == 0x524A)
+		if (PCI_PID(pcr) == 0x524A || PCI_PID(pcr) == 0x525A)
 			rtsx_pci_write_register(pcr, RTS524A_PM_CTRL3,
 				D3_DELINK_MODE_EN, D3_DELINK_MODE_EN);
 		else if (PCI_PID(pcr) == 0x5249)
@@ -485,3 +485,105 @@ void rts524a_init_params(struct rtsx_pcr *pcr)
 	pcr->ops = &rts524a_pcr_ops;
 }
 
+static int rts525a_card_power_on(struct rtsx_pcr *pcr, int card)
+{
+	rtsx_pci_write_register(pcr, LDO_VCC_CFG1,
+		LDO_VCC_TUNE_MASK, LDO_VCC_3V3);
+	return rtsx_base_card_power_on(pcr, card);
+}
+
+static int rts525a_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
+{
+	switch (voltage) {
+	case OUTPUT_3V3:
+		rtsx_pci_write_register(pcr, LDO_CONFIG2,
+			LDO_D3318_MASK, LDO_D3318_33V);
+		rtsx_pci_write_register(pcr, SD_PAD_CTL, SD_IO_USING_1V8, 0);
+		break;
+	case OUTPUT_1V8:
+		rtsx_pci_write_register(pcr, LDO_CONFIG2,
+			LDO_D3318_MASK, LDO_D3318_18V);
+		rtsx_pci_write_register(pcr, SD_PAD_CTL, SD_IO_USING_1V8,
+			SD_IO_USING_1V8);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	rtsx_pci_init_cmd(pcr);
+	rts5249_fill_driving(pcr, voltage);
+	return rtsx_pci_send_cmd(pcr, 100);
+}
+
+static int rts525a_optimize_phy(struct rtsx_pcr *pcr)
+{
+	int err;
+
+	err = rtsx_pci_write_register(pcr, RTS524A_PM_CTRL3,
+		D3_DELINK_MODE_EN, 0x00);
+	if (err < 0)
+		return err;
+
+	rtsx_pci_write_phy_register(pcr, _PHY_FLD0,
+		_PHY_FLD0_CLK_REQ_20C | _PHY_FLD0_RX_IDLE_EN |
+		_PHY_FLD0_BIT_ERR_RSTN | _PHY_FLD0_BER_COUNT |
+		_PHY_FLD0_BER_TIMER | _PHY_FLD0_CHECK_EN);
+
+	rtsx_pci_write_phy_register(pcr, _PHY_ANA03,
+		_PHY_ANA03_TIMER_MAX | _PHY_ANA03_OOBS_DEB_EN |
+		_PHY_CMU_DEBUG_EN);
+
+	if (is_version(pcr, 0x525A, IC_VER_A))
+		rtsx_pci_write_phy_register(pcr, _PHY_REV0,
+			_PHY_REV0_FILTER_OUT | _PHY_REV0_CDR_BYPASS_PFD |
+			_PHY_REV0_CDR_RX_IDLE_BYPASS);
+
+	return 0;
+}
+
+static int rts525a_extra_init_hw(struct rtsx_pcr *pcr)
+{
+	rts5249_extra_init_hw(pcr);
+
+	rtsx_pci_write_register(pcr, PCLK_CTL, PCLK_MODE_SEL, PCLK_MODE_SEL);
+	if (is_version(pcr, 0x525A, IC_VER_A)) {
+		rtsx_pci_write_register(pcr, L1SUB_CONFIG2,
+			L1SUB_AUTO_CFG, L1SUB_AUTO_CFG);
+		rtsx_pci_write_register(pcr, RREF_CFG,
+			RREF_VBGSEL_MASK, RREF_VBGSEL_1V25);
+		rtsx_pci_write_register(pcr, LDO_VIO_CFG,
+			LDO_VIO_TUNE_MASK, LDO_VIO_1V7);
+		rtsx_pci_write_register(pcr, LDO_DV12S_CFG,
+			LDO_D12_TUNE_MASK, LDO_D12_TUNE_DF);
+		rtsx_pci_write_register(pcr, LDO_AV12S_CFG,
+			LDO_AV12S_TUNE_MASK, LDO_AV12S_TUNE_DF);
+		rtsx_pci_write_register(pcr, LDO_VCC_CFG0,
+			LDO_VCC_LMTVTH_MASK, LDO_VCC_LMTVTH_2A);
+		rtsx_pci_write_register(pcr, OOBS_CONFIG,
+			OOBS_AUTOK_DIS | OOBS_VAL_MASK, 0x89);
+	}
+
+	return 0;
+}
+
+static const struct pcr_ops rts525a_pcr_ops = {
+	.fetch_vendor_settings = rtsx_base_fetch_vendor_settings,
+	.extra_init_hw = rts525a_extra_init_hw,
+	.optimize_phy = rts525a_optimize_phy,
+	.turn_on_led = rtsx_base_turn_on_led,
+	.turn_off_led = rtsx_base_turn_off_led,
+	.enable_auto_blink = rtsx_base_enable_auto_blink,
+	.disable_auto_blink = rtsx_base_disable_auto_blink,
+	.card_power_on = rts525a_card_power_on,
+	.card_power_off = rtsx_base_card_power_off,
+	.switch_output_voltage = rts525a_switch_output_voltage,
+	.force_power_down = rtsx_base_force_power_down,
+};
+
+void rts525a_init_params(struct rtsx_pcr *pcr)
+{
+	rts5249_init_params(pcr);
+
+	pcr->ops = &rts525a_pcr_ops;
+}
+
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index e6d97ad..4c47f94 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -59,6 +59,7 @@ static const struct pci_device_id rtsx_pci_ids[] = {
 	{ PCI_DEVICE(0x10EC, 0x5287), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5286), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x524A), PCI_CLASS_OTHERS << 16, 0xFF0000 },
+	{ PCI_DEVICE(0x10EC, 0x525A), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ 0, }
 };
 
@@ -1114,6 +1115,10 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 		rts524a_init_params(pcr);
 		break;
 
+	case 0x525A:
+		rts525a_init_params(pcr);
+		break;
+
 	case 0x5287:
 		rtl8411b_init_params(pcr);
 		break;
@@ -1159,7 +1164,7 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	struct rtsx_pcr *pcr;
 	struct pcr_handle *handle;
 	u32 base, len;
-	int ret, i;
+	int ret, i, bar = 0;
 
 	dev_dbg(&(pcidev->dev),
 		": Realtek PCI-E Card Reader found at %s [%04x:%04x] (rev %x)\n",
@@ -1204,8 +1209,10 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	pcr->pci = pcidev;
 	dev_set_drvdata(&pcidev->dev, handle);
 
-	len = pci_resource_len(pcidev, 0);
-	base = pci_resource_start(pcidev, 0);
+	if (PCI_PID(pcr) == 0x525A)
+		bar = 1;
+	len = pci_resource_len(pcidev, bar);
+	base = pci_resource_start(pcidev, bar);
 	pcr->remap_addr = ioremap_nocache(base, len);
 	if (!pcr->remap_addr) {
 		ret = -ENOMEM;
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index e7daf6f..ce48842 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -40,6 +40,7 @@ void rtl8402_init_params(struct rtsx_pcr *pcr);
 void rts5227_init_params(struct rtsx_pcr *pcr);
 void rts5249_init_params(struct rtsx_pcr *pcr);
 void rts524a_init_params(struct rtsx_pcr *pcr);
+void rts525a_init_params(struct rtsx_pcr *pcr);
 void rtl8411b_init_params(struct rtsx_pcr *pcr);
 
 static inline u8 map_sd_drive(int idx)
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index a392546..c4fb791 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -727,6 +727,10 @@
 #define PHY_SSCCR3			0x03
 #define   PHY_SSCCR3_STEP_IN		0x2740
 #define   PHY_SSCCR3_CHECK_DELAY	0x0008
+#define _PHY_ANA03			0x03
+#define   _PHY_ANA03_TIMER_MAX		0x2700
+#define   _PHY_ANA03_OOBS_DEB_EN	0x0040
+#define   _PHY_CMU_DEBUG_EN		0x0008
 
 #define PHY_RTCR			0x04
 #define PHY_RDR				0x05
@@ -780,6 +784,10 @@
 #define   PHY_REV_STOP_CLKRD		0x0020
 #define   PHY_REV_RX_PWST		0x0008
 #define   PHY_REV_STOP_CLKWR		0x0004
+#define _PHY_REV0			0x19
+#define   _PHY_REV0_FILTER_OUT		0x3800
+#define   _PHY_REV0_CDR_BYPASS_PFD	0x0100
+#define   _PHY_REV0_CDR_RX_IDLE_BYPASS	0x0002
 
 #define PHY_FLD0			0x1A
 #define PHY_ANA1A			0x1A
@@ -795,6 +803,13 @@
 #define   PHY_FLD3_RXDELINK		0x0004
 #define PHY_ANA1D			0x1D
 #define   PHY_ANA1D_DEBUG_ADDR		0x0004
+#define _PHY_FLD0			0x1D
+#define   _PHY_FLD0_CLK_REQ_20C		0x8000
+#define   _PHY_FLD0_RX_IDLE_EN		0x1000
+#define   _PHY_FLD0_BIT_ERR_RSTN	0x0800
+#define   _PHY_FLD0_BER_COUNT		0x01E0
+#define   _PHY_FLD0_BER_TIMER		0x001E
+#define   _PHY_FLD0_CHECK_EN		0x0001
 
 #define PHY_FLD4			0x1E
 #define   PHY_FLD4_FLDEN_SEL		0x4000
-- 
1.9.1

