Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3FNV2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:28:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43292 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3FNV2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:28:18 -0400
Date: Fri, 14 Jun 2013 23:28:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
 <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
 <20130613132624.GA3464@amd.pavel.ucw.cz>
 <20130613141001.GF8164@atomide.com>
 <20130613142809.GA3775@amd.pavel.ucw.cz>
 <20130613145724.GH8164@atomide.com>
 <20130613155240.GB3775@amd.pavel.ucw.cz>
 <20130613161418.GJ8164@atomide.com>
 <20130613230808.GA14876@amd.pavel.ucw.cz>
 <20130614055629.GM8164@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614055629.GM8164@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Pavel Machek <pavel@ucw.cz> [130613 16:14]:
> > Hi!
> > 
> > > > Now, by chance, any idea what is DT equivalent of 
> > > > 
> > > > omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
> > > 
> > > You can try the attached hack after calling the above to grep for
> > > pins in /sys/kernel/debug/omap_mux/board/core and you get the pins
> > > in DT suitable format. There's a bug where the the pins are not
> > > correctly split between core and wkup domains in the legacy mux fwk,
> > > but you probably won't need to mux many wkup domain pins.
> > > 
> > > Then you just need to add the pinctr-single entries for each device,
> > > but AFAIK most of the pins are muxed correctly in the bootloader
> > > for the Nokia boards.
> > 
> > Thanks a lot for the help. So far, I'm not playing with
> > suspend/resume, so wkup/core split should not be issue (right?).
> 
> Well if you have any wkup mux registers mapped for core mux,
> pinctrl-single will complain about offset being out of range
> and not set the values. You can see that in dmesg, or at least
> with CONFIG_DEBUG_PINCTRL set.

