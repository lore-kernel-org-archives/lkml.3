Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3LRCBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:01:19 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:58327 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3LRCBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:01:17 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rBI217Z4004453, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v4 1/2] mfd: rtsx: add set pull control macro and simplify rtl8411
Date: Wed, 18 Dec 2013 10:03:12 +0800
Message-ID: <af3355d221489601a865f70c45f27cb569c69ed3.1387331869.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1387331869.git.micky_ching@realsil.com.cn>
References: <cover.1387331869.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

add set pull control macro to reduce code for setting pull control, and
use a common init function to reduce code for rtl8411.c. So this patch
is used to just simplify code.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rtl8411.c  |   53 ++++++++++++------------------------------------
 drivers/mfd/rtsx_pcr.h |    8 ++++++++
 2 files changed, 21 insertions(+), 40 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 5280135..00ecf6b 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -441,12 +441,10 @@ static const u32 rtl8411b_qfn48_ms_pull_ctl_disable_tbl[] = {
 	0,
 };
 
-void rtl8411_init_params(struct rtsx_pcr *pcr)
+void rtl8411_init_common_params(struct rtsx_pcr *pcr)
 {
 	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
 	pcr->num_slots = 2;
-	pcr->ops = &rtl8411_pcr_ops;
-
 	pcr->flags = 0;
 	pcr->card_drive_sel = RTL8411_CARD_DRIVE_DEFAULT;
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
@@ -454,47 +452,22 @@ void rtl8411_init_params(struct rtsx_pcr *pcr)
 	pcr->aspm_en = ASPM_L1_EN;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
-
 	pcr->ic_version = rtl8411_get_ic_version(pcr);
-	pcr->sd_pull_ctl_enable_tbl = rtl8411_sd_pull_ctl_enable_tbl;
-	pcr->sd_pull_ctl_disable_tbl = rtl8411_sd_pull_ctl_disable_tbl;
-	pcr->ms_pull_ctl_enable_tbl = rtl8411_ms_pull_ctl_enable_tbl;
-	pcr->ms_pull_ctl_disable_tbl = rtl8411_ms_pull_ctl_disable_tbl;
+}
+
+void rtl8411_init_params(struct rtsx_pcr *pcr)
+{
+	rtl8411_init_common_params(pcr);
+	pcr->ops = &rtl8411_pcr_ops;
+	set_pull_ctrl_tables(pcr, rtl8411);
 }
 
 void rtl8411b_init_params(struct rtsx_pcr *pcr)
 {
-	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
-	pcr->num_slots = 2;
+	rtl8411_init_common_params(pcr);
 	pcr->ops = &rtl8411b_pcr_ops;
-
-	pcr->flags = 0;
-	pcr->card_drive_sel = RTL8411_CARD_DRIVE_DEFAULT;
-	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
-	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
-	pcr->aspm_en = ASPM_L1_EN;
-	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
-	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
-
-	pcr->ic_version = rtl8411_get_ic_version(pcr);
-
-	if (rtl8411b_is_qfn48(pcr)) {
-		pcr->sd_pull_ctl_enable_tbl =
-			rtl8411b_qfn48_sd_pull_ctl_enable_tbl;
-		pcr->sd_pull_ctl_disable_tbl =
-			rtl8411b_qfn48_sd_pull_ctl_disable_tbl;
-		pcr->ms_pull_ctl_enable_tbl =
-			rtl8411b_qfn48_ms_pull_ctl_enable_tbl;
-		pcr->ms_pull_ctl_disable_tbl =
-			rtl8411b_qfn48_ms_pull_ctl_disable_tbl;
-	} else {
-		pcr->sd_pull_ctl_enable_tbl =
-			rtl8411b_qfn64_sd_pull_ctl_enable_tbl;
-		pcr->sd_pull_ctl_disable_tbl =
-			rtl8411b_qfn64_sd_pull_ctl_disable_tbl;
-		pcr->ms_pull_ctl_enable_tbl =
-			rtl8411b_qfn64_ms_pull_ctl_enable_tbl;
-		pcr->ms_pull_ctl_disable_tbl =
-			rtl8411b_qfn64_ms_pull_ctl_disable_tbl;
-	}
+	if (rtl8411b_is_qfn48(pcr))
+		set_pull_ctrl_tables(pcr, rtl8411b_qfn48);
+	else
+		set_pull_ctrl_tables(pcr, rtl8411b_qfn64);
 }
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index 947e79b..e9feadb 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -63,4 +63,12 @@ static inline u8 map_sd_drive(int idx)
 #define rtl8411_reg_to_sd30_drive_sel_3v3(reg)	(((reg) >> 5) & 0x07)
 #define rtl8411b_reg_to_sd30_drive_sel_3v3(reg)	((reg) & 0x03)
 
+#define set_pull_ctrl_tables(pcr, __device)				\
+do {									\
+	pcr->sd_pull_ctl_enable_tbl  = __device##_sd_pull_ctl_enable_tbl;  \
+	pcr->sd_pull_ctl_disable_tbl = __device##_sd_pull_ctl_disable_tbl; \
+	pcr->ms_pull_ctl_enable_tbl  = __device##_ms_pull_ctl_enable_tbl;  \
+	pcr->ms_pull_ctl_disable_tbl = __device##_ms_pull_ctl_disable_tbl; \
+} while (0)
+
 #endif
-- 
1.7.9.5

