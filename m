Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaLJJ16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:27:58 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:48320 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaLJJ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:27:55 -0500
Message-ID: <54881218.6010107@monstr.eu>
Date: Wed, 10 Dec 2014 10:27:52 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Fix mmap for cache coherent memory
References: <1417619248-20365-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1417619248-20365-1-git-send-email-lars@metafoo.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="w9s3ARtESDWE7DO8qe5AEshHEe68WRtBK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--w9s3ARtESDWE7DO8qe5AEshHEe68WRtBK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/03/2014 04:07 PM, Lars-Peter Clausen wrote:
> When running in non-cache coherent configuration the memory that was
> allocated with dma_alloc_coherent() has a custom mapping and so there i=
s no
> 1-to-1 relationship between the kernel virtual address and the PFN. Thi=
s
> means that virt_to_pfn() will not work correctly for those addresses an=
d the
> default mmap implementation in the form of dma_common_mmap() will map s=
ome
> random, but not the requested, memory area.
>=20
> Fix this by providing a custom mmap implementation that looks up the PF=
N
> from the page table rather than using virt_to_pfn.
>=20
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/microblaze/include/asm/pgtable.h |  1 +
>  arch/microblaze/kernel/dma.c          | 26 ++++++++++++++++++++++++++
>  arch/microblaze/mm/consistent.c       | 23 ++++++++++++++++++-----
>  3 files changed, 45 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/microblaze/include/asm/pgtable.h b/arch/microblaze/in=
clude/asm/pgtable.h
> index 95cef0b..df19d0c 100644
> --- a/arch/microblaze/include/asm/pgtable.h
> +++ b/arch/microblaze/include/asm/pgtable.h
> @@ -565,6 +565,7 @@ void consistent_free(size_t size, void *vaddr);
>  void consistent_sync(void *vaddr, size_t size, int direction);
>  void consistent_sync_page(struct page *page, unsigned long offset,
>  	size_t size, int direction);
> +unsigned long consistent_virt_to_pfn(void *vaddr);
> =20
>  void setup_memory(void);
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.=
c
> index 4633c36..4822367 100644
> --- a/arch/microblaze/kernel/dma.c
> +++ b/arch/microblaze/kernel/dma.c
> @@ -154,9 +154,35 @@ dma_direct_sync_sg_for_device(struct device *dev,
>  			__dma_sync(sg->dma_address, sg->length, direction);
>  }
> =20
> +int dma_direct_mmap_coherent(struct device *dev, struct vm_area_struct=
 *vma,
> +			     void *cpu_addr, dma_addr_t handle, size_t size,
> +			     struct dma_attrs *attrs)
> +{
> +	unsigned long user_count =3D (vma->vm_end - vma->vm_start) >> PAGE_SH=
IFT;
> +	unsigned long count =3D PAGE_ALIGN(size) >> PAGE_SHIFT;
> +	unsigned long off =3D vma->vm_pgoff;
> +	unsigned long pfn;
> +
> +	if (!IS_ENABLED(CONFIG_MMU))
> +		return -ENXIO;
> +
> +	if (off >=3D count || user_count > (count - off))
> +		return -ENXIO;
> +
> +#ifdef NOT_COHERENT_CACHE
> +	vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> +	pfn =3D consistent_virt_to_pfn(cpu_addr);
> +#else
> +	pfn =3D virt_to_pfn(cpu_addr);
> +#endif
> +	return remap_pfn_range(vma, vma->vm_start, pfn + off,
> +			       vma->vm_end - vma->vm_start, vma->vm_page_prot);
> +}
> +
>  struct dma_map_ops dma_direct_ops =3D {
>  	.alloc		=3D dma_direct_alloc_coherent,
>  	.free		=3D dma_direct_free_coherent,
> +	.mmap		=3D dma_direct_mmap_coherent,
>  	.map_sg		=3D dma_direct_map_sg,
>  	.dma_supported	=3D dma_direct_dma_supported,
>  	.map_page	=3D dma_direct_map_page,
> diff --git a/arch/microblaze/mm/consistent.c b/arch/microblaze/mm/consi=
stent.c
> index e10ad93..f358cd2 100644
> --- a/arch/microblaze/mm/consistent.c
> +++ b/arch/microblaze/mm/consistent.c
> @@ -156,6 +156,23 @@ void *consistent_alloc(gfp_t gfp, size_t size, dma=
_addr_t *dma_handle)
>  }
>  EXPORT_SYMBOL(consistent_alloc);
> =20
> +static pte_t *consistent_virt_to_pte(void *vaddr)
> +{
> +	unsigned long addr =3D (unsigned long)vaddr;
> +
> +	return pte_offset_kernel(pmd_offset(pgd_offset_k(addr), addr), addr);=

> +}
> +
> +unsigned long consistent_virt_to_pfn(void *vaddr)
> +{
> +	pte_t *ptep =3D consistent_virt_to_pte(vaddr);
> +
> +	if (pte_none(*ptep) || !pte_present(*ptep))
> +		return 0;
> +
> +	return pte_pfn(*ptep);
> +}
> +
>  /*
>   * free page(s) as defined by the above mapping.
>   */
> @@ -181,13 +198,9 @@ void consistent_free(size_t size, void *vaddr)
>  	} while (size -=3D PAGE_SIZE);
>  #else
>  	do {
> -		pte_t *ptep;
> +		pte_t *ptep =3D consistent_virt_to_pte(vaddr);
>  		unsigned long pfn;
> =20
> -		ptep =3D pte_offset_kernel(pmd_offset(pgd_offset_k(
> -						(unsigned int)vaddr),
> -					(unsigned int)vaddr),
> -				(unsigned int)vaddr);
>  		if (!pte_none(*ptep) && pte_present(*ptep)) {
>  			pfn =3D pte_pfn(*ptep);
>  			pte_clear(&init_mm, (unsigned int)vaddr, ptep);
>=20


Applied.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--w9s3ARtESDWE7DO8qe5AEshHEe68WRtBK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlSIEhgACgkQykllyylKDCExNQCfZ86S73+4VrzLt9MHKMsFE7dG
29MAoJO+M52ntscv4SmGNwQhbwuTqJfj
=yXkZ
-----END PGP SIGNATURE-----

--w9s3ARtESDWE7DO8qe5AEshHEe68WRtBK--