You are right, I did not have CONFIG_DEBUG_PINCTRL. (What is worse, I
did not even have CONFIG_PINCTRL set. Oops. I did not realize it needs
to be explicitely enabled. Unfortunately, when unkown elements of
device tree are encountered, no warning is given. ... OTOH I guess
that's understandable).

What is worse... bootloader already sets up pinctrls relevant to video
correctly... Again, that is understandable, as it already displayed
the splash screen. So this:

        if (omap_mux_init_gpio(RX51_LCD_RESET_GPIO, OMAP_PIN_OUTPUT))
        {
                pr_err("%s cannot configure MUX for LCD RESET\n",  __func__);
                return 0;
        }

was breaking my video.

I now have somehow-valid-looking pinctrl assignments, but no way to
test them :-(.

> > How does it work with the devices? AFAICT omap4 groups it logically,
> > but that's just for easy reading, no?
> 
> No, there really are two instances of mux registers even on omap3,
> but I missed that earlier while reading the docs, and with the legacy
> mux framework it does not matter which mux domain it is. But it
> matters for pinctrl-single as it ioremaps the ranges separately.

Yes, you are right, with debugging prints it was easy to fix.

> > +		all_pins: pinmux_all_pins {
> > +		    pinctrl-single,pins = <
> > +			0xe6 0x4104	/* cam_d0.gpio_99 gpio99 INPUT | OFF_WAKEUPENABLE | MODE4 */
> > +			0xe8 0x11c	/* cam_d1.gpio_100 gpio100 INPUT_PULLUP | MODE4 */
> > +			0xfa 0x7	/* cam_d10.safe_mode gpio109 OUTPUT | MODE7 */
> ...
> 
> This is not a good way of doing muxing, hogging all the pins under
> omap3_pmx_core will make it impossible to unload pinctrl-single
> as a module, which is not nice for distros and developers.

Does omap4 do it correctly? I don't see how that works :-(.

Also... I split normal pins and wakeup pins, but I'll need to
substract some value from wakeup pins... I guess that's 0x9d0?

Anyway... here's my current version, and thanks for all the help. I
guess I'll need to figure out clocks next, because I'd really like to
have video going on device.


diff --git a/.config b/.config
index f673799..e1c9af0 100644
--- a/.config
+++ b/.config
@@ -1460,10 +1460,10 @@ CONFIG_PINCTRL=y
 #
 # Pin controllers
 #
-# CONFIG_PINMUX is not set
-# CONFIG_PINCONF is not set
-# CONFIG_DEBUG_PINCTRL is not set
-# CONFIG_PINCTRL_SINGLE is not set
+CONFIG_PINMUX=y
+CONFIG_PINCONF=y
+CONFIG_DEBUG_PINCTRL=y
+CONFIG_PINCTRL_SINGLE=y
 # CONFIG_PINCTRL_EXYNOS is not set
 # CONFIG_PINCTRL_EXYNOS5440 is not set
 CONFIG_ARCH_HAVE_CUSTOM_GPIO_H=y
@@ -3052,8 +3052,7 @@ CONFIG_STACKTRACE=y
 # CONFIG_DEBUG_KOBJECT is not set
 # CONFIG_DEBUG_HIGHMEM is not set
 CONFIG_DEBUG_BUGVERBOSE=y
-CONFIG_DEBUG_INFO=y
-CONFIG_DEBUG_INFO_REDUCED=y
+# CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
 # CONFIG_DEBUG_MEMORY_INIT is not set
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 10a880f..4edcb91 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -65,6 +65,14 @@
 	status = "disabled";
 };
 
+&mcspi1 {
+	mipid@2 {
+		compatible = "acx565akm";
+		spi-max-frequency = <6000000>;
+		reg = <2>;
+	};
+};
+
 /*
 &usb_otg_hs {
 	interface-type = <0>;
@@ -73,3 +81,232 @@
 	power = <50>;
 };
 */
+
+
+
+&omap3_pmx_core {
+		pinctrl-names = "default";
+		pinctrl-0 = <
+			&all_pins
+		>;
+
+		all_pins: pinmux_all_pins {
+		    pinctrl-single,pins = <
+			0xe6 0x4104	/* cam_d0.gpio_99 gpio99 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xe8 0x11c	/* cam_d1.gpio_100 gpio100 INPUT_PULLUP | MODE4 */
+			0xfa 0x7	/* cam_d10.safe_mode gpio109 OUTPUT | MODE7 */
+			0xfc 0x4104	/* cam_d11.gpio_110 gpio110 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xea 0xc104	/* cam_d2.gpio_101 gpio101 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xec 0x4	/* cam_d3.gpio_102 gpio102 OUTPUT | MODE4 */
+			0xee 0x7	/* cam_d4.safe_mode gpio103 OUTPUT | MODE7 */
+			0xf0 0x4	/* cam_d5.gpio_104 gpio104 OUTPUT | MODE4 */
+			0xf2 0x100	/* cam_d6.cam_d6 gpio105 INPUT | MODE0 */
+			0xf4 0x100	/* cam_d7.cam_d7 gpio106 INPUT | MODE0 */
+			0xf6 0x100	/* cam_d8.cam_d8 gpio107 INPUT | MODE0 */
+			0xf8 0x100	/* cam_d9.cam_d9 gpio108 INPUT | MODE0 */
+			0xe4 0x4	/* cam_fld.gpio_98 gpio98 OUTPUT | MODE4 */
+			0xdc 0x7	/* cam_hs.safe_mode gpio94 OUTPUT | MODE7 */
+			0xe2 0x4	/* cam_pclk.gpio_97 gpio97 OUTPUT | MODE4 */
+			0x102 0x0	/* cam_strobe.cam_strobe gpio126 OUTPUT | MODE0 */
+			0xde 0x7	/* cam_vs.safe_mode gpio95 OUTPUT | MODE7 */
+			0x100 0x104	/* cam_wen.gpio_167 gpio167 INPUT | MODE4 */
+			0xe0 0x0	/* cam_xclka.cam_xclka gpio96 OUTPUT | MODE0 */
+			0xfe 0x7	/* cam_xclkb.safe_mode gpio111 OUTPUT | MODE7 */
+			0x104 0x7	/* csi2_dx0.safe_mode gpio112 OUTPUT | MODE7 */
+			0x108 0x7	/* csi2_dx1.safe_mode gpio114 OUTPUT | MODE7 */
+			0x106 0x4104	/* csi2_dy0.gpio_113 gpio113 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x10a 0x7	/* csi2_dy1.safe_mode gpio115 OUTPUT | MODE7 */
+			0xaa 0x4104	/* dss_acbias.gpio_69 gpio69 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xac 0x4	/* dss_data0.gpio_70 gpio70 OUTPUT | MODE4 */
+			0xae 0x4114	/* dss_data1.gpio_71 gpio71 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xc0 0x1	/* dss_data10.(null) gpio80 OUTPUT | MODE1 */
+			0xc2 0x1	/* dss_data11.(null) gpio81 OUTPUT | MODE1 */
+			0xc4 0x1	/* dss_data12.(null) gpio82 OUTPUT | MODE1 */
+			0xc6 0x1	/* dss_data13.(null) gpio83 OUTPUT | MODE1 */
+			0xc8 0x7	/* dss_data14.safe_mode gpio84 OUTPUT | MODE7 */
+			0xca 0x7	/* dss_data15.safe_mode gpio85 OUTPUT | MODE7 */
+			0xcc 0x4	/* dss_data16.gpio_86 gpio86 OUTPUT | MODE4 */
+			0xce 0x4	/* dss_data17.gpio_87 gpio87 OUTPUT | MODE4 */
+			0xd0 0x4	/* dss_data18.gpio_88 gpio88 OUTPUT | MODE4 */
+			0xd2 0x4104	/* dss_data19.gpio_89 gpio89 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xd4 0x4	/* dss_data20.gpio_90 gpio90 OUTPUT | MODE4 */
+			0xd6 0x4	/* dss_data21.gpio_91 gpio91 OUTPUT | MODE4 */
+			0xd8 0x1	/* dss_data22.(null) gpio92 OUTPUT | MODE1 */
+			0xda 0x1	/* dss_data23.(null) gpio93 OUTPUT | MODE1 */
+			0xb0 0x4104	/* dss_data2.gpio_72 gpio72 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xb2 0x4	/* dss_data3.gpio_73 gpio73 OUTPUT | MODE4 */
+			0xb4 0x10c	/* dss_data4.gpio_74 gpio74 INPUT_PULLDOWN | MODE4 */
+			0xb6 0x371c	/* dss_data5.gpio_75 gpio75 INPUT_PULLUP | OFF_OUTPUT_LOW | MODE4 */
+			0xb8 0x7	/* dss_data6.safe_mode gpio76 OUTPUT | MODE7 */
+			0xba 0x7	/* dss_data7.safe_mode gpio77 OUTPUT | MODE7 */
+			0xbc 0x7	/* dss_data8.safe_mode gpio78 OUTPUT | MODE7 */
+			0xbe 0x7	/* dss_data9.safe_mode gpio79 OUTPUT | MODE7 */
+			0xa6 0x4	/* dss_hsync.gpio_67 gpio67 OUTPUT | MODE4 */
+			0xa4 0x7	/* dss_pclk.safe_mode gpio66 OUTPUT | MODE7 */
+			0xa8 0x104	/* dss_vsync.gpio_68 gpio68 INPUT | MODE4 */
+			0x5a8 0x114	/* etk_clk.gpio_12 gpio12 INPUT | MODE4 */
+			0x5aa 0x7	/* etk_ctl.(null) gpio13 OUTPUT | MODE7 */
+			0x5ac 0x7	/* etk_d0.(null) gpio14 OUTPUT | MODE7 */
+			0x5ae 0x7	/* etk_d1.(null) gpio15 OUTPUT | MODE7 */
+			0x5c0 0x11b	/* etk_d10.hsusb2_clk gpio24 INPUT_PULLUP | MODE3 */
+			0x5c2 0x7	/* etk_d11.(null) gpio25 OUTPUT | MODE7 */
+			0x5c4 0x17	/* etk_d12.(null) gpio26 OUTPUT | MODE7 */
+			0x5c6 0x11b	/* etk_d13.hsusb2_nxt gpio27 INPUT_PULLUP | MODE3 */
+			0x5c8 0x114	/* etk_d14.gpio_28 gpio28 INPUT | MODE4 */
+			0x5ca 0x114	/* etk_d15.gpio_29 gpio29 INPUT | MODE4 */
+			0x5b0 0x7	/* etk_d2.(null) gpio16 OUTPUT | MODE7 */
+			0x5b2 0x7	/* etk_d3.(null) gpio17 OUTPUT | MODE7 */
+			0x5b4 0x17	/* etk_d4.(null) gpio18 OUTPUT | MODE7 */
+			0x5b6 0x7	/* etk_d5.(null) gpio19 OUTPUT | MODE7 */
+			0x5b8 0x7	/* etk_d6.(null) gpio20 OUTPUT | MODE7 */
+			0x5ba 0x7	/* etk_d7.(null) gpio21 OUTPUT | MODE7 */
+			0x5bc 0x7	/* etk_d8.(null) gpio22 OUTPUT | MODE7 */
+			0x5be 0x7	/* etk_d9.(null) gpio23 OUTPUT | MODE7 */
+			0x4a 0x0	/* gpmc_a1.gpmc_a1 gpio34 OUTPUT | MODE0 */
+			0x5c 0x411c	/* gpmc_a10.gpio_43 gpio43 INPUT_PULLUP | OFF_WAKEUPENABLE | MODE4 */
+			0x4c 0x0	/* gpmc_a2.gpmc_a2 gpio35 OUTPUT | MODE0 */
+			0x4e 0x0	/* gpmc_a3.gpmc_a3 gpio36 OUTPUT | MODE0 */
+			0x50 0x4	/* gpmc_a4.gpio_37 gpio37 OUTPUT | MODE4 */
+			0x52 0x7	/* gpmc_a5.safe_mode gpio38 OUTPUT | MODE7 */
+			0x54 0x7	/* gpmc_a6.safe_mode gpio39 OUTPUT | MODE7 */
+			0x56 0x4	/* gpmc_a7.gpio_40 gpio40 OUTPUT | MODE4 */
+			0x58 0x4	/* gpmc_a8.gpio_41 gpio41 OUTPUT | MODE4 */
+			0x5a 0x4104	/* gpmc_a9.gpio_42 gpio42 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x8e 0x100	/* gpmc_clk.gpmc_clk gpio59 INPUT | MODE0 */
+			0x72 0x100	/* gpmc_d10.gpmc_d10 gpio46 INPUT | MODE0 */
+			0x74 0x100	/* gpmc_d11.gpmc_d11 gpio47 INPUT | MODE0 */
+			0x76 0x100	/* gpmc_d12.gpmc_d12 gpio48 INPUT | MODE0 */
+			0x78 0x100	/* gpmc_d13.gpmc_d13 gpio49 INPUT | MODE0 */
+			0x7a 0x100	/* gpmc_d14.gpmc_d14 gpio50 INPUT | MODE0 */
+			0x7c 0x100	/* gpmc_d15.gpmc_d15 gpio51 INPUT | MODE0 */
+			0x6e 0x100	/* gpmc_d8.gpmc_d8 gpio44 INPUT | MODE0 */
+			0x70 0x100	/* gpmc_d9.gpmc_d9 gpio45 INPUT | MODE0 */
+			0x96 0x4	/* gpmc_nbe0_cle.gpio_60 gpio60 OUTPUT | MODE4 */
+			0x98 0x4104	/* gpmc_nbe1.gpio_61 gpio61 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x80 0x18	/* gpmc_ncs1.gpmc_ncs1 gpio52 OUTPUT | MODE0 */
+			0x82 0x410c	/* gpmc_ncs2.gpio_53 gpio53 INPUT_PULLDOWN | OFF_WAKEUPENABLE | MODE4 */
+			0x84 0x10c	/* gpmc_ncs3.gpio_54 gpio54 INPUT_PULLDOWN | MODE4 */
+			0x86 0x4104	/* gpmc_ncs4.gpio_55 gpio55 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x88 0x7	/* gpmc_ncs5.safe_mode gpio56 OUTPUT | MODE7 */
+			0x8a 0x7	/* gpmc_ncs6.safe_mode gpio57 OUTPUT | MODE7 */
+			0x8c 0x7	/* gpmc_ncs7.safe_mode gpio58 OUTPUT | MODE7 */
+			0x9a 0x104	/* gpmc_nwp.gpio_62 gpio62 INPUT | MODE4 */
+			0x9e 0x7	/* gpmc_wait1.safe_mode gpio63 OUTPUT | MODE7 */
+			0xa0 0x7	/* gpmc_wait2.safe_mode gpio64 OUTPUT | MODE7 */
+			0xa2 0x11c	/* gpmc_wait3.gpio_65 gpio65 INPUT_PULLUP | MODE4 */
+			0x196 0x7	/* hdq_sio.safe_mode gpio170 OUTPUT | MODE7 */
+			0x172 0x100	/* hsusb0_clk.hsusb0_clk gpio120 INPUT | MODE0 */
+			0x17a 0x100	/* hsusb0_data0.hsusb0_data0 gpio125 INPUT | MODE0 */
+			0x17c 0x100	/* hsusb0_data1.hsusb0_data1 gpio130 INPUT | MODE0 */
+			0x17e 0x100	/* hsusb0_data2.hsusb0_data2 gpio131 INPUT | MODE0 */
+			0x180 0x100	/* hsusb0_data3.hsusb0_data3 gpio169 INPUT | MODE0 */
+			0x182 0x100	/* hsusb0_data4.hsusb0_data4 gpio188 INPUT | MODE0 */
+			0x184 0x100	/* hsusb0_data5.hsusb0_data5 gpio189 INPUT | MODE0 */
+			0x186 0x100	/* hsusb0_data6.hsusb0_data6 gpio190 INPUT | MODE0 */
+			0x188 0x100	/* hsusb0_data7.hsusb0_data7 gpio191 INPUT | MODE0 */
+			0x176 0x100	/* hsusb0_dir.hsusb0_dir gpio122 INPUT | MODE0 */
+			0x178 0x100	/* hsusb0_nxt.hsusb0_nxt gpio124 INPUT | MODE0 */
+			0x174 0x0	/* hsusb0_stp.hsusb0_stp gpio121 OUTPUT | MODE0 */
+			0x18e 0x100	/* i2c2_scl.i2c2_scl gpio168 INPUT | MODE0 */
+			0x190 0x100	/* i2c2_sda.i2c2_sda gpio183 INPUT | MODE0 */
+			0x192 0x100	/* i2c3_scl.i2c3_scl gpio184 INPUT | MODE0 */
+			0x194 0x100	/* i2c3_sda.i2c3_sda gpio185 INPUT | MODE0 */
+			0x15c 0x109	/* mcbsp1_clkr.mcspi4_clk gpio156 INPUT_PULLDOWN | MODE1 */
+			0x168 0x14	/* mcbsp1_clkx.gpio_162 gpio162 OUTPUT | MODE4 */
+			0x162 0x109	/* mcbsp1_dr.mcspi4_somi gpio159 INPUT_PULLDOWN | MODE1 */
+			0x160 0x1	/* mcbsp1_dx.mcspi4_simo gpio158 OUTPUT | MODE1 */
+			0x15e 0x7	/* mcbsp1_fsr.safe_mode gpio157 OUTPUT | MODE7 */
+			0x166 0x1	/* mcbsp1_fsx.mcspi4_cs0 gpio161 OUTPUT | MODE1 */
+			0x10e 0x100	/* mcbsp2_clkx.mcbsp2_clkx gpio117 INPUT | MODE0 */
+			0x110 0x100	/* mcbsp2_dr.mcbsp2_dr gpio118 INPUT | MODE0 */
+			0x112 0x0	/* mcbsp2_dx.mcbsp2_dx gpio119 OUTPUT | MODE0 */
+			0x10c 0x100	/* mcbsp2_fsx.mcbsp2_fsx gpio116 INPUT | MODE0 */
+			0x140 0x100	/* mcbsp3_clkx.mcbsp3_clkx gpio142 INPUT | MODE0 */
+			0x13e 0x100	/* mcbsp3_dr.mcbsp3_dr gpio141 INPUT | MODE0 */
+			0x13c 0x0	/* mcbsp3_dx.mcbsp3_dx gpio140 OUTPUT | MODE0 */
+			0x142 0x100	/* mcbsp3_fsx.mcbsp3_fsx gpio143 INPUT | MODE0 */
+			0x154 0x101	/* mcbsp4_clkx.(null) gpio152 INPUT | MODE1 */
+			0x156 0x101	/* mcbsp4_dr.(null) gpio153 INPUT | MODE1 */
+			0x158 0x1	/* mcbsp4_dx.(null) gpio154 OUTPUT | MODE1 */
+			0x15a 0x1	/* mcbsp4_fsx.(null) gpio155 OUTPUT | MODE1 */
+			0x164 0x11c	/* mcbsp_clks.gpio_160 gpio160 INPUT_PULLUP | MODE4 */
+			0x198 0x100	/* mcspi1_clk.mcspi1_clk gpio171 INPUT | MODE0 */
+			0x19e 0x0	/* mcspi1_cs0.mcspi1_cs0 gpio174 OUTPUT | MODE0 */
+			0x1a0 0x7	/* mcspi1_cs1.safe_mode gpio175 OUTPUT | MODE7 */
+			0x1a2 0x0	/* mcspi1_cs2.mcspi1_cs2 gpio176 OUTPUT | MODE0 */
+			0x1a4 0x4114	/* mcspi1_cs3.gpio_177 gpio177 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x19a 0x0	/* mcspi1_simo.mcspi1_simo gpio172 OUTPUT | MODE0 */
+			0x19c 0x108	/* mcspi1_somi.mcspi1_somi gpio173 INPUT_PULLDOWN | MODE0 */
+			0x1a6 0x7	/* mcspi2_clk.safe_mode gpio178 OUTPUT | MODE7 */
+			0x1ac 0x4114	/* mcspi2_cs0.gpio_181 gpio181 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x1ae 0x14	/* mcspi2_cs1.gpio_182 gpio182 OUTPUT | MODE4 */
+			0x1a8 0x1	/* mcspi2_simo.gpt9_pwm_evt gpio179 OUTPUT | MODE1 */
+			0x1aa 0x4114	/* mcspi2_somi.gpio_180 gpio180 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x114 0x118	/* sdmmc1_clk.sdmmc1_clk gpio120 INPUT_PULLUP | MODE0 */
+			0x116 0x118	/* sdmmc1_cmd.sdmmc1_cmd gpio121 INPUT_PULLUP | MODE0 */
+			0x118 0x118	/* sdmmc1_dat0.sdmmc1_dat0 gpio122 INPUT_PULLUP | MODE0 */
+			0x11a 0x118	/* sdmmc1_dat1.sdmmc1_dat1 gpio123 INPUT_PULLUP | MODE0 */
+			0x11c 0x118	/* sdmmc1_dat2.sdmmc1_dat2 gpio124 INPUT_PULLUP | MODE0 */
+			0x11e 0x118	/* sdmmc1_dat3.sdmmc1_dat3 gpio125 INPUT_PULLUP | MODE0 */
+			0x120 0x7	/* sdmmc1_dat4.safe_mode gpio126 OUTPUT | MODE7 */
+			0x122 0x7	/* sdmmc1_dat5.safe_mode gpio127 OUTPUT | MODE7 */
+			0x124 0x7	/* sdmmc1_dat6.safe_mode gpio128 OUTPUT | MODE7 */
+			0x126 0x7	/* sdmmc1_dat7.safe_mode gpio129 OUTPUT | MODE7 */
+			0x128 0x118	/* sdmmc2_clk.sdmmc2_clk gpio130 INPUT_PULLUP | MODE0 */
+			0x12a 0x118	/* sdmmc2_cmd.sdmmc2_cmd gpio131 INPUT_PULLUP | MODE0 */
+			0x12c 0x118	/* sdmmc2_dat0.sdmmc2_dat0 gpio132 INPUT_PULLUP | MODE0 */
+			0x12e 0x118	/* sdmmc2_dat1.sdmmc2_dat1 gpio133 INPUT_PULLUP | MODE0 */
+			0x130 0x118	/* sdmmc2_dat2.sdmmc2_dat2 gpio134 INPUT_PULLUP | MODE0 */
+			0x132 0x118	/* sdmmc2_dat3.sdmmc2_dat3 gpio135 INPUT_PULLUP | MODE0 */
+			0x134 0x118	/* sdmmc2_dat4.sdmmc2_dat4 gpio136 INPUT_PULLUP | MODE0 */
+			0x136 0x118	/* sdmmc2_dat5.sdmmc2_dat5 gpio137 INPUT_PULLUP | MODE0 */
+			0x138 0x118	/* sdmmc2_dat6.sdmmc2_dat6 gpio138 INPUT_PULLUP | MODE0 */
+			0x13a 0x118	/* sdmmc2_dat7.sdmmc2_dat7 gpio139 INPUT_PULLUP | MODE0 */
+			0x232 0x100	/* sdrc_cke0.sdrc_cke0 gpio0 INPUT | MODE0 */
+			0x234 0x100	/* sdrc_cke1.sdrc_cke1 gpio0 INPUT | MODE0 */
+			0x1b2 0x17	/* sys_clkout2.safe_mode gpio186 OUTPUT | MODE7 */
+			0x1b0 0xc118	/* sys_nirq.sys_nirq gpio0 INPUT_PULLUP | OFF_WAKEUPENABLE | MODE0 */
+			0x150 0x111	/* uart1_cts.ssi1_rdy_tx gpio150 INPUT | MODE1 */
+			0x14e 0x1	/* uart1_rts.ssi1_flag_tx gpio149 OUTPUT | MODE1 */
+			0x152 0x4104	/* uart1_rx.gpio_151 gpio151 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x14c 0x1	/* uart1_tx.ssi1_dat_tx gpio148 OUTPUT | MODE1 */
+			0x144 0x118	/* uart2_cts.uart2_cts gpio144 INPUT_PULLUP | MODE0 */
+			0x146 0x0	/* uart2_rts.uart2_rts gpio145 OUTPUT | MODE0 */
+			0x14a 0x100	/* uart2_rx.uart2_rx gpio147 INPUT | MODE0 */
+			0x148 0x0	/* uart2_tx.uart2_tx gpio146 OUTPUT | MODE0 */
+			0x16a 0x4	/* uart3_cts_rctx.gpio_163 gpio163 OUTPUT | MODE4 */
+			0x16c 0x4	/* uart3_rts_sd.gpio_164 gpio164 OUTPUT | MODE4 */
+			0x16e 0x100	/* uart3_rx_irrx.uart3_rx_irrx gpio165 INPUT | MODE0 */
+			0x170 0x0	/* uart3_tx_irtx.uart3_tx_irtx gpio166 OUTPUT | MODE0 */
+		>;
+	};
+};
+
+&omap3_pmx_wkup {
+		pinctrl-names = "default";
+		pinctrl-0 = <
+			&wakeup_pins
+		>;
+
+		wakeup_pins: pinmux_wakeup_pins {
+		    pinctrl-single,pins = <
+		    /* FIXME: something needs to be substracted from these...? */
+			0x9d0 0x100	/* i2c4_scl.i2c4_scl gpio0 INPUT | MODE0 */
+			0x9d2 0x100	/* i2c4_sda.i2c4_sda gpio0 INPUT | MODE0 */
+			0x9f4 0x100	/* jtag_emu0.jtag_emu0 gpio11 INPUT | MODE0 */
+			0x9f6 0x100	/* jtag_emu1.jtag_emu1 gpio31 INPUT | MODE0 */
+			0x9da 0x100	/* sys_boot0.sys_boot0 gpio2 INPUT | MODE0 */
+			0x9dc 0x100	/* sys_boot1.sys_boot1 gpio3 INPUT | MODE0 */
+			0x9de 0x100	/* sys_boot2.sys_boot2 gpio4 INPUT | MODE0 */
+			0x9e0 0x100	/* sys_boot3.sys_boot3 gpio5 INPUT | MODE0 */
+			0x9e2 0x100	/* sys_boot4.sys_boot4 gpio6 INPUT | MODE0 */
+			0x9e4 0x104	/* sys_boot5.gpio_7 gpio7 INPUT | MODE4 */
+			0x9e6 0x100	/* sys_boot6.sys_boot6 gpio8 INPUT | MODE0 */
+			0x9ea 0x17	/* sys_clkout1.safe_mode gpio10 OUTPUT | MODE7 */
+			0x9d6 0x0	/* sys_clkreq.sys_clkreq gpio1 OUTPUT | MODE0 */
+			0x9d8 0x118	/* sys_nreswarm.sys_nreswarm gpio30 INPUT_PULLUP | MODE0 */
+			0x9e8 0x0	/* sys_off_mode.sys_off_mode gpio9 OUTPUT | MODE0 */
+
+		>;
+	};
+};
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 996ffc3..1acfd6c 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -129,10 +129,11 @@ void __init omap_generic_init(void)
 #if 1
 		regulator_use_dummy_regulator();
 
+#if 0
 		omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
-
 		spi_register_board_info(rx51_peripherals_spi_board_info,
 				ARRAY_SIZE(rx51_peripherals_spi_board_info));
+#endif
 #else
 		rx51_video_init();
 #endif
diff --git a/arch/arm/mach-omap2/board-rx51-video.c b/arch/arm/mach-omap2/board-rx51-video.c
index 022bff0..b9cc21c 100644
--- a/arch/arm/mach-omap2/board-rx51-video.c
+++ b/arch/arm/mach-omap2/board-rx51-video.c
@@ -66,15 +66,17 @@ static struct omap_dss_board_info rx51_dss_board_info = {
 	.default_device	= &rx51_lcd_device,
 };
 
-static int __init rx51_video_init(void)
+int __init rx51_video_init(void)
 {
 	if (!of_machine_is_compatible("nokia,omap3-n900"))
 		return 0;
 
+#if 0
 	if (omap_mux_init_gpio(RX51_LCD_RESET_GPIO, OMAP_PIN_OUTPUT)) {
 		pr_err("%s cannot configure MUX for LCD RESET\n", __func__);
 		return 0;
 	}
+#endif
 
 	if (gpio_request_one(RX51_LCD_RESET_GPIO, GPIOF_OUT_INIT_HIGH,
 			     "LCD ACX565AKM reset")) {
diff --git a/dmesg.qemu b/dmesg.qemu
index 39403b9..3d5ad31 100644
--- a/dmesg.qemu
+++ b/dmesg.qemu
@@ -34,7 +34,6 @@ Booting secondary
  Machine: Nokia N900 (Flattened Device Tree), model: Nokia N900

  Memory policy: ECC disabled, Data cache writeback

  On node 0 totalpages: 65280

- free_area_init_node: node 0, pgdat c07ba978, node_mem_map c081e000

    Normal zone: 512 pages used for memmap

    Normal zone: 0 pages reserved

    Normal zone: 65280 pages, LIFO batch:15

@@ -55,8 +54,6 @@ Booting secondary
      lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)

      pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)

      modules : 0xbf000000 - 0xbfe00000   (  14 MB)

-       .data : 0xc0766000 - 0xc07be258   ( 353 kB)

-        .bss : 0xc07be258 - 0xc081d1ec   ( 380 kB)

  SLUB: Genslabs=11, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1

  NR_IRQS:16 nr_irqs:16 16

  IRQ: Found an INTC at 0xfa200000 (revision 4.0) with 96 interrupts

@@ -74,7 +71,6 @@ Booting secondary
  Machine: Nokia N900 (Flattened Device Tree), model: Nokia N900

  Memory policy: ECC disabled, Data cache writeback

  On node 0 totalpages: 65280

- free_area_init_node: node 0, pgdat c07ba978, node_mem_map c081e000

    Normal zone: 512 pages used for memmap

    Normal zone: 0 pages reserved

    Normal zone: 65280 pages, LIFO batch:15

@@ -95,8 +91,6 @@ Booting secondary
      lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)

      pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)

      modules : 0xbf000000 - 0xbfe00000   (  14 MB)

