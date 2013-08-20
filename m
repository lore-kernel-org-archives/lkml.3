Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab3HTGWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:22:39 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:44297 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3HTGWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:22:37 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r7K6J2rm020212, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v3 5/6] mfd:rtsx: Configure to enter a deeper power-saving mode in S3
Date: Tue, 20 Aug 2013 14:18:55 +0800
Message-ID: <e3dd0ffb7eff30526ca401c72335e3dd91921216.1376978825.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1376978825.git.wei_wang@realsil.com.cn>
References: <cover.1376978825.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Set a bit to enable rts5227 and rts5249 to enter a deeper internal
power-saving mode in S3, and recover it after resuming.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtl8411.c        |    2 +-
 drivers/mfd/rts5209.c        |    2 +-
 drivers/mfd/rts5227.c        |    6 +++++-
 drivers/mfd/rts5229.c        |    2 +-
 drivers/mfd/rts5249.c        |    6 +++++-
 drivers/mfd/rtsx_pcr.c       |    2 +-
 include/linux/mfd/rtsx_pci.h |    2 +-
 7 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index d183fa0..37367fb 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -86,7 +86,7 @@ static void rtl8411b_fetch_vendor_settings(struct rtsx_pcr *pcr)
 		map_sd_drive(rtl8411b_reg_to_sd30_drive_sel_3v3(reg));
 }
 
-static void rtl8411_force_power_down(struct rtsx_pcr *pcr)
+static void rtl8411_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	rtsx_pci_write_register(pcr, FPDCTL, 0x07, 0x07);
 }
diff --git a/drivers/mfd/rts5209.c b/drivers/mfd/rts5209.c
index 03a15f7..ef6a59f 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -59,7 +59,7 @@ static void rts5209_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	}
 }
 
-static void rts5209_force_power_down(struct rtsx_pcr *pcr)
+static void rts5209_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	rtsx_pci_write_register(pcr, FPDCTL, 0x07, 0x07);
 }
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index 724ce4c5..c72abd6 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -83,13 +83,16 @@ static void rts5227_fetch_vendor_settings(struct rtsx_pcr *pcr)
 		pcr->flags |= PCR_REVERSE_SOCKET;
 }
 
-static void rts5227_force_power_down(struct rtsx_pcr *pcr)
+static void rts5227_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	/* Set relink_time to 0 */
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 1, 0xFF, 0);
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 2, 0xFF, 0);
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
 
+	if (pm_state == HOST_ENTER_S3)
+		rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x10);
+
 	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
 }
 
@@ -123,6 +126,7 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 	else
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
 				AUTOLOAD_CFG_BASE + 3, 0xB8, 0x88);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index e8261d7..afb0f24 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -56,7 +56,7 @@ static void rts5229_fetch_vendor_settings(struct rtsx_pcr *pcr)
 		map_sd_drive(rtsx_reg_to_sd30_drive_sel_3v3(reg));
 }
 
-static void rts5229_force_power_down(struct rtsx_pcr *pcr)
+static void rts5229_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
 }
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index c5e54d7..384b30b 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -88,13 +88,16 @@ static void rts5249_fetch_vendor_settings(struct rtsx_pcr *pcr)
 		pcr->flags |= PCR_REVERSE_SOCKET;
 }
 
-static void rts5249_force_power_down(struct rtsx_pcr *pcr)
+static void rts5249_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	/* Set relink_time to 0 */
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 1, 0xFF, 0);
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 2, 0xFF, 0);
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
 
+	if (pm_state == HOST_ENTER_S3)
+		rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x10);
+
 	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
 }
 
@@ -119,6 +122,7 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 	else
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
 				AUTOLOAD_CFG_BASE + 3, 0xB0, 0x80);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index ffd393c..29932a0 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -939,7 +939,7 @@ static void rtsx_pci_power_off(struct rtsx_pcr *pcr, u8 pm_state)
 	rtsx_pci_write_register(pcr, HOST_SLEEP_STATE, 0x03, pm_state);
 
 	if (pcr->ops->force_power_down)
-		pcr->ops->force_power_down(pcr);
+		pcr->ops->force_power_down(pcr, pm_state);
 }
 
 static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 9a16276..dd0bd58 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -779,7 +779,7 @@ struct pcr_ops {
 	unsigned int	(*cd_deglitch)(struct rtsx_pcr *pcr);
 	int		(*conv_clk_and_div_n)(int clk, int dir);
 	void		(*fetch_vendor_settings)(struct rtsx_pcr *pcr);
-	void		(*force_power_down)(struct rtsx_pcr *pcr);
+	void		(*force_power_down)(struct rtsx_pcr *pcr, u8 pm_state);
 };
 
 enum PDEV_STAT  {PDEV_STAT_IDLE, PDEV_STAT_RUN};
-- 
1.7.9.5

