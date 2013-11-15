Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3KOIdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:33:18 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:42132 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab3KOIdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:33:02 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rAF8WrSn007073, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wei_wang@realsil.com.cn>,
        <rogerable@realtek.com>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 2/3] mfd: rtsx: add card reader rtl8402
Date: Fri, 15 Nov 2013 16:34:12 +0800
Message-ID: <225f6d5d8ab73afbe6b600f07583dada2145ebaa.1384503048.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1384503048.git.micky_ching@realsil.com.cn>
References: <cover.1384503048.git.micky_ching@realsil.com.cn>
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
 drivers/mfd/rtl8411.c  |   29 +++++++++++++++++++++++++++++
 drivers/mfd/rtsx_pcr.c |    2 ++
 2 files changed, 31 insertions(+)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 4de1045..8e4b546 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -216,6 +216,31 @@ static int rtl8411_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 	return rtsx_pci_write_register(pcr, LDO_CTL, mask, val);
 }
 
+static int rtl8402_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
+{
+	u8 mask, val;
+	int err;
+
+	mask = (BPP_REG_TUNED18 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_MASK;
+	if (voltage == OUTPUT_3V3) {
+		err = rtsx_pci_write_register(pcr,
+				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_3v3);
+		if (err < 0)
+			return err;
+		val = (BPP_ASIC_3V3 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_3V3;
+	} else if (voltage == OUTPUT_1V8) {
+		err = rtsx_pci_write_register(pcr,
+				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_1v8);
+		if (err < 0)
+			return err;
+		val = (BPP_ASIC_2V0 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_1V8;
+	} else {
+		return -EINVAL;
+	}
+
+	return rtsx_pci_write_register(pcr, LDO_CTL, mask, val);
+}
+
 static unsigned int rtl8411_cd_deglitch(struct rtsx_pcr *pcr)
 {
 	unsigned int card_exist;
@@ -460,6 +485,10 @@ void rtl8411_init_params(struct rtsx_pcr *pcr)
 			set_pull_ctrl_tables(rtl8411b_qfn64);
 
 		break;
+	case 0x5286:
+		rtl8411_pcr_ops.switch_output_voltage =
+			rtl8402_switch_output_voltage;
+		break;
 	}
 
 	pcr->ops = &rtl8411_pcr_ops;
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index ecc6852..865d209 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -57,6 +57,7 @@ static DEFINE_PCI_DEVICE_TABLE(rtsx_pci_ids) = {
 	{ PCI_DEVICE(0x10EC, 0x5227), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5249), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5287), PCI_CLASS_OTHERS << 16, 0xFF0000 },
+	{ PCI_DEVICE(0x10EC, 0x5286), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ 0, }
 };
 
@@ -1056,6 +1057,7 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 
 	case 0x5287:
 	case 0x5289:
+	case 0x5286:
 		rtl8411_init_params(pcr);
 		break;
 	}
-- 
1.7.9.5

