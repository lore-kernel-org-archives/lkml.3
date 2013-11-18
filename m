Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab3KRWuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:50:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab3KRWuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:50:19 -0500
Date: Tue, 19 Nov 2013 09:50:01 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] LEDS: tca6502: add device-tree support for GPIO
 configuration.
Message-ID: <20131119095001.610e47c5@notabene.brown>
In-Reply-To: <20131118115512.GF30853@e106331-lin.cambridge.arm.com>
References: <20131101134120.13a44225@notabene.brown>
	<20131118115512.GF30853@e106331-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pzni9iv9=k+.qudDBdJBewZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pzni9iv9=k+.qudDBdJBewZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Nov 2013 11:55:12 +0000 Mark Rutland <mark.rutland@arm.com> wrot=
e:

> On Fri, Nov 01, 2013 at 02:41:20AM +0000, NeilBrown wrote:
> >=20
> > The 7 lines driven by the TCA6507 can either drive LEDs or act as outpu=
t-only
> > GPIOs.
> >=20
> > To make this distinction in devicetree we use the "compatible" property.
> >=20
> > If the device attached to a line is "compatible" with "gpio", we treat =
it
> > like a GPIO.  If it is "compatible" with "led" (or if no "compatible" v=
alue
> > is set) we treat it like an LED.
>=20
> I'm nto sure I understand the purpose of this.
>=20
> Are these lines all GPIOs, some of which happen to by attached to LEDs?
>=20
> If so, why is handlnig the device as a gpio-controller and using the
> gpio-leds binding not sufficient?

No, all the lines are designed to drives LEDs but can happen to be wired up
like GPIOs.  This configuration is explicitly described in the data sheets
for the chip, and is actually used in my board.

The 7 pins either float or sink current. They can switch between the two
modes in various ways under hardware control with a PWM which can have a
varying duty cycle.
So they are very suitable for driving LEDs as the PWM can adjust the appare=
nt
brightness and the varying duty cycle can effect a 'blink' pattern.

But the pins can also be fixed in one state of the other - either never on =
or
always on.  Floating or constantly sinking current.

This mode combined with a pull-up resistor makes an effective output-only
GPIO.  The same action that would turn the LED on, will pull the GPIO low.
The action that would turn the LED off, will allow the GPIO to go high.

So the device connected to each pin can be treated as an LED or as a GPIO.

I hope that clarifies the situation.

Thanks,
NeilBrown


