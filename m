Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaKGSLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:11:39 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:41979 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaKGSLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:11:37 -0500
Date: Fri, 7 Nov 2014 14:11:26 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v3] thermal: ti-soc-thermal: Switch to using managed
 resources
Message-ID: <20141107181123.GA23920@developer>
References: <1412920932-7419-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <1412920932-7419-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Pramod,

On Fri, Oct 10, 2014 at 11:32:12AM +0530, Pramod Gurav wrote:
> This change switches to managed resource APIs to allocated resources
> such as irq, clock. Hence does away with release statements of the
> same resorces in error lables and remove function.
>=20
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>=20
> ---
> Changes since v2:
> - fix failure path of clk_get_rate by returning error.
> Change since v1:
> - Passing struct device to devm_clk_get was missing. Fix the same in v2.
>=20

Thanks for updating your patch. Apologize for my late answer.

>  drivers/thermal/ti-soc-thermal/ti-bandgap.c |   58 ++++++++-------------=
------
>  1 file changed, 16 insertions(+), 42 deletions(-)
>=20
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/therma=
l/ti-soc-thermal/ti-bandgap.c
> index 634b6ce..22ad68e 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> @@ -1060,7 +1060,7 @@ static int ti_bandgap_tshut_init(struct ti_bandgap =
*bgp,
>  	int status;
> =20
>  	/* Request for gpio_86 line */
> -	status =3D gpio_request(gpio_nr, "tshut");
> +	status =3D devm_gpio_request(&pdev->dev, gpio_nr, "tshut");
>  	if (status < 0) {
>  		dev_err(bgp->dev, "Could not request for TSHUT GPIO:%i\n", 86);
>  		return status;
> @@ -1071,14 +1071,13 @@ static int ti_bandgap_tshut_init(struct ti_bandga=
p *bgp,
>  		return status;
>  	}
> =20
> -	status =3D request_irq(gpio_to_irq(gpio_nr), ti_bandgap_tshut_irq_handl=
er,
> -			     IRQF_TRIGGER_RISING, "tshut", NULL);
> -	if (status) {
> -		gpio_free(gpio_nr);
> +	status =3D devm_request_irq(&pdev->dev, gpio_to_irq(gpio_nr),
> +				  ti_bandgap_tshut_irq_handler,
> +				  IRQF_TRIGGER_RISING, "tshut", NULL);
> +	if (status)
>  		dev_err(bgp->dev, "request irq failed for TSHUT");
> -	}
> =20
> -	return 0;
> +	return status;
>  }
> =20
>  /**
> @@ -1104,16 +1103,14 @@ static int ti_bandgap_talert_init(struct ti_bandg=
ap *bgp,
>  		dev_err(&pdev->dev, "get_irq failed\n");
>  		return bgp->irq;
>  	}
> -	ret =3D request_threaded_irq(bgp->irq, NULL,
> +	ret =3D devm_request_threaded_irq(&pdev->dev, bgp->irq, NULL,
>  				   ti_bandgap_talert_irq_handler,
>  				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
>  				   "talert", bgp);
> -	if (ret) {
> +	if (ret)
>  		dev_err(&pdev->dev, "Request threaded irq failed.\n");
> -		return ret;
> -	}
> =20
> -	return 0;
> +	return ret;
>  }
> =20
>  static const struct of_device_id of_ti_bandgap_match[];
> @@ -1212,21 +1209,17 @@ int ti_bandgap_probe(struct platform_device *pdev)
>  		}
>  	}
> =20
> -	bgp->fclock =3D clk_get(NULL, bgp->conf->fclock_name);
> -	ret =3D IS_ERR(bgp->fclock);
> -	if (ret) {
> +	bgp->fclock =3D devm_clk_get(&pdev->dev, bgp->conf->fclock_name);
> +	if (IS_ERR(bgp->fclock)) {
>  		dev_err(&pdev->dev, "failed to request fclock reference\n");
> -		ret =3D PTR_ERR(bgp->fclock);
> -		goto free_irqs;
> +		return PTR_ERR(bgp->fclock);
>  	}
> =20
> -	bgp->div_clk =3D clk_get(NULL,  bgp->conf->div_ck_name);
> -	ret =3D IS_ERR(bgp->div_clk);
> -	if (ret) {
> +	bgp->div_clk =3D devm_clk_get(&pdev->dev, bgp->conf->div_ck_name);
> +	if (IS_ERR(bgp->div_clk)) {
>  		dev_err(&pdev->dev,
>  			"failed to request div_ts_ck clock ref\n");
> -		ret =3D PTR_ERR(bgp->div_clk);
> -		goto free_irqs;
> +		return PTR_ERR(bgp->div_clk);
>  	}
> =20

This part is a little tricky. What board have you tried this patch? Are
you sure that now passing the struct device * you are really receiving
the clk struct?

The thing is, from top of my head, in order to pass the struct device *
you need also to change the OMAP clk data structures under arch/arm/.
And remember, for all the supported chips in this driver.

Have you check that?

Please, let me know how you tested this patch.

Cheers,

Eduardo Valentin

>  	for (i =3D 0; i < bgp->conf->sensor_count; i++) {
> @@ -1249,9 +1242,8 @@ int ti_bandgap_probe(struct platform_device *pdev)
>  				  bgp->conf->sensors[0].ts_data->max_freq);
>  	if (clk_rate < bgp->conf->sensors[0].ts_data->min_freq ||
>  	    clk_rate <=3D 0) {
> -		ret =3D -ENODEV;
>  		dev_err(&pdev->dev, "wrong clock rate (%d)\n", clk_rate);
> -		goto put_clks;
> +		return -ENODEV;
>  	}
> =20
>  	ret =3D clk_set_rate(bgp->div_clk, clk_rate);
> @@ -1357,14 +1349,6 @@ remove_sensors:
>  disable_clk:
>  	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
>  		clk_disable_unprepare(bgp->fclock);
> -put_clks:
> -	clk_put(bgp->fclock);
> -	clk_put(bgp->div_clk);
> -free_irqs:
> -	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
> -		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
> -		gpio_free(bgp->tshut_gpio);
> -	}
> =20
>  	return ret;
>  }
> @@ -1388,16 +1372,6 @@ int ti_bandgap_remove(struct platform_device *pdev)
> =20
>  	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
>  		clk_disable_unprepare(bgp->fclock);
> -	clk_put(bgp->fclock);
> -	clk_put(bgp->div_clk);
> -
> -	if (TI_BANDGAP_HAS(bgp, TALERT))
> -		free_irq(bgp->irq, bgp);
> -
> -	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
> -		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
> -		gpio_free(bgp->tshut_gpio);
> -	}
> =20
>  	return 0;
>  }
> --=20
> 1.7.9.5
>=20

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXQtDAAoJEMLUO4d9pOJW+9kH/3ayHpExtdxnBjAK+HZqRQUT
nALXFJZjG103NYx9Se7H3xmiTd661O8NUgg1uNP5vQ/XIfSnCM+yhFpp1iKQkMtM
fnLd+LJh/s+YzK85due4TF6wOt0kPp6vjsxMqz8Fyrb6zScDgjr4nTaNTVKi3tmX
Y2LGdetH3L0MmlzT+3A4OSnkz9FjfSt2NC87WIf7LnE7HnbuAWvuxThFQOUaBths
Fm5xiJD15mp37ZaF+hv3X3TqDuxir8HZdk1Gg+eLdT4Z+28KL+RM2ay7HTRGMv6u
QMSSsT2DpA6aYOHnp9DWtRmQHB2Ctmzx3iM9CJn7n4u+BDwFtZOM8Nb8Z6yn3rs=
=jS3u
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
