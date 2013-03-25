Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3CYCOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 22:14:18 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:44624 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3CYCOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 22:14:16 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r2P2DvDf030099, This message is released by code: ctlocs8528
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH] mfd:rtsx: Support RTS5249
Date: Mon, 25 Mar 2013 10:13:56 +0800
Message-ID: <1364177636-4294-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Support new model: RTS5249

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/rts5249.c        |  245 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/rtsx_pcr.c       |    5 +
 drivers/mfd/rtsx_pcr.h       |    1 +
 include/linux/mfd/rtsx_pci.h |    2 +
 5 files changed, 254 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mfd/rts5249.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b90409c..f61ac02 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 
-rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o rts5227.o
+rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
 obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
 
 obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
new file mode 100644
index 0000000..24a1861
--- /dev/null
+++ b/drivers/mfd/rts5249.c
@@ -0,0 +1,245 @@
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
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/mfd/rtsx_pci.h>
+
+#include "rtsx_pcr.h"
+
+static u8 rts5249_get_ic_version(struct rtsx_pcr *pcr)
+{
+	u8 val;
+
+	rtsx_pci_read_register(pcr, DUMMY_REG_RESET_0, &val);
+	return val & 0x0F;
+}
+
+static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
+{
+	rtsx_pci_init_cmd(pcr);
+
+	/* Configure GPIO as output */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, GPIO_CTL, 0x02, 0x02);
+	/* Switch LDO3318 source from DV33 to card_3v3 */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x00);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x01);
+	/* LED shine disabled, set initial shine cycle period */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, OLT_LED_CTL, 0x0F, 0x02);
+	/* Configure force_clock_req
+	 * Maybe We should define 0xFF03 as some name
+	 */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, 0xFF03, 0x08, 0x08);
+	/* Correct driving */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+			SD30_CLK_DRIVE_SEL, 0xFF, 0x99);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+			SD30_CMD_DRIVE_SEL, 0xFF, 0x99);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+			SD30_DAT_DRIVE_SEL, 0xFF, 0x92);
+
+	return rtsx_pci_send_cmd(pcr, 100);
+}
+
+static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
+{
+	int err;
+
+	err = rtsx_pci_write_phy_register(pcr, 0x19, 0xFE46);
+	if (err < 0)
+		return err;
+
+	mdelay(1);
+
+	return rtsx_pci_write_phy_register(pcr, 0x0A, 0x05C0);
+}
+
+static int rts5249_turn_on_led(struct rtsx_pcr *pcr)
+{
+	return rtsx_pci_write_register(pcr, GPIO_CTL, 0x02, 0x02);
+}
+
+static int rts5249_turn_off_led(struct rtsx_pcr *pcr)
+{
+	return rtsx_pci_write_register(pcr, GPIO_CTL, 0x02, 0x00);
+}
+
+static int rts5249_enable_auto_blink(struct rtsx_pcr *pcr)
+{
+	return rtsx_pci_write_register(pcr, OLT_LED_CTL, 0x08, 0x08);
+}
+
+static int rts5249_disable_auto_blink(struct rtsx_pcr *pcr)
+{
+	return rtsx_pci_write_register(pcr, OLT_LED_CTL, 0x08, 0x00);
+}
+
+static int rts5249_card_power_on(struct rtsx_pcr *pcr, int card)
+{
+	int err;
+
+	rtsx_pci_init_cmd(pcr);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_PWR_CTL,
+			SD_POWER_MASK, SD_VCC_PARTIAL_POWER_ON);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PWR_GATE_CTRL,
+			LDO3318_PWR_MASK, 0x02);
+	err = rtsx_pci_send_cmd(pcr, 100);
+	if (err < 0)
+		return err;
+
+	msleep(5);
+
+	rtsx_pci_init_cmd(pcr);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_PWR_CTL,
+			SD_POWER_MASK, SD_VCC_POWER_ON);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PWR_GATE_CTRL,
+			LDO3318_PWR_MASK, 0x06);
+	err = rtsx_pci_send_cmd(pcr, 100);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int rts5249_card_power_off(struct rtsx_pcr *pcr, int card)
+{
+	rtsx_pci_init_cmd(pcr);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_PWR_CTL,
+			SD_POWER_MASK, SD_POWER_OFF);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PWR_GATE_CTRL,
+			LDO3318_PWR_MASK, 0x00);
+	return rtsx_pci_send_cmd(pcr, 100);
+}
+
+static int rts5249_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
+{
+	int err;
+	u8 clk_drive, cmd_drive, dat_drive;
+
+	if (voltage == OUTPUT_3V3) {
+		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4FC0 | 0x24);
+		if (err < 0)
+			return err;
+		clk_drive = 0x99;
+		cmd_drive = 0x99;
+		dat_drive = 0x92;
+	} else if (voltage == OUTPUT_1V8) {
+		err = rtsx_pci_write_phy_register(pcr, 0x11, 0x3C02);
+		if (err < 0)
+			return err;
+		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4C40 | 0x24);
+		if (err < 0)
+			return err;
+		clk_drive = 0xb3;
+		cmd_drive = 0xb3;
+		dat_drive = 0xb3;
+	} else {
+		return -EINVAL;
+	}
+
+	/* set pad drive */
+	rtsx_pci_init_cmd(pcr);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CLK_DRIVE_SEL,
+			0xFF, clk_drive);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_CMD_DRIVE_SEL,
+			0xFF, cmd_drive);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD30_DAT_DRIVE_SEL,
+			0xFF, dat_drive);
+	return rtsx_pci_send_cmd(pcr, 100);
+}
+
+static const struct pcr_ops rts5249_pcr_ops = {
+	.extra_init_hw = rts5249_extra_init_hw,
+	.optimize_phy = rts5249_optimize_phy,
+	.turn_on_led = rts5249_turn_on_led,
+	.turn_off_led = rts5249_turn_off_led,
+	.enable_auto_blink = rts5249_enable_auto_blink,
+	.disable_auto_blink = rts5249_disable_auto_blink,
+	.card_power_on = rts5249_card_power_on,
+	.card_power_off = rts5249_card_power_off,
+	.switch_output_voltage = rts5249_switch_output_voltage,
+};
+
+/* SD Pull Control Enable:
+ *     SD_DAT[3:0] ==> pull up
+ *     SD_CD       ==> pull up
+ *     SD_WP       ==> pull up
+ *     SD_CMD      ==> pull up
+ *     SD_CLK      ==> pull down
+ */
+static const u32 rts5249_sd_pull_ctl_enable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL1, 0x66),
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0xAA),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0xE9),
+	RTSX_REG_PAIR(CARD_PULL_CTL4, 0xAA),
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
+static const u32 rts5249_sd_pull_ctl_disable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL1, 0x66),
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0xD5),
+	RTSX_REG_PAIR(CARD_PULL_CTL4, 0x55),
+	0,
+};
+
+/* MS Pull Control Enable:
+ *     MS CD       ==> pull up
+ *     others      ==> pull down
+ */
+static const u32 rts5249_ms_pull_ctl_enable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL4, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL5, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x15),
+	0,
+};
+
+/* MS Pull Control Disable:
+ *     MS CD       ==> pull up
+ *     others      ==> pull down
+ */
+static const u32 rts5249_ms_pull_ctl_disable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL4, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL5, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x15),
+	0,
+};
+
+void rts5249_init_params(struct rtsx_pcr *pcr)
+{
+	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
+	pcr->num_slots = 2;
+	pcr->ops = &rts5249_pcr_ops;
+
+	pcr->ic_version = rts5249_get_ic_version(pcr);
+	pcr->sd_pull_ctl_enable_tbl = rts5249_sd_pull_ctl_enable_tbl;
+	pcr->sd_pull_ctl_disable_tbl = rts5249_sd_pull_ctl_disable_tbl;
+	pcr->ms_pull_ctl_enable_tbl = rts5249_ms_pull_ctl_enable_tbl;
+	pcr->ms_pull_ctl_disable_tbl = rts5249_ms_pull_ctl_disable_tbl;
+}
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 2f12cc1..62b0e12 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -56,6 +56,7 @@ static DEFINE_PCI_DEVICE_TABLE(rtsx_pci_ids) = {
 	{ PCI_DEVICE(0x10EC, 0x5229), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5289), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5227), PCI_CLASS_OTHERS << 16, 0xFF0000 },
