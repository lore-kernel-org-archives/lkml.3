Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaLUQ73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 11:59:29 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54124 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaLUQ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 11:59:27 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: omap2: dss: rfbi.c:  Remove some unused functions
Date: Sun, 21 Dec 2014 18:02:12 +0100
Message-Id: <1419181332-9322-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
rfbi_init_display() rfbi_display_disable() rfbi_display_enable()
rfbi_set_interface_timings() rfbi_set_data_lines() rfbi_set_pixel_size()
rfbi_set_size() rfbi_update() rfbi_configure() rfbi_enable_te()
rfbi_setup_te() rfbi_write_pixels() rfbi_write_data() rfbi_read_data()
rfbi_write_command() rfbi_bus_unlock() rfbi_bus_lock()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/omap2/dss/rfbi.c |  297 ----------------------------------
 1 file changed, 297 deletions(-)

diff --git a/drivers/video/fbdev/omap2/dss/rfbi.c b/drivers/video/fbdev/omap2/dss/rfbi.c
index 878273f..3e25028 100644
--- a/drivers/video/fbdev/omap2/dss/rfbi.c
+++ b/drivers/video/fbdev/omap2/dss/rfbi.c
@@ -151,156 +151,6 @@ static void rfbi_runtime_put(void)
 	WARN_ON(r < 0 && r != -ENOSYS);
 }
 
-static void rfbi_bus_lock(void)
-{
-	down(&rfbi.bus_lock);
-}
-
-static void rfbi_bus_unlock(void)
-{
-	up(&rfbi.bus_lock);
-}
-
-static void rfbi_write_command(const void *buf, u32 len)
-{
-	switch (rfbi.parallelmode) {
-	case OMAP_DSS_RFBI_PARALLELMODE_8:
-	{
-		const u8 *b = buf;
-		for (; len; len--)
-			rfbi_write_reg(RFBI_CMD, *b++);
-		break;
-	}
-
-	case OMAP_DSS_RFBI_PARALLELMODE_16:
-	{
-		const u16 *w = buf;
-		BUG_ON(len & 1);
-		for (; len; len -= 2)
-			rfbi_write_reg(RFBI_CMD, *w++);
-		break;
-	}
-
-	case OMAP_DSS_RFBI_PARALLELMODE_9:
-	case OMAP_DSS_RFBI_PARALLELMODE_12:
-	default:
-		BUG();
-	}
-}
-
-static void rfbi_read_data(void *buf, u32 len)
-{
-	switch (rfbi.parallelmode) {
-	case OMAP_DSS_RFBI_PARALLELMODE_8:
-	{
-		u8 *b = buf;
-		for (; len; len--) {
-			rfbi_write_reg(RFBI_READ, 0);
-			*b++ = rfbi_read_reg(RFBI_READ);
-		}
-		break;
-	}
-
-	case OMAP_DSS_RFBI_PARALLELMODE_16:
-	{
-		u16 *w = buf;
-		BUG_ON(len & ~1);
-		for (; len; len -= 2) {
-			rfbi_write_reg(RFBI_READ, 0);
-			*w++ = rfbi_read_reg(RFBI_READ);
-		}
-		break;
-	}
-
-	case OMAP_DSS_RFBI_PARALLELMODE_9:
-	case OMAP_DSS_RFBI_PARALLELMODE_12:
-	default:
-		BUG();
-	}
-}
-
-static void rfbi_write_data(const void *buf, u32 len)
-{
-	switch (rfbi.parallelmode) {
-	case OMAP_DSS_RFBI_PARALLELMODE_8:
-	{
-		const u8 *b = buf;
-		for (; len; len--)
-			rfbi_write_reg(RFBI_PARAM, *b++);
-		break;
-	}
-
-	case OMAP_DSS_RFBI_PARALLELMODE_16:
-	{
-		const u16 *w = buf;
-		BUG_ON(len & 1);
-		for (; len; len -= 2)
-			rfbi_write_reg(RFBI_PARAM, *w++);
-		break;
-	}
-
-	case OMAP_DSS_RFBI_PARALLELMODE_9:
-	case OMAP_DSS_RFBI_PARALLELMODE_12:
-	default:
-		BUG();
-
-	}
-}
-
-static void rfbi_write_pixels(const void __iomem *buf, int scr_width,
-		u16 x, u16 y,
-		u16 w, u16 h)
-{
-	int start_offset = scr_width * y + x;
-	int horiz_offset = scr_width - w;
-	int i;
-
-	if (rfbi.datatype == OMAP_DSS_RFBI_DATATYPE_16 &&
-	   rfbi.parallelmode == OMAP_DSS_RFBI_PARALLELMODE_8) {
-		const u16 __iomem *pd = buf;
-		pd += start_offset;
-
-		for (; h; --h) {
-			for (i = 0; i < w; ++i) {
-				const u8 __iomem *b = (const u8 __iomem *)pd;
-				rfbi_write_reg(RFBI_PARAM, __raw_readb(b+1));
-				rfbi_write_reg(RFBI_PARAM, __raw_readb(b+0));
-				++pd;
-			}
-			pd += horiz_offset;
-		}
-	} else if (rfbi.datatype == OMAP_DSS_RFBI_DATATYPE_24 &&
-	   rfbi.parallelmode == OMAP_DSS_RFBI_PARALLELMODE_8) {
-		const u32 __iomem *pd = buf;
-		pd += start_offset;
-
-		for (; h; --h) {
-			for (i = 0; i < w; ++i) {
-				const u8 __iomem *b = (const u8 __iomem *)pd;
-				rfbi_write_reg(RFBI_PARAM, __raw_readb(b+2));
-				rfbi_write_reg(RFBI_PARAM, __raw_readb(b+1));
-				rfbi_write_reg(RFBI_PARAM, __raw_readb(b+0));
-				++pd;
-			}
-			pd += horiz_offset;
-		}
-	} else if (rfbi.datatype == OMAP_DSS_RFBI_DATATYPE_16 &&
-	   rfbi.parallelmode == OMAP_DSS_RFBI_PARALLELMODE_16) {
-		const u16 __iomem *pd = buf;
-		pd += start_offset;
-
-		for (; h; --h) {
-			for (i = 0; i < w; ++i) {
-				rfbi_write_reg(RFBI_PARAM, __raw_readw(pd));
-				++pd;
-			}
-			pd += horiz_offset;
-		}
-	} else {
-		BUG();
-	}
-}
-
 static int rfbi_transfer_area(struct omap_dss_device *dssdev,
 		void (*callback)(void *data), void *data)
 {
@@ -567,69 +417,6 @@ static int rfbi_convert_timings(struct rfbi_timings *t)
 	return 0;
 }
 
