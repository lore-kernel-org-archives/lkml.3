Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3FNN5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:57:30 -0400
Received: from sauhun.de ([89.238.76.85]:50344 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3FNN50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:57:26 -0400
Date: Fri, 14 Jun 2013 15:58:59 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] i2c: vt8500: Add support for I2C bus on Wondermedia
 SoCs
Message-ID: <20130614135857.GA2929@katana>
References: <1371023785-3132-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <1371023785-3132-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2013 at 07:56:25PM +1200, Tony Prisk wrote:
> This patch adds support for the I2C bus controllers found on Wondermedia
> 8xxx-series SoCs. Only master-mode is supported.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---

Please describe here what changed since the last version. It's a lot
easier and faster to review then.

> +static int wmt_i2c_xfer(struct i2c_adapter *adap,
> +			struct i2c_msg msgs[],
> +			int num)
> +{
> +	struct i2c_msg *pmsg;
> +	int i, is_last, no_start;
> +	int ret =3D 0;
> +
> +	for (i =3D 0; ret >=3D 0 && i < num; i++) {
> +		is_last =3D ((i + 1) =3D=3D num);
> +		no_start =3D (i !=3D 0);

(i !=3D 0) is a restart condition (start instead of stop)...

> +
> +		pmsg =3D &msgs[i];
> +		if (pmsg->flags & I2C_M_NOSTART)
> +			no_start =3D 1;

=2E..and this is a no_start (concatenating messages). I do have the
impression you are mixing those two?

> +		if (pmsg->flags & I2C_M_RD)
> +			ret =3D wmt_i2c_read(adap, pmsg, no_start, is_last);
> +		else
> +			ret =3D wmt_i2c_write(adap, pmsg, no_start, is_last);
> +	}
> +
> +	return (ret < 0) ? ret : i;
> +}
> +	adap =3D &i2c_dev->adapter;
> +	i2c_set_adapdata(adap, i2c_dev);
> +	strlcpy(adap->name, "WMT I2C adapter", sizeof(adap->name));
> +	adap->owner =3D THIS_MODULE;
> +	adap->algo =3D &wmt_i2c_algo;
> +	adap->dev.parent =3D &pdev->dev;
> +	adap->dev.of_node =3D pdev->dev.of_node;
> +	adap->nr =3D of_alias_get_id(pdev->dev.of_node, "i2c");

Drop this line...

> +
> +	init_completion(&i2c_dev->complete);
> +
> +	err =3D wmt_i2c_reset_hardware(i2c_dev);
> +	if (err) {
> +		dev_err(&pdev->dev, "error initializing hardware\n");
> +		return err;
> +	}
> +
> +	err =3D i2c_add_numbered_adapter(adap);

=2E.. and use i2c_add_adpter here. Since recently the core checks the
ofnode for an alias. Sorry, forgot to mention this last time.

> +	if (err) {
> +		dev_err(&pdev->dev, "failed to add adapter\n");
> +		return err;
> +	}
> +
> +	platform_set_drvdata(pdev, i2c_dev);
> +
> +	of_i2c_register_devices(adap);
> +
> +	return 0;
> +}
> +
> +module_platform_driver(wmt_i2c_driver);
> +
> +MODULE_DESCRIPTION("Wondermedia I2C master-mode bus adapter");
> +MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
> +MODULE_LICENSE("GPL and additional rights");

I see no additional rights mentioned. According to the header "GPL"
should do, but you know the original sources better.

> +MODULE_DEVICE_TABLE(of, wmt_i2c_dt_ids);
> --=20
> 1.7.9.5
>=20

Regards,

   Wolfram


--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRuyGhAAoJEBQN5MwUoCm26LQP/AsVG+oJWCMo+gKx8QDemxWV
hysBgpjZ2Io2o3sekpMfQW7Z6fjapzxaY4fXO8TCib6XjPsOlRgZoqaQ2hAIVDQS
eLSrjUSzqWYupUbqFyYfOlMK9G+1vU9EZmIFAno4plsSkZKf2ICEkUNpXa3wSYcC
6mDCpbyVcPAICzbUgILPrjeVrNxEoriUl6pxfK454/cIwnFl/Cu7o0DpHnGzc1sQ
1G2gdQyAO7FXbNazRM7w8mTwxwgFdD76PU+w7/tt+vt9jNVfistycHHVx4G+h9th
4/Z92KFfP4zVZrQIU5PneYcRyLQgFzMu9Y8md0PYjVslX3dOlXpmlPP/f8hc8m35
MuF6jRlfKMDHjlgm3oOaBK/nhN9cxXa7o2LY22kjKQshJ7Ah+tp2O/xUSvMK9Age
i7TRh5BKXx+wn7hlfxagIMiWudF5JKQHFy/yLLB3TzF8qI1F92CE8M9YIqPT3glK
BOGLo2Z/2bTgrZ+AZqCLYeBk82ytypVrQOy7MD627OzPIGFxULcXobBCGv8HGpJv
LwbZNdXyiLg5GyaH4CbSqDN9C9YiMpM903dxakiFbV52d2AxJIzYCcSQzfwbbvHB
QUkXDjig6OY9I+qIpePxXMU9dl3e9cLkqP44ITJ0FYDuW8QboLwBm6dt9Pc6ym2N
tJ/QLfZwyf60UaX6InzM
=w/qj
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
