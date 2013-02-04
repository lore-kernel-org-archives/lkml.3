Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3BDHti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:49:38 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49895 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3BDHsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:48:51 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r147mX1S025269, This message is released by code: ctlocs8528
From: Roger Tseng <rogerable@realtek.com>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, Roger Tseng <rogerable@realtek.com>
Subject: [PATCH 3/3] mfd: rtsx: support RTS5227
Date: Mon, 4 Feb 2013 15:45:59 +0800
Message-ID: <1359963959-2305-4-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1359963959-2305-1-git-send-email-rogerable@realtek.com>
References: <1359963959-2305-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support new model RTS5227.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
Reviewed-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/Makefile         |   2 +-
 drivers/mfd/rts5227.c        | 234 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/rtsx_pcr.c       |   5 +
 drivers/mfd/rtsx_pcr.h       |   1 +
 include/linux/mfd/rtsx_pci.h |   5 +
 5 files changed, 246 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mfd/rts5227.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8b977f8..b90409c 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 
-rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o
+rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o rts5227.o
 obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
 
 obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
new file mode 100644
index 0000000..fc831dc
--- /dev/null
+++ b/drivers/mfd/rts5227.c
@@ -0,0 +1,234 @@
+/* Driver for Realtek PCI-Express card reader
+ *
+ * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author:
+ *   Wei WANG <wei_wang@realsil.com.cn>
+ *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
+ *
+ *   Roger Tseng <rogerable@realtek.com>
+ *   No. 2, Innovation Road II, Hsinchu Science Park, Hsinchu 300, Taiwan
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/mfd/rtsx_pci.h>
+
+#include "rtsx_pcr.h"
+
+static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
+{
+	u16 cap;
+
+	rtsx_pci_init_cmd(pcr);
+
+	/* Configure GPIO as output */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, GPIO_CTL, 0x02, 0x02);
+	/* Switch LDO3318 source from DV33 to card_3v3 */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x00);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x01);
+	/* LED shine disabled, set initial shine cycle period */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, OLT_LED_CTL, 0x0F, 0x02);
+	/* Configure LTR */
+	pcie_capability_read_word(pcr->pci, PCI_EXP_DEVCTL2, &cap);
+	if (cap & PCI_EXP_LTR_EN)
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LTR_CTL, 0xFF, 0xA3);
+	/* Configure OBFF */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, OBFF_CFG, 0x03, 0x03);
+	/* Configure force_clock_req
+	 * Maybe We should define 0xFF03 as some name
+	 */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, 0xFF03, 0x08, 0x08);
+	/* Correct driving */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+			SD30_CLK_DRIVE_SEL, 0xFF, 0x96);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+			SD30_CMD_DRIVE_SEL, 0xFF, 0x96);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+			SD30_DAT_DRIVE_SEL, 0xFF, 0x96);
+
+	return rtsx_pci_send_cmd(pcr, 100);
+}
+
+static int rts5227_optimize_phy(struct rtsx_pcr *pcr)
+{
+	/* Optimize RX sensitivity */
+	return rtsx_pci_write_phy_register(pcr, 0x00, 0xBA42);
+}
+
+static int rts5227_turn_on_led(struct rtsx_pcr *pcr)
+{
+	return rtsx_pci_write_register(pcr, GPIO_CTL, 0x02, 0x02);
+}
+
+static int rts5227_turn_off_led(struct rtsx_pcr *pcr)
+{
+	return rtsx_pci_write_register(pcr, GPIO_CTL, 0x02, 0x00);
+}
+
+static int rts5227_enable_auto_blink(struct rtsx_pcr *pcr)
+{
+	return rtsx_pci_write_register(pcr, OLT_LED_CTL, 0x08, 0x08);
+}
+
+static int rts5227_disable_auto_blink(struct rtsx_pcr *pcr)
+{
+	return rtsx_pci_write_register(pcr, OLT_LED_CTL, 0x08, 0x00);
+}
+
+static int rts5227_card_power_on(struct rtsx_pcr *pcr, int card)
+{
+	int err;
+
+	rtsx_pci_init_cmd(pcr);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_PWR_CTL,
+			SD_POWER_MASK, SD_PARTIAL_POWER_ON);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PWR_GATE_CTRL,
+			LDO3318_PWR_MASK, 0x02);
+	err = rtsx_pci_send_cmd(pcr, 100);
+	if (err < 0)
+		return err;
+
+	/* To avoid too large in-rush current */
+	udelay(150);
+
+	rtsx_pci_init_cmd(pcr);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_PWR_CTL,
+			SD_POWER_MASK, SD_POWER_ON);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PWR_GATE_CTRL,
+			LDO3318_PWR_MASK, 0x06);
+	err = rtsx_pci_send_cmd(pcr, 100);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int rts5227_card_power_off(struct rtsx_pcr *pcr, int card)
+{
+	rtsx_pci_init_cmd(pcr);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_PWR_CTL,
+			SD_POWER_MASK | PMOS_STRG_MASK,
+			SD_POWER_OFF | PMOS_STRG_400mA);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PWR_GATE_CTRL,
+			LDO3318_PWR_MASK, 0X00);
+	return rtsx_pci_send_cmd(pcr, 100);
+}
+
+static int rts5227_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
+{
+	int err;
+	u8 drive_sel;
+
+	if (voltage == OUTPUT_3V3) {
+		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4FC0 | 0x24);
+		if (err < 0)
+			return err;
+		drive_sel = 0x96;
+	} else if (voltage == OUTPUT_1V8) {
+		err = rtsx_pci_write_phy_register(pcr, 0x11, 0x3C02);
+		if (err < 0)
+			return err;
+		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4C80 | 0x24);
+		if (err < 0)
+			return err;
+		drive_sel = 0xB3;
+	} else {
+		return -EINVAL;
+	}
+
+	/* set pad drive */
+	rtsx_pci_init_cmd(pcr);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CLK_DRIVE_SEL,
+			0xFF, drive_sel);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CMD_DRIVE_SEL,
+			0xFF, drive_sel);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DAT_DRIVE_SEL,
+			0xFF, drive_sel);
+	return rtsx_pci_send_cmd(pcr, 100);
+}
+
+static const struct pcr_ops rts5227_pcr_ops = {
+	.extra_init_hw = rts5227_extra_init_hw,
+	.optimize_phy = rts5227_optimize_phy,
+	.turn_on_led = rts5227_turn_on_led,
+	.turn_off_led = rts5227_turn_off_led,
+	.enable_auto_blink = rts5227_enable_auto_blink,
+	.disable_auto_blink = rts5227_disable_auto_blink,
+	.card_power_on = rts5227_card_power_on,
+	.card_power_off = rts5227_card_power_off,
+	.switch_output_voltage = rts5227_switch_output_voltage,
+	.cd_deglitch = NULL,
+	.conv_clk_and_div_n = NULL,
+};
+
+/* SD Pull Control Enable:
+ *     SD_DAT[3:0] ==> pull up
+ *     SD_CD       ==> pull up
+ *     SD_WP       ==> pull up
+ *     SD_CMD      ==> pull up
+ *     SD_CLK      ==> pull down
+ */
+static const u32 rts5227_sd_pull_ctl_enable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0xAA),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0xE9),
+	0,
+};
+
+/* SD Pull Control Disable:
+ *     SD_DAT[3:0] ==> pull down
+ *     SD_CD       ==> pull up
+ *     SD_WP       ==> pull down
+ *     SD_CMD      ==> pull down
+ *     SD_CLK      ==> pull down
+ */
+static const u32 rts5227_sd_pull_ctl_disable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0xD5),
+	0,
+};
+
+/* MS Pull Control Enable:
+ *     MS CD       ==> pull up
+ *     others      ==> pull down
+ */
+static const u32 rts5227_ms_pull_ctl_enable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL5, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x15),
+	0,
+};
+
+/* MS Pull Control Disable:
+ *     MS CD       ==> pull up
+ *     others      ==> pull down
+ */
+static const u32 rts5227_ms_pull_ctl_disable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL5, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x15),
+	0,
+};
+
+void rts5227_init_params(struct rtsx_pcr *pcr)
+{
+	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
+	pcr->num_slots = 2;
+	pcr->ops = &rts5227_pcr_ops;
+
+	pcr->sd_pull_ctl_enable_tbl = rts5227_sd_pull_ctl_enable_tbl;
+	pcr->sd_pull_ctl_disable_tbl = rts5227_sd_pull_ctl_disable_tbl;
+	pcr->ms_pull_ctl_enable_tbl = rts5227_ms_pull_ctl_enable_tbl;
+	pcr->ms_pull_ctl_disable_tbl = rts5227_ms_pull_ctl_disable_tbl;
+}
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 9016932..822237e 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -55,6 +55,7 @@ static DEFINE_PCI_DEVICE_TABLE(rtsx_pci_ids) = {
 	{ PCI_DEVICE(0x10EC, 0x5209), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5229), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5289), PCI_CLASS_OTHERS << 16, 0xFF0000 },
