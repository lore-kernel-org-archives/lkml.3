Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3ITTWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:22:15 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:53463 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3ITTWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:22:10 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 4/4] RX-51: Add platform function and data for bq24150a charger
Date: Fri, 20 Sep 2013 21:22:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Anton Vorontsov <anton@enomsg.org>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <1378630239-10006-5-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1378630239-10006-5-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1595051.yiAgx1f6pU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309202122.06327@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1595051.yiAgx1f6pU
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 08 September 2013 10:50:39 Pali Roh=C3=A1r wrote:
> This patch will register bq24150a charger in RX-51 board data.
> Patch also adding platform function between isp1704 and
> bq2415x drivers for detecting charger type.
>=20
> So finally charging battery on Nokia N900 (RX-51) working
> automatically without any proprietary Nokia bits in userspace.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |   56
> +++++++++++++++++++++++++- 1 file changed, 55 insertions(+),
> 1 deletion(-)
>=20
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c
> b/arch/arm/mach-omap2/board-rx51-peripherals.c index
> 9c2dd10..a993ffe 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -25,6 +25,7 @@
>  #include <linux/gpio_keys.h>
>  #include <linux/mmc/host.h>
>  #include <linux/power/isp1704_charger.h>
> +#include <linux/power/bq2415x_charger.h>
>  #include <linux/platform_data/spi-omap2-mcspi.h>
>  #include <linux/platform_data/mtd-onenand-omap2.h>
>=20
> @@ -270,6 +271,44 @@ static struct platform_device
> rx51_battery_device =3D { .id	=3D -1,
>  };
>=20
> +static enum bq2415x_mode rx51_charger_mode =3D
> BQ2415X_MODE_OFF; +static void *rx51_charger_hook_data;
> +static void (*rx51_charger_hook)(enum bq2415x_mode mode, void
> *data); +
> +static int rx51_charger_set_hook(
> +		void (*hook)(enum bq2415x_mode mode, void *data), void
> *data) +{
> +	rx51_charger_hook =3D hook;
> +	rx51_charger_hook_data =3D data;
> +	if (rx51_charger_hook)
> +		rx51_charger_hook(rx51_charger_mode,
> rx51_charger_hook_data); +	return 1;
> +}
> +
> +static void rx51_charger_set_current(int mA)
> +{
> +	enum bq2415x_mode mode;
> +
> +	pr_info("RX-51: Charger current limit is %d mA\n", mA);
> +
> +	if (mA =3D=3D 0)
> +		mode =3D BQ2415X_MODE_OFF;
> +	else if (mA < 500)
> +		mode =3D BQ2415X_MODE_NONE;
> +	else if (mA < 1800)
> +		mode =3D BQ2415X_MODE_HOST_CHARGER;
> +	else
> +		mode =3D BQ2415X_MODE_DEDICATED_CHARGER;
> +
> +	if (rx51_charger_mode =3D=3D mode)
> +		return;
> +
> +	rx51_charger_mode =3D mode;
> +
> +	if (rx51_charger_hook)
> +		rx51_charger_hook(rx51_charger_mode,
> rx51_charger_hook_data); +}
> +
>  static void rx51_charger_set_power(bool on)
>  {
>  	gpio_set_value(RX51_USB_TRANSCEIVER_RST_GPIO, on);
> @@ -277,6 +316,7 @@ static void rx51_charger_set_power(bool
> on)
>=20
>  static struct isp1704_charger_data rx51_charger_data =3D {
>  	.set_power	=3D rx51_charger_set_power,
> +	.set_current	=3D rx51_charger_set_current,
>  };
>=20
>  static struct platform_device rx51_charger_device =3D {
> @@ -1017,6 +1057,16 @@ static struct aic3x_pdata
> rx51_aic3x_data2 =3D { .gpio_reset =3D 60,
>  };
>=20
> +static struct bq2415x_platform_data
> rx51_bq24150a_platform_data =3D { +	.current_limit =3D 100,		=09
/*
> mA */
> +	.weak_battery_voltage =3D 3400,		/* mV */
> +	.battery_regulation_voltage =3D 4200,	/* mV */
> +	.charge_current =3D 650,			/* mA */
> +	.termination_current =3D 100,		/* mA */
> +	.resistor_sense =3D 68,			/* m ohm */
> +	.set_mode_hook =3D &rx51_charger_set_hook,
> +};
> +
>  static struct i2c_board_info __initdata
> rx51_peripherals_i2c_board_info_2[] =3D { {
>  		I2C_BOARD_INFO("tlv320aic3x", 0x18),
> @@ -1044,7 +1094,11 @@ static struct i2c_board_info __initdata
> rx51_peripherals_i2c_board_info_2[] =3D { {
>  		I2C_BOARD_INFO("tpa6130a2", 0x60),
>  		.platform_data =3D &rx51_tpa6130a2_data,
> -	}
> +	},
> +	{
> +		I2C_BOARD_INFO("bq24150a", 0x6b),
> +		.platform_data =3D &rx51_bq24150a_platform_data,
> +	},
>  };
>=20
>  static struct i2c_board_info __initdata
> rx51_peripherals_i2c_board_info_3[] =3D {

Tony, can you look and review this board patch?

I think that this patch series it the most important for Nokia=20
N900, because it finally bringing charging support. And without=20
charging battery it very hard to use phone which has power supply=20
only from battery.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1595051.yiAgx1f6pU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI8oF4ACgkQi/DJPQPkQ1JukgCfeTmqm0qDgIsND8EomVbke5HO
5O8AnR/gbRymepoW2X7bWc/auvkV8GRR
=y7Rj
-----END PGP SIGNATURE-----

--nextPart1595051.yiAgx1f6pU--
