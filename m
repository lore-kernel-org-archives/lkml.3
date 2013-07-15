Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3GOHIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:08:18 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:49471 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3GOHIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:08:04 -0400
X-Greylist: delayed 671 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2013 03:07:51 EDT
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6F6uIhk017577, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <adam.lee@canonical.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 1/5] mfd:rtsx: Read vendor setting from config space
Date: Mon, 15 Jul 2013 14:56:10 +0800
Message-ID: <d0a47d6128605ecd9888657ce36b81ad51116876.1373871136.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1373871135.git.wei_wang@realsil.com.cn>
References: <cover.1373871135.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Normally OEMs will set vendor setting to the config space of Realtek
card reader in BIOS stage. This patch reads the setting at the first,
and configure the internal registers according to it, to improve card
reader's compatibility condition.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtl8411.c           |   77 +++++++++++++++++++++++++++----
 drivers/mfd/rts5209.c           |   45 ++++++++++++------
 drivers/mfd/rts5227.c           |   96 +++++++++++++++++++++++++++++----------
 drivers/mfd/rts5229.c           |   39 ++++++++++++++--
 drivers/mfd/rts5249.c           |   91 ++++++++++++++++++++++++++++---------
 drivers/mfd/rtsx_pcr.c          |   29 ++++++++++--
 drivers/mfd/rtsx_pcr.h          |   15 +++++-
 include/linux/mfd/rtsx_common.h |    3 +-
 include/linux/mfd/rtsx_pci.h    |   21 +++++++--
 9 files changed, 331 insertions(+), 85 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index c436bf2..df60ae0 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,7 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
+ *   Roger Tseng <rogerable@realtek.com>
  */
 
 #include <linux/module.h>
@@ -47,19 +47,66 @@ static int rtl8411b_is_qfn48(struct rtsx_pcr *pcr)
 		return 0;
 }
 
+static void rtl8411_init_settings(struct rtsx_pcr *pcr)
+{
+	u32 val1;
+	u8 val2;
+
+	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &val1);
+	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, val1);
+
+	if (!(val1 & 0x1000000)) {
+		pcr->aspm_val = (u8)((val1 >> 28) & 0x03);
+		pcr->sd30_drive_sel_1v8 = map_sd_drive((val1 >> 26) & 0x03);
+		pcr->card_drive_sel &= 0x3F;
+		pcr->card_drive_sel |= (u8)((val1 >> 25) & 0x01) << 6;
+
+		rtsx_pci_read_config_byte(pcr, PCR_SETTING_REG3, &val2);
+		dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n",
+				PCR_SETTING_REG3, val2);
+		pcr->sd30_drive_sel_3v3 = (val2 >> 5) & 0x07;
+	}
+}
+
+static void rtl8411b_init_settings(struct rtsx_pcr *pcr)
+{
+	u32 val;
+
+	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &val);
+	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, val);
+
+	if (!(val & 0x1000000)) {
+		pcr->aspm_val = (u8)((val >> 28) & 0x03);
+		pcr->sd30_drive_sel_1v8 = map_sd_drive((val >> 26) & 0x03);
+		pcr->sd30_drive_sel_3v3 = map_sd_drive(val & 0x03);
+	}
+}
+
 static int rtl8411_extra_init_hw(struct rtsx_pcr *pcr)
 {
-	return rtsx_pci_write_register(pcr, CD_PAD_CTL,
+	rtsx_pci_init_cmd(pcr);
+
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DRIVE_SEL,
+			0xFF, pcr->sd30_drive_sel_3v3);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CD_PAD_CTL,
 			CD_DISABLE_MASK | CD_AUTO_DISABLE, CD_ENABLE);
+
+	return rtsx_pci_send_cmd(pcr, 100);
 }
 
 static int rtl8411b_extra_init_hw(struct rtsx_pcr *pcr)
 {
-	if (rtl8411b_is_qfn48(pcr))
-		rtsx_pci_write_register(pcr, CARD_PULL_CTL3, 0xFF, 0xF5);
+	rtsx_pci_init_cmd(pcr);
 
-	return rtsx_pci_write_register(pcr, CD_PAD_CTL,
+	if (rtl8411b_is_qfn48(pcr))
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+				CARD_PULL_CTL3, 0xFF, 0xF5);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DRIVE_SEL,
+			0xFF, pcr->sd30_drive_sel_3v3);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CD_PAD_CTL,
 			CD_DISABLE_MASK | CD_AUTO_DISABLE, CD_ENABLE);
