Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab3F0MMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:12:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39801 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0MMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:12:18 -0400
Date: Thu, 27 Jun 2013 14:12:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: N900 device tree conversion: next steps
Message-ID: <20130627121213.GA17782@amd.pavel.ucw.cz>
References: <20130613132624.GA3464@amd.pavel.ucw.cz>
 <20130613141001.GF8164@atomide.com>
 <20130613142809.GA3775@amd.pavel.ucw.cz>
 <20130613145724.GH8164@atomide.com>
 <20130613155240.GB3775@amd.pavel.ucw.cz>
 <20130613161418.GJ8164@atomide.com>
 <20130613230808.GA14876@amd.pavel.ucw.cz>
 <20130614055629.GM8164@atomide.com>
 <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
 <20130617111031.GQ20992@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617111031.GQ20992@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Anyway... here's my current version, and thanks for all the help. I
> > guess I'll need to figure out clocks next, because I'd really like to
> > have video going on device.
> 
> Well DSS is still using pdata based init because of the DT bindings
> are not ready yet.

Yes, I know. But as nokia already initializes DSS "by hand", that
should not be a problem.

I have something working at this point: remaining issue was that to
get display working, tsc2005 binding has to be present. (That is true
both before and after devicetree conversion).

What would be procedure for merging the patch? Would you be able to
take it in one piece, or does it need to be split somehow?

Thanks,
								Pavel

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 9c62558..7b1a075 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -119,6 +119,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	omap3-beagle-xm.dtb \
 	omap3-evm.dtb \
 	omap3-tobi.dtb \
