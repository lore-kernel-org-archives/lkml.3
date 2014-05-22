Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaEVMsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:48:11 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:51698 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbaEVMsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:48:10 -0400
Message-ID: <1400762887.16407.4.camel@x220>
Subject: [PATCH] [media] dib0090: remove manual configuration system
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 22 May 2014 14:48:07 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2014 12:48:07.0647 (UTC) FILETIME=[149256F0:01CF75BC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dib0900.c has always shipped with its own, manual, configuration
system. There a three problems with it.

1) macros that are defined, but not used:
    CONFIG_SYS_DVBT
    CONFIG_DIB0090_USE_PWM_AGC

2) checks for macros that are always true:
    CONFIG_SYS_ISDBT
    CONFIG_BAND_CBAND
    CONFIG_BAND_VHF
    CONFIG_BAND_UHF

3) checks for macros that are never defined and are always false:
    CONFIG_BAND_SBAND
    CONFIG_STANDARD_DAB
    CONFIG_STANDARD_DVBT
    CONFIG_TUNER_DIB0090_P1B_SUPPORT
    CONFIG_BAND_LBAND

Remove all references to these macros, and, of course, remove the code
hidden behind the macros that are never defined too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested. I don't have the hardware.

1) This might be a bit hard to review. Should I split it in two or three
patches?

2) dib0070.c has a reference to CONFIG_SYS_ISDBT. I'll remove it in a
future patch.

3) If this gets accepted I might be inclined to clean up the coding
style in a future patch. It needs cleaning up quite a bit.

 drivers/media/dvb-frontends/dib0090.c | 130 ----------------------------------
 1 file changed, 130 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 3ee22ff76315..bb50fec4f475 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -46,13 +46,6 @@ MODULE_PARM_DESC(debug, "turn on debugging (default: 0)");
 	} \
 } while (0)
 
-#define CONFIG_SYS_DVBT
-#define CONFIG_SYS_ISDBT
-#define CONFIG_BAND_CBAND
-#define CONFIG_BAND_VHF
-#define CONFIG_BAND_UHF
-#define CONFIG_DIB0090_USE_PWM_AGC
-
 #define EN_LNA0      0x8000
 #define EN_LNA1      0x4000
 #define EN_LNA2      0x2000
@@ -1165,24 +1158,14 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 		state->agc_freeze = 0;
 		dib0090_write_reg(state, 0x04, 0x0);
 
-#ifdef CONFIG_BAND_SBAND
-		if (state->current_band == BAND_SBAND) {
-			dib0090_set_rframp(state, rf_ramp_sband);
-			dib0090_set_bbramp(state, bb_ramp_boost);
-		} else
-#endif
-#ifdef CONFIG_BAND_VHF
 		if (state->current_band == BAND_VHF && !state->identity.p1g) {
 			dib0090_set_rframp(state, rf_ramp_pwm_vhf);
 			dib0090_set_bbramp(state, bb_ramp_pwm_normal);
 		} else
-#endif
-#ifdef CONFIG_BAND_CBAND
 		if (state->current_band == BAND_CBAND && !state->identity.p1g) {
 			dib0090_set_rframp(state, rf_ramp_pwm_cband);
 			dib0090_set_bbramp(state, bb_ramp_pwm_normal);
 		} else
