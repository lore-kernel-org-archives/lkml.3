Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbbAKVtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:49:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60050 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbbAKVtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:49:22 -0500
Message-ID: <1421012945.19708.27.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16.y-ckt 030/168] drm/i915: Handle failure to kick out
 a conflicting fb driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Sun, 11 Jan 2015 21:49:05 +0000
In-Reply-To: <1418653622-21105-31-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
	 <1418653622-21105-31-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2YmZ2xEKgSWZhe7HJTsF"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2YmZ2xEKgSWZhe7HJTsF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-12-15 at 14:24 +0000, Luis Henriques wrote:
> 3.16.7-ckt3 -stable review patch.  If anyone has any objections, please l=
et me know.
>=20
> ------------------
>=20
> From: Chris Wilson <chris@chris-wilson.co.uk>
>=20
> commit f96de58fc7e7d3d717c7c63975c3b896c906b5e3 upstream.
>=20
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

Should this also be applied to any older stable branches?

i915_kick_out_firmware_fb() was introduced in 3.6 and it has always been
possible for the alloc_apertures() call to fail.

remove_conflicting_framebuffers() has returned an error code since 3.14
(but could silently fail before then!) so this should be applicable to
the 3.14 stable branch too.

Ben.

> ---
>  drivers/gpu/drm/i915/i915_dma.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_=
dma.c
> index d44344140627..0663fb4fa606 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1425,15 +1425,16 @@ void i915_master_destroy(struct drm_device *dev, =
struct drm_master *master)
>  }
> =20
>  #if IS_ENABLED(CONFIG_FB)
> -static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
> +static int i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
>  {
>  	struct apertures_struct *ap;
>  	struct pci_dev *pdev =3D dev_priv->dev->pdev;
>  	bool primary;
> +	int ret;
> =20
>  	ap =3D alloc_apertures(1);
>  	if (!ap)
> -		return;
> +		return -ENOMEM;
> =20
>  	ap->ranges[0].base =3D dev_priv->gtt.mappable_base;
>  	ap->ranges[0].size =3D dev_priv->gtt.mappable_end;
> @@ -1441,13 +1442,16 @@ static void i915_kick_out_firmware_fb(struct drm_=
i915_private *dev_priv)
>  	primary =3D
>  		pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
> =20
> -	remove_conflicting_framebuffers(ap, "inteldrmfb", primary);
> +	ret =3D remove_conflicting_framebuffers(ap, "inteldrmfb", primary);
> =20
>  	kfree(ap);
> +
> +	return ret;
>  }
>  #else
> -static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
> +static int i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
>  {
> +	return 0;
>  }
>  #endif
> =20
> @@ -1664,7 +1668,11 @@ int i915_driver_load(struct drm_device *dev, unsig=
ned long flags)
>  			goto out_gtt;
>  		}
> =20
> -		i915_kick_out_firmware_fb(dev_priv);
> +		ret =3D i915_kick_out_firmware_fb(dev_priv);
> +		if (ret) {
> +			DRM_ERROR("failed to remove conflicting framebuffer drivers\n");
> +			goto out_gtt;
> +		}
>  	}
> =20
>  	pci_set_master(dev->pdev);

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-2YmZ2xEKgSWZhe7HJTsF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVLLv1ue/yOyVhhEJAQrGuhAAlUshSZ02Wf0obsszBFkxQ0ZyE//Y/j+6
T9xX2elf/K6FoQ0w1O66M2VbxMo7xpd3dAoQJr4DW5l1//BhVhRoUhahlQJhQXKB
A66SdKjapuCasEqnyL55USKuolJVIMC4r+Bo3RTwG6MdeKJ/SbPHNlJG3ekaphI8
z1Sd3jZbnzjdMeoXDlvyBwJXraCvE9GDAaymm00zQ0cPrGSuDJiXeXOXkcwCdjip
5yw+7Y93DtzdrCxjIXYkc/zBATDU3ZtQTeOLcxatauyTBBgh3I278Jej7WOhgPS1
ope8c5yIDaak/tL/WqV9pmVz5lFfhCcVHmZdyrb3n7WV594iVdDxNkEptAysGbPe
Xwg0MvxuQzCSupL0h/KC+z8mr8k5+1I8VsMFoTaL89+bBjJ0imlzrp5V4JhSmDm4
ZP/peUNJdBfcKyfsbUUj8M0+JK94GVHb5Sdv8zg3YwZdKDkx9FV93TbY34TMMSu4
ij/ls6GqqaKTi4N/OpOxrP1/sU2dm4PK2UO1ObdPv9xC6A0thIT2bxpWek/k3NOp
oIJSZY9gAN1usbLL5mV196C776SD8UWNpXtCuzP430mKhrgu/6Gg8+EDa9qLfDVT
6WsAp9BjNkOef1vE4sQYFgO8KR/OyX02Jgbincqpu+v9JlXSxqeWAG7vtWNxSAy2
8sKfG8upynE=
=KcRE
-----END PGP SIGNATURE-----

--=-2YmZ2xEKgSWZhe7HJTsF--
