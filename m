Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3BFFZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:25:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49358 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3BFFZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:25:26 -0500
Date: Wed, 6 Feb 2013 16:25:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: linux-next: manual merge of the driver-core tree with the iommu
 tree
Message-Id: <20130206162523.c338c51f0d5fc31b20245184@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Feb_2013_16_25_23_+1100_NFNsrPGA=yOxlu3."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Feb_2013_16_25_23_+1100_NFNsrPGA=yOxlu3.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/iommu/tegra-smmu.c between commit a6870e928d1b ("iommu/tegra:
smmu: Support variable MMIO ranges/blocks") from the iommu tree and
commit bc5e6dea81b0 ("iommu: Convert to devm_ioremap_resource()") from
the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/iommu/tegra-smmu.c
index 7747283,f08dbcd..0000000
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@@ -1185,13 -1177,10 +1186,13 @@@ static int tegra_smmu_probe(struct plat
  		res =3D platform_get_resource(pdev, IORESOURCE_MEM, i);
  		if (!res)
  			return -ENODEV;
- 		smmu->regs[i] =3D devm_request_and_ioremap(&pdev->dev, res);
- 		if (!smmu->regs[i])
- 			return -EBUSY;
+ 		smmu->regs[i] =3D devm_ioremap_resource(&pdev->dev, res);
+ 		if (IS_ERR(smmu->regs[i]))
+ 			return PTR_ERR(smmu->regs[i]);
 +		smmu->rege[i] =3D smmu->regs[i] + resource_size(res) - 1;
  	}
 +	/* Same as "mc" 1st regiter block start address */
 +	smmu->regbase =3D (void __iomem *)((u32)smmu->regs[0] & ~PAGE_MASK);
 =20
  	err =3D of_get_dma_window(dev->of_node, NULL, 0, NULL, &base, &size);
  	if (err)

--Signature=_Wed__6_Feb_2013_16_25_23_+1100_NFNsrPGA=yOxlu3.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREelDAAoJEECxmPOUX5FEx3AP/jLH/ff3IWH2WSSO3gZPw7bS
xzILoitnOWd7jw6Bm5waA5diKP0pwEBWKLYQ9ZfJwPzSjMf4FVbg+jreI70El5Ah
myJgA5mvUnjORQo/U/9w3IYZtORFACwfkjOMqfo3dM1cgXnQxCnL7lj9venGwuUg
n/+QSRv05R3BnRxOU8KGCJ+iNHU1tnXcgQLDE1jh8Ea4aJWzieV0Fsil3TIEzVZp
Ie25yurqLGh8g6GC/Ra75KVgibvqLvzs9llXiArIKseB4pmLbAmbSULphkdSwDjM
XzUvLf/pz2Lc5sq5fzU6BMio4HnYaOMoXL6i5FPjH7G5Xx1PJY3EZjOYbC/69GO9
MwhDUgkMdkbVz6v90iaY+q529x+kZuVwKHWyF5VWeq8jxi5IvezD4DBpBIXB7zAC
ZD/G+sNesDdF5epfuvkiyOZyf/YObujJZvuBeSIFLbbnpgT+/EP63WrpdTC+FHQE
rqmJFPdJyJ2UUfpaNSgdRhIY/3rHPa5UAQIocGaIKPWS0Ffo/ARbWGmw/8BKNp6V
ckDpc/TenMMAw8SqT/6D5QMc2IYKSxMgD3vOd+Em/D8F4M5+dKT7plzoghWj+j9Y
62m8W/FOcDeLw6CNIV2uTI16uxDpUw33USqqmLMy5lryTQqNI5InL9bKcGCAhGlR
OoLxke2s1gCPpagOgqd/
=A99c
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Feb_2013_16_25_23_+1100_NFNsrPGA=yOxlu3.--