-#endif
 		if ((state->current_band == BAND_CBAND || state->current_band == BAND_VHF) && state->identity.p1g) {
 			dib0090_set_rframp(state, rf_ramp_pwm_cband_7090p);
 			dib0090_set_bbramp(state, bb_ramp_pwm_normal_socs);
@@ -1220,14 +1203,12 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 
 		if (*tune_state == CT_AGC_STEP_0) {
 			if (wbd_error < 0 && state->rf_gain_limit > 0 && !state->identity.p1g) {
-#ifdef CONFIG_BAND_CBAND
 				/* in case of CBAND tune reduce first the lt_gain2 before adjusting the RF gain */
 				u8 ltg2 = (state->rf_lt_def >> 10) & 0x7;
 				if (state->current_band == BAND_CBAND && ltg2) {
 					ltg2 >>= 1;
 					state->rf_lt_def &= ltg2 << 10;	/* reduce in 3 steps from 7 to 0 */
 				}
-#endif
 			} else {
 				state->agc_step = 0;
 				*tune_state = CT_AGC_STEP_1;
@@ -1238,16 +1219,6 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 			adc = (adc * ((s32) 355774) + (((s32) 1) << 20)) >> 21;	/* included in [0:-700] */
 
 			adc_error = (s16) (((s32) ADC_TARGET) - adc);
-#ifdef CONFIG_STANDARD_DAB
-			if (state->fe->dtv_property_cache.delivery_system == STANDARD_DAB)
-				adc_error -= 10;
-#endif
-#ifdef CONFIG_STANDARD_DVBT
-			if (state->fe->dtv_property_cache.delivery_system == STANDARD_DVBT &&
-					(state->fe->dtv_property_cache.modulation == QAM_64 || state->fe->dtv_property_cache.modulation == QAM_16))
-				adc_error += 60;
-#endif
-#ifdef CONFIG_SYS_ISDBT
 			if ((state->fe->dtv_property_cache.delivery_system == SYS_ISDBT) && (((state->fe->dtv_property_cache.layer[0].segment_count >
 								0)
 							&&
@@ -1274,17 +1245,9 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 						)
 				)
 				adc_error += 60;
-#endif
 
 			if (*tune_state == CT_AGC_STEP_1) {	/* quickly go to the correct range of the ADC power */
 				if (ABS(adc_error) < 50 || state->agc_step++ > 5) {
-
-#ifdef CONFIG_STANDARD_DAB
-					if (state->fe->dtv_property_cache.delivery_system == STANDARD_DAB) {
-						dib0090_write_reg(state, 0x02, (1 << 15) | (15 << 11) | (31 << 6) | (63));	/* cap value = 63 : narrow BB filter : Fc = 1.8MHz */
-						dib0090_write_reg(state, 0x04, 0x0);
-					} else
-#endif
 					{
 						dib0090_write_reg(state, 0x02, (1 << 15) | (3 << 11) | (6 << 6) | (32));
 						dib0090_write_reg(state, 0x04, 0x01);	/*0 = 1KHz ; 1 = 150Hz ; 2 = 50Hz ; 3 = 50KHz ; 4 = servo fast */
@@ -1554,11 +1517,6 @@ static int dib0090_reset(struct dvb_frontend *fe)
 	if (dib0090_identify(fe) < 0)
 		return -EIO;
 
-#ifdef CONFIG_TUNER_DIB0090_P1B_SUPPORT
-	if (!(state->identity.version & 0x1))	/* it is P1B - reset is already done */
-		return 0;
-#endif
-
 	if (!state->identity.in_soc) {
 		if ((dib0090_read_reg(state, 0x1a) >> 5) & 0x2)
 			dib0090_write_reg(state, 0x1b, (EN_IQADC | EN_BB | EN_BIAS | EN_DIGCLK | EN_PLL | EN_CRYSTAL));
@@ -1788,10 +1746,6 @@ static int dib0090_wbd_calibration(struct dib0090_state *state, enum frontend_tu
 			wbd_gain = wbd->wbd_gain;
 		else {
 			wbd_gain = 4;
-#if defined(CONFIG_BAND_LBAND) || defined(CONFIG_BAND_SBAND)
-			if ((state->current_band == BAND_LBAND) || (state->current_band == BAND_SBAND))
-				wbd_gain = 2;
-#endif
 		}
 
 		if (wbd_gain == state->wbd_calibration_gain) {	/* the WBD calibration has already been done */
@@ -1849,7 +1803,6 @@ static void dib0090_set_bandwidth(struct dib0090_state *state)
 }
 
 static const struct dib0090_pll dib0090_pll_table[] = {
-#ifdef CONFIG_BAND_CBAND
 	{56000, 0, 9, 48, 6},
 	{70000, 1, 9, 48, 6},
 	{87000, 0, 8, 32, 4},
@@ -1857,93 +1810,49 @@ static const struct dib0090_pll dib0090_pll_table[] = {
 	{115000, 0, 7, 24, 6},
 	{140000, 1, 7, 24, 6},
 	{170000, 0, 6, 16, 4},
-#endif
-#ifdef CONFIG_BAND_VHF
 	{200000, 1, 6, 16, 4},
 	{230000, 0, 5, 12, 6},
 	{280000, 1, 5, 12, 6},
 	{340000, 0, 4, 8, 4},
 	{380000, 1, 4, 8, 4},
 	{450000, 0, 3, 6, 6},
-#endif
-#ifdef CONFIG_BAND_UHF
 	{580000, 1, 3, 6, 6},
 	{700000, 0, 2, 4, 4},
 	{860000, 1, 2, 4, 4},
-#endif
-#ifdef CONFIG_BAND_LBAND
-	{1800000, 1, 0, 2, 4},
-#endif
-#ifdef CONFIG_BAND_SBAND
-	{2900000, 0, 14, 1, 4},
-#endif
 };
 
 static const struct dib0090_tuning dib0090_tuning_table_fm_vhf_on_cband[] = {
 
-#ifdef CONFIG_BAND_CBAND
 	{184000, 4, 1, 15, 0x280, 0x2912, 0xb94e, EN_CAB},
 	{227000, 4, 3, 15, 0x280, 0x2912, 0xb94e, EN_CAB},
 	{380000, 4, 7, 15, 0x280, 0x2912, 0xb94e, EN_CAB},
-#endif
-#ifdef CONFIG_BAND_UHF
 	{520000, 2, 0, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{550000, 2, 2, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{650000, 2, 3, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{750000, 2, 5, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{850000, 2, 6, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{900000, 2, 7, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
-#endif
-#ifdef CONFIG_BAND_LBAND
-	{1500000, 4, 0, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1600000, 4, 1, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1800000, 4, 3, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-#endif
-#ifdef CONFIG_BAND_SBAND
-	{2300000, 1, 4, 20, 0x300, 0x2d2A, 0x82c7, EN_SBD},
-	{2900000, 1, 7, 20, 0x280, 0x2deb, 0x8347, EN_SBD},
-#endif
 };
 
 static const struct dib0090_tuning dib0090_tuning_table[] = {
 
-#ifdef CONFIG_BAND_CBAND
 	{170000, 4, 1, 15, 0x280, 0x2912, 0xb94e, EN_CAB},
-#endif
-#ifdef CONFIG_BAND_VHF
 	{184000, 1, 1, 15, 0x300, 0x4d12, 0xb94e, EN_VHF},
 	{227000, 1, 3, 15, 0x300, 0x4d12, 0xb94e, EN_VHF},
 	{380000, 1, 7, 15, 0x300, 0x4d12, 0xb94e, EN_VHF},
-#endif
-#ifdef CONFIG_BAND_UHF
 	{520000, 2, 0, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{550000, 2, 2, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{650000, 2, 3, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{750000, 2, 5, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{850000, 2, 6, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{900000, 2, 7, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
-#endif
-#ifdef CONFIG_BAND_LBAND
-	{1500000, 4, 0, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1600000, 4, 1, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1800000, 4, 3, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-#endif
-#ifdef CONFIG_BAND_SBAND
-	{2300000, 1, 4, 20, 0x300, 0x2d2A, 0x82c7, EN_SBD},
-	{2900000, 1, 7, 20, 0x280, 0x2deb, 0x8347, EN_SBD},
-#endif
 };
 
 static const struct dib0090_tuning dib0090_p1g_tuning_table[] = {
-#ifdef CONFIG_BAND_CBAND
 	{170000, 4, 1, 0x820f, 0x300, 0x2d22, 0x82cb, EN_CAB},
-#endif
-#ifdef CONFIG_BAND_VHF
 	{184000, 1, 1, 15, 0x300, 0x4d12, 0xb94e, EN_VHF},
 	{227000, 1, 3, 15, 0x300, 0x4d12, 0xb94e, EN_VHF},
 	{380000, 1, 7, 15, 0x300, 0x4d12, 0xb94e, EN_VHF},
-#endif
-#ifdef CONFIG_BAND_UHF
 	{510000, 2, 0, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{540000, 2, 1, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{600000, 2, 3, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
@@ -1951,20 +1860,9 @@ static const struct dib0090_tuning dib0090_p1g_tuning_table[] = {
 	{680000, 2, 5, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{720000, 2, 6, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{900000, 2, 7, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
-#endif
-#ifdef CONFIG_BAND_LBAND
-	{1500000, 4, 0, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1600000, 4, 1, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1800000, 4, 3, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-#endif
-#ifdef CONFIG_BAND_SBAND
-	{2300000, 1, 4, 20, 0x300, 0x2d2A, 0x82c7, EN_SBD},
-	{2900000, 1, 7, 20, 0x280, 0x2deb, 0x8347, EN_SBD},
-#endif
 };
 
 static const struct dib0090_pll dib0090_p1g_pll_table[] = {
-#ifdef CONFIG_BAND_CBAND
 	{57000, 0, 11, 48, 6},
 	{70000, 1, 11, 48, 6},
 	{86000, 0, 10, 32, 4},
@@ -1972,71 +1870,43 @@ static const struct dib0090_pll dib0090_p1g_pll_table[] = {
 	{115000, 0, 9, 24, 6},
 	{140000, 1, 9, 24, 6},
 	{170000, 0, 8, 16, 4},
-#endif
-#ifdef CONFIG_BAND_VHF
 	{200000, 1, 8, 16, 4},
 	{230000, 0, 7, 12, 6},
 	{280000, 1, 7, 12, 6},
 	{340000, 0, 6, 8, 4},
 	{380000, 1, 6, 8, 4},
 	{455000, 0, 5, 6, 6},
-#endif
-#ifdef CONFIG_BAND_UHF
 	{580000, 1, 5, 6, 6},
 	{680000, 0, 4, 4, 4},
 	{860000, 1, 4, 4, 4},
-#endif
-#ifdef CONFIG_BAND_LBAND
-	{1800000, 1, 2, 2, 4},
-#endif
-#ifdef CONFIG_BAND_SBAND
-	{2900000, 0, 1, 1, 6},
-#endif
 };
 
 static const struct dib0090_tuning dib0090_p1g_tuning_table_fm_vhf_on_cband[] = {
-#ifdef CONFIG_BAND_CBAND
 	{184000, 4, 3, 0x4187, 0x2c0, 0x2d22, 0x81cb, EN_CAB},
 	{227000, 4, 3, 0x4187, 0x2c0, 0x2d22, 0x81cb, EN_CAB},
 	{380000, 4, 3, 0x4187, 0x2c0, 0x2d22, 0x81cb, EN_CAB},
-#endif
-#ifdef CONFIG_BAND_UHF
 	{520000, 2, 0, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{550000, 2, 2, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{650000, 2, 3, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{750000, 2, 5, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{850000, 2, 6, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{900000, 2, 7, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
-#endif
-#ifdef CONFIG_BAND_LBAND
-	{1500000, 4, 0, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1600000, 4, 1, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1800000, 4, 3, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-#endif
-#ifdef CONFIG_BAND_SBAND
-	{2300000, 1, 4, 20, 0x300, 0x2d2A, 0x82c7, EN_SBD},
-	{2900000, 1, 7, 20, 0x280, 0x2deb, 0x8347, EN_SBD},
-#endif
 };
 
 static const struct dib0090_tuning dib0090_tuning_table_cband_7090[] = {
-#ifdef CONFIG_BAND_CBAND
 	{300000, 4, 3, 0x018F, 0x2c0, 0x2d22, 0xb9ce, EN_CAB},
 	{380000, 4, 10, 0x018F, 0x2c0, 0x2d22, 0xb9ce, EN_CAB},
 	{570000, 4, 10, 0x8190, 0x2c0, 0x2d22, 0xb9ce, EN_CAB},
 	{858000, 4, 5, 0x8190, 0x2c0, 0x2d22, 0xb9ce, EN_CAB},
-#endif
 };
 
 static const struct dib0090_tuning dib0090_tuning_table_cband_7090e_sensitivity[] = {
-#ifdef CONFIG_BAND_CBAND
 	{ 300000,  0 ,  3,  0x8105, 0x2c0, 0x2d12, 0xb84e, EN_CAB },
 	{ 380000,  0 ,  10, 0x810F, 0x2c0, 0x2d12, 0xb84e, EN_CAB },
 	{ 600000,  0 ,  10, 0x815E, 0x280, 0x2d12, 0xb84e, EN_CAB },
 	{ 660000,  0 ,  5,  0x85E3, 0x280, 0x2d12, 0xb84e, EN_CAB },
 	{ 720000,  0 ,  5,  0x852E, 0x280, 0x2d12, 0xb84e, EN_CAB },
 	{ 860000,  0 ,  4,  0x85E5, 0x280, 0x2d12, 0xb84e, EN_CAB },
-#endif
 };
 
 int dib0090_update_tuning_table_7090(struct dvb_frontend *fe,
-- 
1.9.0

