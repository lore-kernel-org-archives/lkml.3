Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaKLIri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:47:38 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51096 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaKLIrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:47:36 -0500
Message-ID: <54631EA2.8060401@linaro.org>
Date: Wed, 12 Nov 2014 09:47:30 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
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
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org> <1415366876-30811-5-git-send-email-tomasz.nowicki@linaro.org> <20141107145525.GH8916@e106497-lin.cambridge.arm.com>
In-Reply-To: <20141107145525.GH8916@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 07.11.2014 o 15:55, Liviu Dudau pisze:
> On Fri, Nov 07, 2014 at 01:27:56PM +0000, Tomasz Nowicki wrote:
>> Code inspired by arch/x86/pci/acpi.c and arch/ia64/pci/pci.c files.
>> The main reasons why we need this:
>> - parse and manage resources (BUS, IO and MEM)
>> - create pci root bus and enumerate its children
>> - provide PCI config space accessors (via MMCONFIG)
>
> Hi Tomasz,
>
> I have some comments to your code:
>
>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   arch/arm64/include/asm/pci.h |   8 +
>>   arch/arm64/kernel/pci.c      | 401 +++++++++++++++++++++++++++++++++++++++++--
>>   2 files changed, 391 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
>> index fded096..ecd940f 100644
>> --- a/arch/arm64/include/asm/pci.h
>> +++ b/arch/arm64/include/asm/pci.h
>> @@ -33,6 +33,14 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
>>   extern int isa_dma_bridge_buggy;
>>
>>   #ifdef CONFIG_PCI
>> +struct pci_controller {
>> +       struct acpi_device *companion;
>> +       int segment;
>> +       int node;               /* nearest node with memory or NUMA_NO_NODE for global allocation */
>> +};
>> +
>> +#define PCI_CONTROLLER(busdev) ((struct pci_controller *) busdev->sysdata)
>
> I am trying to move away from the model where the architecture dictates the shape
> of the pci_controller structure. Can I suggest that you put all this code and the
> one under #ifdef CONFIG_ACPI in a separate file, say arch/arm64/kernel/pci-acpi.c ?
> Or that you add an #ifdef CONFIG_ACPI around this structure definition?
>
> I can't see anyone using this definition outside ACPI (due to struct acpi_device
> dependency) and I would like to avoid it conflicting with other host bridge
> drivers trying to define the same name structure.

That is good point, will do, thanks.

