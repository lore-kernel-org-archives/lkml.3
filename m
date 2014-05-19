Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaESIsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:48:38 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61987 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaESIsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:48:37 -0400
Date: Mon, 19 May 2014 10:46:21 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 3/4] drm/nouveau: hook up cache sync functions
Message-ID: <20140519084620.GB7138@ulmo>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
 <1400483458-9648-4-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <1400483458-9648-4-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 04:10:57PM +0900, Alexandre Courbot wrote:
> From: Lucas Stach <dev@lynxeye.de>
>=20
> Signed-off-by: Lucas Stach <dev@lynxeye.de>
> [acourbot@nvidia.com: make conditional and platform-friendly]
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Perhaps having a propery commit message here would be good.

> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouve=
au/nouveau_bo.c
[...]
> +#ifdef NOUVEAU_NEED_CACHE_SYNC
> +void
> +nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
> +{
> +	struct nouveau_device *device;
> +	struct ttm_tt *ttm =3D nvbo->bo.ttm;
> +
> +	device =3D nouveau_dev(nouveau_bdev(ttm->bdev)->dev);
> +
> +	if (nvbo->bo.ttm && nvbo->bo.ttm->caching_state =3D=3D tt_cached)
> +		ttm_dma_tt_cache_sync_for_cpu((struct ttm_dma_tt *)nvbo->bo.ttm,
> +					      nv_device_base(device));

Can we be certain at this point that the struct ttm_tt is in fact a
struct ttm_dma_tt?

> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.h b/drivers/gpu/drm/nouve=
au/nouveau_bo.h
[...]
> +#if IS_ENABLED(CONFIG_ARCH_TEGRA)
> +#define NOUVEAU_NEED_CACHE_SYNC
> +#endif

I know I gave this as an example myself when we discussed this offline,
but I'm now thinking that this might actually be better off in Kconfig.

> +#ifdef NOUVEAU_NEED_CACHE_SYNC
> +void nouveau_bo_sync_for_cpu(struct nouveau_bo *);
> +void nouveau_bo_sync_for_device(struct nouveau_bo *);
> +#else
> +static inline void
> +nouveau_bo_sync_for_cpu(struct nouveau_bo *)
> +{
> +}
> +
> +static inline void
> +nouveau_bo_sync_for_device(struct nouveau_bo *)
> +{
> +}
> +#endif
> +
> +

There's a gratuituous blank line here.

> diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouv=
eau/nouveau_gem.c
> index c90c0dc0afe8..b7e42fdc9634 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_gem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
> @@ -897,7 +897,13 @@ nouveau_gem_ioctl_cpu_prep(struct drm_device *dev, v=
oid *data,
>  	ret =3D ttm_bo_wait(&nvbo->bo, true, true, no_wait);
>  	spin_unlock(&nvbo->bo.bdev->fence_lock);
>  	drm_gem_object_unreference_unlocked(gem);
> -	return ret;
> +
> +	if (ret)
> +		return ret;
> +
> +	nouveau_bo_sync_for_cpu(nvbo);
> +
> +	return 0;
>  }

This could be rewritten as:

	if (!ret)
		nouveau_bo_sync_for_cpu(nvbo);

	return ret;

Which would be slightly shorter.

On second thought, perhaps part of nouveau_gem_ioctl_cpu_prep() could be
refactored into a separate function to make this more symmetric. If we
put that in nouveau_bo.c and name it nouveau_bo_wait() for example, the
dummies can go away and both nouveau_bo_sync_for_{cpu,device}() can be
made static. I also think that's cleaner because it has both variants of
the nouveau_bo_sync_for_*() calls in the same file.

Thierry

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTecTcAAoJEN0jrNd/PrOh1EwP/2jzEFSMuR0EYqCB6nplr3+U
onn6FmRhLJoD9Yc/Et9C8SdsGE4QU7mSibNIV9Cd9BQP8/H0W+486K/QhkpzHm1F
5kAsIMi8hoLdf3SGY0iJBLgFgTjT/aJ4KVwnfkIytA1jZG0IxGIn5gBRjU7Vbb8S
H9l4n+YBF454ii7dES0LgsZEfwOW9iQeEb8XBqHJJqkXMlLSuns41l/DLZ739gVB
qolgqUOi7XOFyqvle21h3SjwZzj+ItfZKFploM1n5g/a0EUgV8rjneDuVgyTqAzM
+PBt7kR6Zv0VSKlat374EoxeaZG1jNiCw6fGXqo9fGPUsrMGB+PJY8znfq5vm2iv
2L3GZFSjPx+WwXkZoPz2qq8Oeyf6+6bOcXAeiEHNqtpoOxRw4dnUlEd0G6Nq4RKp
VrZCke0T6GlA+uS9T8URRsBG4wJlIwHmJkMVbxdx6u6XPyAJz7i4JyJBBIB1RgnN
WKRzRwKNR5sjx2sHinHjAdAwwTyfk4fb70CSVWlxhJRY7n1/Yxi9tRuFi3p546El
1jsIU1KoCXmrd5t77zTx3sVgS8tsLO/0t1/IT9R6RHP7VSuuwzCNfnD0l2l/uzyz
LdEdp2bC1dtzn78924wTjHKjqPTyctLUzvuRp67DqBh1ZzecYokL2XqbOiFKGgKG
RE+LCR+8tVI00JHW99p4
=WTVo
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
