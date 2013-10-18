Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3JRHq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:46:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab3JRHqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:46:24 -0400
Date: Fri, 18 Oct 2013 18:45:52 +1100
From: NeilBrown <neilb@suse.de>
To: Balaji T K <balajitk@ti.com>
Cc: Andreas Fenkart <afenkart@gmail.com>, Chris Ball <cjb@laptop.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        <zonque@gmail.com>, <devicetree-discuss@lists.ozlabs.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] mmc: omap_hsmmc: Remux pins to support SDIO
 interrupt on AM335x
Message-ID: <20131018184552.1c65117d@notabene.brown>
In-Reply-To: <5260E374.6050804@ti.com>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
	<1380971830-21492-4-git-send-email-afenkart@gmail.com>
	<20131018172053.70cf2c2b@notabene.brown>
	<5260E374.6050804@ti.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HqFK.ZmhUn3b7+9jrSjaGRm"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HqFK.ZmhUn3b7+9jrSjaGRm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Oct 2013 12:59:56 +0530 Balaji T K <balajitk@ti.com> wrote:

> On Friday 18 October 2013 11:50 AM, NeilBrown wrote:
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
> >>   ti,needs-special-reset: Requires a special softreset sequence
> >>   ti,needs-special-hs-handling: HSMMC IP needs special setting for han=
dling High Speed
> >>   ti,quirk-swakup-missing: SOC missing the swakeup line, will not dete=
ct
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
> >>                               ------
> >>                               | PRCM |
> >> @@ -49,3 +52,24 @@ Example:
> >>   		vmmc-supply =3D <&vmmc>; /* phandle to regulator node */
> >>   		ti,non-removable;
> >>   	};
> >> +
> >> +[am335x with with gpio for sdio irq]
> >> +
> >> +	mmc1_cirq_pin: pinmux_cirq_pin {
> >> +		pinctrl-single,pins =3D <
> >> +			0x0f8 0x3f	/* MMC0_DAT1 as GPIO2_28 */
> >> +		>;
> >> +	};
> >> +
> >> +	mmc1: mmc@48060000 {
> >> +		ti,non-removable;
> >> +		bus-width =3D <4>;
> >> +		vmmc-supply =3D <&ldo2_reg>;
> >> +		vmmc_aux-supply =3D <&vmmc>;
> >> +	        ti,quirk-swakeup-missing;
> >> +		pinctrl-names =3D "default", "active", "idle";
> >> +		pinctrl-0 =3D <&mmc1_pins>;
> >> +		pinctrl-1 =3D <&mmc1_pins>;
> >> +		pinctrl-2 =3D <&mmc1_cirq_pin>;
> >> +		ti,cirq-gpio =3D <&gpio3 28 0>;
> >> +	};
> >
> >
> > hi,
> >   I've been trying to get SD irq to work on my  OMAP3 DM3730.
> > I seems to need the magic to catch interrupts while FCLK is off, as
> > the only way I can get it to work at the moment is to keep FCLK on.
> >
> > I discovered your patch and tried it out, but it doesn't seem to work f=
or me.
> >
> > I have a Libertas WIFI chip attached to the second mmc (which is someti=
mes
> > called mmc1, and sometimes mmc2 - very confusing!).
> > I added:
> > 	mmc2_cirq_pin: pinmux_cirq_pin {
> > 		pinctrl-single,pins =3D <
> > 			0x012e (PIN_INPUT_PULLUP | MUX_MODE4)	/* MMC2_DAT1 as GPIO5_5 */
> > 		>;
> > 	};
> >
> > and
> >
> > &mmc2 {
> > 	ti,quirk-swakeup-missing;
> > 	pinctrl-names =3D "default", "active", "idle";
> > 	pinctrl-0 =3D <&mmc2_pins>;
> > 	pinctrl-1 =3D <&mmc2_pins>;
> > 	pinctrl-2 =3D <&mmc2_cirq_pin>;
> > 	ti,cirq-gpio =3D <&gpio5 5 0>; /* GPIO133 =3D 128+5 */
> > };
> >
> > to my dts file but it doesn't make any apparent difference.
> >
> > Any idea what I might be doing wrong?
> > (the base kernel I am applying patches to is from 8th Oct,
> >   commit 0e7a3ed04f0cd4311096d691888f88569310ee6c)
> >
> > BTW,
> >   - with the default polling, I get about 1Mb/sec with iperf
> >   - with sd-irq enabled and FCLK kept on the whole time, I get 4Mb/sec
> >   - with sd-irq enable, FCLK kept on, and the 5ms polling also
> >     running, I get over 5Mb/sec!
> > Still much less than the 40Mb/sec that I would like to get...
> >
> (removing svenkatr@ti.com)
>=20
> Hi,
>=20
> Can you check if you have bus-width property set ?
> 	bus-width =3D <4>;
>=20
>
Yes I do.
as well as the settings above I have:

	vmmc-supply =3D <&vaux4>;
	bus-width =3D <4>;
	ti,non-removable;
	cap-power-off-card;


vaux4 is from a twl4030 and powers the wifi chip.
'cap-power-off-card' I added support for myself to so the card would power
off when not in use.

Thanks,
NeilBrown

--Sig_/HqFK.ZmhUn3b7+9jrSjaGRm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmDnPTnsnt1WYoG5AQIxRg//Ydrldz3H2v7xltx8IUe0h2b66/HbTZJr
gTgJE5KxLeiLajAQPr5Rvm+ohAzWrdkyYnLjA+vAmOI2JA0cCwn9jJ9PDyov5CcH
he2lscxDzxrXz7Ae7JxRPWYDQwlvMkQbNDE+BTuUZCCg4PGxPP4lvyGJRGIc32Fh
+o8mr+99UHCREjA79gi7tol913mzoCHU5hSfkV/jCz4lURcn2rMrrmMsc+0Ie54e
WVRRM2ZBDYyWvzLobcd558oy3dSJmuSO1SLah0TtdSyfodDfFapnyn1rVGPL9Uc0
0PYnD2vBC7Vd1xZ/EPbcSf25CY3kUC52u0ukvJ8rp494ZbSvdLsK/PKWQX9t2yTe
Jpw6WYHHSOweDjHXO4C30E+qoa904zuQqCmVhda3utawIySeOxWLG9kbW1OFJI+w
0ixBQGYLFE5CoR3nw45/EWvCUGf/w0PDcNKM9mTfbeBhjNXbzdB6MO1acjRn2ba+
3pM949IMpc8CHBpIgzleYw7Hw7CuEe4zCBylQKZrkII4wDYQ4lQpcH49rINbw3l3
2R7RUgRB8PzSTC7hb7DMpH4O4XnywKIaGlUT00GL1eaeFC30WdjIk2IkvYTVZOjR
lYBTRCecccTP+AdSOcoWsZBQqGbx7N4gOP0t9niPMYPj5lKSCFT9T/q1EvHRGxrd
fEXC8MZrZxk=
=G1I7
-----END PGP SIGNATURE-----

--Sig_/HqFK.ZmhUn3b7+9jrSjaGRm--
