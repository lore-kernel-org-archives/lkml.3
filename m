Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbaGVPFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:05:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45028 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbaGVPFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:05:36 -0400
Date: Tue, 22 Jul 2014 10:04:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kernel@stlinux.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <peter.griffin+familyguy@linaro.org>
Subject: Re: [RFC PATCH] usb: dwc3: core: allow vendor drivers to check probe
 status
Message-ID: <20140722150445.GD20588@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405617213-27360-1-git-send-email-lee.jones@linaro.org>
 <20140717172045.GM10459@saruman.home>
 <20140718071115.GH30888@lee--X1>
 <20140718144044.GJ24914@saruman.home>
 <20140722135534.GB6817@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
In-Reply-To: <20140722135534.GB6817@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2014 at 02:55:34PM +0100, Peter Griffin wrote:
> Hi Felipe,
>=20
> Sorry for the delay in replying. I've been trying to get to the root cause
> of this problem so I could reply which took longer than I had hoped.
>=20
> The problem manifested itself as a hang on register read/write access if =
dwc3-st=20
> probed before the usb3 phy. Even though dwc3 core would bail and return=
=20
> -EPROBE_DEFER that is not propogated up through of_platform_populate.
>=20
> <snip>
> >=20
> > yeah, because glue layers are not supposed to know. There should be no
> > coupling what so ever between glue layer and core driver, other than the
> > fact that glue layer is the one which triggers platform_device creation
> > through of_platform_population(). But the glue layer has (or should
> > have) no interest in exactly when the core driver finishes probing.
>=20
> Thanks for this clue :-) As it got me debugging why there was this depend=
ency
> between the usb3 phy IP and the ST glue register wrapper around the dwc3 =
usb core.
>=20
> The reason for the depedency / hang is that there is a shared reset signal
> for the dwc3 core, glue registers and usb3 phy. This reset signal was only
> being managed in the USB3 phy driver, which is why if dwc3-st or dwc3 did
> any register access it would cause a hang.
>=20
> So the solution is in addition to taking the devm_reset_control for the p=
owerdown
> signal, in V3 of the dwc3-st glue layer, it also gets the softreset signa=
l,
> and deasserts this before any register accesses.
>=20
> This is now working properly without any init ordering hacks etc.

AWESOME! :-) Thanks for finding that out, it really helps us keep dwc3
clean without platform-specific hacks ;-)

> > > commit message, another way of ensuring the PHYs are available is to
> > > request them, but this would mean an awful lot of code duplication.
> > >=20
> > > In your opinion, what's the best way to handle this?
> >=20
> > How can I know ? You still haven't fully explained what you need. All
> > you said was that you're trying to "configure through the glue-layer".
>=20
> We can forget about this now. Having dwc3-st take a reference on the usb3=
 phys was
> just another method I was experimenting with to find out whether the usb3=
=20
> PHY had probed or not.
>=20
> >=20
> > Care to further explain what the problem really is ? I'm assuming below
> > is what you're concerned about which I had to go dig in the archives
> > because there was no reference to that patch anywhere here.
>=20
> Hopefully I have now above, and the proposed solution.
>=20
> >=20
> > > +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> > > +{
> > > +	u32 reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> > > +
> > > +	reg |=3D aux_clk_en(1) | ext_cfg_reset_n(1) | xhci_revision(1);
> >=20
> > so you have auxiliary clock, an external config reset, what's this
> > xhci_revision ?
>=20
> xhci_revision is an input signal to the dwc3 core, if it is asserted
> then the host controller compiles with the xHCI revision 1.0 spec, if
> not it complies with xHCI revision 0.96 spec. This input signal to
> dwc3 core is exposed in the CLKRST_CTRL glue register wrapped around
> the controller by ST.

I wonder why would HW folks give SW access to that, though. Oh well,
I've seen weirder things ;-)

> Looking through the docs, it was present until 2.40a, then removed as
> an input signal to the core from 2.50a onwards.
>=20
> To make this clearer I have also added a comment above the
> xhci_revision macro in V3 of the dwc3-st patches explaining the
> bitfield and what it does.

thanks

> > looks like it should be split between a CCF and reset drivers. Or maybe
> > a single driver which does both. Do you have a clock/reset control for
> > all IPs ?
>=20
> Yes most IPs which have reset or powerdown signals are already
> controlled by a driver in drivers/reset/sti. These reset and powerdown
> signals are all exposed in the sysconfig registers of the SoC. Indeed
> it was a shared reset signal which wasn't being properly managed and
> causing the hang.
>=20
> However the reset signal and clock gate here is controlling a small
> piece of wrapper IP called pipew which sits between the dwc3 core and
> usb3 phy.  I believe this pipew protocol wrapper hardware is designed
> internally by ST, and has some special contriants which is why these
> reset signals are being exposed here in the glue logic (see below).
>=20
> >  That might be a good way to hide stuff, driver would simply
> > call clk_get()/clk_prepare_enable() and reset_assert()/deassert() when
> > necessary (sure, this doesn't solve the 'when has that guy probe' but
> > you still haven't explained why you need it).
> >=20
> > > +	reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1);
> > > +	reg |=3D SEL_OVERRIDE_VBUSVALID(1) | SEL_OVERRIDE_POWERPRESENT(1) |
> > > +	    SEL_OVERRIDE_BVALID(1);
> >=20
> > this is not correct. You don't know if VBUS is really valid at this
> > time. We have used a gpio which gets pull high/low depending on the
> > state of VBUS/ID.
>=20
> This isn't stating that VBUS is valid, it is configuring a mux to
> select where the vbus / bvalid / powerpresent signals will be selected
> from.

/me now notices the "SEL_" prefix :-)

