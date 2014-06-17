Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaFQPVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:21:48 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:54852 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754462AbaFQPVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:21:46 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v7 1/2] video: ARM CLCD: Add DT support
Date: Tue, 17 Jun 2014 16:21:33 +0100
Message-Id: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic DT bindings for the PL11x CLCD cells
and make their fbdev driver use them.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
Changes since v6:
- replaced in-node device-timing subnode with the standard
  video interface bindings (as in: ports & endpoints); only
  "panel-dpi" compatible panels are supported in the driver

Changes since v5:
- realised that dma_alloc_writecombine() is a arm-specific function;
  replaced with generic dma_alloc_coherent()/dma_mmap_writecombine()

Changes since v4:
- simplified the pads description property and made it optional

Changes since v3:
- changed wording and order of interrupt-names and interrupts
  properties documentation
- changed wording of arm,pl11x,framebuffer-base property
  documentation
- cleaned up binding documentation indentation

Changes since v2:
- replaced video-ram phandle with arm,pl11x,framebuffer-base
- replaced panel-* properties with arm,pl11x,panel-data-pads
- replaced max-framebuffer-size with max-memory-bandwidth
- modified clcdfb_of_init_tft_panel() to use the pads
  data and take differences between PL110 and PL110 into
  account

Changes since v1:
- minor code cleanups as suggested by Sylwester Nawrocki

 .../devicetree/bindings/video/arm,pl11x.txt        | 102 ++++++++
 drivers/video/fbdev/Kconfig                        |   1 +
 drivers/video/fbdev/amba-clcd.c                    | 268 +++++++++++++++++++++
 3 files changed, 371 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/arm,pl11x.txt

diff --git a/Documentation/devicetree/bindings/video/arm,pl11x.txt b/Documentation/devicetree/bindings/video/arm,pl11x.txt
new file mode 100644
index 0000000..54124c6
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/arm,pl11x.txt
@@ -0,0 +1,102 @@
+* ARM PrimeCell Color LCD Controller PL110/PL111
+
+See also Documentation/devicetree/bindings/arm/primecell.txt
+
+Required properties:
+
+- compatible: must be one of:
+	"arm,pl110", "arm,primecell"
+	"arm,pl111", "arm,primecell"
+
+- reg: base address and size of the control registers block
+
+- interrupt-names: either the single entry "combined" representing a
+	combined interrupt output (CLCDINTR), or the four entries
+	"mbe", "vcomp", "lnbu", "fuf" representing the individual
+	CLCDMBEINTR, CLCDVCOMPINTR, CLCDLNBUINTR, CLCDFUFINTR interrupts
+
+- interrupts: contains an interrupt specifier for each entry in
+	interrupt-names
+
+- clocks-names: should contain "clcdclk" and "apb_pclk"
+
+- clocks: contains phandle and clock specifier pairs for the entries
+	in the clock-names property. See
+	Documentation/devicetree/binding/clock/clock-bindings.txt
+
+Optional properties:
+
+- arm,pl11x,framebuffer-base: a pair of two 32-bit values, address and size,
+	defining the framebuffer that must be used; if not present, the
+	framebuffer may be located anywhere in the memory
+
+- max-memory-bandwidth: maximum bandwidth in bytes per second that the
+	cell's memory interface can handle
+
+Required sub-nodes:
+
+- port: describes LCD panel signals, following the common binding
+	for video transmitter interfaces; see
+	Documentation/devicetree/bindings/media/video-interfaces.txt;
+	when it is a TFT panel, the port's endpoint must define the
+	following property:
+
+	- arm,pl11x,tft-r0g0b0-pads: an array of three 32-bit values,
+		defining the way CLD pads are wired up; this implicitly
+		defines available color modes, for example:
+		- PL111 TFT 4:4:4 panel:
+			arm,pl11x,tft-r0g0b0-pads = <4 15 20>;
+		- PL110 TFT (1:)5:5:5 panel:
+			arm,pl11x,tft-r0g0b0-pads = <1 7 13>;
+		- PL111 TFT (1:)5:5:5 panel:
+			arm,pl11x,tft-r0g0b0-pads = <3 11 19>;
+		- PL111 TFT 5:6:5 panel:
+			arm,pl11x,tft-r0g0b0-pads = <3 10 19>;
+		- PL110 and PL111 TFT 8:8:8 panel:
+			arm,pl11x,tft-r0g0b0-pads = <0 8 16>;
+		- PL110 and PL111 TFT 8:8:8 panel, R & B components swapped:
+			arm,pl11x,tft-r0g0b0-pads = <16 8 0>;
+
+
+Example:
+
+	clcd@1f0000 {
+		compatible = "arm,pl111", "arm,primecell";
+		reg = <0x1f0000 0x1000>;
+		interrupt-names = "combined";
+		interrupts = <14>;
+		clock-names = "clcdclk", "apb_pclk";
+		clocks = <&v2m_oscclk1>, <&smbclk>;
+		arm,pl11x,framebuffer-base = <0x18000000 0x00800000>;
+		max-memory-bandwidth = <36864000>; /* bps, 640x480@60 16bpp */
+
+		port {
+			v2m_clcd_pads: endpoint {
+				remote-endpoint = <&v2m_clcd_panel>;
+				arm,pl11x,tft-r0g0b0-pads = <0 8 16>;
+			};
+		};
+
+	};
+
+	panel {
+		compatible = "panel-dpi";
+
+		port {
+			v2m_clcd_panel: endpoint {
+				remote-endpoint = <&v2m_clcd_pads>;
+			};
+		};
+
+		panel-timing {
+			clock-frequency = <25175000>;
+			hactive = <640>;
+			hback-porch = <40>;
+			hfront-porch = <24>;
+			hsync-len = <96>;
+			vactive = <480>;
+			vback-porch = <32>;
+			vfront-porch = <11>;
+			vsync-len = <2>;
+		};
+	};
diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 59c98bfd..a518fe5 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -280,6 +280,7 @@ config FB_ARMCLCD
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VIDEOMODE_HELPERS if OF
 	help
 	  This framebuffer device driver is for the ARM PrimeCell PL110
 	  Colour LCD controller.  ARM PrimeCells provide the building
