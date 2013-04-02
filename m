Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762119Ab3DBSVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:21:32 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:58650 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762085Ab3DBSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:20:36 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: tomi.valkeinen@ti.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv3 6/6] video: fb: vt8500: Convert framebuffer drivers to standardized binding
Date: Wed,  3 Apr 2013 07:20:38 +1300
Message-Id: <1364926838-6721-7-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
References: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that a display timing binding is available, convert our almost identical
binding to use the standard binding.

This patch converts the vt8500 and wm8505 framebuffer drivers and
associated dts/dtsi files to use the standard binding as defined in
bindings/video/display-timing.txt.

There are two side-effects of making this conversion:

1) The fb node should now be in the board file, rather than the soc file as
the display-timing node is a child of the fb node.

2) We still require a bits per pixel property to initialize the framebuffer
for the different lcd panels. Rather than including this as part of the
display timing, it is moved into the framebuffer node.

I have also taken the opportunity to alphabetise the includes of each
driver to avoid double-ups.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 .../devicetree/bindings/video/via,vt8500-fb.txt    |   48 ++++----------
 .../devicetree/bindings/video/wm,wm8505-fb.txt     |   32 ++++++----
 arch/arm/boot/dts/vt8500-bv07.dts                  |   34 +++++-----
 arch/arm/boot/dts/vt8500.dtsi                      |    4 +-
 arch/arm/boot/dts/wm8505-ref.dts                   |   34 +++++-----
 arch/arm/boot/dts/wm8505.dtsi                      |    4 +-
 arch/arm/boot/dts/wm8650-mid.dts                   |   36 +++++------
 arch/arm/boot/dts/wm8650.dtsi                      |    4 +-
 arch/arm/boot/dts/wm8850-w70v2.dts                 |   40 ++++++------
 arch/arm/boot/dts/wm8850.dtsi                      |    4 +-
 drivers/video/Kconfig                              |    6 ++
 drivers/video/vt8500lcdfb.c                        |   53 ++++++----------
 drivers/video/wm8505fb.c                           |   67 ++++++++------------
 13 files changed, 154 insertions(+), 212 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/via,vt8500-fb.txt b/Documentation/devicetree/bindings/video/via,vt8500-fb.txt
index c870b64..2871e21 100644
--- a/Documentation/devicetree/bindings/video/via,vt8500-fb.txt
+++ b/Documentation/devicetree/bindings/video/via,vt8500-fb.txt
@@ -5,58 +5,32 @@ Required properties:
 - compatible : "via,vt8500-fb"
 - reg : Should contain 1 register ranges(address and length)
 - interrupts : framebuffer controller interrupt
-- display: a phandle pointing to the display node
+- bits-per-pixel : bit depth of framebuffer (16 or 32)
 
-Required nodes:
-- display: a display node is required to initialize the lcd panel
-	This should be in the board dts.
-- default-mode: a videomode within the display with timing parameters
-	as specified below.
+Required subnodes:
+- display-timings: see display-timing.txt for information
 
 Example:
 
