Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3AONnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:43:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46899 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752Ab3AONnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:43:51 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 12/12] video: da8xx-fb: set upstream clock rate (if reqd)
Date: Tue, 15 Jan 2013 19:14:36 +0530
Message-ID: <26e787b021cda89a080f80657c2094b9ff2decaf.1358251448.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358251447.git.afzal@ti.com>
References: <cover.1358251447.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LCDC IP has a clock divider to adjust pixel clock, this limits pixel
clock range to fck/255 - fck/2(fck - rate of input clock to LCDC IP).
In the case of AM335x, where this IP is present, default fck is not
sufficient to provide normal pixel clock rates, hence rendering this
driver unusable on AM335x.

If input clock too is configurable, allowable range of pixel clock
would increase. Here initially it is checked whether with present fck,
divider in IP could be configured to obtain required rate, if not,
fck is adjusted. This makes it usable on AM335x.

Note:
A better (if allowable) solution may be to represent clock divider in
LCDC IP as a basic divider clock - the one defined in common clock
framework. But for this to happen, all the platform's using this driver
should be using common clock framework (DaVinci is yet to be converted
to use common clock framework). And it has to be determined whether
common clock framework allows this kind of a clock modelling inside a
driver and for this to be part of clock tree. Advantage of doing so
would be better resolution for pixel clock, even though without this
existing use cases are working properly. Or another extreme alternative
would be to replicate clk-divider of common clock framework inside the
driver, but that probably is not preferred and not worth as it would be
duplication and without much advantage to existing users.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

v2: new patch

 drivers/video/da8xx-fb.c |   76 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 58 insertions(+), 18 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 5455682..09dfa12 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -133,6 +133,9 @@
 #define WSI_TIMEOUT	50
 #define PALETTE_SIZE	256
 
+#define	CLK_MIN_DIV	2
+#define	CLK_MAX_DIV	255
+
 static void __iomem *da8xx_fb_reg_base;
 static struct resource *lcdc_regs;
 static unsigned int lcd_revision;
@@ -683,23 +686,21 @@ static void da8xx_fb_lcd_reset(void)
 	}
 }
 
-static inline unsigned da8xx_fb_calc_clk_divider(struct da8xx_fb_par *par,
-						 unsigned pixclock)
-{
-	return par->lcd_fck_rate / (PICOS2KHZ(pixclock) * 1000);
-}
-
-static inline unsigned da8xx_fb_round_clk(struct da8xx_fb_par *par,
-					  unsigned pixclock)
+static int da8xx_fb_config_clk_divider(struct da8xx_fb_par *par,
+					      unsigned div, unsigned rate)
 {
-	unsigned div;
+	int ret;
 
-	div = da8xx_fb_calc_clk_divider(par, pixclock);
-	return KHZ2PICOS(par->lcd_fck_rate / (1000 * div));
-}
+	if (par->lcd_fck_rate != rate) {
+		ret = clk_set_rate(par->lcdc_clk, rate);
+		if (IS_ERR_VALUE(ret)) {
+			dev_err(par->dev,
+				"unable to set clock rate at %u\n", rate);
+			return ret;
+		}
+		par->lcd_fck_rate = clk_get_rate(par->lcdc_clk);
+	}
 
-static inline void da8xx_fb_config_clk_divider(unsigned div)
-{
 	/* Configure the LCD clock divisor. */
 	lcdc_write(LCD_CLK_DIVISOR(div) |
 			(LCD_RASTER_MODE & 0x1), LCD_CTRL_REG);
@@ -707,14 +708,49 @@ static inline void da8xx_fb_config_clk_divider(unsigned div)
 	if (lcd_revision == LCD_VERSION_2)
 		lcdc_write(LCD_V2_DMA_CLK_EN | LCD_V2_LIDD_CLK_EN |
 				LCD_V2_CORE_CLK_EN, LCD_CLK_ENABLE_REG);
+
+	return 0;
+}
+
+static unsigned int da8xx_fb_calc_clk_divider(struct da8xx_fb_par *par,
+					      unsigned pixclock,
+					      unsigned *rate)
+{
+	unsigned div;
+
+	pixclock = PICOS2KHZ(pixclock) * 1000;
+
+	*rate = par->lcd_fck_rate;
+
+	if (pixclock < (*rate / CLK_MAX_DIV)) {
+		*rate = clk_round_rate(par->lcdc_clk, pixclock * CLK_MAX_DIV);
+		div = CLK_MAX_DIV;
+	} else if (pixclock > (*rate / CLK_MIN_DIV)) {
+		*rate = clk_round_rate(par->lcdc_clk, pixclock * CLK_MIN_DIV);
+		div = CLK_MIN_DIV;
+	} else {
+		div = *rate / pixclock;
+	}
+
+	return div;
 }
 
-static inline void da8xx_fb_calc_config_clk_divider(struct da8xx_fb_par *par,
+static inline int da8xx_fb_calc_config_clk_divider(struct da8xx_fb_par *par,
 						    struct fb_videomode *mode)
 {
-	unsigned div = da8xx_fb_calc_clk_divider(par, mode->pixclock);
+	unsigned rate;
+	unsigned div = da8xx_fb_calc_clk_divider(par, mode->pixclock, &rate);
 
-	da8xx_fb_config_clk_divider(div);
+	return da8xx_fb_config_clk_divider(par, div, rate);
+}
+
+static inline unsigned da8xx_fb_round_clk(struct da8xx_fb_par *par,
+					  unsigned pixclock)
+{
+	unsigned div, rate;
+
+	div = da8xx_fb_calc_clk_divider(par, pixclock, &rate);
+	return KHZ2PICOS(rate / (1000 * div));
 }
 
 static int lcd_init(struct da8xx_fb_par *par, const struct lcd_ctrl_config *cfg,
@@ -723,7 +759,11 @@ static int lcd_init(struct da8xx_fb_par *par, const struct lcd_ctrl_config *cfg,
 	u32 bpp;
 	int ret = 0;
 
-	da8xx_fb_calc_config_clk_divider(par, panel);
+	ret = da8xx_fb_calc_config_clk_divider(par, panel);
+	if (IS_ERR_VALUE(ret)) {
+		dev_err(par->dev, "unable to configure clock\n");
+		return ret;
+	}
 
 	if (panel->sync & FB_SYNC_CLK_INVERT)
 		lcdc_write((lcdc_read(LCD_RASTER_TIMING_2_REG) |
-- 
1.7.9.5

