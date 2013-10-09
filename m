Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3JIPQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:16:51 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37349 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3JIPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <000a01cec4eb$942dc7f0$bc8957d0$%han@samsung.com>
References: <000a01cec4eb$942dc7f0$bc8957d0$%han@samsung.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Oct 2013 09:16:27 -0600
Message-ID: <CAErSpo6fuT8Gj0dG59ptH801H3UbLh0bymEYUFhf9p8XX3zCNw@mail.gmail.com>
Subject: Re: [PATCH V2] PCI: designware: Add irq_create_mapping()
To: Jingoo Han <jg1.han@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        SRIKANTH TUMKUR SHIVANAND <ts.srikanth@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sean Cross <xobs@kosagi.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 6:32 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> From: Pratyush Anand <pratyush.anand@st.com>
>
> Without irq_create_mapping(), the correct irq number cannot be
> provided. In this case, it makes problems such as NULL deference.
> Thus, irq_create_mapping() should be added for MSI.
>
> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> Suggested-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Applied to my pci/host-exynos branch for v3.13, thanks!

Bjorn

> ---
> Tested on Exynos5440.
>
>  drivers/pci/host/pcie-designware.c |   25 +++++++++++++------------
>  drivers/pci/host/pcie-designware.h |    2 +-
>  2 files changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 8963017..92d58fd 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -157,7 +157,7 @@ static struct irq_chip dw_msi_irq_chip = {
>  void dw_handle_msi_irq(struct pcie_port *pp)
>  {
>         unsigned long val;
> -       int i, pos;
> +       int i, pos, irq;
>
>         for (i = 0; i < MAX_MSI_CTRLS; i++) {
>                 dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_STATUS + i * 12, 4,
> @@ -165,8 +165,9 @@ void dw_handle_msi_irq(struct pcie_port *pp)
>                 if (val) {
>                         pos = 0;
>                         while ((pos = find_next_bit(&val, 32, pos)) != 32) {
> -                               generic_handle_irq(pp->msi_irq_start
> -                                       + (i * 32) + pos);
> +                               irq = irq_find_mapping(pp->irq_domain,
> +                                               i * 32 + pos);
> +                               generic_handle_irq(irq);
>                                 pos++;
>                         }
>                 }
> @@ -237,9 +238,8 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
>                 }
>         }
>
> -       irq = (pp->msi_irq_start + pos0);
> -
> -       if ((irq + no_irqs) > (pp->msi_irq_start + MAX_MSI_IRQS-1))
> +       irq = irq_find_mapping(pp->irq_domain, pos0);
> +       if (!irq)
>                 goto no_valid_irq;
>
>         i = 0;
> @@ -270,6 +270,7 @@ static void clear_irq(unsigned int irq)
>         struct irq_desc *desc;
>         struct msi_desc *msi;
>         struct pcie_port *pp;
> +       struct irq_data *data = irq_get_irq_data(irq);
>
>         /* get the port structure */
>         desc = irq_to_desc(irq);
> @@ -280,7 +281,7 @@ static void clear_irq(unsigned int irq)
>                 return;
>         }
>
> -       pos = irq - pp->msi_irq_start;
> +       pos = data->hwirq;
>
>         irq_free_desc(irq);
>
> @@ -371,8 +372,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>         struct of_pci_range range;
>         struct of_pci_range_parser parser;
>         u32 val;
> -
> -       struct irq_domain *irq_domain;
> +       int i;
>
>         if (of_pci_range_parser_init(&parser, np)) {
>                 dev_err(pp->dev, "missing ranges property\n");
> @@ -441,15 +441,16 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>         }
>
>         if (IS_ENABLED(CONFIG_PCI_MSI)) {
> -               irq_domain = irq_domain_add_linear(pp->dev->of_node,
> +               pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
>                                         MAX_MSI_IRQS, &msi_domain_ops,
>                                         &dw_pcie_msi_chip);
> -               if (!irq_domain) {
> +               if (!pp->irq_domain) {
>                         dev_err(pp->dev, "irq domain init failed\n");
>                         return -ENXIO;
>                 }
>
> -               pp->msi_irq_start = irq_find_mapping(irq_domain, 0);
> +               for (i = 0; i < MAX_MSI_IRQS; i++)
> +                       irq_create_mapping(pp->irq_domain, i);
>         }
>
>         if (pp->ops->host_init)
> diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> index faccbbf..1bf9fc5 100644
> --- a/drivers/pci/host/pcie-designware.h
> +++ b/drivers/pci/host/pcie-designware.h
> @@ -47,7 +47,7 @@ struct pcie_port {
>         u32                     lanes;
>         struct pcie_host_ops    *ops;
>         int                     msi_irq;
> -       int                     msi_irq_start;
> +       struct irq_domain       *irq_domain;
>         unsigned long           msi_data;
>         DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
>  };
> --
> 1.7.10.4
>
>
