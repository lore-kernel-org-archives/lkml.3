Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaKGOzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:55:32 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35476 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaKGOza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:55:30 -0500
Date: Fri, 7 Nov 2014 14:55:25 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [RFC PATCH 4/4] arm64, acpi, pci: Provide arch-specific calls
 for PCI host bridge dirver (PNP0A03).
Message-ID: <20141107145525.GH8916@e106497-lin.cambridge.arm.com>
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org>
 <1415366876-30811-5-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1415366876-30811-5-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 07 Nov 2014 14:55:27.0145 (UTC) FILETIME=[DDE0F990:01CFFA9A]
X-MC-Unique: 114110714552720201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 01:27:56PM +0000, Tomasz Nowicki wrote:
> Code inspired by arch/x86/pci/acpi.c and arch/ia64/pci/pci.c files.
> The main reasons why we need this:
> - parse and manage resources (BUS, IO and MEM)
> - create pci root bus and enumerate its children
> - provide PCI config space accessors (via MMCONFIG)

Hi Tomasz,

I have some comments to your code:

> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>  arch/arm64/include/asm/pci.h |   8 +
>  arch/arm64/kernel/pci.c      | 401 +++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 391 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
> index fded096..ecd940f 100644
> --- a/arch/arm64/include/asm/pci.h
> +++ b/arch/arm64/include/asm/pci.h
> @@ -33,6 +33,14 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
>  extern int isa_dma_bridge_buggy;
> 
>  #ifdef CONFIG_PCI
> +struct pci_controller {
> +       struct acpi_device *companion;
> +       int segment;
> +       int node;               /* nearest node with memory or NUMA_NO_NODE for global allocation */
> +};
> +
> +#define PCI_CONTROLLER(busdev) ((struct pci_controller *) busdev->sysdata)

I am trying to move away from the model where the architecture dictates the shape
of the pci_controller structure. Can I suggest that you put all this code and the
one under #ifdef CONFIG_ACPI in a separate file, say arch/arm64/kernel/pci-acpi.c ?
Or that you add an #ifdef CONFIG_ACPI around this structure definition?

I can't see anyone using this definition outside ACPI (due to struct acpi_device
dependency) and I would like to avoid it conflicting with other host bridge
drivers trying to define the same name structure.


