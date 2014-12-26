Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaLZEt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 23:49:59 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49261 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaLZEt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 23:49:56 -0500
Date: Thu, 25 Dec 2014 22:49:29 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <baolu.lu@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC/PATCH] extcon: otg_gpio: add driver for USB OTG port
 controlled by GPIO(s)
Message-ID: <20141226044929.GC7661@saruman>
Reply-To: <balbi@ti.com>
References: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141224002904.GE32702@saruman>
 <20141224224327.GA3175@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <20141224224327.GA3175@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 24, 2014 at 02:43:27PM -0800, David Cohen wrote:
> Hi Felipe,
>=20
> Thanks replying.
>=20
> On Tue, Dec 23, 2014 at 06:29:04PM -0600, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Dec 22, 2014 at 02:43:37PM -0800, David Cohen wrote:
> > > Some platforms have an USB OTG port fully (or partially) controlled by
> > > GPIOs:
> > >=20
> > > (1) USB ID is connected directly to GPIO
> > >=20
> > > Optionally:
> > > (2) VBUS is enabled by a GPIO (when ID is grounded)
> >=20
> > ok, so a fixed regulator with a GPIO enable pin.
>=20
> Pretty much yes.

ok

> > > (3) Platform has 2 USB controllers connected to same port: one for
> > >     device and one for host role. D+/- are switched between phys
> > >     by GPIO.
> >=20
> > so you have discrete mux with a GPIO select signal, like below ?
> >=20
> >=20
> >  .-------.----------------.  .--------.
> >  |       |                |  |        |      D+
> >  |       |                |  |        |<-------------.
> >  |       |                |  |        |              |
> >  |       |    USB Host    -->|    P   |              |
> >  |       |                |  |    H   |              |
> >  |       |                |  |    Y   |    D-        |
> >  |       '----------------'  |    0   |<--------.    |
> >  |                       |   |        |         |    |
> >  |                       |   '--------'      .--------.  D+
> >  |                       |                   |        |------>
> >  |       SOC        GPIO | ----------------->|        |
> >  |                       |                   |   MUX  |
> >  |                       |                   |        |------>
> >  |                       |   .--------.      '--------'  D-
> >  |       .----------------.  |        |   D-  |      |
> >  |       |                |  |    P   |<------'      |
> >  |       |                |  |    H   |              |
> >  |       |                |  |    Y   |              |
> >  |       |   USB Device   -->|    1   |              |
> >  |       |                |  |        |      D+      |
> >  |       |                |  |        |<-------------'
> >  |       |                |  |        |
> >  '-------'----------------'  '--------'
>=20
> Nice ASCII pic :)

asciio ftw \o/

> Yes, that's the case.

alright

> > I have been on and off about writing a pinctrl-gpio.c driver which would
> > allow us to hide this detail from users. It shouldn't really matter
> > which modes are available behind the mux, but we should be able to tell
> > the mux to go into mode 0 or mode 1 by toggling its select signal. And
> > it shouldn't really matter that we have a GPIO pin. The problem is: I
> > don't really know if pinctrl would be able to handle discrete muxes.
> >=20
> > Adding Linus W to ask. Linus, what do you think ? Should we have a
> > pinctrl-gpio.c for such cases ? In TI we too have quite a few boards
> > which different modes hidden behind discrete muxes.
>=20
> An input from Linus would fine in this case.
>=20
> >=20
> > > As per initial version, this driver has the duty to control whether
> > > USB-Host cable is plugged in or not:
> > >  - If yes, OTG port is configured for host role
> > >  - If no, by standard, the OTG port is configured for device role
> >=20
> > correct, this default-B is mandated by OTG spec anyway.
> >=20
> > > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > > ---
> > >=20
> > > Hi,
> > >=20
> > > Some Intel Bay Trail boards have an unusual way to handle the USB OTG=
 port:
> > >  - The USB ID pin is connected directly to GPIO on SoC
> > >  - When in host role, VBUS is provided by enabling a GPIO
> > >  - Device and host roles are supported by 2 independent controllers w=
ith D+/-
> > >    pins from port switched between different phys according a GPIO le=
vel.
> > >=20
> > > The ACPI table describes this USB port as a (virtual) device with all=
 the