+
+	return rtsx_pci_send_cmd(pcr, 100);
 }
 
 static int rtl8411_turn_on_led(struct rtsx_pcr *pcr)
@@ -141,13 +188,13 @@ static int rtl8411_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 	mask = (BPP_REG_TUNED18 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_MASK;
 	if (voltage == OUTPUT_3V3) {
 		err = rtsx_pci_write_register(pcr,
-				SD30_DRIVE_SEL, 0x07, DRIVER_TYPE_D);
+				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_3v3);
 		if (err < 0)
 			return err;
 		val = (BPP_ASIC_3V3 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_3V3;
 	} else if (voltage == OUTPUT_1V8) {
 		err = rtsx_pci_write_register(pcr,
-				SD30_DRIVE_SEL, 0x07, DRIVER_TYPE_B);
+				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_1v8);
 		if (err < 0)
 			return err;
 		val = (BPP_ASIC_1V8 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_1V8;
@@ -222,6 +269,7 @@ static int rtl8411_conv_clk_and_div_n(int input, int dir)
 }
 
 static const struct pcr_ops rtl8411_pcr_ops = {
+	.init_settings = rtl8411_init_settings,
 	.extra_init_hw = rtl8411_extra_init_hw,
 	.optimize_phy = NULL,
 	.turn_on_led = rtl8411_turn_on_led,
@@ -236,6 +284,7 @@ static const struct pcr_ops rtl8411_pcr_ops = {
 };
 
 static const struct pcr_ops rtl8411b_pcr_ops = {
+	.init_settings = rtl8411b_init_settings,
 	.extra_init_hw = rtl8411b_extra_init_hw,
 	.optimize_phy = NULL,
 	.turn_on_led = rtl8411_turn_on_led,
@@ -385,6 +434,12 @@ void rtl8411_init_params(struct rtsx_pcr *pcr)
 	pcr->num_slots = 2;
 	pcr->ops = &rtl8411_pcr_ops;
 
+	pcr->flags = 0;
+	pcr->card_drive_sel = 0x55;
+	pcr->sd30_drive_sel_1v8 = 0x03;
+	pcr->sd30_drive_sel_3v3 = 0x01;
+	pcr->aspm_val = 0x02;
+
 	pcr->ic_version = rtl8411_get_ic_version(pcr);
 	pcr->sd_pull_ctl_enable_tbl = rtl8411_sd_pull_ctl_enable_tbl;
 	pcr->sd_pull_ctl_disable_tbl = rtl8411_sd_pull_ctl_disable_tbl;
@@ -398,6 +453,12 @@ void rtl8411b_init_params(struct rtsx_pcr *pcr)
 	pcr->num_slots = 2;
 	pcr->ops = &rtl8411b_pcr_ops;
 
+	pcr->flags = 0;
+	pcr->card_drive_sel = 0x55;
+	pcr->sd30_drive_sel_1v8 = 0x03;
+	pcr->sd30_drive_sel_3v3 = 0x01;
+	pcr->aspm_val = 0x02;
+
 	pcr->ic_version = rtl8411_get_ic_version(pcr);
 
 	if (rtl8411b_is_qfn48(pcr)) {
diff --git a/drivers/mfd/rts5209.c b/drivers/mfd/rts5209.c
index ec78d9f..1afcfd8 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #include <linux/module.h>
@@ -34,18 +33,26 @@ static u8 rts5209_get_ic_version(struct rtsx_pcr *pcr)
 	return val & 0x0F;
 }
 
-static void rts5209_init_vendor_cfg(struct rtsx_pcr *pcr)
+static void rts5209_init_settings(struct rtsx_pcr *pcr)
 {
 	u32 val;
 
-	rtsx_pci_read_config_dword(pcr, 0x724, &val);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x724: 0x%x\n", val);
+	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &val);
+	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, val);
 
 	if (!(val & 0x80)) {
-		if (val & 0x08)
-			pcr->ms_pmos = false;
-		else
-			pcr->ms_pmos = true;
+		if (!(val & 0x08))
+			pcr->flags |= PCR_MS_PMOS;
+		pcr->aspm_val = (u8)((val >> 5) & 0x03);
+	}
+
+	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG2, &val);
+	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG2, val);
+
+	if (val & 0x80) {
+		pcr->sd30_drive_sel_1v8 = (u8)((val >> 3) & 0x07);
+		pcr->sd30_drive_sel_3v3 = (u8)(val & 0x07);
+		pcr->card_drive_sel = (u8)(val >> 8);
 	}
 }
 
