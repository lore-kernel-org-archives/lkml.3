Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3HWIgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:36:10 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:51505 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755033Ab3HWIgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:36:06 -0400
Date: Fri, 23 Aug 2013 14:05:39 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH V2] PCI: exynos: add support for MSI
Message-ID: <20130823083539.GB3937@pratyush-vbox>
References: <003d01ce9fc6$9c0f1c20$d42d5460$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <003d01ce9fc6$9c0f1c20$d42d5460$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 02:04:20PM +0800, Jingoo Han wrote:
> This patch adds support for Message Signaled Interrupt in the
> Exynos PCIe diver using Synopsys designware PCIe core IP.
> 
> Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> Signed-off-by: Srikanth T Shivanand <ts.srikanth@samsung.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Pratyush Anand <pratyush.anand@st.com>
> Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> ---
> Changes since v1:
> - removed unnecessary exynos_pcie_clear_irq_level()
> - updated the bindings documentation
> - used new msi_chip infrastructure
> - removed ARCH_SUPPORTS_MSI
> - replaced #ifdef guards with IS_ENABLED(CONFIG_PCI_MSI)
> 
>  .../devicetree/bindings/pci/designware-pcie.txt    |    2 +
>  arch/arm/boot/dts/exynos5440.dtsi                  |    2 +
>  drivers/pci/host/pci-exynos.c                      |   47 ++++
>  drivers/pci/host/pcie-designware.c                 |  225 ++++++++++++++++++++
>  drivers/pci/host/pcie-designware.h                 |    4 +
>  5 files changed, 280 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> index eabcb4b..00bb935 100644

[...]

> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 77b0c25..a4fed11 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -11,8 +11,10 @@
>   * published by the Free Software Foundation.
>   */
> 
> +#include <linux/irq.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/msi.h>
>  #include <linux/of_address.h>
>  #include <linux/pci.h>
>  #include <linux/pci_regs.h>
> @@ -62,6 +64,12 @@
>  #define PCIE_ATU_FUNC(x)               (((x) & 0x7) << 16)
>  #define PCIE_ATU_UPPER_TARGET          0x91C
> 
> +#define MAX_MSI_IRQS                   32

DW MSI controller can support upto 256. However, 32 seems a practical
choice, as there might not be any system which may use more
than 32. But a comment like as follows can be put here:

/*
* Maximum number of MSI IRQs can be 256 per controller. But keep
* it 32 as of now. Probably we will never need more than 32. If needed,
* then increment it in multiple of 32.
*/

> +#define MAX_MSI_CTRLS                  8

Why to waste cpu cycles when MAX_MSI_IRQS is 32 only.
#define MAX_MSI_CTRLS   (MAX_MSI_IRQS / 32)

> +
> +static unsigned int msi_data;
> +static DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);

What if one has more than one RC.
There are SOCs which support 3 RCs.
So something like this:

#define MAX_PCIE_PORT_SUPPORTED 3
static DECLARE_BITMAP(msi_irq_in_use[MAX_PCIE_PORT_SUPPORTED],
                  NUM_MSI_IRQS);
static unsigned int *msi_data[MAX_PCIE_PORT_SUPPORTED];

Allocate msi_data using __get_free_pages(GFP_KERNEL, 0)) as Thierry
suggested.

> +
>  static struct hw_pci dw_pci;
> 
>  unsigned long global_io_offset;
> @@ -144,6 +152,205 @@ int dw_pcie_wr_own_conf(struct pcie_port *pp, int where, int size,
>         return ret;
>  }
> 

[...]

>  int dw_pcie_link_up(struct pcie_port *pp)
>  {
>         if (pp->ops->link_up)
> @@ -225,6 +432,13 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>                 return -EINVAL;
>         }
> 
> +       if (IS_ENABLED(CONFIG_PCI_MSI)) {
> +               if (of_property_read_u32(np, "msi-base", &pp->msi_irq_start)) {
> +                       dev_err(pp->dev, "Failed to parse the number of lanes\n");
> +                       return -EINVAL;
> +               }
> +       }
> +

What if an implementor want to use irq_domain method for msi_irq_start
allocation? Is it fine to return error if msi-base is not passed from
dt?

Also, with the limited knowledge of dt I do not understand one thing, how
would dt understand that you have used 32 msi irqs (MAX_MSI_IRQS)?

Regards
Pratyush
