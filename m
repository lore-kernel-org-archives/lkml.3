Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3HNGWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 02:22:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58281 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3HNGWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 02:22:36 -0400
Date: Wed, 14 Aug 2013 16:22:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: linux-next: manual merge of the mvebu tree with the pci tree
Message-Id: <20130814162233.9265a6c8feaaabd0b690985c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Aug_2013_16_22_33_+1000_IoOe9yTT_JbqAU=M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Aug_2013_16_22_33_+1000_IoOe9yTT_JbqAU=M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
drivers/pci/host/pci-mvebu.c between commit f48fbf9c7e89 ("PCI: mvebu:
Convert to use devm_ioremap_resource") from the pci tree and commit
826727641b2a ("PCI: mvebu: move clock enable before register access")
from the mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/host/pci-mvebu.c
index ce1543a,88c6790..0000000
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@@ -725,12 -741,71 +741,71 @@@ static void __iomem *mvebu_pcie_map_reg
 =20
  	ret =3D of_address_to_resource(np, 0, &regs);
  	if (ret)
 -		return NULL;
 +		return ERR_PTR(ret);
 =20
 -	return devm_request_and_ioremap(&pdev->dev, &regs);
 +	return devm_ioremap_resource(&pdev->dev, &regs);
  }
 =20
- static int __init mvebu_pcie_probe(struct platform_device *pdev)
+ #define DT_FLAGS_TO_TYPE(flags)       (((flags) >> 24) & 0x03)
+ #define    DT_TYPE_IO                 0x1
+ #define    DT_TYPE_MEM32              0x2
+ #define DT_CPUADDR_TO_TARGET(cpuaddr) (((cpuaddr) >> 56) & 0xFF)
+ #define DT_CPUADDR_TO_ATTR(cpuaddr)   (((cpuaddr) >> 48) & 0xFF)
+=20
+ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
+ 			      unsigned long type, int *tgt, int *attr)
+ {
+ 	const int na =3D 3, ns =3D 2;
+ 	const __be32 *range;
+ 	int rlen, nranges, rangesz, pna, i;
+=20
+ 	range =3D of_get_property(np, "ranges", &rlen);
+ 	if (!range)
+ 		return -EINVAL;
+=20
+ 	pna =3D of_n_addr_cells(np);
+ 	rangesz =3D pna + na + ns;
+ 	nranges =3D rlen / sizeof(__be32) / rangesz;
+=20
+ 	for (i =3D 0; i < nranges; i++) {
+ 		u32 flags =3D of_read_number(range, 1);
+ 		u32 slot =3D of_read_number(range, 2);
+ 		u64 cpuaddr =3D of_read_number(range + na, pna);
+ 		unsigned long rtype;
+=20
+ 		if (DT_FLAGS_TO_TYPE(flags) =3D=3D DT_TYPE_IO)
+ 			rtype =3D IORESOURCE_IO;
+ 		else if (DT_FLAGS_TO_TYPE(flags) =3D=3D DT_TYPE_MEM32)
+ 			rtype =3D IORESOURCE_MEM;
+=20
+ 		if (slot =3D=3D PCI_SLOT(devfn) && type =3D=3D rtype) {
+ 			*tgt =3D DT_CPUADDR_TO_TARGET(cpuaddr);
+ 			*attr =3D DT_CPUADDR_TO_ATTR(cpuaddr);
+ 			return 0;
+ 		}
+=20
+ 		range +=3D rangesz;
+ 	}
+=20
+ 	return -ENOENT;
+ }
+=20
+ static void mvebu_pcie_msi_enable(struct mvebu_pcie *pcie)
+ {
+ 	struct device_node *msi_node;
+=20
+ 	msi_node =3D of_parse_phandle(pcie->pdev->dev.of_node,
+ 				    "msi-parent", 0);
+ 	if (!msi_node)
+ 		return;
+=20
+ 	pcie->msi =3D of_pci_find_msi_chip_by_node(msi_node);
+=20
+ 	if (pcie->msi)
+ 		pcie->msi->dev =3D &pcie->pdev->dev;
+ }
+=20
+ static int mvebu_pcie_probe(struct platform_device *pdev)
  {
  	struct mvebu_pcie *pcie;
  	struct device_node *np =3D pdev->dev.of_node;
@@@ -816,11 -888,62 +888,63 @@@
  		if (port->devfn < 0)
  			continue;
 =20
+ 		ret =3D mvebu_get_tgt_attr(np, port->devfn, IORESOURCE_MEM,
+ 					 &port->mem_target, &port->mem_attr);
+ 		if (ret < 0) {
+ 			dev_err(&pdev->dev, "PCIe%d.%d: cannot get tgt/attr for mem window\n",
+ 				port->port, port->lane);
+ 			continue;
+ 		}
+=20
+ 		ret =3D mvebu_get_tgt_attr(np, port->devfn, IORESOURCE_IO,
+ 					 &port->io_target, &port->io_attr);
+ 		if (ret < 0) {
+ 			dev_err(&pdev->dev, "PCIe%d.%d: cannot get tgt/attr for io window\n",
+ 				port->port, port->lane);
+ 			continue;
+ 		}
+=20
+ 		port->reset_gpio =3D of_get_named_gpio_flags(child,
+ 						   "reset-gpios", 0, &flags);
+ 		if (gpio_is_valid(port->reset_gpio)) {
+ 			u32 reset_udelay =3D 20000;
+=20
+ 			port->reset_active_low =3D flags & OF_GPIO_ACTIVE_LOW;
+ 			port->reset_name =3D kasprintf(GFP_KERNEL,
+ 				     "pcie%d.%d-reset", port->port, port->lane);
+ 			of_property_read_u32(child, "reset-delay-us",
+ 					     &reset_udelay);
+=20
+ 			ret =3D devm_gpio_request_one(&pdev->dev,
+ 			    port->reset_gpio, GPIOF_DIR_OUT, port->reset_name);
+ 			if (ret) {
+ 				if (ret =3D=3D -EPROBE_DEFER)
+ 					return ret;
+ 				continue;
+ 			}
+=20
+ 			gpio_set_value(port->reset_gpio,
+ 				       (port->reset_active_low) ? 1 : 0);
+ 			udelay(reset_udelay);
+ 		}
+=20
+ 		port->clk =3D of_clk_get_by_name(child, NULL);
+ 		if (IS_ERR(port->clk)) {
+ 			dev_err(&pdev->dev, "PCIe%d.%d: cannot get clock\n",
+ 			       port->port, port->lane);
+ 			continue;
+ 		}
+=20
+ 		ret =3D clk_prepare_enable(port->clk);
+ 		if (ret)
+ 			continue;
+=20
  		port->base =3D mvebu_pcie_map_registers(pdev, child, port);
 -		if (!port->base) {
 +		if (IS_ERR(port->base)) {
  			dev_err(&pdev->dev, "PCIe%d.%d: cannot map registers\n",
  				port->port, port->lane);
+ 			clk_disable_unprepare(port->clk);
 +			port->base =3D NULL;
  			continue;
  		}
 =20

--Signature=_Wed__14_Aug_2013_16_22_33_+1000_IoOe9yTT_JbqAU=M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCyIpAAoJEECxmPOUX5FEf0EP/1f3/4akMyJPyqh3m0lLJyI5
3P6Y1WlwQgdVX1wPwW3GnxgHyWQZ9LIxPxPIGerxJw9G5ouluUbixwlfefvswo5Z
oFTej8EqQgDn2g0/0WxJNtawpdh5oPSyScXJ74N4wl5Gs079Q1g8Lle2KpOpyYgK
t8Scn1jDcL8qMlNU9cVWPmTmI5l2p8WWQMnyKwH59u0h7+ofeq5QNnkMx73zsMVI
Og5LfvBTyPB03HHMUr5ilyxm+SQZctEu34n7Pt2cH+Zw/Bvocd3UqT3MRaLGuZeY
Rk7y3F4psBdr6X8vgl/XrkYh/nhamU/fwJ4AXv3pTJdtOEnA40alKrOltqXdScmd
3KJTwO//sKlh6jXqyWPgTIrBpz0YmHEF+VzuhM9AbYtrL1JlEh7qkFucF+nPPa5K
LufmpACqTNZt8uCoIkRyx3uXlsCpNRFSp/5E1QkEP3dVNDP9xZnqb29yXWW9eQ5C
L1Cuyh4frfpBaav7bUL1n7RY0eoAlooWLMR/CtRBQ4RGVuuxM7VPlXzcTnZX7zio
f1lq/80ZISs2CRVzN2QrjDjALwlN8y0rNcuVWp4iTKtjdXN4NTOW+GdRRjWiIBQC
2CcvEb78uxmz955KKdVAyckzIRShnr+kuT/+FBD+GNYxLiq5wKHBC+WVyrz0AsMl
o49OrvP4yOHPY5IMOK5k
=NJ7v
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Aug_2013_16_22_33_+1000_IoOe9yTT_JbqAU=M--
