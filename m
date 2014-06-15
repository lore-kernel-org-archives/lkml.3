Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaFOJKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 05:10:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:58881 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaFOJKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 05:10:09 -0400
Date: Sun, 15 Jun 2014 11:09:38 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Houcheng Lin <houcheng@gmail.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] [RFC PATCH v2] power:reset: Add defer reset object to
 send board specific reset
Message-ID: <20140615090932.GA29771@earth.universe>
References: <1402816289-7024-1-git-send-email-houcheng@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <1402816289-7024-1-git-send-email-houcheng@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jun 15, 2014 at 03:11:29PM +0800, Houcheng Lin wrote:
> The Problem
> -----------
> The reset signal on a hardware board is send either:
>     - during machine initialization
>     - during bus master's initialization
>=20
> In some hardware design, devices on bus need a non-standard and extra res=
et
> signal after bus is initialied. Most reason is to wake up device from han=
ging
> state.
>=20
> The board spefic reset code can not be put into machine init code, as it =
is
> too early. This code can not also be put onto chip's driver, as it is boa=
rd
> specific and not suitable for a common chip driver.
>=20
> Defer Reset Object
> ------------------
> The defer reset object is to resolve this issue, developer can put a defe=
r-
> reset device on the board's dts file and enable DEFER RESET OBJECT CONFIG.
> During driver init-calls, a defer-reset object is created and issue reset=
 signal
> after the enclosing device is initialized.
>=20
> This eliminate the need to rewrite a driver module with only one purpose:=
 sending
> a board specific reset. This also allow mainstream kernel to support many=
 boards
> that modify the common drivers to send board specific reset. Configuring =
defer-reset
> device in dts leave the board specific reset rules on board level and sim=
ple to
> maintain.
>=20
> Example dts File
> ----------------
>     usb-ehci-chip@1211000{
>         usb-phy =3D <&usb2_phy>;
>         defer_reset_vbus {
>             compatible =3D "defer-reset";
>             reset-gpios =3D <&gpx3 5 1>;
>             reset-init =3D <0>;
>             reset-end =3D <1>;
>             delay =3D <5>;
>         };
>     };
>=20
> Block Diagram of dts File
> -------------------------
>     +-------------------------------------+
>     | usb-ehci-chip@1211000               |
>     |   +-------------------------+       |
>     |   | defer-reset(gpx3)       |       |
>     |   +-------------------------+       |
>     +-------------------------------------+
>=20
> Signed-off-by: Houcheng Lin <houcheng@gmail.com>
> ---
>  .../devicetree/bindings/gpio/gpio-defer-reset.txt  |  22 +++
>  drivers/power/reset/Kconfig                        |   8 +
>  drivers/power/reset/Makefile                       |   1 +
>  drivers/power/reset/gpio-defer-reset.c             | 192 +++++++++++++++=
++++++

I think this belongs to drivers/reset and not to drivers/power/reset.
The drivers in drivers/power/reset are about board reboot / shutdown.
This driver seems to be used for periphals.

>  4 files changed, 223 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-defer-res=
et.txt
>  create mode 100644 drivers/power/reset/gpio-defer-reset.c
>=20
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-defer-reset.txt =
b/Documentation/devicetree/bindings/gpio/gpio-defer-reset.txt
> new file mode 100644
> index 0000000..5d55830
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-defer-reset.txt
> @@ -0,0 +1,22 @@
> +GPIO defer reset binding
> +
> +Put a defer-reset device in a device node and enable DEFER RESET OBJECT =
CONFIG.
> +During driver init-calls, a defer-reset object will be created and issue=
 reset
> +signal after the enclosing device node's initialization complete.
> +
> +Required properties:
> +- compatible:
> +  - "defer-reset" for creating defer reset object
> +- reset-gpio: specify gpio pin, can be an array.
> +- reset-init: specify reset signal initial value, can be 0 or 1.

You can simply use GPIO's HIGH_ACTIVE / LOW_ACTIVE flag for the
"initial value".

> +- reset-end: specify reset signal end value, can be 0 or 1.

You can use a property without a value for booleans. If the property
is there, the value is 1 and if its missing the value is 0.

For example in your case you could use

hold-reset-line;

to inform the system, that the reset signal should not be changed
back after the specified time.

> +- delay: specify reset duration in ms.

Alternatively you could do this via the duration. An infinite long
reset signal basically means, that the line is never changed back.

> +
> +Example:
> +	defer_reset_vbus {
> +		compatible =3D "defer-reset";
> +		reset-gpios =3D <&gpx3 5 1>;
> +		reset-init =3D <0>;
> +		reset-end =3D <1>;
> +		delay =3D <5>;
> +	};

To give a few examples for the above comments:

/* keep "gpx3 5" low for 5ms, change back to high afterwards */
defer_reset_vbus {
    compatible =3D "defer-reset";
    reset-gpios =3D <&gpx3 5 GPIO_ACTIVE_LOW>;
    duration =3D <5>;
};

/* keep "gpx3 5" high for 5ms, change back to low afterwards */
defer_reset_vbus {
    compatible =3D "defer-reset";
    reset-gpios =3D <&gpx3 5 GPIO_ACTIVE_HIGH>;
    duration =3D <5>;
};

/* keep "gpx3 5" low */
defer_reset_vbus {
    compatible =3D "defer-reset";
    reset-gpios =3D <&gpx3 5 GPIO_ACTIVE_LOW>;
    duration =3D <0>;
};

> [...]

-- Sebastian

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTnWLMAAoJENju1/PIO/qaqHwP/0hgnEbNasmEesFJs5WEFGZF
+FHu8nHzeA4pPn1chOw4NaaHbWhRgMTG7Gx5RbkbHQReid+L9SfwxSFt/Aqm9NU7
S9QlvvobCbuZiLtRDZhu8fqYPXSHRg5G754ZOy/hQwBHdRdClDn8J0/Enk7jngVw
yK8ykHZgcLvVAjQGQ+hOUN7YYeXnaJjhv2EPwP0afq4nXd3VTa1kYc0BhJaQTrig
TletSThNX6pWGx92cYgReIrNPDFMFjJ0pjEB50pZi2VHg3cZtTeVZcos1nDp/qn4
QLHbtxxmRzzlw3H024SArMCmN5DZ9rcL5iWpiubsVwCxRldRwfUkijk0kLfbB/qd
tKqmP40xZ0Tc2Jk30LJgZC6YmsMrw3VN83H/wq4xSeT8IrZNSeJd3RwGQMVkBMCd
g2elbhlEs8KX2LZPwOH+W3B1N6TBVVPVz7ayhS1wljOfJLQY6ob4ioxf53lAYrpC
FpZT8Oz2rbk4iVPUyCGcC/PqOosVdMEQ3vqQrIsve/Cj/9vH3chhG3IJAKVGIvj0
jBaCvhI3pC8lQdqNUI1WQaB3TmUAiYSaVJX2abs8b5VOF4PmXcrEzxWZgvObUBqS
JscsJFd08u6SAWd2oWuqWnzHkKVm1IYxCYxwiXwFI/N9rolA87eBydacyuaRaWQJ
4/c2ft5rJS+V9iA0/Zsn
=0cup
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
