Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaJ1EYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:24:54 -0400
Received: from ozlabs.org ([103.22.144.67]:38535 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbaJ1EYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:24:52 -0400
Date: Tue, 28 Oct 2014 15:24:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Thierry Reding <treding@nvidia.com>
Subject: linux-next: manual merge of the akpm-current tree with the
 dma-mapping tree
Message-ID: <20141028152444.79bd9fe9@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.0 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Li=CG9qwWOUt1QgIjJ92DAE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Li=CG9qwWOUt1QgIjJ92DAE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/cma.c between commit 16195ddd4ebc ("mm: cma: Ensure that
reservations never cross the low/high mem boundary") from the
dma-mapping tree and commit 2a70e5a78672 ("mm/cma: ake kmemleak ignore
CMA regions") from the akpm-current tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/cma.c
index fde706e1284f,471fcfef043b..000000000000
--- a/mm/cma.c
+++ b/mm/cma.c
@@@ -278,30 -274,20 +278,35 @@@ int __init cma_declare_contiguous(phys_
  			goto err;
  		}
  	} else {
 -		phys_addr_t addr =3D memblock_alloc_range(size, alignment, base,
 -							limit);
 +		phys_addr_t addr =3D 0;
 +
 +		/*
 +		 * All pages in the reserved area must come from the same zone.
 +		 * If the requested region crosses the low/high memory boundary,
 +		 * try allocating from high memory first and fall back to low
 +		 * memory in case of failure.
 +		 */
 +		if (base < highmem_start && limit > highmem_start) {
 +			addr =3D memblock_alloc_range(size, alignment,
 +						    highmem_start, limit);
 +			limit =3D highmem_start;
 +		}
 +
  		if (!addr) {
 -			ret =3D -ENOMEM;
 -			goto err;
 -		} else {
 -			/*
 -			 * kmemleak scans/reads tracked objects for pointers to
 -			 * other objects but this address isn't mapped and
 -			 * accessible
 -			 */
 -			kmemleak_ignore(phys_to_virt(addr));
 -			base =3D addr;
 +			addr =3D memblock_alloc_range(size, alignment, base,
 +						    limit);
 +			if (!addr) {
 +				ret =3D -ENOMEM;
 +				goto err;
 +			}
  		}
-=20
++		/*
++		 * kmemleak scans/reads tracked objects for pointers to
++		 * other objects but this address isn't mapped and
++		 * accessible
++		 */
++		kmemleak_ignore(phys_to_virt(addr));
 +		base =3D addr;
  	}
 =20
  	ret =3D cma_init_reserved_mem(base, size, order_per_bit, res_cma);

--Sig_/Li=CG9qwWOUt1QgIjJ92DAE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUTxqQAAoJEMDTa8Ir7ZwVQ50P/0EeT71xKRVoq/qwisqTd7Bg
kCuRwRjk9rfE78V0gIwxNE11Z7SLvRMSZpeyYHMw3sMJuJetSI2qRgkscQqbsrtx
JXQG6qOmsZQt9lhIBA1rUWGeICB+57BrqzfmgKJOSZQowxpTluD+cUUFvg6SYSco
IH2eOvpbfGsMe17a8CE0QBSC87clD/M2Mx5amurLroeDTzw9Hiknw0MthRbsi+bv
InRC6FiJVMApJpjLnXG1Xpf28zWTf0XoSg7CwfYxA7BQsil9EjOvOT04pRETGaVz
PdhAW3eNNFnLnwiXI+7Lbd97eKZHL7ryElGGgb7U0p0D1nYq5ApaotxAs2RoHuF5
27wgZd6wfIgj6+r+9mwPSD0FD32HWjgLulSvyXZlMiI7AzH8hkTgBIEowx7Bwy75
w/zonF+MfBuTNc6WDuzRlo7dpfq5P+DpPVDHY60cnNtdul6TK0mk69bUxQDlQusw
+KbPO2TKdWERblE7fgkLF++j7bPojitvblPQrj/AfFJ9sonzj6xSerMaQW/yqQME
fm3dCqdmTDCzBfxpF1oqGax50JuIpnFhYVW1VBi8wYHuD/vhN7F3LvFk1seL0ELE
81sUTPG+ddjaK3nttlzwr/bKsUawFeVwvkk24Y4LXyiQS0LHizhiTe7lk0wizqK/
jPtm1yblR1TWI1yd1D7z
=0cNa
-----END PGP SIGNATURE-----

--Sig_/Li=CG9qwWOUt1QgIjJ92DAE--
