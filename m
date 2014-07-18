Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935023AbaGROlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:41:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55549 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaGROlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:41:24 -0400
Date: Fri, 18 Jul 2014 09:40:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel@stlinux.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <peter.griffin+familyguy@linaro.org>
Subject: Re: [RFC PATCH] usb: dwc3: core: allow vendor drivers to check probe
 status
Message-ID: <20140718144044.GJ24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405617213-27360-1-git-send-email-lee.jones@linaro.org>
 <20140717172045.GM10459@saruman.home>
 <20140718071115.GH30888@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oplxJGu+Ee5xywIT"
Content-Disposition: inline
In-Reply-To: <20140718071115.GH30888@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oplxJGu+Ee5xywIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 18, 2014 at 08:11:15AM +0100, Lee Jones wrote:

<snip>

> > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > index eb69eb9..171ca52 100644
> > > --- a/drivers/usb/dwc3/core.c
> > > +++ b/drivers/usb/dwc3/core.c
> > > @@ -47,6 +47,14 @@
> > > =20
> > >  /* -----------------------------------------------------------------=
--------- */
> > > =20
> > > +static bool is_enabled =3D false;
> > > +
> > > +int dwc3_is_enabled(void)
> > > +{
> > > +	return is_enabled;
> > > +}
> > > +EXPORT_SYMBOL(dwc3_is_enabled);
> >=20
> > no, no, no, no. Let me try that again, hello no! You _do_ realise there
> > are systems with more than one dwc3 instance, right ? And this is the
> > most fragile possible way of doing this.
> >=20
> > You never explained what's a dwc3 subordinate driver, you don't show any
> > example of how this would be used and why/where does the PHY need to
> > poke into DWC3. Why isn't probe defer enough for you ? Which platform
> > are you working on ? what is the problem that you're trying to solve ?
> >=20
> > From this patch, all I can is NAK this patch with no mercy, sorry.
>=20
> That's okay, I knew this was going to happen hence the RFC status of
> the patch.  In the DT case, I describe 'subordinate devices' as are
> drivers which register the DWC3 core using of_platform_populate(),=20
> so, for now:
>=20
>   drivers/usb/dwc3/dwc3-exynos.c
>   drivers/usb/dwc3/dwc3-keystone.c
>   drivers/usb/dwc3/dwc3-omap.c
>=20
> We're attempting to use the same process; however, at the moment we are
> suffering with a 'boot order' issue.  If the PHYs aren't up and we
> attempt to configure through the glue-layer our board locks up. =20

what are you configuring through the glue-layer ? Which glue-layer is
causing that ?

> Presumably waiting for a read to return, forever.  Whist the core does
> the correct thing i.e. -EPROBE_DEFER, we (dwc3-st.c) have no way of

ah! finally, the glue layer.

> checking the return status of dwc3_probe().  As mentioned in the

yeah, because glue layers are not supposed to know. There should be no
coupling what so ever between glue layer and core driver, other than the
fact that glue layer is the one which triggers platform_device creation
through of_platform_population(). But the glue layer has (or should
have) no interest in exactly when the core driver finishes probing.

> commit message, another way of ensuring the PHYs are available is to
> request them, but this would mean an awful lot of code duplication.
>=20
> In your opinion, what's the best way to handle this?

How can I know ? You still haven't fully explained what you need. All
you said was that you're trying to "configure through the glue-layer".

Care to further explain what the problem really is ? I'm assuming below
is what you're concerned about which I had to go dig in the archives
because there was no reference to that patch anywhere here.

> +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> +{
> +	u32 reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> +
> +	reg |=3D aux_clk_en(1) | ext_cfg_reset_n(1) | xhci_revision(1);

so you have auxiliary clock, an external config reset, what's this
xhci_revision ?

> +	reg &=3D ~sw_pipew_reset_n(1);

another reset

> +	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);

looks like it should be split between a CCF and reset drivers. Or maybe
a single driver which does both. Do you have a clock/reset control for
all IPs ? That might be a good way to hide stuff, driver would simply
call clk_get()/clk_prepare_enable() and reset_assert()/deassert() when
necessary (sure, this doesn't solve the 'when has that guy probe' but
you still haven't explained why you need it).

> +	reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1);
> +	reg |=3D SEL_OVERRIDE_VBUSVALID(1) | SEL_OVERRIDE_POWERPRESENT(1) |
> +	    SEL_OVERRIDE_BVALID(1);

this is not correct. You don't know if VBUS is really valid at this
time. We have used a gpio which gets pull high/low depending on the
state of VBUS/ID.

> +	st_dwc3_writel(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1, reg);
> +	udelay(100);
> +
> +	reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> +	reg |=3D sw_pipew_reset_n(1);
> +	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);

let me ask you something else. Isn't the DWC3_GUSB3PIPECTL_PHYSOFTRST
bit functional for you guys ? This sw_pipe2_reset_n looks suspicious.

ps: I read that the board hangs, but why ? Have you checked with IP
folks ? Maybe that's a silicon bug they're going to fix and we can hack
things for now with an errata ID/revision check ?

--=20
balbi

--oplxJGu+Ee5xywIT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTyTHsAAoJEIaOsuA1yqRE78QQALMnnaEq0CzzzRspxVdI8XV9
IiMriQ+CyuCRQbQQav5wuAxQJnFPyKk53KZMm+fPgRCVZ8W6nJhH7TJqYOnZnNJt
46Tlz/QkcoQ47+2Y/i8jBoM9c7u8lSqNjhiVh1Q+Q6oWwwvYjtPU5OoIC0K6rKx1
Qga7ezFTm3zOKj2ZKkFQIF5r0SG4mxnuod2zKokZgApv/g+hwXw8o7oHQZPK6tOj
aDMKqa3Eei3YK4UXCQQPTbfAlJfXlO3GyYo9FUVmG6vuxBc4p7FfzYMaqS7E6Wa/
EKvwTYgwPHfgX9/PFkzxQzeFQaRqKUrM5QcBPbZ1hj9K0ooJksvoHsbkSMMC6KDP
CzX41m0+kGhIv7SBtwadcTJx+UN5jdWn0yLGeBIWrtlTS5nPYUoKhs2YzVrxnzce
UUvfDpfVHMTwfqao50YAOfW4cte/G3JdbeasSnqs0lau6m1HgrOeNHE+/o4p7MRk
OnpflmPG2h9M3XI6NAxV8tCnQFA7tLqK7ABxdZTFppRw2wmW7RWmlwq69d056kfO
icRWn30EX0PFjZZat4QF7IfQYlgdGHEOFYZzzO63lIRNiUctiLuaggeAiPBoeFUz
6joBqskcMuTVlpxV9cEB3NukDfdBBx7d9gNaDkyZBazkJFY4xl/ZO112SuGQNXPP
gt3k9G32GGafwh8D8p5D
=kBrf
-----END PGP SIGNATURE-----

--oplxJGu+Ee5xywIT--
