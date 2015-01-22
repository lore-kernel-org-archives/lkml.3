Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbbAVHEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:04:02 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51206 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbbAVHDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:03:42 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M73SCP021373, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 7/9] mfd: rtsx: add support for rts524A
Date: Thu, 22 Jan 2015 15:03:14 +0800
Message-ID: <17274d43b98a3bbae8700d8b009c12f933e4e20a.1421909642.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421909642.git.micky_ching@realsil.com.cn>
References: <cover.1421909642.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

add support for new chip rts524A.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rts5249.c        | 186 ++++++++++++++++++++++++++++++++++++-------
 drivers/mfd/rtsx_pcr.c       |  25 +++++-
 drivers/mfd/rtsx_pcr.h       |   7 ++
 include/linux/mfd/rtsx_pci.h | 125 ++++++++++++++++++++++++++++-
 4 files changed, 310 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 3977946..97dde92 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -65,15 +65,17 @@ static void rts5249_fill_driving(struct rtsx_pcr *pcr, u8 voltage)
 			0xFF, driving[drive_sel][2]);
 }
 
-static void rts5249_fetch_vendor_settings(struct rtsx_pcr *pcr)
+static void rtsx_base_fetch_vendor_settings(struct rtsx_pcr *pcr)
 {
 	u32 reg;
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg);
 	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
 
-	if (!rtsx_vendor_setting_valid(reg))
+	if (!rtsx_vendor_setting_valid(reg)) {
+		pcr_dbg(pcr, "skip fetch vendor setting\n");
 		return;
+	}
 
 	pcr->aspm_en = rtsx_reg_to_aspm(reg);
 	pcr->sd30_drive_sel_1v8 = rtsx_reg_to_sd30_drive_sel_1v8(reg);
@@ -87,15 +89,21 @@ static void rts5249_fetch_vendor_settings(struct rtsx_pcr *pcr)
 		pcr->flags |= PCR_REVERSE_SOCKET;
 }
 
-static void rts5249_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
+static void rtsx_base_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	/* Set relink_time to 0 */
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 1, 0xFF, 0);
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 2, 0xFF, 0);
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
 
-	if (pm_state == HOST_ENTER_S3)
-		rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x10);
+	if (pm_state == HOST_ENTER_S3) {
+		if (PCI_PID(pcr) == 0x524A)
+			rtsx_pci_write_register(pcr, RTS524A_PM_CTRL3,
+				D3_DELINK_MODE_EN, D3_DELINK_MODE_EN);
+		else if (PCI_PID(pcr) == 0x5249)
+			rtsx_pci_write_register(pcr, PM_CTRL3,
+				D3_DELINK_MODE_EN, D3_DELINK_MODE_EN);
+	}
 
 	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
 }
@@ -104,6 +112,8 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	rtsx_pci_init_cmd(pcr);
 
+	/* Rest L1SUB Config */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, L1SUB_CONFIG3, 0xFF, 0x00);
 	/* Configure GPIO as output */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, GPIO_CTL, 0x02, 0x02);
 	/* Reset ASPM state to default value */
@@ -189,27 +199,27 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
 		PHY_TUNE_TUNED12 | PHY_TUNE_TUNEA12);
 }
 
-static int rts5249_turn_on_led(struct rtsx_pcr *pcr)
+static int rtsx_base_turn_on_led(struct rtsx_pcr *pcr)
 {
 	return rtsx_pci_write_register(pcr, GPIO_CTL, 0x02, 0x02);
 }
 
-static int rts5249_turn_off_led(struct rtsx_pcr *pcr)
+static int rtsx_base_turn_off_led(struct rtsx_pcr *pcr)
 {
 	return rtsx_pci_write_register(pcr, GPIO_CTL, 0x02, 0x00);
 }
 
-static int rts5249_enable_auto_blink(struct rtsx_pcr *pcr)
+static int rtsx_base_enable_auto_blink(struct rtsx_pcr *pcr)
 {
 	return rtsx_pci_write_register(pcr, OLT_LED_CTL, 0x08, 0x08);
 }
 
