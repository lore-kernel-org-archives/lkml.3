Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbaHZLTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:19:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60277 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbaHZLTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:19:30 -0400
Message-ID: <53FC6D36.8000102@ti.com>
Date: Tue, 26 Aug 2014 14:19:18 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH] msm: msm_fb: Add remove function for platform driver
 for clean unloading
References: <1407163433-13528-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1407163433-13528-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="CekNernRPhHRFJJ8d4Sn2Ie3F4Lag1TaD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CekNernRPhHRFJJ8d4Sn2Ie3F4Lag1TaD
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

On 04/08/14 17:43, Pramod Gurav wrote:
> This adds a  remove function to platform driver structure so that
> resources are released when driver is unloaded.
>=20
> Moved kzalloc to use managed resource and adds a return check if failed=
=2E

Please split this patch into two. You change two unrelated things here,
the unloading and the kzalloc part.

> CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
> CC: Stephen Boyd <sboyd@codeaurora.org>
> CC: Jingoo Han <jg1.han@samsung.com>
> CC: Rob Clark <robdclark@gmail.com>
>=20
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/video/fbdev/msm/msm_fb.c |   28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/msm/msm_fb.c b/drivers/video/fbdev/msm=
/msm_fb.c
> index 1374803..ac277e2 100644
> --- a/drivers/video/fbdev/msm/msm_fb.c
> +++ b/drivers/video/fbdev/msm/msm_fb.c
> @@ -553,6 +553,7 @@ static int msmfb_probe(struct platform_device *pdev=
)
>  	fb =3D framebuffer_alloc(sizeof(struct msmfb_info), &pdev->dev);
>  	if (!fb)
>  		return -ENOMEM;
> +
>  	msmfb =3D fb->par;
>  	msmfb->fb =3D fb;
>  	msmfb->panel =3D panel;
> @@ -569,8 +570,13 @@ static int msmfb_probe(struct platform_device *pde=
v)
>  	mutex_init(&msmfb->panel_init_lock);
>  	init_waitqueue_head(&msmfb->frame_wq);
>  	INIT_WORK(&msmfb->resume_work, power_on_panel);
> -	msmfb->black =3D kzalloc(msmfb->fb->var.bits_per_pixel*msmfb->xres,
> -			       GFP_KERNEL);
> +	msmfb->black =3D devm_kzalloc(&pdev->dev,
> +				    msmfb->fb->var.bits_per_pixel*msmfb->xres,
> +				    GFP_KERNEL);
> +	if (!msmfb->black) {
> +		ret =3D -ENOMEM;
> +		goto error_register_framebuffer;
> +	}
> =20
>  	printk(KERN_INFO "msmfb_probe() installing %d x %d panel\n",
>  	       msmfb->xres, msmfb->yres);
> @@ -589,6 +595,8 @@ static int msmfb_probe(struct platform_device *pdev=
)
> =20
>  	msmfb->sleeping =3D WAKING;
> =20
> +	platform_set_drvdata(pdev, msmfb);
> +
>  	return 0;
> =20
>  error_register_framebuffer:
> @@ -598,13 +606,27 @@ error_setup_fbmem:
>  	return ret;
>  }
> =20
> +static int msmfb_remove(struct platform_device *pdev)
> +{
> +	struct msmfb_info *msmfb =3D NULL;

No need to initialize to NULL, msmfb is initialized always below.

> +
> +	msmfb =3D platform_get_drvdata(pdev);
> +	if (msmfb) {

Can msmfb ever be NULL here? If I'm not mistaken, remove is only called
if the probe had succeeded. And if probe had succeeded, the drvdata is
always set to a proper pointer to msmfb_info.

 Tomi



--CekNernRPhHRFJJ8d4Sn2Ie3F4Lag1TaD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/G02AAoJEPo9qoy8lh71sgIP/RVtP4PYUlohr2ve74Mwy/JE
6WrjB0q883nFLJaapssK9RI8AGWA4WdPqXg1lQuI9Y/A3uuNKyIVt4Gf5u9zAz4U
6fGO0Hicrn2tyEyborZxPEMI8U9PinSY9lV9TF69+dKmY5/h+Y7wZQWMJvtmYRLU
JAptwsnzfj5UbqsStfDZwq4vKYN2kWOvskaMaSLc5hyHeE7GYC25e1jTDCa1Rg+2
b0NfbLJ8JnJZk0H6oKXwAjGVuulz9E0nfiYL/3Wi5BPJ7izBxLP/5SmkYCrlvztg
uK7y5pQTKEEkydjnORRFBjPUpEtQyf9/lmRg3OKB3SYurlh0m+oIlGwdXkhIlyju
RI8PHq5w7Jdx/xYBMsWY/z+yHCY87DJXmbkb8uCm/omDJxYwlZPXBMdwJ0eUR676
63eMdKqSIpMjUoTJc0hK8qlRu6yNRbhlCtzSM/RavRQHA3dmbmiCK9QAcnwZGDP+
5K1A5GRMT2OBQCrXowcetbH8aMu/x7Lvt/A15/p5++Ek+lX9Q9k7qsGD4iWDKXan
GaZ69Dekfy7GvJJnH2Pee2oiIyOYBotqCvdBJ0BTg18uTEqQSesIJELgHXCbCreH
WB0c/B72zVF6puPoISjB6WKMK8YDe4Xn4IXbwasdJQPT1turKJkI2ocorJ24zHwt
BQRFrqmKws5Zn9CrbgXC
=QkVU
-----END PGP SIGNATURE-----

--CekNernRPhHRFJJ8d4Sn2Ie3F4Lag1TaD--
