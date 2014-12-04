Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaLDKFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:05:42 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:47882 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaLDKFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:05:39 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <a4d0615288624fe59e8d3250a572f715>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, Philipp Zabel <p.zabel@pengutronix.de>, heiko@sntech.de,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com,
        Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v17 05/12] drm: imx: imx-hdmi: move imx-hdmi to bridge/dw_hdmi
Date: Thu,  4 Dec 2014 18:05:07 +0800
Message-Id: <1417687507-13155-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
References: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the original imx hdmi driver is under drm/imx/,
which depends on imx-drm, so move the imx hdmi
driver out to drm/bridge and rename it to dw_hdmi

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v17:
- remove prompt message of dw_hdmi, adviced by Russel King

Changes in v16: None
Changes in v15:
- add prefix dw_hdmi/DW_HDMI for public used dw_hdmi structs
  adviced by Philipp Zabel
- remove THIS_MODULE in platform driver

Changes in v14: None
Changes in v13: None
Changes in v12: None
Changes in v11: None
Changes in v10: None
Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None

 drivers/gpu/drm/bridge/Kconfig                     |   5 +
 drivers/gpu/drm/bridge/Makefile                    |   1 +
 .../gpu/drm/{imx/imx-hdmi.c => bridge/dw_hdmi.c}   | 278 +++++++++++----------
 .../gpu/drm/{imx/imx-hdmi.h => bridge/dw_hdmi.h}   |  43 ----
 drivers/gpu/drm/imx/Kconfig                        |   1 +
 drivers/gpu/drm/imx/Makefile                       |   2 +-
 .../drm/imx/{imx-hdmi_pltfm.c => dw_hdmi-imx.c}    | 127 +++++-----
 include/drm/bridge/dw_hdmi.h                       |  60 +++++
 8 files changed, 270 insertions(+), 247 deletions(-)
 rename drivers/gpu/drm/{imx/imx-hdmi.c => bridge/dw_hdmi.c} (84%)
 rename drivers/gpu/drm/{imx/imx-hdmi.h => bridge/dw_hdmi.h} (98%)
 rename drivers/gpu/drm/imx/{imx-hdmi_pltfm.c => dw_hdmi-imx.c} (55%)
 create mode 100644 include/drm/bridge/dw_hdmi.h

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 884923f..4d822f0 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -3,3 +3,8 @@ config DRM_PTN3460
 	depends on DRM
 	select DRM_KMS_HELPER
 	---help---
+
+config DRM_DW_HDMI
+	bool
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
diff --git a/drivers/gpu/drm/imx/imx-hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
similarity index 84%
rename from drivers/gpu/drm/imx/imx-hdmi.c
rename to drivers/gpu/drm/bridge/dw_hdmi.c
index 72358144..b69057d 100644
--- a/drivers/gpu/drm/imx/imx-hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -6,12 +6,11 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
- * SH-Mobile High-Definition Multimedia Interface (HDMI) driver
- * for SLISHDMI13T and SLIPHDMIT IP cores
+ * Designware High-Definition Multimedia Interface (HDMI) driver
  *
  * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
  */
-
+#include <linux/module.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
 #include <linux/err.h>
@@ -24,8 +23,9 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_encoder_slave.h>
+#include <drm/bridge/dw_hdmi.h>
 
-#include "imx-hdmi.h"
+#include "dw_hdmi.h"
 
 #define HDMI_EDID_LEN		512
 
@@ -101,18 +101,19 @@ struct hdmi_data_info {
 	struct hdmi_vmode video_mode;
 };
 
