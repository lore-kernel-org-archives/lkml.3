Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3KNJaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:30:08 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46085 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3KNJ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:29:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, micky_ching@realsil.com.cn
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/4] mfd: rtsx: Add rtl8402 card reader
Date: Thu, 14 Nov 2013 09:29:14 +0000
Message-Id: <1384421355-4434-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384421355-4434-1-git-send-email-lee.jones@linaro.org>
References: <1384421355-4434-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the new card reader 'rtl8402' to the two already supported
by this driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/rtl8411.c  | 16 ++++++++++++++++
 drivers/mfd/rtsx_pcr.c |  5 +++++
 drivers/mfd/rtsx_pcr.h |  1 +
 3 files changed, 22 insertions(+)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 9bba4e2..0771796 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -482,3 +482,19 @@ void rtl8411b_init_params(struct rtsx_pcr *pcr)
 	else
 		set_pull_ctrl_tables(rtl8411b_qfn64);
 }
+
+void rtl8402_init_params(struct rtsx_pcr *pcr)
+{
+	/* Fill in common parameters. */
+	rtl84xx_generic_params(pcr);
+
+	/* Device Ops variation. */
+	pcr->ops->fetch_vendor_settings = rtl8411_fetch_vendor_settings;
+	pcr->ops->extra_init_hw = rtl8411_extra_init_hw;
+	pcr->ops->voltage_reg_shift = BPP_TUNED18_SHIFT_8402;
+
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
+	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
+
+	set_pull_ctrl_tables(rtl8411);
+}
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index f41ee8f..e5dbe67 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -56,6 +56,7 @@ static DEFINE_PCI_DEVICE_TABLE(rtsx_pci_ids) = {
 	{ PCI_DEVICE(0x10EC, 0x5289), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5227), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5249), PCI_CLASS_OTHERS << 16, 0xFF0000 },
+	{ PCI_DEVICE(0x10EC, 0x5286), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5287), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ 0, }
 };
@@ -1047,6 +1048,10 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 		rts5229_init_params(pcr);
 		break;
 
+	case 0x5286:
+		rtl8402_init_params(pcr);
+		break;
+
 	case 0x5289:
 		rtl8411_init_params(pcr);
 		break;
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index 947e79b..8cac8db 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -29,6 +29,7 @@
 
 void rts5209_init_params(struct rtsx_pcr *pcr);
 void rts5229_init_params(struct rtsx_pcr *pcr);
+void rtl8402_init_params(struct rtsx_pcr *pcr);
 void rtl8411_init_params(struct rtsx_pcr *pcr);
 void rts5227_init_params(struct rtsx_pcr *pcr);
 void rts5249_init_params(struct rtsx_pcr *pcr);
-- 
1.8.1.2

