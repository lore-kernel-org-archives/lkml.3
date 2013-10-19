Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3JSBDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 21:03:11 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:62332 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3JSBDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 21:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131019101417.3f353c82@notabene.brown>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
 <1380971830-21492-4-git-send-email-afenkart@gmail.com> <20131018172053.70cf2c2b@notabene.brown>
 <CAAwP0s1vNcRrekDbJOdm5vzk3VEWRm-5g8c9s+6KPczFj7LBsA@mail.gmail.com> <20131019101417.3f353c82@notabene.brown>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Sat, 19 Oct 2013 03:02:45 +0200
Message-ID: <CAAwP0s0bjOu-AWLtW30Rnww2TSsT7g5U=4VSe=gYNiQQw3C_HQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] mmc: omap_hsmmc: Remux pins to support SDIO
 interrupt on AM335x
To: NeilBrown <neilb@suse.de>, Enric Balletbo Serra <eballetbo@gmail.com>
Cc: Andreas Fenkart <afenkart@gmail.com>, Chris Ball <cjb@laptop.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Venkatraman S <svenkatr@ti.com>, Balaji T K <balajitk@ti.com>,
        zonque <zonque@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mmc@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 1:14 AM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 18 Oct 2013 12:12:48 +0200 Javier Martinez Canillas
> <martinez.javier@gmail.com> wrote:
>
>> On Fri, Oct 18, 2013 at 8:20 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Sat,  5 Oct 2013 13:17:09 +0200 Andreas Fenkart <afenkart@gmail.com> wrote:
>> >
>> >> The am335x can't detect pending cirq in PM runtime suspend.
>> >> This patch reconfigures dat1 as a GPIO before going to suspend.
>> >> SDIO interrupts are detected with the GPIO, while in runtime
>> >> suspend, standard detection of the module block otherwise.
>> >>
>> >> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
>> >>
>> >> diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
>> >> index 1136e6b..146f3ad 100644
>> >> --- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
>> >> +++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
>> >> @@ -21,8 +21,11 @@ ti,non-removable: non-removable slot (like eMMC)
>> >>  ti,needs-special-reset: Requires a special softreset sequence
>> >>  ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
>> >>  ti,quirk-swakup-missing: SOC missing the swakeup line, will not detect
>> >> -SDIO irq while in suspend. Fallback to polling. Affected chips are
>> >> -am335x,
>> >> +SDIO irq while in suspend. The workaround is to reconfigure the dat1 line as a
>> >> +GPIO upon suspend. Beyond this option and the GPIO config, you also need to set
>> >> +named pinctrl states "default", "active" and "idle ", see example below.  The
>> >> +MMC driver will then then toggle between default and idle during the runtime
>> >> +Affected chips are am335x,
>> >>
>> >>                              ------
>> >>                              | PRCM |
>> >> @@ -49,3 +52,24 @@ Example:
>> >>               vmmc-supply = <&vmmc>; /* phandle to regulator node */
>> >>               ti,non-removable;
>> >>       };
>> >> +
>> >> +[am335x with with gpio for sdio irq]
>> >> +
>> >> +     mmc1_cirq_pin: pinmux_cirq_pin {
>> >> +             pinctrl-single,pins = <
>> >> +                     0x0f8 0x3f      /* MMC0_DAT1 as GPIO2_28 */
>> >> +             >;
>> >> +     };
>> >> +
>> >> +     mmc1: mmc@48060000 {
>> >> +             ti,non-removable;
>> >> +             bus-width = <4>;
>> >> +             vmmc-supply = <&ldo2_reg>;
>> >> +             vmmc_aux-supply = <&vmmc>;
>> >> +             ti,quirk-swakeup-missing;
>> >> +             pinctrl-names = "default", "active", "idle";
>> >> +             pinctrl-0 = <&mmc1_pins>;
>> >> +             pinctrl-1 = <&mmc1_pins>;
>> >> +             pinctrl-2 = <&mmc1_cirq_pin>;
>> >> +             ti,cirq-gpio = <&gpio3 28 0>;
>> >> +     };
>> >
>> >
>> > hi,
>> >  I've been trying to get SD irq to work on my  OMAP3 DM3730.
>> > I seems to need the magic to catch interrupts while FCLK is off, as
>> > the only way I can get it to work at the moment is to keep FCLK on.
>> >
>> > I discovered your patch and tried it out, but it doesn't seem to work for me.
>> >
>> > I have a Libertas WIFI chip attached to the second mmc (which is sometimes
>> > called mmc1, and sometimes mmc2 - very confusing!).
>>
>> Hi Neil,
>>
>> I have a DM3730 board with the same setup, Libertas (Marvell SD8686)
>> wifi + bt chip attached to mmc2.
>>
>> I was going to try to add support for this to the DTS but it would be
>> great if I can use your as a reference.
>>
>> Would you be so kind to share your DTS?
>>
>
> My DTS is below.  It contains an number of things that are not supported in
> mainline yet.  Details can be found in
>    git://neil.brown.name/gta04 mainline
> and
>    http://git.neil.brown.name/?p=gta04.git;a=shortlog;h=refs/heads/mainline
> (this is my working tree and gets rebased and messed up regularly).
>
> NeilBrown
>