-       .data : 0xc0766000 - 0xc07be258   ( 353 kB)

-        .bss : 0xc07be258 - 0xc081d1ec   ( 380 kB)

  SLUB: Genslabs=11, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1

  NR_IRQS:16 nr_irqs:16 16

  IRQ: Found an INTC at 0xfa200000 (revision 4.0) with 96 interrupts

@@ -113,45 +107,73 @@ Booting secondary
  Initializing cgroup subsys freezer

  Initializing cgroup subsys blkio

  CPU: Testing write buffer coherency: ok

- Setting up static identity map for 0xc0533710 - 0xc0533768

  devtmpfs: initialized

  omap_hdq1w_reset: hdq1w: softreset failed (waited 10000 usec)

  pinctrl core: initialized pinctrl subsystem

+ reg-dummy reg-dummy: no of_node; not parsing pinctrl DT

  regulator-dummy: no parameters

  NET: Registered protocol family 16

  DMA: preallocated 256 KiB pool for atomic coherent allocations

+ omap_l3_smx omap_l3_smx.0: no of_node; not parsing pinctrl DT

  Reprogramming SDRC clock to 332000000 Hz

  OMAP GPIO hardware version 2.5

  platform 49022000.mcbsp: alias fck already exists

  platform 49024000.mcbsp: alias fck already exists

- omap_mux_init: Add partition: #1: core, flags: 4

  No ATAGs?

  hw-breakpoint: debug architecture 0x0 unsupported.

+ omap_dma_system omap_dma_system.0: no of_node; not parsing pinctrl DT

+ omap_dma_system omap_dma_system.0: using pinctrl dummy state (default)

  OMAP DMA hardware revision 4.0

   arm-pmu: alias fck already exists

  bio: create slab <bio-0> at 0

+ omap-dma-engine omap-dma-engine: no of_node; not parsing pinctrl DT

+ omap-dma-engine omap-dma-engine: using pinctrl dummy state (default)

  omap-dma-engine omap-dma-engine: OMAP DMA engine driver

  usbcore: registered new interface driver usbfs

  usbcore: registered new interface driver hub

  usbcore: registered new device driver usb

+ omap_i2c i2c.13: using pinctrl dummy state (default)

+ omap_i2c i2c.13: obtain a copy of previously claimed pinctrl

  omap_i2c i2c.13: bus 0 rev3.3 at 2200 kHz

+ twl 0-0048: using pinctrl dummy state (default)

+ dummy 0-0049: no of_node; not parsing pinctrl DT

+ dummy 0-0049: using pinctrl dummy state (default)

+ dummy 0-004a: no of_node; not parsing pinctrl DT

+ dummy 0-004a: using pinctrl dummy state (default)

+ dummy 0-004b: no of_node; not parsing pinctrl DT

+ dummy 0-004b: using pinctrl dummy state (default)

  twl 0-0048: PIH (irq 23) chaining IRQs 336..344

  twl 0-0048: power (irq 341) chaining IRQs 344..351

+ twl_reg regulator-vdac.23: using pinctrl dummy state (default)

  VDAC: 1800 mV 

+ twl_reg regulator-vpll2.24: using pinctrl dummy state (default)

  VPLL2: 1800 mV 

+ twl_reg regulator-vmmc1.25: using pinctrl dummy state (default)

  VMMC1: 1850 <--> 3150 mV at 1850 mV 

+ twl_reg regulator-vusb1v5.26: using pinctrl dummy state (default)

  VUSB1V5: 1500 mV 

+ twl_reg regulator-vusb1v8.27: using pinctrl dummy state (default)

  VUSB1V8: 1800 mV 

+ twl_reg regulator-vusb3v1.28: using pinctrl dummy state (default)

  VUSB3V1: 3100 mV 

+ twl_reg regulator-vsim.29: using pinctrl dummy state (default)

  VSIM: 1800 <--> 3000 mV at 1800 mV 

+ twl4030_gpio gpio.30: using pinctrl dummy state (default)

  twl4030_gpio gpio.30: gpio (irq 336) chaining IRQs 352..369

+ twl4030_usb twl4030-usb.31: using pinctrl dummy state (default)

  twl4030_usb twl4030-usb.31: HW_CONDITIONS 0x04/4; link 1

  omap_musb_mailbox: musb core is not yet initialized

  twl4030_usb twl4030-usb.31: Initialized TWL4030 USB module

+ omap_i2c i2c.14: using pinctrl dummy state (default)

+ omap_i2c i2c.14: obtain a copy of previously claimed pinctrl

  omap_i2c i2c.14: bus 1 rev3.3 at 400 kHz

+ omap_i2c i2c.15: using pinctrl dummy state (default)

+ omap_i2c i2c.15: obtain a copy of previously claimed pinctrl

  omap_i2c i2c.15: bus 2 rev3.3 at 100 kHz

  media: Linux media interface: v0.10

  Linux video capture interface: v2.00

+ omap-iommu omap-iommu.0: no of_node; not parsing pinctrl DT

+ omap-iommu omap-iommu.0: using pinctrl dummy state (default)

  omap-iommu omap-iommu.0: mmu_isp registered

  Advanced Linux Sound Architecture Driver Initialized.

  Bluetooth: Core ver 2.16

@@ -170,13 +192,1024 @@ Booting secondary
  UDP hash table entries: 256 (order: 0, 4096 bytes)

  UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)

  NET: Registered protocol family 1

+ arm-pmu arm-pmu: no of_node; not parsing pinctrl DT

+ arm-pmu arm-pmu: using pinctrl dummy state (default)

  CPU PMU: probing PMU on CPU 0

  hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver, 1 counters available

+ omap_timer 49032000.timer: using pinctrl dummy state (default)

+ omap_timer 49034000.timer: using pinctrl dummy state (default)

+ omap_timer 49036000.timer: using pinctrl dummy state (default)

+ omap_timer 49038000.timer: using pinctrl dummy state (default)

+ omap_timer 4903a000.timer: using pinctrl dummy state (default)

+ omap_timer 4903c000.timer: using pinctrl dummy state (default)

+ omap_timer 4903e000.timer: using pinctrl dummy state (default)

+ omap_timer 49040000.timer: using pinctrl dummy state (default)

+ omap_timer 48086000.timer: using pinctrl dummy state (default)

+ omap_timer 48088000.timer: using pinctrl dummy state (default)

+ omap_timer 48304000.timer: using pinctrl dummy state (default)

+ alarmtimer alarmtimer: no of_node; not parsing pinctrl DT

+ alarmtimer alarmtimer: using pinctrl dummy state (default)

  VFS: Disk quotas dquot_6.5.2

  Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)

  msgmni has been set to 489

  io scheduler noop registered

  io scheduler cfq registered (default)

+ pinctrl-single 48002030.pinmux: allocating 742 pins

+ pinctrl-single 48002030.pinmux: try to register 742 pins ...

+ pinctrl core: registered pin 0 (48002030) on pinctrl-single

+ pinctrl core: registered pin 1 (48002032) on pinctrl-single

+ pinctrl core: registered pin 2 (48002034) on pinctrl-single

+ pinctrl core: registered pin 3 (48002036) on pinctrl-single

+ pinctrl core: registered pin 4 (48002038) on pinctrl-single

+ pinctrl core: registered pin 5 (4800203a) on pinctrl-single

+ pinctrl core: registered pin 6 (4800203c) on pinctrl-single

+ pinctrl core: registered pin 7 (4800203e) on pinctrl-single

+ pinctrl core: registered pin 8 (48002040) on pinctrl-single

+ pinctrl core: registered pin 9 (48002042) on pinctrl-single

+ pinctrl core: registered pin 10 (48002044) on pinctrl-single

+ pinctrl core: registered pin 11 (48002046) on pinctrl-single

+ pinctrl core: registered pin 12 (48002048) on pinctrl-single

+ pinctrl core: registered pin 13 (4800204a) on pinctrl-single

+ pinctrl core: registered pin 14 (4800204c) on pinctrl-single

+ pinctrl core: registered pin 15 (4800204e) on pinctrl-single

+ pinctrl core: registered pin 16 (48002050) on pinctrl-single

+ pinctrl core: registered pin 17 (48002052) on pinctrl-single

+ pinctrl core: registered pin 18 (48002054) on pinctrl-single

+ pinctrl core: registered pin 19 (48002056) on pinctrl-single

+ pinctrl core: registered pin 20 (48002058) on pinctrl-single

+ pinctrl core: registered pin 21 (4800205a) on pinctrl-single

+ pinctrl core: registered pin 22 (4800205c) on pinctrl-single

+ pinctrl core: registered pin 23 (4800205e) on pinctrl-single

+ pinctrl core: registered pin 24 (48002060) on pinctrl-single

+ pinctrl core: registered pin 25 (48002062) on pinctrl-single

+ pinctrl core: registered pin 26 (48002064) on pinctrl-single

+ pinctrl core: registered pin 27 (48002066) on pinctrl-single

+ pinctrl core: registered pin 28 (48002068) on pinctrl-single

+ pinctrl core: registered pin 29 (4800206a) on pinctrl-single