-static int rts5249_disable_auto_blink(struct rtsx_pcr *pcr)
+static int rtsx_base_disable_auto_blink(struct rtsx_pcr *pcr)
 {
 	return rtsx_pci_write_register(pcr, OLT_LED_CTL, 0x08, 0x00);
 }
 
-static int rts5249_card_power_on(struct rtsx_pcr *pcr, int card)
+static int rtsx_base_card_power_on(struct rtsx_pcr *pcr, int card)
 {
 	int err;
 
@@ -236,7 +246,7 @@ static int rts5249_card_power_on(struct rtsx_pcr *pcr, int card)
 	return 0;
 }
 
-static int rts5249_card_power_off(struct rtsx_pcr *pcr, int card)
+static int rtsx_base_card_power_off(struct rtsx_pcr *pcr, int card)
 {
 	rtsx_pci_init_cmd(pcr);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_PWR_CTL,
@@ -246,22 +256,31 @@ static int rts5249_card_power_off(struct rtsx_pcr *pcr, int card)
 	return rtsx_pci_send_cmd(pcr, 100);
 }
 
-static int rts5249_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
+static int rtsx_base_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 {
 	int err;
+	u16 append;
 
-	if (voltage == OUTPUT_3V3) {
-		err = rtsx_pci_write_phy_register(pcr, PHY_TUNE, 0x4FC0 | 0x24);
-		if (err < 0)
-			return err;
-	} else if (voltage == OUTPUT_1V8) {
-		err = rtsx_pci_write_phy_register(pcr, PHY_BACR, 0x3C02);
+	switch (voltage) {
+	case OUTPUT_3V3:
+		err = rtsx_pci_update_phy(pcr, PHY_TUNE, 0xFC3F, 0x03C0);
 		if (err < 0)
 			return err;
-		err = rtsx_pci_write_phy_register(pcr, PHY_TUNE, 0x4C40 | 0x24);
+		break;
+	case OUTPUT_1V8:
+		append = 0x0100;
+		if (PCI_PID(pcr) == 0x5249) {
+			err = rtsx_pci_update_phy(pcr, PHY_BACR, 0xFFF3, 0);
+			if (err < 0)
+				return err;
+			append = 0x0080;
+		}
+
+		err = rtsx_pci_update_phy(pcr, PHY_TUNE, 0xFC3F, append);
 		if (err < 0)
 			return err;
-	} else {
+		break;
+	default:
 		return -EINVAL;
 	}
 
@@ -272,17 +291,17 @@ static int rts5249_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 }
 
 static const struct pcr_ops rts5249_pcr_ops = {
-	.fetch_vendor_settings = rts5249_fetch_vendor_settings,
+	.fetch_vendor_settings = rtsx_base_fetch_vendor_settings,
 	.extra_init_hw = rts5249_extra_init_hw,
 	.optimize_phy = rts5249_optimize_phy,
-	.turn_on_led = rts5249_turn_on_led,
-	.turn_off_led = rts5249_turn_off_led,
-	.enable_auto_blink = rts5249_enable_auto_blink,
-	.disable_auto_blink = rts5249_disable_auto_blink,
-	.card_power_on = rts5249_card_power_on,
-	.card_power_off = rts5249_card_power_off,
-	.switch_output_voltage = rts5249_switch_output_voltage,
-	.force_power_down = rts5249_force_power_down,
+	.turn_on_led = rtsx_base_turn_on_led,
+	.turn_off_led = rtsx_base_turn_off_led,
+	.enable_auto_blink = rtsx_base_enable_auto_blink,
+	.disable_auto_blink = rtsx_base_disable_auto_blink,
+	.card_power_on = rtsx_base_card_power_on,
+	.card_power_off = rtsx_base_card_power_off,
+	.switch_output_voltage = rtsx_base_switch_output_voltage,
+	.force_power_down = rtsx_base_force_power_down,
 };
 
 /* SD Pull Control Enable:
@@ -357,3 +376,112 @@ void rts5249_init_params(struct rtsx_pcr *pcr)
 	pcr->ms_pull_ctl_enable_tbl = rts5249_ms_pull_ctl_enable_tbl;
 	pcr->ms_pull_ctl_disable_tbl = rts5249_ms_pull_ctl_disable_tbl;
 }
+
+static int rts524a_write_phy(struct rtsx_pcr *pcr, u8 addr, u16 val)
+{
+	addr = addr & 0x80 ? (addr & 0x7F) | 0x40 : addr;
+
+	return __rtsx_pci_write_phy_register(pcr, addr, val);
+}
+
+static int rts524a_read_phy(struct rtsx_pcr *pcr, u8 addr, u16 *val)
+{
+	addr = addr & 0x80 ? (addr & 0x7F) | 0x40 : addr;
+
+	return __rtsx_pci_read_phy_register(pcr, addr, val);
+}
+
+static int rts524a_optimize_phy(struct rtsx_pcr *pcr)
+{
+	int err;
+
+	err = rtsx_pci_write_register(pcr, RTS524A_PM_CTRL3,
+		D3_DELINK_MODE_EN, 0x00);
+	if (err < 0)
+		return err;
+
+	rtsx_pci_write_phy_register(pcr, PHY_PCR,
+		PHY_PCR_FORCE_CODE | PHY_PCR_OOBS_CALI_50 |
+		PHY_PCR_OOBS_VCM_08 | PHY_PCR_OOBS_SEN_90 | PHY_PCR_RSSI_EN);
+	rtsx_pci_write_phy_register(pcr, PHY_SSCCR3,
+		PHY_SSCCR3_STEP_IN | PHY_SSCCR3_CHECK_DELAY);
+
+	if (is_version(pcr, 0x524A, IC_VER_A)) {
+		rtsx_pci_write_phy_register(pcr, PHY_SSCCR3,
+			PHY_SSCCR3_STEP_IN | PHY_SSCCR3_CHECK_DELAY);
+		rtsx_pci_write_phy_register(pcr, PHY_SSCCR2,
+			PHY_SSCCR2_PLL_NCODE | PHY_SSCCR2_TIME0 |
+			PHY_SSCCR2_TIME2_WIDTH);
+		rtsx_pci_write_phy_register(pcr, PHY_ANA1A,
+			PHY_ANA1A_TXR_LOOPBACK | PHY_ANA1A_RXT_BIST |
+			PHY_ANA1A_TXR_BIST | PHY_ANA1A_REV);
+		rtsx_pci_write_phy_register(pcr, PHY_ANA1D,
+			PHY_ANA1D_DEBUG_ADDR);
+		rtsx_pci_write_phy_register(pcr, PHY_DIG1E,
+			PHY_DIG1E_REV | PHY_DIG1E_D0_X_D1 |
+			PHY_DIG1E_RX_ON_HOST | PHY_DIG1E_RCLK_REF_HOST |
+			PHY_DIG1E_RCLK_TX_EN_KEEP |
+			PHY_DIG1E_RCLK_TX_TERM_KEEP |
+			PHY_DIG1E_RCLK_RX_EIDLE_ON | PHY_DIG1E_TX_TERM_KEEP |
+			PHY_DIG1E_RX_TERM_KEEP | PHY_DIG1E_TX_EN_KEEP |
+			PHY_DIG1E_RX_EN_KEEP);
+	}
+
+	rtsx_pci_write_phy_register(pcr, PHY_ANA08,
+		PHY_ANA08_RX_EQ_DCGAIN | PHY_ANA08_SEL_RX_EN |
+		PHY_ANA08_RX_EQ_VAL | PHY_ANA08_SCP | PHY_ANA08_SEL_IPI);
+
+	return 0;
+}
+
+static int rts524a_extra_init_hw(struct rtsx_pcr *pcr)
+{
+	rts5249_extra_init_hw(pcr);
+
+	rtsx_pci_write_register(pcr, FUNC_FORCE_CTL,
+		FORCE_ASPM_L1_EN, FORCE_ASPM_L1_EN);
+	rtsx_pci_write_register(pcr, PM_EVENT_DEBUG, PME_DEBUG_0, PME_DEBUG_0);
+	rtsx_pci_write_register(pcr, LDO_VCC_CFG1, LDO_VCC_LMT_EN,
+		LDO_VCC_LMT_EN);
+	rtsx_pci_write_register(pcr, PCLK_CTL, PCLK_MODE_SEL, PCLK_MODE_SEL);
+	if (is_version(pcr, 0x524A, IC_VER_A)) {
+		rtsx_pci_write_register(pcr, LDO_DV18_CFG,
+			LDO_DV18_SR_MASK, LDO_DV18_SR_DF);
+		rtsx_pci_write_register(pcr, LDO_VCC_CFG1,
+			LDO_VCC_REF_TUNE_MASK, LDO_VCC_REF_1V2);
+		rtsx_pci_write_register(pcr, LDO_VIO_CFG,
+			LDO_VIO_REF_TUNE_MASK, LDO_VIO_REF_1V2);
+		rtsx_pci_write_register(pcr, LDO_VIO_CFG,
+			LDO_VIO_SR_MASK, LDO_VIO_SR_DF);
+		rtsx_pci_write_register(pcr, LDO_DV12S_CFG,
+			LDO_REF12_TUNE_MASK, LDO_REF12_TUNE_DF);
+		rtsx_pci_write_register(pcr, SD40_LDO_CTL1,
+			SD40_VIO_TUNE_MASK, SD40_VIO_TUNE_1V7);
+	}
+
+	return 0;
+}
+
+static const struct pcr_ops rts524a_pcr_ops = {
+	.write_phy = rts524a_write_phy,
+	.read_phy = rts524a_read_phy,
+	.fetch_vendor_settings = rtsx_base_fetch_vendor_settings,
+	.extra_init_hw = rts524a_extra_init_hw,
+	.optimize_phy = rts524a_optimize_phy,
+	.turn_on_led = rtsx_base_turn_on_led,
+	.turn_off_led = rtsx_base_turn_off_led,
+	.enable_auto_blink = rtsx_base_enable_auto_blink,
+	.disable_auto_blink = rtsx_base_disable_auto_blink,
+	.card_power_on = rtsx_base_card_power_on,
+	.card_power_off = rtsx_base_card_power_off,
+	.switch_output_voltage = rtsx_base_switch_output_voltage,
+	.force_power_down = rtsx_base_force_power_down,
+};
+
+void rts524a_init_params(struct rtsx_pcr *pcr)
+{
+	rts5249_init_params(pcr);
+
+	pcr->ops = &rts524a_pcr_ops;
+}
+
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 717bfd7..69467c6 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -58,6 +58,7 @@ static const struct pci_device_id rtsx_pci_ids[] = {
 	{ PCI_DEVICE(0x10EC, 0x5249), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5287), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5286), PCI_CLASS_OTHERS << 16, 0xFF0000 },
+	{ PCI_DEVICE(0x10EC, 0x524A), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ 0, }
 };
 
@@ -143,7 +144,7 @@ int rtsx_pci_read_register(struct rtsx_pcr *pcr, u16 addr, u8 *data)
 }
 EXPORT_SYMBOL_GPL(rtsx_pci_read_register);
 
-int rtsx_pci_write_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 val)
+int __rtsx_pci_write_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 val)
 {
 	int err, i, finished = 0;
 	u8 tmp;
@@ -175,9 +176,17 @@ int rtsx_pci_write_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 val)
 
 	return 0;
 }
+
+int rtsx_pci_write_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 val)
+{
+	if (pcr->ops->write_phy)
+		return pcr->ops->write_phy(pcr, addr, val);
+
+	return __rtsx_pci_write_phy_register(pcr, addr, val);
+}
 EXPORT_SYMBOL_GPL(rtsx_pci_write_phy_register);
 
-int rtsx_pci_read_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 *val)
+int __rtsx_pci_read_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 *val)
 {
 	int err, i, finished = 0;
 	u16 data;
@@ -223,6 +232,14 @@ int rtsx_pci_read_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 *val)
 
 	return 0;
 }
+
+int rtsx_pci_read_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 *val)
+{
+	if (pcr->ops->read_phy)
+		return pcr->ops->read_phy(pcr, addr, val);
+
+	return __rtsx_pci_read_phy_register(pcr, addr, val);
+}
 EXPORT_SYMBOL_GPL(rtsx_pci_read_phy_register);
 
 void rtsx_pci_stop_cmd(struct rtsx_pcr *pcr)
@@ -1094,6 +1111,10 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 		rts5249_init_params(pcr);
 		break;
 
+	case 0x524A:
+		rts524a_init_params(pcr);
+		break;
+
 	case 0x5287:
 		rtl8411b_init_params(pcr);
 		break;
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index fe2bbb6..e7daf6f 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -27,12 +27,19 @@
 #define MIN_DIV_N_PCR		80
 #define MAX_DIV_N_PCR		208
 
+#define RTS524A_PME_FORCE_CTL		0xFF78
+#define RTS524A_PM_CTRL3		0xFF7E
+
+int __rtsx_pci_write_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 val);
+int __rtsx_pci_read_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 *val);
+
 void rts5209_init_params(struct rtsx_pcr *pcr);
 void rts5229_init_params(struct rtsx_pcr *pcr);
 void rtl8411_init_params(struct rtsx_pcr *pcr);
 void rtl8402_init_params(struct rtsx_pcr *pcr);
 void rts5227_init_params(struct rtsx_pcr *pcr);
 void rts5249_init_params(struct rtsx_pcr *pcr);
+void rts524a_init_params(struct rtsx_pcr *pcr);
 void rtl8411b_init_params(struct rtsx_pcr *pcr);
 
 static inline u8 map_sd_drive(int idx)
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 33cc63c..a392546 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -577,8 +577,16 @@
 
 #define CDRESUMECTL			0xFE52
 #define WAKE_SEL_CTL			0xFE54
+#define PCLK_CTL			0xFE55
+#define   PCLK_MODE_SEL			0x20
 #define PME_FORCE_CTL			0xFE56
+
 #define ASPM_FORCE_CTL			0xFE57
+#define   FORCE_ASPM_CTL0		0x10
+#define   FORCE_ASPM_VAL_MASK		0x03
+#define   FORCE_ASPM_L1_EN		0x02
+#define   FORCE_ASPM_L0_EN		0x01
+#define   FORCE_ASPM_NO_ASPM		0x00
 #define PM_CLK_FORCE_CTL		0xFE58
 #define FUNC_FORCE_CTL			0xFE59
 #define PERST_GLITCH_WIDTH		0xFE5C
@@ -590,7 +598,8 @@
 #define   HOST_ENTER_S3			2
 
 #define SDIO_CFG			0xFE70
-
+#define PM_EVENT_DEBUG			0xFE71
+#define   PME_DEBUG_0			0x08
 #define NFTS_TX_CTRL			0xFE72
 
 #define PWR_GATE_CTRL			0xFE75
@@ -602,12 +611,19 @@
 #define PWD_SUSPEND_EN			0xFE76
 #define LDO_PWR_SEL			0xFE78
 
+#define L1SUB_CONFIG1			0xFE8D
+#define L1SUB_CONFIG2			0xFE8E
+#define   L1SUB_AUTO_CFG		0x02
+#define L1SUB_CONFIG3			0xFE8F
+
 #define DUMMY_REG_RESET_0		0xFE90
 
 #define AUTOLOAD_CFG_BASE		0xFF00
 #define PETXCFG				0xFF03
 
 #define PM_CTRL1			0xFF44
+#define   CD_RESUME_EN_MASK		0xF0
+
 #define PM_CTRL2			0xFF45
 #define PM_CTRL3			0xFF46
 #define   SDIO_SEND_PME_EN		0x80
@@ -628,6 +644,61 @@
 #define IMAGE_FLAG_ADDR0		0xCE80
 #define IMAGE_FLAG_ADDR1		0xCE81
 
+#define RREF_CFG			0xFF6C
+#define   RREF_VBGSEL_MASK		0x38
+#define   RREF_VBGSEL_1V25		0x28
+
+#define OOBS_CONFIG			0xFF6E
+#define   OOBS_AUTOK_DIS		0x80
+#define   OOBS_VAL_MASK			0x1F
+
+#define LDO_DV18_CFG			0xFF70
+#define   LDO_DV18_SR_MASK		0xC0
+#define   LDO_DV18_SR_DF		0x40
+
+#define LDO_CONFIG2			0xFF71
+#define   LDO_D3318_MASK		0x07
+#define   LDO_D3318_33V			0x07
+#define   LDO_D3318_18V			0x02
+
+#define LDO_VCC_CFG0			0xFF72
+#define   LDO_VCC_LMTVTH_MASK		0x30
+#define   LDO_VCC_LMTVTH_2A		0x10
+
+#define LDO_VCC_CFG1			0xFF73
+#define   LDO_VCC_REF_TUNE_MASK		0x30
+#define   LDO_VCC_REF_1V2		0x20
+#define   LDO_VCC_TUNE_MASK		0x07
+#define   LDO_VCC_1V8			0x04
+#define   LDO_VCC_3V3			0x07
+#define   LDO_VCC_LMT_EN		0x08
+
+#define LDO_VIO_CFG			0xFF75
+#define   LDO_VIO_SR_MASK		0xC0
+#define   LDO_VIO_SR_DF			0x40
+#define   LDO_VIO_REF_TUNE_MASK		0x30
+#define   LDO_VIO_REF_1V2		0x20
+#define   LDO_VIO_TUNE_MASK		0x07
+#define   LDO_VIO_1V7			0x03
+#define   LDO_VIO_1V8			0x04
+#define   LDO_VIO_3V3			0x07
+
+#define LDO_DV12S_CFG			0xFF76
+#define   LDO_REF12_TUNE_MASK		0x18
+#define   LDO_REF12_TUNE_DF		0x10
+#define   LDO_D12_TUNE_MASK		0x07
+#define   LDO_D12_TUNE_DF		0x04
+
+#define LDO_AV12S_CFG			0xFF77
+#define   LDO_AV12S_TUNE_MASK		0x07
+#define   LDO_AV12S_TUNE_DF		0x04
+
+#define SD40_LDO_CTL1			0xFE7D
+#define   SD40_VIO_TUNE_MASK		0x70
+#define   SD40_VIO_TUNE_1V7		0x30
+#define   SD_VIO_LDO_1V8		0x40
+#define   SD_VIO_LDO_3V3		0x70
+
 /* Phy register */
 #define PHY_PCR				0x00
 #define   PHY_PCR_FORCE_CODE		0xB000
@@ -641,6 +712,10 @@
 #define PHY_RCR1			0x02
 #define   PHY_RCR1_ADP_TIME_4		0x0400
 #define   PHY_RCR1_VCO_COARSE		0x001F
+#define PHY_SSCCR2			0x02
+#define   PHY_SSCCR2_PLL_NCODE		0x0A00
+#define   PHY_SSCCR2_TIME0		0x001C
+#define   PHY_SSCCR2_TIME2_WIDTH	0x0003
 
 #define PHY_RCR2			0x03
 #define   PHY_RCR2_EMPHASE_EN		0x8000
@@ -649,6 +724,9 @@
 #define   PHY_RCR2_FREQSEL_12		0x0040
 #define   PHY_RCR2_CDR_SC_12P		0x0010
 #define   PHY_RCR2_CALIB_LATE		0x0002
+#define PHY_SSCCR3			0x03
+#define   PHY_SSCCR3_STEP_IN		0x2740
+#define   PHY_SSCCR3_CHECK_DELAY	0x0008
 
 #define PHY_RTCR			0x04
 #define PHY_RDR				0x05
@@ -663,6 +741,12 @@
 #define   PHY_TUNE_TUNED18		0x01C0
 #define   PHY_TUNE_TUNED12		0X0020
 #define   PHY_TUNE_TUNEA12		0x0004
+#define PHY_ANA08			0x08
+#define   PHY_ANA08_RX_EQ_DCGAIN	0x5000
+#define   PHY_ANA08_SEL_RX_EN		0x0400
+#define   PHY_ANA08_RX_EQ_VAL		0x03C0
+#define   PHY_ANA08_SCP			0x0020
+#define   PHY_ANA08_SEL_IPI		0x0004
 
 #define PHY_IMR				0x09
 #define PHY_BPCR			0x0A
@@ -698,12 +782,19 @@
 #define   PHY_REV_STOP_CLKWR		0x0004
 
 #define PHY_FLD0			0x1A
+#define PHY_ANA1A			0x1A
+#define   PHY_ANA1A_TXR_LOOPBACK	0x2000
+#define   PHY_ANA1A_RXT_BIST		0x0500
+#define   PHY_ANA1A_TXR_BIST		0x0040
+#define   PHY_ANA1A_REV			0x0006
 #define PHY_FLD1			0x1B
 #define PHY_FLD2			0x1C
 #define PHY_FLD3			0x1D
 #define   PHY_FLD3_TIMER_4		0x0800
 #define   PHY_FLD3_TIMER_6		0x0020
 #define   PHY_FLD3_RXDELINK		0x0004
+#define PHY_ANA1D			0x1D
+#define   PHY_ANA1D_DEBUG_ADDR		0x0004
 
 #define PHY_FLD4			0x1E
 #define   PHY_FLD4_FLDEN_SEL		0x4000
@@ -713,7 +804,18 @@
 #define   PHY_FLD4_BER_COUNT		0x00E0
 #define   PHY_FLD4_BER_TIMER		0x000A
 #define   PHY_FLD4_BER_CHK_EN		0x0001
-
+#define PHY_DIG1E			0x1E
+#define   PHY_DIG1E_REV			0x4000
+#define   PHY_DIG1E_D0_X_D1		0x1000
+#define   PHY_DIG1E_RX_ON_HOST		0x0800
+#define   PHY_DIG1E_RCLK_REF_HOST	0x0400
+#define   PHY_DIG1E_RCLK_TX_EN_KEEP	0x0040
+#define   PHY_DIG1E_RCLK_TX_TERM_KEEP	0x0020
+#define   PHY_DIG1E_RCLK_RX_EIDLE_ON	0x0010
+#define   PHY_DIG1E_TX_TERM_KEEP	0x0008
+#define   PHY_DIG1E_RX_TERM_KEEP	0x0004
+#define   PHY_DIG1E_TX_EN_KEEP		0x0002
+#define   PHY_DIG1E_RX_EN_KEEP		0x0001
 #define PHY_DUM_REG			0x1F
 
 #define PCR_SETTING_REG1		0x724
@@ -729,6 +831,8 @@ struct pcr_handle {
 };
 
 struct pcr_ops {
+	int (*write_phy)(struct rtsx_pcr *pcr, u8 addr, u16 val);
+	int (*read_phy)(struct rtsx_pcr *pcr, u8 addr, u16 *val);
 	int		(*extra_init_hw)(struct rtsx_pcr *pcr);
 	int		(*optimize_phy)(struct rtsx_pcr *pcr);
 	int		(*turn_on_led)(struct rtsx_pcr *pcr);
@@ -830,6 +934,10 @@ struct rtsx_pcr {
 #define CHK_PCI_PID(pcr, pid)		((pcr)->pci->device == (pid))
 #define PCI_VID(pcr)			((pcr)->pci->vendor)
 #define PCI_PID(pcr)			((pcr)->pci->device)
+#define is_version(pcr, pid, ver)				\
+	(CHK_PCI_PID(pcr, pid) && (pcr)->ic_version == (ver))
+#define pcr_dbg(pcr, fmt, arg...)				\
+	dev_dbg(&(pcr)->pci->dev, fmt, ##arg)
 
 #define SDR104_PHASE(val)		((val) & 0xFF)
 #define SDR50_PHASE(val)		(((val) >> 8) & 0xFF)
@@ -899,4 +1007,17 @@ static inline void rtsx_pci_write_be32(struct rtsx_pcr *pcr, u16 reg, u32 val)
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, val);
 }
 
+static inline int rtsx_pci_update_phy(struct rtsx_pcr *pcr, u8 addr,
+	u16 mask, u16 append)
+{
+	int err;
+	u16 val;
+
+	err = rtsx_pci_read_phy_register(pcr, addr, &val);
+	if (err < 0)
+		return err;
+
+	return rtsx_pci_write_phy_register(pcr, addr, (val & mask) | append);
+}
+
 #endif
-- 
1.9.1