@@ -57,6 +64,9 @@ static int rts5209_extra_init_hw(struct rtsx_pcr *pcr)
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_GPIO, 0xFF, 0x03);
 	/* Configure GPIO as output */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_GPIO_DIR, 0xFF, 0x03);
+	/* Configure driving */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DRIVE_SEL,
+			0xFF, pcr->sd30_drive_sel_3v3);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
@@ -95,7 +105,7 @@ static int rts5209_card_power_on(struct rtsx_pcr *pcr, int card)
 	partial_pwr_on = SD_PARTIAL_POWER_ON;
 	pwr_on = SD_POWER_ON;
 
-	if (pcr->ms_pmos && (card == RTSX_MS_CARD)) {
+	if ((pcr->flags & PCR_MS_PMOS) && (card == RTSX_MS_CARD)) {
 		pwr_mask = MS_POWER_MASK;
 		partial_pwr_on = MS_PARTIAL_POWER_ON;
 		pwr_on = MS_POWER_ON;
@@ -131,7 +141,7 @@ static int rts5209_card_power_off(struct rtsx_pcr *pcr, int card)
 	pwr_mask = SD_POWER_MASK;
 	pwr_off = SD_POWER_OFF;
 
-	if (pcr->ms_pmos && (card == RTSX_MS_CARD)) {
+	if ((pcr->flags & PCR_MS_PMOS) && (card == RTSX_MS_CARD)) {
 		pwr_mask = MS_POWER_MASK;
 		pwr_off = MS_POWER_OFF;
 	}
@@ -140,7 +150,7 @@ static int rts5209_card_power_off(struct rtsx_pcr *pcr, int card)
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_PWR_CTL,
 			pwr_mask | PMOS_STRG_MASK, pwr_off | PMOS_STRG_400mA);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PWR_GATE_CTRL,
-			LDO3318_PWR_MASK, 0X06);
+			LDO3318_PWR_MASK, 0x06);
 	return rtsx_pci_send_cmd(pcr, 100);
 }
 
@@ -150,7 +160,7 @@ static int rts5209_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 
 	if (voltage == OUTPUT_3V3) {
 		err = rtsx_pci_write_register(pcr,
-				SD30_DRIVE_SEL, 0x07, DRIVER_TYPE_D);
+				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_3v3);
 		if (err < 0)
 			return err;
 		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4FC0 | 0x24);
@@ -158,7 +168,7 @@ static int rts5209_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 			return err;
 	} else if (voltage == OUTPUT_1V8) {
 		err = rtsx_pci_write_register(pcr,
-				SD30_DRIVE_SEL, 0x07, DRIVER_TYPE_B);
+				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_1v8);
 		if (err < 0)
 			return err;
 		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4C40 | 0x24);
