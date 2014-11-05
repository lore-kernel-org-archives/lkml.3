Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaKEM6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:58:05 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:41564 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaKEM6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:58:01 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <1525007b8481e1bb2fd0ade1b746525b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Andy yan <andy.yan@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH V2 2/2] move imx-hdmi to bridge/dw-hdmi
Date: Wed,  5 Nov 2014 20:57:41 +0800
Message-Id: <1415192261-6487-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the original imx hdmi driver is under staging/imx-drm,
which depends on imx-drm, so move the imx hdmi drvier out
to drm/bridge and rename imx-hdmi to dw-hdmi

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
---
 drivers/gpu/drm/bridge/Kconfig                     |   5 +
 drivers/gpu/drm/bridge/Makefile                    |   1 +
 .../imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c}        | 292 ++++++++++-----------
 .../imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h}        |   0
 drivers/staging/imx-drm/Kconfig                    |   1 +
 drivers/staging/imx-drm/Makefile                   |   2 +-
 drivers/staging/imx-drm/dw_hdmi-imx.c              |  66 ++---
 include/drm/bridge/dw_hdmi.h                       |  26 +-
 8 files changed, 200 insertions(+), 193 deletions(-)
 rename drivers/{staging/imx-drm/imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c} (83%)
 rename drivers/{staging/imx-drm/imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h} (100%)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 884923f..26162ef 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -3,3 +3,8 @@ config DRM_PTN3460
 	depends on DRM
 	select DRM_KMS_HELPER
 	---help---
+
+config DRM_DW_HDMI
+	bool "Synopsys DesignWare High-Definition Multimedia Interface"
+	depends on DRM
+	select DRM_KMS_HELPER
diff --git a/drivers/gpu/drm/bridge/Makefile b/drivers/gpu/drm/bridge/Makefile
index b4733e1..d8a8cfd 100644
--- a/drivers/gpu/drm/bridge/Makefile
+++ b/drivers/gpu/drm/bridge/Makefile
@@ -1,3 +1,4 @@
 ccflags-y := -Iinclude/drm
 
 obj-$(CONFIG_DRM_PTN3460) += ptn3460.o
+obj-$(CONFIG_DRM_DW_HDMI) += dw_hdmi.o
diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
similarity index 83%
rename from drivers/staging/imx-drm/imx-hdmi.c
rename to drivers/gpu/drm/bridge/dw_hdmi.c
index 138706c..9c6aa88 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -25,7 +25,7 @@
 #include <drm/drm_encoder_slave.h>
 #include <drm/bridge/dw_hdmi.h>
 
-#include "imx-hdmi.h"
+#include "dw_hdmi.h"
 
 #define RGB			0
 #define YCBCR444		1
