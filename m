Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3FMO2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:28:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38863 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3FMO2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 10:28:13 -0400
Date: Thu, 13 Jun 2013 16:28:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130613142809.GA3775@amd.pavel.ucw.cz>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
 <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
 <20130613132624.GA3464@amd.pavel.ucw.cz>
 <20130613141001.GF8164@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613141001.GF8164@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-06-13 07:10:01, Tony Lindgren wrote:
> * Pavel Machek <pavel@ucw.cz> [130613 06:32]:
> > Hi!
> > 
> > > > I'd like to convert Nokia N900 to device tree.
> > > > 
> > > > Unfortunately, serial port is not easily available (very special cable
> > > > would be needed, does someone know where to get one?) and I don't have
> > > > BDI (and very special cable would be needed, too).
> > > > 
> > > > So I tried doing very small first step, hoping that I get booting
> > > > system... obviously I did not.
> > > 
> > > The following works for me, it's enough to boot and get the USB networking
> > > working. After that I can connect to the device with ssh. I don't use
> > > serial either, I just have initramfs with busybox+dropbear with hardcoded
> > > interface setup.
> > 
> > Nice.... thanks a lot.
> > 
> > Did you get video to work with the device tree? That's what I'd like
> > to accomplish now.
> 
> The DSS code is still using pdata, see mach-omap2/dss-common.[ch].
>  
> > If I init spi manually (and some more hacks), it works in the
> > qemu. But I have not tested on real hw for a while.
> 
> You should be able to initialize spi by adding the .dts entry,
> or is there something missing in drivers/spi/spi-omap2-mcspi.c?

Not sure, I guess I'll find out soon. Do you have example dts that
uses drivers/spi/spi-omap2-mcspi.c? Grepping spi in dts/ was not too
successful.

This is what I'm doing currently...

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
index 0000000..10a880f
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -0,0 +1,75 @@
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
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index e54a480..996ffc3 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -22,6 +22,12 @@
 #include "common-board-devices.h"
 #include "dss-common.h"
 
+#include "mux.h"
+#include <linux/spi/spi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
+#include <linux/platform_data/mtd-onenand-omap2.h>
+#include <linux/regulator/machine.h>
+
 #if !(defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3))
 #define intc_of_init	NULL
 #endif
@@ -35,20 +41,105 @@ static struct of_device_id omap_dt_match_table[] __initdata = {
 	{ }
 };
 
-static void __init omap_generic_init(void)
+#if 1
+
+/* list all spi devices here */
+enum {
+	RX51_SPI_MIPID,		/* LCD panel */
+	RX51_SPI_WL1251,
+	RX51_SPI_TSC2005,	/* Touch Controller */
+};
+
+static struct omap2_mcspi_device_config wl1251_mcspi_config = {
+	.turbo_mode	= 0,
+};
+
+static struct omap2_mcspi_device_config mipid_mcspi_config = {
+	.turbo_mode	= 0,
+};
+
+static struct omap2_mcspi_device_config tsc2005_mcspi_config = {
+	.turbo_mode	= 0,
+};
+
+#if 0
+static struct wl12xx_platform_data wl1251_pdata;
+static struct tsc2005_platform_data tsc2005_pdata;
+#endif
+
+static struct spi_board_info rx51_peripherals_spi_board_info[] __initdata = {
+#if 0
+	/* Wireless */
+	[RX51_SPI_WL1251] = {
+		.modalias		= "wl1251",
+		.bus_num		= 4,
+		.chip_select		= 0,
+		.max_speed_hz   	= 48000000,
+		.mode                   = SPI_MODE_3,
+		.controller_data	= &wl1251_mcspi_config,
+		.platform_data		= &wl1251_pdata,
+	},
+#endif
+	[RX51_SPI_MIPID] = {
+		.modalias		= "acx565akm",
+		.bus_num		= 1,
+		.chip_select		= 2,
+		.max_speed_hz		= 6000000,
+		.controller_data	= &mipid_mcspi_config,
+	},
+#if 0
+	/* Touchscreen */
+	[RX51_SPI_TSC2005] = {
+		.modalias		= "tsc2005",
+		.bus_num		= 1,
+		.chip_select		= 0,
+		.max_speed_hz		= 6000000,
+		.controller_data	= &tsc2005_mcspi_config,
+		.platform_data		= &tsc2005_pdata,
+	},
+#endif
+};
+
+static struct omap_board_mux board_mux[] __initdata = {
+	{ .reg_offset = OMAP_MUX_TERMINATOR },
+};
+#endif
+
+extern int rx51_video_init(void);
+
+void __init omap_generic_init(void)
 {
 	omap_sdrc_init(NULL, NULL);
-
 	of_platform_populate(NULL, omap_dt_match_table, NULL, NULL);
 
 	/*
 	 * HACK: call display setup code for selected boards to enable omapdss.
 	 * This will be removed when omapdss supports DT.
 	 */
-	if (of_machine_is_compatible("ti,omap4-panda"))
+	if (of_machine_is_compatible("ti,omap4-panda")) {
 		omap4_panda_display_init_of();
-	else if (of_machine_is_compatible("ti,omap4-sdp"))
+		return;
+	}
+	if (of_machine_is_compatible("ti,omap4-sdp")) {
 		omap_4430sdp_display_init_of();
+		return;
+	}
+#ifdef CONFIG_MACH_NOKIA_RX51
+	if (of_machine_is_compatible("nokia,omap3-n900")) {
+#if 1
+		regulator_use_dummy_regulator();
+
+		omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
+
+		spi_register_board_info(rx51_peripherals_spi_board_info,
+				ARRAY_SIZE(rx51_peripherals_spi_board_info));
+#else
+		rx51_video_init();
+#endif
+		return;
+	}
+	panic("really want to init video\n");
+#endif
 }
 
 #ifdef CONFIG_SOC_OMAP2420
