Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab3BYIRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 03:17:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37779 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab3BYIRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 03:17:34 -0500
Date: Mon, 25 Feb 2013 10:17:23 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <kishon@ti.com>
Subject: Re: [PATCH RFC] usb: dwc3: Set GCTL.PrtCapDir based on selected mode.
Message-ID: <20130225081723.GD25749@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360071958-20797-1-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fOHHtNG4YXGJ0yqR"
Content-Disposition: inline
In-Reply-To: <1360071958-20797-1-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fOHHtNG4YXGJ0yqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Feb 05, 2013 at 07:15:58PM +0530, Vivek Gautam wrote:
> Now that machines may select the mode of working of DWC3,
> we can set the Port capability direction based on selected mode.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/dwc3/core.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 177f4c6..f4c47f7 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -479,7 +479,6 @@ static int dwc3_probe(struct platform_device *pdev)
> =20
>  	switch (mode) {
>  	case DWC3_MODE_DEVICE:
> -		dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
>  		ret =3D dwc3_gadget_init(dwc);
>  		if (ret) {
>  			dev_err(dev, "failed to initialize gadget\n");
> @@ -487,7 +486,6 @@ static int dwc3_probe(struct platform_device *pdev)
>  		}
>  		break;
>  	case DWC3_MODE_HOST:
> -		dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_HOST);
>  		ret =3D dwc3_host_init(dwc);
>  		if (ret) {
>  			dev_err(dev, "failed to initialize host\n");
> @@ -495,7 +493,6 @@ static int dwc3_probe(struct platform_device *pdev)
>  		}
>  		break;
>  	case DWC3_MODE_DRD:
> -		dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_OTG);
>  		ret =3D dwc3_host_init(dwc);
>  		if (ret) {
>  			dev_err(dev, "failed to initialize host\n");
> @@ -514,6 +511,14 @@ static int dwc3_probe(struct platform_device *pdev)
>  	}
>  	dwc->mode =3D mode;
> =20
> +#if IS_ENABLED(CONFIG_USB_DWC3_HOST)
> +	dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_HOST);
> +#elif IS_ENABLED(CONFIG_USB_DWC3_GADGET)
> +	dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
> +#else
> +	dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_OTG);
> +#endif

you can actually use:

if (IS_ENABLED(CONFIG_USB_DWC3_HOST))
	dwc3_set_mode(dwc...
else if (IS_ENABLED( ...
	...
else
	...

instead of pre-processor conditionals. In fact, I have recently written
a patch converting #if IS_ENABLED() to if (IS_ENABLED()) but I haven't
posted yet:

commit 42dbbbc272bc941ec2b0cac51342609e61e13a01
Author: Felipe Balbi <balbi@ti.com>
Date:   Fri Feb 22 16:24:49 2013 +0200

    usb: dwc3: debugfs: improve debugfs file creation
   =20
    when commit 388e5c5 (usb: dwc3: remove dwc3
    dependency on host AND gadget.) changed the
    way debugfs files are created, it failed to
    note that 'mode' is necessary in Dual Role
    mode only while 'testmode' and 'link_state'
    are valid in Dual Role and Peripheral-only
    builds. Fix this while also converting pre-
    processor conditional to C conditionals.
   =20
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index a1bac9a..8b23d045 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -667,28 +667,31 @@ int dwc3_debugfs_init(struct dwc3 *dwc)
 		goto err1;
 	}
=20
-#if IS_ENABLED(CONFIG_USB_DWC3_GADGET)
-	file =3D debugfs_create_file("mode", S_IRUGO | S_IWUSR, root,
-			dwc, &dwc3_mode_fops);
-	if (!file) {
-		ret =3D -ENOMEM;
-		goto err1;
+	if (IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE)) {
+		file =3D debugfs_create_file("mode", S_IRUGO | S_IWUSR, root,
+				dwc, &dwc3_mode_fops);
+		if (!file) {
+			ret =3D -ENOMEM;
+			goto err1;
+		}
 	}
=20
-	file =3D debugfs_create_file("testmode", S_IRUGO | S_IWUSR, root,
-			dwc, &dwc3_testmode_fops);
-	if (!file) {
-		ret =3D -ENOMEM;
-		goto err1;
-	}
-
-	file =3D debugfs_create_file("link_state", S_IRUGO | S_IWUSR, root,
-			dwc, &dwc3_link_state_fops);
-	if (!file) {
-		ret =3D -ENOMEM;
-		goto err1;
+	if (IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE) ||
+			IS_ENABLED(CONFIG_USB_DWC3_GADGET)) {
+		file =3D debugfs_create_file("testmode", S_IRUGO | S_IWUSR, root,
+				dwc, &dwc3_testmode_fops);
+		if (!file) {
+			ret =3D -ENOMEM;
+			goto err1;
+		}
+
+		file =3D debugfs_create_file("link_state", S_IRUGO | S_IWUSR, root,
+				dwc, &dwc3_link_state_fops);
+		if (!file) {
+			ret =3D -ENOMEM;
+			goto err1;
+		}
 	}
-#endif
=20
 	return 0;
=20

--=20
balbi

--fOHHtNG4YXGJ0yqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRKx4TAAoJEIaOsuA1yqREu9cP/jP6kpdzJQ5Ow65s3pfiEL+t
AdGH2p1jiR1PZx5yR9VsJ3tv1AK4in12dIx0m5BSWn9kzFWERBlPLBzJqavR86e0
4/JirtAwxSAQxmNFZ8lQS0AOixMNPtGS+0XFn6lcDU0mSkejRVSEqItgzGQDGFTP
xHyM8qKXBTOIimM3flnGyY4iLfJNizkerNHPJ8Kskj5qub0fz6hZu4nBB11uqkwN
fKvE7UbPFOhFSgk/H/xLDY2vHY+7VoVRm6Zti6hjIprAo2VBiGujXEyTiAMd3mp/
v/wu9oFT/R8JCbQd0WsqeoVNmi9+nfF3DcjNVmYQ6NyDgVmppwTDYiJSIjzWewAj
vHaxkREpKOkQVegKvPm+fXTtVALLqPXoP9SP8/PssO6jHlsogs3vqqcUIiUE+lrB
hnspK97zEr0YfhYxayZbORsOLhEI8dHCKsvaqbikg2RqjlUpN6CoePuLrba+GB3U
0iNsWcWhwvHZC61ov2TDbscNCMN8ROg+90zdVjT89J8jI20Ip4vLiW1ozKsNiBuB
MlAZXno+53HcwlraXQIY22kGy899H1cWDhrTAKb9x/v0+pk90w66SfV7BOIyYob0
sqQP4PSC3Y6XpLZ6dHff2nDUCxDhpKutjHWfLBvN3rJE+x1tKHTyq1wzzXiiIfy5
3gRRKaieLXDoTEUUGOtc
=Ir6p
-----END PGP SIGNATURE-----

--fOHHtNG4YXGJ0yqR--