> I have added a better comment in V3 which hopefully makes the function
> of VBUS_MNGMNT_SEL register clearer.

thanks

> > > +	st_dwc3_writel(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1, reg);
> > > +	udelay(100);
> > > +
> > > +	reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> > > +	reg |=3D sw_pipew_reset_n(1);
> > > +	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);
> >=20
> > let me ask you something else. Isn't the DWC3_GUSB3PIPECTL_PHYSOFTRST
> > bit functional for you guys ? This sw_pipe2_reset_n looks suspicious.
>=20
> Your right to be suspicious ;-)
>=20
> Due to a constriant on the pipew hardware, they have provided two
> extra software controlled  resets ext_cfg_reset and sw_pipew_reset in
> the CLKRST_CTRL glue reg.
>=20
> These two software controlled resets are ANDED with the nominal
> cfg_reset_n and pipe_reset_n resets to the pipew hardware.
>=20
> So yes DWC3_GUSB3PIPECTL_PHYSOFTRST is functional, but it will only
> actually issue a reset to pipew and then onto MiPHY if
> sw_pipew_reset_n is also set in the glue. The same goes with the
> global bus_reset_n signal which is subsystem wide reset, it will only
> bepropogated to pipew if ext_cfg_reset is also set in CLKRST_CTRL.

oh man, what a mess :-)

> Hopefully that makes things clearer and I've answered everything.  I
> intend to send a V3 shortly.

sure, thanks

--=20
balbi

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTzn2NAAoJEIaOsuA1yqREDIwQALSM3JqxlGv8Nh/RVAbNt8S8
F0WVwd/mNUCEbw6ELD4QkN3KzJWqmWxYo8dvKk379aghLbOTjiND6Njmo7+0D+Oa
qYeT0fJhUI+ml0CyjP3PWiS910hqZPL3DBU+7eaF4BOfRDAP9v+UYLkjpteQzVH4
LxDn1OR5BgJ4miUD9uiGJvTf2QKmwcM7aAhbTgNR5LfzX9AMltel3A4GYOqxAJD6
nO4Azu1Hg/1+412yPBomYon80aZ55leuL2Kb0DPNrzgBIPIjyyv+YpE+wghR46aR
7PT+f8kWe/lWU9sx4Xq6hsxgCpJ6TmY4FUOd8MNc8mkw5FGtlZkrPHXn01eRYYkO
xnNeeVo1dcbd9XkNhnzogeWiMc7M3CrDAihfFvIMWasH0ZvuKU/2RdIqR5f40zgY
qJHy0UKn/MB6ote8JHQM3uvwSFwkk+5U1POAG84D5chq2A3vLVPXWiK7FqVlAiNC
xEsIvNd6dYzzJ4lSNdVdFwkbG0Nx+lIVNNgZADPRWCX0CwUMCm4uzjZ3gBBeakMo
eTtYOrxI8/r/W9B2vPlD1+wBf/tur+tzS5CVNi7IPGUj3KsaeVvEt4+umD+qka6C
/rNtP03by1/nStfKnyHZsuJqqi4nasPs7WhIcA7kpNgdIUIYUAmOaXAmyZEfc5YI
ysZeTlWcMXCZm3z+QLex
=Sqt1
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