-	fb@d800e400 {
+	fb@d8050800 {
 		compatible = "via,vt8500-fb";
 		reg = <0xd800e400 0x400>;
 		interrupts = <12>;
-		display = <&display>;
-		default-mode = <&mode0>;
-	};
-
-VIA VT8500 Display
------------------------------------------------------
-Required properties (as per of_videomode_helper):
-
- - hactive, vactive: Display resolution
- - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
-   in pixels
-   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
-   lines
- - clock: displayclock in Hz
- - bpp: lcd panel bit-depth.
-	<16> for RGB565, <32> for RGB888
-
-Optional properties (as per of_videomode_helper):
- - width-mm, height-mm: Display dimensions in mm
- - hsync-active-high (bool): Hsync pulse is active high
- - vsync-active-high (bool): Vsync pulse is active high
- - interlaced (bool): This is an interlaced mode
- - doublescan (bool): This is a doublescan mode
+		bits-per-pixel = <16>;
 
-Example:
-	display: display@0 {
-		modes {
-			mode0: mode@0 {
+		display-timings {
+			native-mode = <&timing0>;
+			timing0: 800x480 {
+				clock-frequency = <0>; /* unused but required */
 				hactive = <800>;
 				vactive = <480>;
-				hback-porch = <88>;
 				hfront-porch = <40>;
+				hback-porch = <88>;
 				hsync-len = <0>;
 				vback-porch = <32>;
 				vfront-porch = <11>;
 				vsync-len = <1>;
-				clock = <0>;	/* unused but required */
-				bpp = <16>;	/* non-standard but required */
 			};
 		};
 	};
+
diff --git a/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt b/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt
index 3d325e1..0bcadb2 100644
--- a/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt
+++ b/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt
@@ -4,20 +4,30 @@ Wondermedia WM8505 Framebuffer
 Required properties:
 - compatible : "wm,wm8505-fb"
 - reg : Should contain 1 register ranges(address and length)
-- via,display: a phandle pointing to the display node
+- bits-per-pixel : bit depth of framebuffer (16 or 32)
 
-Required nodes:
-- display: a display node is required to initialize the lcd panel
-	This should be in the board dts. See definition in
-	Documentation/devicetree/bindings/video/via,vt8500-fb.txt
-- default-mode: a videomode node as specified in
-	Documentation/devicetree/bindings/video/via,vt8500-fb.txt
+Required subnodes:
+- display-timings: see display-timing.txt for information
 
 Example:
 
-	fb@d8050800 {
+	fb@d8051700 {
 		compatible = "wm,wm8505-fb";
-		reg = <0xd8050800 0x200>;
-		display = <&display>;
-		default-mode = <&mode0>;
+		reg = <0xd8051700 0x200>;
+		bits-per-pixel = <16>;
+
+		display-timings {
+			native-mode = <&timing0>;
+			timing0: 800x480 {
+				clock-frequency = <0>; /* unused but required */
+				hactive = <800>;
+				vactive = <480>;
+				hfront-porch = <40>;
+				hback-porch = <88>;
+				hsync-len = <0>;
+				vback-porch = <32>;
+				vfront-porch = <11>;
+				vsync-len = <1>;
+			};
+		};
 	};
diff --git a/arch/arm/boot/dts/vt8500-bv07.dts b/arch/arm/boot/dts/vt8500-bv07.dts
index 567cf4e..877b33a 100644
--- a/arch/arm/boot/dts/vt8500-bv07.dts
+++ b/arch/arm/boot/dts/vt8500-bv07.dts
@@ -11,26 +11,22 @@
 
 / {
 	model = "Benign BV07 Netbook";
+};
 
-	/*
-	 * Display node is based on Sascha Hauer's patch on dri-devel.
-	 * Added a bpp property to calculate the size of the framebuffer
-	 * until the binding is formalized.
-	 */
-	display: display@0 {
-		modes {
-			mode0: mode@0 {
-				hactive = <800>;
-				vactive = <480>;
-				hback-porch = <88>;
-				hfront-porch = <40>;
-				hsync-len = <0>;
-				vback-porch = <32>;
-				vfront-porch = <11>;
-				vsync-len = <1>;
-				clock = <0>;	/* unused but required */
-				bpp = <16>;	/* non-standard but required */
-			};
+&fb {
+	bits-per-pixel = <16>;
+	display-timings {
+		native-mode = <&timing0>;
+		timing0: 800x480 {
+			clock-frequency = <0>; /* unused but required */
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <40>;
+			hback-porch = <88>;
+			hsync-len = <0>;
+			vback-porch = <32>;
+			vfront-porch = <11>;
+			vsync-len = <1>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/vt8500.dtsi b/arch/arm/boot/dts/vt8500.dtsi
index cf31ced..68c8dc6 100644
--- a/arch/arm/boot/dts/vt8500.dtsi
+++ b/arch/arm/boot/dts/vt8500.dtsi
@@ -98,12 +98,10 @@
 			interrupts = <43>;
 		};
 
-		fb@d800e400 {
+		fb: fb@d8050800 {
 			compatible = "via,vt8500-fb";
 			reg = <0xd800e400 0x400>;
 			interrupts = <12>;
-			display = <&display>;
-			default-mode = <&mode0>;
 		};
 
 		ge_rops@d8050400 {
diff --git a/arch/arm/boot/dts/wm8505-ref.dts b/arch/arm/boot/dts/wm8505-ref.dts
index fd4e248..edd2cec 100644
--- a/arch/arm/boot/dts/wm8505-ref.dts
+++ b/arch/arm/boot/dts/wm8505-ref.dts
@@ -11,26 +11,22 @@
 
 / {
 	model = "Wondermedia WM8505 Netbook";
+};
 
-	/*
-	 * Display node is based on Sascha Hauer's patch on dri-devel.
-	 * Added a bpp property to calculate the size of the framebuffer
-	 * until the binding is formalized.
-	 */
-	display: display@0 {
-		modes {
-			mode0: mode@0 {
-				hactive = <800>;
-				vactive = <480>;
-				hback-porch = <88>;
-				hfront-porch = <40>;
-				hsync-len = <0>;
-				vback-porch = <32>;
-				vfront-porch = <11>;
-				vsync-len = <1>;
-				clock = <0>;	/* unused but required */
-				bpp = <32>;	/* non-standard but required */
-			};
+&fb {
+	bits-per-pixel = <32>;
+	display-timings {
+		native-mode = <&timing0>;
+		timing0: 800x480 {
+			clock-frequency = <0>; /* unused but required */
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <40>;
+			hback-porch = <88>;
+			hsync-len = <0>;
+			vback-porch = <32>;
+			vfront-porch = <11>;
+			vsync-len = <1>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/wm8505.dtsi b/arch/arm/boot/dts/wm8505.dtsi
index e74a1c0..bcf668d 100644
--- a/arch/arm/boot/dts/wm8505.dtsi
+++ b/arch/arm/boot/dts/wm8505.dtsi
@@ -128,11 +128,9 @@
 			interrupts = <0>;
 		};
 
-		fb@d8050800 {
+		fb: fb@d8050800 {
 			compatible = "wm,wm8505-fb";
 			reg = <0xd8050800 0x200>;
-			display = <&display>;
-			default-mode = <&mode0>;
 		};
 
 		ge_rops@d8050400 {
diff --git a/arch/arm/boot/dts/wm8650-mid.dts b/arch/arm/boot/dts/wm8650-mid.dts
index cefd938..61671a0 100644
--- a/arch/arm/boot/dts/wm8650-mid.dts
+++ b/arch/arm/boot/dts/wm8650-mid.dts
@@ -11,26 +11,24 @@
 
 / {
 	model = "Wondermedia WM8650-MID Tablet";
+};
+
+&fb {
+	bits-per-pixel = <16>;
 
-	/*
-	 * Display node is based on Sascha Hauer's patch on dri-devel.
-	 * Added a bpp property to calculate the size of the framebuffer
-	 * until the binding is formalized.
-	 */
-	display: display@0 {
-		modes {
-			mode0: mode@0 {
-				hactive = <800>;
-				vactive = <480>;
-				hback-porch = <88>;
-				hfront-porch = <40>;
-				hsync-len = <0>;
-				vback-porch = <32>;
-				vfront-porch = <11>;
-				vsync-len = <1>;
-				clock = <0>;	/* unused but required */
-				bpp = <16>;	/* non-standard but required */
-			};
+	display-timings {
+		native-mode = <&timing0>;
+		timing0: 800x480 {
+			clock-frequency = <0>; /* unused but required */
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <40>;
+			hback-porch = <88>;
+			hsync-len = <0>;
+			vback-porch = <32>;
+			vfront-porch = <11>;
+			vsync-len = <1>;
 		};
 	};
 };
+
diff --git a/arch/arm/boot/dts/wm8650.dtsi b/arch/arm/boot/dts/wm8650.dtsi
index db3c0a1..9313407 100644
--- a/arch/arm/boot/dts/wm8650.dtsi
+++ b/arch/arm/boot/dts/wm8650.dtsi
@@ -128,11 +128,9 @@
 			interrupts = <43>;
 		};
 
-		fb@d8050800 {
+		fb: fb@d8050800 {
 			compatible = "wm,wm8505-fb";
 			reg = <0xd8050800 0x200>;
-			display = <&display>;
-			default-mode = <&mode0>;
 		};
 
 		ge_rops@d8050400 {
diff --git a/arch/arm/boot/dts/wm8850-w70v2.dts b/arch/arm/boot/dts/wm8850-w70v2.dts
index fcc660c..32d2253 100644
--- a/arch/arm/boot/dts/wm8850-w70v2.dts
+++ b/arch/arm/boot/dts/wm8850-w70v2.dts
@@ -15,28 +15,6 @@
 / {
 	model = "Wondermedia WM8850-W70v2 Tablet";
 
-	/*
-	 * Display node is based on Sascha Hauer's patch on dri-devel.
-	 * Added a bpp property to calculate the size of the framebuffer
-	 * until the binding is formalized.
-	 */
-	display: display@0 {
-		modes {
-			mode0: mode@0 {
-				hactive = <800>;
-				vactive = <480>;
-				hback-porch = <88>;
-				hfront-porch = <40>;
-				hsync-len = <0>;
-				vback-porch = <32>;
-				vfront-porch = <11>;
-				vsync-len = <1>;
-				clock = <0>;	/* unused but required */
-				bpp = <16>;	/* non-standard but required */
-			};
-		};
-	};
-
 	backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pwm 0 50000 1>;	/* duty inverted */
@@ -45,3 +23,21 @@
 		default-brightness-level = <5>;
 	};
 };
+
+&fb {
+	bits-per-pixel = <16>;
+	display-timings {
+		native-mode = <&timing0>;
+		timing0: 800x480 {
+			clock-frequency = <0>; /* unused but required */
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <40>;
+			hback-porch = <88>;
+			hsync-len = <0>;
+			vback-porch = <32>;
+			vfront-porch = <11>;
+			vsync-len = <1>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/wm8850.dtsi b/arch/arm/boot/dts/wm8850.dtsi
index e8cbfdc..7149cd1 100644
--- a/arch/arm/boot/dts/wm8850.dtsi
+++ b/arch/arm/boot/dts/wm8850.dtsi
@@ -135,11 +135,9 @@
 			};
 		};
 
-		fb@d8051700 {
+		fb: fb@d8051700 {
 			compatible = "wm,wm8505-fb";
 			reg = <0xd8051700 0x200>;
-			display = <&display>;
-			default-mode = <&mode0>;
 		};
 
 		ge_rops@d8050400 {
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index ad762ed..d0c932a 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1794,6 +1794,9 @@ config FB_VT8500
 	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
 	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
 	select FB_SYS_IMAGEBLIT
+	select FB_MODE_HELPERS
+	select OF_DISPLAY_TIMING
+	select OF_VIDEOMODE
 	help
 	  This is the framebuffer driver for VIA VT8500 integrated LCD
 	  controller.
@@ -1804,6 +1807,9 @@ config FB_WM8505
 	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
 	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
 	select FB_SYS_IMAGEBLIT
+	select FB_MODE_HELPERS
+	select OF_DISPLAY_TIMING
+	select OF_VIDEOMODE
 	help
 	  This is the framebuffer driver for WonderMedia WM8xxx-series
 	  integrated LCD controller. This driver covers the WM8505, WM8650
diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index 2ff2312..9547e18 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -15,20 +15,21 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/dma-mapping.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/wait.h>
+#include <video/of_display_timing.h>
 
 #include "vt8500lcdfb.h"
 #include "wmt_ge_rops.h"
@@ -275,11 +276,11 @@ static int vt8500lcd_probe(struct platform_device *pdev)
 {
 	struct vt8500lcd_info *fbi;
 	struct resource *res;
+	struct display_timings *disp_timing;
 	void *addr;
 	int irq, ret;
 
 	struct fb_videomode	of_mode;
-	struct device_node	*np;
 	u32			bpp;
 	dma_addr_t fb_mem_phys;
 	unsigned long fb_mem_len;
@@ -344,32 +345,18 @@ static int vt8500lcd_probe(struct platform_device *pdev)
 		goto failed_free_res;
 	}
 
-	np = of_parse_phandle(pdev->dev.of_node, "default-mode", 0);
-	if (!np) {
-		pr_err("%s: No display description in Device Tree\n", __func__);
-		ret = -EINVAL;
-		goto failed_free_res;
-	}
+	disp_timing = of_get_display_timings(pdev->dev.of_node);
+	if (!disp_timing)
+		return -EINVAL;
 
-	/*
-	 * This code is copied from Sascha Hauer's of_videomode helper
-	 * and can be replaced with a call to the helper once mainlined
-	 */
-	ret = 0;
-	ret |= of_property_read_u32(np, "hactive", &of_mode.xres);
-	ret |= of_property_read_u32(np, "vactive", &of_mode.yres);
-	ret |= of_property_read_u32(np, "hback-porch", &of_mode.left_margin);
-	ret |= of_property_read_u32(np, "hfront-porch", &of_mode.right_margin);
-	ret |= of_property_read_u32(np, "hsync-len", &of_mode.hsync_len);
-	ret |= of_property_read_u32(np, "vback-porch", &of_mode.upper_margin);
-	ret |= of_property_read_u32(np, "vfront-porch", &of_mode.lower_margin);
-	ret |= of_property_read_u32(np, "vsync-len", &of_mode.vsync_len);
-	ret |= of_property_read_u32(np, "bpp", &bpp);
-	if (ret) {
-		pr_err("%s: Unable to read display properties\n", __func__);
-		goto failed_free_res;
-	}
-	of_mode.vmode = FB_VMODE_NONINTERLACED;
+	ret = of_get_fb_videomode(pdev->dev.of_node, &of_mode,
+							OF_USE_NATIVE_MODE);
+	if (ret)
+		return ret;
+
+	ret = of_property_read_u32(pdev->dev.of_node, "bits-per-pixel", &bpp);
+	if (ret)
+		return ret;
 
 	/* try allocating the framebuffer */
 	fb_mem_len = of_mode.xres * of_mode.yres * 2 * (bpp / 8);
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index e3be1e3..19e2e7f 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -14,23 +14,24 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
 #include <linux/fb.h>
+#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/dma-mapping.h>
-#include <linux/platform_device.h>
-#include <linux/wait.h>
+#include <linux/kernel.h>
+#include <linux/memblock.h>
+#include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
-#include <linux/memblock.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/wait.h>
+#include <video/of_display_timing.h>
 
 #include "wm8505fb_regs.h"
 #include "wmt_ge_rops.h"
@@ -261,12 +262,12 @@ static struct fb_ops wm8505fb_ops = {
 static int wm8505fb_probe(struct platform_device *pdev)
 {
 	struct wm8505fb_info	*fbi;
-	struct resource		*res;
+	struct resource	*res;
+	struct display_timings *disp_timing;
 	void			*addr;
 	int ret;
 
-	struct fb_videomode	of_mode;
-	struct device_node	*np;
+	struct fb_videomode	mode;
 	u32			bpp;
 	dma_addr_t fb_mem_phys;
 	unsigned long fb_mem_len;
@@ -306,33 +307,19 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	if (fbi->regbase == NULL)
 		return -EBUSY;
 
-	np = of_parse_phandle(pdev->dev.of_node, "default-mode", 0);
-	if (!np) {
-		pr_err("%s: No display description in Device Tree\n", __func__);
+	disp_timing = of_get_display_timings(pdev->dev.of_node);
+	if (!disp_timing)
 		return -EINVAL;
-	}
 
-	/*
-	 * This code is copied from Sascha Hauer's of_videomode helper
-	 * and can be replaced with a call to the helper once mainlined
-	 */
-	ret = 0;
-	ret |= of_property_read_u32(np, "hactive", &of_mode.xres);
-	ret |= of_property_read_u32(np, "vactive", &of_mode.yres);
-	ret |= of_property_read_u32(np, "hback-porch", &of_mode.left_margin);
-	ret |= of_property_read_u32(np, "hfront-porch", &of_mode.right_margin);
-	ret |= of_property_read_u32(np, "hsync-len", &of_mode.hsync_len);
-	ret |= of_property_read_u32(np, "vback-porch", &of_mode.upper_margin);
-	ret |= of_property_read_u32(np, "vfront-porch", &of_mode.lower_margin);
-	ret |= of_property_read_u32(np, "vsync-len", &of_mode.vsync_len);
-	ret |= of_property_read_u32(np, "bpp", &bpp);
-	if (ret) {
-		pr_err("%s: Unable to read display properties\n", __func__);
-		return -EINVAL;
-	}
+	ret = of_get_fb_videomode(pdev->dev.of_node, &mode, OF_USE_NATIVE_MODE);
+	if (ret)
+		return ret;
+
+	ret = of_property_read_u32(pdev->dev.of_node, "bits-per-pixel", &bpp);
+	if (ret)
+		return ret;
 
-	of_mode.vmode = FB_VMODE_NONINTERLACED;
-	fb_videomode_to_var(&fbi->fb.var, &of_mode);
+	fb_videomode_to_var(&fbi->fb.var, &mode);
 
 	fbi->fb.var.nonstd		= 0;
 	fbi->fb.var.activate		= FB_ACTIVATE_NOW;
@@ -341,7 +328,7 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	fbi->fb.var.width		= -1;
 
 	/* try allocating the framebuffer */
-	fb_mem_len = of_mode.xres * of_mode.yres * 2 * (bpp / 8);
+	fb_mem_len = mode.xres * mode.yres * 2 * (bpp / 8);
 	fb_mem_virt = dmam_alloc_coherent(&pdev->dev, fb_mem_len, &fb_mem_phys,
 				GFP_KERNEL);
 	if (!fb_mem_virt) {
@@ -349,8 +336,8 @@ static int wm8505fb_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	fbi->fb.var.xres_virtual	= of_mode.xres;
-	fbi->fb.var.yres_virtual	= of_mode.yres * 2;
+	fbi->fb.var.xres_virtual	= mode.xres;
+	fbi->fb.var.yres_virtual	= mode.yres * 2;
 	fbi->fb.var.bits_per_pixel	= bpp;
 
 	fbi->fb.fix.smem_start		= fb_mem_phys;
-- 
1.7.9.5