Hello Neil,

Thanks a lot for your DTS and the pointers to your trees.

Best regards,
Javier

> /*
>  * Copyright (C) 2013 Marek Belisko <marek@goldelico.com>
>  *
>  * Based on omap3-beagle-xm.dts
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
>  */
> /dts-v1/;
> #define RFKILL_TYPE_GPS 6
> #include "omap36xx.dtsi"
>
> / {
>         model = "OMAP3 GTA04";
>         compatible = "ti,omap3-gta04", "ti,omap3";
>         chosen {
>                 bootargs = "console=ttyO2,115200n8 vram=12M omapfb.rotate_type=0 omapdss.def_disp=lcd root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait twl4030_charger.allow_usb=1 musb_hdrc.preserve_vbus=1 log_buf_len=8M ignore_loglevel no_console_suspend";
>         };
>
>         cpus {
>                 cpu@0 {
>                         cpu0-supply = <&vcc>;
>                 };
>         };
>
>         memory {
>                 device_type = "memory";
>                 reg = <0x80000000 0x20000000>; /* 512 MB */
>         };
>
>         aux-keys {
>                 compatible = "gpio-keys";
>
>                 aux-button {
>                         label = "aux";
>                         linux,code = <169>;
>                         gpios = <&gpio1 7 GPIO_ACTIVE_HIGH>;
>                         gpio-key,wakeup;
>                 };
>         };
>
>         incoming-keys {
>                 compatible = "gpio-keys";
>
>                 incoming-button {
>                         label = "Option";
>                         linux,code = <240>;
>                         /* 176 for A3, 10 for A4 */
>                         gpios = <&gpio6 16 GPIO_ACTIVE_HIGH>;
>                         gpio-key,wakeup;
>                 };
>         };
>
>         sound {
>                 compatible = "ti,omap-twl4030";
>                 ti,model = "gta04";
>
>                 ti,mcbsp = <&mcbsp2>;
>                 ti,codec = <&twl_audio>;
>         };
>
>         panel {
>                 compatible = "tpo,td028ttec1";
>                 display-name = "lcd";
>                 source     = "dpi.0";
>                 data-lines = <24>;
>                 cs-gpio    = <&gpio1 19 0>;
>                 scl-gpio   = <&gpio1 12 0>;
>                 din-gpio   = <&gpio1 18 0>;
>                 dout-gpio  = <&gpio1 20 0>;
>         };
>
>         backlight {
>                 compatible = "pwm-backlight";
>                 label = "pwm-backlight";
>                 pwms = <&pwm 0 2000000>;
>                 brightness-levels = <0 11 20 30 40 50 60 70 80 90 100>;
>                 default-brightness-level = <10>;
>         };
>
>         pwm: omap-pwm {
>                 compatible = "ti,omap-pwm";
>                 timers = <&timer11>;
>                 #pwm-cells = <2>;
>         };
>
>         /* need to connect uart1 DTR line to vaux4 */
>         btdtr: gpio-reg.bt {
>                 compatible = "gpio_regulator";
>                 vgpio-supply = <&vaux4>;
>                 microvolt = <3150000>;
>                 gpio-controller;
>                 #gpio-cells = <2>;
>         };
>
>         gps-rfkill {
>                 compatible = "rfkill-regulator";
>                 label = "GPS";
>                 type = <RFKILL_TYPE_GPS>;
>                 vrfkill-supply = <&vsim>;
>         };
>
>         gpsdtr: gps-onoff {
>                 compatible = "gpio-w2sg0004";
>                 gpios = <&gpio5 17 0>, <&gpio5 19 0>;
>                 /* MODE0 PULL_ENA(8) INPUT_EN(256) PULL_UP(16) */
>                 state-on = <280>;
>                 /* MODE4 PULL_ENA(8) INPUT_EN(256) PULL_UP(16) */
>                 state-off = <284>;
>                 gpio-controller;
>                 #gpio-cells = <2>;
>         };
> };
>
> &omap3_pmx_core {
>         uart1_pins: pinmux_uart1_pins {
>                 pinctrl-single,pins = <
>                         0x152 (PIN_INPUT | MUX_MODE0)           /* uart1_rx.uart1_rx */
>                         0x14c (PIN_OUTPUT |MUX_MODE0)           /* uart1_tx.uart1_tx */
>                 >;
>         };
>
>         uart2_pins: pinmux_uart2_pins {
>                 pinctrl-single,pins = <
>                         0x14a (PIN_INPUT | MUX_MODE0)           /* uart2_rx.uart2_rx */
>                         0x148 (PIN_OUTPUT | MUX_MODE0)          /* uart2_tx.uart2_tx */
>                 >;
>         };
>
>         uart3_pins: pinmux_uart3_pins {
>                 pinctrl-single,pins = <
>                         0x16e (PIN_INPUT | MUX_MODE0)           /* uart3_rx.uart3_rx */
>                         0x170 (PIN_OUTPUT | MUX_MODE0)          /* uart3_tx.uart3_tx */
>                 >;
>         };
>
>         mmc1_pins: pinmux_mmc1_pins {
>                 pinctrl-single,pins = <
>                         0x114 (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc1_clk.sdmmc1_clk */
>                         0x116 (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc1_cmd.sdmmc1_cmd */
>                         0x118 (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc1_dat0.sdmmc1_dat0 */
>                         0x11a (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc1_dat1.sdmmc1_dat1 */
>                         0x11c (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc1_dat2.sdmmc1_dat2 */
>                         0x11e (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc1_dat3.sdmmc1_dat3 */
>                 >;
>         };
>         mmc2_pins: pinmux_mmc2_pins {
>                 pinctrl-single,pins = <
>                         0x128 (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc2_clk.sdmmc2_clk */
>                         0x12a (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc2_cmd.sdmmc2_cmd */
>                         0x12c (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc2_dat0.sdmmc2_dat0 */
>                         0x12e (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc2_dat1.sdmmc2_dat1 */
>                         0x130 (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc2_dat2.sdmmc2_dat2 */
>                         0x132 (PIN_INPUT_PULLUP | MUX_MODE0)    /* sdmmc2_dat3.sdmmc1_dat3 */
>                 >;
>         };
>         mmc2_cirq_pin: pinmux_cirq_pin {
>                 pinctrl-single,pins = <
>                         0x012e (PIN_INPUT_PULLUP | MUX_MODE4)   /* MMC2_DAT1 as GPIO5_5 */
>                 >;
>         };
> };
>
> &i2c1 {
>         clock-frequency = <2600000>;
>
>         twl: twl@48 {
>                 reg = <0x48>;
>                 interrupts = <7>; /* SYS_NIRQ cascaded to intc */
>                 interrupt-parent = <&intc>;
>
>                 twl_audio: audio {
>                         compatible = "ti,twl4030-audio";
>                         codec {
>                         };
>                 };
>                 vaux4: regulator-vaux4 {
>                         compatible = "ti,twl4030-vaux4";
>                         regulator-min-microvolt = <2800000>;
>                         regulator-max-microvolt = <3150000>;
>                         ti,allow_unsupported;
>                 };
>         };
> };
>
> #include "twl4030.dtsi"
> #include "twl4030_omap3.dtsi"
>
> &i2c2 {
>         clock-frequency = <400000>;
>
>         /* touch screen */
>         tsc2007: tsc2007@48 {
>                 compatible = "tsc2007";
>                 reg = <0x48>;
>                 interrupt-parent = <&gpio6>;
>                 interrupts = <0 IRQ_TYPE_EDGE_FALLING>;
>                 model-number = <2007>;
>                 x-plate-ohms = <600>;
>                 pen-gpio = <&gpio6 0 GPIO_ACTIVE_LOW>;
>         };
>
>         /* pressure sensor */
>         bmp085@77 {
>                 compatible = "bosch,bmp085";
>                 reg = <0x77>;
>         };
>
>         /* accelerometer */
>         bma180@41 {
>                 compatible = "bosch,bma180";
>                 reg = <0x41>;
>                 interrupt-parent = <&gpio3>;
>                 interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
>         };
>
>         /* leds */
>         tca: tca6507@45 {
>                 compatible = "ti,tca6507";
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>                 reg = <0x45>;
>
>                 gpio-controller;
>                 #gpio-cells = <2>;
>
>                 gta04_led0: red_aux@0 {
>                         label = "gta04:red:aux";
>                         reg = <0x0>;
>                 };
>
>                 gta04_led1: green_aux@1 {
>                         label = "gta04:green:aux";
>                         reg = <0x1>;
>                 };
>
>                 gta04_led3: red_power@3 {
>                         label = "gta04:red:power";
>                         reg = <0x3>;
>                         linux,default-trigger = "default-on";
>                 };
>
>                 gta04_led4: green_power@4 {
>                         label = "gta04:green:power";
>                         reg = <0x4>;
>                 };
>
>                 wifi_reset@6 {
>                         label = "gta04:wlan:reset";
>                         reg = <0x6>;
>                         make-gpio;
>                 };
>         };
>
>         /* gyroscope */
>         itg3200@68 {
>                 compatible = "invensense,itg3200";
>                 reg = <0x68>;
>         };
>
>         /* compass aka magnetometer */
>         hmc5843@1e {
>                 compatible = "honeywell,hmc5843";
>                 reg = <0x1e>;
>         };
> };
>
> &i2c3 {
>         clock-frequency = <100000>;
> };
>
> &usb_otg_hs {
>         interface-type = <0>;
>         usb-phy = <&usb2_phy>;
>         mode = <3>;
>         power = <50>;
> };
>
> &mmc1 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&mmc1_pins>;
>         vmmc-supply = <&vmmc1>;
>         bus-width = <4>;
>         ti,non-removable;
>         cap-power-off-card;
> };
>
> &mmc2 {
>         vmmc-supply = <&vaux4>;
>         bus-width = <4>;
>         ti,non-removable;
>         cap-power-off-card;
>         reset-gpios = <&tca 0 GPIO_ACTIVE_HIGH>;
>
>         ti,quirk-swakeup-missing;
>         pinctrl-names = "default", "active", "idle";
>         pinctrl-0 = <&mmc2_pins>;
>         pinctrl-1 = <&mmc2_pins>;
>         pinctrl-2 = <&mmc2_cirq_pin>;
>         ti,cirq-gpio = <&gpio5 5 0>; /* GPIO133 = 128+5 */
> };
>
> &mmc3 {
>         status = "disabled";
> };
>
> &uart1 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&uart1_pins>;
> };
>
> &uart2 {
>        pinctrl-names = "default";
>        pinctrl-0 = <&uart2_pins>;
> };
>
> &uart3 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&uart3_pins>;
> };
>
> &charger {
>         bb_uvolt = <3200000>;
>         bb_uamp = <150>;
> };
>
> &twl_power {
>         ti,use_poweroff;
> };
>
> &vpll2 {
>         supply-dev = "omapdss_dpi.0";
>         supply = "vdds_dsi";
> };
>
> /* uart1 is bluetooth - need to connect DTR */
> &uart1 {
>         dtr = <&btdtr 0 GPIO_ACTIVE_HIGH>;
> };
> &uart2 {
>         dtr = <&gpsdtr 0 GPIO_ACTIVE_HIGH>;
> };
>
> &vsim {
>         regulator-min-microvolt = <2800000>;
>         regulator-max-microvolt = <2800000>;
> };