+ pinctrl core: registered pin 30 (4800206c) on pinctrl-single

+ pinctrl core: registered pin 31 (4800206e) on pinctrl-single

+ pinctrl core: registered pin 32 (48002070) on pinctrl-single

+ pinctrl core: registered pin 33 (48002072) on pinctrl-single

+ pinctrl core: registered pin 34 (48002074) on pinctrl-single

+ pinctrl core: registered pin 35 (48002076) on pinctrl-single

+ pinctrl core: registered pin 36 (48002078) on pinctrl-single

+ pinctrl core: registered pin 37 (4800207a) on pinctrl-single

+ pinctrl core: registered pin 38 (4800207c) on pinctrl-single

+ pinctrl core: registered pin 39 (4800207e) on pinctrl-single

+ pinctrl core: registered pin 40 (48002080) on pinctrl-single

+ pinctrl core: registered pin 41 (48002082) on pinctrl-single

+ pinctrl core: registered pin 42 (48002084) on pinctrl-single

+ pinctrl core: registered pin 43 (48002086) on pinctrl-single

+ pinctrl core: registered pin 44 (48002088) on pinctrl-single

+ pinctrl core: registered pin 45 (4800208a) on pinctrl-single

+ pinctrl core: registered pin 46 (4800208c) on pinctrl-single

+ pinctrl core: registered pin 47 (4800208e) on pinctrl-single

+ pinctrl core: registered pin 48 (48002090) on pinctrl-single

+ pinctrl core: registered pin 49 (48002092) on pinctrl-single

+ pinctrl core: registered pin 50 (48002094) on pinctrl-single

+ pinctrl core: registered pin 51 (48002096) on pinctrl-single

+ pinctrl core: registered pin 52 (48002098) on pinctrl-single

+ pinctrl core: registered pin 53 (4800209a) on pinctrl-single

+ pinctrl core: registered pin 54 (4800209c) on pinctrl-single

+ pinctrl core: registered pin 55 (4800209e) on pinctrl-single

+ pinctrl core: registered pin 56 (480020a0) on pinctrl-single

+ pinctrl core: registered pin 57 (480020a2) on pinctrl-single

+ pinctrl core: registered pin 58 (480020a4) on pinctrl-single

+ pinctrl core: registered pin 59 (480020a6) on pinctrl-single

+ pinctrl core: registered pin 60 (480020a8) on pinctrl-single

+ pinctrl core: registered pin 61 (480020aa) on pinctrl-single

+ pinctrl core: registered pin 62 (480020ac) on pinctrl-single

+ pinctrl core: registered pin 63 (480020ae) on pinctrl-single

+ pinctrl core: registered pin 64 (480020b0) on pinctrl-single

+ pinctrl core: registered pin 65 (480020b2) on pinctrl-single

+ pinctrl core: registered pin 66 (480020b4) on pinctrl-single

+ pinctrl core: registered pin 67 (480020b6) on pinctrl-single

+ pinctrl core: registered pin 68 (480020b8) on pinctrl-single

+ pinctrl core: registered pin 69 (480020ba) on pinctrl-single

+ pinctrl core: registered pin 70 (480020bc) on pinctrl-single

+ pinctrl core: registered pin 71 (480020be) on pinctrl-single

+ pinctrl core: registered pin 72 (480020c0) on pinctrl-single

+ pinctrl core: registered pin 73 (480020c2) on pinctrl-single

+ pinctrl core: registered pin 74 (480020c4) on pinctrl-single

+ pinctrl core: registered pin 75 (480020c6) on pinctrl-single

+ pinctrl core: registered pin 76 (480020c8) on pinctrl-single

+ pinctrl core: registered pin 77 (480020ca) on pinctrl-single

+ pinctrl core: registered pin 78 (480020cc) on pinctrl-single

+ pinctrl core: registered pin 79 (480020ce) on pinctrl-single

+ pinctrl core: registered pin 80 (480020d0) on pinctrl-single

+ pinctrl core: registered pin 81 (480020d2) on pinctrl-single

+ pinctrl core: registered pin 82 (480020d4) on pinctrl-single

+ pinctrl core: registered pin 83 (480020d6) on pinctrl-single

+ pinctrl core: registered pin 84 (480020d8) on pinctrl-single

+ pinctrl core: registered pin 85 (480020da) on pinctrl-single

+ pinctrl core: registered pin 86 (480020dc) on pinctrl-single

+ pinctrl core: registered pin 87 (480020de) on pinctrl-single

+ pinctrl core: registered pin 88 (480020e0) on pinctrl-single

+ pinctrl core: registered pin 89 (480020e2) on pinctrl-single

+ pinctrl core: registered pin 90 (480020e4) on pinctrl-single

+ pinctrl core: registered pin 91 (480020e6) on pinctrl-single

+ pinctrl core: registered pin 92 (480020e8) on pinctrl-single

+ pinctrl core: registered pin 93 (480020ea) on pinctrl-single

+ pinctrl core: registered pin 94 (480020ec) on pinctrl-single

+ pinctrl core: registered pin 95 (480020ee) on pinctrl-single

+ pinctrl core: registered pin 96 (480020f0) on pinctrl-single

+ pinctrl core: registered pin 97 (480020f2) on pinctrl-single

+ pinctrl core: registered pin 98 (480020f4) on pinctrl-single

+ pinctrl core: registered pin 99 (480020f6) on pinctrl-single

+ pinctrl core: registered pin 100 (480020f8) on pinctrl-single

+ pinctrl core: registered pin 101 (480020fa) on pinctrl-single

+ pinctrl core: registered pin 102 (480020fc) on pinctrl-single

+ pinctrl core: registered pin 103 (480020fe) on pinctrl-single

+ pinctrl core: registered pin 104 (48002100) on pinctrl-single

+ pinctrl core: registered pin 105 (48002102) on pinctrl-single

+ pinctrl core: registered pin 106 (48002104) on pinctrl-single

+ pinctrl core: registered pin 107 (48002106) on pinctrl-single

+ pinctrl core: registered pin 108 (48002108) on pinctrl-single

+ pinctrl core: registered pin 109 (4800210a) on pinctrl-single

+ pinctrl core: registered pin 110 (4800210c) on pinctrl-single

+ pinctrl core: registered pin 111 (4800210e) on pinctrl-single

+ pinctrl core: registered pin 112 (48002110) on pinctrl-single

+ pinctrl core: registered pin 113 (48002112) on pinctrl-single

+ pinctrl core: registered pin 114 (48002114) on pinctrl-single

+ pinctrl core: registered pin 115 (48002116) on pinctrl-single

+ pinctrl core: registered pin 116 (48002118) on pinctrl-single

+ pinctrl core: registered pin 117 (4800211a) on pinctrl-single

+ pinctrl core: registered pin 118 (4800211c) on pinctrl-single

+ pinctrl core: registered pin 119 (4800211e) on pinctrl-single

+ pinctrl core: registered pin 120 (48002120) on pinctrl-single

+ pinctrl core: registered pin 121 (48002122) on pinctrl-single

+ pinctrl core: registered pin 122 (48002124) on pinctrl-single

+ pinctrl core: registered pin 123 (48002126) on pinctrl-single

+ pinctrl core: registered pin 124 (48002128) on pinctrl-single

+ pinctrl core: registered pin 125 (4800212a) on pinctrl-single

+ pinctrl core: registered pin 126 (4800212c) on pinctrl-single

+ pinctrl core: registered pin 127 (4800212e) on pinctrl-single

+ pinctrl core: registered pin 128 (48002130) on pinctrl-single

+ pinctrl core: registered pin 129 (48002132) on pinctrl-single

+ pinctrl core: registered pin 130 (48002134) on pinctrl-single

+ pinctrl core: registered pin 131 (48002136) on pinctrl-single

+ pinctrl core: registered pin 132 (48002138) on pinctrl-single

+ pinctrl core: registered pin 133 (4800213a) on pinctrl-single

+ pinctrl core: registered pin 134 (4800213c) on pinctrl-single

+ pinctrl core: registered pin 135 (4800213e) on pinctrl-single

+ pinctrl core: registered pin 136 (48002140) on pinctrl-single

+ pinctrl core: registered pin 137 (48002142) on pinctrl-single

+ pinctrl core: registered pin 138 (48002144) on pinctrl-single

+ pinctrl core: registered pin 139 (48002146) on pinctrl-single

+ pinctrl core: registered pin 140 (48002148) on pinctrl-single

+ pinctrl core: registered pin 141 (4800214a) on pinctrl-single

+ pinctrl core: registered pin 142 (4800214c) on pinctrl-single

+ pinctrl core: registered pin 143 (4800214e) on pinctrl-single

+ pinctrl core: registered pin 144 (48002150) on pinctrl-single

+ pinctrl core: registered pin 145 (48002152) on pinctrl-single

+ pinctrl core: registered pin 146 (48002154) on pinctrl-single

+ pinctrl core: registered pin 147 (48002156) on pinctrl-single

+ pinctrl core: registered pin 148 (48002158) on pinctrl-single

+ pinctrl core: registered pin 149 (4800215a) on pinctrl-single

+ pinctrl core: registered pin 150 (4800215c) on pinctrl-single

+ pinctrl core: registered pin 151 (4800215e) on pinctrl-single

+ pinctrl core: registered pin 152 (48002160) on pinctrl-single

+ pinctrl core: registered pin 153 (48002162) on pinctrl-single

+ pinctrl core: registered pin 154 (48002164) on pinctrl-single

+ pinctrl core: registered pin 155 (48002166) on pinctrl-single

+ pinctrl core: registered pin 156 (48002168) on pinctrl-single

+ pinctrl core: registered pin 157 (4800216a) on pinctrl-single

+ pinctrl core: registered pin 158 (4800216c) on pinctrl-single

+ pinctrl core: registered pin 159 (4800216e) on pinctrl-single

+ pinctrl core: registered pin 160 (48002170) on pinctrl-single

+ pinctrl core: registered pin 161 (48002172) on pinctrl-single

+ pinctrl core: registered pin 162 (48002174) on pinctrl-single

+ pinctrl core: registered pin 163 (48002176) on pinctrl-single

+ pinctrl core: registered pin 164 (48002178) on pinctrl-single

+ pinctrl core: registered pin 165 (4800217a) on pinctrl-single

+ pinctrl core: registered pin 166 (4800217c) on pinctrl-single

+ pinctrl core: registered pin 167 (4800217e) on pinctrl-single

+ pinctrl core: registered pin 168 (48002180) on pinctrl-single

+ pinctrl core: registered pin 169 (48002182) on pinctrl-single

+ pinctrl core: registered pin 170 (48002184) on pinctrl-single

+ pinctrl core: registered pin 171 (48002186) on pinctrl-single

+ pinctrl core: registered pin 172 (48002188) on pinctrl-single

+ pinctrl core: registered pin 173 (4800218a) on pinctrl-single

+ pinctrl core: registered pin 174 (4800218c) on pinctrl-single

+ pinctrl core: registered pin 175 (4800218e) on pinctrl-single

+ pinctrl core: registered pin 176 (48002190) on pinctrl-single

+ pinctrl core: registered pin 177 (48002192) on pinctrl-single

+ pinctrl core: registered pin 178 (48002194) on pinctrl-single

+ pinctrl core: registered pin 179 (48002196) on pinctrl-single

+ pinctrl core: registered pin 180 (48002198) on pinctrl-single

+ pinctrl core: registered pin 181 (4800219a) on pinctrl-single

+ pinctrl core: registered pin 182 (4800219c) on pinctrl-single

+ pinctrl core: registered pin 183 (4800219e) on pinctrl-single

+ pinctrl core: registered pin 184 (480021a0) on pinctrl-single

+ pinctrl core: registered pin 185 (480021a2) on pinctrl-single

+ pinctrl core: registered pin 186 (480021a4) on pinctrl-single

+ pinctrl core: registered pin 187 (480021a6) on pinctrl-single

+ pinctrl core: registered pin 188 (480021a8) on pinctrl-single

+ pinctrl core: registered pin 189 (480021aa) on pinctrl-single

+ pinctrl core: registered pin 190 (480021ac) on pinctrl-single

+ pinctrl core: registered pin 191 (480021ae) on pinctrl-single

+ pinctrl core: registered pin 192 (480021b0) on pinctrl-single

+ pinctrl core: registered pin 193 (480021b2) on pinctrl-single

+ pinctrl core: registered pin 194 (480021b4) on pinctrl-single

+ pinctrl core: registered pin 195 (480021b6) on pinctrl-single

+ pinctrl core: registered pin 196 (480021b8) on pinctrl-single

+ pinctrl core: registered pin 197 (480021ba) on pinctrl-single

+ pinctrl core: registered pin 198 (480021bc) on pinctrl-single

+ pinctrl core: registered pin 199 (480021be) on pinctrl-single

+ pinctrl core: registered pin 200 (480021c0) on pinctrl-single

+ pinctrl core: registered pin 201 (480021c2) on pinctrl-single

+ pinctrl core: registered pin 202 (480021c4) on pinctrl-single

+ pinctrl core: registered pin 203 (480021c6) on pinctrl-single

+ pinctrl core: registered pin 204 (480021c8) on pinctrl-single

+ pinctrl core: registered pin 205 (480021ca) on pinctrl-single

+ pinctrl core: registered pin 206 (480021cc) on pinctrl-single

+ pinctrl core: registered pin 207 (480021ce) on pinctrl-single

+ pinctrl core: registered pin 208 (480021d0) on pinctrl-single

+ pinctrl core: registered pin 209 (480021d2) on pinctrl-single

+ pinctrl core: registered pin 210 (480021d4) on pinctrl-single

+ pinctrl core: registered pin 211 (480021d6) on pinctrl-single

