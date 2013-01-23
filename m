Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3AWLtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:49:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43293 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab3AWLtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:49:07 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 12/12] video: da8xx-fb: CCF clock divider handling
Date: Wed, 23 Jan 2013 17:18:56 +0530
Message-ID: <fa8dab522507e087d5a94bac13dda71544911707.1358937685.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358937685.git.afzal@ti.com>
References: <cover.1358937685.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common clock framework provides a basic clock divider. Make use of it
to handle clock configuration in the LCDC IP, wherever applicable;
out of two platforms having this IP, only am335x is converted to use
CCF, DaVinci is not yet converted. Hence wrap the modification such
that it will come into effect only if CCF is selected, otherwise,
prgram dividers as earlier. Once DaVinci is converted to use CCF,
this ifdef'ery can be removed.

Divider clock instantiated is made as a one that allows the rate
propogation to it's parent, that provides more options w.r.t pixel
clock rates that could be configured.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

v4: use new registration for clock divider having minimum divider
    requirement and have ifdef'ery in a better way
v3: model CCF clock divider with parent propogation if CCF selected
v2: new patch

 drivers/video/da8xx-fb.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 5455682..6723683 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -36,6 +36,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/lcm.h>
+#include <linux/clk-provider.h>
 #include <video/of_display_timing.h>
 #include <video/da8xx-fb.h>
 #include <asm/div64.h>
@@ -133,6 +134,10 @@
 #define WSI_TIMEOUT	50
 #define PALETTE_SIZE	256
 
+#define	LCD_CLK_SHIFT	8
+#define	LCD_CLK_WIDTH	8
+#define	LCD_CLK_MIN_DIV	2
+
 static void __iomem *da8xx_fb_reg_base;
 static struct resource *lcdc_regs;
 static unsigned int lcd_revision;
@@ -181,6 +186,9 @@ struct da8xx_fb_par {
 	u32 pseudo_palette[16];
 	struct fb_videomode	mode;
 	struct lcd_ctrl_config	cfg;
+#ifdef CONFIG_COMMON_CLK
+	struct clk		*child_clk;
+#endif
 };
 
 static struct fb_var_screeninfo da8xx_fb_var;
@@ -683,12 +691,27 @@ static void da8xx_fb_lcd_reset(void)
 	}
 }
 
+#ifndef	CONFIG_COMMON_CLK
 static inline unsigned da8xx_fb_calc_clk_divider(struct da8xx_fb_par *par,
 						 unsigned pixclock)
 {
 	return par->lcd_fck_rate / (PICOS2KHZ(pixclock) * 1000);
 }
+#endif
 
+#ifdef	CONFIG_COMMON_CLK
+static inline unsigned da8xx_fb_round_clk(struct da8xx_fb_par *par,
+					  unsigned pixclock)
+{
+	unsigned long rate;
+
+	rate = PICOS2KHZ(pixclock) * 1000;
+	rate = clk_round_rate(par->child_clk, rate);
+	rate = KHZ2PICOS(rate / 1000);
+
+	return rate;
+}
+#else
 static inline unsigned da8xx_fb_round_clk(struct da8xx_fb_par *par,
 					  unsigned pixclock)
 {
@@ -703,19 +726,43 @@ static inline void da8xx_fb_config_clk_divider(unsigned div)
 	/* Configure the LCD clock divisor. */
 	lcdc_write(LCD_CLK_DIVISOR(div) |
 			(LCD_RASTER_MODE & 0x1), LCD_CTRL_REG);
+}
+#endif
 
+static inline void da8xx_fb_clkc_enable(void)
+{
 	if (lcd_revision == LCD_VERSION_2)
 		lcdc_write(LCD_V2_DMA_CLK_EN | LCD_V2_LIDD_CLK_EN |
 				LCD_V2_CORE_CLK_EN, LCD_CLK_ENABLE_REG);
 }
 
-static inline void da8xx_fb_calc_config_clk_divider(struct da8xx_fb_par *par,
+#ifdef	CONFIG_COMMON_CLK
+static inline int da8xx_fb_calc_config_clk_divider(struct da8xx_fb_par *par,
+						    struct fb_videomode *mode)
+{
+	int ret;
+
+	ret = clk_set_rate(par->child_clk, PICOS2KHZ(mode->pixclock) * 1000);
+	if (IS_ERR_VALUE(ret)) {
+		dev_err(par->dev, "unable to setup pixel clock of %u ps",
+			mode->pixclock);
+		return ret;
+	}
+	da8xx_fb_clkc_enable();
+	return 0;
+}
+#else
+static inline int da8xx_fb_calc_config_clk_divider(struct da8xx_fb_par *par,
 						    struct fb_videomode *mode)
 {
 	unsigned div = da8xx_fb_calc_clk_divider(par, mode->pixclock);
 
 	da8xx_fb_config_clk_divider(div);
+	da8xx_fb_clkc_enable();
+
+	return 0;
 }
+#endif
 
 static int lcd_init(struct da8xx_fb_par *par, const struct lcd_ctrl_config *cfg,
 		struct fb_videomode *panel)
@@ -723,7 +770,9 @@ static int lcd_init(struct da8xx_fb_par *par, const struct lcd_ctrl_config *cfg,
 	u32 bpp;
 	int ret = 0;
 
-	da8xx_fb_calc_config_clk_divider(par, panel);
+	ret = da8xx_fb_calc_config_clk_divider(par, panel);
+	if (IS_ERR_VALUE(ret))
+		return ret;
 
 	if (panel->sync & FB_SYNC_CLK_INVERT)
 		lcdc_write((lcdc_read(LCD_RASTER_TIMING_2_REG) |
@@ -1406,6 +1455,25 @@ static int fb_probe(struct platform_device *device)
 
 	da8xx_fb_lcd_reset();
 
+#ifdef	CONFIG_COMMON_CLK
+	/* set sane divisor value to begin along with the mode */
+	lcdc_write(LCD_RASTER_MODE | LCD_CLK_DIVISOR(LCD_CLK_MIN_DIV),
+		   LCD_CTRL_REG);
+
+	par->child_clk = clk_register_min_divider(NULL, "da8xx_fb_clk",
+					      __clk_get_name(fb_clk),
+					      CLK_SET_RATE_PARENT,
+					      da8xx_fb_reg_base + LCD_CTRL_REG,
+					      LCD_CLK_SHIFT, LCD_CLK_WIDTH,
+					      LCD_CLK_MIN_DIV,
+					      CLK_DIVIDER_ONE_BASED, NULL);
+	if (IS_ERR(par->child_clk)) {
+		dev_err(&device->dev, "error registering clk\n");
+		ret = -ENODEV;
+		goto err_release_fb;
+	}
+#endif
+
 	/* allocate frame buffer */
 	par->vram_size = lcdc_info->xres * lcdc_info->yres * lcd_cfg->bpp;
 	ulcm = lcm((lcdc_info->xres * lcd_cfg->bpp)/8, PAGE_SIZE);
-- 
1.7.12