> > > necessary GPIOs. This driver implements support to this virtual devic=
e as an
> > > extcon class driver. All drivers that depend on the USB OTG port stat=
e (USB phy,
> > > PMIC, charge detection) will listen to extcon events.
> >=20
> > Right I think you're almost there, but I still think that this needs to
> > be a bit broken down. First, we need some generic DRD library under
> > drivers/usb/common, and that should be the one listening to extcon cable
> > events. But your extcon driver should be doing only that: checking which
> > cable was attached, it shouldn't be doing the switch by itself. That
> > should be part of the DRD library.
> >=20
> > That DRD library would also be the one enabling the (optional) VBUS
> > regulator.
> >=20
> > George Cherian tried to implement a generic DRD library but I think
> > there are still too many changes happening on usbcore and udc-core. Most
> > of the pieces are already there (usb_del_hcd() and usb_del_gadget_udc()
> > know how to properly unload an hcd/udc), but there are details missing,
> > no doubt.
> >=20
> > If we can find a way to broadcast (probably not the best term, but
> > whatever) a "Hey ID pin was just grounded" message, we can get things
> > working.
> >=20
> > That message, btw, shouldn't really depend on extcon-gpio alone because
> > other platforms might use non-gpio methods to verify ID pin level. In
> > any case, we need to have generic ID_PIN_LOW and ID_PIN_HIGH messages
> > that a generic DRD library can listen to and load/unload the correct
> > drivers by means of usb_{add,del}_{hcd,gadget_udc}().
>=20
> IMHO extcon is the correct way to broadcast it, as long as we define a
> standard for the cable names. E.g. DRD library could listen to
> "USB-HOST" cable state. Then it doesn't matter how ID pin is grounded,
> it just matters that whoever is controlling it broadcast via this cable.

right, the likelyhood that someone would not use a GPIO is also quite
minimal and for such cases, the controller would likely switch roles
automatically (like with MUSB).

> > With that in mind, I think you can use extcon-gpio.c for your purposes
> > if the other pieces can be fullfilled by regulator and pinctrl.
>=20
> In my case we have all gpios listed in a single ACPI device. In order to
> be backwards compatible with products already on market, we'd need
> something like a single mfd to register platform devices for this
> smaller pieces (extcon gpio, possible pintrl gpio, maybe vbus as regulato=
r??).

correct.

> > > +	ret =3D devm_request_threaded_irq(dev, gpiod_to_irq(vup->gpio_usb_i=
d),
> > > +					vuport_isr, vuport_thread_isr,
> > > +					IRQF_SHARED | IRQF_TRIGGER_RISING |
> > > +					IRQF_TRIGGER_FALLING,
> > > +					dev_name(dev), vup);
> > > +	if (ret < 0) {
> > > +		dev_err(dev, "cannot request IRQ for USB ID GPIO: ret =3D %d\n",
> > > +			ret);
> > > +		goto irq_err;
> > > +	}
> > > +	vuport_do_usb_id(vup);
> > > +
> > > +	platform_set_drvdata(pdev, vup);
> > > +
> > > +	dev_info(dev, "driver successfully probed\n");
> >=20
> > this will just make boot noisier, make it dev_dbg() ? Or even
> > dev_vdbg() ?
>=20
> dev_dgb() perhaps.

sure, why not :-)

--=20
balbi

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUnOjZAAoJEIaOsuA1yqRECAMP+wZnGjlJL5Vvjzlr6hXS4smD
e1QQA4owRtaPj5CJb5/Gicd/mJpBBaLwTo05EogUBWI4AjKVJ03ER4DZgUG5oxE9
xr2hWuxQiHGLpVu4n9+tc9vBxwxgoDSoc8mcHuaEjEf3cMECbODORd6JtXt9Ehr5
Hn5JrVxcP6T9k2dPA6EOHLGwa1OhSTEjGPWhOpaCe6gs5FDx0TS3qlRZzvGNpGuE
f8uAD89p/AK77vLyqfxFhOLXNxVXybcE9kkCNOo1RHc8fgXzZaaWf7Bolz2Igjsm
wA0/XIkMhd4awoAJKTgyVJqaP5mui7avnzlElpx+RDSI0f0RaHPmwu4WC2uUQRm2
mhph7NhAqKMwvP3UnZlVck8oNVDhR8F0cjFYtgiR1EK83PDcl/OLumOmJ6g8EdLJ
KPOirORa8tMm76ZbKSjgUkXcKgE2NQkEc30+sZjg05E+UuhBdLLVLN09sMSi3sGy
EeA1eQxFzq1/we+yFcaPEqEQI8CjCMqKnZsAFDOMg2AGpf88J256hEgWRyDs45lh
NhhRjlFaHk37J02nEx96aqcYli329aK/3NwqeV718UCNNP2PHQKMLJt7XnM2NaJj
L6u06C15acnuRimoE6GhAQ9l9e1cMHM7yfBmBevozFd8tEYg6p+AZznemFP7mcOh
SF2Jxkm2SFz7sp2lwYdT
=OtjZ
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