+ pinctrl core: registered pin 212 (480021d8) on pinctrl-single

+ pinctrl core: registered pin 213 (480021da) on pinctrl-single

+ pinctrl core: registered pin 214 (480021dc) on pinctrl-single

+ pinctrl core: registered pin 215 (480021de) on pinctrl-single

+ pinctrl core: registered pin 216 (480021e0) on pinctrl-single

+ pinctrl core: registered pin 217 (480021e2) on pinctrl-single

+ pinctrl core: registered pin 218 (480021e4) on pinctrl-single

+ pinctrl core: registered pin 219 (480021e6) on pinctrl-single

+ pinctrl core: registered pin 220 (480021e8) on pinctrl-single

+ pinctrl core: registered pin 221 (480021ea) on pinctrl-single

+ pinctrl core: registered pin 222 (480021ec) on pinctrl-single

+ pinctrl core: registered pin 223 (480021ee) on pinctrl-single

+ pinctrl core: registered pin 224 (480021f0) on pinctrl-single

+ pinctrl core: registered pin 225 (480021f2) on pinctrl-single

+ pinctrl core: registered pin 226 (480021f4) on pinctrl-single

+ pinctrl core: registered pin 227 (480021f6) on pinctrl-single

+ pinctrl core: registered pin 228 (480021f8) on pinctrl-single

+ pinctrl core: registered pin 229 (480021fa) on pinctrl-single

+ pinctrl core: registered pin 230 (480021fc) on pinctrl-single

+ pinctrl core: registered pin 231 (480021fe) on pinctrl-single

+ pinctrl core: registered pin 232 (48002200) on pinctrl-single

+ pinctrl core: registered pin 233 (48002202) on pinctrl-single

+ pinctrl core: registered pin 234 (48002204) on pinctrl-single

+ pinctrl core: registered pin 235 (48002206) on pinctrl-single

+ pinctrl core: registered pin 236 (48002208) on pinctrl-single

+ pinctrl core: registered pin 237 (4800220a) on pinctrl-single

+ pinctrl core: registered pin 238 (4800220c) on pinctrl-single

+ pinctrl core: registered pin 239 (4800220e) on pinctrl-single

+ pinctrl core: registered pin 240 (48002210) on pinctrl-single

+ pinctrl core: registered pin 241 (48002212) on pinctrl-single

+ pinctrl core: registered pin 242 (48002214) on pinctrl-single

+ pinctrl core: registered pin 243 (48002216) on pinctrl-single

+ pinctrl core: registered pin 244 (48002218) on pinctrl-single

+ pinctrl core: registered pin 245 (4800221a) on pinctrl-single

+ pinctrl core: registered pin 246 (4800221c) on pinctrl-single

+ pinctrl core: registered pin 247 (4800221e) on pinctrl-single

+ pinctrl core: registered pin 248 (48002220) on pinctrl-single

+ pinctrl core: registered pin 249 (48002222) on pinctrl-single

+ pinctrl core: registered pin 250 (48002224) on pinctrl-single

+ pinctrl core: registered pin 251 (48002226) on pinctrl-single

+ pinctrl core: registered pin 252 (48002228) on pinctrl-single

+ pinctrl core: registered pin 253 (4800222a) on pinctrl-single

+ pinctrl core: registered pin 254 (4800222c) on pinctrl-single

+ pinctrl core: registered pin 255 (4800222e) on pinctrl-single

+ pinctrl core: registered pin 256 (48002230) on pinctrl-single

+ pinctrl core: registered pin 257 (48002232) on pinctrl-single

+ pinctrl core: registered pin 258 (48002234) on pinctrl-single

+ pinctrl core: registered pin 259 (48002236) on pinctrl-single

+ pinctrl core: registered pin 260 (48002238) on pinctrl-single

+ pinctrl core: registered pin 261 (4800223a) on pinctrl-single

+ pinctrl core: registered pin 262 (4800223c) on pinctrl-single

+ pinctrl core: registered pin 263 (4800223e) on pinctrl-single

+ pinctrl core: registered pin 264 (48002240) on pinctrl-single

+ pinctrl core: registered pin 265 (48002242) on pinctrl-single

+ pinctrl core: registered pin 266 (48002244) on pinctrl-single

+ pinctrl core: registered pin 267 (48002246) on pinctrl-single

+ pinctrl core: registered pin 268 (48002248) on pinctrl-single

+ pinctrl core: registered pin 269 (4800224a) on pinctrl-single

+ pinctrl core: registered pin 270 (4800224c) on pinctrl-single

+ pinctrl core: registered pin 271 (4800224e) on pinctrl-single

+ pinctrl core: registered pin 272 (48002250) on pinctrl-single

+ pinctrl core: registered pin 273 (48002252) on pinctrl-single

+ pinctrl core: registered pin 274 (48002254) on pinctrl-single

+ pinctrl core: registered pin 275 (48002256) on pinctrl-single

+ pinctrl core: registered pin 276 (48002258) on pinctrl-single

+ pinctrl core: registered pin 277 (4800225a) on pinctrl-single

+ pinctrl core: registered pin 278 (4800225c) on pinctrl-single

+ pinctrl core: registered pin 279 (4800225e) on pinctrl-single

+ pinctrl core: registered pin 280 (48002260) on pinctrl-single

+ pinctrl core: registered pin 281 (48002262) on pinctrl-single

+ pinctrl core: registered pin 282 (48002264) on pinctrl-single

+ pinctrl core: registered pin 283 (48002266) on pinctrl-single

+ pinctrl core: registered pin 284 (48002268) on pinctrl-single

+ pinctrl core: registered pin 285 (4800226a) on pinctrl-single

+ pinctrl core: registered pin 286 (4800226c) on pinctrl-single

+ pinctrl core: registered pin 287 (4800226e) on pinctrl-single

+ pinctrl core: registered pin 288 (48002270) on pinctrl-single

+ pinctrl core: registered pin 289 (48002272) on pinctrl-single

+ pinctrl core: registered pin 290 (48002274) on pinctrl-single

+ pinctrl core: registered pin 291 (48002276) on pinctrl-single

+ pinctrl core: registered pin 292 (48002278) on pinctrl-single

+ pinctrl core: registered pin 293 (4800227a) on pinctrl-single

+ pinctrl core: registered pin 294 (4800227c) on pinctrl-single

+ pinctrl core: registered pin 295 (4800227e) on pinctrl-single

+ pinctrl core: registered pin 296 (48002280) on pinctrl-single

+ pinctrl core: registered pin 297 (48002282) on pinctrl-single

+ pinctrl core: registered pin 298 (48002284) on pinctrl-single

+ pinctrl core: registered pin 299 (48002286) on pinctrl-single

+ pinctrl core: registered pin 300 (48002288) on pinctrl-single

+ pinctrl core: registered pin 301 (4800228a) on pinctrl-single

+ pinctrl core: registered pin 302 (4800228c) on pinctrl-single

+ pinctrl core: registered pin 303 (4800228e) on pinctrl-single

+ pinctrl core: registered pin 304 (48002290) on pinctrl-single

+ pinctrl core: registered pin 305 (48002292) on pinctrl-single

+ pinctrl core: registered pin 306 (48002294) on pinctrl-single

+ pinctrl core: registered pin 307 (48002296) on pinctrl-single

+ pinctrl core: registered pin 308 (48002298) on pinctrl-single

+ pinctrl core: registered pin 309 (4800229a) on pinctrl-single

+ pinctrl core: registered pin 310 (4800229c) on pinctrl-single

+ pinctrl core: registered pin 311 (4800229e) on pinctrl-single

+ pinctrl core: registered pin 312 (480022a0) on pinctrl-single

+ pinctrl core: registered pin 313 (480022a2) on pinctrl-single

+ pinctrl core: registered pin 314 (480022a4) on pinctrl-single

+ pinctrl core: registered pin 315 (480022a6) on pinctrl-single

+ pinctrl core: registered pin 316 (480022a8) on pinctrl-single

+ pinctrl core: registered pin 317 (480022aa) on pinctrl-single

+ pinctrl core: registered pin 318 (480022ac) on pinctrl-single

+ pinctrl core: registered pin 319 (480022ae) on pinctrl-single

+ pinctrl core: registered pin 320 (480022b0) on pinctrl-single

+ pinctrl core: registered pin 321 (480022b2) on pinctrl-single

+ pinctrl core: registered pin 322 (480022b4) on pinctrl-single

+ pinctrl core: registered pin 323 (480022b6) on pinctrl-single

+ pinctrl core: registered pin 324 (480022b8) on pinctrl-single

+ pinctrl core: registered pin 325 (480022ba) on pinctrl-single

+ pinctrl core: registered pin 326 (480022bc) on pinctrl-single

+ pinctrl core: registered pin 327 (480022be) on pinctrl-single

+ pinctrl core: registered pin 328 (480022c0) on pinctrl-single

+ pinctrl core: registered pin 329 (480022c2) on pinctrl-single

+ pinctrl core: registered pin 330 (480022c4) on pinctrl-single

+ pinctrl core: registered pin 331 (480022c6) on pinctrl-single

+ pinctrl core: registered pin 332 (480022c8) on pinctrl-single

+ pinctrl core: registered pin 333 (480022ca) on pinctrl-single

+ pinctrl core: registered pin 334 (480022cc) on pinctrl-single

+ pinctrl core: registered pin 335 (480022ce) on pinctrl-single

+ pinctrl core: registered pin 336 (480022d0) on pinctrl-single

+ pinctrl core: registered pin 337 (480022d2) on pinctrl-single

+ pinctrl core: registered pin 338 (480022d4) on pinctrl-single

+ pinctrl core: registered pin 339 (480022d6) on pinctrl-single

+ pinctrl core: registered pin 340 (480022d8) on pinctrl-single

+ pinctrl core: registered pin 341 (480022da) on pinctrl-single

+ pinctrl core: registered pin 342 (480022dc) on pinctrl-single

+ pinctrl core: registered pin 343 (480022de) on pinctrl-single

+ pinctrl core: registered pin 344 (480022e0) on pinctrl-single

+ pinctrl core: registered pin 345 (480022e2) on pinctrl-single

+ pinctrl core: registered pin 346 (480022e4) on pinctrl-single

+ pinctrl core: registered pin 347 (480022e6) on pinctrl-single

+ pinctrl core: registered pin 348 (480022e8) on pinctrl-single

+ pinctrl core: registered pin 349 (480022ea) on pinctrl-single

+ pinctrl core: registered pin 350 (480022ec) on pinctrl-single

+ pinctrl core: registered pin 351 (480022ee) on pinctrl-single

+ pinctrl core: registered pin 352 (480022f0) on pinctrl-single

+ pinctrl core: registered pin 353 (480022f2) on pinctrl-single

+ pinctrl core: registered pin 354 (480022f4) on pinctrl-single

+ pinctrl core: registered pin 355 (480022f6) on pinctrl-single

+ pinctrl core: registered pin 356 (480022f8) on pinctrl-single

+ pinctrl core: registered pin 357 (480022fa) on pinctrl-single

+ pinctrl core: registered pin 358 (480022fc) on pinctrl-single

+ pinctrl core: registered pin 359 (480022fe) on pinctrl-single

+ pinctrl core: registered pin 360 (48002300) on pinctrl-single

+ pinctrl core: registered pin 361 (48002302) on pinctrl-single

+ pinctrl core: registered pin 362 (48002304) on pinctrl-single

+ pinctrl core: registered pin 363 (48002306) on pinctrl-single

+ pinctrl core: registered pin 364 (48002308) on pinctrl-single

+ pinctrl core: registered pin 365 (4800230a) on pinctrl-single

+ pinctrl core: registered pin 366 (4800230c) on pinctrl-single

+ pinctrl core: registered pin 367 (4800230e) on pinctrl-single

+ pinctrl core: registered pin 368 (48002310) on pinctrl-single

+ pinctrl core: registered pin 369 (48002312) on pinctrl-single

+ pinctrl core: registered pin 370 (48002314) on pinctrl-single

+ pinctrl core: registered pin 371 (48002316) on pinctrl-single

+ pinctrl core: registered pin 372 (48002318) on pinctrl-single

+ pinctrl core: registered pin 373 (4800231a) on pinctrl-single

+ pinctrl core: registered pin 374 (4800231c) on pinctrl-single

+ pinctrl core: registered pin 375 (4800231e) on pinctrl-single

+ pinctrl core: registered pin 376 (48002320) on pinctrl-single

+ pinctrl core: registered pin 377 (48002322) on pinctrl-single

+ pinctrl core: registered pin 378 (48002324) on pinctrl-single

+ pinctrl core: registered pin 379 (48002326) on pinctrl-single

+ pinctrl core: registered pin 380 (48002328) on pinctrl-single

+ pinctrl core: registered pin 381 (4800232a) on pinctrl-single

+ pinctrl core: registered pin 382 (4800232c) on pinctrl-single

+ pinctrl core: registered pin 383 (4800232e) on pinctrl-single

+ pinctrl core: registered pin 384 (48002330) on pinctrl-single

+ pinctrl core: registered pin 385 (48002332) on pinctrl-single

+ pinctrl core: registered pin 386 (48002334) on pinctrl-single

+ pinctrl core: registered pin 387 (48002336) on pinctrl-single

+ pinctrl core: registered pin 388 (48002338) on pinctrl-single

+ pinctrl core: registered pin 389 (4800233a) on pinctrl-single

+ pinctrl core: registered pin 390 (4800233c) on pinctrl-single

+ pinctrl core: registered pin 391 (4800233e) on pinctrl-single

+ pinctrl core: registered pin 392 (48002340) on pinctrl-single

+ pinctrl core: registered pin 393 (48002342) on pinctrl-single

