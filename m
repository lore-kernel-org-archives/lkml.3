Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3LCJYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:24:49 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33376 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3LCJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:24:43 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rB39OXFd010408, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wei_wang@realsil.com.cn>,
        <rogerable@realtek.com>, Micky Ching <micky_ching@realsil.com.cn>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 2/3] mfd: rtsx: add card reader rtl8402
Date: Tue, 3 Dec 2013 17:26:32 +0800
Message-ID: <39b168dd315f3b2645d92af29e5ad71789853317.1386051860.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1386051860.git.micky_ching@realsil.com.cn>
References: <cover.1386051860.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add card reader rtl8042, rtl8402 is much like rtl8411, so just add it to
rtl8411.c

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rtl8411.c  |   33 +++++++++++++++++++++++++++++++++
 drivers/mfd/rtsx_pcr.c |    5 +++++
 drivers/mfd/rtsx_pcr.h |    1 +
 3 files changed, 39 insertions(+)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index c9eab9d..4b377e3 100644
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
@@ -457,3 +482,11 @@ void rtl8411b_init_params(struct rtsx_pcr *pcr)
 	else
 		set_pull_ctrl_tables(rtl8411b_qfn64);
 }
+
+void rtl8402_init_params(struct rtsx_pcr *pcr)
+{
+	rtl8411_init_params(pcr);
+
+	rtl8411_pcr_ops.switch_output_voltage =
+		rtl8402_switch_output_voltage;
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