> +
>  static inline int pci_proc_domain(struct pci_bus *bus)
>  {
>         return 1;
> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
> index 42fb195..cc34ded 100644
> --- a/arch/arm64/kernel/pci.c
> +++ b/arch/arm64/kernel/pci.c
> @@ -1,6 +1,10 @@
>  /*
> - * Code borrowed from powerpc/kernel/pci-common.c
> + * Code borrowed from powerpc/kernel/pci-common.c and arch/ia64/pci/pci.c
>   *
> + * Copyright (c) 2002, 2005 Hewlett-Packard Development Company, L.P.
> + *     David Mosberger-Tang <davidm@hpl.hp.com>
> + *     Bjorn Helgaas <bjorn.helgaas@hp.com>
> + * Copyright (C) 2004 Silicon Graphics, Inc.
>   * Copyright (C) 2003 Anton Blanchard <anton@au.ibm.com>, IBM
>   * Copyright (C) 2014 ARM Ltd.
>   *
> @@ -17,10 +21,16 @@
>  #include <linux/mm.h>
>  #include <linux/of_pci.h>
>  #include <linux/of_platform.h>
> +#include <linux/of_address.h>
>  #include <linux/slab.h>
> +#include <linux/pci.h>
> +#include <linux/acpi.h>
> +#include <linux/mmconfig.h>
> 
>  #include <asm/pci-bridge.h>
> 
> +#define PREFIX "PCI: "

Where is this used?

> +
>  /*
>   * Called after each bus is probed, but before its children are examined
>   */
> @@ -43,7 +53,8 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
>   */
>  int pcibios_add_device(struct pci_dev *dev)
>  {
> -       dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
> +       if (acpi_disabled)
> +               dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
> 
>         return 0;
>  }
> @@ -54,45 +65,399 @@ static bool dt_domain_found = false;
> 
>  void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
>  {
> -       int domain = of_get_pci_domain_nr(parent->of_node);
> +       int domain = -1;
> 
> -       if (domain >= 0) {
> -               dt_domain_found = true;
> -       } else if (dt_domain_found == true) {
> -               dev_err(parent, "Node %s is missing \"linux,pci-domain\" property in DT\n",
> -                       parent->of_node->full_name);
> -               return;
> +       if (acpi_disabled) {
> +               domain = of_get_pci_domain_nr(parent->of_node);
> +
> +               if (domain >= 0) {
> +                       dt_domain_found = true;
> +               } else if (dt_domain_found == true) {
> +                       dev_err(parent, "Node %s is missing \"linux,pci-domain\" property in DT\n",
> +                               parent->of_node->full_name);
> +                       return;
> +               } else {
> +                       domain = pci_get_new_domain_nr();
> +               }
>         } else {
> -               domain = pci_get_new_domain_nr();
> +               /*
> +                * Take the domain nr from associated private data.
> +                * Case where bus has parent is covered in pci_alloc_bus()
> +                */
> +               if (!parent)
> +                       domain = PCI_CONTROLLER(bus)->segment;

I would also like to wrap this into an ACPI specific function. Reason for it
is that when I get to split the pci_host_bridge creation out of pci_create_root_bus()
this will become a pci_controller property.

>         }
> 
>         bus->domain_nr = domain;
>  }
>  #endif
> 
> +static char __iomem *pci_dev_base(unsigned int seg, unsigned int bus,
> +                                 unsigned int devfn)
> +{
> +       struct pci_mmcfg_region *cfg = pci_mmconfig_lookup(seg, bus);
> +
> +       if (cfg && cfg->virt)
> +               return cfg->virt + (PCI_MMCFG_BUS_OFFSET(bus) | (devfn << 12));
> +       return NULL;
> +}
> +
>  /*
>   * raw_pci_read/write - Platform-specific PCI config space access.
> - *
> - * Default empty implementation.  Replace with an architecture-specific setup
> - * routine, if necessary.
>   */
>  int raw_pci_read(unsigned int domain, unsigned int bus,
>                   unsigned int devfn, int reg, int len, u32 *val)
>  {
> -       return -EINVAL;
> +       char __iomem *addr;
> +
> +       if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095))) {
> +err:           *val = -1;

I believe the general usage is to have labels on their own line.

> +               return -EINVAL;
> +       }
> +
> +       rcu_read_lock();
> +       addr = pci_dev_base(domain, bus, devfn);
> +       if (!addr) {
> +               rcu_read_unlock();
> +               goto err;
> +       }
> +
> +       switch (len) {
> +       case 1:
> +               *val = readb(addr + reg);
> +               break;
> +       case 2:
> +               *val = readw(addr + reg);
> +               break;
> +       case 4:
> +               *val = readl(addr + reg);
> +               break;
> +       }
> +       rcu_read_unlock();
> +
> +       return 0;
>  }
> 
>  int raw_pci_write(unsigned int domain, unsigned int bus,
>                 unsigned int devfn, int reg, int len, u32 val)
>  {
> -       return -EINVAL;
> +       char __iomem *addr;
> +
> +       if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
> +               return -EINVAL;
> +
> +       rcu_read_lock();
> +       addr = pci_dev_base(domain, bus, devfn);
> +       if (!addr) {
> +               rcu_read_unlock();
> +               return -EINVAL;
> +       }
> +
> +       switch (len) {
> +       case 1:
> +               writeb(val, addr + reg);
> +               break;
> +       case 2:
> +               writew(val, addr + reg);
> +               break;
> +       case 4:
> +               writel(val, addr + reg);
> +               break;
> +       }
> +       rcu_read_unlock();
> +
> +       return 0;
>  }
> 

These raw_pci_{read,write} functions are all ACPI specific so they can move
into the new file as well.