>=20
> THanksm
> Mark.
>=20
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Docum=
entation/devicetree/bindings/leds/tca6507.txt
> > index 80ff3dfb1f32..d7221b84987c 100644
> > --- a/Documentation/devicetree/bindings/leds/tca6507.txt
> > +++ b/Documentation/devicetree/bindings/leds/tca6507.txt
> > @@ -2,6 +2,13 @@ LEDs connected to tca6507
> > =20
> >  Required properties:
> >  - compatible : should be : "ti,tca6507".
> > +- #address-cells: must be 1
> > +- #size-cells: must be 0
> > +- reg: typically 0x45.
> > +
> > +Optional properties:
> > +- gpio-controller: allows lines to be used as output-only GPIOs.
> > +- #gpio-cells: if present, must be 0.
> > =20
> >  Each led is represented as a sub-node of the ti,tca6507 device.
> > =20
> > @@ -10,6 +17,7 @@ LED sub-node properties:
> >  - reg : number of LED line (could be from 0 to 6)
> >  - linux,default-trigger : (optional)
> >     see Documentation/devicetree/bindings/leds/common.txt
> > +- compatible: either "led" (the default) or "gpio".
> > =20
> >  Examples:
> > =20
> > @@ -19,6 +27,9 @@ tca6507@45 {
> >  	#size-cells =3D <0>;
> >  	reg =3D <0x45>;
> > =20
> > +	gpio-controller;
> > +	#gpio-cells =3D <2>;
> > +
> >  	led0: red-aux@0 {
> >  		label =3D "red:aux";
> >  		reg =3D <0x0>;
> > @@ -29,5 +40,10 @@ tca6507@45 {
> >  		reg =3D <0x5>;
> >  		linux,default-trigger =3D "default-on";
> >  	};
> > +
> > +	wifi-reset@6 {
> > +		reg =3D <0x6>;
> > +		compatible =3D "gpio";
> > +	};
> >  };
> > =20
> > diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
> > index f5063f447463..93a2b1759054 100644
> > --- a/drivers/leds/leds-tca6507.c
> > +++ b/drivers/leds/leds-tca6507.c
> > @@ -638,6 +638,9 @@ static int tca6507_probe_gpios(struct i2c_client *c=
lient,
> >  	tca->gpio.direction_output =3D tca6507_gpio_direction_output;
> >  	tca->gpio.set =3D tca6507_gpio_set_value;
> >  	tca->gpio.dev =3D &client->dev;
> > +#ifdef CONFIG_OF_GPIO
> > +	tca->gpio.of_node =3D of_node_get(client->dev.of_node);
> > +#endif
> >  	err =3D gpiochip_add(&tca->gpio);
> >  	if (err) {
> >  		tca->gpio.ngpio =3D 0;
> > @@ -696,6 +699,8 @@ tca6507_led_dt_init(struct i2c_client *client)
> >  		led.default_trigger =3D
> >  			of_get_property(child, "linux,default-trigger", NULL);
> >  		led.flags =3D 0;
> > +		if (of_property_match_string(child, "compatible", "gpio") >=3D 0)
> > +			led.flags |=3D TCA6507_MAKE_GPIO;
> >  		ret =3D of_property_read_u32(child, "reg", &reg);
> >  		if (ret !=3D 0 || reg < 0 || reg >=3D NUM_LEDS)
> >  			continue;
> > @@ -709,6 +714,7 @@ tca6507_led_dt_init(struct i2c_client *client)
> > =20
> >  	pdata->leds.leds =3D tca_leds;
> >  	pdata->leds.num_leds =3D NUM_LEDS;
> > +	pdata->gpio_base =3D -1;
> > =20
> >  	return pdata;
> >  }
>=20


--Sig_/pzni9iv9=k+.qudDBdJBewZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoqZmTnsnt1WYoG5AQLoNQ/+N8ZWQ5hq/0azLK0wbZT7A7nvU3N3eMyR
OfgsPU7yBoUEtYyHvZR2eepf94fmXyD4eyP586u6xPiybbU9ne12RzPCTao3h5rX
3YYg0eo8o+DPkMHuPEw+x/P7wj3rRnaNIIT6iKfKqK29z1/cSJZ0Psp1kROHEjd4
N7WJdQEIyAAq9J6dCcYkjRTCnbpQEpIVA/SaUuZApG05fLWaCoTgbQDwvgLzk9J7
Yk+fBo0mUDu7D8J7FXJM8z6qV8VMBzfPlav02FPsL187H9uBkxInUFMsOCxiKgAY
UNgI5oaZFZZUUHjS7KlGXCo2xjxn5+AFd1ZsGSEuO4LqZk+pqZZ+QZLYTJul2m86
sz/peZO2pI5iJhEom46cxz35Sq7avJmLFu7WgYyFLSLMfTOixXAt/kEKf6B8cj5d
JMeHTqdVm+SHmwiMSPv2kTICSnqpT01JpvqxUhu1dFpW7L3Kd/pnh8KjXXsqtmBF
n6Zc3OynNrZeDiF9KH2S1ZVaHriWxxb/v6L2U/uh7MzJNzR2i36tgS//AusfBtXD
M7M36Jb1jIx02j08gBM4MUpxbO04S3e80S3OxR+E5eXHEkohVpzbsWzXf61J9KQL
EPNJhBTXFgamOr6cumFLmShvInknnsRNYof/TdbHIp5iSNJN9EmK3VpBuK42rnv2
oBxgdF8c6zM=
=drnJ
-----END PGP SIGNATURE-----

--Sig_/pzni9iv9=k+.qudDBdJBewZ--
