Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab3JRXOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:14:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab3JRXOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:14:39 -0400
Date: Sat, 19 Oct 2013 10:14:17 +1100
From: NeilBrown <neilb@suse.de>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Andreas Fenkart <afenkart@gmail.com>, Chris Ball <cjb@laptop.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Venkatraman S <svenkatr@ti.com>, Balaji T K <balajitk@ti.com>,
        zonque@gmail.com,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mmc@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] mmc: omap_hsmmc: Remux pins to support SDIO
 interrupt on AM335x
Message-ID: <20131019101417.3f353c82@notabene.brown>
In-Reply-To: <CAAwP0s1vNcRrekDbJOdm5vzk3VEWRm-5g8c9s+6KPczFj7LBsA@mail.gmail.com>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
	<1380971830-21492-4-git-send-email-afenkart@gmail.com>
	<20131018172053.70cf2c2b@notabene.brown>
	<CAAwP0s1vNcRrekDbJOdm5vzk3VEWRm-5g8c9s+6KPczFj7LBsA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sF/4rebobev7XK.RZ1P0SjQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sF/4rebobev7XK.RZ1P0SjQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Oct 2013 12:12:48 +0200 Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:

> On Fri, Oct 18, 2013 at 8:20 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sat,  5 Oct 2013 13:17:09 +0200 Andreas Fenkart <afenkart@gmail.com>=
 wrote:
> >
> >> The am335x can't detect pending cirq in PM runtime suspend.
> >> This patch reconfigures dat1 as a GPIO before going to suspend.
> >> SDIO interrupts are detected with the GPIO, while in runtime
> >> suspend, standard detection of the module block otherwise.
> >>
> >> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> >>
> >> diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b=
/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> >> index 1136e6b..146f3ad 100644
> >> --- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> >> +++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> >> @@ -21,8 +21,11 @@ ti,non-removable: non-removable slot (like eMMC)
> >>  ti,needs-special-reset: Requires a special softreset sequence
> >>  ti,needs-special-hs-handling: HSMMC IP needs special setting for hand=
ling High Speed
> >>  ti,quirk-swakup-missing: SOC missing the swakeup line, will not detect
> >> -SDIO irq while in suspend. Fallback to polling. Affected chips are
> >> -am335x,
> >> +SDIO irq while in suspend. The workaround is to reconfigure the dat1 =
line as a
> >> +GPIO upon suspend. Beyond this option and the GPIO config, you also n=
eed to set
> >> +named pinctrl states "default", "active" and "idle ", see example bel=
ow.  The
> >> +MMC driver will then then toggle between default and idle during the =
runtime
> >> +Affected chips are am335x,
> >>
> >>                              ------
> >>                              | PRCM |
> >> @@ -49,3 +52,24 @@ Example:
> >>               vmmc-supply =3D <&vmmc>; /* phandle to regulator node */
> >>               ti,non-removable;
> >>       };
> >> +
> >> +[am335x with with gpio for sdio irq]
> >> +
> >> +     mmc1_cirq_pin: pinmux_cirq_pin {
> >> +             pinctrl-single,pins =3D <
> >> +                     0x0f8 0x3f      /* MMC0_DAT1 as GPIO2_28 */
> >> +             >;
> >> +     };
> >> +
> >> +     mmc1: mmc@48060000 {
> >> +             ti,non-removable;
> >> +             bus-width =3D <4>;
> >> +             vmmc-supply =3D <&ldo2_reg>;
> >> +             vmmc_aux-supply =3D <&vmmc>;
> >> +             ti,quirk-swakeup-missing;
> >> +             pinctrl-names =3D "default", "active", "idle";
> >> +             pinctrl-0 =3D <&mmc1_pins>;
> >> +             pinctrl-1 =3D <&mmc1_pins>;
> >> +             pinctrl-2 =3D <&mmc1_cirq_pin>;
> >> +             ti,cirq-gpio =3D <&gpio3 28 0>;
> >> +     };
> >
> >
> > hi,
> >  I've been trying to get SD irq to work on my  OMAP3 DM3730.
> > I seems to need the magic to catch interrupts while FCLK is off, as
> > the only way I can get it to work at the moment is to keep FCLK on.
> >
> > I discovered your patch and tried it out, but it doesn't seem to work f=
or me.
> >
> > I have a Libertas WIFI chip attached to the second mmc (which is someti=
mes
> > called mmc1, and sometimes mmc2 - very confusing!).
>=20
> Hi Neil,
>=20
> I have a DM3730 board with the same setup, Libertas (Marvell SD8686)
> wifi + bt chip attached to mmc2.
>=20
> I was going to try to add support for this to the DTS but it would be
> great if I can use your as a reference.
>=20
> Would you be so kind to share your DTS?
>=20