-struct imx_hdmi {
+struct dw_hdmi {
 	struct drm_connector connector;
 	struct drm_encoder *encoder;
 	struct drm_bridge *bridge;
 
-	enum imx_hdmi_devtype dev_type;
+	enum dw_hdmi_devtype dev_type;
 	struct device *dev;
 	struct clk *isfr_clk;
 	struct clk *iahb_clk;
 
 	struct hdmi_data_info hdmi_data;
-	const struct imx_hdmi_plat_data *plat_data;
+	const struct dw_hdmi_plat_data *plat_data;
+
 	int vic;
 
 	u8 edid[HDMI_EDID_LEN];
@@ -129,17 +130,17 @@ struct imx_hdmi {
 	int ratio;
 };
 
-static inline void hdmi_writeb(struct imx_hdmi *hdmi, u8 val, int offset)
+static inline void hdmi_writeb(struct dw_hdmi *hdmi, u8 val, int offset)
 {
 	writeb(val, hdmi->regs + offset);
 }
 
-static inline u8 hdmi_readb(struct imx_hdmi *hdmi, int offset)
+static inline u8 hdmi_readb(struct dw_hdmi *hdmi, int offset)
 {
 	return readb(hdmi->regs + offset);
 }
 
-static void hdmi_modb(struct imx_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
+static void hdmi_modb(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
 {
 	u8 val = hdmi_readb(hdmi, reg) & ~mask;
 
@@ -147,13 +148,13 @@ static void hdmi_modb(struct imx_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
 	hdmi_writeb(hdmi, val, reg);
 }
 
-static void hdmi_mask_writeb(struct imx_hdmi *hdmi, u8 data, unsigned int reg,
+static void hdmi_mask_writeb(struct dw_hdmi *hdmi, u8 data, unsigned int reg,
 			     u8 shift, u8 mask)
 {
 	hdmi_modb(hdmi, data << shift, mask, reg);
 }
 
-static void hdmi_set_clock_regenerator_n(struct imx_hdmi *hdmi,
+static void hdmi_set_clock_regenerator_n(struct dw_hdmi *hdmi,
 					 unsigned int value)
 {
 	hdmi_writeb(hdmi, value & 0xff, HDMI_AUD_N1);
@@ -164,7 +165,7 @@ static void hdmi_set_clock_regenerator_n(struct imx_hdmi *hdmi,
 	hdmi_modb(hdmi, 0, HDMI_AUD_CTS3_N_SHIFT_MASK, HDMI_AUD_CTS3);
 }
 
-static void hdmi_regenerate_cts(struct imx_hdmi *hdmi, unsigned int cts)
+static void hdmi_regenerate_cts(struct dw_hdmi *hdmi, unsigned int cts)
 {
 	/* Must be set/cleared first */
 	hdmi_modb(hdmi, 0, HDMI_AUD_CTS3_CTS_MANUAL, HDMI_AUD_CTS3);
@@ -311,7 +312,7 @@ static unsigned int hdmi_compute_cts(unsigned int freq, unsigned long pixel_clk,
 	return (cts * ratio) / 100;
 }
 
-static void hdmi_set_clk_regenerator(struct imx_hdmi *hdmi,
+static void hdmi_set_clk_regenerator(struct dw_hdmi *hdmi,
 				     unsigned long pixel_clk)
 {
 	unsigned int clk_n, clk_cts;
@@ -335,12 +336,12 @@ static void hdmi_set_clk_regenerator(struct imx_hdmi *hdmi,
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
@@ -352,7 +353,7 @@ static void hdmi_clk_regenerator_update_pixel_clock(struct imx_hdmi *hdmi)
  *			pin{31~24} <==> G[7:0]
  *			pin{15~8}  <==> B[7:0]
  */
-static void hdmi_video_sample(struct imx_hdmi *hdmi)
+static void hdmi_video_sample(struct dw_hdmi *hdmi)
 {
 	int color_format = 0;
 	u8 val;
@@ -408,12 +409,12 @@ static void hdmi_video_sample(struct imx_hdmi *hdmi)
 	hdmi_writeb(hdmi, 0x0, HDMI_TX_BCBDATA1);
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
@@ -423,7 +424,7 @@ static int is_color_space_decimation(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static int is_color_space_interpolation(struct imx_hdmi *hdmi)
+static int is_color_space_interpolation(struct dw_hdmi *hdmi)
 {
 	if (hdmi->hdmi_data.enc_in_format != YCBCR422_8BITS)
 		return 0;
@@ -433,7 +434,7 @@ static int is_color_space_interpolation(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static void imx_hdmi_update_csc_coeffs(struct imx_hdmi *hdmi)
+static void dw_hdmi_update_csc_coeffs(struct dw_hdmi *hdmi)
 {
 	const u16 (*csc_coeff)[3][4] = &csc_coeff_default;
 	unsigned i;
@@ -474,7 +475,7 @@ static void imx_hdmi_update_csc_coeffs(struct imx_hdmi *hdmi)
 		  HDMI_CSC_SCALE);
 }
 
-static void hdmi_video_csc(struct imx_hdmi *hdmi)
+static void hdmi_video_csc(struct dw_hdmi *hdmi)
 {
 	int color_depth = 0;
 	int interpolation = HDMI_CSC_CFG_INTMODE_DISABLE;
@@ -502,7 +503,7 @@ static void hdmi_video_csc(struct imx_hdmi *hdmi)
 	hdmi_modb(hdmi, color_depth, HDMI_CSC_SCALE_CSC_COLORDE_PTH_MASK,
 		  HDMI_CSC_SCALE);
 
-	imx_hdmi_update_csc_coeffs(hdmi);
+	dw_hdmi_update_csc_coeffs(hdmi);
 }
 
 /*
@@ -510,7 +511,7 @@ static void hdmi_video_csc(struct imx_hdmi *hdmi)
  * for example, if input is YCC422 mode or repeater is used,
  * data should be repacked this module can be bypassed.
  */
-static void hdmi_video_packetize(struct imx_hdmi *hdmi)
+static void hdmi_video_packetize(struct dw_hdmi *hdmi)
 {
 	unsigned int color_depth = 0;
 	unsigned int remap_size = HDMI_VP_REMAP_YCC422_16bit;
@@ -607,40 +608,40 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
 		  HDMI_VP_CONF);
 }
 
-static inline void hdmi_phy_test_clear(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_clear(struct dw_hdmi *hdmi,
 				       unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTCLR_OFFSET,
 		  HDMI_PHY_TST0_TSTCLR_MASK, HDMI_PHY_TST0);
 }
 
-static inline void hdmi_phy_test_enable(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_enable(struct dw_hdmi *hdmi,
 					unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTEN_OFFSET,
 		  HDMI_PHY_TST0_TSTEN_MASK, HDMI_PHY_TST0);
 }
 
-static inline void hdmi_phy_test_clock(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_clock(struct dw_hdmi *hdmi,
 				       unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTCLK_OFFSET,
 		  HDMI_PHY_TST0_TSTCLK_MASK, HDMI_PHY_TST0);
 }
 
-static inline void hdmi_phy_test_din(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_din(struct dw_hdmi *hdmi,
 				     unsigned char bit)
 {
 	hdmi_writeb(hdmi, bit, HDMI_PHY_TST1);
 }
 
-static inline void hdmi_phy_test_dout(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_dout(struct dw_hdmi *hdmi,
 				      unsigned char bit)
 {
 	hdmi_writeb(hdmi, bit, HDMI_PHY_TST2);
 }
 
-static bool hdmi_phy_wait_i2c_done(struct imx_hdmi *hdmi, int msec)
+static bool hdmi_phy_wait_i2c_done(struct dw_hdmi *hdmi, int msec)
 {
 	while ((hdmi_readb(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
 		if (msec-- == 0)
@@ -650,7 +651,7 @@ static bool hdmi_phy_wait_i2c_done(struct imx_hdmi *hdmi, int msec)
 	return true;
 }
 
-static void __hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
+static void __hdmi_phy_i2c_write(struct dw_hdmi *hdmi, unsigned short data,
 				 unsigned char addr)
 {
 	hdmi_writeb(hdmi, 0xFF, HDMI_IH_I2CMPHY_STAT0);
@@ -664,63 +665,64 @@ static void __hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
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
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_PDZ_OFFSET,
 			 HDMI_PHY_CONF0_PDZ_MASK);
 }
 
-static void imx_hdmi_phy_enable_tmds(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_enable_tmds(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_ENTMDS_OFFSET,
 			 HDMI_PHY_CONF0_ENTMDS_MASK);
 }
 
-static void imx_hdmi_phy_gen2_pddq(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_gen2_pddq(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_GEN2_PDDQ_OFFSET,
 			 HDMI_PHY_CONF0_GEN2_PDDQ_MASK);
 }
 
-static void imx_hdmi_phy_gen2_txpwron(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_gen2_txpwron(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_GEN2_TXPWRON_OFFSET,
 			 HDMI_PHY_CONF0_GEN2_TXPWRON_MASK);
 }
 
-static void imx_hdmi_phy_sel_data_en_pol(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_sel_data_en_pol(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_SELDATAENPOL_OFFSET,
 			 HDMI_PHY_CONF0_SELDATAENPOL_MASK);
 }
 
-static void imx_hdmi_phy_sel_interface_control(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_sel_interface_control(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_SELDIPIF_OFFSET,
 			 HDMI_PHY_CONF0_SELDIPIF_MASK);
 }
 
-static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
+static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
 			      unsigned char res, int cscon)
 {
 	unsigned res_idx, i;
 	u8 val, msec;
-	const struct mpll_config *mpll_config = hdmi->plat_data->mpll_cfg;
-	const struct curr_ctrl   *curr_ctrl = hdmi->plat_data->cur_ctr;
-	const struct sym_term *sym_term =  hdmi->plat_data->sym_term;
+	const struct dw_hdmi_mpll_config *mpll_config =
+						hdmi->plat_data->mpll_cfg;
+	const struct dw_hdmi_curr_ctrl *curr_ctrl = hdmi->plat_data->cur_ctr;
+	const struct dw_hdmi_sym_term *sym_term =  hdmi->plat_data->sym_term;
 
 	if (prep)
 		return -EINVAL;
@@ -728,13 +730,13 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	switch (res) {
 	case 0:	/* color resolution 0 is 8 bit colour depth */
 	case 8:
-		res_idx = RES_8;
+		res_idx = DW_HDMI_RES_8;
 		break;
 	case 10:
-		res_idx = RES_10;
+		res_idx = DW_HDMI_RES_10;
 		break;
 	case 12:
-		res_idx = RES_12;
+		res_idx = DW_HDMI_RES_12;
 		break;
 	default:
 		return -EINVAL;
@@ -749,10 +751,10 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	hdmi_writeb(hdmi, val, HDMI_MC_FLOWCTRL);
 
 	/* gen2 tx power off */
-	imx_hdmi_phy_gen2_txpwron(hdmi, 0);
+	dw_hdmi_phy_gen2_txpwron(hdmi, 0);
 
 	/* gen2 pddq */
-	imx_hdmi_phy_gen2_pddq(hdmi, 1);
+	dw_hdmi_phy_gen2_pddq(hdmi, 1);
 
 	/* PHY reset */
 	hdmi_writeb(hdmi, HDMI_MC_PHYRSTZ_DEASSERT, HDMI_MC_PHYRSTZ);
@@ -806,15 +808,15 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
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
@@ -835,7 +837,7 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	return 0;
 }
 
-static int imx_hdmi_phy_init(struct imx_hdmi *hdmi)
+static int dw_hdmi_phy_init(struct dw_hdmi *hdmi)
 {
 	int i, ret;
 	bool cscon = false;
@@ -846,10 +848,10 @@ static int imx_hdmi_phy_init(struct imx_hdmi *hdmi)
 
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
@@ -861,7 +863,7 @@ static int imx_hdmi_phy_init(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static void hdmi_tx_hdcp_config(struct imx_hdmi *hdmi)
+static void hdmi_tx_hdcp_config(struct dw_hdmi *hdmi)
 {
 	u8 de;
 
@@ -880,7 +882,7 @@ static void hdmi_tx_hdcp_config(struct imx_hdmi *hdmi)
 		  HDMI_A_HDCPCFG1_ENCRYPTIONDISABLE_MASK, HDMI_A_HDCPCFG1);
 }
 
-static void hdmi_config_AVI(struct imx_hdmi *hdmi)
+static void hdmi_config_AVI(struct dw_hdmi *hdmi)
 {
 	u8 val, pix_fmt, under_scan;
 	u8 act_ratio, coded_ratio, colorimetry, ext_colorimetry;
@@ -974,7 +976,7 @@ static void hdmi_config_AVI(struct imx_hdmi *hdmi)
 	hdmi_writeb(hdmi, 0, HDMI_FC_AVISRB1);
 }
 
-static void hdmi_av_composer(struct imx_hdmi *hdmi,
+static void hdmi_av_composer(struct dw_hdmi *hdmi,
 			     const struct drm_display_mode *mode)
 {
 	u8 inv_val;
@@ -1058,19 +1060,19 @@ static void hdmi_av_composer(struct imx_hdmi *hdmi,
 	hdmi_writeb(hdmi, vsync_len, HDMI_FC_VSYNCINWIDTH);
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
 
@@ -1099,13 +1101,13 @@ static void imx_hdmi_enable_video_path(struct imx_hdmi *hdmi)
 	}
 }
 
-static void hdmi_enable_audio_clk(struct imx_hdmi *hdmi)
+static void hdmi_enable_audio_clk(struct dw_hdmi *hdmi)
 {
 	hdmi_modb(hdmi, 0, HDMI_MC_CLKDIS_AUDCLK_DISABLE, HDMI_MC_CLKDIS);
 }
 
 /* Workaround to clear the overflow condition */
-static void imx_hdmi_clear_overflow(struct imx_hdmi *hdmi)
+static void dw_hdmi_clear_overflow(struct dw_hdmi *hdmi)
 {
 	int count;
 	u8 val;
@@ -1123,19 +1125,19 @@ static void imx_hdmi_clear_overflow(struct imx_hdmi *hdmi)
 		hdmi_writeb(hdmi, val, HDMI_FC_INVIDCONF);
 }
 
-static void hdmi_enable_overflow_interrupts(struct imx_hdmi *hdmi)
+static void hdmi_enable_overflow_interrupts(struct dw_hdmi *hdmi)
 {
 	hdmi_writeb(hdmi, 0, HDMI_FC_MASK2);
 	hdmi_writeb(hdmi, 0, HDMI_IH_MUTE_FC_STAT2);
 }
 
-static void hdmi_disable_overflow_interrupts(struct imx_hdmi *hdmi)
+static void hdmi_disable_overflow_interrupts(struct dw_hdmi *hdmi)
 {
 	hdmi_writeb(hdmi, HDMI_IH_MUTE_FC_STAT2_OVERFLOW_MASK,
 		    HDMI_IH_MUTE_FC_STAT2);
 }
 
-static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
+static int dw_hdmi_setup(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
 {
 	int ret;
 
@@ -1187,12 +1189,12 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
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
@@ -1213,7 +1215,7 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 	hdmi_video_sample(hdmi);
 	hdmi_tx_hdcp_config(hdmi);
 
-	imx_hdmi_clear_overflow(hdmi);
+	dw_hdmi_clear_overflow(hdmi);
 	if (hdmi->cable_plugin && !hdmi->hdmi_data.video_mode.mdvi)
 		hdmi_enable_overflow_interrupts(hdmi);
 
@@ -1221,7 +1223,7 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 }
 
 /* Wait until we are registered to enable interrupts */
-static int imx_hdmi_fb_registered(struct imx_hdmi *hdmi)
+static int dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
 {
 	hdmi_writeb(hdmi, HDMI_PHY_I2CM_INT_ADDR_DONE_POL,
 		    HDMI_PHY_I2CM_INT_ADDR);
@@ -1239,7 +1241,7 @@ static int imx_hdmi_fb_registered(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static void initialize_hdmi_ih_mutes(struct imx_hdmi *hdmi)
+static void initialize_hdmi_ih_mutes(struct dw_hdmi *hdmi)
 {
 	u8 ih_mute;
 
@@ -1291,73 +1293,73 @@ static void initialize_hdmi_ih_mutes(struct imx_hdmi *hdmi)
 	hdmi_writeb(hdmi, ih_mute, HDMI_IH_MUTE);
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
 
-static void imx_hdmi_bridge_mode_set(struct drm_bridge *bridge,
-				     struct drm_display_mode *mode,
-				     struct drm_display_mode *adjusted_mode)
+static void dw_hdmi_bridge_mode_set(struct drm_bridge *bridge,
+				    struct drm_display_mode *mode,
+				    struct drm_display_mode *adjusted_mode)
 {
-	struct imx_hdmi *hdmi = bridge->driver_private;
+	struct dw_hdmi *hdmi = bridge->driver_private;
 
-	imx_hdmi_setup(hdmi, mode);
+	dw_hdmi_setup(hdmi, mode);
 
 	/* Store the display mode for plugin/DKMS poweron events */
 	memcpy(&hdmi->previous_mode, mode, sizeof(hdmi->previous_mode));
 }
 
-static bool imx_hdmi_bridge_mode_fixup(struct drm_bridge *bridge,
-				       const struct drm_display_mode *mode,
-				       struct drm_display_mode *adjusted_mode)
+static bool dw_hdmi_bridge_mode_fixup(struct drm_bridge *bridge,
+				      const struct drm_display_mode *mode,
+				      struct drm_display_mode *adjusted_mode)
 {
 	return true;
 }
 
-static void imx_hdmi_bridge_disable(struct drm_bridge *bridge)
+static void dw_hdmi_bridge_disable(struct drm_bridge *bridge)
 {
-	struct imx_hdmi *hdmi = bridge->driver_private;
+	struct dw_hdmi *hdmi = bridge->driver_private;
 
-	imx_hdmi_poweroff(hdmi);
+	dw_hdmi_poweroff(hdmi);
 }
 
-static void imx_hdmi_bridge_enable(struct drm_bridge *bridge)
+static void dw_hdmi_bridge_enable(struct drm_bridge *bridge)
 {
-	struct imx_hdmi *hdmi = bridge->driver_private;
+	struct dw_hdmi *hdmi = bridge->driver_private;
 
-	imx_hdmi_poweron(hdmi);
+	dw_hdmi_poweron(hdmi);
 }
 
-static void imx_hdmi_bridge_destroy(struct drm_bridge *bridge)
+static void dw_hdmi_bridge_destroy(struct drm_bridge *bridge)
 {
 	drm_bridge_cleanup(bridge);
 	kfree(bridge);
 }
 
-static void imx_hdmi_bridge_nope(struct drm_bridge *bridge)
+static void dw_hdmi_bridge_nope(struct drm_bridge *bridge)
 {
 	/* do nothing */
 }
 
-static enum drm_connector_status imx_hdmi_connector_detect(struct drm_connector
-							*connector, bool force)
+static enum drm_connector_status
+dw_hdmi_connector_detect(struct drm_connector *connector, bool force)
 {
-	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
+	struct dw_hdmi *hdmi = container_of(connector, struct dw_hdmi,
 					     connector);
 
 	return hdmi_readb(hdmi, HDMI_PHY_STAT0) & HDMI_PHY_HPD ?
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
@@ -1380,46 +1382,46 @@ static int imx_hdmi_connector_get_modes(struct drm_connector *connector)
 	return 0;
 }
 
-static struct drm_encoder *imx_hdmi_connector_best_encoder(struct drm_connector
+static struct drm_encoder *dw_hdmi_connector_best_encoder(struct drm_connector
 							   *connector)
 {
-	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
+	struct dw_hdmi *hdmi = container_of(connector, struct dw_hdmi,
 					     connector);
 
 	return hdmi->encoder;
 }
 
-static void imx_hdmi_connector_destroy(struct drm_connector *connector)
+static void dw_hdmi_connector_destroy(struct drm_connector *connector)
 {
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
 }
 
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
-	.best_encoder = imx_hdmi_connector_best_encoder,
+static struct drm_connector_helper_funcs dw_hdmi_connector_helper_funcs = {
+	.get_modes = dw_hdmi_connector_get_modes,
+	.best_encoder = dw_hdmi_connector_best_encoder,
 };
 
-struct drm_bridge_funcs imx_hdmi_bridge_funcs = {
-	.enable = imx_hdmi_bridge_enable,
-	.disable = imx_hdmi_bridge_disable,
-	.pre_enable = imx_hdmi_bridge_nope,
-	.post_disable = imx_hdmi_bridge_nope,
-	.mode_set = imx_hdmi_bridge_mode_set,
-	.mode_fixup = imx_hdmi_bridge_mode_fixup,
-	.destroy = imx_hdmi_bridge_destroy,
+struct drm_bridge_funcs dw_hdmi_bridge_funcs = {
+	.enable = dw_hdmi_bridge_enable,
+	.disable = dw_hdmi_bridge_disable,
+	.pre_enable = dw_hdmi_bridge_nope,
+	.post_disable = dw_hdmi_bridge_nope,
+	.mode_set = dw_hdmi_bridge_mode_set,
+	.mode_fixup = dw_hdmi_bridge_mode_fixup,
+	.destroy = dw_hdmi_bridge_destroy,
 };
 
-static irqreturn_t imx_hdmi_hardirq(int irq, void *dev_id)
+static irqreturn_t dw_hdmi_hardirq(int irq, void *dev_id)
 {
-	struct imx_hdmi *hdmi = dev_id;
+	struct dw_hdmi *hdmi = dev_id;
 	u8 intr_stat;
 
 	intr_stat = hdmi_readb(hdmi, HDMI_IH_PHY_STAT0);
@@ -1429,9 +1431,9 @@ static irqreturn_t imx_hdmi_hardirq(int irq, void *dev_id)
 	return intr_stat ? IRQ_WAKE_THREAD : IRQ_NONE;
 }
 
-static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
+static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 {
-	struct imx_hdmi *hdmi = dev_id;
+	struct dw_hdmi *hdmi = dev_id;
 	u8 intr_stat;
 	u8 phy_int_pol;
 
@@ -1445,14 +1447,14 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 
 			hdmi_modb(hdmi, 0, HDMI_PHY_HPD, HDMI_PHY_POL0);
 
-			imx_hdmi_poweron(hdmi);
+			dw_hdmi_poweron(hdmi);
 		} else {
 			dev_dbg(hdmi->dev, "EVENT=plugout\n");
 
 			hdmi_modb(hdmi, HDMI_PHY_HPD, HDMI_PHY_HPD,
 				  HDMI_PHY_POL0);
 
-			imx_hdmi_poweroff(hdmi);
+			dw_hdmi_poweroff(hdmi);
 		}
 		drm_helper_hpd_irq_event(hdmi->connector.dev);
 	}
@@ -1463,7 +1465,7 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
+static int dw_hdmi_register(struct drm_device *drm, struct dw_hdmi *hdmi)
 {
 	struct drm_encoder *encoder = hdmi->encoder;
 	struct drm_bridge *bridge;
@@ -1478,7 +1480,7 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 	hdmi->bridge = bridge;
 	bridge->driver_private = hdmi;
 
-	ret = drm_bridge_init(drm, bridge, &imx_hdmi_bridge_funcs);
+	ret = drm_bridge_init(drm, bridge, &dw_hdmi_bridge_funcs);
 	if (ret) {
 		DRM_ERROR("Failed to initialize bridge with drm\n");
 		return -EINVAL;
@@ -1488,8 +1490,8 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 	hdmi->connector.polled = DRM_CONNECTOR_POLL_HPD;
 
 	drm_connector_helper_add(&hdmi->connector,
-				 &imx_hdmi_connector_helper_funcs);
-	drm_connector_init(drm, &hdmi->connector, &imx_hdmi_connector_funcs,
+				 &dw_hdmi_connector_helper_funcs);
+	drm_connector_init(drm, &hdmi->connector, &dw_hdmi_connector_funcs,
 			   DRM_MODE_CONNECTOR_HDMIA);
 
 	hdmi->connector.encoder = encoder;
@@ -1499,7 +1501,7 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 	return 0;
 }
 
-int imx_hdmi_bind(struct device *dev, struct device *master,
+int dw_hdmi_bind(struct device *dev, struct device *master,
 		 void *data, struct drm_encoder *encoder,
 		 struct resource *iores, int irq,
 		 const struct dw_hdmi_plat_data *plat_data)
@@ -1507,7 +1509,7 @@ int imx_hdmi_bind(struct device *dev, struct device *master,
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
-	struct imx_hdmi *hdmi;
+	struct dw_hdmi *hdmi;
 	int ret;
 
 	hdmi = devm_kzalloc(dev, sizeof(*hdmi), GFP_KERNEL);
@@ -1535,8 +1537,8 @@ int imx_hdmi_bind(struct device *dev, struct device *master,
 	}
 
 
-	ret = devm_request_threaded_irq(dev, irq, imx_hdmi_hardirq,
-					imx_hdmi_irq, IRQF_SHARED,
+	ret = devm_request_threaded_irq(dev, irq, dw_hdmi_hardirq,
+					dw_hdmi_irq, IRQF_SHARED,
 					dev_name(dev), hdmi);
 	if (ret)
 		return ret;
@@ -1596,11 +1598,11 @@ int imx_hdmi_bind(struct device *dev, struct device *master,
 	/* Clear Hotplug interrupts */
 	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD, HDMI_IH_PHY_STAT0);
 
-	ret = imx_hdmi_fb_registered(hdmi);
+	ret = dw_hdmi_fb_registered(hdmi);
 	if (ret)
 		goto err_iahb;
 
-	ret = imx_hdmi_register(drm, hdmi);
+	ret = dw_hdmi_register(drm, hdmi);
 	if (ret)
 		goto err_iahb;
 
@@ -1618,11 +1620,11 @@ err_isfr:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(imx_hdmi_bind);
+EXPORT_SYMBOL_GPL(dw_hdmi_bind);
 
-void imx_hdmi_unbind(struct device *dev, struct device *master, void *data)
+void dw_hdmi_unbind(struct device *dev, struct device *master, void *data)
 {
-	struct imx_hdmi *hdmi = dev_get_drvdata(dev);
+	struct dw_hdmi *hdmi = dev_get_drvdata(dev);
 
 	/* Disable all interrupts */
 	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
@@ -1634,11 +1636,11 @@ void imx_hdmi_unbind(struct device *dev, struct device *master, void *data)
 	clk_disable_unprepare(hdmi->isfr_clk);
 	i2c_put_adapter(hdmi->ddc);
 }
-EXPORT_SYMBOL_GPL(imx_hdmi_unbind);
+EXPORT_SYMBOL_GPL(dw_hdmi_unbind);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
 MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
-MODULE_DESCRIPTION("i.MX6 HDMI transmitter driver");
+MODULE_DESCRIPTION("DW HDMI transmitter driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:imx-hdmi");
+MODULE_ALIAS("platform:dw-hdmi");
diff --git a/drivers/gpu/drm/imx/imx-hdmi.h b/drivers/gpu/drm/bridge/dw_hdmi.h
similarity index 98%
rename from drivers/gpu/drm/imx/imx-hdmi.h
rename to drivers/gpu/drm/bridge/dw_hdmi.h
index db407f0..baa7849 100644
--- a/drivers/gpu/drm/imx/imx-hdmi.h
+++ b/drivers/gpu/drm/bridge/dw_hdmi.h
@@ -1030,47 +1030,4 @@ enum {
 	HDMI_A_VIDPOLCFG_HSYNCPOL_ACTIVE_LOW = 0x0,
 };
 
-enum imx_hdmi_devtype {
-	IMX6Q_HDMI,
-	IMX6DL_HDMI,
-};
-
-struct imx_hdmi_plat_data {
-	enum imx_hdmi_devtype dev_type;
-	const struct mpll_config *mpll_cfg;
-	const struct curr_ctrl *cur_ctr;
-	const struct sym_term *sym_term;
-};
-
-enum {
-	RES_8,
-	RES_10,
-	RES_12,
-	RES_MAX,
-};
-
-struct mpll_config {
-	unsigned long mpixelclock;
-	struct {
-		u16 cpce;
-		u16 gmp;
-	} res[RES_MAX];
-};
-
-struct curr_ctrl {
-	unsigned long mpixelclock;
-	u16 curr[RES_MAX];
-};
-
-struct sym_term {
-	unsigned long mpixelclock;
-	u16 sym_ctr;    /*clock symbol and transmitter control*/
-	u16 term;       /*transmission termination value*/
-};
-
-int imx_hdmi_bind(struct device *dev, struct device *master,
-		  void *data, struct drm_encoder *encoder,
-		  struct resource *iores, int irq,
-		  const struct imx_hdmi_plat_data *plat_data);
-void imx_hdmi_unbind(struct device *dev, struct device *master, void *data);
 #endif /* __IMX_HDMI_H__ */
diff --git a/drivers/gpu/drm/imx/Kconfig b/drivers/gpu/drm/imx/Kconfig
index 82fb758..7070077 100644
--- a/drivers/gpu/drm/imx/Kconfig
+++ b/drivers/gpu/drm/imx/Kconfig
@@ -48,6 +48,7 @@ config DRM_IMX_IPUV3
 
 config DRM_IMX_HDMI
 	tristate "Freescale i.MX DRM HDMI"
+	select DRM_DW_HDMI
 	depends on DRM_IMX
 	help
 	  Choose this if you want to use HDMI on i.MX6.
diff --git a/drivers/gpu/drm/imx/Makefile b/drivers/gpu/drm/imx/Makefile
index 63cf56a..f3ecd89 100644
--- a/drivers/gpu/drm/imx/Makefile
+++ b/drivers/gpu/drm/imx/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
 
 imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
 obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
-obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o imx-hdmi_pltfm.o
+obj-$(CONFIG_DRM_IMX_HDMI) += dw_hdmi-imx.o
diff --git a/drivers/gpu/drm/imx/imx-hdmi_pltfm.c b/drivers/gpu/drm/imx/dw_hdmi-imx.c
similarity index 55%
rename from drivers/gpu/drm/imx/imx-hdmi_pltfm.c
rename to drivers/gpu/drm/imx/dw_hdmi-imx.c
index e1d5ee2..0293a88 100644
--- a/drivers/gpu/drm/imx/imx-hdmi_pltfm.c
+++ b/drivers/gpu/drm/imx/dw_hdmi-imx.c
@@ -1,6 +1,6 @@
 /* Copyright (C) 2011-2013 Freescale Semiconductor, Inc.
  *
- * derived from imx-hdmi.c
+ * derived from imx-hdmi.c(renamed to bridge/dw_hdmi.c now)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -11,6 +11,7 @@
 #include <linux/component.h>
 #include <linux/mfd/syscon.h>
 #include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
+#include <drm/bridge/dw_hdmi.h>
 #include <video/imx-ipu-v3.h>
 #include <linux/regmap.h>
 #include <drm/drm_of.h>
@@ -20,15 +21,14 @@
 #include <drm/drm_encoder_slave.h>
 
 #include "imx-drm.h"
-#include "imx-hdmi.h"
 
-struct imx_hdmi_priv {
+struct imx_hdmi {
 	struct device *dev;
 	struct drm_encoder encoder;
 	struct regmap *regmap;
 };
 
-static const struct mpll_config imx_mpll_cfg[] = {
+static const struct dw_hdmi_mpll_config imx_mpll_cfg[] = {
 	{
 		45250000, {
 			{ 0x01e0, 0x0000 },
@@ -56,7 +56,7 @@ static const struct mpll_config imx_mpll_cfg[] = {
 	}
 };
 
-static const struct curr_ctrl imx_cur_ctr[] = {
+static const struct dw_hdmi_curr_ctrl imx_cur_ctr[] = {
 	/*      pixelclk     bpp8    bpp10   bpp12 */
 	{
 		54000000, { 0x091c, 0x091c, 0x06dc },
@@ -73,13 +73,13 @@ static const struct curr_ctrl imx_cur_ctr[] = {
 	}
 };
 
-static const struct sym_term imx_sym_term[] = {
+static const struct dw_hdmi_sym_term imx_sym_term[] = {
 	/*pixelclk   symbol   term*/
 	{ 148500000, 0x800d, 0x0005 },
 	{ ~0UL,      0x0000, 0x0000 }
 };
 
-static int imx_hdmi_parse_dt(struct imx_hdmi_priv *hdmi)
+static int dw_hdmi_imx_parse_dt(struct imx_hdmi *hdmi)
 {
 	struct device_node *np = hdmi->dev->of_node;
 
@@ -92,28 +92,26 @@ static int imx_hdmi_parse_dt(struct imx_hdmi_priv *hdmi)
 	return 0;
 }
 
-static void imx_hdmi_encoder_disable(struct drm_encoder *encoder)
+static void dw_hdmi_imx_encoder_disable(struct drm_encoder *encoder)
 {
 }
 
-static bool imx_hdmi_encoder_mode_fixup(struct drm_encoder *encoder,
-					const struct drm_display_mode *mode,
-					struct drm_display_mode *adjusted_mode)
+static bool dw_hdmi_imx_encoder_mode_fixup(struct drm_encoder *encoder,
+					   const struct drm_display_mode *mode,
+					   struct drm_display_mode *adjusted_mode)
 {
 	return true;
 }
 
-static void imx_hdmi_encoder_mode_set(struct drm_encoder *encoder,
-				      struct drm_display_mode *mode,
-				      struct drm_display_mode *adjusted_mode)
+static void dw_hdmi_imx_encoder_mode_set(struct drm_encoder *encoder,
+					 struct drm_display_mode *mode,
+					 struct drm_display_mode *adjusted_mode)
 {
 }
 
-static void imx_hdmi_encoder_commit(struct drm_encoder *encoder)
+static void dw_hdmi_imx_encoder_commit(struct drm_encoder *encoder)
 {
-	struct imx_hdmi_priv *hdmi = container_of(encoder,
-						  struct imx_hdmi_priv,
-						  encoder);
+	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
 	int mux = imx_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
 
 	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
@@ -121,38 +119,38 @@ static void imx_hdmi_encoder_commit(struct drm_encoder *encoder)
 			   mux << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
 }
 
-static void imx_hdmi_encoder_prepare(struct drm_encoder *encoder)
+static void dw_hdmi_imx_encoder_prepare(struct drm_encoder *encoder)
 {
 	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
 }
 
-static struct drm_encoder_helper_funcs imx_hdmi_encoder_helper_funcs = {
-	.mode_fixup = imx_hdmi_encoder_mode_fixup,
-	.mode_set = imx_hdmi_encoder_mode_set,
-	.prepare = imx_hdmi_encoder_prepare,
-	.commit = imx_hdmi_encoder_commit,
-	.disable = imx_hdmi_encoder_disable,
+static struct drm_encoder_helper_funcs dw_hdmi_imx_encoder_helper_funcs = {
+	.mode_fixup = dw_hdmi_imx_encoder_mode_fixup,
+	.mode_set = dw_hdmi_imx_encoder_mode_set,
+	.prepare = dw_hdmi_imx_encoder_prepare,
+	.commit = dw_hdmi_imx_encoder_commit,
+	.disable = dw_hdmi_imx_encoder_disable,
 };
 
-static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
+static struct drm_encoder_funcs dw_hdmi_imx_encoder_funcs = {
 	.destroy = drm_encoder_cleanup,
 };
 
-static struct imx_hdmi_plat_data imx6q_hdmi_drv_data = {
-	.mpll_cfg = imx_mpll_cfg,
-	.cur_ctr  = imx_cur_ctr,
-	.sym_term = imx_sym_term,
-	.dev_type = IMX6Q_HDMI,
+static struct dw_hdmi_plat_data imx6q_hdmi_drv_data = {
+	.mpll_cfg		= imx_mpll_cfg,
+	.cur_ctr		= imx_cur_ctr,
+	.sym_term		= imx_sym_term,
+	.dev_type		= IMX6Q_HDMI,
 };
 
-static struct imx_hdmi_plat_data imx6dl_hdmi_drv_data = {
-	.mpll_cfg = imx_mpll_cfg,
-	.cur_ctr  = imx_cur_ctr,
-	.sym_term = imx_sym_term,
-	.dev_type = IMX6DL_HDMI,
+static struct dw_hdmi_plat_data imx6dl_hdmi_drv_data = {
+	.mpll_cfg		= imx_mpll_cfg,
+	.cur_ctr		= imx_cur_ctr,
+	.sym_term		= imx_sym_term,
+	.dev_type		= IMX6DL_HDMI,
 };
 
-static const struct of_device_id imx_hdmi_dt_ids[] = {
+static const struct of_device_id dw_hdmi_imx_dt_ids[] = {
 	{ .compatible = "fsl,imx6q-hdmi",
 	  .data = &imx6q_hdmi_drv_data
 	}, {
@@ -161,17 +159,17 @@ static const struct of_device_id imx_hdmi_dt_ids[] = {
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(of, imx_hdmi_dt_ids);
+MODULE_DEVICE_TABLE(of, dw_hdmi_imx_dt_ids);
 
-static int imx_hdmi_pltfm_bind(struct device *dev, struct device *master,
-			       void *data)
+static int dw_hdmi_imx_bind(struct device *dev, struct device *master,
+			    void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	const struct imx_hdmi_plat_data *plat_data;
+	const struct dw_hdmi_plat_data *plat_data;
 	const struct of_device_id *match;
 	struct drm_device *drm = data;
 	struct drm_encoder *encoder;
-	struct imx_hdmi_priv *hdmi;
+	struct imx_hdmi *hdmi;
 	struct resource *iores;
 	int irq;
 	int ret;
@@ -183,7 +181,7 @@ static int imx_hdmi_pltfm_bind(struct device *dev, struct device *master,
 	if (!hdmi)
 		return -ENOMEM;
 
-	match = of_match_node(imx_hdmi_dt_ids, pdev->dev.of_node);
+	match = of_match_node(dw_hdmi_imx_dt_ids, pdev->dev.of_node);
 	plat_data = match->data;
 	hdmi->dev = &pdev->dev;
 	encoder = &hdmi->encoder;
@@ -208,54 +206,53 @@ static int imx_hdmi_pltfm_bind(struct device *dev, struct device *master,
 	if (encoder->possible_crtcs == 0)
 		return -EPROBE_DEFER;
 
-	ret = imx_hdmi_parse_dt(hdmi);
+	ret = dw_hdmi_imx_parse_dt(hdmi);
 	if (ret < 0)
 		return ret;
 
-	drm_encoder_helper_add(encoder, &imx_hdmi_encoder_helper_funcs);
-	drm_encoder_init(drm, encoder, &imx_hdmi_encoder_funcs,
+	drm_encoder_helper_add(encoder, &dw_hdmi_imx_encoder_helper_funcs);
+	drm_encoder_init(drm, encoder, &dw_hdmi_imx_encoder_funcs,
 			 DRM_MODE_ENCODER_TMDS);
 
-	return imx_hdmi_bind(dev, master, data, encoder, iores, irq, plat_data);
+	return dw_hdmi_bind(dev, master, data, encoder, iores, irq, plat_data);
 }
 
-static void imx_hdmi_pltfm_unbind(struct device *dev, struct device *master,
-				  void *data)
+static void dw_hdmi_imx_unbind(struct device *dev, struct device *master,
+			       void *data)
 {
-	return imx_hdmi_unbind(dev, master, data);
+	return dw_hdmi_unbind(dev, master, data);
 }
 
-static const struct component_ops imx_hdmi_ops = {
-	.bind	= imx_hdmi_pltfm_bind,
-	.unbind	= imx_hdmi_pltfm_unbind,
+static const struct component_ops dw_hdmi_imx_ops = {
+	.bind	= dw_hdmi_imx_bind,
+	.unbind	= dw_hdmi_imx_unbind,
 };
 
-static int imx_hdmi_probe(struct platform_device *pdev)
+static int dw_hdmi_imx_probe(struct platform_device *pdev)
 {
-	return component_add(&pdev->dev, &imx_hdmi_ops);
+	return component_add(&pdev->dev, &dw_hdmi_imx_ops);
 }
 
-static int imx_hdmi_remove(struct platform_device *pdev)
+static int dw_hdmi_imx_remove(struct platform_device *pdev)
 {
-	component_del(&pdev->dev, &imx_hdmi_ops);
+	component_del(&pdev->dev, &dw_hdmi_imx_ops);
 
 	return 0;
 }
 
-static struct platform_driver imx_hdmi_pltfm_driver = {
-	.probe  = imx_hdmi_probe,
-	.remove = imx_hdmi_remove,
+static struct platform_driver dw_hdmi_imx_platform_driver = {
+	.probe  = dw_hdmi_imx_probe,
+	.remove = dw_hdmi_imx_remove,
 	.driver = {
-		.name = "hdmi-imx",
-		.owner = THIS_MODULE,
-		.of_match_table = imx_hdmi_dt_ids,
+		.name = "dwhdmi-imx",
+		.of_match_table = dw_hdmi_imx_dt_ids,
 	},
 };
 
-module_platform_driver(imx_hdmi_pltfm_driver);
+module_platform_driver(dw_hdmi_imx_platform_driver);
 
 MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
 MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
 MODULE_DESCRIPTION("IMX6 Specific DW-HDMI Driver Extension");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:hdmi-imx");
+MODULE_ALIAS("platform:dwhdmi-imx");
diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
new file mode 100644
index 0000000..fbb813f
--- /dev/null
+++ b/include/drm/bridge/dw_hdmi.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) 2011 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __DW_HDMI__
+#define __DW_HDMI__
+
+#include <drm/drmP.h>
+
+enum {
+	DW_HDMI_RES_8,
+	DW_HDMI_RES_10,
+	DW_HDMI_RES_12,
+	DW_HDMI_RES_MAX,
+};
+
+enum dw_hdmi_devtype {
+	IMX6Q_HDMI,
+	IMX6DL_HDMI,
+};
+
+struct dw_hdmi_mpll_config {
+	unsigned long mpixelclock;
+	struct {
+		u16 cpce;
+		u16 gmp;
+	} res[DW_HDMI_RES_MAX];
+};
+
+struct dw_hdmi_curr_ctrl {
+	unsigned long mpixelclock;
+	u16 curr[DW_HDMI_RES_MAX];
+};
+
+struct dw_hdmi_sym_term {
+	unsigned long mpixelclock;
+	u16 sym_ctr;    /*clock symbol and transmitter control*/
+	u16 term;       /*transmission termination value*/
+};
+
+struct dw_hdmi_plat_data {
+	enum dw_hdmi_devtype dev_type;
+	const struct dw_hdmi_mpll_config *mpll_cfg;
+	const struct dw_hdmi_curr_ctrl *cur_ctr;
+	const struct dw_hdmi_sym_term *sym_term;
+	enum drm_mode_status (*mode_valid)(struct drm_connector *connector,
+			      struct drm_display_mode *mode);
+};
+
+void dw_hdmi_unbind(struct device *dev, struct device *master, void *data);
+int dw_hdmi_bind(struct device *dev, struct device *master,
+		 void *data, struct drm_encoder *encoder,
+		 struct resource *iores, int irq,
+		 const struct dw_hdmi_plat_data *plat_data);
+#endif /* __IMX_HDMI_H__ */
-- 
1.9.1