+ pinctrl core: registered pin 394 (48002344) on pinctrl-single

+ pinctrl core: registered pin 395 (48002346) on pinctrl-single

+ pinctrl core: registered pin 396 (48002348) on pinctrl-single

+ pinctrl core: registered pin 397 (4800234a) on pinctrl-single

+ pinctrl core: registered pin 398 (4800234c) on pinctrl-single

+ pinctrl core: registered pin 399 (4800234e) on pinctrl-single

+ pinctrl core: registered pin 400 (48002350) on pinctrl-single

+ pinctrl core: registered pin 401 (48002352) on pinctrl-single

+ pinctrl core: registered pin 402 (48002354) on pinctrl-single

+ pinctrl core: registered pin 403 (48002356) on pinctrl-single

+ pinctrl core: registered pin 404 (48002358) on pinctrl-single

+ pinctrl core: registered pin 405 (4800235a) on pinctrl-single

+ pinctrl core: registered pin 406 (4800235c) on pinctrl-single

+ pinctrl core: registered pin 407 (4800235e) on pinctrl-single

+ pinctrl core: registered pin 408 (48002360) on pinctrl-single

+ pinctrl core: registered pin 409 (48002362) on pinctrl-single

+ pinctrl core: registered pin 410 (48002364) on pinctrl-single

+ pinctrl core: registered pin 411 (48002366) on pinctrl-single

+ pinctrl core: registered pin 412 (48002368) on pinctrl-single

+ pinctrl core: registered pin 413 (4800236a) on pinctrl-single

+ pinctrl core: registered pin 414 (4800236c) on pinctrl-single

+ pinctrl core: registered pin 415 (4800236e) on pinctrl-single

+ pinctrl core: registered pin 416 (48002370) on pinctrl-single

+ pinctrl core: registered pin 417 (48002372) on pinctrl-single

+ pinctrl core: registered pin 418 (48002374) on pinctrl-single

+ pinctrl core: registered pin 419 (48002376) on pinctrl-single

+ pinctrl core: registered pin 420 (48002378) on pinctrl-single

+ pinctrl core: registered pin 421 (4800237a) on pinctrl-single

+ pinctrl core: registered pin 422 (4800237c) on pinctrl-single

+ pinctrl core: registered pin 423 (4800237e) on pinctrl-single

+ pinctrl core: registered pin 424 (48002380) on pinctrl-single

+ pinctrl core: registered pin 425 (48002382) on pinctrl-single

+ pinctrl core: registered pin 426 (48002384) on pinctrl-single

+ pinctrl core: registered pin 427 (48002386) on pinctrl-single

+ pinctrl core: registered pin 428 (48002388) on pinctrl-single

+ pinctrl core: registered pin 429 (4800238a) on pinctrl-single

+ pinctrl core: registered pin 430 (4800238c) on pinctrl-single

+ pinctrl core: registered pin 431 (4800238e) on pinctrl-single

+ pinctrl core: registered pin 432 (48002390) on pinctrl-single

+ pinctrl core: registered pin 433 (48002392) on pinctrl-single

+ pinctrl core: registered pin 434 (48002394) on pinctrl-single

+ pinctrl core: registered pin 435 (48002396) on pinctrl-single

+ pinctrl core: registered pin 436 (48002398) on pinctrl-single

+ pinctrl core: registered pin 437 (4800239a) on pinctrl-single

+ pinctrl core: registered pin 438 (4800239c) on pinctrl-single

+ pinctrl core: registered pin 439 (4800239e) on pinctrl-single

+ pinctrl core: registered pin 440 (480023a0) on pinctrl-single

+ pinctrl core: registered pin 441 (480023a2) on pinctrl-single

+ pinctrl core: registered pin 442 (480023a4) on pinctrl-single

+ pinctrl core: registered pin 443 (480023a6) on pinctrl-single

+ pinctrl core: registered pin 444 (480023a8) on pinctrl-single

+ pinctrl core: registered pin 445 (480023aa) on pinctrl-single

+ pinctrl core: registered pin 446 (480023ac) on pinctrl-single

+ pinctrl core: registered pin 447 (480023ae) on pinctrl-single

+ pinctrl core: registered pin 448 (480023b0) on pinctrl-single

+ pinctrl core: registered pin 449 (480023b2) on pinctrl-single

+ pinctrl core: registered pin 450 (480023b4) on pinctrl-single

+ pinctrl core: registered pin 451 (480023b6) on pinctrl-single

+ pinctrl core: registered pin 452 (480023b8) on pinctrl-single

+ pinctrl core: registered pin 453 (480023ba) on pinctrl-single

+ pinctrl core: registered pin 454 (480023bc) on pinctrl-single

+ pinctrl core: registered pin 455 (480023be) on pinctrl-single

+ pinctrl core: registered pin 456 (480023c0) on pinctrl-single

+ pinctrl core: registered pin 457 (480023c2) on pinctrl-single

+ pinctrl core: registered pin 458 (480023c4) on pinctrl-single

+ pinctrl core: registered pin 459 (480023c6) on pinctrl-single

+ pinctrl core: registered pin 460 (480023c8) on pinctrl-single

+ pinctrl core: registered pin 461 (480023ca) on pinctrl-single

+ pinctrl core: registered pin 462 (480023cc) on pinctrl-single

+ pinctrl core: registered pin 463 (480023ce) on pinctrl-single

+ pinctrl core: registered pin 464 (480023d0) on pinctrl-single

+ pinctrl core: registered pin 465 (480023d2) on pinctrl-single

+ pinctrl core: registered pin 466 (480023d4) on pinctrl-single

+ pinctrl core: registered pin 467 (480023d6) on pinctrl-single

+ pinctrl core: registered pin 468 (480023d8) on pinctrl-single

+ pinctrl core: registered pin 469 (480023da) on pinctrl-single

+ pinctrl core: registered pin 470 (480023dc) on pinctrl-single

+ pinctrl core: registered pin 471 (480023de) on pinctrl-single

+ pinctrl core: registered pin 472 (480023e0) on pinctrl-single

+ pinctrl core: registered pin 473 (480023e2) on pinctrl-single

+ pinctrl core: registered pin 474 (480023e4) on pinctrl-single

+ pinctrl core: registered pin 475 (480023e6) on pinctrl-single

+ pinctrl core: registered pin 476 (480023e8) on pinctrl-single

+ pinctrl core: registered pin 477 (480023ea) on pinctrl-single

+ pinctrl core: registered pin 478 (480023ec) on pinctrl-single

+ pinctrl core: registered pin 479 (480023ee) on pinctrl-single

+ pinctrl core: registered pin 480 (480023f0) on pinctrl-single

+ pinctrl core: registered pin 481 (480023f2) on pinctrl-single

+ pinctrl core: registered pin 482 (480023f4) on pinctrl-single

+ pinctrl core: registered pin 483 (480023f6) on pinctrl-single

+ pinctrl core: registered pin 484 (480023f8) on pinctrl-single

+ pinctrl core: registered pin 485 (480023fa) on pinctrl-single

+ pinctrl core: registered pin 486 (480023fc) on pinctrl-single

+ pinctrl core: registered pin 487 (480023fe) on pinctrl-single

+ pinctrl core: registered pin 488 (48002400) on pinctrl-single

+ pinctrl core: registered pin 489 (48002402) on pinctrl-single

+ pinctrl core: registered pin 490 (48002404) on pinctrl-single

+ pinctrl core: registered pin 491 (48002406) on pinctrl-single

+ pinctrl core: registered pin 492 (48002408) on pinctrl-single

+ pinctrl core: registered pin 493 (4800240a) on pinctrl-single

+ pinctrl core: registered pin 494 (4800240c) on pinctrl-single

+ pinctrl core: registered pin 495 (4800240e) on pinctrl-single

+ pinctrl core: registered pin 496 (48002410) on pinctrl-single

+ pinctrl core: registered pin 497 (48002412) on pinctrl-single

+ pinctrl core: registered pin 498 (48002414) on pinctrl-single

+ pinctrl core: registered pin 499 (48002416) on pinctrl-single

+ pinctrl core: registered pin 500 (48002418) on pinctrl-single

+ pinctrl core: registered pin 501 (4800241a) on pinctrl-single

+ pinctrl core: registered pin 502 (4800241c) on pinctrl-single

+ pinctrl core: registered pin 503 (4800241e) on pinctrl-single

+ pinctrl core: registered pin 504 (48002420) on pinctrl-single

+ pinctrl core: registered pin 505 (48002422) on pinctrl-single

+ pinctrl core: registered pin 506 (48002424) on pinctrl-single

+ pinctrl core: registered pin 507 (48002426) on pinctrl-single

+ pinctrl core: registered pin 508 (48002428) on pinctrl-single

+ pinctrl core: registered pin 509 (4800242a) on pinctrl-single

+ pinctrl core: registered pin 510 (4800242c) on pinctrl-single

+ pinctrl core: registered pin 511 (4800242e) on pinctrl-single

+ pinctrl core: registered pin 512 (48002430) on pinctrl-single

+ pinctrl core: registered pin 513 (48002432) on pinctrl-single

+ pinctrl core: registered pin 514 (48002434) on pinctrl-single

+ pinctrl core: registered pin 515 (48002436) on pinctrl-single

+ pinctrl core: registered pin 516 (48002438) on pinctrl-single

+ pinctrl core: registered pin 517 (4800243a) on pinctrl-single

+ pinctrl core: registered pin 518 (4800243c) on pinctrl-single

+ pinctrl core: registered pin 519 (4800243e) on pinctrl-single

+ pinctrl core: registered pin 520 (48002440) on pinctrl-single

+ pinctrl core: registered pin 521 (48002442) on pinctrl-single

+ pinctrl core: registered pin 522 (48002444) on pinctrl-single

+ pinctrl core: registered pin 523 (48002446) on pinctrl-single

+ pinctrl core: registered pin 524 (48002448) on pinctrl-single

+ pinctrl core: registered pin 525 (4800244a) on pinctrl-single

+ pinctrl core: registered pin 526 (4800244c) on pinctrl-single

+ pinctrl core: registered pin 527 (4800244e) on pinctrl-single

+ pinctrl core: registered pin 528 (48002450) on pinctrl-single

+ pinctrl core: registered pin 529 (48002452) on pinctrl-single

+ pinctrl core: registered pin 530 (48002454) on pinctrl-single

+ pinctrl core: registered pin 531 (48002456) on pinctrl-single

+ pinctrl core: registered pin 532 (48002458) on pinctrl-single

+ pinctrl core: registered pin 533 (4800245a) on pinctrl-single

+ pinctrl core: registered pin 534 (4800245c) on pinctrl-single

+ pinctrl core: registered pin 535 (4800245e) on pinctrl-single

+ pinctrl core: registered pin 536 (48002460) on pinctrl-single

+ pinctrl core: registered pin 537 (48002462) on pinctrl-single

+ pinctrl core: registered pin 538 (48002464) on pinctrl-single

+ pinctrl core: registered pin 539 (48002466) on pinctrl-single

+ pinctrl core: registered pin 540 (48002468) on pinctrl-single

+ pinctrl core: registered pin 541 (4800246a) on pinctrl-single

+ pinctrl core: registered pin 542 (4800246c) on pinctrl-single

+ pinctrl core: registered pin 543 (4800246e) on pinctrl-single

+ pinctrl core: registered pin 544 (48002470) on pinctrl-single

+ pinctrl core: registered pin 545 (48002472) on pinctrl-single

+ pinctrl core: registered pin 546 (48002474) on pinctrl-single

+ pinctrl core: registered pin 547 (48002476) on pinctrl-single

+ pinctrl core: registered pin 548 (48002478) on pinctrl-single

+ pinctrl core: registered pin 549 (4800247a) on pinctrl-single

+ pinctrl core: registered pin 550 (4800247c) on pinctrl-single

+ pinctrl core: registered pin 551 (4800247e) on pinctrl-single

+ pinctrl core: registered pin 552 (48002480) on pinctrl-single

+ pinctrl core: registered pin 553 (48002482) on pinctrl-single

+ pinctrl core: registered pin 554 (48002484) on pinctrl-single

+ pinctrl core: registered pin 555 (48002486) on pinctrl-single

+ pinctrl core: registered pin 556 (48002488) on pinctrl-single

+ pinctrl core: registered pin 557 (4800248a) on pinctrl-single

+ pinctrl core: registered pin 558 (4800248c) on pinctrl-single

+ pinctrl core: registered pin 559 (4800248e) on pinctrl-single

+ pinctrl core: registered pin 560 (48002490) on pinctrl-single

+ pinctrl core: registered pin 561 (48002492) on pinctrl-single

+ pinctrl core: registered pin 562 (48002494) on pinctrl-single

+ pinctrl core: registered pin 563 (48002496) on pinctrl-single

+ pinctrl core: registered pin 564 (48002498) on pinctrl-single

+ pinctrl core: registered pin 565 (4800249a) on pinctrl-single

+ pinctrl core: registered pin 566 (4800249c) on pinctrl-single

+ pinctrl core: registered pin 567 (4800249e) on pinctrl-single

+ pinctrl core: registered pin 568 (480024a0) on pinctrl-single

+ pinctrl core: registered pin 569 (480024a2) on pinctrl-single

+ pinctrl core: registered pin 570 (480024a4) on pinctrl-single

+ pinctrl core: registered pin 571 (480024a6) on pinctrl-single

+ pinctrl core: registered pin 572 (480024a8) on pinctrl-single

+ pinctrl core: registered pin 573 (480024aa) on pinctrl-single

+ pinctrl core: registered pin 574 (480024ac) on pinctrl-single

+ pinctrl core: registered pin 575 (480024ae) on pinctrl-single

