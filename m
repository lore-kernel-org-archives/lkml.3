Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaGaL4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:56:53 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36931 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaGaL4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:56:51 -0400
Date: Thu, 31 Jul 2014 13:56:45 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] pwm-backlight: Allow backlight to remain disabled on boot
Message-ID: <20140731115644.GB12627@ulmo>
References: <1406806970-12561-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <1406806970-12561-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Cc'ing Ajay (who raised this on a different thread recently), therefore
quoting all of the original email.

Thierry

On Thu, Jul 31, 2014 at 01:42:50PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> The default for backlight devices is to be enabled immediately when
> registering with the backlight core. This can be useful for setups that
> use a simple framebuffer device and where the backlight cannot otherwise
> be hooked up to the panel.
>=20
> However, when dealing with more complex setups, such as those of recent
> ARM SoCs, this can be problematic. Since the backlight is usually setup
> separately from the display controller, the probe order is not usually
> deterministic. That can lead to situations where the backlight will be
> powered up and the panel will show an uninitialized framebuffer.
>=20
> Furthermore, subsystems such as DRM have advanced functionality to set
> the power mode of a panel. In order to allow such setups to power up the
> panel at exactly the right moment, a way is needed to prevent the
> backlight core from powering the backlight up automatically when it is
> registered.
>=20
> This commit introduces a new boot_off field in the platform data (and
> also implements getting the same information from device tree). When set
> the initial backlight power mode will be set to "off".
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> I've been meaning to send this for a while but was always holding back
> because of the indoctrination that this type of configuration shouldn't
> be part of device tree. However this issue was recently raised again in
> the context of power up sequences for display panels. As described above
> the issue is that panel datasheets recommend that the backlight attached
> to a panel be turned on at the very last step to avoid visual glitches
> during the panel's power up sequence. With the current implementation it
> is typical for the backlight to be probed before the display panel. That
> has, in many cases, the side-effect of enabling the backlight, therefore
> making the screen content visible before it's actually initialized.
>=20
> Some panels come up with random garbage when uninitialized, others show
> all white. With some luck the panel will be all black and users won't
> really notice.
>=20
> This patch is an attempt to enable boards to override the default of
> turning on the backlight for the pwm-backlight driver. I'm not sure if
> there was a specific reason to turn on the backlight by default when
> this driver was initially written, but the fact is that since it has
> pretty much always been like this we can't really go and change the
> default, otherwise a lot of people may end up with no backlight and no
> clue as to how to enable it. So the only reasonable thing we can do is
> to keep the old behaviour and give new boards a way to override it if
> they know that some other part of the stack will enable it at the right
> moment.
>=20
>  .../devicetree/bindings/video/backlight/pwm-backlight.txt         | 1 +
>  drivers/video/backlight/pwm_bl.c                                  | 8 ++=
++++++
>  include/linux/pwm_backlight.h                                     | 2 ++
>  3 files changed, 11 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backli=
ght.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.t=
xt
> index 764db86d441a..65e001a1733d 100644
> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> @@ -17,6 +17,7 @@ Optional properties:
>                 "pwms" property (see PWM binding[0])
>    - enable-gpios: contains a single GPIO specifier for the GPIO which en=
ables
>                    and disables the backlight (see GPIO binding[1])
> +  - backlight-boot-off: keep the backlight disabled on boot
> =20
>  [0]: Documentation/devicetree/bindings/pwm/pwm.txt
>  [1]: Documentation/devicetree/bindings/gpio/gpio.txt
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
> index d7a3d13e72ec..62adfc9d37a7 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -173,6 +173,8 @@ static int pwm_backlight_parse_dt(struct device *dev,
>  		data->max_brightness--;
>  	}
> =20
> +	data->boot_off =3D of_property_read_bool(node, "backlight-boot-off");
> +
>  	return 0;
>  }
> =20
> @@ -317,6 +319,12 @@ static int pwm_backlight_probe(struct platform_devic=
e *pdev)
>  	}
> =20
>  	bl->props.brightness =3D data->dft_brightness;
> +
> +	if (data->boot_off)
> +		bl->props.power =3D FB_BLANK_POWERDOWN;
> +	else
> +		bl->props.power =3D FB_BLANK_UNBLANK;
> +
>  	backlight_update_status(bl);
> =20
>  	platform_set_drvdata(pdev, bl);
> diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
> index efdd9227a49c..1fc14989da4a 100644
> --- a/include/linux/pwm_backlight.h
> +++ b/include/linux/pwm_backlight.h
> @@ -15,6 +15,8 @@ struct platform_pwm_backlight_data {
>  	unsigned int *levels;
>  	/* TODO remove once all users are switched to gpiod_* API */
>  	int enable_gpio;
> +	bool boot_off;
> +
>  	int (*init)(struct device *dev);
>  	int (*notify)(struct device *dev, int brightness);
>  	void (*notify_after)(struct device *dev, int brightness);
> --=20
> 2.0.3
>=20

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2i78AAoJEN0jrNd/PrOhMIkQAIIV8vrSJSNDQKLZEGVyLLai
VFdhQgVBLvZmlpD+SFcQAvBclxARKtRmNa2DfSnpZO+ggiQvHKKulkeorKFHq3/x
8ro1BzID5CtaKSpfD4PqhLaFIZ5r54WT4ho8I7XcoMINVPNQnTAomlFGVW+DFF2M
CpRiUhptGfjyfXw0ftdFcOuUKt56DIxlVyK7Kvw8jh0RGAB0IMFBpOtsYUBiit1F
z7IZmeayiijAjSMBEOhlUQ7AUqSyhnirvvZsqVCACxjfM83rmemW8RDxgNfY3GrS
hiB9wde7MDlLXkcb4DPZyEvzgb0L1fhII/IrjUAO3yz02dILnAJXIVRbMecOPNI9
UDw+HL9INwZO//RoF4X1N7ZK9BAC7Sp0r5tYIyqX4xC+juvPEcj7YPkYhiCotbrj
WQ9fkh+IZF5mF+wTbFACFpOvLndzTZlaAhpfR/PC2ub8PpHroxwhL5jPOeXt+s0J
nmTqI7TStDWgnJvWkid/AU0oBLTRkIyHHAgPxF7ooOvUYiZ03MHqAlKxuUY9qHgm
T1+CHuNMo36Q7PyXlWeEDSDl2IOa1E9pfzxO8DXVDDfEjcDvkNOsO3FkVlPa9iTz
i31CR2Ow16XIS3Xum96gxOzuNlx3CniWKHicHm7v6GcZYPRF6vA3yL53sQhVN1sP
c/3yQXBA9s8BF88n2gak
=/I5A
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