@@ -172,6 +182,7 @@ static int rts5209_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 }
 
 static const struct pcr_ops rts5209_pcr_ops = {
+	.init_settings = rts5209_init_settings,
 	.extra_init_hw = rts5209_extra_init_hw,
 	.optimize_phy = rts5209_optimize_phy,
 	.turn_on_led = rts5209_turn_on_led,
@@ -242,7 +253,11 @@ void rts5209_init_params(struct rtsx_pcr *pcr)
 	pcr->num_slots = 2;
 	pcr->ops = &rts5209_pcr_ops;
 
-	rts5209_init_vendor_cfg(pcr);
+	pcr->flags = 0;
+	pcr->card_drive_sel = 0x55;
+	pcr->sd30_drive_sel_1v8 = 0x03;
+	pcr->sd30_drive_sel_3v3 = 0x01;
+	pcr->aspm_val = 0x02;
 
 	pcr->ic_version = rts5209_get_ic_version(pcr);
 	pcr->sd_pull_ctl_enable_tbl = rts5209_sd_pull_ctl_enable_tbl;
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index fc831dc..c868eaf 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,10 +17,7 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
- *
  *   Roger Tseng <rogerable@realtek.com>
- *   No. 2, Innovation Road II, Hsinchu Science Park, Hsinchu 300, Taiwan
  */
 
 #include <linux/module.h>
@@ -29,6 +26,60 @@
 
 #include "rtsx_pcr.h"
 
+static void rts5227_fill_driving(struct rtsx_pcr *pcr, u8 voltage)
+{
+	u8 driving_3v3[4][3] = {
+		{0x13, 0x13, 0x13},
+		{0x96, 0x96, 0x96},
+		{0x7F, 0x7F, 0x7F},
+		{0x96, 0x96, 0x96},
+	};
+	u8 driving_1v8[4][3] = {
+		{0x99, 0x99, 0x99},
+		{0xAA, 0xAA, 0xAA},
+		{0xFE, 0xFE, 0xFE},
+		{0xB3, 0xB3, 0xB3},
+	};
+	u8 (*driving)[3], drive_sel;
+
+	if (voltage == OUTPUT_3V3) {
+		driving = driving_3v3;
+		drive_sel = pcr->sd30_drive_sel_3v3;
+	} else {
+		driving = driving_1v8;
+		drive_sel = pcr->sd30_drive_sel_1v8;
+	}
+
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CLK_DRIVE_SEL,
+			0xFF, driving[drive_sel][0]);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CMD_DRIVE_SEL,
+			0xFF, driving[drive_sel][1]);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DAT_DRIVE_SEL,
+			0xFF, driving[drive_sel][2]);
+}
+
+static void rts5227_init_settings(struct rtsx_pcr *pcr)
+{
+	u32 val;
+
+	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &val);
+	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, val);
+
+	if (!(val & 0x1000000)) {
+		pcr->aspm_val = (u8)((val >> 28) & 0x03);
+		pcr->sd30_drive_sel_1v8 = (val >> 26) & 0x03;
+		pcr->card_drive_sel &= 0x3F;
+		pcr->card_drive_sel |= (u8)((val >> 25) & 0x01) << 6;
+
+		rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG2, &val);
+		dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n",
+				PCR_SETTING_REG2, val);
+		pcr->sd30_drive_sel_3v3 = (val >> 5) & 0x03;
+		if (val & 0x4000)
+			pcr->flags |= PCR_REVERSE_SOCKET;
+	}
+}
+
 static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	u16 cap;
@@ -48,17 +99,15 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LTR_CTL, 0xFF, 0xA3);
 	/* Configure OBFF */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, OBFF_CFG, 0x03, 0x03);
-	/* Configure force_clock_req
-	 * Maybe We should define 0xFF03 as some name
-	 */
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, 0xFF03, 0x08, 0x08);
-	/* Correct driving */
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-			SD30_CLK_DRIVE_SEL, 0xFF, 0x96);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-			SD30_CMD_DRIVE_SEL, 0xFF, 0x96);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-			SD30_DAT_DRIVE_SEL, 0xFF, 0x96);
+	/* Configure driving */
+	rts5227_fill_driving(pcr, OUTPUT_3V3);
+	/* Configure force_clock_req */
+	if (pcr->flags & PCR_REVERSE_SOCKET)
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+				AUTOLOAD_CFG_BASE + 3, 0xB8, 0xB8);
+	else
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+				AUTOLOAD_CFG_BASE + 3, 0xB8, 0x88);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
@@ -131,13 +180,11 @@ static int rts5227_card_power_off(struct rtsx_pcr *pcr, int card)
 static int rts5227_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 {
 	int err;
-	u8 drive_sel;
 
 	if (voltage == OUTPUT_3V3) {
 		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4FC0 | 0x24);
 		if (err < 0)
 			return err;
-		drive_sel = 0x96;
 	} else if (voltage == OUTPUT_1V8) {
 		err = rtsx_pci_write_phy_register(pcr, 0x11, 0x3C02);
 		if (err < 0)
@@ -145,23 +192,18 @@ static int rts5227_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4C80 | 0x24);
 		if (err < 0)
 			return err;
-		drive_sel = 0xB3;
 	} else {
 		return -EINVAL;
 	}
 
 	/* set pad drive */
 	rtsx_pci_init_cmd(pcr);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CLK_DRIVE_SEL,
