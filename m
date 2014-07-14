Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaGNO35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:29:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59319 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbaGNO3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:29:49 -0400
Message-ID: <53C3E905.3080806@ti.com>
Date: Mon, 14 Jul 2014 10:28:21 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Pratyush Anand <pratyush.anand@st.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v4 0/6] Add Keystone PCIe controller driver
References: <1405110995-24676-1-git-send-email-m-karicheri2@ti.com> <20140714060334.GB2930@pratyush-vbox>
In-Reply-To: <20140714060334.GB2930@pratyush-vbox>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 02:03 AM, Pratyush Anand wrote:
> Oh.. I see my reply from gmail is not readable at all. (I forgot to
> switch to plain text :( ) Please ignore last mail I am replying again
> here.
>
> On Sat, Jul 12, 2014 at 04:36:29AM +0800, Murali Karicheri wrote:
>
> [...]
>
>> Murali Karicheri (6):
>>    PCI: designware: add rd[wr]_other_conf API
>>    PCI: designware: refactor MSI code to work with v3.65 dw hardware
>
> For  above two you can add my reviewed-by:
>
>>    PCI: designware: refactor host init code to re-use on keystone PCI
>>    PCI: designware: enhance dw core driver to support keystone PCI host
>
> In stead of using version number and then changing few functions from
> static to global , I would have used same philosophy of adding callbacks
> wherever needed. May be maintainers can give their view, instead of patch
> 3 and 4 I would have gone with something like this, where kc_pcie can be
> passed through pp->plat_data.
>

Pratyush,

Thanks for the response. I will look into your proposal and respond back 
when I get a chance.

Thanks and regards,

Murali

> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 905941c..b216192 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -490,16 +490,21 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>          }
>
>          if (IS_ENABLED(CONFIG_PCI_MSI)) {
> -               pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
> -                                       MAX_MSI_IRQS,&msi_domain_ops,
> -&dw_pcie_msi_chip);
> -               if (!pp->irq_domain) {
> -                       dev_err(pp->dev, "irq domain init failed\n");
> -                       return -ENXIO;
> -               }
> +               if (!pp->ops->msi_init) {
> +                       pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
> +                                               MAX_MSI_IRQS,&msi_domain_ops,
> +&dw_pcie_msi_chip);
> +                       if (!pp->irq_domain) {
> +                               dev_err(pp->dev, "irq domain init failed\n");
> +                               return -ENXIO;
> +                       }
>
> -               for (i = 0; i<  MAX_MSI_IRQS; i++)
> -                       irq_create_mapping(pp->irq_domain, i);
> +                       for (i = 0; i<  MAX_MSI_IRQS; i++)
> +                               irq_create_mapping(pp->irq_domain, i);
> +               } else {
> +                       pp->ops->msi_init(pp,&msi_domain_ops,
> +&dw_pcie_msi_chip);
> +               }
>          }
>
>          if (pp->ops->host_init)
> @@ -759,6 +764,9 @@ static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
>                  BUG();
>          }
>
> +       if (bus&&  pp->ops->scan_bus)
> +               bus = pp->ops->scan_bus(pp);
> +
>          return bus;
>   }
>
> diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> index 387f69e..39ce496 100644
> --- a/drivers/pci/host/pcie-designware.h
> +++ b/drivers/pci/host/pcie-designware.h
> @@ -52,6 +52,7 @@ struct pcie_port {
>          struct irq_domain       *irq_domain;
>          unsigned long           msi_data;
>          DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
> +       void                    *plat_data;
>   };
>
>   struct pcie_host_ops {
> @@ -70,6 +71,9 @@ struct pcie_host_ops {
>          void (*msi_set_irq)(struct pcie_port *pp, int irq);
>          void (*msi_clear_irq)(struct pcie_port *pp, int irq);
>          u32 (*get_msi_data)(struct pcie_port *pp);
> +       struct pci_bus *(*scan_bus)(struct pcie_port *pp);
> +       void (*msi_init) (struct pcie_port *pp, struct irq_domain_ops *ops,
> +                       struct msi_chip *chip);
>   };
>
>   int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
>
>
> ~Pratyush