+ pinctrl core: registered pin 576 (480024b0) on pinctrl-single

+ pinctrl core: registered pin 577 (480024b2) on pinctrl-single

+ pinctrl core: registered pin 578 (480024b4) on pinctrl-single

+ pinctrl core: registered pin 579 (480024b6) on pinctrl-single

+ pinctrl core: registered pin 580 (480024b8) on pinctrl-single

+ pinctrl core: registered pin 581 (480024ba) on pinctrl-single

+ pinctrl core: registered pin 582 (480024bc) on pinctrl-single

+ pinctrl core: registered pin 583 (480024be) on pinctrl-single

+ pinctrl core: registered pin 584 (480024c0) on pinctrl-single

+ pinctrl core: registered pin 585 (480024c2) on pinctrl-single

+ pinctrl core: registered pin 586 (480024c4) on pinctrl-single

+ pinctrl core: registered pin 587 (480024c6) on pinctrl-single

+ pinctrl core: registered pin 588 (480024c8) on pinctrl-single

+ pinctrl core: registered pin 589 (480024ca) on pinctrl-single

+ pinctrl core: registered pin 590 (480024cc) on pinctrl-single

+ pinctrl core: registered pin 591 (480024ce) on pinctrl-single

+ pinctrl core: registered pin 592 (480024d0) on pinctrl-single

+ pinctrl core: registered pin 593 (480024d2) on pinctrl-single

+ pinctrl core: registered pin 594 (480024d4) on pinctrl-single

+ pinctrl core: registered pin 595 (480024d6) on pinctrl-single

+ pinctrl core: registered pin 596 (480024d8) on pinctrl-single

+ pinctrl core: registered pin 597 (480024da) on pinctrl-single

+ pinctrl core: registered pin 598 (480024dc) on pinctrl-single

+ pinctrl core: registered pin 599 (480024de) on pinctrl-single

+ pinctrl core: registered pin 600 (480024e0) on pinctrl-single

+ pinctrl core: registered pin 601 (480024e2) on pinctrl-single

+ pinctrl core: registered pin 602 (480024e4) on pinctrl-single

+ pinctrl core: registered pin 603 (480024e6) on pinctrl-single

+ pinctrl core: registered pin 604 (480024e8) on pinctrl-single

+ pinctrl core: registered pin 605 (480024ea) on pinctrl-single

+ pinctrl core: registered pin 606 (480024ec) on pinctrl-single

+ pinctrl core: registered pin 607 (480024ee) on pinctrl-single

+ pinctrl core: registered pin 608 (480024f0) on pinctrl-single

+ pinctrl core: registered pin 609 (480024f2) on pinctrl-single

+ pinctrl core: registered pin 610 (480024f4) on pinctrl-single

+ pinctrl core: registered pin 611 (480024f6) on pinctrl-single

+ pinctrl core: registered pin 612 (480024f8) on pinctrl-single

+ pinctrl core: registered pin 613 (480024fa) on pinctrl-single

+ pinctrl core: registered pin 614 (480024fc) on pinctrl-single

+ pinctrl core: registered pin 615 (480024fe) on pinctrl-single

+ pinctrl core: registered pin 616 (48002500) on pinctrl-single

+ pinctrl core: registered pin 617 (48002502) on pinctrl-single

+ pinctrl core: registered pin 618 (48002504) on pinctrl-single

+ pinctrl core: registered pin 619 (48002506) on pinctrl-single

+ pinctrl core: registered pin 620 (48002508) on pinctrl-single

+ pinctrl core: registered pin 621 (4800250a) on pinctrl-single

+ pinctrl core: registered pin 622 (4800250c) on pinctrl-single

+ pinctrl core: registered pin 623 (4800250e) on pinctrl-single

+ pinctrl core: registered pin 624 (48002510) on pinctrl-single

+ pinctrl core: registered pin 625 (48002512) on pinctrl-single

+ pinctrl core: registered pin 626 (48002514) on pinctrl-single

+ pinctrl core: registered pin 627 (48002516) on pinctrl-single

+ pinctrl core: registered pin 628 (48002518) on pinctrl-single

+ pinctrl core: registered pin 629 (4800251a) on pinctrl-single

+ pinctrl core: registered pin 630 (4800251c) on pinctrl-single

+ pinctrl core: registered pin 631 (4800251e) on pinctrl-single

+ pinctrl core: registered pin 632 (48002520) on pinctrl-single

+ pinctrl core: registered pin 633 (48002522) on pinctrl-single

+ pinctrl core: registered pin 634 (48002524) on pinctrl-single

+ pinctrl core: registered pin 635 (48002526) on pinctrl-single

+ pinctrl core: registered pin 636 (48002528) on pinctrl-single

+ pinctrl core: registered pin 637 (4800252a) on pinctrl-single

+ pinctrl core: registered pin 638 (4800252c) on pinctrl-single

+ pinctrl core: registered pin 639 (4800252e) on pinctrl-single

+ pinctrl core: registered pin 640 (48002530) on pinctrl-single

+ pinctrl core: registered pin 641 (48002532) on pinctrl-single

+ pinctrl core: registered pin 642 (48002534) on pinctrl-single

+ pinctrl core: registered pin 643 (48002536) on pinctrl-single

+ pinctrl core: registered pin 644 (48002538) on pinctrl-single

+ pinctrl core: registered pin 645 (4800253a) on pinctrl-single

+ pinctrl core: registered pin 646 (4800253c) on pinctrl-single

+ pinctrl core: registered pin 647 (4800253e) on pinctrl-single

+ pinctrl core: registered pin 648 (48002540) on pinctrl-single

+ pinctrl core: registered pin 649 (48002542) on pinctrl-single

+ pinctrl core: registered pin 650 (48002544) on pinctrl-single

+ pinctrl core: registered pin 651 (48002546) on pinctrl-single

+ pinctrl core: registered pin 652 (48002548) on pinctrl-single

+ pinctrl core: registered pin 653 (4800254a) on pinctrl-single

+ pinctrl core: registered pin 654 (4800254c) on pinctrl-single

+ pinctrl core: registered pin 655 (4800254e) on pinctrl-single

+ pinctrl core: registered pin 656 (48002550) on pinctrl-single

+ pinctrl core: registered pin 657 (48002552) on pinctrl-single

+ pinctrl core: registered pin 658 (48002554) on pinctrl-single

+ pinctrl core: registered pin 659 (48002556) on pinctrl-single

+ pinctrl core: registered pin 660 (48002558) on pinctrl-single

+ pinctrl core: registered pin 661 (4800255a) on pinctrl-single

+ pinctrl core: registered pin 662 (4800255c) on pinctrl-single

+ pinctrl core: registered pin 663 (4800255e) on pinctrl-single

+ pinctrl core: registered pin 664 (48002560) on pinctrl-single

+ pinctrl core: registered pin 665 (48002562) on pinctrl-single

+ pinctrl core: registered pin 666 (48002564) on pinctrl-single

+ pinctrl core: registered pin 667 (48002566) on pinctrl-single

+ pinctrl core: registered pin 668 (48002568) on pinctrl-single

+ pinctrl core: registered pin 669 (4800256a) on pinctrl-single

+ pinctrl core: registered pin 670 (4800256c) on pinctrl-single

+ pinctrl core: registered pin 671 (4800256e) on pinctrl-single

+ pinctrl core: registered pin 672 (48002570) on pinctrl-single

+ pinctrl core: registered pin 673 (48002572) on pinctrl-single

+ pinctrl core: registered pin 674 (48002574) on pinctrl-single

+ pinctrl core: registered pin 675 (48002576) on pinctrl-single

+ pinctrl core: registered pin 676 (48002578) on pinctrl-single

+ pinctrl core: registered pin 677 (4800257a) on pinctrl-single

+ pinctrl core: registered pin 678 (4800257c) on pinctrl-single

+ pinctrl core: registered pin 679 (4800257e) on pinctrl-single

+ pinctrl core: registered pin 680 (48002580) on pinctrl-single

+ pinctrl core: registered pin 681 (48002582) on pinctrl-single

+ pinctrl core: registered pin 682 (48002584) on pinctrl-single

+ pinctrl core: registered pin 683 (48002586) on pinctrl-single

+ pinctrl core: registered pin 684 (48002588) on pinctrl-single

+ pinctrl core: registered pin 685 (4800258a) on pinctrl-single

+ pinctrl core: registered pin 686 (4800258c) on pinctrl-single

+ pinctrl core: registered pin 687 (4800258e) on pinctrl-single

+ pinctrl core: registered pin 688 (48002590) on pinctrl-single

+ pinctrl core: registered pin 689 (48002592) on pinctrl-single

+ pinctrl core: registered pin 690 (48002594) on pinctrl-single

+ pinctrl core: registered pin 691 (48002596) on pinctrl-single

+ pinctrl core: registered pin 692 (48002598) on pinctrl-single

+ pinctrl core: registered pin 693 (4800259a) on pinctrl-single

+ pinctrl core: registered pin 694 (4800259c) on pinctrl-single

+ pinctrl core: registered pin 695 (4800259e) on pinctrl-single

+ pinctrl core: registered pin 696 (480025a0) on pinctrl-single

+ pinctrl core: registered pin 697 (480025a2) on pinctrl-single

+ pinctrl core: registered pin 698 (480025a4) on pinctrl-single

+ pinctrl core: registered pin 699 (480025a6) on pinctrl-single

+ pinctrl core: registered pin 700 (480025a8) on pinctrl-single

+ pinctrl core: registered pin 701 (480025aa) on pinctrl-single

+ pinctrl core: registered pin 702 (480025ac) on pinctrl-single

+ pinctrl core: registered pin 703 (480025ae) on pinctrl-single

+ pinctrl core: registered pin 704 (480025b0) on pinctrl-single

+ pinctrl core: registered pin 705 (480025b2) on pinctrl-single

+ pinctrl core: registered pin 706 (480025b4) on pinctrl-single

+ pinctrl core: registered pin 707 (480025b6) on pinctrl-single

+ pinctrl core: registered pin 708 (480025b8) on pinctrl-single

+ pinctrl core: registered pin 709 (480025ba) on pinctrl-single

+ pinctrl core: registered pin 710 (480025bc) on pinctrl-single

+ pinctrl core: registered pin 711 (480025be) on pinctrl-single

+ pinctrl core: registered pin 712 (480025c0) on pinctrl-single

+ pinctrl core: registered pin 713 (480025c2) on pinctrl-single

+ pinctrl core: registered pin 714 (480025c4) on pinctrl-single

+ pinctrl core: registered pin 715 (480025c6) on pinctrl-single

+ pinctrl core: registered pin 716 (480025c8) on pinctrl-single

+ pinctrl core: registered pin 717 (480025ca) on pinctrl-single

+ pinctrl core: registered pin 718 (480025cc) on pinctrl-single

+ pinctrl core: registered pin 719 (480025ce) on pinctrl-single

+ pinctrl core: registered pin 720 (480025d0) on pinctrl-single

+ pinctrl core: registered pin 721 (480025d2) on pinctrl-single

+ pinctrl core: registered pin 722 (480025d4) on pinctrl-single

+ pinctrl core: registered pin 723 (480025d6) on pinctrl-single

+ pinctrl core: registered pin 724 (480025d8) on pinctrl-single

+ pinctrl core: registered pin 725 (480025da) on pinctrl-single

+ pinctrl core: registered pin 726 (480025dc) on pinctrl-single

+ pinctrl core: registered pin 727 (480025de) on pinctrl-single

+ pinctrl core: registered pin 728 (480025e0) on pinctrl-single

+ pinctrl core: registered pin 729 (480025e2) on pinctrl-single

+ pinctrl core: registered pin 730 (480025e4) on pinctrl-single

+ pinctrl core: registered pin 731 (480025e6) on pinctrl-single

+ pinctrl core: registered pin 732 (480025e8) on pinctrl-single

+ pinctrl core: registered pin 733 (480025ea) on pinctrl-single

+ pinctrl core: registered pin 734 (480025ec) on pinctrl-single

+ pinctrl core: registered pin 735 (480025ee) on pinctrl-single

+ pinctrl core: registered pin 736 (480025f0) on pinctrl-single

+ pinctrl core: registered pin 737 (480025f2) on pinctrl-single

+ pinctrl core: registered pin 738 (480025f4) on pinctrl-single

+ pinctrl core: registered pin 739 (480025f6) on pinctrl-single

+ pinctrl core: registered pin 740 (480025f8) on pinctrl-single

+ pinctrl core: registered pin 741 (480025fa) on pinctrl-single

+ pinctrl core: add 1 pinmux maps

+ pinctrl-single 48002030.pinmux: found group selector 0 for pinmux_all_pins

