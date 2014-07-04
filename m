Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbaGDNfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:35:37 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63906 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaGDNfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:35:36 -0400
Date: Fri, 4 Jul 2014 15:35:22 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Riley <davidriley@chromium.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Ritesh Harjain <ritesh.harjani@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 5/5] arm64: Add atomic pool for non-coherent and CMA
 allocations.
Message-ID: <20140704133517.GA9860@ulmo>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
 <1404324218-4743-6-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <1404324218-4743-6-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 11:03:38AM -0700, Laura Abbott wrote:
[...]
> diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
[...]
> +static struct gen_pool *atomic_pool;
> +
> +#define DEFAULT_DMA_COHERENT_POOL_SIZE  SZ_256K
> +static size_t atomic_pool_size =3D DEFAULT_DMA_COHERENT_POOL_SIZE;

There doesn't seem to be much use for this since it can't be overridden
via init_dma_coherent_pool_size like on ARM.

> +static int __free_from_pool(void *start, size_t size)
> +{
> +	if (!__in_atomic_pool(start, size))
> +		return 0;
> +
> +	gen_pool_free(atomic_pool, (unsigned long)start, size);
> +
> +	return 1;
> +}
> +
> +

There's a gratuituous blank line here.

>  static void *__dma_alloc_coherent(struct device *dev, size_t size,
>  				  dma_addr_t *dma_handle, gfp_t flags,
>  				  struct dma_attrs *attrs)
> @@ -53,7 +103,8 @@ static void *__dma_alloc_coherent(struct device *dev, =
size_t size,
>  	if (IS_ENABLED(CONFIG_ZONE_DMA) &&
>  	    dev->coherent_dma_mask <=3D DMA_BIT_MASK(32))
>  		flags |=3D GFP_DMA;
> -	if (IS_ENABLED(CONFIG_DMA_CMA)) {
> +
> +	if (!(flags & __GFP_WAIT) && IS_ENABLED(CONFIG_DMA_CMA)) {

I think the diff would be more readable here if this wasn't introducing
a blank linke and kept the IS_ENABLED() first.

>  		struct page *page;
> =20
>  		size =3D PAGE_ALIGN(size);
> @@ -73,50 +124,56 @@ static void __dma_free_coherent(struct device *dev, =
size_t size,
>  				void *vaddr, dma_addr_t dma_handle,
>  				struct dma_attrs *attrs)
>  {
> +	bool freed;
> +	phys_addr_t paddr =3D dma_to_phys(dev, dma_handle);
> +
>  	if (dev =3D=3D NULL) {
>  		WARN_ONCE(1, "Use an actual device structure for DMA allocation\n");
>  		return;
>  	}
> =20
> -	if (IS_ENABLED(CONFIG_DMA_CMA)) {
> -		phys_addr_t paddr =3D dma_to_phys(dev, dma_handle);
> =20
> -		dma_release_from_contiguous(dev,

The above leaves an unnecessary blank line in place.

>  	ptr =3D __dma_alloc_coherent(dev, size, dma_handle, flags, attrs);
>  	if (!ptr)
>  		goto no_mem;
> -	map =3D kmalloc(sizeof(struct page *) << order, flags & ~GFP_DMA);
> -	if (!map)
> -		goto no_map;
> =20
>  	/* remove any dirty cache lines on the kernel alias */
>  	__dma_flush_range(ptr, ptr + size);
> =20
> +

Adds an unnecessary blank line.

> @@ -332,6 +391,67 @@ static struct notifier_block amba_bus_nb =3D {
> =20
>  extern int swiotlb_late_init_with_default_size(size_t default_size);
> =20
> +static int __init atomic_pool_init(void)
> +{
> +	pgprot_t prot =3D __pgprot(PROT_NORMAL_NC);
> +	unsigned long nr_pages =3D atomic_pool_size >> PAGE_SHIFT;
> +	struct page *page;
> +	void *addr;
> +
> +

There's another gratuituous blank line here...

> +	if (dev_get_cma_area(NULL))
> +		page =3D dma_alloc_from_contiguous(NULL, nr_pages,
> +					get_order(atomic_pool_size));
> +	else
> +		page =3D alloc_pages(GFP_KERNEL, get_order(atomic_pool_size));
> +
> +

and here.

> +	if (page) {
> +		int ret;
> +
> +		atomic_pool =3D gen_pool_create(PAGE_SHIFT, -1);
> +		if (!atomic_pool)
> +			goto free_page;
> +
> +		addr =3D dma_common_contiguous_remap(page, atomic_pool_size,
> +					VM_USERMAP, prot, atomic_pool_init);
> +
> +		if (!addr)
> +			goto destroy_genpool;
> +
> +		memset(addr, 0, atomic_pool_size);
> +		__dma_flush_range(addr, addr + atomic_pool_size);
> +
> +		ret =3D gen_pool_add_virt(atomic_pool, (unsigned long)addr,
> +					page_to_phys(page),
> +					atomic_pool_size, -1);
> +		if (ret)
> +			goto remove_mapping;
> +
> +		gen_pool_set_algo(atomic_pool,
> +				  gen_pool_first_fit_order_align, NULL);
> +
> +		pr_info("DMA: preallocated %zd KiB pool for atomic allocations\n",

I think this should be "%zu" because atomic_pool_size is a size_t, not a
ssize_t.

> +			atomic_pool_size / 1024);
> +		return 0;
> +	}
> +	goto out;
> +
> +remove_mapping:
> +	dma_common_free_remap(addr, atomic_pool_size, VM_USERMAP);
> +destroy_genpool:
> +	gen_pool_destroy(atomic_pool);
> +	atomic_pool =3D=3D NULL;

This probably doesn't belong here.

> +free_page:
> +	if (!dma_release_from_contiguous(NULL, page, nr_pages))
> +		__free_pages(page, get_order(atomic_pool_size));

You use get_order(atomic_pool_size) a lot, perhaps it should be a
temporary variable?

> +out:
> +	pr_err("DMA: failed to allocate %zx KiB pool for atomic coherent alloca=
tion\n",
> +		atomic_pool_size / 1024);

Print in decimal rather than hexadecimal?

Thierry

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtq2VAAoJEN0jrNd/PrOhWGgP/0QTXomEVasIBv8dgVzothdB
0Huu6JJrjj323T7QB6zjNWrXcBkfTDD8H/XL1ubdb80HlU8aBiHCdKtr64oksl0k
0R1W/SY4aiwx50oubVLBjJNvpsLJPhVtCFWYxG8ays6RCNCPPRzxkMUAqnFXq98l
m/XcNzCwpgApbjHjjwrPfGk6IyNXDqSQ/cqC7P4iMBS1H96VbBX+K2qZMNBzGJF5
fdVH8LXH9AHR88bmnbJUWuGeII+EUSq7ct+Ti3mayLSQQC3JdJJ1+VAEzRF0bjVU
YehClP8PK5edDPYfOSktomqqe0mNbLCc/BCkx8otub9QZDyFyTzT6/HJEzgKdr9x
qT04gwzMGykfRR0irTuTYvYo7zG3yy3ME2xy5Vqyrfujdf0ZB6V74XOfROP/0nOc
06mHWCI1LiTW3NlfuAD/wwVBoTeDTgJaeimKxZJJIfR5r9x/9Ihh6yzDtROV9SwR
LWZV1exGHyA/Dt2ZZwCVuB5zMvs8GUGL41U73+bIeSwUjwnwuk1/S45aoyJlHpV3
HD2DUc3nDQ1PcERjVVgHTzgYxU9L6SSq4X1NZvukkyfIVTvwaGDhFQnyb3eSM37f
Rad40Q2OKwMnWxvOoGiCsMQMfzUriSLNhhzOSPS6DQLnjZFARezDimuVqNvj/oFk
Jhd5G1ZDTSA7n0uXC7Ks
=P2sl
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
