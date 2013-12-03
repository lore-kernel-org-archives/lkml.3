Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3LCJYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:24:54 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33378 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3LCJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:24:43 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rB39OVfD010394, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wei_wang@realsil.com.cn>,
        <rogerable@realtek.com>, Micky Ching <micky_ching@realsil.com.cn>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 1/3] mfd: rtsx: reduce code duplication in rtl8411
Date: Tue, 3 Dec 2013 17:26:31 +0800
Message-ID: <4dbd7d35c3e2201a77357155f6610abda69a3139.1386051860.git.micky_ching@realsil.com.cn>
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

in order to remove duplicated code in rtl8411, we make 8411 as the base
init params, and other like-8411 chips will just change the different
value with 8411, this can save some source code.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rtl8411.c  |   63 +++++++++---------------------------------------
 drivers/mfd/rtsx_pcr.h |    8 ++++++
 2 files changed, 19 insertions(+), 52 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 5280135..c9eab9d 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -279,7 +279,7 @@ static int rtl8411_conv_clk_and_div_n(int input, int dir)
 	return output;
 }
 
-static const struct pcr_ops rtl8411_pcr_ops = {
+static struct pcr_ops rtl8411_pcr_ops = {
 	.fetch_vendor_settings = rtl8411_fetch_vendor_settings,
 	.extra_init_hw = rtl8411_extra_init_hw,
 	.optimize_phy = NULL,
@@ -295,22 +295,6 @@ static const struct pcr_ops rtl8411_pcr_ops = {
 	.force_power_down = rtl8411_force_power_down,
 };
 
-static const struct pcr_ops rtl8411b_pcr_ops = {
-	.fetch_vendor_settings = rtl8411b_fetch_vendor_settings,
-	.extra_init_hw = rtl8411b_extra_init_hw,
-	.optimize_phy = NULL,
-	.turn_on_led = rtl8411_turn_on_led,
-	.turn_off_led = rtl8411_turn_off_led,
-	.enable_auto_blink = rtl8411_enable_auto_blink,
-	.disable_auto_blink = rtl8411_disable_auto_blink,
-	.card_power_on = rtl8411_card_power_on,
-	.card_power_off = rtl8411_card_power_off,
-	.switch_output_voltage = rtl8411_switch_output_voltage,
-	.cd_deglitch = rtl8411_cd_deglitch,
-	.conv_clk_and_div_n = rtl8411_conv_clk_and_div_n,
-	.force_power_down = rtl8411_force_power_down,
-};
-
 /* SD Pull Control Enable:
  *     SD_DAT[3:0] ==> pull up
  *     SD_CD       ==> pull up
@@ -456,45 +440,20 @@ void rtl8411_init_params(struct rtsx_pcr *pcr)
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
 
 	pcr->ic_version = rtl8411_get_ic_version(pcr);
-	pcr->sd_pull_ctl_enable_tbl = rtl8411_sd_pull_ctl_enable_tbl;
-	pcr->sd_pull_ctl_disable_tbl = rtl8411_sd_pull_ctl_disable_tbl;
-	pcr->ms_pull_ctl_enable_tbl = rtl8411_ms_pull_ctl_enable_tbl;
-	pcr->ms_pull_ctl_disable_tbl = rtl8411_ms_pull_ctl_disable_tbl;
+
+	set_pull_ctrl_tables(rtl8411);
 }
 
 void rtl8411b_init_params(struct rtsx_pcr *pcr)
 {
-	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
-	pcr->num_slots = 2;
-	pcr->ops = &rtl8411b_pcr_ops;
-
-	pcr->flags = 0;
-	pcr->card_drive_sel = RTL8411_CARD_DRIVE_DEFAULT;
-	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
-	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
-	pcr->aspm_en = ASPM_L1_EN;
-	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
-	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
+	rtl8411_init_params(pcr);
 
-	pcr->ic_version = rtl8411_get_ic_version(pcr);
+	rtl8411_pcr_ops.fetch_vendor_settings =
+		rtl8411b_fetch_vendor_settings;
+	rtl8411_pcr_ops.extra_init_hw = rtl8411b_extra_init_hw;
 
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
+		set_pull_ctrl_tables(rtl8411b_qfn48);
+	else
+		set_pull_ctrl_tables(rtl8411b_qfn64);
 }
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index 947e79b..26b52ec 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -63,4 +63,12 @@ static inline u8 map_sd_drive(int idx)
 #define rtl8411_reg_to_sd30_drive_sel_3v3(reg)	(((reg) >> 5) & 0x07)
 #define rtl8411b_reg_to_sd30_drive_sel_3v3(reg)	((reg) & 0x03)
 
+#define set_pull_ctrl_tables(__device)				\
+do {								\
+	pcr->sd_pull_ctl_enable_tbl  = __device##_sd_pull_ctl_enable_tbl;  \
+	pcr->sd_pull_ctl_disable_tbl = __device##_sd_pull_ctl_disable_tbl; \
+	pcr->ms_pull_ctl_enable_tbl  = __device##_ms_pull_ctl_enable_tbl;  \
+	pcr->ms_pull_ctl_disable_tbl = __device##_ms_pull_ctl_disable_tbl; \
+} while (0)
+
 #endif
-- 
1.7.9.5

