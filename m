Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaLHHtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:49:20 -0500
Received: from ozlabs.org ([103.22.144.67]:48905 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbaLHHtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:49:18 -0500
Date: Mon, 8 Dec 2014 18:49:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: linux-next: manual merge of the xen-tip tree with the arm-soc tree
Message-ID: <20141208184908.27bfd605@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/keqifRXUMrFmd1v=HZ4il08"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/keqifRXUMrFmd1v=HZ4il08
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen-tip tree got a conflict in
arch/arm/include/asm/dma-mapping.h between commits a3a60f81ee6f
("dma-mapping: replace set_arch_dma_coherent_ops with
arch_setup_dma_ops") and 4bb25789ed28 ("arm: dma-mapping: plumb our
iommu mapping ops into arch_setup_dma_ops") from the arm-soc tree and
commit 3d5391ac6f5e ("arm: introduce is_device_dma_coherent") from the
xen-tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

I also neede this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 8 Dec 2014 18:46:59 +1100
Subject: [PATCH] arm: introduce is_device_dma_coherent merge fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mm/dma-mapping.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 09645f00bd17..43064cbe58f9 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -2058,6 +2058,7 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_b=
ase, u64 size,
 	else
 		dma_ops =3D arm_get_dma_map_ops(coherent);
=20
+	dev->archdata.dma_coherent =3D coherent;
 	set_dma_ops(dev, dma_ops);
 }
=20
--=20
2.1.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/dma-mapping.h
index 9410b7e548fc,e6e3446abdf6..000000000000
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@@ -121,13 -121,20 +121,19 @@@ static inline unsigned long dma_max_pfn
  }
  #define dma_max_pfn(dev) dma_max_pfn(dev)
 =20
 -static inline int set_arch_dma_coherent_ops(struct device *dev)
 -{
 -	dev->archdata.dma_coherent =3D true;
 -	set_dma_ops(dev, &arm_coherent_dma_ops);
 -	return 0;
 -}
 -#define set_arch_dma_coherent_ops(dev)	set_arch_dma_coherent_ops(dev)
 +#define arch_setup_dma_ops arch_setup_dma_ops
 +extern void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 +			       struct iommu_ops *iommu, bool coherent);
 +
 +#define arch_teardown_dma_ops arch_teardown_dma_ops
 +extern void arch_teardown_dma_ops(struct device *dev);
 =20
+ /* do not use this function in a driver */
+ static inline bool is_device_dma_coherent(struct device *dev)
+ {
+ 	return dev->archdata.dma_coherent;
+ }
+=20
  static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t padd=
r)
  {
  	unsigned int offset =3D paddr & ~PAGE_MASK;

--Sig_/keqifRXUMrFmd1v=HZ4il08
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhVf8AAoJEMDTa8Ir7ZwVauYQAJaFQg2K5pLKsuzWje2mAv2r
P2fggQQrBBFC7MO8aWRlJlaz2i9kzkOOIZoJC5sIgSiWIWYptw8K8FPwh78UDHKh
YOXnlVSclL5KP35pok6sqIBNVpjug3DvNlP4ruIQu1BvSne7UZIhlLaLSDlCp7Lj
qybnlefodPOoJOLVOYwI+R2Wa0rhhNbM62PwySPvsvE004VjmdKDQqZvuTrlcezD
Tir3kGgnLkMp+pEVIPfdbkoWZqAjMpKHfRJ/cGM13As4A7BT9kbcI23Duh3Fhb5w
0+qJQW5rOYx/eeJAjKuCCDorcoXaRGNOrd1zKAFbf53HAn4ex/CDd3+/jpsOa0jU
JndBOIjjLcezwQyZZuU+T7Dxdtb/1dVxspLCiRsCkDv9dmljPaY6zDm7LYTIeAbV
+tKTgiPjC79Z7F18H/p2+VSDG9Y9+1A5S/4V+mbTyZdiHnUfKSLsFX1TKmlzQi78
8N99ki0aFKG1t9lHRZs1hfKhqWTLl/Z6I/XfL9i2mQ9talG0loFAzOorCHPy42X3
mpJf4ufiCWnKMJrBmh2mrnRBOQKyjjm9paNQ/LM2ip/9pBdMyl8MEooYGlD68xmG
HhJJeWQjXoU+Xxj8IxUWEG2LO1np55NuqJlzwJaiZ9rjl7zJ0pQAaCogjWdXicP6
k46Vdrjllr2oHULIaBoW
=AIpA
-----END PGP SIGNATURE-----

--Sig_/keqifRXUMrFmd1v=HZ4il08--
