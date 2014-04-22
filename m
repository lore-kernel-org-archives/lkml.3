Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbaDVLuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:50:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64608 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbaDVLum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140422101112.GA865@e106497-lin.cambridge.arm.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
	<CA+b37P3HqMFU6kGA+GH3YpGM_Z=TwNXL6jKu+ConR3kCk-Tp4g@mail.gmail.com>
	<20140422101112.GA865@e106497-lin.cambridge.arm.com>
Date: Tue, 22 Apr 2014 17:20:40 +0530
Message-ID: <CA+b37P0XV81K4oBNnkXrVHYub=Bcuuw8nrFWUGVw-i8PJ8wGxQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] Add support for PCI in AArch64
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2014 15:41, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> On Tue, Apr 22, 2014 at 09:58:28AM +0100, Sandeepa Prabhu wrote:
>> On 14 March 2014 21:04, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> > Hi,
>> >
>> > This patch adds support for PCI to AArch64. It is based on my v7 patch
>> > that adds support for creating generic host bridge structure from
>> > device tree. With that in place, I was able to boot a platform that
>> > has PCIe host bridge support and use a PCIe network card.
>> Hi Liviu,
>>
>> Are these patches (including your other patchset for device tree host
>> bridge support ) available on a public git repo I can checkout from?
>
> Yes, I have pushed them into git://linux-arm.org/linux-ld.git
Thanks Liviu,
Just to understand, is the X-gene PCIe
(https://lwn.net/Articles/589733/) verified using the same patchset?

~Sandeepa
>
> Best regards,
> Liviu
>
>>
>> Thanks,
>> ~Sandeepa
>>
>> >
>> > I have dropped the RFC tag from the subject as I now have the ambitious goal
>> > of trying to get it mainlined.
>> >
>> > Changes from v6:
>> >   - Guard the pci_domain_nr() inline implementation with #ifdef CONFIG_PCI as
>> >     to avoid conflict with default empty version present in include/linux/pci.h.
>> >     Thanks to Jingoo Han for catching this.
>> >
>> > Changes from v5:
>> >   - Removed pcibios_fixup_bridge_ranges() as the week default version is fine.
>> >   - Removed the ALIGN() call in pcibios_align_resource()
>> >   - Stopped exporting pcibios_align_resource()
>> >
>> > Changes from v4:
>> >   - Fixed the pci_domain_nr() implementation for arm64. Now we use
>> >     find_pci_host_bride() to find the host bridge before we retrieve
>> >     the domain number.
>> >
>> > Changes from v3:
>> >   - Added Acks accumulated so far ;)
>> >   - Still carrying Catalin's patch for moving the PCI_IO_BASE until it
>> >     lands in linux-next or mainline, in order to ease applying the series
>> >
>> > Changes from v2:
>> >   - Implement an arch specific version of pci_register_io_range() and
>> >     pci_address_to_pio().
>> >   - Return 1 from pci_proc_domain().
>> >
>> > Changes from v1:
>> >   - Added Catalin's patch for moving the PCI_IO_BASE location and extend
>> >     its size to 16MB
>> >   - Integrated Arnd's version of pci_ioremap_io that uses a bitmap for
>> >     keeping track of assigned IO space and returns an io_offset. At the
>> >     moment the code is added in arch/arm64 but it can be moved in drivers/pci.
>> >   - Added a fix for the generic ioport_map() function when !CONFIG_GENERIC_IOMAP
>> >     as suggested by Arnd.
>> >
>> > v6 thread here: https://lkml.org/lkml/2014/3/5/41
>> > v5 thread here: https://lkml.org/lkml/2014/3/4/307
>> > v4 thread here: https://lkml.org/lkml/2014/3/3/298
>> > v3 thread here: https://lkml.org/lkml/2014/2/28/211
>> > v2 thread here: https://lkml.org/lkml/2014/2/27/255
>> > v1 thread here: https://lkml.org/lkml/2014/2/3/389
>> >
>> >
>> > The API used is different from the one used by ARM architecture. There is
>> > no pci_common_init_dev() function and no hw_pci structure, as that is no
>> > longer needed. Once the last signature is added to the legal agreement, I
>> > will post the host bridge driver code that I am using. Meanwhile, here
>> > is an example of what the probe function looks like, posted as an example:
>> >
>> > static int myhostbridge_probe(struct platform_device *pdev)
>> > {
>> >         int err;
>> >         struct device_node *dev;
>> >         struct pci_host_bridge *bridge;
>> >         struct myhostbridge_port *pp;
>> >         resource_size_t lastbus;
>> >
>> >         dev = pdev->dev.of_node;
>> >
>> >         if (!of_device_is_available(dev)) {
>> >                 pr_warn("%s: disabled\n", dev->full_name);
>> >                 return -ENODEV;
>> >         }
>> >
>> >         pp = kzalloc(sizeof(struct myhostbridge_port), GFP_KERNEL);
>> >         if (!pp)
>> >                 return -ENOMEM;
>> >
>> >         bridge = of_create_pci_host_bridge(&pdev->dev, &myhostbridge_ops, pp);
>> >         if (IS_ERR(bridge)) {
>> >                 err = PTR_ERR(bridge);
>> >                 goto bridge_create_fail;
>> >         }
>> >
>> >         err = myhostbridge_setup(bridge->bus);
>> >         if (err)
>> >                 goto bridge_setup_fail;
>> >
>> >         /* We always enable PCI domains and we keep domain 0 backward
>> >          * compatible in /proc for video cards
>> >          */
>> >         pci_add_flags(PCI_ENABLE_PROC_DOMAINS);
>> >         pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);
>> >
>> >         lastbus = pci_scan_child_bus(bridge->bus);
>> >         pci_bus_update_busn_res_end(bridge->bus, lastbus);
>> >
>> >         pci_assign_unassigned_bus_resources(bridge->bus);
>> >
>> >         pci_bus_add_devices(bridge->bus);
>> >
>> >         return 0;
>> >
>> > bridge_setup_fail:
>> >         put_device(&bridge->dev);
>> >         device_unregister(&bridge->dev);
>> > bridge_create_fail:
>> >         kfree(pp);
>> >         return err;
>> > }
>> >
>> > Best regards,
>> > Liviu
>> >
>> >
>> > Catalin Marinas (1):
>> >   arm64: Extend the PCI I/O space to 16MB
>> >
>> > Liviu Dudau (2):
>> >   Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
>> >   arm64: Add architecture support for PCI
>> >
>> >  Documentation/arm64/memory.txt |  16 +--
>> >  arch/arm64/Kconfig             |  19 +++-
>> >  arch/arm64/include/asm/Kbuild  |   1 +
>> >  arch/arm64/include/asm/io.h    |   5 +-
>> >  arch/arm64/include/asm/pci.h   |  51 +++++++++
>> >  arch/arm64/kernel/Makefile     |   1 +
>> >  arch/arm64/kernel/pci.c        | 173 +++++++++++++++++++++++++++++++
>> >  include/asm-generic/io.h       |   2 +-
>> >  8 files changed, 258 insertions(+), 10 deletions(-)
>> >  create mode 100644 arch/arm64/include/asm/pci.h
>> >  create mode 100644 arch/arm64/kernel/pci.c
>> >
>> > --
>> > 1.9.0
>> >
>> >
>> > _______________________________________________
>> > linux-arm-kernel mailing list
>> > linux-arm-kernel@lists.infradead.org
>> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>
> --
> ====================
> | I would like to |
> | fix the world,  |
> | but they're not |
> | giving me the   |
>  \ source code!  /
>   ---------------
>     ¯\_(ツ)_/¯
>