diff --git a/drivers/video/fbdev/amba-clcd.c b/drivers/video/fbdev/amba-clcd.c
index 14d6b37..64eae1b 100644
--- a/drivers/video/fbdev/amba-clcd.c
+++ b/drivers/video/fbdev/amba-clcd.c
@@ -26,6 +26,13 @@
 #include <linux/amba/clcd.h>
 #include <linux/clk.h>
 #include <linux/hardirq.h>
+#include <linux/dma-mapping.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_graph.h>
+#include <video/display_timing.h>
+#include <video/of_display_timing.h>
+#include <video/videomode.h>
 
 #include <asm/sizes.h>
 
@@ -543,6 +550,264 @@ static int clcdfb_register(struct clcd_fb *fb)
 	return ret;
 }
 
+#ifdef CONFIG_OF
+static int clcdfb_of_get_dpi_panel_mode(struct device_node *node,
+		struct fb_videomode *mode)
+{
+	int err;
+	struct display_timing timing;
+	struct videomode video;
+
+	err = of_get_display_timing(node, "panel-timing", &timing);
+	if (err)
+		return err;
+
+	videomode_from_timing(&timing, &video);
+
+	err = fb_videomode_from_videomode(&video, mode);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int clcdfb_snprintf_mode(char *buf, int size, struct fb_videomode *mode)
+{
+	return snprintf(buf, size, "%ux%u@%u", mode->xres, mode->yres,
+			mode->refresh);
+}
+
+static int clcdfb_of_get_mode(struct device *dev, struct device_node *endpoint,
+		struct fb_videomode *mode)
+{
+	int err;
+	struct device_node *panel;
+	char *name;
+	int len;
+
+	panel = of_graph_get_remote_port_parent(endpoint);
+	if (!panel)
+		return -ENODEV;
+
+	/* Only directly connected DPI panels supported for now */
+	if (of_device_is_compatible(panel, "panel-dpi"))
+		err = clcdfb_of_get_dpi_panel_mode(panel, mode);
+	else
+		err = -ENOENT;
+	if (err)
+		return err;
+
+	len = clcdfb_snprintf_mode(NULL, 0, mode);
+	name = devm_kzalloc(dev, len + 1, GFP_KERNEL);
+	clcdfb_snprintf_mode(name, len + 1, mode);
+	mode->name = name;
+
+	return 0;
+}
+
+static int clcdfb_of_init_tft_panel(struct clcd_fb *fb, u32 r0, u32 g0, u32 b0)
+{
+	static struct {
+		unsigned int part;
+		u32 r0, g0, b0;
+		u32 caps;
+	} panels[] = {
+		{ 0x110, 1,  7, 13, CLCD_CAP_5551 },
+		{ 0x110, 0,  8, 16, CLCD_CAP_888 },
+		{ 0x111, 4, 14, 20, CLCD_CAP_444 },
+		{ 0x111, 3, 11, 19, CLCD_CAP_444 | CLCD_CAP_5551 },
+		{ 0x111, 3, 10, 19, CLCD_CAP_444 | CLCD_CAP_5551 |
+				    CLCD_CAP_565 },
+		{ 0x111, 0,  8, 16, CLCD_CAP_444 | CLCD_CAP_5551 |
+				    CLCD_CAP_565 | CLCD_CAP_888 },
+	};
+	int i;
+
+	/* Bypass pixel clock divider, data output on the falling edge */
+	fb->panel->tim2 = TIM2_BCD | TIM2_IPC;
+
+	/* TFT display, vert. comp. interrupt at the start of the back porch */
+	fb->panel->cntl |= CNTL_LCDTFT | CNTL_LCDVCOMP(1);
+
+	fb->panel->caps = 0;
+
+	/* Match the setup with known variants */
+	for (i = 0; i < ARRAY_SIZE(panels) && !fb->panel->caps; i++) {
+		if (amba_part(fb->dev) != panels[i].part)
+			continue;
+		if (g0 != panels[i].g0)
+			continue;
+		if (r0 == panels[i].r0 && b0 == panels[i].b0)
+			fb->panel->caps = panels[i].caps & CLCD_CAP_RGB;
+		if (r0 == panels[i].b0 && b0 == panels[i].r0)
+			fb->panel->caps = panels[i].caps & CLCD_CAP_BGR;
+	}
+
+	return fb->panel->caps ? 0 : -EINVAL;
+}
+
+static int clcdfb_of_init_display(struct clcd_fb *fb)
+{
+	struct device_node *endpoint;
+	int err;
+	u32 max_bandwidth;
+	u32 tft_r0b0g0[3];
+
+	fb->panel = devm_kzalloc(&fb->dev->dev, sizeof(*fb->panel), GFP_KERNEL);
+	if (!fb->panel)
+		return -ENOMEM;
+
+	endpoint = of_graph_get_next_endpoint(fb->dev->dev.of_node, NULL);
+	if (!endpoint)
+		return -ENODEV;
+
+	err = clcdfb_of_get_mode(&fb->dev->dev, endpoint, &fb->panel->mode);
+	if (err)
+		return err;
+
+	err = of_property_read_u32(fb->dev->dev.of_node, "max-memory-bandwidth",
+			&max_bandwidth);
+	if (!err)
+		fb->panel->bpp = 8 * max_bandwidth / (fb->panel->mode.xres *
+				fb->panel->mode.yres * fb->panel->mode.refresh);
+	else
+		fb->panel->bpp = 32;
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	fb->panel->cntl |= CNTL_BEBO;
+#endif
+	fb->panel->width = -1;
+	fb->panel->height = -1;
+
+	if (of_property_read_u32_array(endpoint,
+			"arm,pl11x,tft-r0g0b0-pads",
+			tft_r0b0g0, ARRAY_SIZE(tft_r0b0g0)) == 0)
+		return clcdfb_of_init_tft_panel(fb, tft_r0b0g0[0],
+				 tft_r0b0g0[1],  tft_r0b0g0[2]);
+
+	return -ENOENT;
+}
+
+static int clcdfb_of_vram_setup(struct clcd_fb *fb)
+{
+	int err;
+	u32 values[2];
+	phys_addr_t phys_base;
+	size_t size;
+
+	err = clcdfb_of_init_display(fb);
+	if (err)
+		return err;
+
+	err = of_property_read_u32_array(fb->dev->dev.of_node,
+			"arm,pl11x,framebuffer-base",
+			values, ARRAY_SIZE(values));
+	if (err)
+		return err;
+
+	phys_base = values[0];
+	size = values[1];
+
+	fb->fb.screen_base = ioremap(phys_base, size);
+	if (!fb->fb.screen_base)
+		return -ENOMEM;
+
+	fb->fb.fix.smem_start = phys_base;
+	fb->fb.fix.smem_len = size;
+
+	return 0;
+}
+
+static int clcdfb_of_vram_mmap(struct clcd_fb *fb, struct vm_area_struct *vma)
+{
+	unsigned long off, user_size, kernel_size;
+
+
+	off = vma->vm_pgoff << PAGE_SHIFT;
+	user_size = vma->vm_end - vma->vm_start;
+	kernel_size = fb->fb.fix.smem_len;
+
+	if (off >= kernel_size || user_size > (kernel_size - off))
+		return -ENXIO;
+
+	return remap_pfn_range(vma, vma->vm_start,
+			__phys_to_pfn(fb->fb.fix.smem_start) + vma->vm_pgoff,
+			user_size,
+			pgprot_writecombine(vma->vm_page_prot));
+}
+
+static void clcdfb_of_vram_remove(struct clcd_fb *fb)
+{
+	iounmap(fb->fb.screen_base);
+}
+
+static int clcdfb_of_dma_setup(struct clcd_fb *fb)
+{
+	unsigned long framesize;
+	dma_addr_t dma;
+	int err;
+
+	err = clcdfb_of_init_display(fb);
+	if (err)
+		return err;
+
+	framesize = fb->panel->mode.xres * fb->panel->mode.yres *
+			fb->panel->bpp / 8;
+	fb->fb.screen_base = dma_alloc_coherent(&fb->dev->dev, framesize,
+			&dma, GFP_KERNEL);
+	if (!fb->fb.screen_base)
+		return -ENOMEM;
+
+	fb->fb.fix.smem_start = dma;
+	fb->fb.fix.smem_len = framesize;
+
+	return 0;
+}
+
+static int clcdfb_of_dma_mmap(struct clcd_fb *fb, struct vm_area_struct *vma)
+{
+	return dma_mmap_writecombine(&fb->dev->dev, vma, fb->fb.screen_base,
+			fb->fb.fix.smem_start, fb->fb.fix.smem_len);
+}
+
+static void clcdfb_of_dma_remove(struct clcd_fb *fb)
+{
+	dma_free_coherent(&fb->dev->dev, fb->fb.fix.smem_len,
+			fb->fb.screen_base, fb->fb.fix.smem_start);
+}
+
+static struct clcd_board *clcdfb_of_get_board(struct amba_device *dev)
+{
+	struct clcd_board *board = devm_kzalloc(&dev->dev, sizeof(*board),
+			GFP_KERNEL);
+	struct device_node *node = dev->dev.of_node;
+
+	if (!board)
+		return NULL;
+
+	board->name = of_node_full_name(node);
+	board->caps = CLCD_CAP_ALL;
+	board->check = clcdfb_check;
+	board->decode = clcdfb_decode;
+	if (of_find_property(node, "arm,pl11x,framebuffer-base", NULL)) {
+		board->setup = clcdfb_of_vram_setup;
+		board->mmap = clcdfb_of_vram_mmap;
+		board->remove = clcdfb_of_vram_remove;
+	} else {
+		board->setup = clcdfb_of_dma_setup;
+		board->mmap = clcdfb_of_dma_mmap;
+		board->remove = clcdfb_of_dma_remove;
+	}
+
+	return board;
+}
+#else
+static struct clcd_board *clcdfb_of_get_board(struct amba_dev *dev)
+{
+	return NULL;
+}
+#endif
+
 static int clcdfb_probe(struct amba_device *dev, const struct amba_id *id)
 {
 	struct clcd_board *board = dev_get_platdata(&dev->dev);
@@ -550,6 +815,9 @@ static int clcdfb_probe(struct amba_device *dev, const struct amba_id *id)
 	int ret;
 
 	if (!board)
+		board = clcdfb_of_get_board(dev);
+
+	if (!board)
 		return -EINVAL;
 
 	ret = dma_set_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32));
-- 
1.9.1

