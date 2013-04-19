Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030500Ab3DSNyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:54:33 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:43879 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030417Ab3DSNyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:54:31 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r3JDs3h2018895, This message is released by code: ctlocs8528
From: <rogerable@realtek.com>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, Roger Tseng <rogerable@realtek.com>
Subject: [PATCH] mfd:rtsx: Support RTL8411B
Date: Fri, 19 Apr 2013 21:52:42 +0800
Message-ID: <1366379562-23429-1-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

Adding support of model RTL8411B. Since the model is similar to RTL8411,
differences are implemented in rtl8411.c.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
---
 drivers/mfd/rtl8411.c        | 132 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/rtsx_pcr.c       |   5 ++
 drivers/mfd/rtsx_pcr.h       |   1 +
 include/linux/mfd/rtsx_pci.h |   1 +
 4 files changed, 139 insertions(+)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 2a2d316..c436bf2 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -35,12 +35,33 @@ static u8 rtl8411_get_ic_version(struct rtsx_pcr *pcr)
 	return val & 0x0F;
 }
 
+static int rtl8411b_is_qfn48(struct rtsx_pcr *pcr)
+{
+	u8 val = 0;
+
+	rtsx_pci_read_register(pcr, RTL8411B_PACKAGE_MODE, &val);
+
+	if (val & 0x2)
+		return 1;
+	else
+		return 0;
+}
+
 static int rtl8411_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	return rtsx_pci_write_register(pcr, CD_PAD_CTL,
 			CD_DISABLE_MASK | CD_AUTO_DISABLE, CD_ENABLE);
 }
 
