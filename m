Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaIVFBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 01:01:35 -0400
Received: from ozlabs.org ([103.22.144.67]:40608 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaIVFBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 01:01:34 -0400
Date: Mon, 22 Sep 2014 15:01:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20140922150124.4f24bb6f@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/xHH3Y1/9EiunJAbu.sfa57V"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xHH3Y1/9EiunJAbu.sfa57V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/iio/accel/bma180.c between commit 0668a4e4d297 ("iio: accel:
bma180: Fix indio_dev->trig assignment") from Linus' tree and commit
16ed8692fa48 ("iio:bma180: Enable use of device without IRQ") from the
staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/iio/accel/bma180.c
index 19100fddd2ed,6ef19641457c..000000000000
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@@ -553,29 -729,31 +729,31 @@@ static int bma180_probe(struct i2c_clie
  	indio_dev->modes =3D INDIO_DIRECT_MODE;
  	indio_dev->info =3D &bma180_info;
 =20
- 	trig =3D iio_trigger_alloc("%s-dev%d", indio_dev->name, indio_dev->id);
- 	if (!trig) {
- 		ret =3D -ENOMEM;
- 		goto err_chip_disable;
- 	}
+ 	if (client->irq > 0) {
+ 		data->trig =3D iio_trigger_alloc("%s-dev%d", indio_dev->name,
+ 			indio_dev->id);
+ 		if (!data->trig) {
+ 			ret =3D -ENOMEM;
+ 			goto err_chip_disable;
+ 		}
 =20
- 	ret =3D devm_request_irq(&client->dev, client->irq,
- 			iio_trigger_generic_data_rdy_poll,
- 			IRQF_TRIGGER_RISING, BMA180_IRQ_NAME, trig);
- 	if (ret) {
- 		dev_err(&client->dev, "unable to request IRQ\n");
- 		goto err_trigger_free;
- 	}
+ 		ret =3D devm_request_irq(&client->dev, client->irq,
+ 			iio_trigger_generic_data_rdy_poll, IRQF_TRIGGER_RISING,
+ 			"bma180_event", data->trig);
+ 		if (ret) {
+ 			dev_err(&client->dev, "unable to request IRQ\n");
+ 			goto err_trigger_free;
+ 		}
 =20
- 	trig->dev.parent =3D &client->dev;
- 	trig->ops =3D &bma180_trigger_ops;
- 	iio_trigger_set_drvdata(trig, indio_dev);
- 	data->trig =3D trig;
- 	indio_dev->trig =3D iio_trigger_get(trig);
+ 		data->trig->dev.parent =3D &client->dev;
+ 		data->trig->ops =3D &bma180_trigger_ops;
+ 		iio_trigger_set_drvdata(data->trig, indio_dev);
 -		indio_dev->trig =3D data->trig;
++		indio_dev->trig =3D iio_trigger_get(data->trig);
 =20
- 	ret =3D iio_trigger_register(trig);
- 	if (ret)
- 		goto err_trigger_free;
+ 		ret =3D iio_trigger_register(data->trig);
+ 		if (ret)
+ 			goto err_trigger_free;
+ 	}
 =20
  	ret =3D iio_triggered_buffer_setup(indio_dev, NULL,
  			bma180_trigger_handler, NULL);

--Sig_/xHH3Y1/9EiunJAbu.sfa57V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUH60pAAoJEMDTa8Ir7ZwVLWEP/0p27ELO0Ss4wGBw9Fx/8wc2
3PPwjpOWuN4NYWzw6u4kChS595SVkNl+dsrsogQIqQJNkPyqbfdDy4peA7TOoOtx
+m+cJIFYF8y0NUUUG8pgAXBi6ap5kps4JjGU2Yutfd+hIEUiuLiPTHEd+X4UfJUr
LDp7ft5QOiN8Zt6CBJflDSlEWEVGspnNbWUHwy1C8GyKDVJUGsoEUCXy98le65cL
U+S/qZanUUcyDAaHj2OY2g3+owMqwfIR38x898PYBSzUTyvu8z/nn4o/HOBCVGR5
+7NeT1ZptNbsMnQUAuZIhC83MIVbp5uxLtjec2oXsxl+NJ1fp2FU0oZpFtFiqCey
waiRjQtwSQLAUlqdHDyONHJF6c5+d8dKXWsdWPtp1lwFltAmAhmcDPBaIxc+EVY/
FoMEqRQXWL04cWP+G43ilJn823lKRj3M51HYHzTdyJQzv7YQp1/6uMblVW67CTvL
AFcmsHJoO3HKhJxJ6nHQK3I4xwuGjh4FxgGCQStI1nOQNiSs1qa0LZe18J0LS0Sr
Q9liu3rfFZ9cneS3hdmJj2MHjij1VsbF6nEtLMjaw9d7QAamdxUxtKXRBwe1LbNC
FGR89khEx8GravD5lGpHY1JsUxvFlKHpG6aKkt6o2IN4mUh//Ko1D8c6y2SmHBUP
J01DHN4uL9MSTZgutwSx
=y6y4
-----END PGP SIGNATURE-----

--Sig_/xHH3Y1/9EiunJAbu.sfa57V--
