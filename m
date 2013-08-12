Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3HLK4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:56:48 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:58110 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab3HLK4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:56:44 -0400
Date: Mon, 12 Aug 2013 12:56:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] PCI: exynos: add support for MSI
Message-ID: <20130812105638.GA12042@ulmo>
References: <000401ce9739$e0a65410$a1f2fc30$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <000401ce9739$e0a65410$a1f2fc30$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 05:56:47PM +0900, Jingoo Han wrote:
[...]
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 855d4a7..9ef1c95 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -93,6 +93,7 @@ config SOC_EXYNOS5440
>  	default y
>  	depends on ARCH_EXYNOS5
>  	select ARCH_HAS_OPP
> +	select ARCH_SUPPORTS_MSI

This symbol goes away in Thomas Petazzoni's MSI patch series which is
targetted at 3.12, so I don't think you should add that here.

> +#ifdef CONFIG_PCI_MSI
> +static void exynos_pcie_clear_irq_level(struct pcie_port *pp)
> +{
> +	u32 val;
> +	struct exynos_pcie *exynos_pcie =3D to_exynos_pcie(pp);
> +	void __iomem *elbi_base =3D exynos_pcie->elbi_base;
> +
> +	val =3D readl(elbi_base + PCIE_IRQ_LEVEL);
> +	writel(val, elbi_base + PCIE_IRQ_LEVEL);
> +	return;
> +}

I'm a little confused by this: the above code seems to access the PCIe
controller registers to clear an interrupt, but you pass in a PCIe
port...