diff --git a/arch/arm/mach-omap2/board-rx51-video.c b/arch/arm/mach-omap2/board-rx51-video.c
index eb66726..022bff0 100644
--- a/arch/arm/mach-omap2/board-rx51-video.c
+++ b/arch/arm/mach-omap2/board-rx51-video.c
@@ -68,7 +68,7 @@ static struct omap_dss_board_info rx51_dss_board_info = {
 
 static int __init rx51_video_init(void)
 {
-	if (!machine_is_nokia_rx51())
+	if (!of_machine_is_compatible("nokia,omap3-n900"))
 		return 0;
 
 	if (omap_mux_init_gpio(RX51_LCD_RESET_GPIO, OMAP_PIN_OUTPUT)) {
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index 74f83a5..ee001e2 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -36,6 +36,8 @@
 
 #define RX51_GPIO_SLEEP_IND 162
 
+/* This lights up left part of keyboard */
+
 static struct gpio_led gpio_leds[] = {
 	{
 		.name	= "sleep_ind",
@@ -91,49 +93,69 @@ static struct omap_musb_board_data musb_board_data = {
 	.power			= 0,
 };
 
-static void __init rx51_init(void)
+void rx51_init_base(void)
 {
 	struct omap_sdrc_params *sdrc_params;
-
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
-	omap_serial_init();
 
+#if 0
 	sdrc_params = nokia_get_sdram_timings();
 	omap_sdrc_init(sdrc_params, sdrc_params);
+#endif
+}
+
+void __init rx51_init(void)
+{
+	printk("rx_init: n900 starting\n");
+
+	rx51_init_base();
+#if 0
+	omap_serial_init();
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(&musb_board_data);
+#endif
 	rx51_peripherals_init();
-	rx51_camera_init();
+//	rx51_camera_init();
 
+#if 0
 #ifdef CONFIG_ARM_ERRATA_430973
 	printk(KERN_INFO "RX-51: Enabling ARM errata 430973 workaround.\n");
 	/* set IBE to 1 */
 	rx51_secure_update_aux_cr(1 << 6, 0);
 #endif
+#endif
 
+	/* FIXME: keep those? */
 	/* Ensure SDRC pins are mux'd for self-refresh */
-	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
-	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
+//	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
+//	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
 
-	platform_device_register(&leds_gpio);
+//	platform_device_register(&leds_gpio);
 }
 
-static void __init rx51_reserve(void)
-{
-	omap_reserve();
-}
+static const char *omap3_boards_compat[] __initdata = {
+	"nokia,omap3-n900",
+        NULL,
+};
+
 
-MACHINE_START(NOKIA_RX51, "Nokia RX-51 board")
-	/* Maintainer: Lauri Leukkunen <lauri.leukkunen@nokia.com> */
-	.atag_offset	= 0x100,
-	.reserve	= rx51_reserve,
+extern void __init omap_generic_init(void);
+
+DT_MACHINE_START(NOKIA_RX51_DT, "Nokia N900 (Flattened Device Tree)")
+	.reserve	= omap_reserve,
 	.map_io		= omap3_map_io,
-	.init_early	= omap3430_init_early,
-	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
-	.init_machine	= rx51_init,
-	.init_late	= omap3430_init_late,
-	.init_time	= omap3_sync32k_timer_init,
-	.restart	= omap3xxx_restart,
+	.init_early     = omap3430_init_early,
+	.init_irq       = omap_intc_of_init, 
+	.handle_irq     = omap3_intc_handle_irq,
+	.init_machine   = 
+#if 0
+			  rx51_init, 
+#else
+			  omap_generic_init,
+#endif
+	.init_late      = omap3_init_late,
+	.init_time      = omap3_sync32k_timer_init,
+	.dt_compat      = omap3_boards_compat,
+	.restart        = omap3xxx_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 0b6260a1..e300c18 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -764,7 +764,7 @@ static inline void omap_init_ocp2scp(void) { }
 static int __init omap2_init_devices(void)
 {
 	/* Enable dummy states for those platforms without pinctrl support */
-	if (!of_have_populated_dt())
+	if (1) /* FIXME */
 		pinctrl_provide_dummies();
 
 	/*
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index e4842c3..026de91 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -396,8 +396,10 @@ static int rx51_soc_probe(struct platform_device *pdev)
 	struct snd_soc_card *card = &rx51_sound_card;
 	int err;
 
-	if (!machine_is_nokia_rx51())
+	if (!of_machine_is_compatible("nokia,omap3-n900")) {
+		printk("FIXME: rx51_soc_probe on non-nokia\n");
 		return -ENODEV;
+	}
 
 	err = gpio_request_one(RX51_TVOUT_SEL_GPIO,
 			       GPIOF_DIR_OUT | GPIOF_INIT_LOW, "tvout_sel");


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
