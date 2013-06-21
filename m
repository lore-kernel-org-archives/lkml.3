Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423693Ab3FUStY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:49:24 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56967 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423388Ab3FUStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:49:23 -0400
Date: Fri, 21 Jun 2013 20:49:21 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-fbdev@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        jimwall@q.com, brian@crystalfontz.com, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 2/2] fb: backlight: HX8357: Add HX8369 support
Message-ID: <20130621184921.GA26008@lukather>
References: <1371839259-543-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1371839259-543-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <1371839259-543-2-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Fri, Jun 21, 2013 at 08:27:39PM +0200, Alexandre Belloni wrote:
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/video/backlight/hx8357.c | 183 +++++++++++++++++++++++++++++++++=
++++--
>  1 file changed, 175 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/h=
x8357.c
> index 69f5672..b1c4042 100644
> --- a/drivers/video/backlight/hx8357.c
> +++ b/drivers/video/backlight/hx8357.c
> @@ -71,6 +71,18 @@
>  #define HX8357_SET_POWER_NORMAL		0xd2
>  #define HX8357_SET_PANEL_RELATED	0xe9
> =20
> +#define HX8369_SET_DISPLAY_BRIGHTNESS		0x51
> +#define HX8369_WRITE_CABC_DISPLAY_VALUE		0x53
> +#define HX8369_WRITE_CABC_BRIGHT_CTRL		0x55
> +#define HX8369_WRITE_CABC_MIN_BRIGHTNESS	0x5e
> +#define HX8369_SET_POWER			0xb1
> +#define HX8369_SET_DISPLAY_MODE			0xb2
> +#define HX8369_SET_DISPLAY_WAVEFORM_CYC		0xb4
> +#define HX8369_SET_VCOM				0xb6
> +#define HX8369_SET_EXTENSION_COMMAND		0xb9
> +#define HX8369_SET_GIP				0xd5
> +#define HX8369_SET_GAMMA_CURVE_RELATED		0xe0
> +
>  struct hx8357_data {
>  	unsigned		im_pins[HX8357_NUM_IM_PINS];
>  	unsigned		reset;
> @@ -144,6 +156,61 @@ static u8 hx8357_seq_display_mode[] =3D {
>  	HX8357_SET_DISPLAY_MODE_RGB_INTERFACE,
>  };
> =20
> +static u8 hx8369_seq_write_CABC_min_brightness[] =3D {
> +	HX8369_WRITE_CABC_MIN_BRIGHTNESS, 0x00,
> +};
> +
> +static u8 hx8369_seq_write_CABC_control[] =3D {
> +	HX8369_WRITE_CABC_DISPLAY_VALUE, 0x24,
> +};
> +
> +static u8 hx8369_seq_set_display_brightness[] =3D {
> +	HX8369_SET_DISPLAY_BRIGHTNESS, 0xFF,
> +};
> +
> +static u8 hx8369_seq_write_CABC_control_setting[] =3D {
> +	HX8369_WRITE_CABC_BRIGHT_CTRL, 0x02,
> +};
> +
> +static u8 hx8369_seq_extension_command[] =3D {
> +	HX8369_SET_EXTENSION_COMMAND, 0xff, 0x83, 0x69,
> +};
> +
> +static u8 hx8369_seq_display_related[] =3D {
> +	HX8369_SET_DISPLAY_MODE, 0x00, 0x2b, 0x03, 0x03, 0x70, 0x00,
> +	0xff, 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 0x00,	0x01,
> +};
> +
> +static u8 hx8369_seq_panel_waveform_cycle[] =3D {
> +	HX8369_SET_DISPLAY_WAVEFORM_CYC, 0x0a, 0x1d, 0x80, 0x06, 0x02,
> +};
> +
> +static u8 hx8369_seq_set_address_mode[] =3D {
> +	HX8357_SET_ADDRESS_MODE, 0x00,
> +};
> +
> +static u8 hx8369_seq_vcom[] =3D {
> +	HX8369_SET_VCOM, 0x3e, 0x3e,
> +};
> +
> +static u8 hx8369_seq_gip[] =3D {
> +	HX8369_SET_GIP, 0x00, 0x01, 0x03, 0x25, 0x01, 0x02, 0x28, 0x70,
> +	0x11, 0x13, 0x00, 0x00, 0x40, 0x26, 0x51, 0x37, 0x00, 0x00, 0x71,
> +	0x35, 0x60, 0x24, 0x07, 0x0f, 0x04, 0x04,
> +};
> +
> +static u8 hx8369_seq_power[] =3D {
> +	HX8369_SET_POWER, 0x01, 0x00, 0x34, 0x03, 0x00, 0x11, 0x11, 0x32,
> +	0x2f, 0x3f, 0x3f, 0x01, 0x3a, 0x01, 0xe6, 0xe6, 0xe6, 0xe6, 0xe6,
> +};
> +
> +static u8 hx8369_seq_gamma_curve_related[] =3D {
> +	HX8369_SET_GAMMA_CURVE_RELATED, 0x00, 0x0d, 0x19, 0x2f, 0x3b, 0x3d,
> +	0x2e, 0x4a, 0x08, 0x0e, 0x0f, 0x14, 0x16, 0x14, 0x14, 0x14, 0x1e,
> +	0x00, 0x0d, 0x19, 0x2f, 0x3b, 0x3d, 0x2e, 0x4a, 0x08, 0x0e, 0x0f,
> +	0x14, 0x16, 0x14, 0x14, 0x14, 0x1e,
> +};
> +
>  static int hx8357_spi_write_then_read(struct lcd_device *lcdev,
>  				u8 *txbuf, u16 txlen,
>  				u8 *rxbuf, u16 rxlen)
> @@ -242,6 +309,16 @@ static int hx8357_exit_standby(struct lcd_device *lc=
dev)
>  	return 0;
>  }
> =20
> +static void hx8357_lcd_reset(struct hx8357_data *lcd)
> +{
> +	gpio_set_value(lcd->reset, 1);
> +	usleep_range(10000, 12000);
> +	gpio_set_value(lcd->reset, 0);
> +	usleep_range(10000, 12000);
> +	gpio_set_value(lcd->reset, 1);
> +	msleep(120);
> +}

