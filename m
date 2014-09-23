Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaIWHXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:23:50 -0400
Received: from ozlabs.org ([103.22.144.67]:46531 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbaIWHXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:23:48 -0400
Date: Tue, 23 Sep 2014 17:23:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: linux-next: manual merge of the akpm-current tree with the arm64
 tree
Message-ID: <20140923172339.32ad4301@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fFyBUbNXuEWrQWGFEwTGdvX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fFyBUbNXuEWrQWGFEwTGdvX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/arm64/mm/dma-mapping.c between commit 2189064795dc ("arm64:
Implement set_arch_dma_coherent_ops() to replace bus notifiers") from
the arm64 tree and commit 50a477611cc9 ("arm64: add atomic pool for
non-coherent and CMA allocations") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/mm/dma-mapping.c
index d6ceb3df0047,90bb7b34d058..000000000000
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@@ -22,8 -22,12 +22,9 @@@
  #include <linux/slab.h>
  #include <linux/dma-mapping.h>
  #include <linux/dma-contiguous.h>
 -#include <linux/of.h>
 -#include <linux/platform_device.h>
  #include <linux/vmalloc.h>
  #include <linux/swiotlb.h>
 -#include <linux/amba/bus.h>
+ #include <linux/genalloc.h>
 =20
  #include <asm/cacheflush.h>
 =20
@@@ -305,8 -363,91 +360,69 @@@ struct dma_map_ops coherent_swiotlb_dma
  };
  EXPORT_SYMBOL(coherent_swiotlb_dma_ops);
 =20
 -static int dma_bus_notifier(struct notifier_block *nb,
 -			    unsigned long event, void *_dev)
 -{
 -	struct device *dev =3D _dev;
 -
 -	if (event !=3D BUS_NOTIFY_ADD_DEVICE)
 -		return NOTIFY_DONE;
 -
 -	if (of_property_read_bool(dev->of_node, "dma-coherent"))
 -		set_dma_ops(dev, &coherent_swiotlb_dma_ops);
 -
 -	return NOTIFY_OK;
 -}
 -
 -static struct notifier_block platform_bus_nb =3D {
 -	.notifier_call =3D dma_bus_notifier,
 -};
 -
 -static struct notifier_block amba_bus_nb =3D {
 -	.notifier_call =3D dma_bus_notifier,
 -};
 -
  extern int swiotlb_late_init_with_default_size(size_t default_size);
 =20
+ static int __init atomic_pool_init(void)
+ {
+ 	pgprot_t prot =3D __pgprot(PROT_NORMAL_NC);
+ 	unsigned long nr_pages =3D atomic_pool_size >> PAGE_SHIFT;
+ 	struct page *page;
+ 	void *addr;
+ 	unsigned int pool_size_order =3D get_order(atomic_pool_size);
+=20
+ 	if (dev_get_cma_area(NULL))
+ 		page =3D dma_alloc_from_contiguous(NULL, nr_pages,
+ 							pool_size_order);
+ 	else
+ 		page =3D alloc_pages(GFP_DMA, pool_size_order);
+=20
+ 	if (page) {
+ 		int ret;
+ 		void *page_addr =3D page_address(page);
+=20
+ 		memset(page_addr, 0, atomic_pool_size);
+ 		__dma_flush_range(page_addr, page_addr + atomic_pool_size);
+=20
+ 		atomic_pool =3D gen_pool_create(PAGE_SHIFT, -1);
+ 		if (!atomic_pool)
+ 			goto free_page;
+=20
+ 		addr =3D dma_common_contiguous_remap(page, atomic_pool_size,
+ 					VM_USERMAP, prot, atomic_pool_init);
+=20
+ 		if (!addr)
+ 			goto destroy_genpool;
+=20
+ 		ret =3D gen_pool_add_virt(atomic_pool, (unsigned long)addr,
+ 					page_to_phys(page),
+ 					atomic_pool_size, -1);
+ 		if (ret)
+ 			goto remove_mapping;
+=20
+ 		gen_pool_set_algo(atomic_pool,
+ 				  gen_pool_first_fit_order_align,
+ 				  (void *)PAGE_SHIFT);
+=20
+ 		pr_info("DMA: preallocated %zu KiB pool for atomic allocations\n",
+ 			atomic_pool_size / 1024);
+ 		return 0;
+ 	}
+ 	goto out;
+=20
+ remove_mapping:
+ 	dma_common_free_remap(addr, atomic_pool_size, VM_USERMAP);
+ destroy_genpool:
+ 	gen_pool_destroy(atomic_pool);
+ 	atomic_pool =3D NULL;
+ free_page:
+ 	if (!dma_release_from_contiguous(NULL, page, nr_pages))
+ 		__free_pages(page, pool_size_order);
+ out:
+ 	pr_err("DMA: failed to allocate %zu KiB pool for atomic coherent allocat=
ion\n",
+ 		atomic_pool_size / 1024);
+ 	return -ENOMEM;
+ }
+=20
  static int __init swiotlb_late_init(void)
  {
  	size_t swiotlb_size =3D min(SZ_64M, MAX_ORDER_NR_PAGES << PAGE_SHIFT);

--Sig_/fFyBUbNXuEWrQWGFEwTGdvX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUISACAAoJEMDTa8Ir7ZwVI9sQAJAb04vew1Kl3qFcdo/phrpr
iJ5XIN4eSMpYgwwinU0sYoJvahJHkhHtVa+cTP9BTXk1uSl1qgzH72gQ8sZi0cXn
V0ybDQIogf4sxGT/v5u8NH4cmdTXePWDI5V2I6ZyBmQVztgHALkmjv66M0E/zAW4
YmIVD7m3BTjaK9JR7GUQpbMAPZFc9VgUNpQV5eeqAFt8GE8/sJ8Uakf7vf9vX8KF
jFAxsi/Pmgb1SeLqM8JTrEYDJYpNJTNiEmhQlk9naGXkZ0U1i7UIi8/Fbqugsm2U
DYrxM4PN0pMvQVEcNu7h2VgeDHouK68fgZ7u5e7JkHhrU+BA/QDaCVunyhrj9/5D
iCd2ZNtO3xul8rNu/9QZnkZea16Dt/5mFEIqis/DqDdJ9H/KB0eALNC7ckGrhXrY
gzYHt91UKPw8q86LH9XWzH7TS0nAaF5ynd3rKCL1PkIMkniT0FKHnbzTAX8/GEte
XnmaHh+UNJWZfVrBJ+N5HE/sNUhWAPjf2k5f+7Vkec/SrHoYiwmNVnhpuKoGJi7N
rw7Vy1BmE266DVGGZT76UTRM1b09oSiSJDhy8krsO4GDg6F9RT8az5C6H/8QWYjA
oJL1KBNBtEgH1BgFRpdJey4Yx/fsugF1z4vZ9tfUWFHDJSyrQ9qtR2AZYBi0bWgY
keDHrrj6RPI+cIQd7/es
=/yns
-----END PGP SIGNATURE-----

--Sig_/fFyBUbNXuEWrQWGFEwTGdvX--
