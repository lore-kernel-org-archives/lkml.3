Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaCACHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:07:10 -0500
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:39363 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752006AbaCACHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:07:07 -0500
MIME-Version: 1.0
In-Reply-To: <CACoXjck59jA1Ub8mHB0zn16krCxagUgH8BmJVnLQ8KGpFg7WpA@mail.gmail.com>
References: <1393592902-24750-1-git-send-email-Liviu.Dudau@arm.com>
	<1393592902-24750-6-git-send-email-Liviu.Dudau@arm.com>
	<CACoXjck59jA1Ub8mHB0zn16krCxagUgH8BmJVnLQ8KGpFg7WpA@mail.gmail.com>
Date: Fri, 28 Feb 2014 18:07:05 -0800
Message-ID: <CACoXjckem9p0uKRBTF67xJ6-_nM2mxcmRyfsb0jue2TiVZiuxQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] pci: Add support for creating a generic
 host_bridge from device tree
From: Tanmay Inamdar <tinamdar@apm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        patches <patches@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier email did not deliver to mailing lists because of plain text
setting problem on my side. Apologies for spamming. Sending it again.

Hello Liviu,

While porting X-Gene PCIe driver to v2 series, following problems were observed.

1. In 'of_create_pci_host_bridge' function, bus_range is defined
locally. So, while walking over list of resources in bridge->windows
later, during X-Gene controller related setup, garbage values are
found in the resource. Please allocate it dynamically.

2. 'domain_nr' problem is partially solved. There are still some
places where functions are getting invalid domain_nr.  For example,
'pci_alloc_child_bus' tries to get domain_nr when bridge is not
assigned to bus. You may want to look for all the places where
pci_domain_nr is used. Please see below dump -->