We should probably use the new reset framework here, especially
reset-gpio (I'm not sure what's the current status of the patch though).

> +
>  static int hx8357_lcd_init(struct lcd_device *lcdev)
>  {
>  	struct hx8357_data *lcd =3D lcd_get_data(lcdev);
> @@ -257,13 +334,7 @@ static int hx8357_lcd_init(struct lcd_device *lcdev)
>  		gpio_set_value_cansleep(lcd->im_pins[2], 1);
>  	}
> =20
> -	/* Reset the screen */
> -	gpio_set_value(lcd->reset, 1);
> -	usleep_range(10000, 12000);
> -	gpio_set_value(lcd->reset, 0);
> -	usleep_range(10000, 12000);
> -	gpio_set_value(lcd->reset, 1);
> -	msleep(120);
> +	hx8357_lcd_reset(lcd);

And that would become reset_device_reset

>  	ret =3D hx8357_spi_write_array(lcdev, hx8357_seq_power,
>  				ARRAY_SIZE(hx8357_seq_power));
> @@ -359,6 +430,97 @@ static int hx8357_lcd_init(struct lcd_device *lcdev)
>  	return 0;
>  }
> =20
> +static int hx8369_lcd_init(struct lcd_device *lcdev)
> +{
> +	struct hx8357_data *lcd =3D lcd_get_data(lcdev);
> +	int ret;
> +
> +	hx8357_lcd_reset(lcd);
> +
> +	ret =3D hx8357_spi_write_array(lcdev, hx8369_seq_extension_command,
> +				ARRAY_SIZE(hx8369_seq_extension_command));
> +	if (ret < 0)
> +		return ret;
> +	usleep_range(10000, 12000);
> +
> +	ret =3D hx8357_spi_write_array(lcdev, hx8369_seq_display_related,
> +				ARRAY_SIZE(hx8369_seq_display_related));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D hx8357_spi_write_array(lcdev, hx8369_seq_panel_waveform_cycle,
> +				ARRAY_SIZE(hx8369_seq_panel_waveform_cycle));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D hx8357_spi_write_array(lcdev, hx8369_seq_set_address_mode,
> +				ARRAY_SIZE(hx8369_seq_set_address_mode));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D hx8357_spi_write_array(lcdev, hx8369_seq_vcom,
> +				ARRAY_SIZE(hx8369_seq_vcom));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D hx8357_spi_write_array(lcdev, hx8369_seq_gip,
> +				ARRAY_SIZE(hx8369_seq_gip));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D hx8357_spi_write_array(lcdev, hx8369_seq_power,
> +				ARRAY_SIZE(hx8369_seq_power));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D hx8357_spi_write_byte(lcdev, HX8357_EXIT_SLEEP_MODE);
> +	if (ret < 0)
> +		return ret;
> +
> +	msleep(120);
> +
> +	ret =3D hx8357_spi_write_array(lcdev, hx8369_seq_gamma_curve_related,
> +				ARRAY_SIZE(hx8369_seq_gamma_curve_related));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D hx8357_spi_write_byte(lcdev, HX8357_EXIT_SLEEP_MODE);
> +	if (ret < 0)
> +		return ret;
> +	usleep_range(1000, 1200);
> +
> +	ret =3D hx8357_spi_write_array(lcdev, hx8369_seq_write_CABC_control,
> +				ARRAY_SIZE(hx8369_seq_write_CABC_control));
> +	if (ret < 0)
> +		return ret;
> +	usleep_range(10000, 12000);
> +
> +	ret =3D hx8357_spi_write_array(lcdev,
> +			hx8369_seq_write_CABC_control_setting,
> +			ARRAY_SIZE(hx8369_seq_write_CABC_control_setting));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D hx8357_spi_write_array(lcdev,
> +			hx8369_seq_write_CABC_min_brightness,
> +			ARRAY_SIZE(hx8369_seq_write_CABC_min_brightness));
> +	if (ret < 0)
> +		return ret;
> +	usleep_range(10000, 12000);
> +
> +	ret =3D hx8357_spi_write_array(lcdev, hx8369_seq_set_display_brightness,
> +				ARRAY_SIZE(hx8369_seq_set_display_brightness));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D hx8357_spi_write_byte(lcdev, HX8357_SET_DISPLAY_ON);
> +	if (ret < 0)
> +		return ret;
> +	msleep(100);
> +
> +	return 0;
> +}
> +
>  #define POWER_IS_ON(pwr)	((pwr) <=3D FB_BLANK_NORMAL)
> =20
>  static int hx8357_set_power(struct lcd_device *lcdev, int power)
> @@ -461,7 +623,11 @@ static int hx8357_probe(struct spi_device *spi)
>  	}
>  	spi_set_drvdata(spi, lcdev);
> =20
> -	ret =3D hx8357_lcd_init(lcdev);
> +	ret =3D -ENODEV;
> +	if (of_device_is_compatible(spi->dev.of_node, "himax,hx8357"))
> +		ret =3D hx8357_lcd_init(lcdev);
> +	else if (of_device_is_compatible(spi->dev.of_node, "himax,hx8369"))
> +		ret =3D hx8369_lcd_init(lcdev);
>  	if (ret) {
>  		dev_err(&spi->dev, "Couldn't initialize panel\n");
>  		goto init_error;
> @@ -486,6 +652,7 @@ static int hx8357_remove(struct spi_device *spi)
> =20
>  static const struct of_device_id hx8357_dt_ids[] =3D {
>  	{ .compatible =3D "himax,hx8357" },
> +	{ .compatible =3D "himax,hx8369" },

Maybe you could use the .data field and of_match_device here.

>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, hx8357_dt_ids);
> --=20
> 1.8.1.2
>=20

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRxKAwAAoJEBx+YmzsjxAg0kkQALGlQh+NI4exXbD01GK8KO7+
CYdzRPhJIYlRPB7vG1hUo+AfnOuqUqOdqbTA8QKdkpprPU+o7UsM9qzymrsVOGy6
HtnyynHoniu/XCDL5hUo2ZmLxsLBa4czfdMRq5wtxwaDcJtCtAv5WbOhvDUpyojc
OrLI6hA87AK9wAwvMTXbD/L0xIgGGDYJHtgK0xfrdTtDxUd2uwMjtoZ2QHfwSycl
kz6QB+kXtj1zJo83AlXLu/Apxgs5FW3GqGh5Q/21XZQzKLZGGpl8/0v81VqxRhGi
GtqosIAY6+rvSUZAb/UNXy3z34D2zfDgDoa1aD9eoeD75npCYFeBgY506r9Ybfog
jjV5Bx9aoQjb/cku+czoFxjvKbAP43kls/w9CW0tTqikCE4o/NeqE+Im7WOFkNaO
CSyXKm/I5tGqby1eK6PUdpeQtBN1h58mRNvAorYTSPupPnYXvLze/Jy1eL5Jqdrg
riXfQ3+oPeK3OaErY5V99y2cJT0ozTfQxBESWqSjkUbFiKOyM/ksbL9XjDsyQBmw
B1r/9khJrn9fUzPbTEiwDvRViKbDTBgrK07prLzUDaEM0BcA+575e0Pl/w0rNNXl
VEuWqyZyGI6eOuss1Pkxuc6h0HUSRB2dLeE2VRHWlBTSzIku+tiOtA395sZ5UiYW
Bl2f53V3h6I3QzzlRNyR
=h7nF
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