>
>
>> +
>>   static inline int pci_proc_domain(struct pci_bus *bus)
>>   {
>>          return 1;
>> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
>> index 42fb195..cc34ded 100644
>> --- a/arch/arm64/kernel/pci.c
>> +++ b/arch/arm64/kernel/pci.c
>> @@ -1,6 +1,10 @@
>>   /*
>> - * Code borrowed from powerpc/kernel/pci-common.c
>> + * Code borrowed from powerpc/kernel/pci-common.c and arch/ia64/pci/pci.c
>>    *
>> + * Copyright (c) 2002, 2005 Hewlett-Packard Development Company, L.P.
>> + *     David Mosberger-Tang <davidm@hpl.hp.com>
>> + *     Bjorn Helgaas <bjorn.helgaas@hp.com>
>> + * Copyright (C) 2004 Silicon Graphics, Inc.
>>    * Copyright (C) 2003 Anton Blanchard <anton@au.ibm.com>, IBM
>>    * Copyright (C) 2014 ARM Ltd.
>>    *
>> @@ -17,10 +21,16 @@
>>   #include <linux/mm.h>
>>   #include <linux/of_pci.h>
>>   #include <linux/of_platform.h>
>> +#include <linux/of_address.h>
>>   #include <linux/slab.h>
>> +#include <linux/pci.h>
>> +#include <linux/acpi.h>
>> +#include <linux/mmconfig.h>
>>
>>   #include <asm/pci-bridge.h>
>>
>> +#define PREFIX "PCI: "
>
> Where is this used?

Nowhere here, will remove/improve.

>
>> +
>>   /*
>>    * Called after each bus is probed, but before its children are examined
>>    */
>> @@ -43,7 +53,8 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
>>    */
>>   int pcibios_add_device(struct pci_dev *dev)
>>   {
>> -       dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
>> +       if (acpi_disabled)
>> +               dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
>>
>>          return 0;
>>   }
>> @@ -54,45 +65,399 @@ static bool dt_domain_found = false;
>>
>>   void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
>>   {
>> -       int domain = of_get_pci_domain_nr(parent->of_node);
>> +       int domain = -1;
>>
>> -       if (domain >= 0) {
>> -               dt_domain_found = true;
>> -       } else if (dt_domain_found == true) {
>> -               dev_err(parent, "Node %s is missing \"linux,pci-domain\" property in DT\n",
>> -                       parent->of_node->full_name);
>> -               return;
>> +       if (acpi_disabled) {
>> +               domain = of_get_pci_domain_nr(parent->of_node);
>> +
>> +               if (domain >= 0) {
>> +                       dt_domain_found = true;
>> +               } else if (dt_domain_found == true) {
>> +                       dev_err(parent, "Node %s is missing \"linux,pci-domain\" property in DT\n",
>> +                               parent->of_node->full_name);
>> +                       return;
>> +               } else {
>> +                       domain = pci_get_new_domain_nr();
>> +               }
>>          } else {
>> -               domain = pci_get_new_domain_nr();
>> +               /*
>> +                * Take the domain nr from associated private data.
>> +                * Case where bus has parent is covered in pci_alloc_bus()
>> +                */
>> +               if (!parent)
>> +                       domain = PCI_CONTROLLER(bus)->segment;
>
> I would also like to wrap this into an ACPI specific function. Reason for it
> is that when I get to split the pci_host_bridge creation out of pci_create_root_bus()
> this will become a pci_controller property.

Make sense for me.

>
>>          }
>>
>>          bus->domain_nr = domain;
>>   }
>>   #endif
>>
>> +static char __iomem *pci_dev_base(unsigned int seg, unsigned int bus,
>> +                                 unsigned int devfn)
>> +{
>> +       struct pci_mmcfg_region *cfg = pci_mmconfig_lookup(seg, bus);
>> +
>> +       if (cfg && cfg->virt)
>> +               return cfg->virt + (PCI_MMCFG_BUS_OFFSET(bus) | (devfn << 12));
>> +       return NULL;
>> +}
>> +
>>   /*
>>    * raw_pci_read/write - Platform-specific PCI config space access.
>> - *
>> - * Default empty implementation.  Replace with an architecture-specific setup
>> - * routine, if necessary.
>>    */
>>   int raw_pci_read(unsigned int domain, unsigned int bus,
>>                    unsigned int devfn, int reg, int len, u32 *val)
>>   {
>> -       return -EINVAL;
>> +       char __iomem *addr;
>> +
>> +       if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095))) {
>> +err:           *val = -1;
>
> I believe the general usage is to have labels on their own line.
>
>> +               return -EINVAL;
>> +       }
>> +
>> +       rcu_read_lock();
>> +       addr = pci_dev_base(domain, bus, devfn);
>> +       if (!addr) {
>> +               rcu_read_unlock();
>> +               goto err;
>> +       }
>> +
>> +       switch (len) {
>> +       case 1:
>> +               *val = readb(addr + reg);
>> +               break;
>> +       case 2:
>> +               *val = readw(addr + reg);
>> +               break;
>> +       case 4:
>> +               *val = readl(addr + reg);
>> +               break;
>> +       }
>> +       rcu_read_unlock();
>> +
>> +       return 0;
>>   }
>>
>>   int raw_pci_write(unsigned int domain, unsigned int bus,
>>                  unsigned int devfn, int reg, int len, u32 val)
>>   {
>> -       return -EINVAL;
>> +       char __iomem *addr;
>> +
>> +       if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
>> +               return -EINVAL;
>> +
>> +       rcu_read_lock();
>> +       addr = pci_dev_base(domain, bus, devfn);
>> +       if (!addr) {
>> +               rcu_read_unlock();
>> +               return -EINVAL;
>> +       }
>> +
>> +       switch (len) {
>> +       case 1:
>> +               writeb(val, addr + reg);
>> +               break;
>> +       case 2:
>> +               writew(val, addr + reg);
>> +               break;
>> +       case 4:
>> +               writel(val, addr + reg);
>> +               break;
>> +       }
>> +       rcu_read_unlock();
>> +
>> +       return 0;
>>   }
>>
>
> These raw_pci_{read,write} functions are all ACPI specific so they can move
> into the new file as well.

Got it!