+	{ PCI_DEVICE(0x10EC, 0x5249), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ 0, }
 };
 
@@ -1033,6 +1034,10 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 	case 0x5227:
 		rts5227_init_params(pcr);
 		break;
+
+	case 0x5249:
+		rts5249_init_params(pcr);
+		break;
 	}
 
 	dev_dbg(&(pcr->pci->dev), "PID: 0x%04x, IC version: 0x%02x\n",
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index 2b3ab8a..55fcfc2 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -32,5 +32,6 @@ void rts5209_init_params(struct rtsx_pcr *pcr);
 void rts5229_init_params(struct rtsx_pcr *pcr);
 void rtl8411_init_params(struct rtsx_pcr *pcr);
 void rts5227_init_params(struct rtsx_pcr *pcr);
+void rts5249_init_params(struct rtsx_pcr *pcr);
 
 #endif
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 26ea7f1..ffb880b 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -500,6 +500,8 @@
 #define BPP_POWER_15_PERCENT_ON		0x08
 #define BPP_POWER_ON			0x00
 #define BPP_POWER_MASK			0x0F
+#define SD_VCC_PARTIAL_POWER_ON		0x02
+#define SD_VCC_POWER_ON			0x00
 
 /* PWR_GATE_CTRL */
 #define PWR_GATE_EN			0x01
-- 
1.7.9.5

