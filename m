Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3KFHSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:18:03 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57409 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab3KFHSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:18:00 -0500
Date: Wed, 6 Nov 2013 18:17:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: linux-next: manual merge of the xen-tip tree with the arm tree
Message-Id: <20131106181740.c5e7e966a750909290ba1f94@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Nov_2013_18_17_40_+1100_cbaUBxQ1cYXv8GWg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Nov_2013_18_17_40_+1100_cbaUBxQ1cYXv8GWg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen-tip tree got a conflict in
arch/arm/include/asm/dma-mapping.h between commit 6a6a5c15d871 ("ARM:
7805/1: mm: change max*pfn to include the physical offset of memory")
from the arm tree and commit e24b7aa368a0 ("arm: make SWIOTLB available")
from the xen-tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/dma-mapping.h
index 863cd84eb1a2,8acfef48124a..000000000000
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@@ -87,13 -97,39 +98,46 @@@ static inline dma_addr_t virt_to_dma(st
  }
  #endif
 =20
+ static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t padd=
r)
+ {
+ 	unsigned int offset =3D paddr & ~PAGE_MASK;
+ 	return pfn_to_dma(dev, __phys_to_pfn(paddr)) + offset;
+ }
+=20
+ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_=
addr)
+ {
+ 	unsigned int offset =3D dev_addr & ~PAGE_MASK;
+ 	return __pfn_to_phys(dma_to_pfn(dev, dev_addr)) + offset;
+ }
+=20
+ static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_=
t size)
+ {
+ 	u64 limit, mask;
+=20
+ 	if (!dev->dma_mask)
+ 		return 0;
+=20
+ 	mask =3D *dev->dma_mask;
+=20
+ 	limit =3D (mask + 1) & ~mask;
+ 	if (limit && size > limit)
+ 		return 0;
+=20
+ 	if ((addr | (addr + size - 1)) & ~mask)
+ 		return 0;
+=20
+ 	return 1;
+ }
+=20
+ static inline void dma_mark_clean(void *addr, size_t size) { }
+=20
 +/* The ARM override for dma_max_pfn() */
 +static inline unsigned long dma_max_pfn(struct device *dev)
 +{
 +	return PHYS_PFN_OFFSET + dma_to_pfn(dev, *dev->dma_mask);
 +}
 +#define dma_max_pfn(dev) dma_max_pfn(dev)
 +
  /*
   * DMA errors are defined by all-bits-set in the DMA address.
   */

--Signature=_Wed__6_Nov_2013_18_17_40_+1100_cbaUBxQ1cYXv8GWg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSee0ZAAoJEMDTa8Ir7ZwVHv8P/0I12ssfd/91CQGeSSLmw5Oz
rTPg+coKwjK4JrxLOWcJHRqkEGhw4WUwGjBdAog2Gh+tU1NCsRYIIEJs1wKTIdG8
Hk6CZJAtaXOt1YgMy8nErW0kLZp3EpsVWAhebq7FxaiIGh2fDOdlx/7XEon4Gk8i
4x7TRqWGtJdym7XyPFy3VZpXW73KvQ16P8oxdGrWoUJaDs+v9lNEic9PEpd3LqM3
O5LLH05gIsW+KJv46B/HqHti8cupf8DFSGg/MS5lPqlicVUBuBcK2yvmNx3iieML
7PcgKRDwikkf19qSwl2ZlR4n+5MjP3mRYAhqmDPJhY7s/rpUExNDKaaaIk3TX81v
jSRZrWbKkHxXpeDOpnUL4jvdyUCfdxUXSsQTpD5j1v1XNiHzefIp+UvK6q1FnglQ
EtNUhrCgz3glGWMyg3RAQebG+cRIilx0BtPVO3XUvbtK4QqCfBYJd/uo+lyKmeUj
IgAi7jefFS5I2X3t37WT4HeHoEjPZ9mEQHweeR/28k358YnSMEo7v6vbjE0I5WUF
2z5Y5bTdYprxyyZ+WNBRJN7PmCDK/uTOxOy5oFzzJhGJN0gdmpRWU2XvsJdVNK1f
iikd5EOvPDLp0rIho9oojc8GDsymqj/oO/32mf9r19cYntwmBQiTp4dg/+SEcGFk
5QZF3QE8usF5CkprrQXp
=fF1q
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Nov_2013_18_17_40_+1100_cbaUBxQ1cYXv8GWg--
