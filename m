Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbaIRBha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 21:37:30 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53213 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbaIRBh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 21:37:29 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8I1ZwT2025495, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH] mfd: rtsx: fix PM suspend for 5227 & 5249
Date: Thu, 18 Sep 2014 09:35:56 +0800
Message-ID: <1411004156-9057-1-git-send-email-micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Fix rts5227&5249 failed send buffer cmd after suspend,
PM_CTRL3 should reset before send any buffer cmd after suspend.
Otherwise, buffer cmd will failed, this will lead resume fail.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rts5227.c        |   19 +++++++++++++++++++
 drivers/mfd/rts5249.c        |    4 ++++
 drivers/mfd/rtsx_pcr.h       |    1 +
 include/linux/mfd/rtsx_pci.h |   12 ++++++++++++
 4 files changed, 36 insertions(+)

diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index 9c8eec8..8222a31 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -128,8 +128,27 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 	return rtsx_pci_send_cmd(pcr, 100);
 }
 
+int rts5227_pm_reset(struct rtsx_pcr *pcr)
+{
+	int err;
+
+	/* init aspm */
+	err = rtsx_pci_update_cfg_byte(pcr, LCTLR, 0xFC, 0);
+	if (err < 0)
+		return err;
+
+	/* reset PM_CTRL3 before send buffer cmd */
+	return rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x00);
+}
+
 static int rts5227_optimize_phy(struct rtsx_pcr *pcr)
 {
+	int err;
+
+	err = rts5227_pm_reset(pcr);
+	if (err < 0)
+		return err;
+
 	/* Optimize RX sensitivity */
 	return rtsx_pci_write_phy_register(pcr, 0x00, 0xBA42);
 }
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 573de7b..0f1b0e6 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -130,6 +130,10 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
 {
 	int err;
 
+	err = rts5227_pm_reset(pcr);
+	if (err < 0)
+		return err;
+
 	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV,
 			PHY_REG_REV_RESV | PHY_REG_REV_RXIDLE_LATCHED |
 			PHY_REG_REV_P1_EN | PHY_REG_REV_RXIDLE_EN |
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index 07e4c2e..acc7a1e 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -72,4 +72,5 @@ do {									\
 	pcr->ms_pull_ctl_disable_tbl = __device##_ms_pull_ctl_disable_tbl; \
 } while (0)
 
+int rts5227_pm_reset(struct rtsx_pcr *pcr);
 #endif
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 74346d5..b34fec8 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -967,4 +967,16 @@ static inline u8 *rtsx_pci_get_cmd_data(struct rtsx_pcr *pcr)
 	return (u8 *)(pcr->host_cmds_ptr);
 }
 
+static inline int rtsx_pci_update_cfg_byte(struct rtsx_pcr *pcr, int addr,
+		u8 mask, u8 append)
+{
+	int err;
+	u8 val;
+
+	err = pci_read_config_byte(pcr->pci, addr, &val);
+	if (err < 0)
+		return err;
+	return pci_write_config_byte(pcr->pci, addr, (val & mask) | append);
+}
+
 #endif
-- 
1.7.9.5

