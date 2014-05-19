Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaESJEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:04:21 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47475 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaESJET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:04:19 -0400
Date: Mon, 19 May 2014 11:02:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 4/4] drm/nouveau: introduce CPU cache flushing macro
Message-ID: <20140519090202.GC7138@ulmo>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
 <1400483458-9648-5-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <1400483458-9648-5-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 04:10:58PM +0900, Alexandre Courbot wrote:
> Some architectures (e.g. ARM) need the CPU buffers to be explicitely
> flushed for a memory write to take effect. Not doing so results in
> synchronization issues, especially after writing to BOs.

It seems to me that the above is generally true for all architectures,
not just ARM.

Also: s/explicitely/explicitly/

> This patch introduces a macro that flushes the caches on ARM and
> translates to a no-op on other architectures, and uses it when
> writing to in-memory BOs. It will also be useful for implementations of
> instmem that access shared memory directly instead of going through
> PRAMIN.

Presumably instmem can access shared memory on all architectures, so
this doesn't seem like a property of the architecture but rather of the
memory pool backing the instmem.

In that case I wonder if this shouldn't be moved into an operation that
is implemented by the backing memory pool and be a noop where the cache
doesn't need explicit flushing.

> diff --git a/drivers/gpu/drm/nouveau/core/os.h b/drivers/gpu/drm/nouveau/=
core/os.h
> index d0ced94ca54c..274b4460bb03 100644
> --- a/drivers/gpu/drm/nouveau/core/os.h
> +++ b/drivers/gpu/drm/nouveau/core/os.h
> @@ -38,4 +38,21 @@
>  #endif /* def __BIG_ENDIAN else */
>  #endif /* !ioread32_native */
> =20
> +#if defined(__arm__)
> +
> +#define nv_cpu_cache_flush_area(va, size)	\
> +do {						\
> +	phys_addr_t pa =3D virt_to_phys(va);	\
> +	__cpuc_flush_dcache_area(va, size);	\
> +	outer_flush_range(pa, pa + size);	\
> +} while (0)

Couldn't this be a static inline function?

> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouve=
au/nouveau_bo.c
[...]
> index 0886f47e5244..b9c9729c5733 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -437,8 +437,10 @@ nouveau_bo_wr16(struct nouveau_bo *nvbo, unsigned in=
dex, u16 val)
>  	mem =3D &mem[index];
>  	if (is_iomem)
>  		iowrite16_native(val, (void __force __iomem *)mem);
> -	else
> +	else {
>  		*mem =3D val;
> +		nv_cpu_cache_flush_area(mem, 2);
> +	}
>  }
> =20
>  u32
> @@ -461,8 +463,10 @@ nouveau_bo_wr32(struct nouveau_bo *nvbo, unsigned in=
dex, u32 val)
>  	mem =3D &mem[index];
>  	if (is_iomem)
>  		iowrite32_native(val, (void __force __iomem *)mem);
> -	else
> +	else {
>  		*mem =3D val;
> +		nv_cpu_cache_flush_area(mem, 4);
> +	}

This looks rather like a sledgehammer to me. Effectively this turns nvbo
into an uncached buffer. With additional overhead of constantly flushing
caches. Wouldn't it make more sense to locate the places where these are
called and flush the cache after all the writes have completed?

Thierry

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTeciKAAoJEN0jrNd/PrOh0PoP/iqDXcR5waoDFQHQ1VnngF6c
DRB0hnT6E13C5mFNyvyn49ot18fnTCRUImAXuFzPdYAQolp/n2Ij+Eejq9t16aUK
XrsppQNfRgvvPlExg41AQvwKHmmboLwA0/Qc5Rgai76jE3M6QI2vdEzL6g7lxTpb
9IFt82clDs0HgGAMAl/NN2gANDTlfLYa2OyxCmPE/JhHaX5gf4D1/Jte4IdtjMYS
1zT9/Fay9CyrokKaH33hE6w6d7W6jsCUXnaPj3RmkpUbAzXc/A+ifLBXSh9a6ixz
FKdMy2wV3iZw232KUutE2YlXs1ECdjZBUBJWF4bVqYMH93R24b99s0nUuPXd3OBk
vnPsunOOjc4t/nakcMOjXjCC3HSdel4yp5dl/2mhpuC7Ju1aneh0sPrcrHNgqwpN
+ayPpEDufF+32alpnxfe07ARKtXDX/FUR2bVoa2TGpX5b5ONNqd8CW/aQB15cU0E
PC3yQQmX0z5OajbgTQS9+kSx/FDXtBhUvI5GY4yFn5YVw/96F/CVOeo/8hlNxbCY
EmlSTDCQPWoW6Uh3nlgFsHs/vKEequKTxRecyUQP6GAC8ZbjT/VZoougHgK2VSzr
6E2PMEoai9uAqkq44iJbWsss5G5EQqWYS/WxmjJdVDsP4gvIcsA2wqgNReKjflXS
f7ULQ7JvqvQJnJ1lZtna
=W3I6
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