> +static irqreturn_t exynos_pcie_msi_irq_handler(int irq, void *arg)
> +{
> +	struct pcie_port *pp =3D arg;
> +
> +	/* handle msi irq */
> +	dw_handle_msi_irq(pp);
> +	exynos_pcie_clear_irq_level(pp);

=2E.. so here dw_handle_msi_irq() seems to operate on a single port, while
clearing the IRQ is done on a per-controller basis.

I see that the Exynos PCIe driver hasn't made it into linux-next yet, so
I don't have full context surrounding this, but it strikes me as odd
that MSI's would be handled per-port instead of per-controller. And
furthermore that the DesignWare part handles it per-port yet the Exynos
specific part handles it per-controller.

> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void exynos_pcie_msi_init(struct pcie_port *pp)
> +{
> +	u32 val;
> +	struct exynos_pcie *exynos_pcie =3D to_exynos_pcie(pp);
> +	void __iomem *elbi_base =3D exynos_pcie->elbi_base;
> +
> +	dw_pcie_msi_init(pp);
> +
> +	/* enable MSI interrupt */
> +	val =3D readl(elbi_base + PCIE_IRQ_EN_LEVEL);
> +	val |=3D IRQ_MSI_ENABLE;
> +	writel(val, elbi_base + PCIE_IRQ_EN_LEVEL);
> +	return;
> +}

This function is called per-port, yet operates on per-controller
registers. It's not terribly bad in this case because it only sets one
bit, but it could eventually lead to problems in case you need to extend
this function in the future to do more, which could then potentially be
run multiple times and cause problems.

> +#endif
> +
>  static void exynos_pcie_enable_interrupts(struct pcie_port *pp)
>  {
>  	exynos_pcie_enable_irq_pulse(pp);
> +#ifdef CONFIG_PCI_MSI
> +	exynos_pcie_msi_init(pp);
> +#endif
>  	return;
>  }

Instead of the whole #ifdef business above, can't you just use something
like this in exynos_pcie_enable_interrupts():

	if (IS_ENABLED(CONFIG_PCI_MSI))
		exynos_pcie_msi_init(pp);

Now you can drop the #ifdef guards and the compiler will throw away all
the related code automatically if PCI_MSI is not selected because the
functions are all static and unused. This has the advantage of compiling
all the code whether or not PCI_MSI is selected or not, therefore
increasing compile coverage of the driver.

> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-d=
esignware.c
[...]
> @@ -62,6 +64,14 @@
>  #define PCIE_ATU_FUNC(x)		(((x) & 0x7) << 16)
>  #define PCIE_ATU_UPPER_TARGET		0x91C
> =20
> +#ifdef CONFIG_PCI_MSI
> +#define MAX_MSI_IRQS			32
> +#define MAX_MSI_CTRLS			8
> +
> +static unsigned int msi_data;
> +static DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
> +#endif
> +
>  static struct hw_pci dw_pci;
> =20
>  unsigned long global_io_offset;
> @@ -144,6 +154,202 @@ int dw_pcie_wr_own_conf(struct pcie_port *pp, int w=
here, int size,
>  	return ret;
>  }
> =20
> +#ifdef CONFIG_PCI_MSI
> +static struct irq_chip dw_msi_chip =3D {
> +	.name =3D "PCI-MSI",
> +	.irq_enable =3D unmask_msi_irq,
> +	.irq_disable =3D mask_msi_irq,
> +	.irq_mask =3D mask_msi_irq,
> +	.irq_unmask =3D unmask_msi_irq,
> +};
> +
> +/* MSI int handler */
> +void dw_handle_msi_irq(struct pcie_port *pp)
> +{
> +	unsigned long val;
> +	int i, pos;
> +
> +	for (i =3D 0; i < MAX_MSI_CTRLS; i++) {
> +		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_STATUS + i * 12, 4,
> +				(u32 *)&val);
> +		if (val) {
> +			pos =3D 0;
> +			while ((pos =3D find_next_bit(&val, 32, pos)) !=3D 32) {
> +				generic_handle_irq(pp->msi_irq_start
> +					+ (i * 32) + pos);
> +				pos++;
> +			}
> +		}
> +		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_STATUS + i * 12, 4, val);
> +	}
> +}
> +
> +void dw_pcie_msi_init(struct pcie_port *pp)
> +{
> +	/* program the msi_data */
> +	dw_pcie_wr_own_conf(pp, PCIE_MSI_ADDR_LO, 4,
> +			__virt_to_phys((u32)(&msi_data)));

That's slightly odd. You convert the virtual address of a local variable
(local to the file) to a physical address and program that into a
register. I assume that it works since you've probably tested this, but
I wonder if it's safe to do this. Perhaps a better way would be to
allocate a single free page (__get_free_pages(GFP_KERNEL, 0)) and write
the physical address of that into the register instead.

> +static int find_valid_pos0(int msgvec, int pos, int *pos0)
> +{
> +	int flag =3D 1;
> +
> +	do {
> +		pos =3D find_next_zero_bit(msi_irq_in_use,
> +				MAX_MSI_IRQS, pos);
> +		/*if you have reached to the end then get out from here.*/
> +		if (pos =3D=3D MAX_MSI_IRQS)
> +			return -ENOSPC;
> +		/*
> +		 * Check if this position is at correct offset.nvec is always a
> +		 * power of two. pos0 must be nvec bit alligned.
> +		 */
> +		if (pos % msgvec)
> +			pos +=3D msgvec - (pos % msgvec);
> +		else
> +			flag =3D 0;
> +	} while (flag);
> +
> +	*pos0 =3D pos;
> +	return 0;
> +}
> +
> +/* Dynamic irq allocate and deallocation */
> +static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
> +{
> +	int res, bit, irq, pos0, pos1, i;
> +	u32 val;
> +	struct pcie_port *pp =3D sys_to_pcie(desc->dev->bus->sysdata);
> +
> +	if (!pp) {
> +		BUG();
> +		return -EINVAL;
> +	}
> +
> +	pos0 =3D find_first_zero_bit(msi_irq_in_use,
> +			MAX_MSI_IRQS);
> +	if (pos0 % no_irqs) {
> +		if (find_valid_pos0(no_irqs, pos0, &pos0))
> +			goto no_valid_irq;
> +	}
> +	if (no_irqs > 1) {
> +		pos1 =3D find_next_bit(msi_irq_in_use,
> +				MAX_MSI_IRQS, pos0);
> +		/* there must be nvec number of consecutive free bits */
> +		while ((pos1 - pos0) < no_irqs) {
> +			if (find_valid_pos0(no_irqs, pos1, &pos0))
> +				goto no_valid_irq;
> +			pos1 =3D find_next_bit(msi_irq_in_use,
> +					MAX_MSI_IRQS, pos0);
> +		}
> +	}
> +
> +	irq =3D (pp->msi_irq_start + pos0);
> +
> +	if ((irq + no_irqs) > (pp->msi_irq_start + MAX_MSI_IRQS-1))
> +		goto no_valid_irq;
> +
> +	i =3D 0;
> +	while (i < no_irqs) {
> +		set_bit(pos0 + i, msi_irq_in_use);
> +		irq_alloc_descs((irq + i), (irq + i), 1, 0);
> +		irq_set_msi_desc(irq + i, desc);
> +		irq_set_chip_and_handler(irq + i, &dw_msi_chip,
> +					handle_simple_irq);
> +		set_irq_flags(irq + i, IRQF_VALID);
> +		/*Enable corresponding interrupt in MSI interrupt controller */
> +		res =3D ((pos0 + i) / 32) * 12;
> +		bit =3D (pos0 + i) % 32;
> +		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
> +		val |=3D 1 << bit;
> +		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
> +		i++;
> +	}
> +
> +	*pos =3D pos0;
> +	return irq;
> +
> +no_valid_irq:
> +	*pos =3D pos0;
> +	return -ENOSPC;
> +}

There was some discussion about this already, and I think eventually we
really should refactor some of this code. Currently all three ARM PCIe
drivers (Marvell, Tegra and Exynos/DesignWare) use a similar bitmap-
based allocator for this. Benjamin Herrenschmidt pointed out that the
same exists for PowerPC as well, so we should look at converging on one
implementation eventually. But I think that can be done subsequently and
shouldn't have to be done prior to this patch.

> +static void clear_irq(unsigned int irq)
> +{
> +	int res, bit, val, pos;
> +	struct irq_desc *desc;
> +	struct msi_desc *msi;
> +	struct pcie_port *pp;
> +
> +	/* get the port structure */
> +	desc =3D irq_to_desc(irq);
> +	msi =3D irq_desc_get_msi_desc(desc);
> +	pp =3D sys_to_pcie(msi->dev->bus->sysdata);
> +	if (!pp) {
> +		BUG();
> +		return;
> +	}
> +
> +	pos =3D irq - pp->msi_irq_start;
> +
> +	irq_free_desc(irq);
> +
> +	clear_bit(pos, msi_irq_in_use);
> +
> +	/* Disable corresponding interrupt on MSI interrupt controller */
> +	res =3D (pos / 32) * 12;
> +	bit =3D pos % 32;
> +	dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
> +	val &=3D ~(1 << bit);
> +	dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
> +}

Oh, and you should probably look into using an IRQ domain for the MSI
support in this driver.

> +int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
> +{
> +	int irq, pos, msgvec;
> +	u16 msg_ctr;
> +	struct msi_msg msg;
> +	struct pcie_port *pp =3D sys_to_pcie(pdev->bus->sysdata);
> +
> +	if (!pp) {
> +		BUG();
> +		return -EINVAL;
> +	}
> +
> +	pci_read_config_word(pdev, desc->msi_attrib.pos+PCI_MSI_FLAGS,
> +				&msg_ctr);
> +	msgvec =3D (msg_ctr&PCI_MSI_FLAGS_QSIZE) >> 4;
> +	if (msgvec =3D=3D 0)
> +		msgvec =3D (msg_ctr & PCI_MSI_FLAGS_QMASK) >> 1;
> +	if (msgvec > 5)
> +		msgvec =3D 0;
> +
> +	irq =3D assign_irq((1 << msgvec), desc, &pos);
> +	if (irq < 0)
> +		return irq;
> +
> +	msg_ctr &=3D ~PCI_MSI_FLAGS_QSIZE;
> +	msg_ctr |=3D msgvec << 4;
> +	pci_write_config_word(pdev, desc->msi_attrib.pos + PCI_MSI_FLAGS,
> +				msg_ctr);
> +	desc->msi_attrib.multiple =3D msgvec;
> +
> +	msg.address_hi =3D 0x0;
> +	msg.address_lo =3D __virt_to_phys((u32)(&msi_data));
> +	msg.data =3D pos;
> +	write_msi_msg(irq, &msg);
> +
> +	return 0;
> +}
> +
> +void arch_teardown_msi_irq(unsigned int irq)
> +{
> +	clear_irq(irq);
> +}

And we've reworked this largely so that drivers no longer provide arch_*
functions because that prevents multi-platform support. So I think you
need to port this to the new msi_chip infrastructure that's being
introduced in 3.12.

Thierry

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCL9mAAoJEN0jrNd/PrOhZIkQAIfxv5CTrvUkm3DyzsSr32Ld
BPQYmkPdMhflyAmZGi46zX3MjQSpkh96esbg7NS2VBHtkzvMwWFPriPalNmguh2u
bxqpdhlcMiaiXOO0NusQD49fuo6LnkOWEptq4htV3K/HtHdaQzGEuU8ZGJ68KRW1
EOnrSDEdLSOlvJ2V/SBdWJvvrTB9Sf3WEZ964Qkwk2CZURqr9Z7WyNZVaPzQKI7R
1XshUYRMlFu+7oXIeMReiGX6/wO9w0s333FooB1LQg7SDVlVp5k+0c0gYfNSCu1p
3HJL5MeBWRHMMQMwxI5zCzhQ7/MY6P868mW5n2ynspnZMjvi6sgYKB5yob+b0llg
pKpO2BY3LSbAdFZnCkiDtKjWxHPSjAGRQ7kt/bQ9loW65aEoz4Dkc/ovHYaQj4OX
pPpAHCCtn139tBQFIG2cP1L5u8OT25udCpOphX2lXNGLPIBel/KpZ2nyUStjx3pX
JHNbqsn9GA6Bumo6S6XySaIXfqtrlURv3LVAHdZlXplqbkclV5nuDZRSI7Ut4WsR
4b/P20gvbjLrpD9+S9iYZonOKZK2VodY8fI78Ris5y8ZKOROlFYbfX52kL9dyaYo
SNdNCmT57WOkxJelYA4JKUu6wkBAUQllIy22ObbiFUNkmJSf/sfgA90k2lAoDann
e29JF7FJDbFPOtq9LwWM
=u3Re
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