-			0xFF, drive_sel);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CMD_DRIVE_SEL,
-			0xFF, drive_sel);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DAT_DRIVE_SEL,
-			0xFF, drive_sel);
+	rts5227_fill_driving(pcr, voltage);
 	return rtsx_pci_send_cmd(pcr, 100);
 }
 
 static const struct pcr_ops rts5227_pcr_ops = {
+	.init_settings = rts5227_init_settings,
 	.extra_init_hw = rts5227_extra_init_hw,
 	.optimize_phy = rts5227_optimize_phy,
 	.turn_on_led = rts5227_turn_on_led,
@@ -227,6 +269,12 @@ void rts5227_init_params(struct rtsx_pcr *pcr)
 	pcr->num_slots = 2;
 	pcr->ops = &rts5227_pcr_ops;
 
+	pcr->flags = 0;
+	pcr->card_drive_sel = 0x41;
+	pcr->sd30_drive_sel_1v8 = 3;
+	pcr->sd30_drive_sel_3v3 = 3;
+	pcr->aspm_val = 0x02;
+
 	pcr->sd_pull_ctl_enable_tbl = rts5227_sd_pull_ctl_enable_tbl;
 	pcr->sd_pull_ctl_disable_tbl = rts5227_sd_pull_ctl_disable_tbl;
 	pcr->ms_pull_ctl_enable_tbl = rts5227_ms_pull_ctl_enable_tbl;
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index 58af4db..f19dd01 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #include <linux/module.h>
@@ -34,6 +33,26 @@ static u8 rts5229_get_ic_version(struct rtsx_pcr *pcr)
 	return val & 0x0F;
 }
 
+static void rts5229_init_settings(struct rtsx_pcr *pcr)
+{
+	u32 val;
+
+	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &val);
+	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, val);
+
+	if (!(val & 0x1000000)) {
+		pcr->aspm_val = (u8)((val >> 28) & 0x03);
+		pcr->sd30_drive_sel_1v8 = map_sd_drive((val >> 26) & 0x03);
+		pcr->card_drive_sel &= 0x3F;
+		pcr->card_drive_sel |= (u8)((val >> 25) & 0x01) << 6;
+
+		rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG2, &val);
+		dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n",
+				PCR_SETTING_REG2, val);
+		pcr->sd30_drive_sel_3v3 = map_sd_drive((val >> 5) & 0x03);
+	}
+}
+
 static int rts5229_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	rtsx_pci_init_cmd(pcr);
@@ -45,6 +64,9 @@ static int rts5229_extra_init_hw(struct rtsx_pcr *pcr)
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x01);
 	/* LED shine disabled, set initial shine cycle period */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, OLT_LED_CTL, 0x0F, 0x02);
+	/* Configure driving */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DRIVE_SEL,
+			0xFF, pcr->sd30_drive_sel_3v3);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
@@ -110,7 +132,7 @@ static int rts5229_card_power_off(struct rtsx_pcr *pcr, int card)
 			SD_POWER_MASK | PMOS_STRG_MASK,
 			SD_POWER_OFF | PMOS_STRG_400mA);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PWR_GATE_CTRL,
-			LDO3318_PWR_MASK, 0X00);
+			LDO3318_PWR_MASK, 0x00);
 	return rtsx_pci_send_cmd(pcr, 100);
 }
 
@@ -120,7 +142,7 @@ static int rts5229_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 
 	if (voltage == OUTPUT_3V3) {
 		err = rtsx_pci_write_register(pcr,
-				SD30_DRIVE_SEL, 0x07, DRIVER_TYPE_D);
+				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_3v3);
 		if (err < 0)
 			return err;
 		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4FC0 | 0x24);
@@ -128,7 +150,7 @@ static int rts5229_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 			return err;
 	} else if (voltage == OUTPUT_1V8) {
 		err = rtsx_pci_write_register(pcr,
-				SD30_DRIVE_SEL, 0x07, DRIVER_TYPE_B);
+				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_1v8);
 		if (err < 0)
 			return err;
 		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4C40 | 0x24);
