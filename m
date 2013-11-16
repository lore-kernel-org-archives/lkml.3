Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3KPACG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:02:06 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40333 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KPABh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:37 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 03/23] OMAPDSS: raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:06 +0200
Message-Id: <1384560086-11994-4-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 drivers/video/omap2/dss/dispc.c           |    4 ++--
 drivers/video/omap2/dss/dsi.c             |    4 ++--
 drivers/video/omap2/dss/dss.c             |    4 ++--
 drivers/video/omap2/dss/rfbi.c            |   16 ++++++++--------
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c |    4 ++--
 drivers/video/omap2/dss/venc.c            |    4 ++--
 drivers/video/omap2/omapfb/omapfb-main.c  |   10 +++++-----
 drivers/video/omap2/vrfb.c                |    6 +++---
 8 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/video/omap2/dss/dispc.c b/drivers/video/omap2/dss/dispc.c
index 4779750..87a3682 100644
--- a/drivers/video/omap2/dss/dispc.c
+++ b/drivers/video/omap2/dss/dispc.c
@@ -228,12 +228,12 @@ static unsigned long dispc_plane_lclk_rate(enum omap_plane plane);
 
 static inline void dispc_write_reg(const u16 idx, u32 val)
 {
-	__raw_writel(val, dispc.base + idx);
+	writel_relaxed(val, dispc.base + idx);
 }
 
 static inline u32 dispc_read_reg(const u16 idx)
 {
-	return __raw_readl(dispc.base + idx);
+	return readl_relaxed(dispc.base + idx);
 }
 
 static u32 mgr_fld_read(enum omap_channel channel, enum mgr_reg_fields regfld)