@@ -80,17 +80,17 @@ static const u16 csc_coeff_rgb_in_eitu709[3][4] = {
 /*On rockchip platform, no-word access to the hdmi
  * register will causes an imprecise external abort
  */
-static inline void hdmi_writel(struct imx_hdmi *hdmi, u32 val, int offset)
+static inline void hdmi_writel(struct dw_hdmi *hdmi, u32 val, int offset)
 {
 	writel(val, hdmi->regs + (offset << 2));
 }
 
-static inline u32 hdmi_readl(struct imx_hdmi *hdmi, int offset)
+static inline u32 hdmi_readl(struct dw_hdmi *hdmi, int offset)
 {
 	return readl(hdmi->regs + (offset << 2));
 }
 
-static void hdmi_modl(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
+static void hdmi_modl(struct dw_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
 {
 	u32 val = hdmi_readl(hdmi, reg) & ~mask;
 
@@ -98,23 +98,23 @@ static void hdmi_modl(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
 	hdmi_writel(hdmi, val, reg);
 }
 
-static void hdmi_mask_writel(struct imx_hdmi *hdmi, u32 data, unsigned int reg,
+static void hdmi_mask_writel(struct dw_hdmi *hdmi, u32 data, unsigned int reg,
 			     u32 shift, u32 mask)
 {
 	hdmi_modl(hdmi, data << shift, mask, reg);
 }
 
-static inline void hdmi_writeb(struct imx_hdmi *hdmi, u32 val, int offset)
+static inline void hdmi_writeb(struct dw_hdmi *hdmi, u32 val, int offset)
 {
 	writeb(val, hdmi->regs + offset);
 }
 
-static inline u32 hdmi_readb(struct imx_hdmi *hdmi, int offset)
+static inline u32 hdmi_readb(struct dw_hdmi *hdmi, int offset)
 {
 	return readb(hdmi->regs + offset);
 }
 
-static void hdmi_modb(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
+static void hdmi_modb(struct dw_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
 {
 	u8 val = hdmi_readb(hdmi, reg) & ~mask;
 
@@ -122,13 +122,13 @@ static void hdmi_modb(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
 	hdmi_writeb(hdmi, val, reg);
 }
 
-static void hdmi_mask_writeb(struct imx_hdmi *hdmi, u32 data, unsigned int reg,
+static void hdmi_mask_writeb(struct dw_hdmi *hdmi, u32 data, unsigned int reg,
 		      u32 shift, u32 mask)
 {
 	hdmi_modb(hdmi, data << shift, mask, reg);
 }
 
-static void hdmi_set_clock_regenerator_n(struct imx_hdmi *hdmi,
+static void hdmi_set_clock_regenerator_n(struct dw_hdmi *hdmi,
 					 unsigned int value)
 {
 	hdmi->write(hdmi, value & 0xff, HDMI_AUD_N1);
@@ -139,7 +139,7 @@ static void hdmi_set_clock_regenerator_n(struct imx_hdmi *hdmi,
 	hdmi->mod(hdmi, 0, HDMI_AUD_CTS3_N_SHIFT_MASK, HDMI_AUD_CTS3);
 }
 
-static void hdmi_regenerate_cts(struct imx_hdmi *hdmi, unsigned int cts)
+static void hdmi_regenerate_cts(struct dw_hdmi *hdmi, unsigned int cts)
 {
 	/* Must be set/cleared first */
 	hdmi->mod(hdmi, 0, HDMI_AUD_CTS3_CTS_MANUAL, HDMI_AUD_CTS3);
@@ -283,11 +283,11 @@ static unsigned int hdmi_compute_cts(unsigned int freq, unsigned long pixel_clk,
 	}
 	if (ratio == 100)
 		return cts;
-
-	return (cts * ratio) / 100;
+	else
+		return (cts * ratio) / 100;
 }
 
-static void hdmi_set_clk_regenerator(struct imx_hdmi *hdmi,
+static void hdmi_set_clk_regenerator(struct dw_hdmi *hdmi,
 	unsigned long pixel_clk)
 {
 	unsigned int clk_n, clk_cts;
@@ -311,12 +311,12 @@ static void hdmi_set_clk_regenerator(struct imx_hdmi *hdmi,
 	hdmi_regenerate_cts(hdmi, clk_cts);
 }
 
-static void hdmi_init_clk_regenerator(struct imx_hdmi *hdmi)
+static void hdmi_init_clk_regenerator(struct dw_hdmi *hdmi)
 {
 	hdmi_set_clk_regenerator(hdmi, 74250000);
 }
 
-static void hdmi_clk_regenerator_update_pixel_clock(struct imx_hdmi *hdmi)
+static void hdmi_clk_regenerator_update_pixel_clock(struct dw_hdmi *hdmi)
 {
 	hdmi_set_clk_regenerator(hdmi, hdmi->hdmi_data.video_mode.mpixelclock);
 }
@@ -328,7 +328,7 @@ static void hdmi_clk_regenerator_update_pixel_clock(struct imx_hdmi *hdmi)
  *			pin{31~24} <==> G[7:0]
  *			pin{15~8}  <==> B[7:0]
  */
-static void hdmi_video_sample(struct imx_hdmi *hdmi)
+static void hdmi_video_sample(struct dw_hdmi *hdmi)
 {
 	int color_format = 0;
 	u8 val;
@@ -384,12 +384,12 @@ static void hdmi_video_sample(struct imx_hdmi *hdmi)
 	hdmi->write(hdmi, 0x0, HDMI_TX_BCBDATA1);
 }
 
-static int is_color_space_conversion(struct imx_hdmi *hdmi)
+static int is_color_space_conversion(struct dw_hdmi *hdmi)
 {
 	return hdmi->hdmi_data.enc_in_format != hdmi->hdmi_data.enc_out_format;
 }
 
-static int is_color_space_decimation(struct imx_hdmi *hdmi)
+static int is_color_space_decimation(struct dw_hdmi *hdmi)
 {
 	if (hdmi->hdmi_data.enc_out_format != YCBCR422_8BITS)
 		return 0;
@@ -399,7 +399,7 @@ static int is_color_space_decimation(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static int is_color_space_interpolation(struct imx_hdmi *hdmi)
+static int is_color_space_interpolation(struct dw_hdmi *hdmi)
 {
 	if (hdmi->hdmi_data.enc_in_format != YCBCR422_8BITS)
 		return 0;
@@ -409,7 +409,7 @@ static int is_color_space_interpolation(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static void imx_hdmi_update_csc_coeffs(struct imx_hdmi *hdmi)
+static void dw_hdmi_update_csc_coeffs(struct dw_hdmi *hdmi)
 {
 	const u16 (*csc_coeff)[3][4] = &csc_coeff_default;
 	unsigned i;
@@ -452,7 +452,7 @@ static void imx_hdmi_update_csc_coeffs(struct imx_hdmi *hdmi)
 		  HDMI_CSC_SCALE);
 }
 
-static void hdmi_video_csc(struct imx_hdmi *hdmi)
+static void hdmi_video_csc(struct dw_hdmi *hdmi)
 {
 	int color_depth = 0;
 	int interpolation = HDMI_CSC_CFG_INTMODE_DISABLE;
@@ -480,7 +480,7 @@ static void hdmi_video_csc(struct imx_hdmi *hdmi)
 	hdmi->mod(hdmi, color_depth, HDMI_CSC_SCALE_CSC_COLORDE_PTH_MASK,
 		  HDMI_CSC_SCALE);
 
-	imx_hdmi_update_csc_coeffs(hdmi);
+	dw_hdmi_update_csc_coeffs(hdmi);
 }
 
 /*
@@ -488,7 +488,7 @@ static void hdmi_video_csc(struct imx_hdmi *hdmi)
  * for example, if input is YCC422 mode or repeater is used,
  * data should be repacked this module can be bypassed.
  */
-static void hdmi_video_packetize(struct imx_hdmi *hdmi)
+static void hdmi_video_packetize(struct dw_hdmi *hdmi)
 {
 	unsigned int color_depth = 0;
 	unsigned int remap_size = HDMI_VP_REMAP_YCC422_16bit;
@@ -585,40 +585,40 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
 		  HDMI_VP_CONF);
 }
 
-static inline void hdmi_phy_test_clear(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_clear(struct dw_hdmi *hdmi,
 						unsigned char bit)
 {
 	hdmi->mod(hdmi, bit << HDMI_PHY_TST0_TSTCLR_OFFSET,
 		  HDMI_PHY_TST0_TSTCLR_MASK, HDMI_PHY_TST0);
 }
 
-static inline void hdmi_phy_test_enable(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_enable(struct dw_hdmi *hdmi,
 						unsigned char bit)
 {
 	hdmi->mod(hdmi, bit << HDMI_PHY_TST0_TSTEN_OFFSET,
 		  HDMI_PHY_TST0_TSTEN_MASK, HDMI_PHY_TST0);
 }
 
-static inline void hdmi_phy_test_clock(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_clock(struct dw_hdmi *hdmi,
 						unsigned char bit)
 {
 	hdmi->mod(hdmi, bit << HDMI_PHY_TST0_TSTCLK_OFFSET,
 		  HDMI_PHY_TST0_TSTCLK_MASK, HDMI_PHY_TST0);
 }
 
-static inline void hdmi_phy_test_din(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_din(struct dw_hdmi *hdmi,
 						unsigned char bit)
 {
 	hdmi->write(hdmi, bit, HDMI_PHY_TST1);
 }
 
-static inline void hdmi_phy_test_dout(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_dout(struct dw_hdmi *hdmi,
 						unsigned char bit)
 {
 	hdmi->write(hdmi, bit, HDMI_PHY_TST2);
 }
 
-static bool hdmi_phy_wait_i2c_done(struct imx_hdmi *hdmi, int msec)
+static bool hdmi_phy_wait_i2c_done(struct dw_hdmi *hdmi, int msec)
 {
 	while ((hdmi->read(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
 		if (msec-- == 0)
@@ -628,7 +628,7 @@ static bool hdmi_phy_wait_i2c_done(struct imx_hdmi *hdmi, int msec)
 	return true;
 }
 
-static void __hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
+static void __hdmi_phy_i2c_write(struct dw_hdmi *hdmi, unsigned short data,
 			      unsigned char addr)
 {
 	hdmi->write(hdmi, 0xFF, HDMI_IH_I2CMPHY_STAT0);
@@ -642,56 +642,56 @@ static void __hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
 	hdmi_phy_wait_i2c_done(hdmi, 1000);
 }
 
-static int hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
+static int hdmi_phy_i2c_write(struct dw_hdmi *hdmi, unsigned short data,
 				     unsigned char addr)
 {
 	__hdmi_phy_i2c_write(hdmi, data, addr);
 	return 0;
 }
 
-static void imx_hdmi_phy_enable_power(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_enable_power(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_PDZ_OFFSET,
 			 HDMI_PHY_CONF0_PDZ_MASK);
 }
 
-static void imx_hdmi_phy_enable_tmds(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_enable_tmds(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_ENTMDS_OFFSET,
 			 HDMI_PHY_CONF0_ENTMDS_MASK);
 }
 
-static void imx_hdmi_phy_gen2_pddq(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_gen2_pddq(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_GEN2_PDDQ_OFFSET,
 			 HDMI_PHY_CONF0_GEN2_PDDQ_MASK);
 }
 
-static void imx_hdmi_phy_gen2_txpwron(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_gen2_txpwron(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_GEN2_TXPWRON_OFFSET,
 			 HDMI_PHY_CONF0_GEN2_TXPWRON_MASK);
 }
 
-static void imx_hdmi_phy_sel_data_en_pol(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_sel_data_en_pol(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_SELDATAENPOL_OFFSET,
 			 HDMI_PHY_CONF0_SELDATAENPOL_MASK);
 }
 
-static void imx_hdmi_phy_sel_interface_control(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_sel_interface_control(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi->mask_write(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_SELDIPIF_OFFSET,
 			 HDMI_PHY_CONF0_SELDIPIF_MASK);
 }
 
-static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
+static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
 			      unsigned char res, int cscon)
 {
 	unsigned res_idx, i;
@@ -726,10 +726,10 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	hdmi->write(hdmi, val, HDMI_MC_FLOWCTRL);
 
 	/* gen2 tx power off */
-	imx_hdmi_phy_gen2_txpwron(hdmi, 0);
+	dw_hdmi_phy_gen2_txpwron(hdmi, 0);
 
 	/* gen2 pddq */
-	imx_hdmi_phy_gen2_pddq(hdmi, 1);
+	dw_hdmi_phy_gen2_pddq(hdmi, 1);
 
 	/* PHY reset */
 	hdmi->write(hdmi, HDMI_MC_PHYRSTZ_DEASSERT, HDMI_MC_PHYRSTZ);
@@ -776,15 +776,15 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	/* REMOVE CLK TERM */
 	hdmi_phy_i2c_write(hdmi, 0x8000, 0x05);  /* CKCALCTRL */
 
-	imx_hdmi_phy_enable_power(hdmi, 1);
+	dw_hdmi_phy_enable_power(hdmi, 1);
 
 	/* toggle TMDS enable */
-	imx_hdmi_phy_enable_tmds(hdmi, 0);
-	imx_hdmi_phy_enable_tmds(hdmi, 1);
+	dw_hdmi_phy_enable_tmds(hdmi, 0);
+	dw_hdmi_phy_enable_tmds(hdmi, 1);
 
 	/* gen2 tx power on */
-	imx_hdmi_phy_gen2_txpwron(hdmi, 1);
-	imx_hdmi_phy_gen2_pddq(hdmi, 0);
+	dw_hdmi_phy_gen2_txpwron(hdmi, 1);
+	dw_hdmi_phy_gen2_pddq(hdmi, 0);
 
 	/*Wait for PHY PLL lock */
 	msec = 5;
@@ -805,7 +805,7 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	return 0;
 }
 
-static int imx_hdmi_phy_init(struct imx_hdmi *hdmi)
+static int dw_hdmi_phy_init(struct dw_hdmi *hdmi)
 {
 	int i, ret;
 	bool cscon = false;
@@ -816,10 +816,10 @@ static int imx_hdmi_phy_init(struct imx_hdmi *hdmi)
 
 	/* HDMI Phy spec says to do the phy initialization sequence twice */
 	for (i = 0; i < 2; i++) {
-		imx_hdmi_phy_sel_data_en_pol(hdmi, 1);
-		imx_hdmi_phy_sel_interface_control(hdmi, 0);
-		imx_hdmi_phy_enable_tmds(hdmi, 0);
-		imx_hdmi_phy_enable_power(hdmi, 0);
+		dw_hdmi_phy_sel_data_en_pol(hdmi, 1);
+		dw_hdmi_phy_sel_interface_control(hdmi, 0);
+		dw_hdmi_phy_enable_tmds(hdmi, 0);
+		dw_hdmi_phy_enable_power(hdmi, 0);
 
 		/* Enable CSC */
 		ret = hdmi_phy_configure(hdmi, 0, 8, cscon);
@@ -831,7 +831,7 @@ static int imx_hdmi_phy_init(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static void hdmi_tx_hdcp_config(struct imx_hdmi *hdmi)
+static void hdmi_tx_hdcp_config(struct dw_hdmi *hdmi)
 {
 	u8 de;
 
@@ -850,7 +850,7 @@ static void hdmi_tx_hdcp_config(struct imx_hdmi *hdmi)
 		  HDMI_A_HDCPCFG1_ENCRYPTIONDISABLE_MASK, HDMI_A_HDCPCFG1);
 }
 
-static void hdmi_config_AVI(struct imx_hdmi *hdmi)
+static void hdmi_config_AVI(struct dw_hdmi *hdmi)
 {
 	u8 val, pix_fmt, under_scan;
 	u8 act_ratio, coded_ratio, colorimetry, ext_colorimetry;
@@ -944,7 +944,7 @@ static void hdmi_config_AVI(struct imx_hdmi *hdmi)
 	hdmi->write(hdmi, 0, HDMI_FC_AVISRB1);
 }
 
-static void hdmi_av_composer(struct imx_hdmi *hdmi,
+static void hdmi_av_composer(struct dw_hdmi *hdmi,
 			     const struct drm_display_mode *mode)
 {
 	u8 inv_val;
@@ -1028,19 +1028,19 @@ static void hdmi_av_composer(struct imx_hdmi *hdmi,
 	hdmi->write(hdmi, vsync_len, HDMI_FC_VSYNCINWIDTH);
 }
 
-static void imx_hdmi_phy_disable(struct imx_hdmi *hdmi)
+static void dw_hdmi_phy_disable(struct dw_hdmi *hdmi)
 {
 	if (!hdmi->phy_enabled)
 		return;
 
-	imx_hdmi_phy_enable_tmds(hdmi, 0);
-	imx_hdmi_phy_enable_power(hdmi, 0);
+	dw_hdmi_phy_enable_tmds(hdmi, 0);
+	dw_hdmi_phy_enable_power(hdmi, 0);
 
 	hdmi->phy_enabled = false;
 }
 
 /* HDMI Initialization Step B.4 */
-static void imx_hdmi_enable_video_path(struct imx_hdmi *hdmi)
+static void dw_hdmi_enable_video_path(struct dw_hdmi *hdmi)
 {
 	u8 clkdis;
 
@@ -1069,13 +1069,13 @@ static void imx_hdmi_enable_video_path(struct imx_hdmi *hdmi)
 	}
 }
 
-static void hdmi_enable_audio_clk(struct imx_hdmi *hdmi)
+static void hdmi_enable_audio_clk(struct dw_hdmi *hdmi)
 {
 	hdmi->mod(hdmi, 0, HDMI_MC_CLKDIS_AUDCLK_DISABLE, HDMI_MC_CLKDIS);
 }
 
 /* Workaround to clear the overflow condition */
-static void imx_hdmi_clear_overflow(struct imx_hdmi *hdmi)
+static void dw_hdmi_clear_overflow(struct dw_hdmi *hdmi)
 {
 	int count;
 	u8 val;
@@ -1093,19 +1093,19 @@ static void imx_hdmi_clear_overflow(struct imx_hdmi *hdmi)
 		hdmi->write(hdmi, val, HDMI_FC_INVIDCONF);
 }
 
-static void hdmi_enable_overflow_interrupts(struct imx_hdmi *hdmi)
+static void hdmi_enable_overflow_interrupts(struct dw_hdmi *hdmi)
 {
 	hdmi->write(hdmi, 0, HDMI_FC_MASK2);
 	hdmi->write(hdmi, 0, HDMI_IH_MUTE_FC_STAT2);
 }
 
-static void hdmi_disable_overflow_interrupts(struct imx_hdmi *hdmi)
+static void hdmi_disable_overflow_interrupts(struct dw_hdmi *hdmi)
 {
 	hdmi->write(hdmi, HDMI_IH_MUTE_FC_STAT2_OVERFLOW_MASK,
 		    HDMI_IH_MUTE_FC_STAT2);
 }
 
-static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
+static int dw_hdmi_setup(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
 {
 	int ret;
 
@@ -1157,12 +1157,12 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 	hdmi_av_composer(hdmi, mode);
 
 	/* HDMI Initializateion Step B.2 */
-	ret = imx_hdmi_phy_init(hdmi);
+	ret = dw_hdmi_phy_init(hdmi);
 	if (ret)
 		return ret;
 
 	/* HDMI Initialization Step B.3 */
-	imx_hdmi_enable_video_path(hdmi);
+	dw_hdmi_enable_video_path(hdmi);
 
 	/* not for DVI mode */
 	if (hdmi->hdmi_data.video_mode.mdvi) {
@@ -1183,7 +1183,7 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 	hdmi_video_sample(hdmi);
 	hdmi_tx_hdcp_config(hdmi);
 
-	imx_hdmi_clear_overflow(hdmi);
+	dw_hdmi_clear_overflow(hdmi);
 	if (hdmi->cable_plugin && !hdmi->hdmi_data.video_mode.mdvi)
 		hdmi_enable_overflow_interrupts(hdmi);
 
@@ -1191,7 +1191,7 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 }
 
 /* Wait until we are registered to enable interrupts */
-static int imx_hdmi_fb_registered(struct imx_hdmi *hdmi)
+static int dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
 {
 	hdmi->write(hdmi, HDMI_PHY_I2CM_INT_ADDR_DONE_POL,
 		    HDMI_PHY_I2CM_INT_ADDR);
@@ -1209,7 +1209,7 @@ static int imx_hdmi_fb_registered(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static void initialize_hdmi_ih_mutes(struct imx_hdmi *hdmi)
+static void initialize_hdmi_ih_mutes(struct dw_hdmi *hdmi)
 {
 	u8 ih_mute;
 
@@ -1261,29 +1261,29 @@ static void initialize_hdmi_ih_mutes(struct imx_hdmi *hdmi)
 	hdmi->write(hdmi, ih_mute, HDMI_IH_MUTE);
 }
 
-static void imx_hdmi_poweron(struct imx_hdmi *hdmi)
+static void dw_hdmi_poweron(struct dw_hdmi *hdmi)
 {
-	imx_hdmi_setup(hdmi, &hdmi->previous_mode);
+	dw_hdmi_setup(hdmi, &hdmi->previous_mode);
 }
 
-static void imx_hdmi_poweroff(struct imx_hdmi *hdmi)
+static void dw_hdmi_poweroff(struct dw_hdmi *hdmi)
 {
-	imx_hdmi_phy_disable(hdmi);
+	dw_hdmi_phy_disable(hdmi);
 }
 
-static enum drm_connector_status imx_hdmi_connector_detect(struct drm_connector
+static enum drm_connector_status dw_hdmi_connector_detect(struct drm_connector
 							*connector, bool force)
 {
-	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
+	struct dw_hdmi *hdmi = container_of(connector, struct dw_hdmi,
 					     connector);
 
 	return hdmi->read(hdmi, HDMI_PHY_STAT0) & HDMI_PHY_HPD ?
 		connector_status_connected : connector_status_disconnected;
 }
 
-static int imx_hdmi_connector_get_modes(struct drm_connector *connector)
+static int dw_hdmi_connector_get_modes(struct drm_connector *connector)
 {
-	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
+	struct dw_hdmi *hdmi = container_of(connector, struct dw_hdmi,
 					     connector);
 	struct edid *edid;
 	int ret;
@@ -1306,114 +1306,113 @@ static int imx_hdmi_connector_get_modes(struct drm_connector *connector)
 	return 0;
 }
 
-static struct drm_encoder *imx_hdmi_connector_best_encoder(struct drm_connector
+static struct drm_encoder *dw_hdmi_connector_best_encoder(struct drm_connector
 							   *connector)
 {
-	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
+	struct dw_hdmi *hdmi = container_of(connector, struct dw_hdmi,
 					     connector);
 
 	return &hdmi->encoder;
 }
 
-static void imx_hdmi_encoder_mode_set(struct drm_encoder *encoder,
+static void dw_hdmi_encoder_mode_set(struct drm_encoder *encoder,
 			struct drm_display_mode *mode,
 			struct drm_display_mode *adjusted_mode)
 {
-	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
+	struct dw_hdmi *hdmi = container_of(encoder, struct dw_hdmi, encoder);
 
-	imx_hdmi_setup(hdmi, mode);
+	dw_hdmi_setup(hdmi, mode);
 
 	/* Store the display mode for plugin/DKMS poweron events */
 	memcpy(&hdmi->previous_mode, mode, sizeof(hdmi->previous_mode));
 }
 
-static bool imx_hdmi_encoder_mode_fixup(struct drm_encoder *encoder,
+static bool dw_hdmi_encoder_mode_fixup(struct drm_encoder *encoder,
 			const struct drm_display_mode *mode,
 			struct drm_display_mode *adjusted_mode)
 {
 	return true;
 }
 
-static void imx_hdmi_encoder_disable(struct drm_encoder *encoder)
+static void dw_hdmi_encoder_disable(struct drm_encoder *encoder)
 {
 }
 
-static void imx_hdmi_encoder_dpms(struct drm_encoder *encoder, int mode)
+static void dw_hdmi_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
-	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
+	struct dw_hdmi *hdmi = container_of(encoder, struct dw_hdmi, encoder);
 
 	if (mode)
-		imx_hdmi_poweroff(hdmi);
+		dw_hdmi_poweroff(hdmi);
 	else
-		imx_hdmi_poweron(hdmi);
+		dw_hdmi_poweron(hdmi);
 }
 
-static void imx_hdmi_encoder_prepare(struct drm_encoder *encoder)
+static void dw_hdmi_encoder_prepare(struct drm_encoder *encoder)
 {
-	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
-
-	imx_hdmi_poweroff(hdmi);
+	struct dw_hdmi *hdmi = container_of(encoder, struct dw_hdmi, encoder);
+	dw_hdmi_poweroff(hdmi);
 
 	if (hdmi->plat_data->encoder_prepare)
 		hdmi->plat_data->encoder_prepare(&hdmi->connector, encoder);
 }
 
-static void imx_hdmi_encoder_commit(struct drm_encoder *encoder)
+static void dw_hdmi_encoder_commit(struct drm_encoder *encoder)
 {
-	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
+	struct dw_hdmi *hdmi = container_of(encoder, struct dw_hdmi, encoder);
 
 	if (hdmi->plat_data->set_crtc_mux)
 		hdmi->plat_data->set_crtc_mux(hdmi->priv, encoder);
 
-	imx_hdmi_poweron(hdmi);
+	dw_hdmi_poweron(hdmi);
 }
 
-void imx_hdmi_connector_destroy(struct drm_connector *connector)
+void dw_hdmi_connector_destroy(struct drm_connector *connector)
 {
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
 }
 
-static int imx_hdmi_connector_mode_valid(struct drm_connector *connector,
+static int dw_hdmi_connector_mode_valid(struct drm_connector *connector,
 					 struct drm_display_mode *mode)
 {
-	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
+	struct dw_hdmi *hdmi = container_of(connector, struct dw_hdmi,
 					     connector);
 	if (hdmi->plat_data->mode_valid)
 		return hdmi->plat_data->mode_valid(connector, mode);
-
-	return MODE_OK;
+	else
+		return MODE_OK;
 }
 
-static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
+static struct drm_encoder_funcs dw_hdmi_encoder_funcs = {
 	.destroy = drm_encoder_cleanup,
 };
 
-static struct drm_encoder_helper_funcs imx_hdmi_encoder_helper_funcs = {
-	.dpms = imx_hdmi_encoder_dpms,
-	.prepare = imx_hdmi_encoder_prepare,
-	.commit = imx_hdmi_encoder_commit,
-	.mode_set = imx_hdmi_encoder_mode_set,
-	.mode_fixup = imx_hdmi_encoder_mode_fixup,
-	.disable = imx_hdmi_encoder_disable,
+static struct drm_encoder_helper_funcs dw_hdmi_encoder_helper_funcs = {
+	.dpms = dw_hdmi_encoder_dpms,
+	.prepare = dw_hdmi_encoder_prepare,
+	.commit = dw_hdmi_encoder_commit,
+	.mode_set = dw_hdmi_encoder_mode_set,
+	.mode_fixup = dw_hdmi_encoder_mode_fixup,
+	.disable = dw_hdmi_encoder_disable,
 };
 
-static struct drm_connector_funcs imx_hdmi_connector_funcs = {
+static struct drm_connector_funcs dw_hdmi_connector_funcs = {
 	.dpms = drm_helper_connector_dpms,
 	.fill_modes = drm_helper_probe_single_connector_modes,
-	.detect = imx_hdmi_connector_detect,
-	.destroy = imx_hdmi_connector_destroy,
+	.detect = dw_hdmi_connector_detect,
+	.destroy = dw_hdmi_connector_destroy,
 };
 
-static struct drm_connector_helper_funcs imx_hdmi_connector_helper_funcs = {
-	.get_modes = imx_hdmi_connector_get_modes,
-	.mode_valid = imx_hdmi_connector_mode_valid,
-	.best_encoder = imx_hdmi_connector_best_encoder,
+static struct drm_connector_helper_funcs dw_hdmi_connector_helper_funcs = {
+	.get_modes = dw_hdmi_connector_get_modes,
+	.mode_valid = dw_hdmi_connector_mode_valid,
+	.best_encoder = dw_hdmi_connector_best_encoder,
 };
 
-static irqreturn_t imx_hdmi_hardirq(int irq, void *dev_id)
+static irqreturn_t dw_hdmi_hardirq(int irq, void *dev_id)
 {
-	struct imx_hdmi *hdmi = dev_id;
+	struct dw_hdmi *hdmi = dev_id;
 	u8 intr_stat;
 
 	intr_stat = hdmi->read(hdmi, HDMI_IH_PHY_STAT0);
@@ -1423,9 +1422,9 @@ static irqreturn_t imx_hdmi_hardirq(int irq, void *dev_id)
 	return intr_stat ? IRQ_WAKE_THREAD : IRQ_NONE;
 }
 
-static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
+static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 {
-	struct imx_hdmi *hdmi = dev_id;
+	struct dw_hdmi *hdmi = dev_id;
 	u8 intr_stat;
 	u8 phy_int_pol;
 
@@ -1439,14 +1438,14 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 
 			hdmi->mod(hdmi, 0, HDMI_PHY_HPD, HDMI_PHY_POL0);
 
-			imx_hdmi_poweron(hdmi);
+			dw_hdmi_poweron(hdmi);
 		} else {
 			dev_dbg(hdmi->dev, "EVENT=plugout\n");
 
 			hdmi->mod(hdmi, HDMI_PHY_HPD, HDMI_PHY_HPD,
 				HDMI_PHY_POL0);
 
-			imx_hdmi_poweroff(hdmi);
+			dw_hdmi_poweroff(hdmi);
 		}
 		drm_helper_hpd_irq_event(hdmi->connector.dev);
 	}
@@ -1457,7 +1456,7 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
+static int dw_hdmi_register(struct drm_device *drm, struct dw_hdmi *hdmi)
 {
 	struct drm_encoder *encoder = &hdmi->encoder;
 	struct device *dev = hdmi->dev;
@@ -1466,13 +1465,13 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 
 	hdmi->connector.polled = DRM_CONNECTOR_POLL_HPD;
 
-	drm_encoder_helper_add(&hdmi->encoder, &imx_hdmi_encoder_helper_funcs);
-	drm_encoder_init(drm, &hdmi->encoder, &imx_hdmi_encoder_funcs,
+	drm_encoder_helper_add(&hdmi->encoder, &dw_hdmi_encoder_helper_funcs);
+	drm_encoder_init(drm, &hdmi->encoder, &dw_hdmi_encoder_funcs,
 			 DRM_MODE_ENCODER_TMDS);
 
 	drm_connector_helper_add(&hdmi->connector,
-				 &imx_hdmi_connector_helper_funcs);
-	drm_connector_init(drm, &hdmi->connector, &imx_hdmi_connector_funcs,
+				 &dw_hdmi_connector_helper_funcs);
+	drm_connector_init(drm, &hdmi->connector, &dw_hdmi_connector_funcs,
 			   DRM_MODE_CONNECTOR_HDMIA);
 
 	hdmi->connector.encoder = &hdmi->encoder;
@@ -1482,10 +1481,10 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
+static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct imx_hdmi *hdmi = platform_get_drvdata(pdev);
+	struct dw_hdmi *hdmi = platform_get_drvdata(pdev);
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
@@ -1533,8 +1532,8 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	if (irq < 0)
 		return irq;
 
-	ret = devm_request_threaded_irq(dev, irq, imx_hdmi_hardirq,
-					imx_hdmi_irq, IRQF_SHARED,
+	ret = devm_request_threaded_irq(dev, irq, dw_hdmi_hardirq,
+					dw_hdmi_irq, IRQF_SHARED,
 					dev_name(dev), hdmi);
 	if (ret)
 		return ret;
@@ -1571,11 +1570,11 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	/* Clear Hotplug interrupts */
 	hdmi->write(hdmi, HDMI_IH_PHY_STAT0_HPD, HDMI_IH_PHY_STAT0);
 
-	ret = imx_hdmi_fb_registered(hdmi);
+	ret = dw_hdmi_fb_registered(hdmi);
 	if (ret)
 		return ret;
 
-	ret = imx_hdmi_register(drm, hdmi);
+	ret = dw_hdmi_register(drm, hdmi);
 	if (ret)
 		return ret;
 
@@ -1587,15 +1586,16 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	return 0;
 }
 
-static void imx_hdmi_unbind(struct device *dev, struct device *master,
+static void dw_hdmi_unbind(struct device *dev, struct device *master,
 	void *data)
 {
-	struct imx_hdmi *hdmi = dev_get_drvdata(dev);
+	struct dw_hdmi *hdmi = dev_get_drvdata(dev);
 
 	/* Disable all interrupts */
 	hdmi->write(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
 
 	hdmi->connector.funcs->destroy(&hdmi->connector);
+
 	hdmi->encoder.funcs->destroy(&hdmi->encoder);
 	if (hdmi->plat_data->exit)
 		hdmi->plat_data->exit(hdmi->priv);
@@ -1603,25 +1603,25 @@ static void imx_hdmi_unbind(struct device *dev, struct device *master,
 }
 
 static const struct component_ops hdmi_ops = {
-	.bind	= imx_hdmi_bind,
-	.unbind	= imx_hdmi_unbind,
+	.bind	= dw_hdmi_bind,
+	.unbind	= dw_hdmi_unbind,
 };
 
-static int imx_hdmi_platform_probe(struct platform_device *pdev)
+static int dw_hdmi_platform_probe(struct platform_device *pdev)
 {
 	return component_add(&pdev->dev, &hdmi_ops);
 }
 
-static int imx_hdmi_platform_remove(struct platform_device *pdev)
+static int dw_hdmi_platform_remove(struct platform_device *pdev)
 {
 	component_del(&pdev->dev, &hdmi_ops);
 	return 0;
 }
 
-int imx_hdmi_pltfm_register(struct platform_device *pdev,
-			    const struct imx_hdmi_plat_data *plat_data)
+int dw_hdmi_pltfm_register(struct platform_device *pdev,
+			   const struct dw_hdmi_plat_data *plat_data)
 {
-	struct imx_hdmi *hdmi;
+	struct dw_hdmi *hdmi;
 
 	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi)
@@ -1635,17 +1635,17 @@ int imx_hdmi_pltfm_register(struct platform_device *pdev,
 
 	platform_set_drvdata(pdev, hdmi);
 
-	return imx_hdmi_platform_probe(pdev);
+	return dw_hdmi_platform_probe(pdev);
 }
-EXPORT_SYMBOL_GPL(imx_hdmi_pltfm_register);
+EXPORT_SYMBOL_GPL(dw_hdmi_pltfm_register);
 
-int imx_hdmi_pltfm_unregister(struct platform_device *pdev)
+int dw_hdmi_pltfm_unregister(struct platform_device *pdev)
 {
-	return imx_hdmi_platform_remove(pdev);
+	return dw_hdmi_platform_remove(pdev);
 }
-EXPORT_SYMBOL_GPL(imx_hdmi_pltfm_unregister);
+EXPORT_SYMBOL_GPL(dw_hdmi_pltfm_unregister);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_DESCRIPTION("i.MX6 HDMI transmitter driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:imx-hdmi");
+MODULE_ALIAS("platform:dw-hdmi");
diff --git a/drivers/staging/imx-drm/imx-hdmi.h b/drivers/gpu/drm/bridge/dw_hdmi.h
similarity index 100%
rename from drivers/staging/imx-drm/imx-hdmi.h
rename to drivers/gpu/drm/bridge/dw_hdmi.h
diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
index ab31848..560e1d3 100644
--- a/drivers/staging/imx-drm/Kconfig
+++ b/drivers/staging/imx-drm/Kconfig
@@ -50,5 +50,6 @@ config DRM_IMX_IPUV3
 config DRM_IMX_HDMI
 	tristate "Freescale i.MX DRM HDMI"
 	depends on DRM_IMX
+	select DRM_DW_HDMI
 	help
 	  Choose this if you want to use HDMI on i.MX6.
diff --git a/drivers/staging/imx-drm/Makefile b/drivers/staging/imx-drm/Makefile
index 809027d..f3ecd89 100644
--- a/drivers/staging/imx-drm/Makefile
+++ b/drivers/staging/imx-drm/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
 
 imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
 obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
-obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o dw_hdmi-imx.o
+obj-$(CONFIG_DRM_IMX_HDMI) += dw_hdmi-imx.o
diff --git a/drivers/staging/imx-drm/dw_hdmi-imx.c b/drivers/staging/imx-drm/dw_hdmi-imx.c
index 71ac859..fecbf73 100644
--- a/drivers/staging/imx-drm/dw_hdmi-imx.c
+++ b/drivers/staging/imx-drm/dw_hdmi-imx.c
@@ -14,7 +14,7 @@
 
 #include "imx-drm.h"
 
-struct imx_hdmi_priv {
+struct imx_hdmi {
 	struct device *dev;
 	struct clk *isfr_clk;
 	struct clk *iahb_clk;
@@ -66,7 +66,7 @@ static const struct curr_ctrl imx_cur_ctr[] = {
 	}
 };
 
-static int imx_hdmi_parse_dt(struct imx_hdmi_priv *hdmi)
+static int dw_hdmi_imx_parse_dt(struct imx_hdmi *hdmi)
 {
 	struct device_node *np = hdmi->dev->of_node;
 
@@ -91,9 +91,9 @@ static int imx_hdmi_parse_dt(struct imx_hdmi_priv *hdmi)
 	return 0;
 }
 
-static void *imx_hdmi_imx_setup(struct platform_device *pdev)
+static void *dw_hdmi_imx_setup(struct platform_device *pdev)
 {
-	struct imx_hdmi_priv *hdmi;
+	struct imx_hdmi *hdmi;
 	int ret;
 
 	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
@@ -101,7 +101,7 @@ static void *imx_hdmi_imx_setup(struct platform_device *pdev)
 		return ERR_PTR(-ENOMEM);
 	hdmi->dev = &pdev->dev;
 
-	ret = imx_hdmi_parse_dt(hdmi);
+	ret = dw_hdmi_imx_parse_dt(hdmi);
 	if (ret < 0)
 		return ERR_PTR(ret);
 	ret = clk_prepare_enable(hdmi->isfr_clk);
@@ -121,18 +121,18 @@ static void *imx_hdmi_imx_setup(struct platform_device *pdev)
 	return hdmi;
 }
 
-static void imx_hdmi_imx_exit(void *priv)
+static void dw_hdmi_imx_exit(void *priv)
 {
-	struct imx_hdmi_priv *hdmi = (struct imx_hdmi_priv *)priv;
+	struct imx_hdmi *hdmi = (struct imx_hdmi *)priv;
 
 	clk_disable_unprepare(hdmi->isfr_clk);
 
 	clk_disable_unprepare(hdmi->iahb_clk);
 }
 
-static void imx_hdmi_imx_set_crtc_mux(void *priv, struct drm_encoder *encoder)
+static void dw_hdmi_imx_set_crtc_mux(void *priv, struct drm_encoder *encoder)
 {
-	struct imx_hdmi_priv *hdmi = (struct imx_hdmi_priv *)priv;
+	struct imx_hdmi *hdmi = (struct imx_hdmi *)priv;
 	int mux = imx_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
 
 	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
@@ -140,33 +140,33 @@ static void imx_hdmi_imx_set_crtc_mux(void *priv, struct drm_encoder *encoder)
 			   mux << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
 }
 
-static void imx_hdmi_imx_encoder_prepare(struct drm_connector *connector,
+static void dw_hdmi_imx_encoder_prepare(struct drm_connector *connector,
 					struct drm_encoder *encoder)
 {
 	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
 }
 
-static struct imx_hdmi_plat_data imx6q_hdmi_drv_data = {
-	.setup			= imx_hdmi_imx_setup,
-	.exit			= imx_hdmi_imx_exit,
-	.set_crtc_mux		= imx_hdmi_imx_set_crtc_mux,
-	.encoder_prepare	= imx_hdmi_imx_encoder_prepare,
+static struct dw_hdmi_plat_data imx6q_hdmi_drv_data = {
+	.setup			= dw_hdmi_imx_setup,
+	.exit			= dw_hdmi_imx_exit,
+	.set_crtc_mux		= dw_hdmi_imx_set_crtc_mux,
+	.encoder_prepare	= dw_hdmi_imx_encoder_prepare,
 	.mpll_cfg		= imx_mpll_cfg,
 	.cur_ctr		= imx_cur_ctr,
 	.dev_type		= IMX6Q_HDMI,
 };
 
-static struct imx_hdmi_plat_data imx6dl_hdmi_drv_data = {
-	.setup			= imx_hdmi_imx_setup,
-	.exit			= imx_hdmi_imx_exit,
-	.set_crtc_mux		= imx_hdmi_imx_set_crtc_mux,
-	.encoder_prepare	= imx_hdmi_imx_encoder_prepare,
+static struct dw_hdmi_plat_data imx6dl_hdmi_drv_data = {
+	.setup			= dw_hdmi_imx_setup,
+	.exit			= dw_hdmi_imx_exit,
+	.set_crtc_mux		= dw_hdmi_imx_set_crtc_mux,
+	.encoder_prepare	= dw_hdmi_imx_encoder_prepare,
 	.mpll_cfg		= imx_mpll_cfg,
 	.cur_ctr		= imx_cur_ctr,
 	.dev_type		= IMX6DL_HDMI,
 };
 
-static const struct of_device_id imx_hdmi_imx_ids[] = {
+static const struct of_device_id dw_hdmi_imx_ids[] = {
 	{ .compatible = "fsl,imx6q-hdmi",
 	  .data = &imx6q_hdmi_drv_data
 	}, {
@@ -175,38 +175,38 @@ static const struct of_device_id imx_hdmi_imx_ids[] = {
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(of, imx_hdmi_imx_dt_ids);
+MODULE_DEVICE_TABLE(of, dw_hdmi_imx_dt_ids);
 
-static int imx_hdmi_imx_probe(struct platform_device *pdev)
+static int dw_hdmi_imx_probe(struct platform_device *pdev)
 {
-	const struct imx_hdmi_plat_data *plat_data;
+	const struct dw_hdmi_plat_data *plat_data;
 	const struct of_device_id *match;
 
 	if (!pdev->dev.of_node)
 		return -ENODEV;
 
-	match = of_match_node(imx_hdmi_imx_ids, pdev->dev.of_node);
+	match = of_match_node(dw_hdmi_imx_ids, pdev->dev.of_node);
 	plat_data = match->data;
 
-	return imx_hdmi_pltfm_register(pdev, plat_data);
+	return dw_hdmi_pltfm_register(pdev, plat_data);
 }
 
-static int imx_hdmi_imx_remove(struct platform_device *pdev)
+static int dw_hdmi_imx_remove(struct platform_device *pdev)
 {
-	return imx_hdmi_pltfm_unregister(pdev);
+	return dw_hdmi_pltfm_unregister(pdev);
 }
 
-static struct platform_driver imx_hdmi_imx_pltfm_driver = {
-	.probe  = imx_hdmi_imx_probe,
-	.remove = imx_hdmi_imx_remove,
+static struct platform_driver dw_hdmi_imx_pltfm_driver = {
+	.probe  = dw_hdmi_imx_probe,
+	.remove = dw_hdmi_imx_remove,
 	.driver = {
 		.name = "dwhdmi-imx",
 		.owner = THIS_MODULE,
-		.of_match_table = imx_hdmi_imx_ids,
+		.of_match_table = dw_hdmi_imx_ids,
 	},
 };
 
-module_platform_driver(imx_hdmi_imx_pltfm_driver);
+module_platform_driver(dw_hdmi_imx_pltfm_driver);
 
 MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
 MODULE_DESCRIPTION("IMX6 Specific DW-HDMI Driver Extension");
diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
index e7e8285..514f82b 100644
--- a/include/drm/bridge/dw_hdmi.h
+++ b/include/drm/bridge/dw_hdmi.h
@@ -21,7 +21,7 @@ enum {
 	RES_MAX,
 };
 
-enum imx_hdmi_devtype {
+enum dw_hdmi_devtype {
 	IMX6Q_HDMI,
 	IMX6DL_HDMI,
 };
@@ -62,15 +62,15 @@ struct hdmi_data_info {
 };
 
 
-struct imx_hdmi {
+struct dw_hdmi {
 	struct drm_connector connector;
 	struct drm_encoder encoder;
 
-	enum imx_hdmi_devtype dev_type;
+	enum dw_hdmi_devtype dev_type;
 	struct device *dev;
 
 	struct hdmi_data_info hdmi_data;
-	const struct imx_hdmi_plat_data *plat_data;
+	const struct dw_hdmi_plat_data *plat_data;
 	void *priv;
 
 	int vic;
@@ -87,14 +87,14 @@ struct imx_hdmi {
 	unsigned int sample_rate;
 	int ratio;
 
-	void (*write)(struct imx_hdmi *hdmi, u32 val, int offset);
-	u32 (*read)(struct imx_hdmi *hdmi, int offset);
-	void (*mod)(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg);
-	void (*mask_write)(struct imx_hdmi *hdmi, u32 data, unsigned int reg,
+	void (*write)(struct dw_hdmi *hdmi, u32 val, int offset);
+	u32 (*read)(struct dw_hdmi *hdmi, int offset);
+	void (*mod)(struct dw_hdmi *hdmi, u32 data, u32 mask, unsigned reg);
+	void (*mask_write)(struct dw_hdmi *hdmi, u32 data, unsigned int reg,
 			      u32 shift, u32 mask);
 };
 
-struct imx_hdmi_plat_data {
+struct dw_hdmi_plat_data {
 	void * (*setup)(struct platform_device *pdev);
 	void (*exit)(void *priv);
 	void (*set_crtc_mux)(void *priv, struct drm_encoder *encoder);
@@ -104,11 +104,11 @@ struct imx_hdmi_plat_data {
 					   struct drm_display_mode *mode);
 	const struct mpll_config *mpll_cfg;
 	const struct curr_ctrl *cur_ctr;
-	enum imx_hdmi_devtype dev_type;
+	enum dw_hdmi_devtype dev_type;
 
 };
 
-int imx_hdmi_pltfm_register(struct platform_device *pdev,
-			    const struct imx_hdmi_plat_data *plat_data);
-int imx_hdmi_pltfm_unregister(struct platform_device *pdev);
+int dw_hdmi_pltfm_register(struct platform_device *pdev,
+			    const struct dw_hdmi_plat_data *plat_data);
+int dw_hdmi_pltfm_unregister(struct platform_device *pdev);
 #endif /* __IMX_HDMI_H__ */
-- 
1.9.1