+static int rtl8411b_extra_init_hw(struct rtsx_pcr *pcr)
+{
+	if (rtl8411b_is_qfn48(pcr))
+		rtsx_pci_write_register(pcr, CARD_PULL_CTL3, 0xFF, 0xF5);
+
+	return rtsx_pci_write_register(pcr, CD_PAD_CTL,
+			CD_DISABLE_MASK | CD_AUTO_DISABLE, CD_ENABLE);
+}
+
 static int rtl8411_turn_on_led(struct rtsx_pcr *pcr)
 {
 	return rtsx_pci_write_register(pcr, CARD_GPIO, 0x01, 0x00);
@@ -214,6 +235,20 @@ static const struct pcr_ops rtl8411_pcr_ops = {
 	.conv_clk_and_div_n = rtl8411_conv_clk_and_div_n,
 };
 
+static const struct pcr_ops rtl8411b_pcr_ops = {
+	.extra_init_hw = rtl8411b_extra_init_hw,
+	.optimize_phy = NULL,
+	.turn_on_led = rtl8411_turn_on_led,
+	.turn_off_led = rtl8411_turn_off_led,
+	.enable_auto_blink = rtl8411_enable_auto_blink,
+	.disable_auto_blink = rtl8411_disable_auto_blink,
+	.card_power_on = rtl8411_card_power_on,
+	.card_power_off = rtl8411_card_power_off,
+	.switch_output_voltage = rtl8411_switch_output_voltage,
+	.cd_deglitch = rtl8411_cd_deglitch,
+	.conv_clk_and_div_n = rtl8411_conv_clk_and_div_n,
+};
+
 /* SD Pull Control Enable:
  *     SD_DAT[3:0] ==> pull up
  *     SD_CD       ==> pull up
@@ -276,6 +311,74 @@ static const u32 rtl8411_ms_pull_ctl_disable_tbl[] = {
 	0,
 };
 
+static const u32 rtl8411b_qfn64_sd_pull_ctl_enable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL1, 0xAA),
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0xAA),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0x09 | 0xD0),
+	RTSX_REG_PAIR(CARD_PULL_CTL4, 0x09 | 0x50),
+	RTSX_REG_PAIR(CARD_PULL_CTL5, 0x05 | 0x50),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x04 | 0x11),
+	0,
+};
+
+static const u32 rtl8411b_qfn48_sd_pull_ctl_enable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0xAA),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0x69 | 0x90),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x08 | 0x11),
+	0,
+};
+
+static const u32 rtl8411b_qfn64_sd_pull_ctl_disable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL1, 0x65),
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0x05 | 0xD0),
+	RTSX_REG_PAIR(CARD_PULL_CTL4, 0x09 | 0x50),
+	RTSX_REG_PAIR(CARD_PULL_CTL5, 0x05 | 0x50),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x04 | 0x11),
+	0,
+};
+
+static const u32 rtl8411b_qfn48_sd_pull_ctl_disable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0x65 | 0x90),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x04 | 0x11),
+	0,
+};
+
+static const u32 rtl8411b_qfn64_ms_pull_ctl_enable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL1, 0x65),
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0x05 | 0xD0),
+	RTSX_REG_PAIR(CARD_PULL_CTL4, 0x05 | 0x50),
+	RTSX_REG_PAIR(CARD_PULL_CTL5, 0x05 | 0x50),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x04 | 0x11),
+	0,
+};
+
+static const u32 rtl8411b_qfn48_ms_pull_ctl_enable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0x65 | 0x90),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x04 | 0x11),
+	0,
+};
+
+static const u32 rtl8411b_qfn64_ms_pull_ctl_disable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL1, 0x65),
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0x05 | 0xD0),
+	RTSX_REG_PAIR(CARD_PULL_CTL4, 0x09 | 0x50),
+	RTSX_REG_PAIR(CARD_PULL_CTL5, 0x05 | 0x50),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x04 | 0x11),
+	0,
+};
+
+static const u32 rtl8411b_qfn48_ms_pull_ctl_disable_tbl[] = {
+	RTSX_REG_PAIR(CARD_PULL_CTL2, 0x55),
+	RTSX_REG_PAIR(CARD_PULL_CTL3, 0x65 | 0x90),
+	RTSX_REG_PAIR(CARD_PULL_CTL6, 0x04 | 0x11),
+	0,
+};
+
 void rtl8411_init_params(struct rtsx_pcr *pcr)
 {
 	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
@@ -288,3 +391,32 @@ void rtl8411_init_params(struct rtsx_pcr *pcr)
 	pcr->ms_pull_ctl_enable_tbl = rtl8411_ms_pull_ctl_enable_tbl;
 	pcr->ms_pull_ctl_disable_tbl = rtl8411_ms_pull_ctl_disable_tbl;
 }
+
+void rtl8411b_init_params(struct rtsx_pcr *pcr)
+{
+	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
+	pcr->num_slots = 2;
+	pcr->ops = &rtl8411b_pcr_ops;
+
+	pcr->ic_version = rtl8411_get_ic_version(pcr);
+
+	if (rtl8411b_is_qfn48(pcr)) {
+		pcr->sd_pull_ctl_enable_tbl =
+			rtl8411b_qfn48_sd_pull_ctl_enable_tbl;
+		pcr->sd_pull_ctl_disable_tbl =
+			rtl8411b_qfn48_sd_pull_ctl_disable_tbl;
+		pcr->ms_pull_ctl_enable_tbl =
+			rtl8411b_qfn48_ms_pull_ctl_enable_tbl;
+		pcr->ms_pull_ctl_disable_tbl =
+			rtl8411b_qfn48_ms_pull_ctl_disable_tbl;
+	} else {
+		pcr->sd_pull_ctl_enable_tbl =
+			rtl8411b_qfn64_sd_pull_ctl_enable_tbl;
+		pcr->sd_pull_ctl_disable_tbl =
+			rtl8411b_qfn64_sd_pull_ctl_disable_tbl;
+		pcr->ms_pull_ctl_enable_tbl =
+			rtl8411b_qfn64_ms_pull_ctl_enable_tbl;
+		pcr->ms_pull_ctl_disable_tbl =
+			rtl8411b_qfn64_ms_pull_ctl_disable_tbl;
+	}
+}
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 62b0e12..5d9202c 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -57,6 +57,7 @@ static DEFINE_PCI_DEVICE_TABLE(rtsx_pci_ids) = {
 	{ PCI_DEVICE(0x10EC, 0x5289), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5227), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5249), PCI_CLASS_OTHERS << 16, 0xFF0000 },
+	{ PCI_DEVICE(0x10EC, 0x5287), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ 0, }
 };
 
@@ -1038,6 +1039,10 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 	case 0x5249:
 		rts5249_init_params(pcr);
 		break;
+
+	case 0x5287:
+		rtl8411b_init_params(pcr);
+		break;
 	}
 
 	dev_dbg(&(pcr->pci->dev), "PID: 0x%04x, IC version: 0x%02x\n",
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index 55fcfc2..c0cac7e 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -33,5 +33,6 @@ void rts5229_init_params(struct rtsx_pcr *pcr);
 void rtl8411_init_params(struct rtsx_pcr *pcr);
 void rts5227_init_params(struct rtsx_pcr *pcr);
 void rts5249_init_params(struct rtsx_pcr *pcr);
+void rtl8411b_init_params(struct rtsx_pcr *pcr);
 
 #endif
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 86bc635..7a9f708 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -575,6 +575,7 @@
 
 #define CARD_PWR_CTL			0xFD50
 #define CARD_CLK_SWITCH			0xFD51
+#define RTL8411B_PACKAGE_MODE		0xFD51
 #define CARD_SHARE_MODE			0xFD52
 #define CARD_DRIVE_SEL			0xFD53
 #define CARD_STOP			0xFD54
-- 
1.8.2

