Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3JJLLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:11:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33745 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab3JJLLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:11:04 -0400
Message-ID: <52568B40.4040802@ti.com>
Date: Thu, 10 Oct 2013 14:10:56 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
CC: Marek Belisko <marek@goldelico.com>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com>
In-Reply-To: <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="2DV6krLhrTwJeD94HfVGuNSxjrrHvSC31"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2DV6krLhrTwJeD94HfVGuNSxjrrHvSC31
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/10/13 12:34, Dr. H. Nikolaus Schaller wrote:
> Hi Tomi,
>=20
> Am 10.10.2013 um 10:19 schrieb Tomi Valkeinen:
>=20
>> Hi,
>>
>> On 10/10/13 00:08, Marek Belisko wrote:
>>> For communicating with driver is used gpio bitbanging because TD028 d=
oes
>>> not have a standard compliant SPI interface. It is a 3-wire thing wit=
h
>>> direction reversal.
>>
>> Isn't that SPI_3WIRE?
>=20
> Maybe - but we have no complete datasheet and I don't know an official =
spec of
> a 3-wire SPI protocol to compare how 3-wire should work.

Yep, and I know only what I read on wikipedia a few hours ago =3D).

> And I think (but I may be wrong) that SPI_3WIRE is an optional feature =
of the SoC
> specific SPI drivers and in my understanding the OMAP has no such drive=
r:
>=20
> http://lxr.free-electrons.com/source/drivers/spi/spi-omap2-mcspi.c#L874=

>=20
> And spi-bitbang.c hasn't either.
>=20
> So I would prefer to leave this as an area for optimizations for future=
 work.
> Maybe we can add some more comments on this.

