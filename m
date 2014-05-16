Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbaEPKdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:33:10 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39287 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbaEPKdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:33:06 -0400
MIME-Version: 1.0
In-Reply-To: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
Date: Fri, 16 May 2014 16:03:04 +0530
Message-ID: <CA+sq2Ccok5wtKjCZUkBhhj3WsiqFAoMgHK7LY210aBtMku+8SA@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] Add support for PCI in AArch64
From: Sunil Kovvuri <sunil.kovvuri@gmail.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>, kdb@lurndal.org,
        yu.zhao@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liviu,

I am using your ARM64 PCIe patches to write a PCIe host controller
driver for our SOC. I am facing an issue with SR-IOV capable device.

Consider an PCI Express endpoint connected to a PCI Express
Root Port.  The PCI Express endpoint provides PCI-SIG SR-IOV
capabilities with a single physical function and a large number
of virtual functions.  The Root Port contains a pci-pci bridge in
between it and the SR-IOV device.

When the SR-IOV capable device's driver tries to enable sriov
(pci_enable_sriov()) it fails to create/add PCI device for each
virtual function reporting  "not enough MMIO resources for SR-IOV".

In sriov_enable() (drivers/pci/iov.c)

 296        for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
 297                 bars |= (1 << (i + PCI_IOV_RESOURCES));
 298                 res = dev->resource + PCI_IOV_RESOURCES + i;
 299                 if (res->parent)
 300                         nres++;
 301         }
 302         if (nres != iov->nres) {
 303                 dev_err(&dev->dev, "not enough MMIO resources for
 SR-IOV\n");
 304                 return -ENOMEM;
 305         }

Here its checking if physical function's IOV resource has a parent or not.
Which is pci-pci bridge in this case. Otherwise it doesn't consider
that resource.

Added below api to your patch.
This will try to claim a resource while creating a PCI device which
inturn sets 'res->parent'.

Let me know if this is okay.

diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
index 9f29c9a..fbfb48f 100644
--- a/arch/arm64/kernel/pci.c
+++ b/arch/arm64/kernel/pci.c
@@ -125,6 +125,21 @@ resource_size_t pcibios_align_resource(void
*data, const struct resource *res,
        return res->start;
 }

+int pcibios_add_device(struct pci_dev *pdev)
+{
+        unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
+        struct resource *res;
+
+        for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+                res = &pdev->resource[i];
+                if (res->parent || !(res->flags & type_mask))
+                        continue;
+                pci_claim_resource(pdev, i);
+        }
+


On Fri, Mar 14, 2014 at 9:04 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> Hi,
>
> This patch adds support for PCI to AArch64. It is based on my v7 patch
> that adds support for creating generic host bridge structure from
> device tree. With that in place, I was able to boot a platform that
> has PCIe host bridge support and use a PCIe network card.
>
> I have dropped the RFC tag from the subject as I now have the ambitious goal
> of trying to get it mainlined.
>
> Changes from v6:
>   - Guard the pci_domain_nr() inline implementation with #ifdef CONFIG_PCI as
>     to avoid conflict with default empty version present in include/linux/pci.h.
>     Thanks to Jingoo Han for catching this.
>
> Changes from v5:
>   - Removed pcibios_fixup_bridge_ranges() as the week default version is fine.
>   - Removed the ALIGN() call in pcibios_align_resource()
>   - Stopped exporting pcibios_align_resource()
>
> Changes from v4:
>   - Fixed the pci_domain_nr() implementation for arm64. Now we use
>     find_pci_host_bride() to find the host bridge before we retrieve
>     the domain number.
>
> Changes from v3:
>   - Added Acks accumulated so far ;)
>   - Still carrying Catalin's patch for moving the PCI_IO_BASE until it
>     lands in linux-next or mainline, in order to ease applying the series
>
> Changes from v2:
>   - Implement an arch specific version of pci_register_io_range() and
>     pci_address_to_pio().
>   - Return 1 from pci_proc_domain().
>
> Changes from v1:
>   - Added Catalin's patch for moving the PCI_IO_BASE location and extend
>     its size to 16MB
>   - Integrated Arnd's version of pci_ioremap_io that uses a bitmap for
>     keeping track of assigned IO space and returns an io_offset. At the
>     moment the code is added in arch/arm64 but it can be moved in drivers/pci.
>   - Added a fix for the generic ioport_map() function when !CONFIG_GENERIC_IOMAP
>     as suggested by Arnd.
>
> v6 thread here: https://lkml.org/lkml/2014/3/5/41
> v5 thread here: https://lkml.org/lkml/2014/3/4/307
> v4 thread here: https://lkml.org/lkml/2014/3/3/298
> v3 thread here: https://lkml.org/lkml/2014/2/28/211
> v2 thread here: https://lkml.org/lkml/2014/2/27/255
> v1 thread here: https://lkml.org/lkml/2014/2/3/389
>
>
> The API used is different from the one used by ARM architecture. There is
> no pci_common_init_dev() function and no hw_pci structure, as that is no
> longer needed. Once the last signature is added to the legal agreement, I
> will post the host bridge driver code that I am using. Meanwhile, here
> is an example of what the probe function looks like, posted as an example:
>
> static int myhostbridge_probe(struct platform_device *pdev)
> {
>         int err;
>         struct device_node *dev;
>         struct pci_host_bridge *bridge;
>         struct myhostbridge_port *pp;
>         resource_size_t lastbus;
>
>         dev = pdev->dev.of_node;
>
>         if (!of_device_is_available(dev)) {
>                 pr_warn("%s: disabled\n", dev->full_name);
>                 return -ENODEV;
>         }
>
>         pp = kzalloc(sizeof(struct myhostbridge_port), GFP_KERNEL);
>         if (!pp)
>                 return -ENOMEM;
>
>         bridge = of_create_pci_host_bridge(&pdev->dev, &myhostbridge_ops, pp);
>         if (IS_ERR(bridge)) {
>                 err = PTR_ERR(bridge);
>                 goto bridge_create_fail;
>         }
>
>         err = myhostbridge_setup(bridge->bus);
>         if (err)
>                 goto bridge_setup_fail;
>
>         /* We always enable PCI domains and we keep domain 0 backward
>          * compatible in /proc for video cards
>          */
>         pci_add_flags(PCI_ENABLE_PROC_DOMAINS);
>         pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);
>
>         lastbus = pci_scan_child_bus(bridge->bus);
>         pci_bus_update_busn_res_end(bridge->bus, lastbus);
>
>         pci_assign_unassigned_bus_resources(bridge->bus);
>
>         pci_bus_add_devices(bridge->bus);
>
>         return 0;
>
> bridge_setup_fail:
>         put_device(&bridge->dev);
>         device_unregister(&bridge->dev);
> bridge_create_fail:
>         kfree(pp);
>         return err;
> }
>
> Best regards,
> Liviu
>
>
> Catalin Marinas (1):
>   arm64: Extend the PCI I/O space to 16MB
>
> Liviu Dudau (2):
>   Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
>   arm64: Add architecture support for PCI
>
>  Documentation/arm64/memory.txt |  16 +--
>  arch/arm64/Kconfig             |  19 +++-
>  arch/arm64/include/asm/Kbuild  |   1 +
>  arch/arm64/include/asm/io.h    |   5 +-
>  arch/arm64/include/asm/pci.h   |  51 +++++++++
>  arch/arm64/kernel/Makefile     |   1 +
>  arch/arm64/kernel/pci.c        | 173 +++++++++++++++++++++++++++++++
>  include/asm-generic/io.h       |   2 +-
>  8 files changed, 258 insertions(+), 10 deletions(-)
>  create mode 100644 arch/arm64/include/asm/pci.h
>  create mode 100644 arch/arm64/kernel/pci.c
>
> --
> 1.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
