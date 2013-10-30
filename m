Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab3J3FKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:10:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58713 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3J3FKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:10:13 -0400
Date: Wed, 30 Oct 2013 16:09:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: linux-next: manual merge of the xen-tip tree with the  tree
Message-Id: <20131030160956.dfa5c1900c2decb0018061b9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Oct_2013_16_09_56_+1100_QqQ9XaUpT29pM7xs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Oct_2013_16_09_56_+1100_QqQ9XaUpT29pM7xs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen-tip tree got a conflict in
arch/arm/include/asm/dma-mapping.h between commit 223016339ce7 ("ARM:
7805/1: mm: change max*pfn to include the physical offset of memory")
from the arm tree and commit 06e6295bcece ("arm: make SWIOTLB available")
from the xen-tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/dma-mapping.h
index 863cd84eb1a2,f5945d4e4e9f..000000000000
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@@ -87,13 -98,42 +99,49 @@@ static inline dma_addr_t virt_to_dma(st
  }
  #endif
 =20
 +/* The ARM override for dma_max_pfn() */
 +static inline unsigned long dma_max_pfn(struct device *dev)
 +{
 +	return PHYS_PFN_OFFSET + dma_to_pfn(dev, *dev->dma_mask);
 +}
 +#define dma_max_pfn(dev) dma_max_pfn(dev)
 +
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
+ =09
+ 	if (dev->dma_mask)
+ 		mask =3D *dev->dma_mask;
+ 	else=20
+ 		mask =3D dev->coherent_dma_mask;
+=20
+ 	if (mask =3D=3D 0)
+ 		return 0;
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
  /*
   * DMA errors are defined by all-bits-set in the DMA address.
   */

--Signature=_Wed__30_Oct_2013_16_09_56_+1100_QqQ9XaUpT29pM7xs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScJSpAAoJEMDTa8Ir7ZwV2BgP/ROx7O0INdO5PMoqLNSHyoIt
hXPFU1YnpP8oa0Hq5m0HoEwTYmLTm7qt/11e2JktzQPOhIGkqo3iV8AqXCD2l2V8
bDD6xad24qTYdYR44m8ZxeaI2hIpSktmsmD7rS93HeN7lvojVUiQUR5wm+QIRulK
D6yu62r64/fJYdbbU7uEWSRXfzvhegkThO91nBRihWHPWHSbaPM+emsOJofIqGHI
LdHg7z6JMRMuuIXbz2WgJt+41k8bHWzfdBmSoLd/sVYXVlQbkRo6QFx8xUtkjyr8
TexKE6mLVy72QVmt7PX6DN03TKV+f7oC/ccPCRvmWnbvJwivq1wn7NlesZf9e0Fc
4ZWwV+I2MT+37MqaucjT7eyZrCNZWvgVegI1t199ycApjiDyHUj4aOsOrCZVjyz7
iIAbzdeVLXYE9IyJIDBUrvb+gAvsHTAIy8VpIAnmqmBZvMoPsvAMw+FxlbybHW++
O5IzvyUgOGxVecZaOzNiJLfXxm1pbtbe+59zHSe1UBbkjIg3JDJBlRMLFa8vFkl0
PwAHoU9BuW5jvNHb8Vu+DGWlHSpKbsFrC2sGT0H/KRxYAlArzNWIiSmX3MHteHxd
/nEZY+N3GcdQBQYzeOdpv65+TDINQZfRFH/lYrM3ZcAO133UBKc9Qf+x77ed6TSO
V7SjyPhuVrGmd/AsDfZv
=tUZo
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Oct_2013_16_09_56_+1100_QqQ9XaUpT29pM7xs--
