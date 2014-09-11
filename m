Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaIKHs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:48:29 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:44287 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaIKHsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:48:06 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8B7I2wL005010, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 2/2] mfd: rtsx: fix PM suspend for 5249
Date: Thu, 11 Sep 2014 15:17:53 +0800
Message-ID: <75cf0554bef8d9c07c6a4137daf1d78e11e12eaf.1410330111.git.micky_ching@realsil.com.cn>
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

Fix rts5249 failed send buffer cmd after suspend,
PM_CTRL3 should reset before send any buffer cmd after suspend.
Otherwise, buffer cmd will failed, this will lead resume fail.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rts5249.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 573de7b..d6cc546 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -126,10 +126,31 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 	return rtsx_pci_send_cmd(pcr, 100);
 }

+static int rts5249_pm_reset(struct rtsx_pcr *pcr)
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
 static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
 {
 	int err;

+	err = rts5249_pm_reset(pcr);
+	if (err < 0)
+		return err;
+
 	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV,
 			PHY_REG_REV_RESV | PHY_REG_REV_RXIDLE_LATCHED |
 			PHY_REG_REV_P1_EN | PHY_REG_REV_RXIDLE_EN |
--
1.7.9.5