@@ -142,6 +164,7 @@ static int rts5229_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 }
 
 static const struct pcr_ops rts5229_pcr_ops = {
+	.init_settings = rts5229_init_settings,
 	.extra_init_hw = rts5229_extra_init_hw,
 	.optimize_phy = rts5229_optimize_phy,
 	.turn_on_led = rts5229_turn_on_led,
@@ -221,6 +244,12 @@ void rts5229_init_params(struct rtsx_pcr *pcr)
 	pcr->num_slots = 2;
 	pcr->ops = &rts5229_pcr_ops;
 
+	pcr->flags = 0;
+	pcr->card_drive_sel = 0x41;
+	pcr->sd30_drive_sel_1v8 = 0x03;
+	pcr->sd30_drive_sel_3v3 = 0x01;
+	pcr->aspm_val = 0x02;
+
 	pcr->ic_version = rts5229_get_ic_version(pcr);
 	if (pcr->ic_version == IC_VER_C) {
 		pcr->sd_pull_ctl_enable_tbl = rts5229_sd_pull_ctl_enable_tbl2;
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 15dc848..5b1a6ba 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 128, West Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #include <linux/module.h>
@@ -34,6 +33,60 @@ static u8 rts5249_get_ic_version(struct rtsx_pcr *pcr)
 	return val & 0x0F;
 }
 
+static void rts5249_fill_driving(struct rtsx_pcr *pcr, u8 voltage)
+{
+	u8 driving_3v3[4][3] = {
+		{0x11, 0x11, 0x11},
+		{0x55, 0x55, 0x5C},
+		{0x99, 0x99, 0x92},
+		{0x99, 0x99, 0x92},
+	};
+	u8 driving_1v8[4][3] = {
+		{0x3C, 0x3C, 0x3C},
+		{0xB3, 0xB3, 0xB3},
+		{0xFE, 0xFE, 0xFE},
+		{0xC4, 0xC4, 0xC4},
+	};
+	u8 (*driving)[3], drive_sel;
+
+	if (voltage == OUTPUT_3V3) {
+		driving = driving_3v3;
+		drive_sel = pcr->sd30_drive_sel_3v3;
+	} else {
+		driving = driving_1v8;
+		drive_sel = pcr->sd30_drive_sel_1v8;
+	}
+
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CLK_DRIVE_SEL,
+			0xFF, driving[drive_sel][0]);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CMD_DRIVE_SEL,
+			0xFF, driving[drive_sel][1]);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DAT_DRIVE_SEL,
+			0xFF, driving[drive_sel][2]);
+}
+
+static void rts5249_init_settings(struct rtsx_pcr *pcr)
+{
+	u32 val;
+
+	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &val);
+	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, val);
+
+	if (!(val & 0x1000000)) {
+		pcr->aspm_val = (u8)((val >> 28) & 0x03);
+		pcr->sd30_drive_sel_1v8 = (val >> 26) & 0x03;
+		pcr->card_drive_sel &= 0x3F;
+		pcr->card_drive_sel |= (u8)((val >> 25) & 0x01) << 6;
+
+		rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG2, &val);
+		dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n",
+				PCR_SETTING_REG2, val);
+		pcr->sd30_drive_sel_3v3 = (val >> 5) & 0x03;
+		if (val & 0x4000)
+			pcr->flags |= PCR_REVERSE_SOCKET;
+	}
+}
+
 static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	rtsx_pci_init_cmd(pcr);
@@ -45,13 +98,14 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x01);
 	/* LED shine disabled, set initial shine cycle period */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, OLT_LED_CTL, 0x0F, 0x02);
