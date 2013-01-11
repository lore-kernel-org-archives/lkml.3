Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3AKDwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 22:52:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3AKDww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 22:52:52 -0500
Date: Fri, 11 Jan 2013 04:52:46 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130111035246.GB28094@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
 <50EF616E.7040609@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <50EF616E.7040609@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:UqiMxL2AJW1MEfrQx0jzDAP852YV6p0SWT+JHLwH20s
 5bTzURDNZN6q8HqN0YmJwR+j24CrlX+v4/qhd1xT4Ngw3cKC8i
 50OwBnLEKY1jNXlFL6J+iElJOcOAkkFFqjZ4knFP1ZQMfAYJoZ
 3LZoY99/GrigTvNJbThDQS2FmAl7ZAHC6CZnCGVNr7gneSqOXf
 fPoB3EDo5GU298aD+UIWWX0LTUWaR0IgR1vO2RBm0ePmBsEwD/
 KNhBrAKc/HmxQmAMI+vq1Y6IzUlxK9IHEqeBY8399qjpr58T0D
 2QM9s+6wx3/wOnT8y0n67FPUZ3AotzRikOF/pU0i8QHbi2oOYR
 H7D4nWMLX64wfAaVrzP9Fi7NADQNjvq9lMLarSMyzmu5OK+h+n
 94F2ie1T8HhwEa1Pv0rwsTdf6yt5HS1SrY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 05:48:46PM -0700, Stephen Warren wrote:
