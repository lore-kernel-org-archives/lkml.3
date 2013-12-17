Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3LQCfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:35:01 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:46028 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3LQCe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:34:59 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rBH2YnxI001099, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v3 2/2] mfd: rtsx: add card reader rtl8402
Date: Tue, 17 Dec 2013 10:36:59 +0800
Message-ID: <f43e4d180851c395661efc65f397c9dabba491b0.1387246693.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1387246693.git.micky_ching@realsil.com.cn>
References: <cover.1387246693.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add card reader rtl8042, rtl8402 is much like rtl8411, so just add it to
rtl8411.c

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rtl8411.c  |   28 ++++++++++++++++++++++++----
 drivers/mfd/rtsx_pcr.c |    5 +++++
 drivers/mfd/rtsx_pcr.h |    1 +
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index c9eab9d..01eb31b 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -191,24 +191,25 @@ static int rtl8411_card_power_off(struct rtsx_pcr *pcr, int card)
 			BPP_LDO_POWB, BPP_LDO_SUSPEND);
 }
 
-static int rtl8411_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
+static int rtl8411_do_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage,
+		int bpp_tuned18_shift, int bpp_asic_1v8)
 {
 	u8 mask, val;
 	int err;
 
-	mask = (BPP_REG_TUNED18 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_MASK;
+	mask = (BPP_REG_TUNED18 << bpp_tuned18_shift) | BPP_PAD_MASK;
 	if (voltage == OUTPUT_3V3) {
 		err = rtsx_pci_write_register(pcr,
 				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_3v3);
 		if (err < 0)
 			return err;
-		val = (BPP_ASIC_3V3 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_3V3;
+		val = (BPP_ASIC_3V3 << bpp_tuned18_shift) | BPP_PAD_3V3;
 	} else if (voltage == OUTPUT_1V8) {
 		err = rtsx_pci_write_register(pcr,
 				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_1v8);
 		if (err < 0)
 			return err;
-		val = (BPP_ASIC_1V8 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_1V8;
+		val = (bpp_asic_1v8 << bpp_tuned18_shift) | BPP_PAD_1V8;
 	} else {
 		return -EINVAL;
 	}
@@ -216,6 +217,18 @@ static int rtl8411_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 	return rtsx_pci_write_register(pcr, LDO_CTL, mask, val);
 }
 
+static int rtl8411_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
+{
+	return rtl8411_do_switch_output_voltage(pcr, voltage,
+			BPP_TUNED18_SHIFT_8411, BPP_ASIC_1V8);
+}
+
+static int rtl8402_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
+{
+	return rtl8411_do_switch_output_voltage(pcr, voltage,
+			BPP_TUNED18_SHIFT_8402, BPP_ASIC_2V0);
+}
+
 static unsigned int rtl8411_cd_deglitch(struct rtsx_pcr *pcr)
 {
 	unsigned int card_exist;
@@ -457,3 +470,10 @@ void rtl8411b_init_params(struct rtsx_pcr *pcr)
 	else
 		set_pull_ctrl_tables(rtl8411b_qfn64);
 }
+
+void rtl8402_init_params(struct rtsx_pcr *pcr)
+{
+	rtl8411_init_params(pcr);
+
+	rtl8411_pcr_ops.switch_output_voltage = rtl8402_switch_output_voltage;
+}
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 11e20af..2af55bb 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -57,6 +57,7 @@ static DEFINE_PCI_DEVICE_TABLE(rtsx_pci_ids) = {
 	{ PCI_DEVICE(0x10EC, 0x5227), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5249), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5287), PCI_CLASS_OTHERS << 16, 0xFF0000 },
+	{ PCI_DEVICE(0x10EC, 0x5286), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ 0, }
 };
 
@@ -1061,6 +1062,10 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 	case 0x5287:
 		rtl8411b_init_params(pcr);
 		break;
+
+	case 0x5286:
+		rtl8402_init_params(pcr);
+		break;
 	}
 
 	dev_dbg(&(pcr->pci->dev), "PID: 0x%04x, IC version: 0x%02x\n",
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index 26b52ec..c097dbd 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -30,6 +30,7 @@
 void rts5209_init_params(struct rtsx_pcr *pcr);
 void rts5229_init_params(struct rtsx_pcr *pcr);
 void rtl8411_init_params(struct rtsx_pcr *pcr);
+void rtl8402_init_params(struct rtsx_pcr *pcr);
 void rts5227_init_params(struct rtsx_pcr *pcr);
 void rts5249_init_params(struct rtsx_pcr *pcr);
 void rtl8411b_init_params(struct rtsx_pcr *pcr);
-- 
1.7.9.5

