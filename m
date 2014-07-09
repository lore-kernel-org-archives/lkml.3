Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbaGIWtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:49:33 -0400
Received: from ozlabs.org ([103.22.144.67]:57414 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbaGIWtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:49:31 -0400
Date: Thu, 10 Jul 2014 08:49:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Madhusudanan Kandasamy <kmadhu@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Fail remap_4k_pfn() if PFN doesn't fit inside
 PTE
Message-ID: <20140710084911.22cb58d4@canb.auug.org.au>
In-Reply-To: <53BD68FF.7000307@linux.vnet.ibm.com>
References: <53BD68FF.7000307@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/h1fVS2dE973m3B64ZcYvb=W"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/h1fVS2dE973m3B64ZcYvb=W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Madhusudanan,

On Wed, 09 Jul 2014 21:38:31 +0530 Madhusudanan Kandasamy <kmadhu@linux.vne=
t.ibm.com> wrote:
>
> diff --git a/arch/powerpc/include/asm/pte-hash64-64k.h b/arch/powerpc/inc=
lude/asm/pte-hash64-64k.h
> index d836d94..10af7f1 100644
> --- a/arch/powerpc/include/asm/pte-hash64-64k.h
> +++ b/arch/powerpc/include/asm/pte-hash64-64k.h
> @@ -74,8 +74,15 @@
>  #define pte_pagesize_index(mm, addr, pte)	\
>  	(((pte) & _PAGE_COMBO)? MMU_PAGE_4K: MMU_PAGE_64K)
>=20
> +static inline int bad_4k_pfn(void)
> +{
> +	WARN_ON(1);
> +	return -EINVAL;
> +}
> +
>  #define remap_4k_pfn(vma, addr, pfn, prot)				\
> -	remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,		\
> -			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN))
> +	((pfn >=3D (1UL << (64 - PTE_RPN_SHIFT))) ? bad_4k_pfn() :	\
> +		remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,	\
> +			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN)))
>=20
>  #endif	/* __ASSEMBLY__ */

WARN_ON() returns the value it is passed, so no helper is needed:

 #define remap_4k_pfn(vma, addr, pfn, prot)				\
-	remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,		\
-			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN))
+	WARN_ON(((pfn >=3D (1UL << (64 - PTE_RPN_SHIFT)))) ? -EINVAL :	\
+		remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,	\
+			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN)))

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/h1fVS2dE973m3B64ZcYvb=W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTvcb3AAoJEMDTa8Ir7ZwVlaIQAJBoBqF3IYhUMKxcoWhAmFXO
huw/jlZF4sAFPjGintk8dk9PRoGXSwbQ/jcBJtdrFI3WDjkd4DVuClQ+bcw7nK3Z
yJ5iam3EI5VT7e6wfymEtXSpKu4pBYT/nQVeWVzzgVM6hGo+i2np06xTQKbzWOpD
paYvNzdiEkUqpaQUmH8d+YMKphYn0Fspye5jSQFyOeevKWx2y7y0ntOY2Ay3DE1u
PSuYwpusaOKTKu6pRtnsnQWuRqigix37SDJquZ0ws9DO3A2DNVMPzW7qP2CMvCGX
wmt2JoCLKngj2j0IyKcTRbIqAgh7tPBPhNiBvsBc96QdGH0AzmjJHj2FAovC1fZ8
BWxgC6/QDt5TghG1+UVik/FdIP0xymUuwnagkA2kTEanOwVfk3EwSgHWQf4tBSl1
5vagNJCY/pKiK1VQhCEmPGV3YLmyYwkKBNh5pDYi5cFTBpPOgCptEkzKU2aujp5B
D3r1f29+GsUcJViMKuHQ7a9hb2LKZpmzL+Pm0tdLI2QBIOzMraArWcvL/zcx7apH
jbWmbcfqtF5YjkKrgau6EiQoTVF+S1xGukLWpcTuMrb2K+3BOyLkfFDvfTS5s7PI
RLR6JrDQ2gzqWN0rMQtbHq0ux6NVDz9IE4uYA/gkmviPdNQCTTzqsNHK1nYMCqSe
+JlbkihkpA9gV8y7ypBR
=z5JH
-----END PGP SIGNATURE-----

--Sig_/h1fVS2dE973m3B64ZcYvb=W--
