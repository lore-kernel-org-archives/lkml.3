Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3JHGXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:23:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38239 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab3JHGXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:23:42 -0400
Message-ID: <5253A4DA.7090306@ti.com>
Date: Tue, 8 Oct 2013 11:53:22 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH V3] PCI: exynos: add support for MSI
References: <001a01ceaace$013ec980$03bc5c80$%han@samsung.com>
In-Reply-To: <001a01ceaace$013ec980$03bc5c80$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Friday 06 September 2013 12:24 PM, Jingoo Han wrote:
> This patch adds support for Message Signaled Interrupt in the
> Exynos PCIe diver using Synopsys designware PCIe core IP.
> 
> Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> Signed-off-by: Srikanth T Shivanand <ts.srikanth@samsung.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Pratyush Anand <pratyush.anand@st.com>
> Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> ---
> Changes since v2:
> - fixed MAX_MSI_CTRLS because MAX_MSI_IRQS is 32 only
> - used __get_free_pages() to allocate msi_data
> - used one msi_data and msi_irq_in_use per one RC
> - used irq_domain to represent the MSI controller
> - removed msi-base irq number from device tree because this is not
>   a hardware property.
> 
> Changes since v1:
> - removed unnecessary exynos_pcie_clear_irq_level()
> - updated the bindings documentation
> - used new msi_chip infrastructure
> - removed ARCH_SUPPORTS_MSI
> - replaced #ifdef guards with IS_ENABLED(CONFIG_PCI_MSI)
> 
>  drivers/pci/host/pci-exynos.c      |   44 +++++++
>  drivers/pci/host/pcie-designware.c |  240 ++++++++++++++++++++++++++++++++++++
>  drivers/pci/host/pcie-designware.h |   14 +++
>  3 files changed, 298 insertions(+)
> 
> diff --git a/drivers/pci/host/pci-exynos.c b/drivers/pci/host/pci-exynos.c
> index 94e096b..f062aca 100644
> --- a/drivers/pci/host/pci-exynos.c
> +++ b/drivers/pci/host/pci-exynos.c
> @@ -48,6 +48,7 @@ struct exynos_pcie {
>  #define PCIE_IRQ_SPECIAL		0x008
>  #define PCIE_IRQ_EN_PULSE		0x00c
>  #define PCIE_IRQ_EN_LEVEL		0x010
> +#define IRQ_MSI_ENABLE			(0x1 << 2)
>  #define PCIE_IRQ_EN_SPECIAL		0x014
>  #define PCIE_PWR_RESET			0x018
>  #define PCIE_CORE_RESET			0x01c
> @@ -342,9 +343,36 @@ static irqreturn_t exynos_pcie_irq_handler(int irq, void *arg)
>  	return IRQ_HANDLED;
>  }
>  
> +static irqreturn_t exynos_pcie_msi_irq_handler(int irq, void *arg)
> +{
> +	struct pcie_port *pp = arg;
> +
> +	dw_handle_msi_irq(pp);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void exynos_pcie_msi_init(struct pcie_port *pp)
> +{
> +	u32 val;
> +	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
> +
> +	dw_pcie_msi_init(pp);
> +
> +	/* enable MSI interrupt */
> +	val = exynos_elb_readl(exynos_pcie, PCIE_IRQ_EN_LEVEL);
> +	val |= IRQ_MSI_ENABLE;
> +	exynos_elb_writel(exynos_pcie, val, PCIE_IRQ_EN_LEVEL);
> +	return;
> +}
> +
>  static void exynos_pcie_enable_interrupts(struct pcie_port *pp)
>  {
>  	exynos_pcie_enable_irq_pulse(pp);
> +
> +	if (IS_ENABLED(CONFIG_PCI_MSI))
> +		exynos_pcie_msi_init(pp);
> +
>  	return;
>  }
>  
> @@ -430,6 +458,22 @@ static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
>  		return ret;
>  	}
>  
> +	if (IS_ENABLED(CONFIG_PCI_MSI)) {
> +		pp->msi_irq = platform_get_irq(pdev, 0);
> +		if (!pp->msi_irq) {
> +			dev_err(&pdev->dev, "failed to get msi irq\n");
> +			return -ENODEV;
> +		}
> +
> +		ret = devm_request_irq(&pdev->dev, pp->msi_irq,
> +					exynos_pcie_msi_irq_handler,
> +					IRQF_SHARED, "exynos-pcie", pp);
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to request msi irq\n");
> +			return ret;
> +		}
> +	}
> +
>  	pp->root_bus_nr = -1;
>  	pp->ops = &exynos_pcie_host_ops;
>  
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index c10e9ac..8963017 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -11,8 +11,11 @@
>   * published by the Free Software Foundation.
>   */
>  
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/msi.h>
>  #include <linux/of_address.h>
>  #include <linux/pci.h>
>  #include <linux/pci_regs.h>
> @@ -142,6 +145,204 @@ int dw_pcie_wr_own_conf(struct pcie_port *pp, int where, int size,
>  	return ret;
>  }
>  
> +static struct irq_chip dw_msi_irq_chip = {
> +	.name = "PCI-MSI",
> +	.irq_enable = unmask_msi_irq,
> +	.irq_disable = mask_msi_irq,
> +	.irq_mask = mask_msi_irq,
> +	.irq_unmask = unmask_msi_irq,
> +};
> +
> +/* MSI int handler */
> +void dw_handle_msi_irq(struct pcie_port *pp)
> +{
> +	unsigned long val;
> +	int i, pos;
> +
> +	for (i = 0; i < MAX_MSI_CTRLS; i++) {
> +		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_STATUS + i * 12, 4,
> +				(u32 *)&val);
> +		if (val) {
> +			pos = 0;
> +			while ((pos = find_next_bit(&val, 32, pos)) != 32) {
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
> +	pp->msi_data = __get_free_pages(GFP_KERNEL, 0);
> +
> +	/* program the msi_data */
> +	dw_pcie_wr_own_conf(pp, PCIE_MSI_ADDR_LO, 4,
> +			virt_to_phys((void *)pp->msi_data));
> +	dw_pcie_wr_own_conf(pp, PCIE_MSI_ADDR_HI, 4, 0);
> +}
> +
> +static int find_valid_pos0(struct pcie_port *pp, int msgvec, int pos, int *pos0)
> +{
> +	int flag = 1;
> +
> +	do {
> +		pos = find_next_zero_bit(pp->msi_irq_in_use,
> +				MAX_MSI_IRQS, pos);
> +		/*if you have reached to the end then get out from here.*/
> +		if (pos == MAX_MSI_IRQS)
> +			return -ENOSPC;
> +		/*
> +		 * Check if this position is at correct offset.nvec is always a
> +		 * power of two. pos0 must be nvec bit alligned.
> +		 */
> +		if (pos % msgvec)
> +			pos += msgvec - (pos % msgvec);
> +		else
> +			flag = 0;
> +	} while (flag);
> +
> +	*pos0 = pos;
> +	return 0;
> +}
> +
> +static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
> +{
> +	int res, bit, irq, pos0, pos1, i;
> +	u32 val;
> +	struct pcie_port *pp = sys_to_pcie(desc->dev->bus->sysdata);
> +
> +	if (!pp) {
> +		BUG();
> +		return -EINVAL;
> +	}
> +
> +	pos0 = find_first_zero_bit(pp->msi_irq_in_use,
> +			MAX_MSI_IRQS);
> +	if (pos0 % no_irqs) {
> +		if (find_valid_pos0(pp, no_irqs, pos0, &pos0))
> +			goto no_valid_irq;
> +	}
> +	if (no_irqs > 1) {
> +		pos1 = find_next_bit(pp->msi_irq_in_use,
> +				MAX_MSI_IRQS, pos0);
> +		/* there must be nvec number of consecutive free bits */
> +		while ((pos1 - pos0) < no_irqs) {
> +			if (find_valid_pos0(pp, no_irqs, pos1, &pos0))
> +				goto no_valid_irq;
> +			pos1 = find_next_bit(pp->msi_irq_in_use,
> +					MAX_MSI_IRQS, pos0);
> +		}
> +	}
> +
> +	irq = (pp->msi_irq_start + pos0);
> +
> +	if ((irq + no_irqs) > (pp->msi_irq_start + MAX_MSI_IRQS-1))
> +		goto no_valid_irq;
> +
> +	i = 0;
> +	while (i < no_irqs) {
> +		set_bit(pos0 + i, pp->msi_irq_in_use);
> +		irq_alloc_descs((irq + i), (irq + i), 1, 0);
> +		irq_set_msi_desc(irq + i, desc);
> +		/*Enable corresponding interrupt in MSI interrupt controller */
> +		res = ((pos0 + i) / 32) * 12;
> +		bit = (pos0 + i) % 32;
> +		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
> +		val |= 1 << bit;
> +		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
> +		i++;
> +	}
> +
> +	*pos = pos0;
> +	return irq;
> +
> +no_valid_irq:
> +	*pos = pos0;
> +	return -ENOSPC;
> +}
> +
> +static void clear_irq(unsigned int irq)
> +{
> +	int res, bit, val, pos;
> +	struct irq_desc *desc;
> +	struct msi_desc *msi;
> +	struct pcie_port *pp;
> +
> +	/* get the port structure */
> +	desc = irq_to_desc(irq);
> +	msi = irq_desc_get_msi_desc(desc);
> +	pp = sys_to_pcie(msi->dev->bus->sysdata);
> +	if (!pp) {
> +		BUG();
> +		return;
> +	}
> +
> +	pos = irq - pp->msi_irq_start;
> +
> +	irq_free_desc(irq);
> +
> +	clear_bit(pos, pp->msi_irq_in_use);
> +
> +	/* Disable corresponding interrupt on MSI interrupt controller */
> +	res = (pos / 32) * 12;
> +	bit = pos % 32;
> +	dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
> +	val &= ~(1 << bit);
> +	dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
> +}
> +
> +static int dw_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
> +			struct msi_desc *desc)
> +{
> +	int irq, pos, msgvec;
> +	u16 msg_ctr;
> +	struct msi_msg msg;
> +	struct pcie_port *pp = sys_to_pcie(pdev->bus->sysdata);
> +
> +	if (!pp) {
> +		BUG();
> +		return -EINVAL;
> +	}
> +
> +	pci_read_config_word(pdev, desc->msi_attrib.pos+PCI_MSI_FLAGS,
> +				&msg_ctr);
> +	msgvec = (msg_ctr&PCI_MSI_FLAGS_QSIZE) >> 4;
> +	if (msgvec == 0)
> +		msgvec = (msg_ctr & PCI_MSI_FLAGS_QMASK) >> 1;
> +	if (msgvec > 5)
> +		msgvec = 0;
> +
> +	irq = assign_irq((1 << msgvec), desc, &pos);
> +	if (irq < 0)
> +		return irq;
> +
> +	msg_ctr &= ~PCI_MSI_FLAGS_QSIZE;
> +	msg_ctr |= msgvec << 4;
> +	pci_write_config_word(pdev, desc->msi_attrib.pos + PCI_MSI_FLAGS,
> +				msg_ctr);
> +	desc->msi_attrib.multiple = msgvec;
> +
> +	msg.address_lo = virt_to_phys((void *)pp->msi_data);
> +	msg.address_hi = 0x0;
> +	msg.data = pos;
> +	write_msi_msg(irq, &msg);
> +
> +	return 0;
> +}
> +
> +static void dw_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
> +{
> +	clear_irq(irq);
> +}
> +
> +static struct msi_chip dw_pcie_msi_chip = {
> +	.setup_irq = dw_msi_setup_irq,
> +	.teardown_irq = dw_msi_teardown_irq,
> +};
> +
>  int dw_pcie_link_up(struct pcie_port *pp)
>  {
>  	if (pp->ops->link_up)
> @@ -150,6 +351,20 @@ int dw_pcie_link_up(struct pcie_port *pp)
>  		return 0;
>  }
>  
> +static int dw_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
> +			irq_hw_number_t hwirq)
> +{
> +	irq_set_chip_and_handler(irq, &dw_msi_irq_chip, handle_simple_irq);
> +	irq_set_chip_data(irq, domain->host_data);
> +	set_irq_flags(irq, IRQF_VALID);
> +
> +	return 0;
> +}
> +
> +static const struct irq_domain_ops msi_domain_ops = {
> +	.map = dw_pcie_msi_map,
> +};
> +
>  int __init dw_pcie_host_init(struct pcie_port *pp)
>  {
>  	struct device_node *np = pp->dev->of_node;
> @@ -157,6 +372,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  	struct of_pci_range_parser parser;
>  	u32 val;
>  
> +	struct irq_domain *irq_domain;
> +
>  	if (of_pci_range_parser_init(&parser, np)) {
>  		dev_err(pp->dev, "missing ranges property\n");
>  		return -EINVAL;
> @@ -223,6 +440,18 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  		return -EINVAL;
>  	}
>  
> +	if (IS_ENABLED(CONFIG_PCI_MSI)) {
> +		irq_domain = irq_domain_add_linear(pp->dev->of_node,
> +					MAX_MSI_IRQS, &msi_domain_ops,
> +					&dw_pcie_msi_chip);
> +		if (!irq_domain) {
> +			dev_err(pp->dev, "irq domain init failed\n");
> +			return -ENXIO;
> +		}
> +
> +		pp->msi_irq_start = irq_find_mapping(irq_domain, 0);

Where is the irq_create_mapping done for this irq domain? Is that not needed?
Without that I'm not getting the correct irq number.

Thanks
Kishon