pci 0001:00:00.0: scanning [bus 00-00] behind bridge, pass 1
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at
/home/tinamdar/work/open-source/linux/fs/sysfs/dir.c:52
sysfs_warn_dup+0x80/0xc0()
sysfs: cannot create duplicate filename '/class/pci_bus/0000:01'
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc4+ #37
Call trace:
[<ffffffc000088140>] dump_backtrace+0x0/0x140
[<ffffffc000088294>] show_stack+0x14/0x20
[<ffffffc0004f64b0>] dump_stack+0x78/0xc4
[<ffffffc000096c88>] warn_slowpath_common+0x88/0xc0
[<ffffffc000096d10>] warn_slowpath_fmt+0x50/0x60
[<ffffffc0001b8260>] sysfs_warn_dup+0x80/0xc0
[<ffffffc0001b8718>] sysfs_do_create_link_sd.isra.2+0xf8/0x100
[<ffffffc0001b8740>] sysfs_create_link+0x20/0x40
[<ffffffc000322f5c>] device_add+0x41c/0x520
[<ffffffc00032307c>] device_register+0x1c/0x40
[<ffffffc0004f1924>] pci_add_new_bus+0x284/0x380
[<ffffffc0002c51a0>] pci_scan_bridge+0x4e0/0x540
[<ffffffc0002c52b4>] pci_scan_child_bus+0xb4/0x140
[<ffffffc0004f1a34>] pci_rescan_bus+0x14/0x40
[<ffffffc0006a12d4>] xgene_pcie_probe_bridge+0x688/0x750
[<ffffffc000327c64>] platform_drv_probe+0x24/0x60
[<ffffffc000325d74>] really_probe+0xf4/0x220
[<ffffffc000325fc4>] __driver_attach+0xa4/0xc0
[<ffffffc000323e18>] bus_for_each_dev+0x58/0xa0
[<ffffffc000325800>] driver_attach+0x20/0x40
[<ffffffc0003253d0>] bus_add_driver+0x150/0x220
[<ffffffc000326780>] driver_register+0x60/0x120
[<ffffffc000327c20>] __platform_driver_register+0x60/0x80
[<ffffffc0006a0c44>] xgene_pcie_driver_init+0x18/0x20
[<ffffffc0000814c4>] do_one_initcall+0xe4/0x160
[<ffffffc00068c938>] kernel_init_freeable+0x138/0x1d8
[<ffffffc0004f06b0>] kernel_init+0x10/0xe0
---[ end trace 53db1c3a7fbdeb88 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at
/home/tinamdar/work/open-source/linux/drivers/pci/probe.c:711
pci_add_new_bus+0x36c/0x380()

Thanks,
Tanmay

On Fri, Feb 28, 2014 at 6:01 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> Hello Liviu,
>
> While porting X-Gene PCIe driver to v2 series, following problems were
> observed.
>
> 1. In 'of_create_pci_host_bridge' function, bus_range is defined locally.
> So, while walking over list of resources in bridge->windows later, during
> X-Gene controller related setup, garbage values are found in the resource.
> Please allocate it dynamically.
>
> 2. 'domain_nr' problem is partially solved. There are still some places
> where functions are getting invalid domain_nr.  For example,
> 'pci_alloc_child_bus' tries to get domain_nr when bridge is not assigned to
> bus. You may want to look for all the places where pci_domain_nr is used.
> Please see below dump -->
>
> pci 0001:00:00.0: scanning [bus 00-00] behind bridge, pass 1
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at
> /home/tinamdar/work/open-source/linux/fs/sysfs/dir.c:52
> sysfs_warn_dup+0x80/0xc0()
> sysfs: cannot create duplicate filename '/class/pci_bus/0000:01'
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc4+ #37
> Call trace:
> [<ffffffc000088140>] dump_backtrace+0x0/0x140
> [<ffffffc000088294>] show_stack+0x14/0x20
> [<ffffffc0004f64b0>] dump_stack+0x78/0xc4
> [<ffffffc000096c88>] warn_slowpath_common+0x88/0xc0
> [<ffffffc000096d10>] warn_slowpath_fmt+0x50/0x60
> [<ffffffc0001b8260>] sysfs_warn_dup+0x80/0xc0
> [<ffffffc0001b8718>] sysfs_do_create_link_sd.isra.2+0xf8/0x100
> [<ffffffc0001b8740>] sysfs_create_link+0x20/0x40
> [<ffffffc000322f5c>] device_add+0x41c/0x520
> [<ffffffc00032307c>] device_register+0x1c/0x40
> [<ffffffc0004f1924>] pci_add_new_bus+0x284/0x380
> [<ffffffc0002c51a0>] pci_scan_bridge+0x4e0/0x540
> [<ffffffc0002c52b4>] pci_scan_child_bus+0xb4/0x140
> [<ffffffc0004f1a34>] pci_rescan_bus+0x14/0x40
> [<ffffffc0006a12d4>] xgene_pcie_probe_bridge+0x688/0x750
> [<ffffffc000327c64>] platform_drv_probe+0x24/0x60
> [<ffffffc000325d74>] really_probe+0xf4/0x220
> [<ffffffc000325fc4>] __driver_attach+0xa4/0xc0
> [<ffffffc000323e18>] bus_for_each_dev+0x58/0xa0
> [<ffffffc000325800>] driver_attach+0x20/0x40
> [<ffffffc0003253d0>] bus_add_driver+0x150/0x220
> [<ffffffc000326780>] driver_register+0x60/0x120
> [<ffffffc000327c20>] __platform_driver_register+0x60/0x80
> [<ffffffc0006a0c44>] xgene_pcie_driver_init+0x18/0x20
> [<ffffffc0000814c4>] do_one_initcall+0xe4/0x160
> [<ffffffc00068c938>] kernel_init_freeable+0x138/0x1d8
> [<ffffffc0004f06b0>] kernel_init+0x10/0xe0
> ---[ end trace 53db1c3a7fbdeb88 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at
> /home/tinamdar/work/open-source/linux/drivers/pci/probe.c:711
> pci_add_new_bus+0x36c/0x380()
>
> Thanks,
> Tanmay
>
>
>
> On Fri, Feb 28, 2014 at 5:08 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>>
>> Several platforms use a rather generic version of parsing
>> the device tree to find the host bridge ranges. Move the common code
>> into the generic PCI code and use it to create a pci_host_bridge
>> structure that can be used by arch code.
>>
>> Based on early attempts by Andrew Murray to unify the code.
>> Used powerpc and microblaze PCI code as starting point.
>>
>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>>
>> diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
>> index 06ace62..feb8436 100644
>> --- a/drivers/pci/host-bridge.c
>> +++ b/drivers/pci/host-bridge.c
>> @@ -6,9 +6,13 @@
>>  #include <linux/init.h>
>>  #include <linux/pci.h>
>>  #include <linux/module.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_pci.h>
>>
>>  #include "pci.h"
>>
>> +static int domain_nr;
>> +
>>  static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
>>  {
>>         while (bus->parent)
>> @@ -91,3 +95,133 @@ void pcibios_bus_to_resource(struct pci_bus *bus,
>> struct resource *res,
>>         res->end = region->end + offset;
>>  }
>>  EXPORT_SYMBOL(pcibios_bus_to_resource);
>> +
>> +/**
>> + * pci_host_bridge_of_get_ranges - Parse PCI host bridge resources from
>> DT
>> + * @dev: device node of the host bridge having the range property
>> + * @resources: list where the range of resources will be added after DT
>> parsing
>> + * @io_base: pointer to a variable that will contain the physical address
>> for
>> + * the start of the I/O range.
>> + *
>> + * If this function returns an error then the @resources list will be
>> freed.
>> + *
>> + * This function will parse the "ranges" property of a PCI host bridge
>> device
>> + * node and setup the resource mapping based on its content. It is
>> expected
>> + * that the property conforms with the Power ePAPR document.
>> + *
>> + * Each architecture is then offered the chance of applying their own
>> + * filtering of pci_host_bridge_windows based on their own restrictions
>> by
>> + * calling pcibios_fixup_bridge_ranges(). The filtered list of windows
>> + * can then be used when creating a pci_host_bridge structure.
>> + */
>> +static int pci_host_bridge_of_get_ranges(struct device_node *dev,
>> +               struct list_head *resources, resource_size_t *io_base)
>> +{
>> +       struct resource *res;
>> +       struct of_pci_range range;
>> +       struct of_pci_range_parser parser;
>> +       int err;
>> +
>> +       pr_info("PCI host bridge %s ranges:\n", dev->full_name);
>> +
>> +       /* Check for ranges property */
>> +       err = of_pci_range_parser_init(&parser, dev);
>> +       if (err)
>> +               return err;
>> +
>> +       pr_debug("Parsing ranges property...\n");
>> +       for_each_of_pci_range(&parser, &range) {
>> +               /* Read next ranges element */
>> +               pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
>> +                               range.pci_space, range.pci_addr);
>> +               pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
>> +                                       range.cpu_addr, range.size);
>> +
>> +               /*
>> +                * If we failed translation or got a zero-sized region
>> +                * then skip this range
>> +                */
>> +               if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
>> +                       continue;
>> +
>> +               res = kzalloc(sizeof(struct resource), GFP_KERNEL);
>> +               if (!res) {
>> +                       err = -ENOMEM;
>> +                       goto bridge_ranges_nomem;
>> +               }
>> +
>> +               of_pci_range_to_resource(&range, dev, res);
>> +
>> +               if (resource_type(res) == IORESOURCE_IO)
>> +                       *io_base = range.cpu_addr;
>> +
>> +               pci_add_resource_offset(resources, res,
>> +                               res->start - range.pci_addr);
>> +       }
>> +
>> +       /* Apply architecture specific fixups for the ranges */
>> +       pcibios_fixup_bridge_ranges(resources);
>> +
>> +       return 0;
>> +
>> +bridge_ranges_nomem:
>> +       pci_free_resource_list(resources);
>> +       return err;
>> +}
>> +
>> +/**
>> + * of_create_pci_host_bridge - Create a PCI host bridge structure using
>> + * information passed in the DT.
>> + * @parent: device owning this host bridge
>> + * @ops: pci_ops associated with the host controller
>> + * @host_data: opaque data structure used by the host controller.
>> + *
>> + * returns a pointer to the newly created pci_host_bridge structure, or
>> + * NULL if the call failed.
>> + *
>> + * This function will try to obtain the host bridge domain number by
>> + * using of_alias_get_id() call with "pci-domain" as a stem. If that
>> + * fails, a local allocator will be used that will put each host bridge
>> + * in a new domain.
>> + */
>> +struct pci_host_bridge *
>> +of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops,
>> void *host_data)
>> +{
>> +       int err, domain, busno;
>> +       struct resource bus_range;
>> +       struct pci_bus *root_bus;
>> +       struct pci_host_bridge *bridge;
>> +       resource_size_t io_base;
>> +       LIST_HEAD(res);
>> +
>> +       domain = of_alias_get_id(parent->of_node, "pci-domain");
>> +       if (domain == -ENODEV)
>> +               domain = domain_nr++;
>> +
>> +       err = of_pci_parse_bus_range(parent->of_node, &bus_range);
>> +       if (err) {
>> +               dev_info(parent, "No bus range for %s, using default
>> [0-255]\n",
>> +                       parent->of_node->full_name);
>> +               bus_range.start = 0;
>> +               bus_range.end = 255;
>> +               bus_range.flags = IORESOURCE_BUS;
>> +       }
>> +       busno = bus_range.start;
>> +       pci_add_resource(&res, &bus_range);
>> +
>> +       /* now parse the rest of host bridge bus ranges */
>> +       if (pci_host_bridge_of_get_ranges(parent->of_node, &res,
>> &io_base))
>> +               return NULL;
>> +
>> +       /* then create the root bus */
>> +       root_bus = pci_create_root_bus_in_domain(parent, domain, busno,
>> +                                               ops, host_data, &res);
>> +       if (!root_bus)
>> +               return NULL;
>> +
>> +       bridge = to_pci_host_bridge(root_bus->bridge);
>> +       bridge->io_base = io_base;
>> +
>> +       return bridge;
>> +}
>> +EXPORT_SYMBOL_GPL(of_create_pci_host_bridge);
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 1eed009..0c5e269 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -395,6 +395,7 @@ struct pci_host_bridge {
>>         struct device dev;
>>         struct pci_bus *bus;            /* root bus */
>>         int domain_nr;
>> +       resource_size_t io_base;        /* physical address for the start
>> of I/O area */
>>         struct list_head windows;       /* pci_host_bridge_windows */
>>         void (*release_fn)(struct pci_host_bridge *);
>>         void *release_data;
>> @@ -1786,11 +1787,23 @@ static inline struct device_node
>> *pci_bus_to_OF_node(struct pci_bus *bus)
>>         return bus ? bus->dev.of_node : NULL;
>>  }
>>
>> +struct pci_host_bridge *
>> +of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops,
>> +                       void *host_data);
>> +
>> +void pcibios_fixup_bridge_ranges(struct list_head *resources);
>>  #else /* CONFIG_OF */
>>  static inline void pci_set_of_node(struct pci_dev *dev) { }
>>  static inline void pci_release_of_node(struct pci_dev *dev) { }
>>  static inline void pci_set_bus_of_node(struct pci_bus *bus) { }
>>  static inline void pci_release_bus_of_node(struct pci_bus *bus) { }
>> +
>> +static inline struct pci_host_bridge *
>> +pci_host_bridge_of_init(struct device *parent, struct pci_ops *ops,
>> +                       void *host_data)
>> +{
>> +       return NULL;
>> +}
>>  #endif  /* CONFIG_OF */
>>
>>  #ifdef CONFIG_EEH
>> --
>> 1.9.0
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
