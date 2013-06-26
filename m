Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3FZPOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:14:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45563 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZPO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:14:29 -0400
Date: Wed, 26 Jun 2013 17:14:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: N900 device tree conversion: first step
Message-ID: <20130626151426.GA1440@amd.pavel.ucw.cz>
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

Hi!

After major fight, I ended up with patch that can be posted to the
mailing list without major risk, and where video still works on
emulator & real hardware...

So... here it is.

One hack that is still neccessary is old-style spi init. Without that,
I get display on emulator, but not on actual hardware. Bad. Ideas
welcome.

Oh and this all is with very reduced .config.

Not for merge, but

Signed-off-by: Pavel Machek <pavel@ucw.cz>

Enjoy :-),
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
index 0000000..3918ae1
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -0,0 +1,83 @@
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
+	mipid@2 {
+		compatible = "acx565akm";
+		spi-max-frequency = <6000000>;
+		reg = <2>;
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
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index e54a480..5aacde2 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -21,6 +21,10 @@
 #include "common.h"
 #include "common-board-devices.h"
 #include "dss-common.h"
+#include "sdram-nokia.h"
+#include "soc.h"
+#include "board-rx51-secure.h"
+#include <linux/regulator/machine.h>
 
 #if !(defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3))
 #define intc_of_init	NULL
@@ -35,20 +39,57 @@ static struct of_device_id omap_dt_match_table[] __initdata = {
 	{ }
 };
 
-static void __init omap_generic_init(void)
+extern void rx51_init_base(void);
+extern void rx51_init(void);
+extern int __init rx51_i2c_init(void);
+extern void __init rx51_peripherals_init(void);
+extern void __init rx51_spi_init(void);
+
+
+void __init omap_generic_init(void)
 {
-	omap_sdrc_init(NULL, NULL);
+	struct omap_sdrc_params *sdrc_params;
+
+#ifdef CONFIG_ARM_ERRATA_430973
+	if (omap_type() == OMAP2_DEVICE_TYPE_SEC) {
+		printk(KERN_INFO "RX-51: Enabling ARM errata 430973 workaround.\n");
+		/* set IBE to 1 */
+		rx51_secure_update_aux_cr(1 << 6, 0);
+	} else {
+		extern bool early_print_redirect;
+
+		early_print_redirect = 1;
+	}
+#endif
 
+	sdrc_params = nokia_get_sdram_timings();
+	omap_sdrc_init(sdrc_params, sdrc_params);
+
+#if 1
+	printk("*** omap: populating platform\n");
 	of_platform_populate(NULL, omap_dt_match_table, NULL, NULL);
+#endif
 
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
+		regulator_use_dummy_regulator(); 
+		rx51_spi_init();
+		return;
+	}
+	panic("really want to init video\n");
+#endif
 }
 
 #ifdef CONFIG_SOC_OMAP2420
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
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 64485d7..cc6c2e8 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -1647,6 +1647,12 @@ fail:
 	printk(KERN_ERR "Bluetooth device registration failed\n");
 }
 
+void __init rx51_spi_init(void)
+{
+	spi_register_board_info(rx51_peripherals_spi_board_info,
+				ARRAY_SIZE(rx51_peripherals_spi_board_info));
+}
+
 void __init rx51_peripherals_init(void)
 {
 	rx51_i2c_init();
@@ -1664,8 +1670,7 @@ void __init rx51_peripherals_init(void)
 	rx51_cmt_init();
 	rx51_ssi_init();
 	rx51_bt_init();
-	spi_register_board_info(rx51_peripherals_spi_board_info,
-				ARRAY_SIZE(rx51_peripherals_spi_board_info));
+	rx51_spi_init();
 
 	partition = omap_mux_get("core");
 	if (partition)
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
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 0b6260a1..7959946 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -39,6 +39,8 @@
 #include "devices.h"
 #include "dma.h"
 
+#define OF_DT 0
+
 #define L3_MODULES_MAX_LEN 12
 #define L3_MODULES 3
 
@@ -764,7 +766,7 @@ static inline void omap_init_ocp2scp(void) { }
 static int __init omap2_init_devices(void)
 {
 	/* Enable dummy states for those platforms without pinctrl support */
-	if (!of_have_populated_dt())
+	if (!OF_DT)
 		pinctrl_provide_dummies();
 
 	/*
diff --git a/drivers/video/omap2/dss/sdi.c b/drivers/video/omap2/dss/sdi.c
index 62b5374..081838b 100644
--- a/drivers/video/omap2/dss/sdi.c
+++ b/drivers/video/omap2/dss/sdi.c
@@ -194,6 +194,7 @@ static int __init sdi_init_display(struct omap_dss_device *dssdev)
 		if (IS_ERR(vdds_sdi)) {
 			DSSERR("can't get VDDS_SDI regulator\n");
 			return PTR_ERR(vdds_sdi);
+//			return 0;
 		}
 
 		sdi.vdds_sdi_reg = vdds_sdi;
diff --git a/kernel/printk.c b/kernel/printk.c
index abbdd9e..dc3c6bc 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -757,11 +757,24 @@ static int __init ignore_loglevel_setup(char *str)
 	return 0;
 }
 
+bool __read_mostly early_print_redirect;
+
+static int __init early_print_setup(char *str)
+{
+	early_print_redirect = 1;
+	early_printk("copying printk to early_printk\n");
+
+	return 0;
+}
+
+
 early_param("ignore_loglevel", ignore_loglevel_setup);
 module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
 	"print all kernel messages to the console.");
 
+early_param("early_print", early_print_setup);
+
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static int boot_delay; /* msecs delay after each printk during bootup */
@@ -1265,6 +1278,12 @@ static void call_console_drivers(int level, const char *text, size_t len)
 {
 	struct console *con;
 
+	if (early_print_redirect) {
+                int i;
+		for (i=0; i<len; i++)
+                        early_printk("%c", text[i]);
+        }
+
 	trace_console(text, 0, len, len);
 
 	if (level >= console_loglevel && !ignore_loglevel)
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