-/* xxx FIX module selection missing */
-static int rfbi_setup_te(enum omap_rfbi_te_mode mode,
-			     unsigned hs_pulse_time, unsigned vs_pulse_time,
-			     int hs_pol_inv, int vs_pol_inv, int extif_div)
-{
-	int hs, vs;
-	int min;
-	u32 l;
-
-	hs = ps_to_rfbi_ticks(hs_pulse_time, 1);
-	vs = ps_to_rfbi_ticks(vs_pulse_time, 1);
-	if (hs < 2)
-		return -EDOM;
-	if (mode == OMAP_DSS_RFBI_TE_MODE_2)
-		min = 2;
-	else /* OMAP_DSS_RFBI_TE_MODE_1 */
-		min = 4;
-	if (vs < min)
-		return -EDOM;
-	if (vs == hs)
-		return -EINVAL;
-	rfbi.te_mode = mode;
-	DSSDBG("setup_te: mode %d hs %d vs %d hs_inv %d vs_inv %d\n",
-		mode, hs, vs, hs_pol_inv, vs_pol_inv);
-
-	rfbi_write_reg(RFBI_HSYNC_WIDTH, hs);
-	rfbi_write_reg(RFBI_VSYNC_WIDTH, vs);
-
-	l = rfbi_read_reg(RFBI_CONFIG(0));
-	if (hs_pol_inv)
-		l &= ~(1 << 21);
-	else
-		l |= 1 << 21;
-	if (vs_pol_inv)
-		l &= ~(1 << 20);
-	else
-		l |= 1 << 20;
-
-	return 0;
-}
-
-/* xxx FIX module selection missing */
-static int rfbi_enable_te(bool enable, unsigned line)
-{
-	u32 l;
-
-	DSSDBG("te %d line %d mode %d\n", enable, line, rfbi.te_mode);
-	if (line > (1 << 11) - 1)
-		return -EINVAL;
-
-	l = rfbi_read_reg(RFBI_CONFIG(0));
-	l &= ~(0x3 << 2);
-	if (enable) {
-		rfbi.te_enabled = 1;
-		l |= rfbi.te_mode << 2;
-	} else
-		rfbi.te_enabled = 0;
-	rfbi_write_reg(RFBI_CONFIG(0), l);
-	rfbi_write_reg(RFBI_LINE_NUMBER, line);
-
-	return 0;
-}
-
 static int rfbi_configure_bus(int rfbi_module, int bpp, int lines)
 {
 	u32 l;
@@ -762,40 +549,6 @@ static int rfbi_configure_bus(int rfbi_module, int bpp, int lines)
 	return 0;
 }
 