-	/* Correct driving */
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-			SD30_CLK_DRIVE_SEL, 0xFF, 0x99);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-			SD30_CMD_DRIVE_SEL, 0xFF, 0x99);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-			SD30_DAT_DRIVE_SEL, 0xFF, 0x92);
+	/* Configure driving */
+	rts5249_fill_driving(pcr, OUTPUT_3V3);
+	if (pcr->flags & PCR_REVERSE_SOCKET)
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+				AUTOLOAD_CFG_BASE + 3, 0xB0, 0xB0);
+	else
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+				AUTOLOAD_CFG_BASE + 3, 0xB0, 0x80);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
@@ -129,15 +183,11 @@ static int rts5249_card_power_off(struct rtsx_pcr *pcr, int card)
 static int rts5249_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 {
 	int err;
-	u8 clk_drive, cmd_drive, dat_drive;
 
 	if (voltage == OUTPUT_3V3) {
 		err = rtsx_pci_write_phy_register(pcr, PHY_TUNE, 0x4FC0 | 0x24);
 		if (err < 0)
 			return err;
-		clk_drive = 0x99;
-		cmd_drive = 0x99;
-		dat_drive = 0x92;
 	} else if (voltage == OUTPUT_1V8) {
 		err = rtsx_pci_write_phy_register(pcr, PHY_BACR, 0x3C02);
 		if (err < 0)
@@ -145,25 +195,18 @@ static int rts5249_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 		err = rtsx_pci_write_phy_register(pcr, PHY_TUNE, 0x4C40 | 0x24);
 		if (err < 0)
 			return err;
-		clk_drive = 0xb3;
-		cmd_drive = 0xb3;
-		dat_drive = 0xb3;
 	} else {
 		return -EINVAL;
 	}
 
 	/* set pad drive */
 	rtsx_pci_init_cmd(pcr);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CLK_DRIVE_SEL,
-			0xFF, clk_drive);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CMD_DRIVE_SEL,
-			0xFF, cmd_drive);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DAT_DRIVE_SEL,
-			0xFF, dat_drive);
+	rts5249_fill_driving(pcr, voltage);
 	return rtsx_pci_send_cmd(pcr, 100);
 }
 
 static const struct pcr_ops rts5249_pcr_ops = {
+	.init_settings = rts5249_init_settings,
 	.extra_init_hw = rts5249_extra_init_hw,
 	.optimize_phy = rts5249_optimize_phy,
 	.turn_on_led = rts5249_turn_on_led,
@@ -233,6 +276,12 @@ void rts5249_init_params(struct rtsx_pcr *pcr)
 	pcr->num_slots = 2;
 	pcr->ops = &rts5249_pcr_ops;
 
+	pcr->flags = 0;
+	pcr->card_drive_sel = 0x41;
+	pcr->sd30_drive_sel_1v8 = 1;
+	pcr->sd30_drive_sel_3v3 = 3;
+	pcr->aspm_val = 0x02;
+
 	pcr->ic_version = rts5249_get_ic_version(pcr);
 	pcr->sd_pull_ctl_enable_tbl = rts5249_sd_pull_ctl_enable_tbl;
 	pcr->sd_pull_ctl_disable_tbl = rts5249_sd_pull_ctl_disable_tbl;
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index dd186c4..7bab03d 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #include <linux/pci.h>
@@ -73,6 +72,9 @@ void rtsx_pci_start_run(struct rtsx_pcr *pcr)
 		pcr->state = PDEV_STAT_RUN;
 		if (pcr->ops->enable_auto_blink)
 			pcr->ops->enable_auto_blink(pcr);
+
+		if (pcr->aspm_val)
+			rtsx_pci_write_config_byte(pcr, LCTLR, 0);
 	}
 
 	mod_delayed_work(system_wq, &pcr->idle_work, msecs_to_jiffies(200));
@@ -717,7 +719,7 @@ int rtsx_pci_card_exclusive_check(struct rtsx_pcr *pcr, int card)
 		[RTSX_MS_CARD] = MS_EXIST
 	};
 
-	if (!pcr->ms_pmos) {
+	if (!(pcr->flags & PCR_MS_PMOS)) {
 		/* When using single PMOS, accessing card is not permitted
 		 * if the existing card is not the designated one.
 		 */
@@ -918,6 +920,9 @@ static void rtsx_pci_idle_work(struct work_struct *work)
 	if (pcr->ops->turn_off_led)
 		pcr->ops->turn_off_led(pcr);
 
+	if (pcr->aspm_val)
+		rtsx_pci_write_config_byte(pcr, LCTLR, pcr->aspm_val);
+
 	mutex_unlock(&pcr->pcr_mutex);
 }
 
@@ -956,8 +961,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 	/* Reset delink mode */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CHANGE_LINK_STATE, 0x0A, 0);
 	/* Card driving select */
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DRIVE_SEL,
-			0x07, DRIVER_TYPE_D);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_DRIVE_SEL,
+			0xFF, pcr->card_drive_sel);
 	/* Enable SSC Clock */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SSC_CTL1,
 			0xFF, SSC_8X_EN | SSC_SEL_4M);
@@ -989,6 +994,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 	if (err < 0)
 		return err;
 
+	rtsx_pci_write_config_byte(pcr, LCTLR, 0);
+
 	/* Enable clk_request_n to enable clock power management */
 	rtsx_pci_write_config_byte(pcr, 0x81, 1);
 	/* Enter L1 when host tx idle */