>  #ifdef CONFIG_ACPI
> +static int pci_read(struct pci_bus *bus, unsigned int devfn, int where,
> +                   int size, u32 *value)
> +{
> +       return raw_pci_read(pci_domain_nr(bus), bus->number,
> +                           devfn, where, size, value);
> +}
> +
> +static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
> +                    int size, u32 value)
> +{
> +       return raw_pci_write(pci_domain_nr(bus), bus->number,
> +                            devfn, where, size, value);
> +}
> +
> +struct pci_ops pci_root_ops = {
> +       .read = pci_read,
> +       .write = pci_write,
> +};
> +
> +static struct pci_controller *alloc_pci_controller(int seg)
> +{
> +       struct pci_controller *controller;
> +
> +       controller = kzalloc(sizeof(*controller), GFP_KERNEL);
> +       if (!controller)
> +               return NULL;
> +
> +       controller->segment = seg;
> +       return controller;
> +}
> +
> +struct pci_root_info {
> +       struct acpi_device *bridge;
> +       struct pci_controller *controller;
> +       struct list_head resources;
> +       struct resource *res;
> +       resource_size_t *res_offset;

Why do you need to keep an array of res_offsets here? You only seem
to be using the values once when you add the resource to the host
bridge windows.

> +       unsigned int res_num;
> +       char *name;
> +};
> +
> +static acpi_status resource_to_window(struct acpi_resource *resource,
> +                                     struct acpi_resource_address64 *addr)
> +{
> +       acpi_status status;
> +
> +       /*
> +        * We're only interested in _CRS descriptors that are
> +        *      - address space descriptors for memory
> +        *      - non-zero size
> +        *      - producers, i.e., the address space is routed downstream,
> +        *        not consumed by the bridge itself
> +        */
> +       status = acpi_resource_to_address64(resource, addr);
> +       if (ACPI_SUCCESS(status) &&
> +           (addr->resource_type == ACPI_MEMORY_RANGE ||
> +            addr->resource_type == ACPI_IO_RANGE) &&
> +           addr->address_length &&
> +           addr->producer_consumer == ACPI_PRODUCER)
> +               return AE_OK;
> +
> +       return AE_ERROR;
> +}
> +
> +static acpi_status count_window(struct acpi_resource *resource, void *data)
> +{
> +       unsigned int *windows = (unsigned int *) data;
> +       struct acpi_resource_address64 addr;
> +       acpi_status status;
> +
> +       status = resource_to_window(resource, &addr);
> +       if (ACPI_SUCCESS(status))
> +               (*windows)++;
> +
> +       return AE_OK;
> +}
> +
> +static acpi_status add_window(struct acpi_resource *res, void *data)
> +{
> +       struct pci_root_info *info = data;
> +       struct resource *resource;
> +       struct acpi_resource_address64 addr;
> +       acpi_status status;
> +       unsigned long flags;
> +       struct resource *root;
> +       u64 start;
> +
> +       /* Return AE_OK for non-window resources to keep scanning for more */
> +       status = resource_to_window(res, &addr);
> +       if (!ACPI_SUCCESS(status))
> +               return AE_OK;
> +
> +       if (addr.resource_type == ACPI_MEMORY_RANGE) {
> +               flags = IORESOURCE_MEM;
> +               root = &iomem_resource;
> +       } else if (addr.resource_type == ACPI_IO_RANGE) {
> +               flags = IORESOURCE_IO;
> +               root = &ioport_resource;
> +       } else
> +               return AE_OK;
> +
> +       start = addr.minimum + addr.translation_offset;
> +
> +       resource = &info->res[info->res_num];
> +       resource->name = info->name;
> +       resource->flags = flags;
> +       resource->start = start;
> +       resource->end = resource->start + addr.address_length - 1;
> +
> +       if (flags & IORESOURCE_IO) {
> +               unsigned long port;
> +               int err;
> +
> +               err = pci_register_io_range(start, addr.address_length);
> +               if (err)
> +                       return AE_OK;
> +
> +               port = pci_address_to_pio(start);
> +               if (port == (unsigned long)-1)
> +                       return AE_OK;
> +
> +               resource->start = port;
> +               resource->end = port + addr.address_length - 1;
> +
> +               if (pci_remap_iospace(resource, start) < 0)
> +                       return AE_OK;

You seem to leave around invalid resources every time you return in this code
path due to your choice of ignoring error conditions.

I think there are a few things that can be streamlined in this patch, but
overall I think it looks promising.

Best regards,
Liviu


> +
> +               info->res_offset[info->res_num] = 0;
> +       } else
> +               info->res_offset[info->res_num] = addr.translation_offset;
> +
> +       if (insert_resource(root, resource)) {
> +               dev_err(&info->bridge->dev,
> +                       "can't allocate host bridge window %pR\n",
> +                       resource);
> +       } else {
> +               if (addr.translation_offset)
> +                       dev_info(&info->bridge->dev, "host bridge window %pR "
> +                                "(PCI address [%#llx-%#llx])\n",
> +                                resource,
> +                                resource->start - addr.translation_offset,
> +                                resource->end - addr.translation_offset);
> +               else
> +                       dev_info(&info->bridge->dev,
> +                                "host bridge window %pR\n", resource);
> +       }
> +
> +       pci_add_resource_offset(&info->resources, resource,
> +                               info->res_offset[info->res_num]);
> +       info->res_num++;
> +       return AE_OK;
> +}
> +
> +static void free_pci_root_info_res(struct pci_root_info *info)
> +{
> +       kfree(info->name);
> +       kfree(info->res);
> +       info->res = NULL;
> +       kfree(info->res_offset);
> +       info->res_offset = NULL;
> +       info->res_num = 0;
> +       kfree(info->controller);
> +       info->controller = NULL;
> +}
> +
> +static void __release_pci_root_info(struct pci_root_info *info)
> +{
> +       int i;
> +       struct resource *res;
> +
> +       for (i = 0; i < info->res_num; i++) {
> +               res = &info->res[i];
> +
> +               if (!res->parent)
> +                       continue;
> +
> +               if (!(res->flags & (IORESOURCE_MEM | IORESOURCE_IO)))
> +                       continue;
> +
> +               release_resource(res);
> +       }
> +
> +       free_pci_root_info_res(info);
> +       kfree(info);
> +}
> +
> +static void release_pci_root_info(struct pci_host_bridge *bridge)
> +{
> +       struct pci_root_info *info = bridge->release_data;
> +
> +       __release_pci_root_info(info);
> +}
> +
> +static int
> +probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
> +               int busnum, int domain)
> +{
> +       char *name;
> +
> +       name = kmalloc(16, GFP_KERNEL);
> +       if (!name)
> +               return -ENOMEM;
> +
> +       sprintf(name, "PCI Bus %04x:%02x", domain, busnum);
> +       info->bridge = device;
> +       info->name = name;
> +
> +       acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_window,
> +                       &info->res_num);
> +       if (info->res_num) {
> +               info->res =
> +                       kzalloc_node(sizeof(*info->res) * info->res_num,
> +                                    GFP_KERNEL, info->controller->node);
> +               if (!info->res) {
> +                       kfree(name);
> +                       return -ENOMEM;
> +               }
> +
> +               info->res_offset =
> +                       kzalloc_node(sizeof(*info->res_offset) * info->res_num,
> +                                       GFP_KERNEL, info->controller->node);
> +               if (!info->res_offset) {
> +                       kfree(name);
> +                       kfree(info->res);
> +                       info->res = NULL;
> +                       return -ENOMEM;
> +               }
> +
> +               info->res_num = 0;
> +               acpi_walk_resources(device->handle, METHOD_NAME__CRS,
> +                       add_window, info);
> +       } else
> +               kfree(name);
> +
> +       return 0;
> +}
> +
>  /* Root bridge scanning */
>  struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>  {
> -       /* TODO: Should be revisited when implementing PCI on ACPI */
> -       return NULL;
> +       struct acpi_device *device = root->device;
> +       int domain = root->segment;
> +       int bus = root->secondary.start;
> +       struct pci_controller *controller;
> +       struct pci_root_info *info = NULL;
> +       int busnum = root->secondary.start;
> +       struct pci_bus *pbus;
> +       int ret;
> +
> +       controller = alloc_pci_controller(domain);
> +       if (!controller)
> +               return NULL;
> +
> +       controller->companion = device;
> +       controller->node = acpi_get_node(device->handle);
> +
> +       info = kzalloc(sizeof(*info), GFP_KERNEL);
> +       if (!info) {
> +               dev_err(&device->dev,
> +                               "pci_bus %04x:%02x: ignored (out of memory)\n",
> +                               domain, busnum);
> +               kfree(controller);
> +               return NULL;
> +       }
> +
> +       info->controller = controller;
> +       INIT_LIST_HEAD(&info->resources);
> +
> +       ret = probe_pci_root_info(info, device, busnum, domain);
> +       if (ret) {
> +               kfree(info->controller);
> +               kfree(info);
> +               return NULL;
> +       }
> +       /* insert busn resource at first */
> +       pci_add_resource(&info->resources, &root->secondary);
> +
> +       pbus = pci_create_root_bus(NULL, bus, &pci_root_ops, controller,
> +                                  &info->resources);
> +       if (!pbus) {
> +               pci_free_resource_list(&info->resources);
> +               __release_pci_root_info(info);
> +               return NULL;
> +       }
> +
> +       pci_set_host_bridge_release(to_pci_host_bridge(pbus->bridge),
> +                       release_pci_root_info, info);
> +       pci_scan_child_bus(pbus);
> +       return pbus;
>  }
> -#endif
> +#endif /* CONFIG_ACPI */
> --
> 1.9.1
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

