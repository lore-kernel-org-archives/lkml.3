Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3FLMaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:30:07 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:58951 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3FLMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:30:04 -0400
Date: Wed, 12 Jun 2013 14:30:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 07/12] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130612122959.GA32444@manwe>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
 <1365000318-28256-8-git-send-email-thierry.reding@avionic-design.de>
 <516C46BC.2040707@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <516C46BC.2040707@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2013 at 12:28:12PM -0600, Stephen Warren wrote:
> On 04/03/2013 08:45 AM, Thierry Reding wrote:
> > Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
> > directory. The motivation is to collect various host controller drivers
> > in the same location in order to facilitate refactoring.
> >=20
> > The Tegra PCIe driver has been largely rewritten, both in order to turn
> > it into a proper platform driver and to add MSI (based on code by
> > Krishna Kishore <kthota@nvidia.com>) as well as device tree support.
>=20
> > diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
>=20
> > +struct tegra_msi {
> > +	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
> > +	struct irq_domain *domain;
> > +	struct msi_chip chip;
>=20
> Nit: You could move that to be the first field in the struct, then
> to_tegra_msi() would end up being a no-op, which might save a byte or two.

Done.

> > +static int tegra_pcie_write_conf(struct pci_bus *bus, unsigned int dev=
fn,
> > +				 int where, int size, u32 value)
> ...
> > +	if (bus->number =3D=3D 0) {
> > +		unsigned int slot =3D PCI_SLOT(devfn);
> > +		struct tegra_pcie_port *port;
> > +
> > +		list_for_each_entry(port, &pcie->ports, list) {
> > +			if (port->index + 1 =3D=3D slot) {
> > +				addr =3D port->base + (where & ~3);
> > +				break;
> > +			}
> > +		}
> > +	} else {
> > +		addr =3D tegra_pcie_bus_map(pcie, bus->number);
> > +		if (!addr) {
> > +			dev_err(pcie->dev,
> > +				"failed to map cfg. space for bus %u\n",
> > +				bus->number);
> > +			return PCIBIOS_DEVICE_NOT_FOUND;
> > +		}
> > +
> > +		addr +=3D tegra_pcie_conf_offset(devfn, where);
> > +	}
>=20
> It seems like that chunk of code could be shared between
> tegra_pcie_read_conf() and tegra_pcie_write_conf().
>=20
> Also, tegra_pcie_read_conf() checks again for addr =3D=3D NULL and returns
> if so. read and write should be consistent.

Done.

> > +static void tegra_pcie_port_free(struct tegra_pcie_port *port)
> > +{
> > +	struct tegra_pcie *pcie =3D port->pcie;
> > +
> > +	devm_iounmap(pcie->dev, port->base);
> > +	devm_release_mem_region(pcie->dev, port->regs.start,
> > +				resource_size(&port->regs));
> > +	list_del(&port->list);
> > +	devm_kfree(pcie->dev, port);
> > +}
>=20
> Do ports get allocated and freed separately from the host controller,
> such that it's actually worth manually calling the
> devm_iounmap/release/free functions?

Yes, they can be freed separately. When a link is down and hence no
device is connected to the port, tegra_pcie_enable() will disable and
free that port.

That's in fact the only place where this is called because we don't
actually support removing the controller. I don't know of any ARM
architecture support to do that (i.e. there is no counterpart to
pci_common_init()).

> > +static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
> ...
> > +	/* disable all exceptions */
> > +	afi_writel(pcie, 0, AFI_FPCI_ERROR_MASKS);
>=20
> Is that a good idea?

I have no idea what that register means. It's one of the undocumented
registers. Note that I also didn't change this, it's been there since
the beginning.

It's probably worth finding out about the register's meaning and about
how to catch these exceptions at runtime, though. I'm adding Jay on Cc
maybe he can research internally.

> > +static int tegra_pcie_get_resources(struct tegra_pcie *pcie)
>=20
> > +	err =3D devm_request_irq(&pdev->dev, pcie->irq, tegra_pcie_isr,
> > +			       IRQF_SHARED, "PCIE", pcie);
>=20
> devm_request_irq and IRQF_SHARED sounds like a bad combination; what if
> the IRQ goes off after this driver's remove() is called, but before the
> driver core devm cleanup runs?

You're right. Changed to request_irq() in tegra_pcie_get_resources() and
added free_irq() to tegra_pcie_put_resources().

> > +static irqreturn_t tegra_pcie_msi_irq(int irq, void *data)
> ...
> > +	return IRQ_HANDLED;
>=20
> Shouldn't this function return IRQ_NONE if no MSI status bits were found
> set?

The IRQ isn't marked IRQF_SHARED, so I don't think this is needed.

> > +static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
>=20
> > +	/* setup AFI/FPCI range */
> > +	msi->pages =3D __get_free_pages(GFP_KERNEL, 3);
>=20
> If tegra_msi_setup_irq() hard-codes the MSI address as msi->pages, then
> I expect you can get away with a single page here. Of course, perhaps
> tegra_msi_setup_irq() is supposed to give a different address to every
> MSI client? Even so, 256 clients * 4 bytes is still less than 1 page.

Yes, I'll try setting the order to 0 and see if that still works. I
don't have a setup with more than one MSI client so test results may not
be very reliable, though.

> > +static u32 tegra_pcie_get_xbar_config(struct tegra_pcie *pcie, u32 lan=
es)
> > +{
> > +	struct device_node *np =3D pcie->dev->of_node;
> > +
> > +	switch (lanes) {
> > +	case 0x00000004:
> > +		dev_info(pcie->dev, "single-mode configuration\n");
> > +		return AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_SINGLE;
> > +
> > +	case 0x00000202:
> > +		dev_info(pcie->dev, "dual-mode configuration\n");
> > +		return AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL;
> > +	}
> > +
> > +	return 0;
>=20
> Shouldn't that return an error, and dev_err() about it? If not, then I
> think using one of the #defines for the default would make the result a
> lot more obvious.

I've changed tegra_pcie_get_xbar_config() to return -EINVAL if an
invalid combination of lanes is encountered and 0 otherwise, passing
back the corresponding define in an output parameter. I think it's
reasonable to fail if an invalid combination is provided instead of
assuming that some default will work.

> > +static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
>=20
> > +	pcie->xbar_config =3D tegra_pcie_get_xbar_config(pcie, lanes);
> > +	if (!pcie->xbar_config) {
> > +		dev_err(pcie->dev, "invalid lane configuration\n");
> > +		return -EINVAL;
> > +	}
>=20
> Oh, but AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_SINGLE=3D=3D0, which is valid=
=2E..

Fixed by the above change.

> > +static bool tegra_pcie_port_check_link(struct tegra_pcie_port *port)
> ...
> > +			if (value & 0x20000000)
> > +				return true;
>=20
> Can we use a #define for 0x20000000?

Yes, we could use something like RP_LINK_CONTROL_STATUS_DL_LINK_ACTIVE
=66rom the TRM, though it's rather long...

> > +static int tegra_pcie_enable(struct tegra_pcie *pcie)
> > +{
> > +	struct tegra_pcie_port *port, *tmp;
> > +	struct hw_pci hw;
> > +
> > +	list_for_each_entry_safe(port, tmp, &pcie->ports, list) {
> > +		dev_info(pcie->dev, "probing port %u, using %u lanes\n",
> > +			 port->index, port->lanes);
> > +
> > +		tegra_pcie_port_enable(port);
> > +
> > +		if (tegra_pcie_port_check_link(port))
> > +			continue;
> > +
> > +		dev_info(pcie->dev, "link %u down, ignoring\n", port->index);
> > +
> > +		tegra_pcie_port_disable(port);
> > +		tegra_pcie_port_free(port);
> > +	}
>=20
> Why is that needed; when would a port get enabled if it was already
> enabled, and if it was already enabled, wouldn't you want this function
> to be a no-op rather than destroying everything and starting again?

I'm not sure I understand what you're saying. The intent of this
function is to enable a port, check that there's a link and disable the
port otherwise. That way we don't keep ports around where nothing is
connected.

> > +static int tegra_pcie_probe(struct platform_device *pdev)
> ...
> > +	pcibios_min_mem =3D 0;
>=20
> What does that mean/do? I wonder if that should be set to 0x80000000 by
> the Tegra30 patches?

ARM defines PCIBIOS_MIN_MEM to that variable. That macro in turn is only
used by pci_bus_alloc_resource() AFAICT, which uses it to override the
start of a resource when allocating if res->start =3D=3D 0. As such it
designates a lower-bound of valid PCI memory addresses, so 0 on Tegra20
and 0x80000000 on Tegra30 don't seem like good values. Maybe we need to
set them to the lowest of the prefetchable and non-prefetchable memory
areas as defined in the DT?

It doesn't currently seem to matter at all, though, since we never pass
in a range that's 0, so the start address of resources can never be 0
and therefore PCIBIOS_MIN_MEM is never used.

Thierry

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRuGnHAAoJEN0jrNd/PrOhZ2wP+wbfTMwHj/mzIsEJIqwVu7/k
wFUPRPld364uIEmYSTJ9cjyriEBhK/gR1dinm9jCLD70JEwpkfULAArx6k2IJfKJ
MvUnyXD5ArSXX7W712Q8rc4+X6j/Oen36WBKmw/ZtBQ0BPSMTVgEs2vMsaMCoyOL
K8s352nsJrVX2WKfNs52ZJlZqHc5zl/DWH5Gf4JPIPqrXLftR5c+BqqJF6/5gB2s
T3kvvJzgpKhPIATkYaes9BdBDW48s30kZ/Yj8c9BVPV5ocYaBv0JWDNTYH+t2XYD
p91p60uk3piaCtDM+gQlkTDCrq54hUugj+C+HSyHb/jDT2nl/PYTUQo5P1Nj3VLz
gXVUmcXWFQvHO4ZpSa5bLkl+HPC3sFcN3GpG/bZlrumSm/794BgPC6Mo4lCkn0Tg
BJqixhbyIfpGSfzTDPWurZLQbj1oWqK3VqjFq0SODdjaanLwQvMGQwiOaep37aks
6RXBLP60CLS53Vi2rsxIfWJG2zZhGVPxwcao9ZwD3PNOSwq0WvTZzne2EpABaLTa
VSylIqAXFc4qjLBWjzQvXZFQJvP09wh6RitiLx1mWX1GVs8zX1fu4Z3lMV9jadzT
mhqCrDxlYnn+qjo4NfT1dZ1U/67a2WGQHSaC30nQABv8jtRusKucQE+ndyPO+DOE
gAK6HB/goOgi/nD/RehW
=jWNR
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
