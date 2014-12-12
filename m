Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbaLLBPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 20:15:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:60796 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757750AbaLLBPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 20:15:10 -0500
Date: Fri, 12 Dec 2014 02:15:04 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<ivo.g.dimitrov.75@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: __hci_cmd_sync() not suitable for nokia h4p
Message-ID: <20141212011504.GA16599@earth.universe>
References: <20141209190210.GA15641@amd>
 <304050AD-DB11-4A2B-A1F7-8B1BBB5F04F0@holtmann.org>
 <20141209201328.GA18003@amd>
 <7EFD3C33-E503-4FB6-BCCF-52836080ABD6@holtmann.org>
 <20141210131519.GA14748@amd>
 <EE1A4B9D-30D5-4BD9-9A43-532619494A0C@holtmann.org>
 <20141211221306.GA2905@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <20141211221306.GA2905@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 11, 2014 at 11:13:07PM +0100, Pavel Machek wrote:
> Hi!
>=20
> > > h4p changes uart speed again after load of the firmware, but I guess
> > > that's ok.
>=20
> >  if you can do it the other way around it would result in a faster
> > init. Depending on how many patches are actually required to be
> > loaded.
>=20
> IIRC driver does two speed changes, so it looks to me like someone
> already tried that (and it did not work).

maybe. maybe not. Should be easy to test it (again) and add a
comment, shouldn't it?

> > >> What needs to be done is the bring up of the device including the pr=
oper UART settings and speed and then just run the firmware downloads. All =
firmware files on the Nokia devices where just HCI commands with vendor spe=
cific details. Some from CSR, some from Broadcom and some from TI. You can =
actually decode them if you really want to. Shouldn't be that hard.
> > >>=20
> > >=20
> > > Speed changes at the end of firmware load, but I guess that's detail?
> > > Anyway, patch would look like this.
> >=20
> > You should really look into providing hdev->setup() callback. That is n=
ormally the callback where you want to load the firmware.
> >=20
>=20
> I can provide setup() callback and load firmware from there.
>=20
> I have created provisional device tree binding, and the driver still
> works.

I don't have time to look at the code now, but I have some comments
regarding the binding.

> Some time ago you mentioned that with the "big" issues fixed, you'd be
> willing to take it into the tree. What way forward do you see? Would
> it make sense to re-enable the driver in staging, so that "big"
> changes could be applied, followed by renames?
>=20
> Thanks,
> 								Pavel
>=20
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n=
900.dts
> index 9e0e5a2..201f21b 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -790,9 +776,21 @@
>  };
> =20
>  &uart2 {
> +        compatible =3D "brcm,uart,bcm2048";

This does not look correct. The uart should not be overwritten. The
current h4p driver indeed implements a driver for the serial port,
but that's a) linux specific and does not belong in the DT and b)
should probably be changed in the mainline kernel.

>  	interrupts-extended =3D <&intc 73 &omap3_pmx_core OMAP3_UART2_RX>;
>  	pinctrl-names =3D "default";
>  	pinctrl-0 =3D <&uart2_pins>;
> +	device {
> +		  compatible =3D "brcm,bcm2048";
> +		  uart =3D <&uart2>;

You don't need a phandle to the parent device.

> +		  reset-gpios =3D <&gpio3 27 GPIO_ACTIVE_HIGH>; /* want 91 */
> +		  host-wakeup-gpios =3D <&gpio4 5 GPIO_ACTIVE_HIGH>; /* want 101 */

The host-wakeup should be mapped as irq, gpio2irq conversion
will happen ;)

> +		  bluetooth-wakeup-gpios =3D <&gpio2 5 GPIO_ACTIVE_HIGH>; /* want 37 */

To be consistent with the n900 DTS file you should probably drop
"want " from the comments.

> +		  chip-type =3D <3>;

This should be set in the driver based on the compatible
value and not via DT data.

> +		  clocks =3D <&uart2_fck>, <&uart2_ick>;
> +		  clock-names =3D "fck", "ick";

These clocks you defined belong to the uart device and not to the
uart slave (bluetooth) device.

> +		  bt-sysclk =3D <2>;

I think this should be mapped cleanly in DT by adding a new clock
to the DTS file:

vctcxo_clock: clock  {
    compatible =3D "fixed-clock";
    #clock-cells =3D <0>;
    clock-frequency =3D <38400000>;
};

Then the bluetooth device can reference its clock device:

clocks =3D <&vctcxo_clock>;

The same clock reference should be added to the wl1251 DT node :)

> ... [code] ...

-- Sebastian

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUikGVAAoJENju1/PIO/qarccP/1m0jZaqvO/05eEN3P251HkG
Dn4KpMmj8F+B+AEuq+3DkCIdKRR+d5pfAxV2TMOU6dLwwNghaJvl69Rc7IYj0TM2
gU4QIvbOR5ylFigXYlgolGaFQb2j1wTlG+g5Mco8EV3Qa/K2o2dAC5Ao/DMaB58v
/95//yebUOSmfpflBLnNKV1KZn8WYzbZKiSU++x5Sil5BYTogl/h5HJOXKpByOEV
stEmp8kf/RUcv1BFzeLwBZfUIxVWbXmdKRviVr3/HqhLWq2vev+tVExXJc2pxT2s
vyBMlZy1G74u58aMk/dhk3PdN1f048TCtk8GC+4EHJ59eknrwiLBIOC1K6YOGw3L
+k9GjuZyG2HYiTk2ELdcZbKL003UuoDvzMC/oqtlAmjIUDVLCkS8ZrjTP7X9zh+z
MlxnpjO67S3S1Inw8kVVojUIaLCx/1nBHxnVp7RCcQACiy/2dVIPKCTIMoQodoMe
Ri3YXVD5YwE29KhDooagpVliMRLoCp2WdGu3ciw5nmW+4OKWZ+GpinezqCLv9yzl
LjExdDwuDAhYQaLITbAccGqpPfEWDF5j6lybXRg/YqN0AzEzRq46u3xy7njF5msH
f5OeWglE3dRaD/aIko/s1QfJ2nltqYLcq7MiJPJKNyqGLK8allOkAMYI33wYkIUl
cMUmJw8u5WTZ6FbrDzs+
=TAb3
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