-static int rfbi_configure(struct omap_dss_device *dssdev)
-{
-	return rfbi_configure_bus(dssdev->phy.rfbi.channel, rfbi.pixel_size,
-			rfbi.data_lines);
-}
-
-static int rfbi_update(struct omap_dss_device *dssdev, void (*callback)(void *),
-		void *data)
-{
-	return rfbi_transfer_area(dssdev, callback, data);
-}
-
-static void rfbi_set_size(struct omap_dss_device *dssdev, u16 w, u16 h)
-{
-	rfbi.timings.x_res = w;
-	rfbi.timings.y_res = h;
-}
-
-static void rfbi_set_pixel_size(struct omap_dss_device *dssdev, int pixel_size)
-{
-	rfbi.pixel_size = pixel_size;
-}
-
-static void rfbi_set_data_lines(struct omap_dss_device *dssdev, int data_lines)
-{
-	rfbi.data_lines = data_lines;
-}
-
-static void rfbi_set_interface_timings(struct omap_dss_device *dssdev,
-		struct rfbi_timings *timings)
-{
-	rfbi.intf_timings = *timings;
-}
-
 static void rfbi_dump_regs(struct seq_file *s)
 {
 #define DUMPREG(r) seq_printf(s, "%-35s %08x\n", #r, rfbi_read_reg(r))
@@ -874,56 +627,6 @@ static void rfbi_config_lcd_manager(struct omap_dss_device *dssdev)
 	dss_mgr_set_timings(mgr, &rfbi.timings);
 }
 
-static int rfbi_display_enable(struct omap_dss_device *dssdev)
-{
-	struct omap_dss_device *out = &rfbi.output;
-	int r;
-
-	if (out == NULL || out->manager == NULL) {
-		DSSERR("failed to enable display: no output/manager\n");
-		return -ENODEV;
-	}
-
-	r = rfbi_runtime_get();
-	if (r)
-		return r;
-
-	r = dss_mgr_register_framedone_handler(out->manager,
-			framedone_callback, NULL);
-	if (r) {
-		DSSERR("can't get FRAMEDONE irq\n");
-		goto err1;
-	}
-
-	rfbi_config_lcd_manager(dssdev);
-
-	rfbi_configure_bus(dssdev->phy.rfbi.channel, rfbi.pixel_size,
-			rfbi.data_lines);
-
-	rfbi_set_timings(dssdev->phy.rfbi.channel, &rfbi.intf_timings);
-
-	return 0;
-err1:
-	rfbi_runtime_put();
-	return r;
-}
-
-static void rfbi_display_disable(struct omap_dss_device *dssdev)
-{
-	struct omap_dss_device *out = &rfbi.output;
-
-	dss_mgr_unregister_framedone_handler(out->manager,
-			framedone_callback, NULL);
-
-	rfbi_runtime_put();
-}
-
-static int rfbi_init_display(struct omap_dss_device *dssdev)
-{
-	rfbi.dssdev[dssdev->phy.rfbi.channel] = dssdev;
-	return 0;
-}
-
 static void rfbi_init_output(struct platform_device *pdev)
 {
 	struct omap_dss_device *out = &rfbi.output;
-- 
1.7.10.4

