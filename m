Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaHAMlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:41:07 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39376 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaHAMlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:41:04 -0400
Date: Fri, 1 Aug 2014 14:40:59 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dma-mapping: Provide write-combine allocations
Message-ID: <20140801124057.GA19889@ulmo>
References: <1403863018-20033-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <1403863018-20033-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2014 at 11:56:58AM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> Provide an implementation for dma_{alloc,free,mmap}_writecombine() when
> the architecture supports DMA attributes.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v2:
> - Add a generic dma_mmap_writecombine() function
>=20
>  arch/arm/include/asm/dma-mapping.h       | 16 ----------------
>  include/asm-generic/dma-mapping-common.h |  8 --------
>  include/linux/dma-mapping.h              | 26 ++++++++++++++++++++++++++
>  3 files changed, 26 insertions(+), 24 deletions(-)

Ping?

> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dm=
a-mapping.h
> index c45b61a4b4a5..85738b200023 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -265,22 +265,6 @@ extern int arm_dma_mmap(struct device *dev, struct v=
m_area_struct *vma,
>  			void *cpu_addr, dma_addr_t dma_addr, size_t size,
>  			struct dma_attrs *attrs);
> =20
> -static inline void *dma_alloc_writecombine(struct device *dev, size_t si=
ze,
> -				       dma_addr_t *dma_handle, gfp_t flag)
> -{
> -	DEFINE_DMA_ATTRS(attrs);
> -	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> -	return dma_alloc_attrs(dev, size, dma_handle, flag, &attrs);
> -}
> -
> -static inline void dma_free_writecombine(struct device *dev, size_t size,
> -				     void *cpu_addr, dma_addr_t dma_handle)
> -{
> -	DEFINE_DMA_ATTRS(attrs);
> -	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> -	return dma_free_attrs(dev, size, cpu_addr, dma_handle, &attrs);
> -}
> -
>  /*
>   * This can be called during early boot to increase the size of the atom=
ic
>   * coherent DMA pool above the default value of 256KiB. It must be called
> diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-gener=
ic/dma-mapping-common.h
> index de8bf89940f8..d137431bf26f 100644
> --- a/include/asm-generic/dma-mapping-common.h
> +++ b/include/asm-generic/dma-mapping-common.h
> @@ -205,14 +205,6 @@ dma_mmap_attrs(struct device *dev, struct vm_area_st=
ruct *vma, void *cpu_addr,
> =20
>  #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, N=
ULL)
> =20
> -static inline int dma_mmap_writecombine(struct device *dev, struct vm_ar=
ea_struct *vma,
> -		      void *cpu_addr, dma_addr_t dma_addr, size_t size)
> -{
> -	DEFINE_DMA_ATTRS(attrs);
> -	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> -	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
> -}
> -
>  int
>  dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
>  		       void *cpu_addr, dma_addr_t dma_addr, size_t size);
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 931b70986272..d5d388160f42 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -263,6 +263,32 @@ struct dma_attrs;
>  #define dma_unmap_sg_attrs(dev, sgl, nents, dir, attrs) \
>  	dma_unmap_sg(dev, sgl, nents, dir)
> =20
> +#else
> +static inline void *dma_alloc_writecombine(struct device *dev, size_t si=
ze,
> +					   dma_addr_t *dma_addr, gfp_t gfp)
> +{
> +	DEFINE_DMA_ATTRS(attrs);
> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> +	return dma_alloc_attrs(dev, size, dma_addr, gfp, &attrs);
> +}
> +
> +static inline void dma_free_writecombine(struct device *dev, size_t size,
> +					 void *cpu_addr, dma_addr_t dma_addr)
> +{
> +	DEFINE_DMA_ATTRS(attrs);
> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> +	return dma_free_attrs(dev, size, cpu_addr, dma_addr, &attrs);
> +}
> +
> +static inline int dma_mmap_writecombine(struct device *dev,
> +					struct vm_area_struct *vma,
> +					void *cpu_addr, dma_addr_t dma_addr,
> +					size_t size)
> +{
> +	DEFINE_DMA_ATTRS(attrs);
> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> +	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
> +}
>  #endif /* CONFIG_HAVE_DMA_ATTRS */
> =20
>  #ifdef CONFIG_NEED_DMA_MAP_STATE
> --=20
> 2.0.0
>=20

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT24rZAAoJEN0jrNd/PrOhuoMQAIC1wuuwH28B0CCY2EBqThuV
fxYZuecVu8FdUA0qiVIEUzj+su1XeDowjXRxA8roMawM6284MyN/FAlu6dCBin1H
FX/SoNynzslax9U5wpKz6z+qpVva/ucJYJIsBRXyylAVnAds21F2pj2XxxEtRhq0
0jxrZVS6wC5aNro5uqWaKZB2pCiG5Na95B+ODOo11g9nlho+RKM9GdQQNBomt+pJ
3J3RtG/w3SSnENrD1ZuDmjPCjYQGOaKpIpmr32pFXKrNxCjX5KdkrYNU84MJM5p3
4+lk0bLHTPLjWzm3MdkQKwCfJthzBHUo9hB29loUVDuO6buoONA172J/Tlj+PGvc
ii5Dd2bTYGXKOv3Kh0MTv8hQ4BpDlx8azLa/etj8ppSmYgfmB+etOuZ3BA/K3zAM
0b/nl7Cui+3x8xpwRLXuyQH+cWg4vzG7FcmCD0UfvdmAH13EtR3iZ10BzR5F9rhT
tM+e8vz+mPLWZBIcYv6/6F/qblkIxkF2wT/ctcWpIGvsbUvl3eNVUkSBsuYKdEKV
6Dgi9rzsGaMlfPhbxMYq6n+9Tl6IR6ChyeI7+gr6AO6NYPqmb2cHB531x4CcApxF
aSkgqRq/PSdcGurIIxL97jN4HnnYPEOMfuf1oC5PVEvYuol7KNILr2AM1TosQhRa
xF5Zs0+HFD3spoOZZOfi
=OYSm
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
