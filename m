Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaIKHS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:18:59 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:33348 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaIKHS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:18:57 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8B7HuOo004708, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 1/2] mfd: rtsx: fix PM suspend for 5227
Date: Thu, 11 Sep 2014 15:17:52 +0800
Message-ID: <c13c93e9f5fca1a46df2b141899d50c13b28aaa0.1410330111.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1410330111.git.micky_ching@realsil.com.cn>
References: <cover.1410330111.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Fix rts5227 failed send buffer cmd after suspend,
PM_CTRL3 should reset before send any buffer cmd after suspend.
Otherwise, buffer cmd will failed, this will lead resume fail.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rts5227.c        |   23 +++++++++++++++++++++++
 include/linux/mfd/rtsx_pci.h |   13 +++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index 9c8eec8..3d4998e 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -128,8 +128,31 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 	return rtsx_pci_send_cmd(pcr, 100);
 }

+static int rts5227_pm_reset(struct rtsx_pcr *pcr)
+{
+	int err;
+
+	/* init aspm */
+	err = rtsx_pci_update_cfg_byte(pcr, LCTLR, 0xFC, 0);
+	if (err < 0)
+		return err;
+
+	/* reset PM_CTRL3 before send buffer cmd */
+	err = rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x00);
+	if (err < 0)
+		return err;
+
+	return err;
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
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 74346d5..037fbc5 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -967,4 +967,17 @@ static inline u8 *rtsx_pci_get_cmd_data(struct rtsx_pcr *pcr)
 	return (u8 *)(pcr->host_cmds_ptr);
 }

+static inline int rtsx_pci_update_cfg_byte(struct rtsx_pcr *pcr, int addr,
+		u8 mask, u8 append)
+{
+	int err;
+	u8 val;
+
+	err = pci_read_config_byte(pcr->pci, addr, &val);
+	if (err)
+		return err;
+	err = pci_write_config_byte(pcr->pci, addr, (val & mask) | append);
+	return err;
+}
+
 #endif
--
1.7.9.5
