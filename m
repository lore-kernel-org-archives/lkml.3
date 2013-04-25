Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3DYTJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:09:11 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:61997 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063Ab3DYTJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:09:09 -0400
MIME-Version: 1.0
In-Reply-To: <1366883360-14061-2-git-send-email-Andrew.Murray@arm.com>
References: <1366883360-14061-1-git-send-email-Andrew.Murray@arm.com> <1366883360-14061-2-git-send-email-Andrew.Murray@arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Apr 2013 13:08:48 -0600
Message-ID: <CAErSpo6+v_xAdEw+4Qg--QLXzG8B8UPK=eBLsoT8-dZi6xatGA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] powerpc: Move struct pci_controller to asm-generic
To: Andrew Murray <Andrew.Murray@arm.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        microblaze-uclinux@itee.uq.edu.au,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 3:49 AM, Andrew Murray <Andrew.Murray@arm.com> wrote:
> This patch moves struct pci_controller into asm-generic to allow
> for use by other architectures thus reducing code duplication in
> the kernel.
>
> Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> ---
>  arch/powerpc/include/asm/pci-bridge.h |   87 +++++---------------------------
>  include/asm-generic/pci-bridge.h      |   68 +++++++++++++++++++++++++
>  2 files changed, 82 insertions(+), 73 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
> index 205bfba..163bd40 100644
> --- a/arch/powerpc/include/asm/pci-bridge.h
> +++ b/arch/powerpc/include/asm/pci-bridge.h
> @@ -8,7 +8,6 @@
>   * 2 of the License, or (at your option) any later version.
>   */
>  #include <linux/pci.h>
> -#include <linux/list.h>
>  #include <linux/ioport.h>
>  #include <linux/of_pci.h>
>  #include <asm-generic/pci-bridge.h>
> @@ -16,85 +15,27 @@
>  struct device_node;
>
>  /*
> - * Structure of a PCI controller (host bridge)
> + * Used for variants of PCI indirect handling and possible quirks:
> + *  SET_CFG_TYPE - used on 4xx or any PHB that does explicit type0/1
> + *  EXT_REG - provides access to PCI-e extended registers
> + *  SURPRESS_PRIMARY_BUS - we suppress the setting of PCI_PRIMARY_BUS

s/SURPRESS/SUPRESS/ throughout.

I'm not sure how generic these flags will end up being.  If they wind
up in a shared header file, it seems like we might want a PCI_ prefix
to anchor them.

> + *   on Freescale PCI-e controllers since they used the PCI_PRIMARY_BUS
> + *   to determine which bus number to match on when generating type0
> + *   config cycles
> + *  NO_PCIE_LINK - the Freescale PCI-e controllers have issues with
> + *   hanging if we don't have link and try to do config cycles to
> + *   anything but the PHB.  Only allow talking to the PHB if this is
> + *   set.
> + *  BIG_ENDIAN - cfg_addr is a big endian register
> + *  BROKEN_MRM - the 440EPx/GRx chips have an errata that causes hangs on
> + *   the PLB4.  Effectively disable MRM commands by setting this.
>   */
> -struct pci_controller {
> -       struct pci_bus *bus;
> -       char is_dynamic;
> -#ifdef CONFIG_PPC64
> -       int node;
> -#endif
> -       struct device_node *dn;
> -       struct list_head list_node;
> -       struct device *parent;
> -
> -       int first_busno;
> -       int last_busno;
> -       int self_busno;
> -       struct resource busn;
> -
> -       void __iomem *io_base_virt;
> -#ifdef CONFIG_PPC64
> -       void *io_base_alloc;
> -#endif
> -       resource_size_t io_base_phys;
> -       resource_size_t pci_io_size;
> -
> -       /* Some machines (PReP) have a non 1:1 mapping of
> -        * the PCI memory space in the CPU bus space
> -        */
> -       resource_size_t pci_mem_offset;
> -
> -       /* Some machines have a special region to forward the ISA
> -        * "memory" cycles such as VGA memory regions. Left to 0
> -        * if unsupported
> -        */
> -       resource_size_t isa_mem_phys;
> -       resource_size_t isa_mem_size;
> -
> -       struct pci_ops *ops;
> -       unsigned int __iomem *cfg_addr;
> -       void __iomem *cfg_data;
> -
> -       /*
> -        * Used for variants of PCI indirect handling and possible quirks:
> -        *  SET_CFG_TYPE - used on 4xx or any PHB that does explicit type0/1
> -        *  EXT_REG - provides access to PCI-e extended registers
> -        *  SURPRESS_PRIMARY_BUS - we suppress the setting of PCI_PRIMARY_BUS
> -        *   on Freescale PCI-e controllers since they used the PCI_PRIMARY_BUS
> -        *   to determine which bus number to match on when generating type0
> -        *   config cycles
> -        *  NO_PCIE_LINK - the Freescale PCI-e controllers have issues with
> -        *   hanging if we don't have link and try to do config cycles to
> -        *   anything but the PHB.  Only allow talking to the PHB if this is
> -        *   set.
> -        *  BIG_ENDIAN - cfg_addr is a big endian register
> -        *  BROKEN_MRM - the 440EPx/GRx chips have an errata that causes hangs on
> -        *   the PLB4.  Effectively disable MRM commands by setting this.
> -        */
>  #define PPC_INDIRECT_TYPE_SET_CFG_TYPE         0x00000001
>  #define PPC_INDIRECT_TYPE_EXT_REG              0x00000002
>  #define PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS 0x00000004
>  #define PPC_INDIRECT_TYPE_NO_PCIE_LINK         0x00000008
>  #define PPC_INDIRECT_TYPE_BIG_ENDIAN           0x00000010
>  #define PPC_INDIRECT_TYPE_BROKEN_MRM           0x00000020
> -       u32 indirect_type;
> -       /* Currently, we limit ourselves to 1 IO range and 3 mem
> -        * ranges since the common pci_bus structure can't handle more
> -        */
> -       struct resource io_resource;
> -       struct resource mem_resources[3];
> -       int global_number;              /* PCI domain number */
> -
> -       resource_size_t dma_window_base_cur;
> -       resource_size_t dma_window_size;
> -
> -#ifdef CONFIG_PPC64
> -       unsigned long buid;
> -
> -       void *private_data;
> -#endif /* CONFIG_PPC64 */
> -};
>
>  /* These are used for config access before all the PCI probing
>     has been done. */
> diff --git a/include/asm-generic/pci-bridge.h b/include/asm-generic/pci-bridge.h
> index 20db2e5..e58830e 100644
> --- a/include/asm-generic/pci-bridge.h
> +++ b/include/asm-generic/pci-bridge.h
> @@ -9,6 +9,9 @@
>
>  #ifdef __KERNEL__
>
> +#include <linux/pci.h>
> +#include <linux/list.h>
> +
>  enum {
>         /* Force re-assigning all resources (ignore firmware
>          * setup completely)
> @@ -38,6 +41,71 @@ enum {
>         PCI_SCAN_ALL_PCIE_DEVS  = 0x00000040,
>  };
>
> +struct device_node;
> +
> +/*
> + * Structure of a PCI controller (host bridge)
> + */
> +#if defined(CONFIG_PPC32) || defined(CONFIG_PPC64)
> +struct pci_controller {
> +       struct pci_bus *bus;

A lot of the information here (struct pci_bus *bus, first_/last_busno,
busn, window information) is already in the struct pci_host_bridge,
and I'm not sure it makes sense to duplicate it here.  I'd like to use
that structure when it makes sense, and use the sysdata pointer, i.e.,
the pointer to "struct pci_controller" here, for things that are truly
arch-specific.

> +       char is_dynamic;
> +#ifdef CONFIG_PPC64
> +       int node;
> +#endif
> +       struct device_node *dn;
> +       struct list_head list_node;
> +       struct device *parent;
> +
> +       int first_busno;
> +       int last_busno;
> +       int self_busno;
> +#if defined(CONFIG_PPC64) || defined(CONFIG_PPC32)
> +       struct resource busn;
> +#endif
> +
> +       void __iomem *io_base_virt;
> +#ifdef CONFIG_PPC64
> +       void *io_base_alloc;
> +#endif
> +       resource_size_t io_base_phys;
> +       resource_size_t pci_io_size;
> +
> +       /* Some machines (PReP) have a non 1:1 mapping of
> +        * the PCI memory space in the CPU bus space
> +        */
> +       resource_size_t pci_mem_offset;
> +
> +       /* Some machines have a special region to forward the ISA
> +        * "memory" cycles such as VGA memory regions. Left to 0
> +        * if unsupported
> +        */
> +       resource_size_t isa_mem_phys;
> +       resource_size_t isa_mem_size;
> +
> +       struct pci_ops *ops;
> +       unsigned int __iomem *cfg_addr;
> +       void __iomem *cfg_data;
> +
> +       u32 indirect_type;
> +       /* Currently, we limit ourselves to 1 IO range and 3 mem
> +        * ranges since the common pci_bus structure can't handle more
> +        */
> +       struct resource io_resource;
> +       struct resource mem_resources[3];

pci_host_bridge has a list for apertures, which contains this
information (and the offset between CPU and PCI bus addresses).

> +       int global_number;              /* PCI domain number */

The domain is a good candidate for going in the pci_host_bridge
structure.  I'm not sure how to plumb it in there, but it is something
that's pretty generic and I'd like to get rid of all the arch-specific
pci_domain_nr() implementations that are really the same.

> +
> +       resource_size_t dma_window_base_cur;
> +       resource_size_t dma_window_size;
> +
> +#ifdef CONFIG_PPC64
> +       unsigned long buid;
> +
> +       void *private_data;
> +#endif /* CONFIG_PPC64 */
> +};
> +#endif
> +
>  #ifdef CONFIG_PCI
>  extern unsigned int pci_flags;
>
> --
> 1.7.0.4
>