Ok. Well, I guess it's not too bad. But it's really not something that
should be in the panel driver (assuming it's "standard" 3-wire SPI).
Some SoC could support 3-wire SPI, and then it'd be good to use the SoCs
hardware for SPI communication. Having bitbanging hardcoded into the
driver will prevent that.

>>> +	int cs_gpio;
>>> +	int scl_gpio;
>>> +	int din_gpio;
>>> +	int dout_gpio;
>>
>> Three wires, but four gpios? What am I missing here...
>=20
> We have wired up the 3-wire SPI interface of the display
> to 4 wires of the McSPI interface because we initially thought
> that it could work in 4 wire mode as well.
>=20
> The next step we did was to port the driver code from the
> Openmoko Neo1973 U-Boot which used the gpio-bitbang
> mechanism.
>=20
> Since it worked and is used only for enabling/disabling the
> display and for no other purpose we never felt it important
> to check or modify the code to use SPI.
>=20
> But you are right - we don't use the din_gpio really since
> we never read registers from the chip. So 3 gpios could be
> sufficient.
>=20
> Or we must handle the case that din_gpio =3D=3D dout_gpio
> in panel_probe to avoid duplicate use of the same gpio.

The panel hardware has three wires, so the panel driver (if it does
handle the bus by bitbanging) can only refer to three gpios. So either
the bus details should be hidden by using the normal spi framework, or
if the driver does the bitbanging, use the gpios as specified in the
panel spec. The panel driver cannot contain any board specific stuff.

>>> +static int jbt_spi_xfer(struct panel_drv_data *data, int wordnum, in=
t bitlen)
>>
>> Hmm, if it's not SPI, maybe it shouldn't be called SPI?
>=20
> Yes, we can remove the _spi_ in this name.

Or maybe use "spi3w" or such, just to make it clear it's not plain
standard spi. Again, presuming it's really 3-wire spi =3D).

>>> +static int td028ttec1_panel_probe(struct platform_device *pdev)
>>> +{
>>> +	struct panel_drv_data *ddata;
>>> +	struct omap_dss_device *dssdev;
>>> +	int r;
>>> +
>>> +	ddata =3D devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
>>> +	if (ddata =3D=3D NULL)
>>> +		return -ENOMEM;
>>> +
>>> +	platform_set_drvdata(pdev, ddata);
>>> +
>>> +	if (dev_get_platdata(&pdev->dev)) {
>>> +		r =3D td028ttec1_panel_probe_pdata(pdev);
>>> +		if (r)
>>> +			return r;
>>> +	} else {
>>> +		return -ENODEV;
>>> +	}
>>> +
>>> +	if (gpio_is_valid(ddata->cs_gpio)) {
>>> +		r =3D devm_gpio_request_one(&pdev->dev, ddata->cs_gpio,
>>> +				GPIOF_OUT_INIT_HIGH, "lcd cs");
>>> +		if (r)
>>> +			goto err_gpio;
>>> +	}
>>> +
>>> +	if (gpio_is_valid(ddata->scl_gpio)) {
>>> +		r =3D devm_gpio_request_one(&pdev->dev, ddata->scl_gpio,
>>> +				GPIOF_OUT_INIT_HIGH, "lcd scl");
>>> +		if (r)
>>> +			goto err_gpio;
>>> +	}
>>> +
>>> +	if (gpio_is_valid(ddata->dout_gpio)) {
>>> +		r =3D devm_gpio_request_one(&pdev->dev, ddata->dout_gpio,
>>> +				GPIOF_OUT_INIT_LOW, "lcd dout");
>>> +		if (r)
>>> +			goto err_gpio;
>>> +	}
>>> +
>>> +	if (gpio_is_valid(ddata->din_gpio)) {
>>> +		r =3D devm_gpio_request_one(&pdev->dev, ddata->din_gpio,
>>> +				GPIOF_IN, "lcd din");
>>> +		if (r)
>>> +			goto err_gpio;
>>> +	}
>>> +
>>> +	/* according to data sheet: wait 50ms (Tpos of LCM). However, 50ms
>>> +	 * seems unreliable with later LCM batches, increasing to 90ms */
>>> +	mdelay(90);
>>
>> What is this delay for? Usually sleeps/delays should be between two "H=
W
>> actions". Here there's nothing below this line that would count as suc=
h
>> an action.
>=20
> I guess that this delay is intended to power on the display first, then=
 wait some

I'm not very comfortable with merging a driver, when the driver author
guesses what parts of the driver do =3D).

> time and after that delay enable the DSS clocks and signals and make th=
e
> controller chip in the panel initialize.

I don't see the code before the delay doing any power up, it just sets
the data bus gpios to certain state. Do those gpio initializations power
up the panel?

> But this of course depends on the order the DSS components are probed
> and enabled and how power is controlled (we don't interrupt power at al=
l).
>=20
> I think we can move this delay (sleep) to the beginning of=20
>=20
> td028ttec1_panel_enable() before /* three times command zero */
>
> to make sure that a freshly powered display has enough time to do its
> internal reset and initializations before registers are programmed.

The probe function should not enable the panel (well, it can enable the
panel, but only to read an ID or such and then disable it before exiting
probe).

So after probe, the panel should be as dead as possible, power disabled
etc. All the powering up should happen in enable().

 Tomi



--2DV6krLhrTwJeD94HfVGuNSxjrrHvSC31
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSVotAAAoJEPo9qoy8lh71ScIP/0axQGLQWOaR+pHahmz3Z3g2
JRLYxyDrna4CwpyirVQTnDuTA5uMtGHnOWetN5YGSyxutOxW+dtq2voBpgHZbRz6
GUJAbg5hD650IP13aoWrHppPe1B6TNO0N5EQqs4YV355mGPmT9TPHRWvX8HQe9UA
3oJFVVPSIsVuBIRjFPofUAYQ6fPlPcftXG85ZXq8rn4rptLebItMdElvt8fZ9J3q
k0RHbMmuw7u2VU2X4g0TujlrBXlif3akdO/JVhZu7p1Gr33B4CYV0eE1U8sP69OA
yqt84SOL1kLMYiVDuMBdrQvFWNn32Y/BuGhVgWN1N2W/59EGz/4NGGEnWOPmWQtm
X62pT6MCDzIufg3xVVtEHU1pN7B9cky6ZVKj4ArB70nk687YgHYFHNUxZQxJ1zg0
iBgwsObNQc23AfvrCUDW/farQyj5dHHHCEwzIsGw2zSpRK3YzFc7y9HCanJA2A2J
+1IIA4DSNcS6vFqRzYN9w0IQDjAOUQcXQPyi+T2jEV5COE4qQ6swbYO9etlQiTrn
Qf/ByjzyL6uN589rPIjK0KhXb98fboAzjNtcVpZUX2QOhLuR5NAzgJyDXAPAzH7I
DhX4rohHW70IoTf6BD6f6y0bLtKPxpAh4gLw9GrA5ge+W8YdOO+x3NimJW1incvP
uZQ8/mDh0Xs3ogEYVyeM
=EdUe
-----END PGP SIGNATURE-----

--2DV6krLhrTwJeD94HfVGuNSxjrrHvSC31--
