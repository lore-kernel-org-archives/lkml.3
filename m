Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3KNJ3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:29:41 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:40508 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3KNJ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:29:36 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, micky_ching@realsil.com.cn
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/4] mfd: rtsx: Generify call-back operations in order to reduce code duplication
Date: Thu, 14 Nov 2013 09:29:12 +0000
Message-Id: <1384421355-4434-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384421355-4434-1-git-send-email-lee.jones@linaro.org>
References: <1384421355-4434-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With only a few variations between devices, it seems silly to keep bolting
on entirely new and mostly duplicated operation structs when a generic one
could be defined and the small differences could be handled in the init
functions.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/rtl8411.c        | 118 ++++++++++++++++++-------------------------
 include/linux/mfd/rtsx_pci.h |   2 +-
 2 files changed, 50 insertions(+), 70 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 5280135..92e9bf6 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -279,38 +279,6 @@ static int rtl8411_conv_clk_and_div_n(int input, int dir)
 	return output;
 }
 
-static const struct pcr_ops rtl8411_pcr_ops = {
-	.fetch_vendor_settings = rtl8411_fetch_vendor_settings,
-	.extra_init_hw = rtl8411_extra_init_hw,
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
@@ -441,60 +409,72 @@ static const u32 rtl8411b_qfn48_ms_pull_ctl_disable_tbl[] = {
 	0,
 };
 
-void rtl8411_init_params(struct rtsx_pcr *pcr)
+#define set_pull_ctrl_tables(__device) \
+	pcr->sd_pull_ctl_enable_tbl  = __device##_sd_pull_ctl_enable_tbl;  \
+	pcr->sd_pull_ctl_disable_tbl = __device##_sd_pull_ctl_disable_tbl; \
+	pcr->ms_pull_ctl_enable_tbl  = __device##_ms_pull_ctl_enable_tbl;  \
+	pcr->ms_pull_ctl_disable_tbl = __device##_ms_pull_ctl_disable_tbl;
+
+static struct pcr_ops rtl84xx_pcr_generic_ops = {
+	.fetch_vendor_settings = NULL, /* Dynamic */
+	.extra_init_hw = NULL,         /* Dynamic */
+	.optimize_phy = NULL,
+	.turn_on_led = rtl8411_turn_on_led,
+	.turn_off_led = rtl8411_turn_off_led,
+	.enable_auto_blink = rtl8411_enable_auto_blink,
+	.disable_auto_blink = rtl8411_disable_auto_blink,
+	.card_power_on = rtl8411_card_power_on,
+	.card_power_off = rtl8411_card_power_off,
+	.switch_output_voltage = rtl84xx_switch_output_voltage,
+	.cd_deglitch = rtl8411_cd_deglitch,
+	.conv_clk_and_div_n = rtl8411_conv_clk_and_div_n,
+	.force_power_down = rtl8411_force_power_down,
+};
+
+void rtl84xx_generic_params(struct rtsx_pcr *pcr)
 {
+	pcr->ops = &rtl84xx_pcr_generic_ops;
+
 	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
 	pcr->num_slots = 2;
-	pcr->ops = &rtl8411_pcr_ops;
 
 	pcr->flags = 0;
 	pcr->card_drive_sel = RTL8411_CARD_DRIVE_DEFAULT;
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
-	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
-	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
 
 	pcr->ic_version = rtl8411_get_ic_version(pcr);
-	pcr->sd_pull_ctl_enable_tbl = rtl8411_sd_pull_ctl_enable_tbl;
-	pcr->sd_pull_ctl_disable_tbl = rtl8411_sd_pull_ctl_disable_tbl;
-	pcr->ms_pull_ctl_enable_tbl = rtl8411_ms_pull_ctl_enable_tbl;
-	pcr->ms_pull_ctl_disable_tbl = rtl8411_ms_pull_ctl_disable_tbl;
+}
+
+void rtl8411_init_params(struct rtsx_pcr *pcr)
+{
+	/* Fill in common parameters. */
+	rtl84xx_generic_params(pcr);
+
+	/* Device Ops variation. */
+	pcr->ops->fetch_vendor_settings = rtl8411_fetch_vendor_settings;
+	pcr->ops->extra_init_hw = rtl8411_extra_init_hw;
+
+	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
+
+	set_pull_ctrl_tables(rtl8411);
 }
 
 void rtl8411b_init_params(struct rtsx_pcr *pcr)
 {
-	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
-	pcr->num_slots = 2;
-	pcr->ops = &rtl8411b_pcr_ops;
+	/* Fill in common parameters. */
+	rtl84xx_generic_params(pcr);
+
+	/* Device Ops variation. */
+	pcr->ops->fetch_vendor_settings = rtl8411b_fetch_vendor_settings;
+	pcr->ops->extra_init_hw = rtl8411b_extra_init_hw;
 
-	pcr->flags = 0;
-	pcr->card_drive_sel = RTL8411_CARD_DRIVE_DEFAULT;
-	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
-	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
-	pcr->aspm_en = ASPM_L1_EN;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
 
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
+		set_pull_ctrl_tables(rtl8411b_qfn48);
+	else
+		set_pull_ctrl_tables(rtl8411b_qfn64);
 }
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index d1382df..f5f3ffc 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -855,7 +855,7 @@ struct rtsx_pcr {
 	const u32			*ms_pull_ctl_enable_tbl;
 	const u32			*ms_pull_ctl_disable_tbl;
 
-	const struct pcr_ops		*ops;
+	struct pcr_ops			*ops;
 	enum PDEV_STAT			state;
 
 	int				num_slots;
-- 
1.8.1.2