diff --git a/drivers/video/omap2/dss/dsi.c b/drivers/video/omap2/dss/dsi.c
index a598b58..c5af3fa 100644
--- a/drivers/video/omap2/dss/dsi.c
+++ b/drivers/video/omap2/dss/dsi.c
@@ -414,7 +414,7 @@ static inline void dsi_write_reg(struct platform_device *dsidev,
 {
 	struct dsi_data *dsi = dsi_get_dsidrv_data(dsidev);
 
-	__raw_writel(val, dsi->base + idx.idx);
+	writel_relaxed(val, dsi->base + idx.idx);
 }
 
 static inline u32 dsi_read_reg(struct platform_device *dsidev,
@@ -422,7 +422,7 @@ static inline u32 dsi_read_reg(struct platform_device *dsidev,
 {
 	struct dsi_data *dsi = dsi_get_dsidrv_data(dsidev);
 
-	return __raw_readl(dsi->base + idx.idx);
+	return readl_relaxed(dsi->base + idx.idx);
 }
 
 static void dsi_bus_lock(struct omap_dss_device *dssdev)
diff --git a/drivers/video/omap2/dss/dss.c b/drivers/video/omap2/dss/dss.c
index bd01608..e53f663 100644
--- a/drivers/video/omap2/dss/dss.c
+++ b/drivers/video/omap2/dss/dss.c
@@ -104,12 +104,12 @@ static const char * const dss_generic_clk_source_names[] = {
 
 static inline void dss_write_reg(const struct dss_reg idx, u32 val)
 {
-	__raw_writel(val, dss.base + idx.idx);
+	writel_relaxed(val, dss.base + idx.idx);
 }
 
 static inline u32 dss_read_reg(const struct dss_reg idx)
 {
-	return __raw_readl(dss.base + idx.idx);
+	return readl_relaxed(dss.base + idx.idx);
 }
 
 #define SR(reg) \
diff --git a/drivers/video/omap2/dss/rfbi.c b/drivers/video/omap2/dss/rfbi.c
index c8a81a2..7772e33 100644
--- a/drivers/video/omap2/dss/rfbi.c
+++ b/drivers/video/omap2/dss/rfbi.c
@@ -122,12 +122,12 @@ static struct {
 
 static inline void rfbi_write_reg(const struct rfbi_reg idx, u32 val)
 {
-	__raw_writel(val, rfbi.base + idx.idx);
+	writel_relaxed(val, rfbi.base + idx.idx);
 }
 
 static inline u32 rfbi_read_reg(const struct rfbi_reg idx)
 {
-	return __raw_readl(rfbi.base + idx.idx);
+	return readl_relaxed(rfbi.base + idx.idx);
 }
 
 static int rfbi_runtime_get(void)
@@ -263,8 +263,8 @@ static void rfbi_write_pixels(const void __iomem *buf, int scr_width,
 		for (; h; --h) {
 			for (i = 0; i < w; ++i) {
 				const u8 __iomem *b = (const u8 __iomem *)pd;
-				rfbi_write_reg(RFBI_PARAM, __raw_readb(b+1));
-				rfbi_write_reg(RFBI_PARAM, __raw_readb(b+0));
+				rfbi_write_reg(RFBI_PARAM, readb_relaxed(b+1));
+				rfbi_write_reg(RFBI_PARAM, readb_relaxed(b+0));
 				++pd;
 			}
 			pd += horiz_offset;
@@ -277,9 +277,9 @@ static void rfbi_write_pixels(const void __iomem *buf, int scr_width,
 		for (; h; --h) {
 			for (i = 0; i < w; ++i) {
 				const u8 __iomem *b = (const u8 __iomem *)pd;
-				rfbi_write_reg(RFBI_PARAM, __raw_readb(b+2));
-				rfbi_write_reg(RFBI_PARAM, __raw_readb(b+1));
-				rfbi_write_reg(RFBI_PARAM, __raw_readb(b+0));
+				rfbi_write_reg(RFBI_PARAM, readb_relaxed(b+2));
+				rfbi_write_reg(RFBI_PARAM, readb_relaxed(b+1));
+				rfbi_write_reg(RFBI_PARAM, readb_relaxed(b+0));
 				++pd;
 			}
 			pd += horiz_offset;
@@ -291,7 +291,7 @@ static void rfbi_write_pixels(const void __iomem *buf, int scr_width,
 
 		for (; h; --h) {
 			for (i = 0; i < w; ++i) {
-				rfbi_write_reg(RFBI_PARAM, __raw_readw(pd));
+				rfbi_write_reg(RFBI_PARAM, readw_relaxed(pd));
 				++pd;
 			}
 			pd += horiz_offset;
diff --git a/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c b/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
index 3dfe009..59936fa 100644
--- a/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
+++ b/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
@@ -43,13 +43,13 @@
 static inline void hdmi_write_reg(void __iomem *base_addr,
 				const u16 idx, u32 val)
 {
-	__raw_writel(val, base_addr + idx);
+	writel_relaxed(val, base_addr + idx);
 }
 
 static inline u32 hdmi_read_reg(void __iomem *base_addr,
 				const u16 idx)
 {
-	return __raw_readl(base_addr + idx);
+	return readl_relaxed(base_addr + idx);
 }
 
 static inline void __iomem *hdmi_wp_base(struct hdmi_ip_data *ip_data)
diff --git a/drivers/video/omap2/dss/venc.c b/drivers/video/omap2/dss/venc.c
index 5f88ac4..74e6973 100644
--- a/drivers/video/omap2/dss/venc.c
+++ b/drivers/video/omap2/dss/venc.c
@@ -309,12 +309,12 @@ static struct {
 
 static inline void venc_write_reg(int idx, u32 val)
 {
-	__raw_writel(val, venc.base + idx);
+	writel_relaxed(val, venc.base + idx);
 }
 
 static inline u32 venc_read_reg(int idx)
 {
-	u32 l = __raw_readl(venc.base + idx);
+	u32 l = readl_relaxed(venc.base + idx);
 	return l;
 }
 
diff --git a/drivers/video/omap2/omapfb/omapfb-main.c b/drivers/video/omap2/omapfb/omapfb-main.c
index 27d6905..f7a347c 100644
--- a/drivers/video/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/omap2/omapfb/omapfb-main.c
@@ -82,18 +82,18 @@ static void draw_pixel(struct fb_info *fbi, int x, int y, unsigned color)
 		g = g * 64 / 256;
 		b = b * 32 / 256;
 
-		__raw_writew((r << 11) | (g << 5) | (b << 0), p);
+		writew_relaxed((r << 11) | (g << 5) | (b << 0), p);
 	} else if (var->bits_per_pixel == 24) {
 		u8 __iomem *p = (u8 __iomem *)addr;
 		p += (y * line_len + x) * 3;
 
-		__raw_writeb(b, p + 0);
-		__raw_writeb(g, p + 1);
-		__raw_writeb(r, p + 2);
+		writeb_relaxed(b, p + 0);
+		writeb_relaxed(g, p + 1);
+		writeb_relaxed(r, p + 2);
 	} else if (var->bits_per_pixel == 32) {
 		u32 __iomem *p = (u32 __iomem *)addr;
 		p += y * line_len + x;
-		__raw_writel(color, p);
+		writel_relaxed(color, p);
 	}
 }
 
diff --git a/drivers/video/omap2/vrfb.c b/drivers/video/omap2/vrfb.c
index f346b02..0324690 100644
--- a/drivers/video/omap2/vrfb.c
+++ b/drivers/video/omap2/vrfb.c
@@ -82,17 +82,17 @@ static bool vrfb_loaded;
 
 static void omap2_sms_write_rot_control(u32 val, unsigned ctx)
 {
-	__raw_writel(val, vrfb_base + SMS_ROT_CONTROL(ctx));
+	writel_relaxed(val, vrfb_base + SMS_ROT_CONTROL(ctx));
 }
 
 static void omap2_sms_write_rot_size(u32 val, unsigned ctx)
 {
-	__raw_writel(val, vrfb_base + SMS_ROT_SIZE(ctx));
+	writel_relaxed(val, vrfb_base + SMS_ROT_SIZE(ctx));
 }
 
 static void omap2_sms_write_rot_physical_ba(u32 val, unsigned ctx)
 {
-	__raw_writel(val, vrfb_base + SMS_ROT_PHYSICAL_BA(ctx));
+	writel_relaxed(val, vrfb_base + SMS_ROT_PHYSICAL_BA(ctx));
 }
 
 static inline void restore_hw_context(int ctx)
-- 
1.7.9.5