My DTS is below.  It contains an number of things that are not supported in
mainline yet.  Details can be found in
   git://neil.brown.name/gta04 mainline
and
   http://git.neil.brown.name/?p=3Dgta04.git;a=3Dshortlog;h=3Drefs/heads/ma=
inline
(this is my working tree and gets rebased and messed up regularly).

NeilBrown

/*
 * Copyright (C) 2013 Marek Belisko <marek@goldelico.com>
 *
 * Based on omap3-beagle-xm.dts
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
/dts-v1/;
#define RFKILL_TYPE_GPS 6
#include "omap36xx.dtsi"

/ {
	model =3D "OMAP3 GTA04";
	compatible =3D "ti,omap3-gta04", "ti,omap3";
	chosen {
		bootargs =3D "console=3DttyO2,115200n8 vram=3D12M omapfb.rotate_type=3D0 =
omapdss.def_disp=3Dlcd root=3D/dev/mmcblk0p2 rw rootfstype=3Dext3 rootwait =
twl4030_charger.allow_usb=3D1 musb_hdrc.preserve_vbus=3D1 log_buf_len=3D8M =
ignore_loglevel no_console_suspend";
	};

	cpus {
		cpu@0 {
			cpu0-supply =3D <&vcc>;
		};
	};

	memory {
		device_type =3D "memory";
		reg =3D <0x80000000 0x20000000>; /* 512 MB */
	};

	aux-keys {
		compatible =3D "gpio-keys";

		aux-button {
			label =3D "aux";
			linux,code =3D <169>;
			gpios =3D <&gpio1 7 GPIO_ACTIVE_HIGH>;
			gpio-key,wakeup;
		};
	};

	incoming-keys {
		compatible =3D "gpio-keys";

		incoming-button {
			label =3D "Option";
			linux,code =3D <240>;
			/* 176 for A3, 10 for A4 */
			gpios =3D <&gpio6 16 GPIO_ACTIVE_HIGH>;
			gpio-key,wakeup;
		};
	};

	sound {
		compatible =3D "ti,omap-twl4030";
		ti,model =3D "gta04";

		ti,mcbsp =3D <&mcbsp2>;
		ti,codec =3D <&twl_audio>;
	};

	panel {
		compatible =3D "tpo,td028ttec1";
		display-name =3D "lcd";
		source     =3D "dpi.0";
		data-lines =3D <24>;
		cs-gpio    =3D <&gpio1 19 0>;
		scl-gpio   =3D <&gpio1 12 0>;
		din-gpio   =3D <&gpio1 18 0>;
		dout-gpio  =3D <&gpio1 20 0>;
	};

	backlight {
		compatible =3D "pwm-backlight";
		label =3D "pwm-backlight";
		pwms =3D <&pwm 0 2000000>;
		brightness-levels =3D <0 11 20 30 40 50 60 70 80 90 100>;
		default-brightness-level =3D <10>;
	};

	pwm: omap-pwm {
		compatible =3D "ti,omap-pwm";
		timers =3D <&timer11>;
		#pwm-cells =3D <2>;
	};

	/* need to connect uart1 DTR line to vaux4 */
	btdtr: gpio-reg.bt {
		compatible =3D "gpio_regulator";
		vgpio-supply =3D <&vaux4>;
		microvolt =3D <3150000>;
		gpio-controller;
		#gpio-cells =3D <2>;
	};

	gps-rfkill {
		compatible =3D "rfkill-regulator";
		label =3D "GPS";
		type =3D <RFKILL_TYPE_GPS>;
		vrfkill-supply =3D <&vsim>;
	};

	gpsdtr: gps-onoff {
		compatible =3D "gpio-w2sg0004";
		gpios =3D <&gpio5 17 0>, <&gpio5 19 0>;
		/* MODE0 PULL_ENA(8) INPUT_EN(256) PULL_UP(16) */
		state-on =3D <280>;
		/* MODE4 PULL_ENA(8) INPUT_EN(256) PULL_UP(16) */
		state-off =3D <284>;
		gpio-controller;
		#gpio-cells =3D <2>;
	};
};