+ pinctrl-single 48002030.pinmux: request pin 115 (48002116) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 116 (48002118) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 125 (4800212a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 126 (4800212c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 117 (4800211a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 118 (4800211c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 119 (4800211e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 120 (48002120) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 121 (48002122) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 122 (48002124) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 123 (48002126) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 124 (48002128) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 114 (48002114) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 110 (4800210c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 113 (48002112) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 129 (48002132) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 111 (4800210e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 128 (48002130) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 112 (48002110) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 127 (4800212e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 130 (48002134) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 132 (48002138) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 131 (48002136) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 133 (4800213a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 85 (480020da) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 86 (480020dc) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 87 (480020de) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 96 (480020f0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 97 (480020f2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 98 (480020f4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 99 (480020f6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 100 (480020f8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 101 (480020fa) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 102 (480020fc) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 103 (480020fe) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 104 (48002100) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 105 (48002102) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 106 (48002104) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 107 (48002106) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 108 (48002108) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 109 (4800210a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 88 (480020e0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 89 (480020e2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 90 (480020e4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 91 (480020e6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 92 (480020e8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 93 (480020ea) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 94 (480020ec) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 95 (480020ee) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 83 (480020d6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 82 (480020d4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 84 (480020d8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 724 (480025d8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 725 (480025da) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 726 (480025dc) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 727 (480025de) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 736 (480025f0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 737 (480025f2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 738 (480025f4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 739 (480025f6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 740 (480025f8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 741 (480025fa) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 728 (480025e0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 729 (480025e2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 730 (480025e4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 731 (480025e6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 732 (480025e8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 733 (480025ea) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 734 (480025ec) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 735 (480025ee) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 37 (4800207a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 46 (4800208c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 38 (4800207c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 39 (4800207e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 40 (48002080) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 41 (48002082) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 42 (48002084) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 43 (48002086) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 44 (48002088) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 45 (4800208a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 71 (480020be) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 57 (480020a2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 58 (480020a4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 59 (480020a6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 60 (480020a8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 61 (480020aa) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 62 (480020ac) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 55 (4800209e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 56 (480020a0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 75 (480020c6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 76 (480020c8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 64 (480020b0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 65 (480020b2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 66 (480020b4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 67 (480020b6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 68 (480020b8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 69 (480020ba) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 70 (480020bc) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 77 (480020ca) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 79 (480020ce) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 80 (480020d0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 81 (480020d2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 203 (480021c6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 185 (480021a2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 189 (480021aa) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 190 (480021ac) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 191 (480021ae) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 192 (480021b0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 193 (480021b2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 194 (480021b4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 195 (480021b6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 196 (480021b8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 187 (480021a6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 188 (480021a8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 186 (480021a4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 199 (480021be) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 200 (480021c0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 201 (480021c2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 202 (480021c4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 174 (4800218c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 180 (48002198) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 177 (48002192) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 176 (48002190) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 175 (4800218e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 179 (48002196) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 135 (4800213e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 136 (48002140) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 137 (48002142) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 134 (4800213c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 160 (48002170) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 159 (4800216e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 158 (4800216c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 161 (48002172) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 170 (48002184) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 171 (48002186) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 172 (48002188) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 173 (4800218a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 178 (48002194) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 204 (480021c8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 207 (480021ce) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 208 (480021d0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 209 (480021d2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 210 (480021d4) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 205 (480021ca) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 206 (480021cc) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 211 (480021d6) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 214 (480021dc) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 215 (480021de) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 212 (480021d8) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 213 (480021da) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 138 (48002144) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 139 (48002146) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 140 (48002148) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 141 (4800214a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 142 (4800214c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 143 (4800214e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 144 (48002150) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 145 (48002152) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 146 (48002154) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 147 (48002156) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 148 (48002158) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 149 (4800215a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 150 (4800215c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 151 (4800215e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 152 (48002160) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 153 (48002162) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 154 (48002164) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 155 (48002166) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 156 (48002168) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 157 (4800216a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 281 (48002262) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 282 (48002264) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 217 (480021e2) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 216 (480021e0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 168 (48002180) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 167 (4800217e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 169 (48002182) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 166 (4800217c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 162 (48002174) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 163 (48002176) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 165 (4800217a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 164 (48002178) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 181 (4800219a) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 182 (4800219c) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 183 (4800219e) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: request pin 184 (480021a0) for 48002030.pinmux

+ pinctrl-single 48002030.pinmux: enabling pinmux_all_pins function0

+ pinctrl-single 48002030.pinmux: using pinctrl dummy state (sleep)

+ pinctrl-single 48002030.pinmux: 742 pins at pa fa002030 size 1484

+ pinctrl-single 48002a58.pinmux: allocating 46 pins

+ pinctrl-single 48002a58.pinmux: try to register 46 pins ...

+ pinctrl core: registered pin 0 (48002a58) on pinctrl-single

+ pinctrl core: registered pin 1 (48002a5a) on pinctrl-single

+ pinctrl core: registered pin 2 (48002a5c) on pinctrl-single

+ pinctrl core: registered pin 3 (48002a5e) on pinctrl-single

+ pinctrl core: registered pin 4 (48002a60) on pinctrl-single

+ pinctrl core: registered pin 5 (48002a62) on pinctrl-single

+ pinctrl core: registered pin 6 (48002a64) on pinctrl-single

+ pinctrl core: registered pin 7 (48002a66) on pinctrl-single

+ pinctrl core: registered pin 8 (48002a68) on pinctrl-single

+ pinctrl core: registered pin 9 (48002a6a) on pinctrl-single

+ pinctrl core: registered pin 10 (48002a6c) on pinctrl-single

+ pinctrl core: registered pin 11 (48002a6e) on pinctrl-single

+ pinctrl core: registered pin 12 (48002a70) on pinctrl-single

+ pinctrl core: registered pin 13 (48002a72) on pinctrl-single

+ pinctrl core: registered pin 14 (48002a74) on pinctrl-single

+ pinctrl core: registered pin 15 (48002a76) on pinctrl-single

+ pinctrl core: registered pin 16 (48002a78) on pinctrl-single

+ pinctrl core: registered pin 17 (48002a7a) on pinctrl-single

+ pinctrl core: registered pin 18 (48002a7c) on pinctrl-single

+ pinctrl core: registered pin 19 (48002a7e) on pinctrl-single

+ pinctrl core: registered pin 20 (48002a80) on pinctrl-single

+ pinctrl core: registered pin 21 (48002a82) on pinctrl-single

+ pinctrl core: registered pin 22 (48002a84) on pinctrl-single

+ pinctrl core: registered pin 23 (48002a86) on pinctrl-single

+ pinctrl core: registered pin 24 (48002a88) on pinctrl-single

+ pinctrl core: registered pin 25 (48002a8a) on pinctrl-single

+ pinctrl core: registered pin 26 (48002a8c) on pinctrl-single

+ pinctrl core: registered pin 27 (48002a8e) on pinctrl-single

+ pinctrl core: registered pin 28 (48002a90) on pinctrl-single

+ pinctrl core: registered pin 29 (48002a92) on pinctrl-single

+ pinctrl core: registered pin 30 (48002a94) on pinctrl-single

+ pinctrl core: registered pin 31 (48002a96) on pinctrl-single

+ pinctrl core: registered pin 32 (48002a98) on pinctrl-single

+ pinctrl core: registered pin 33 (48002a9a) on pinctrl-single

+ pinctrl core: registered pin 34 (48002a9c) on pinctrl-single

+ pinctrl core: registered pin 35 (48002a9e) on pinctrl-single

+ pinctrl core: registered pin 36 (48002aa0) on pinctrl-single

+ pinctrl core: registered pin 37 (48002aa2) on pinctrl-single

+ pinctrl core: registered pin 38 (48002aa4) on pinctrl-single

+ pinctrl core: registered pin 39 (48002aa6) on pinctrl-single

+ pinctrl core: registered pin 40 (48002aa8) on pinctrl-single

+ pinctrl core: registered pin 41 (48002aaa) on pinctrl-single

+ pinctrl core: registered pin 42 (48002aac) on pinctrl-single

+ pinctrl core: registered pin 43 (48002aae) on pinctrl-single

+ pinctrl core: registered pin 44 (48002ab0) on pinctrl-single

+ pinctrl core: registered pin 45 (48002ab2) on pinctrl-single

+ pinctrl-single 48002a58.pinmux: mux offset out of range: 0x9d0 (0x5c)

+ pinctrl-single 48002a58.pinmux: could not add functions for pinmux_wakeup_pins 2512x

+ pinctrl core: add 1 pinmux maps

+ pinctrl-single 48002a58.pinmux: found group selector 0 for pinmux_wakeup_pins

+ pinctrl-single 48002a58.pinmux: enabling pinmux_wakeup_pins function0

+ pinctrl-single 48002a58.pinmux: using pinctrl dummy state (sleep)

+ pinctrl-single 48002a58.pinmux: 46 pins at pa fa002a58 size 92

+ omapvrfb omapvrfb: no of_node; not parsing pinctrl DT

+ omapvrfb omapvrfb: using pinctrl dummy state (default)

+ omapdss omapdss: no of_node; not parsing pinctrl DT

+ omapdss omapdss: using pinctrl dummy state (default)

+ omapdss_dss omapdss_dss: no of_node; not parsing pinctrl DT

+ omapdss_dss omapdss_dss: using pinctrl dummy state (default)

 ------------

  WARNING: at drivers/video/omap2/dss/dss.c:495 dss_set_clock_div+0x90/0xbc()

  clk rate mismatch

@@ -199,18 +1232,47 @@ Booting secondary
  (ret_from_fork+0x14/0x3c)

 ---

  OMAP DSS rev 2.0

+ omapdss_dispc omapdss_dispc: no of_node; not parsing pinctrl DT

+ omapdss_dispc omapdss_dispc: using pinctrl dummy state (default)

+ omapdss_sdi omapdss_sdi: no of_node; not parsing pinctrl DT

+ omapdss_sdi omapdss_sdi: using pinctrl dummy state (default)

+ omapdss_venc omapdss_venc: no of_node; not parsing pinctrl DT

+ omapdss_venc omapdss_venc: using pinctrl dummy state (default)

+ venc display1: no of_node; not parsing pinctrl DT

+ venc display1: using pinctrl dummy state (default)

  Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled

+ serial8250 serial8250: no of_node; not parsing pinctrl DT

+ serial8250 serial8250: using pinctrl dummy state (default)

+ omap_uart serial.10: using pinctrl dummy state (default)

+ omap_uart serial.10: obtain a copy of previously claimed pinctrl

  serial.10: ttyO0 at MMIO 0x4806a000 (irq = 88) is a OMAP UART0

+ omap_uart serial.11: using pinctrl dummy state (default)

+ omap_uart serial.11: obtain a copy of previously claimed pinctrl

  serial.11: ttyO1 at MMIO 0x4806c000 (irq = 89) is a OMAP UART1

+ omap_uart serial.12: using pinctrl dummy state (default)

+ omap_uart serial.12: obtain a copy of previously claimed pinctrl

  serial.12: ttyO2 at MMIO 0x49020000 (irq = 90) is a OMAP UART2

  brd: module loaded

  loop: module loaded

  mtdoops: mtd device (mtddev=name/number) must be supplied

  OneNAND driver initializing

+ omap2_mcspi spi.16: using pinctrl dummy state (default)

+ omap2_mcspi spi.16: obtain a copy of previously claimed pinctrl

  omap-dma-engine omap-dma-engine: allocating channel for 40

  omap-dma-engine omap-dma-engine: allocating channel for 39

+ acx565akm spi1.2: using pinctrl dummy state (default)

+ panel-acx565akm display0: no of_node; not parsing pinctrl DT

+ panel-acx565akm display0: using pinctrl dummy state (default)

  acx565akm spi1.2: omapfb: acx565akm rev 12 LCD detected

+ omap2_mcspi spi.17: using pinctrl dummy state (default)

+ omap2_mcspi spi.17: obtain a copy of previously claimed pinctrl

+ omap2_mcspi spi.18: using pinctrl dummy state (default)

+ omap2_mcspi spi.18: obtain a copy of previously claimed pinctrl

+ omap2_mcspi spi.19: using pinctrl dummy state (default)

+ omap2_mcspi spi.19: obtain a copy of previously claimed pinctrl

  OMAP SSI hw driver loaded

+ omap_ssi omap_ssi.0: no of_node; not parsing pinctrl DT

+ omap_ssi omap_ssi.0: using pinctrl dummy state (default)

   port0: No Wake in support

  musb-hdrc: version 6.0, ?dma?, otg (peripheral+host)

  i2c /dev entries driver

@@ -219,11 +1281,22 @@ Booting secondary
  using legacy suspend method

  using legacy resume method

  I2C driver for BCM2048 FM Radio Receiver

+ omap_wdt wdt.20: using pinctrl dummy state (default)

  omap_wdt: OMAP Watchdog Timer Rev 0x31: initial timeout 60 sec

+ twl4030_wdt watchdog.22: using pinctrl dummy state (default)

  omap_cpufreq_init: physical regulator not present for MPU

  cpuidle: using governor ladder

  cpuidle: using governor menu

  ledtrig-cpu: registered to indicate activity on CPUs

+ snd-soc-dummy snd-soc-dummy: no of_node; not parsing pinctrl DT

+ snd-soc-dummy snd-soc-dummy: using pinctrl dummy state (default)

+ omap-pcm-audio omap-pcm-audio: no of_node; not parsing pinctrl DT

+ omap-pcm-audio omap-pcm-audio: using pinctrl dummy state (default)

+ omap-mcbsp 48074000.mcbsp: using pinctrl dummy state (default)

+ omap-mcbsp 49022000.mcbsp: using pinctrl dummy state (default)

+ omap-mcbsp 49024000.mcbsp: using pinctrl dummy state (default)

+ omap-mcbsp 49026000.mcbsp: using pinctrl dummy state (default)

+ omap-mcbsp 48096000.mcbsp: using pinctrl dummy state (default)

  TCP: cubic registered

  Initializing XFRM netlink socket

  NET: Registered protocol family 17

@@ -234,7 +1307,11 @@ Booting secondary
  ThumbEE CPU extension supported.

  Bootup reason: pwr_key

  OMAP GPIO switch handler initializing

+ gpio-switch gpio-switch: no of_node; not parsing pinctrl DT

+ gpio-switch gpio-switch: using pinctrl dummy state (default)

  registered taskstats version 1

+ omapfb omapfb: no of_node; not parsing pinctrl DT

+ omapfb omapfb: using pinctrl dummy state (default)

  Console: switching to colour frame buffer device 100x30

  VPLL2: disabling

  drivers/rtc/hctosys.c: unable to open rtc device (rtc0)


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