>
>
>>   #ifdef CONFIG_ACPI
>> +static int pci_read(struct pci_bus *bus, unsigned int devfn, int where,
>> +                   int size, u32 *value)
>> +{
>> +       return raw_pci_read(pci_domain_nr(bus), bus->number,
>> +                           devfn, where, size, value);
>> +}
>> +
>> +static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
>> +                    int size, u32 value)
>> +{
>> +       return raw_pci_write(pci_domain_nr(bus), bus->number,
>> +                            devfn, where, size, value);
>> +}
>> +
>> +struct pci_ops pci_root_ops = {
>> +       .read = pci_read,
>> +       .write = pci_write,
>> +};
>> +
>> +static struct pci_controller *alloc_pci_controller(int seg)
>> +{
>> +       struct pci_controller *controller;
>> +
>> +       controller = kzalloc(sizeof(*controller), GFP_KERNEL);
>> +       if (!controller)
>> +               return NULL;
>> +
>> +       controller->segment = seg;
>> +       return controller;
>> +}
>> +
>> +struct pci_root_info {
>> +       struct acpi_device *bridge;
>> +       struct pci_controller *controller;
>> +       struct list_head resources;
>> +       struct resource *res;
>> +       resource_size_t *res_offset;
>
> Why do you need to keep an array of res_offsets here? You only seem
> to be using the values once when you add the resource to the host
> bridge windows.

This is what I noticed too but did not improve that at the end. Let me 
fix that in the next ver.

>
>> +       unsigned int res_num;
>> +       char *name;
>> +};
>> +
>> +static acpi_status resource_to_window(struct acpi_resource *resource,
>> +                                     struct acpi_resource_address64 *addr)
>> +{
>> +       acpi_status status;
>> +
>> +       /*
>> +        * We're only interested in _CRS descriptors that are
>> +        *      - address space descriptors for memory
>> +        *      - non-zero size
>> +        *      - producers, i.e., the address space is routed downstream,
>> +        *        not consumed by the bridge itself
>> +        */
>> +       status = acpi_resource_to_address64(resource, addr);
>> +       if (ACPI_SUCCESS(status) &&
>> +           (addr->resource_type == ACPI_MEMORY_RANGE ||
>> +            addr->resource_type == ACPI_IO_RANGE) &&
>> +           addr->address_length &&
>> +           addr->producer_consumer == ACPI_PRODUCER)
>> +               return AE_OK;
>> +
>> +       return AE_ERROR;
>> +}
>> +
>> +static acpi_status count_window(struct acpi_resource *resource, void *data)
>> +{
>> +       unsigned int *windows = (unsigned int *) data;
>> +       struct acpi_resource_address64 addr;
>> +       acpi_status status;
>> +
>> +       status = resource_to_window(resource, &addr);
>> +       if (ACPI_SUCCESS(status))
>> +               (*windows)++;
>> +
>> +       return AE_OK;
>> +}
>> +
>> +static acpi_status add_window(struct acpi_resource *res, void *data)
>> +{
>> +       struct pci_root_info *info = data;
>> +       struct resource *resource;
>> +       struct acpi_resource_address64 addr;
>> +       acpi_status status;
>> +       unsigned long flags;
>> +       struct resource *root;
>> +       u64 start;
>> +
>> +       /* Return AE_OK for non-window resources to keep scanning for more */
>> +       status = resource_to_window(res, &addr);
>> +       if (!ACPI_SUCCESS(status))
>> +               return AE_OK;
>> +
>> +       if (addr.resource_type == ACPI_MEMORY_RANGE) {
>> +               flags = IORESOURCE_MEM;
>> +               root = &iomem_resource;
>> +       } else if (addr.resource_type == ACPI_IO_RANGE) {
>> +               flags = IORESOURCE_IO;
>> +               root = &ioport_resource;
>> +       } else
>> +               return AE_OK;
>> +
>> +       start = addr.minimum + addr.translation_offset;
>> +
>> +       resource = &info->res[info->res_num];
>> +       resource->name = info->name;
>> +       resource->flags = flags;
>> +       resource->start = start;
>> +       resource->end = resource->start + addr.address_length - 1;
>> +
>> +       if (flags & IORESOURCE_IO) {
>> +               unsigned long port;
>> +               int err;
>> +
>> +               err = pci_register_io_range(start, addr.address_length);
>> +               if (err)
>> +                       return AE_OK;
>> +
>> +               port = pci_address_to_pio(start);
>> +               if (port == (unsigned long)-1)
>> +                       return AE_OK;
>> +
>> +               resource->start = port;
>> +               resource->end = port + addr.address_length - 1;
>> +
>> +               if (pci_remap_iospace(resource, start) < 0)
>> +                       return AE_OK;
>
> You seem to leave around invalid resources every time you return in this code
> path due to your choice of ignoring error conditions.
>
> I think there are a few things that can be streamlined in this patch, but
> overall I think it looks promising.
>

Thanks Liviu!

Tomasz
