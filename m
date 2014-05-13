Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421AbaEMKFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:05:38 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49112 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631AbaEMKFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:05:37 -0400
Date: Tue, 13 May 2014 12:03:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: using devm functions for timberdale gpio memory
 allocation This eases memory allocation and provides appropriate logging
Message-ID: <20140513100334.GA27345@ulmo>
References: <1399944102-9089-1-git-send-email-berthe.ab@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1399944102-9089-1-git-send-email-berthe.ab@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 03:21:42AM +0200, abdoulaye berthe wrote:
[...]
> diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdal=
e.c
[...]
>  	iomem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!iomem) {
> -		err =3D -EINVAL;
> -		goto err_mem;
> +		dev_err(dev, "Unable to get resource\n");
> +		return -EINVAL;
>  	}
[...]
> -	if (!request_mem_region(iomem->start, resource_size(iomem),
> -		DRIVER_NAME)) {
> -		err =3D -EBUSY;
> -		goto err_request;
> +	if (!devm_request_mem_region(dev, iomem->start, resource_size(iomem),
> +				     DRIVER_NAME)) {
> +		dev_err(dev, "Region already claimed\n");
> +		return -EBUSY;
>  	}
> =20
> -	tgpio->membase =3D ioremap(iomem->start, resource_size(iomem));
> +	tgpio->membase =3D devm_ioremap(dev, iomem->start, resource_size(iomem)=
);
>  	if (!tgpio->membase) {
> -		err =3D -ENOMEM;
> -		goto err_ioremap;
> +		dev_err(dev, "Cannot ioremap\n");
> +		return -ENOMEM;
>  	}

The above could be further simplified to:

	iomem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
	tgpio->membase =3D devm_ioremap_resource(&pdev->dev, iomem);
	if (IS_ERR(tgpio->membase))
		return PTR_ERR(tgpio->membase);

Where devm_ioremap_resource() already provides error messages as
appropriate.

Thierry

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTce32AAoJEN0jrNd/PrOhHcYQALXRFve6mBvV2XxhqjRlXW+t
v75uejBBzLH/uo9O/g1WpVd0NBOo3Ll+3BLZ2rH7e2eLDgbBaW3vKrvQFCenAVY+
UjO3mvXQUOvDhNPRBiCNrjCoYyI48aTQoPvwLlutaUNtx2JcA5jd96/V80OhSqPh
C5he93sZP5+oMLb/aMLrGb4zGwxIRl7lpiYZESNw2AwyiQQhcAFApvWoJ0t2sJVF
avz21DBfXd1ohfYP7HzS3lvLV7Ep+hZUBw6Z7E9f7R14d7ijI53d7KTvVUCISZHT
7877AwMQaZ6K0YV86bnScJVlQh2rT/oQXgjFyV6F1FqJc35IEaNVUDi4FE5MKq4e
GB7jNvucPNrfPPpMbGSYBCcJibcZh61ABYo5Jqu2PjxTA++w/GsY7nehywIRluAi
hSxRySQcffmTBbh/U614wIgdOdJLZlGRdrAD3s0eHduCm7QnsbPfeVyAZfe68guI
epPnyxC6sheXHKWBsNyKUT2eDYw42VgkOZ7Oj3X6SDB1KBDG+kHvVzFXZvNq6PCw
54F60Vqjir6K8mr9QBlQD0xIPq5KUBetY0pt4BDiBty8DwZFErYf0VPyMe8HsmWB
M1mJoTG4c3dk/e8XE6vRjswRMYdqLmViRl9xXoLEJhGXsJj7JuXZpR6qM4zj1CB0
vPKjKizVe+uC6j+zFrnn
=RGuE
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