> On 01/09/2013 01:43 PM, Thierry Reding wrote:
> > Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
> > directory. The motivation is to collect various host controller drivers
> > in the same location in order to facilitate refactoring.
> >=20
> > The Tegra PCIe driver has been largely rewritten, both in order to turn
> > it into a proper platform driver and to add MSI (based on code by
> > Krishna Kishore <kthota@nvidia.com>) as well as device tree support.
>=20
> > diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-teg=
ra/board-dt-tegra20.c
>=20
> >  static void __init trimslice_init(void)
> >  {
> >  #ifdef CONFIG_TEGRA_PCI
> > -	int ret;
> > -
> > -	ret =3D tegra_pcie_init(true, true);
> > -	if (ret)
> > -		pr_err("tegra_pci_init() failed: %d\n", ret);
> > +	platform_device_register(&tegra_pcie_device);
>=20
> That struct doesn't actually exist anywhere; only an extern definition
> is added (and that extern definition isn't removed by patch 14 either).

Right, this shouldn't be there. In fact TEGRA_PCI is removed by this
patch, so I should go over the code more carefully again.

> > diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
>=20
> > +config PCI_TEGRA
> > +	bool "NVIDIA Tegra PCIe controller"
> > +	depends on ARCH_TEGRA_2x_SOC
>=20
> Perhaps depend on ARCH_TEGRA; that will save churn once this is ported
> to Tegra30, and shouldn't cause any problems before then.

Okay, I can do that.

> > diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
>=20
> > +#define AFI_INTR_CODE		0xb8
> > +#define  AFI_INTR_CODE_MASK	0xf
> > +#define  AFI_INTR_MASTER_ABORT	4
> > +#define  AFI_INTR_LEGACY	6
>=20
> Adding defines for at least some other codes here, would help further
> below ...
>=20
> > +static irqreturn_t tegra_pcie_isr(int irq, void *arg)
>=20
> > +	if (code =3D=3D AFI_INTR_MASTER_ABORT) {
> > +		dev_dbg(pcie->dev, "%s, signature: %08x\n", err_msg[code],
> > +			signature);
> > +	} else
> > +		dev_err(pcie->dev, "%s, signature: %08x\n", err_msg[code],
> > +			signature);
> > +
> > +	if (code =3D=3D 3 || code =3D=3D 4 || code =3D=3D 7) {
>=20
> ... i.e. here.

Will do.

>=20
> > +		u32 fpci =3D afi_readl(pcie, AFI_UPPER_FPCI_ADDRESS) & 0xff;
> > +		u64 address =3D (u64)fpci << 32 | (signature & 0xfffffffc);
> > +		dev_dbg(pcie->dev, "  FPCI address: %10llx\n", address);
>=20
> I'd suggest making that dev_err(), or at least something higher than
> debug, since the message indicating the error happened is dev_err(), so
> the complete details may as well be available since they're small.

I can make it conditional on !AFI_INTR_MASTER_ABORT to match the
previous output. Or rather move it into the branches above.

> > +static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
> > +{
> > +	unsigned int timeout;
> > +	unsigned long value;
> > +
> > +	/* enable dual controller and both ports */
> > +	value =3D afi_readl(pcie, AFI_PCIE_CONFIG);
> > +	value &=3D ~(AFI_PCIE_CONFIG_PCIEC0_DISABLE_DEVICE |
> > +		   AFI_PCIE_CONFIG_PCIEC1_DISABLE_DEVICE |
> > +		   AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK);
> > +	value |=3D AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL;
> > +	afi_writel(pcie, value, AFI_PCIE_CONFIG);
>=20
> Eventually, we should probably derive the port enables from the state of
> the root port DT nodes, so that we can disable some and presumably save
> a little power. Also, I notice that the nvidia,num-lanes property isn't
> implemented yet. Still, we can probably take care of this later.

Yes, the plan was to eventually derive the disable bits from the port
status and setup the XBAR_CONFIG field based on the combination of
nvidia,num-lanes properties.

I assume we should simply fail if the configuration specified by
nvidia,num-lanes is invalid?

> > +static void tegra_pcie_power_off(struct tegra_pcie *pcie)
>=20
> > +	if (!IS_ERR_OR_NULL(pcie->pex_clk_supply)) {
>=20
> Hmm. I think we should make supplies mandatory; it doesn't make sense
> for regulator support to be disabled on Tegra, and where a specific
> board doesn't actually have a regulator, you're supposed to provide a
> dummy fixed regulator so the driver doesn't have to care.
>=20
> The same comment obviously applies to tegra_pcie_power_on() and wherever
> regulator_get() happens.

Okay, I'll fix that.

> > +static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
>=20
> > +	pcie->vdd_supply =3D devm_regulator_get(pcie->dev, "vdd");
> > +	if (IS_ERR(pcie->vdd_supply))
> > +		return PTR_ERR(pcie->vdd_supply);
> > +
> > +	pcie->pex_clk_supply =3D devm_regulator_get(pcie->dev, "pex-clk");
> > +	if (IS_ERR(pcie->pex_clk_supply))
> > +		return PTR_ERR(pcie->pex_clk_supply);
>=20
> Oh, I guess the regulator_get() calls are already strict.

Yeah, I think they can't return NULL, right? In that case I can just
drop the extra checks in tegra_pcie_power_{on,off}().

> > +static int tegra_pcie_add_port(struct tegra_pcie *pcie, struct device_=
node *np)
>=20
> > +	port =3D devm_kzalloc(pcie->dev, sizeof(*port), GFP_KERNEL);
> > +	if (!port)
> > +		return -ENOMEM;
> > +
> > +	INIT_LIST_HEAD(&port->list);
> > +	port->index =3D index;
> > +	port->pcie =3D pcie;
> > +
> > +	port->base =3D devm_request_and_ioremap(pcie->dev, &regs);
> > +	if (!port->base)
> > +		return -EADDRNOTAVAIL;
> > +
> > +	if (!tegra_pcie_port_check_link(port)) {
> > +		dev_info(pcie->dev, "link %u down, ignoring\n", port->index);
>=20
> Perhaps devm_kfree(port)? Not a big leak, but equally if you don't, it's
> an unreferenced memory block.

I suppose I should do devm_iounmap() and devm_release_mem_region() as
well.

Thanks for reviewing!
Thierry

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ74yOAAoJEN0jrNd/PrOhmK8P/AwZxUIN1cnwe6eHZlEB5owu
yd4xrGsPRsk2WP08LZlpGBbaRDWTmTuS0j2KDnncH1C+31CSTi6p0UzzE7PTfyKv
oeF3ECJeamq4BTDw/+ryuvGP2Kk+acszUbScx1DCw+/+GiY4lWapSYpQCwinQp5S
AIA3R4i7hzAQWeFwdFfKPvOb0o9HrsRFG/IhZm85Kld6Sr07H7G8BkzaPu1dMm8t
oJGnBe/Qh8ub3fA9xuczLOmkFukl57XH8SlfnOyhoMnEQlrNamB/YA+IXcTp+eIG
njqla+giXK24iabvqQZz9sJhLkNQcUYHdUSckSIz7dk4isMgNv8xUhVl7FK6ZlNe
P7iYq0sTF3YIRyu4kHiZjVHL6bzx5jS2hGtzSRn0rTC12xpIt0YHpneS775dTl1T
5gM/6Le0IHR1H752o7A/OsvhjqOvuv4Lw6OobkzDvbkCgrX7Zz+R1z2ckN+96jjN
AxhXOG65WS6LdOgCxy7+K8nplCv4LpKjpRtDBe57T+BZ30GrJ9NFKsjvqRnoR62r
URGoMxrLyekzEDShaxfULJ6OpPfxOVao8ZaLO8LRzH+JtQY7ksiXS9x7iqysFqzw
Z4O+L38Oje/3UqHH/E2MVinU/ZLa8OGAJu5ibfBbeneLPK4D3uD8YUlrztumLe1d
57J+EMGmOb5lLIKfQvJ5
=Y7Y5
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
