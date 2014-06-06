Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaFFNWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:22:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:13244 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaFFNWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:22:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,989,1392192000"; 
   d="asc'?scan'208";a="543577714"
Message-ID: <1402060936.12971.2.camel@intelbox>
Subject: Re: [PATCH 4/5] drm/i915: Fixup global gtt cleanup
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>
Date: Fri, 06 Jun 2014 16:22:16 +0300
In-Reply-To: <1401980308-5116-4-git-send-email-daniel.vetter@ffwll.ch>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
	 <1401980308-5116-4-git-send-email-daniel.vetter@ffwll.ch>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-2BCPdOH0cs5aaY9fHwqv"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2BCPdOH0cs5aaY9fHwqv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-06-05 at 16:58 +0200, Daniel Vetter wrote:
> The global gtt is setup up in 2 parts, so we need to be careful
> with the cleanup. For consistency shovel it all into the ->cleanup
> callback, like with ppgtt.
>=20
> Noticed because it blew up in the out_gtt: cleanup code while
> fiddling with the vgacon code.
>=20
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Reviewed-by: Imre Deak <imre.deak@intel.com>

> ---
>  drivers/gpu/drm/i915/i915_dma.c     | 4 ----
>  drivers/gpu/drm/i915/i915_gem_gtt.c | 9 ++++++++-
>  2 files changed, 8 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_=
dma.c
> index b9159ade5e85..27fe65ac5940 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1386,7 +1386,6 @@ cleanup_gem:
>  	i915_gem_context_fini(dev);
>  	mutex_unlock(&dev->struct_mutex);
>  	WARN_ON(dev_priv->mm.aliasing_ppgtt);
> -	drm_mm_takedown(&dev_priv->gtt.base.mm);
>  cleanup_irq:
>  	drm_irq_uninstall(dev);
>  cleanup_gem_stolen:
> @@ -1756,8 +1755,6 @@ out_mtrrfree:
>  	arch_phys_wc_del(dev_priv->gtt.mtrr);
>  	io_mapping_free(dev_priv->gtt.mappable);
>  out_gtt:
> -	list_del(&dev_priv->gtt.base.global_link);
> -	drm_mm_takedown(&dev_priv->gtt.base.mm);
>  	dev_priv->gtt.base.cleanup(&dev_priv->gtt.base);
>  out_regs:
>  	intel_uncore_fini(dev);
> @@ -1846,7 +1843,6 @@ int i915_driver_unload(struct drm_device *dev)
>  			i915_free_hws(dev);
>  	}
> =20
> -	list_del(&dev_priv->gtt.base.global_link);
>  	WARN_ON(!list_empty(&dev_priv->vm_list));
> =20
>  	drm_vblank_cleanup(dev);
> diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i=
915_gem_gtt.c
> index 931b906f292a..41e864ec5632 100644
> --- a/drivers/gpu/drm/i915/i915_gem_gtt.c
> +++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
> @@ -1985,7 +1985,10 @@ static void gen6_gmch_remove(struct i915_address_s=
pace *vm)
> =20
>  	struct i915_gtt *gtt =3D container_of(vm, struct i915_gtt, base);
> =20
> -	drm_mm_takedown(&vm->mm);
> +	if (drm_mm_initialized(&vm->mm)) {
> +		drm_mm_takedown(&vm->mm);
> +		list_del(&vm->global_link);
> +	}
>  	iounmap(gtt->gsm);
>  	teardown_scratch_page(vm->dev);
>  }
> @@ -2018,6 +2021,10 @@ static int i915_gmch_probe(struct drm_device *dev,
> =20
>  static void i915_gmch_remove(struct i915_address_space *vm)
>  {
> +	if (drm_mm_initialized(&vm->mm)) {
> +		drm_mm_takedown(&vm->mm);
> +		list_del(&vm->global_link);
> +	}
>  	intel_gmch_remove();
>  }
> =20


--=-2BCPdOH0cs5aaY9fHwqv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJTkcCIAAoJEORIIAnNuWDFww8H/3eHS5Ps+9l3CBgIDCDNqXtJ
65PJpcv4Ys0c9zr5jLwITfxwCWD4xY35nKjAYkvCXXv/MKSsOhpDp2g2/iKDOSdZ
xByYcQk0eV670u4Rqrsp9jqAsJ9G7EalRNmQn+XBMPH9RgMLNu87tVyZSVNY5gMO
zgbnTZiPef91jmWOQbMezySQclKCNcNe9wNZ2k048vGxB49xH7PO/AjnMkigKINV
F3g8ImgfZh96cLmw6nT8r4gE99sscy4suxUgA9BDfuaZ+8lXnDttwCIw49TAdD6H
gPqCz1XKLL99pr2EGGQL5ZsciQBAEwNKsezlqYDD2b5wYzH57Nbu6sbjUqMeB0c=
=kaTi
-----END PGP SIGNATURE-----

--=-2BCPdOH0cs5aaY9fHwqv--