+	omap3-n900.dtb \
 	omap4-panda.dtb \
 	omap4-panda-a4.dtb \
 	omap4-panda-es.dtb \
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
new file mode 100644
index 0000000..c5538a6
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2013 Pavel Machek <pavel@ucw.cz>
+ * Copyright 2013 Aaro Koskinen <aaro.koskinen@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or later) as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+
+/include/ "omap34xx.dtsi"
+
+/ {
+	model = "Nokia N900";
+	compatible = "nokia,omap3-n900", "ti,omap3";
+
+	cpus {
+		cpu@0 {
+//			cpu0-supply = <&vcc>;
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x80000000 0x10000000>; /* 256 MB */
+	};
+
+};
+
+&i2c1 {
+	clock-frequency = <2200000>;
+
+	twl: twl@48 {
+		reg = <0x48>;
+		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
+		interrupt-parent = <&intc>;
+	};
+};
+
+/include/ "twl4030.dtsi"
+
+&twl_gpio {
+	ti,pullups	= <0x0>;
+	ti,pulldowns	= <0x03ff3f>; /* BIT(0..5) | BIT(8..17) */
+};
+
+&i2c2 {
+	clock-frequency = <400000>;
+};
+
+&i2c3 {
+	clock-frequency = <100000>;
+};
+
+&mmc1 {
+	status = "disabled";
+};
+
+&mmc2 {
+	status = "disabled";
+};
+
+&mmc3 {
+	status = "disabled";
+};
+
+&mcspi1 {
+	// For some reason, touchscreen is neccessary for screen to work at 
+	// all on real hw. It works well without it on emulator.
+	//
+	// Also... order in the device tree actually matters here.
+	tsc2005@0 {
+		compatible = "tsc2005";
+		spi-max-frequency = <6000000>;
+		reg = <0>;
+	};
+	mipid@2 {
+		compatible = "acx565akm";
+		spi-max-frequency = <6000000>;
+		reg = <2>;
+		// turbo_mode = 0,
+		// cs_per_word = 0
+	};
+};
+
+/*
+&usb_otg_hs {
+	interface-type = <0>;
+	usb-phy = <&usb2_phy>;
+	mode = <2>;
+	power = <50>;
+};
+*/
diff --git a/arch/arm/boot/dts/omap34xx.dtsi b/arch/arm/boot/dts/omap34xx.dtsi
new file mode 100644
index 0000000..75ed4ae
--- /dev/null
+++ b/arch/arm/boot/dts/omap34xx.dtsi
@@ -0,0 +1,28 @@
+/*
+ * Device Tree Source for OMAP34xx/OMAP35xx SoC
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "omap3.dtsi"
+
+/ {
+	cpus {
+		cpu@0 {
+			/* OMAP343x/OMAP35xx variants OPP1-5 */
+			operating-points = <
+				/* kHz    uV */
+				125000   975000
+				250000  1075000
+				500000  1200000
+				550000  1270000
+				600000  1350000
+			>;
+			clock-latency = <300000>; /* From legacy driver */
+		};
+	};
+};
diff --git a/arch/arm/mach-omap2/board-rx51-compat.c b/arch/arm/mach-omap2/board-rx51-compat.c
index 0ffa909..f4223ff 100644
--- a/arch/arm/mach-omap2/board-rx51-compat.c
+++ b/arch/arm/mach-omap2/board-rx51-compat.c
@@ -131,6 +131,7 @@ static long twl4030_madc_ioctl(struct file *filp, unsigned int cmd,
 
 	switch (cmd) {
 	case TWL4030_MADC_IOCX_ADC_RAW_READ: {
+#if 0
 		struct twl4030_madc_request req;
 		if (par.channel >= TWL4030_MADC_MAX_CHANNELS)
 			return -EINVAL;
@@ -151,6 +152,9 @@ static long twl4030_madc_ioctl(struct file *filp, unsigned int cmd,
 		} else {
 			par.status = val;
 		}
+#else
+		panic("no raw readings from adc"); 
+#endif
 		break;
 	}
 	default:
diff --git a/arch/arm/mach-omap2/board-rx51-video.c b/arch/arm/mach-omap2/board-rx51-video.c
index eb66726..4c834c1 100644
--- a/arch/arm/mach-omap2/board-rx51-video.c
+++ b/arch/arm/mach-omap2/board-rx51-video.c
@@ -68,7 +68,7 @@ static struct omap_dss_board_info rx51_dss_board_info = {
 
 static int __init rx51_video_init(void)
 {
-	if (!machine_is_nokia_rx51())
+	if (!machine_is_nokia_rx51() && !of_machine_is_compatible("nokia,omap3-n900"))
 		return 0;
 
 	if (omap_mux_init_gpio(RX51_LCD_RESET_GPIO, OMAP_PIN_OUTPUT)) {
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index 74f83a5..81f7b9f 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -33,9 +33,12 @@
 #include "pm.h"
 #include "sdram-nokia.h"
 #include "board-rx51-secure.h"
+#include "soc.h"
 
 #define RX51_GPIO_SLEEP_IND 162
 
+/* This lights up left part of keyboard */
+
 static struct gpio_led gpio_leds[] = {
 	{
 		.name	= "sleep_ind",
@@ -107,9 +110,11 @@ static void __init rx51_init(void)
 	rx51_camera_init();
 
 #ifdef CONFIG_ARM_ERRATA_430973
-	printk(KERN_INFO "RX-51: Enabling ARM errata 430973 workaround.\n");
-	/* set IBE to 1 */
-	rx51_secure_update_aux_cr(1 << 6, 0);
+	if (omap_type() == OMAP2_DEVICE_TYPE_SEC) {
+		printk(KERN_INFO "RX-51: Enabling ARM errata 430973 workaround.\n");
+		/* set IBE to 1 */
+		rx51_secure_update_aux_cr(1 << 6, 0);
+	}
 #endif
 
 	/* Ensure SDRC pins are mux'd for self-refresh */
@@ -124,6 +129,7 @@ static void __init rx51_reserve(void)
 	omap_reserve();
 }
 
+#if 0
 MACHINE_START(NOKIA_RX51, "Nokia RX-51 board")
 	/* Maintainer: Lauri Leukkunen <lauri.leukkunen@nokia.com> */
 	.atag_offset	= 0x100,
@@ -137,3 +143,4 @@ MACHINE_START(NOKIA_RX51, "Nokia RX-51 board")
 	.init_time	= omap3_sync32k_timer_init,
 	.restart	= omap3xxx_restart,
 MACHINE_END
+#endif
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -396,7 +396,7 @@ static int rx51_soc_probe(struct platform_device *pdev)
 	struct snd_soc_card *card = &rx51_sound_card;
 	int err;
 
-	if (!machine_is_nokia_rx51())
+	if (!machine_is_nokia_rx51() && !of_machine_is_compatible("nokia,omap3-n900"))
 		return -ENODEV;
 
 	err = gpio_request_one(RX51_TVOUT_SEL_GPIO,


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