@@ -1053,6 +1060,18 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 	if (!pcr->slots)
 		return -ENOMEM;
 
+	if (pcr->ops->init_settings)
+		pcr->ops->init_settings(pcr);
+
+	dev_dbg(&(pcr->pci->dev), "pcr->aspm_val = 0x%x\n", pcr->aspm_val);
+	dev_dbg(&(pcr->pci->dev), "pcr->sd30_drive_sel_1v8 = 0x%x\n",
+			pcr->sd30_drive_sel_1v8);
+	dev_dbg(&(pcr->pci->dev), "pcr->sd30_drive_sel_3v3 = 0x%x\n",
+			pcr->sd30_drive_sel_3v3);
+	dev_dbg(&(pcr->pci->dev), "pcr->card_drive_sel = 0x%x\n",
+			pcr->card_drive_sel);
+	dev_dbg(&(pcr->pci->dev), "pcr->flags = 0x%x\n", pcr->flags);
+
 	pcr->state = PDEV_STAT_IDLE;
 	err = rtsx_pci_init_hw(pcr);
 	if (err < 0) {
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index c0cac7e..830aa66 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #ifndef __RTSX_PCR_H
@@ -35,4 +34,16 @@ void rts5227_init_params(struct rtsx_pcr *pcr);
 void rts5249_init_params(struct rtsx_pcr *pcr);
 void rtl8411b_init_params(struct rtsx_pcr *pcr);
 
+static inline u8 map_sd_drive(int idx)
+{
+	u8 sd_drive[4] = {
+		0x01,	/* Type D */
+		0x02,	/* Type C */
+		0x05,	/* Type A */
+		0x03	/* Type B */
+	};
+
+	return sd_drive[idx];
+}
+
 #endif
diff --git a/include/linux/mfd/rtsx_common.h b/include/linux/mfd/rtsx_common.h
index 2b13970..443176e 100644
--- a/include/linux/mfd/rtsx_common.h
+++ b/include/linux/mfd/rtsx_common.h
@@ -1,6 +1,6 @@
 /* Driver for Realtek driver-based card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #ifndef __RTSX_COMMON_H
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 7a9f708..4a7eef3 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #ifndef __RTSX_PCI_H
@@ -684,6 +683,8 @@
 
 #define DUMMY_REG_RESET_0		0xFE90
 
+#define AUTOLOAD_CFG_BASE		0xFF00
+
 /* Memory mapping */
 #define SRAM_BASE			0xE600
 #define RBUF_BASE			0xF400
@@ -726,6 +727,11 @@
 #define PHY_FLD4			0x1E
 #define PHY_DUM_REG			0x1F
 
+#define LCTLR				0x80
+#define PCR_SETTING_REG1		0x724
+#define PCR_SETTING_REG2		0x814
+#define PCR_SETTING_REG3		0x747
+
 #define rtsx_pci_init_cmd(pcr)		((pcr)->ci = 0)
 
 struct rtsx_pcr;
@@ -747,6 +753,7 @@ struct pcr_ops {
 						u8 voltage);
 	unsigned int	(*cd_deglitch)(struct rtsx_pcr *pcr);
 	int		(*conv_clk_and_div_n)(int clk, int dir);
+	void		(*init_settings)(struct rtsx_pcr *pcr);
 };
 
 enum PDEV_STAT  {PDEV_STAT_IDLE, PDEV_STAT_RUN};
@@ -788,7 +795,6 @@ struct rtsx_pcr {
 	struct completion		*finish_me;
 
 	unsigned int			cur_clock;
-	bool				ms_pmos;
 	bool				remove_pci;
 	bool				msi_en;
 
@@ -806,6 +812,15 @@ struct rtsx_pcr {
 #define IC_VER_D			3
 	u8				ic_version;
 
+	u8				sd30_drive_sel_1v8;
+	u8				sd30_drive_sel_3v3;
+	u8				card_drive_sel;
+	u8				aspm_val;
+
+#define PCR_MS_PMOS			(1 << 0)
+#define PCR_REVERSE_SOCKET		(1 << 1)
+	u32				flags;
+
 	const u32			*sd_pull_ctl_enable_tbl;
 	const u32			*sd_pull_ctl_disable_tbl;
 	const u32			*ms_pull_ctl_enable_tbl;
-- 
1.7.9.5

