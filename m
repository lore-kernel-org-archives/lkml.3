Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3KNJae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:30:34 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:45071 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab3KNJ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:29:38 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, micky_ching@realsil.com.cn
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/4] mfd: rtsx: Generify the switch voltage routine
Date: Thu, 14 Nov 2013 09:29:13 +0000
Message-Id: <1384421355-4434-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384421355-4434-1-git-send-email-lee.jones@linaro.org>
References: <1384421355-4434-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other, upcoming devices will want to change the shift value when using
the switch voltage call-back routine. In this patch we will ensure that
unnecessary code duplication shall not occur.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/rtl8411.c        | 12 ++++++++----
 drivers/mfd/rtsx_pcr.c       |  3 ++-
 include/linux/mfd/rtsx_pci.h |  3 ++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 92e9bf6..9bba4e2 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -191,24 +191,25 @@ static int rtl8411_card_power_off(struct rtsx_pcr *pcr, int card)
 			BPP_LDO_POWB, BPP_LDO_SUSPEND);
 }
 
-static int rtl8411_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
+static int rtl84xx_switch_output_voltage(struct rtsx_pcr *pcr,
+					 u8 voltage, int shift)
 {
 	u8 mask, val;
 	int err;
 
-	mask = (BPP_REG_TUNED18 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_MASK;
+	mask = (BPP_REG_TUNED18 << shift) | BPP_PAD_MASK;
 	if (voltage == OUTPUT_3V3) {
 		err = rtsx_pci_write_register(pcr,
 				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_3v3);
 		if (err < 0)
 			return err;
-		val = (BPP_ASIC_3V3 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_3V3;
+		val = (BPP_ASIC_3V3 << shift) | BPP_PAD_3V3;
 	} else if (voltage == OUTPUT_1V8) {
 		err = rtsx_pci_write_register(pcr,
 				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_1v8);
 		if (err < 0)
 			return err;
-		val = (BPP_ASIC_1V8 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_1V8;
+		val = (BPP_ASIC_1V8 << shift) | BPP_PAD_1V8;
 	} else {
 		return -EINVAL;
 	}
@@ -426,6 +427,7 @@ static struct pcr_ops rtl84xx_pcr_generic_ops = {
 	.card_power_on = rtl8411_card_power_on,
 	.card_power_off = rtl8411_card_power_off,
 	.switch_output_voltage = rtl84xx_switch_output_voltage,
+	.voltage_reg_shift = 0,        /* Dynamic */
 	.cd_deglitch = rtl8411_cd_deglitch,
 	.conv_clk_and_div_n = rtl8411_conv_clk_and_div_n,
 	.force_power_down = rtl8411_force_power_down,
@@ -455,6 +457,7 @@ void rtl8411_init_params(struct rtsx_pcr *pcr)
 	/* Device Ops variation. */
 	pcr->ops->fetch_vendor_settings = rtl8411_fetch_vendor_settings;
 	pcr->ops->extra_init_hw = rtl8411_extra_init_hw;
+	pcr->ops->voltage_reg_shift = BPP_TUNED18_SHIFT_8411;
 
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
 
@@ -469,6 +472,7 @@ void rtl8411b_init_params(struct rtsx_pcr *pcr)
 	/* Device Ops variation. */
 	pcr->ops->fetch_vendor_settings = rtl8411b_fetch_vendor_settings;
 	pcr->ops->extra_init_hw = rtl8411b_extra_init_hw;
+	pcr->ops->voltage_reg_shift = BPP_TUNED18_SHIFT_8411;
 
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
 	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index e6ae772..f41ee8f 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -734,7 +734,8 @@ EXPORT_SYMBOL_GPL(rtsx_pci_card_exclusive_check);
 int rtsx_pci_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 {
 	if (pcr->ops->switch_output_voltage)
-		return pcr->ops->switch_output_voltage(pcr, voltage);
+		return pcr->ops->switch_output_voltage(pcr, voltage,
+					pcr->ops->voltage_reg_shift);
 
 	return 0;
 }
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index f5f3ffc..5afc448 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -774,11 +774,12 @@ struct pcr_ops {
 	int		(*card_power_on)(struct rtsx_pcr *pcr, int card);
 	int		(*card_power_off)(struct rtsx_pcr *pcr, int card);
 	int		(*switch_output_voltage)(struct rtsx_pcr *pcr,
-						u8 voltage);
+						 u8 voltage, int shift);
 	unsigned int	(*cd_deglitch)(struct rtsx_pcr *pcr);
 	int		(*conv_clk_and_div_n)(int clk, int dir);
 	void		(*fetch_vendor_settings)(struct rtsx_pcr *pcr);
 	void		(*force_power_down)(struct rtsx_pcr *pcr, u8 pm_state);
+	int		voltage_reg_shift;
 };
 
 enum PDEV_STAT  {PDEV_STAT_IDLE, PDEV_STAT_RUN};
-- 
1.8.1.2