+	{ PCI_DEVICE(0x10EC, 0x5227), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ 0, }
 };
 
@@ -998,6 +999,10 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 	case 0x5289:
 		rtl8411_init_params(pcr);
 		break;
+
+	case 0x5227:
+		rts5227_init_params(pcr);
+		break;
 	}
 
 	dev_dbg(&(pcr->pci->dev), "PID: 0x%04x, IC version: 0x%02x\n",
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index 33c210b..2b3ab8a 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -31,5 +31,6 @@
 void rts5209_init_params(struct rtsx_pcr *pcr);
 void rts5229_init_params(struct rtsx_pcr *pcr);
 void rtl8411_init_params(struct rtsx_pcr *pcr);
+void rts5227_init_params(struct rtsx_pcr *pcr);
 
 #endif
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 3f2bf26..5d9b81e 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -581,8 +581,11 @@
 #define CARD_GPIO_DIR			0xFD57
 #define CARD_GPIO			0xFD58
 #define CARD_DATA_SOURCE		0xFD5B
+#define SD30_CLK_DRIVE_SEL		0xFD5A
 #define CARD_SELECT			0xFD5C
 #define SD30_DRIVE_SEL			0xFD5E
+#define SD30_CMD_DRIVE_SEL		0xFD5E
+#define SD30_DAT_DRIVE_SEL		0xFD5F
 #define CARD_CLK_EN			0xFD69
 #define SDIO_CTRL			0xFD6B
 #define CD_PAD_CTL			0xFD73
@@ -655,6 +658,8 @@
 #define MSGTXDATA3			0xFE47
 #define MSGTXCTL			0xFE48
 #define PETXCFG				0xFE49
+#define LTR_CTL				0xFE4A
+#define OBFF_CFG			0xFE4C
 
 #define CDRESUMECTL			0xFE52
 #define WAKE_SEL_CTL			0xFE54
-- 
1.7.12.1