&omap3_pmx_core {
	uart1_pins: pinmux_uart1_pins {
		pinctrl-single,pins =3D <
			0x152 (PIN_INPUT | MUX_MODE0)		/* uart1_rx.uart1_rx */
			0x14c (PIN_OUTPUT |MUX_MODE0)		/* uart1_tx.uart1_tx */
		>;
	};

	uart2_pins: pinmux_uart2_pins {
		pinctrl-single,pins =3D <
			0x14a (PIN_INPUT | MUX_MODE0)		/* uart2_rx.uart2_rx */
			0x148 (PIN_OUTPUT | MUX_MODE0)		/* uart2_tx.uart2_tx */
		>;
	};

	uart3_pins: pinmux_uart3_pins {
		pinctrl-single,pins =3D <
			0x16e (PIN_INPUT | MUX_MODE0)		/* uart3_rx.uart3_rx */
			0x170 (PIN_OUTPUT | MUX_MODE0)		/* uart3_tx.uart3_tx */
		>;
	};

	mmc1_pins: pinmux_mmc1_pins {
		pinctrl-single,pins =3D <
			0x114 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_clk.sdmmc1_clk */
			0x116 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_cmd.sdmmc1_cmd */
			0x118 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat0.sdmmc1_dat0 */
			0x11a (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat1.sdmmc1_dat1 */
			0x11c (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat2.sdmmc1_dat2 */
			0x11e (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat3.sdmmc1_dat3 */
		>;
	};
	mmc2_pins: pinmux_mmc2_pins {
		pinctrl-single,pins =3D <
			0x128 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc2_clk.sdmmc2_clk */
			0x12a (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc2_cmd.sdmmc2_cmd */
			0x12c (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc2_dat0.sdmmc2_dat0 */
			0x12e (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc2_dat1.sdmmc2_dat1 */
			0x130 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc2_dat2.sdmmc2_dat2 */
			0x132 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc2_dat3.sdmmc1_dat3 */
		>;
	};
	mmc2_cirq_pin: pinmux_cirq_pin {
		pinctrl-single,pins =3D <
			0x012e (PIN_INPUT_PULLUP | MUX_MODE4)	/* MMC2_DAT1 as GPIO5_5 */
		>;
	};
};

&i2c1 {
	clock-frequency =3D <2600000>;

	twl: twl@48 {
		reg =3D <0x48>;
		interrupts =3D <7>; /* SYS_NIRQ cascaded to intc */
		interrupt-parent =3D <&intc>;

		twl_audio: audio {
			compatible =3D "ti,twl4030-audio";
			codec {
			};
		};
		vaux4: regulator-vaux4 {
			compatible =3D "ti,twl4030-vaux4";
			regulator-min-microvolt =3D <2800000>;
			regulator-max-microvolt =3D <3150000>;
			ti,allow_unsupported;
		};
	};
};

#include "twl4030.dtsi"
#include "twl4030_omap3.dtsi"

&i2c2 {
	clock-frequency =3D <400000>;

	/* touch screen */
	tsc2007: tsc2007@48 {
		compatible =3D "tsc2007";
		reg =3D <0x48>;
		interrupt-parent =3D <&gpio6>;
		interrupts =3D <0 IRQ_TYPE_EDGE_FALLING>;
		model-number =3D <2007>;
		x-plate-ohms =3D <600>;
		pen-gpio =3D <&gpio6 0 GPIO_ACTIVE_LOW>;
	};

	/* pressure sensor */
	bmp085@77 {
		compatible =3D "bosch,bmp085";
		reg =3D <0x77>;
	};

	/* accelerometer */
	bma180@41 {
		compatible =3D "bosch,bma180";
		reg =3D <0x41>;
		interrupt-parent =3D <&gpio3>;
		interrupts =3D <19 IRQ_TYPE_LEVEL_HIGH>;
	};

	/* leds */
	tca: tca6507@45 {
		compatible =3D "ti,tca6507";
		#address-cells =3D <1>;
		#size-cells =3D <0>;
		reg =3D <0x45>;

		gpio-controller;
		#gpio-cells =3D <2>;

		gta04_led0: red_aux@0 {
			label =3D "gta04:red:aux";
			reg =3D <0x0>;
		};

		gta04_led1: green_aux@1 {
			label =3D "gta04:green:aux";
			reg =3D <0x1>;
		};

		gta04_led3: red_power@3 {
			label =3D "gta04:red:power";
			reg =3D <0x3>;
			linux,default-trigger =3D "default-on";
		};

		gta04_led4: green_power@4 {
			label =3D "gta04:green:power";
			reg =3D <0x4>;
		};

		wifi_reset@6 {
			label =3D "gta04:wlan:reset";
			reg =3D <0x6>;
			make-gpio;
		};
	};

	/* gyroscope */
	itg3200@68 {
		compatible =3D "invensense,itg3200";
		reg =3D <0x68>;
	};

	/* compass aka magnetometer */
	hmc5843@1e {
		compatible =3D "honeywell,hmc5843";
		reg =3D <0x1e>;
	};
};

&i2c3 {
	clock-frequency =3D <100000>;
};

&usb_otg_hs {
	interface-type =3D <0>;
	usb-phy =3D <&usb2_phy>;
	mode =3D <3>;
	power =3D <50>;
};

&mmc1 {
	pinctrl-names =3D "default";
	pinctrl-0 =3D <&mmc1_pins>;
	vmmc-supply =3D <&vmmc1>;
	bus-width =3D <4>;
	ti,non-removable;
	cap-power-off-card;
};

&mmc2 {
	vmmc-supply =3D <&vaux4>;
	bus-width =3D <4>;
	ti,non-removable;
	cap-power-off-card;
	reset-gpios =3D <&tca 0 GPIO_ACTIVE_HIGH>;

	ti,quirk-swakeup-missing;
	pinctrl-names =3D "default", "active", "idle";
	pinctrl-0 =3D <&mmc2_pins>;
	pinctrl-1 =3D <&mmc2_pins>;
	pinctrl-2 =3D <&mmc2_cirq_pin>;
	ti,cirq-gpio =3D <&gpio5 5 0>; /* GPIO133 =3D 128+5 */
};

&mmc3 {
	status =3D "disabled";
};

&uart1 {
	pinctrl-names =3D "default";
	pinctrl-0 =3D <&uart1_pins>;
};

&uart2 {
       pinctrl-names =3D "default";
       pinctrl-0 =3D <&uart2_pins>;
};

&uart3 {
	pinctrl-names =3D "default";
	pinctrl-0 =3D <&uart3_pins>;
};

&charger {
	bb_uvolt =3D <3200000>;
	bb_uamp =3D <150>;
};

&twl_power {
	ti,use_poweroff;
};

&vpll2 {
	supply-dev =3D "omapdss_dpi.0";
	supply =3D "vdds_dsi";
};

/* uart1 is bluetooth - need to connect DTR */
&uart1 {
	dtr =3D <&btdtr 0 GPIO_ACTIVE_HIGH>;
};
&uart2 {
	dtr =3D <&gpsdtr 0 GPIO_ACTIVE_HIGH>;
};

&vsim {
	regulator-min-microvolt =3D <2800000>;
	regulator-max-microvolt =3D <2800000>;
};

--Sig_/sF/4rebobev7XK.RZ1P0SjQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmHAyTnsnt1WYoG5AQI6vhAApX+GZIxzWi7ul7/gb+1ysK0iJVY5V6aO
PvQdh70SkiFwDtDT+DKlYKgAhbbR6uq7q9ciH0jR3qau/Xjf6vli1xni9xdnuvq9
Hex0GenHmUHLd8JgryFclyrOcpQGHgi8DqD76oUGOwkju4E5xwXR4O5VRKaHKpML
XoojzAW95Gm8KRk6EqSTt/JKOy/J/dq17MeX1dryN3tPk4+ggE4PBfVhGAFFOiJy
wCAs7UrG+2kbliyzogWoT1JJ6ROTx983Sg+vlMl42foPNSWQvR8GM6PRKmOt1LEF
7Q5Lz53TdtuxBscsXpnL5RscBSCpXvw/LcvupMAeQjS6Cpho79dfuMmC99ESzJAI
mYmP7Amw1KH67uN1NGrhyX8kVd6U6diqt2pL66uQOMp6W4RdilyRNLGhgF4OvP9P
xzwz2N+tEQM/JJ9NA2venjbJDgE1/bCPtfGDsLr8aFmGI7bUIJ+kZDfzAalWgvwZ
+GdITAdpUy7NQTc8pJdNpCWM5Y3sEwZTCIRS886pzavp1h73vJDKEgyt+0iuYg1F
tNZ9f4bYv5CacjsgRzc6ZtTikDEJ0POoqvXBXRAfmVBbizKOZztMYMhCC4zdsAxK
MnRYLvSLB0kVTAQDr45qdX7h5telFvTuZ0YUBGptJOV4mUZnERAygxPzq0u6Lxs1
Jg0xw8T3jhg=
=Wkow
-----END PGP SIGNATURE-----

--Sig_/sF/4rebobev7XK.RZ1P0SjQ--
