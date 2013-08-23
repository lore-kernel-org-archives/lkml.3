Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3HWVqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:46:33 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62791 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3HWVqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130823000252.GA29441@google.com>
References: <1375970227-14794-1-git-send-email-rkrcmar@redhat.com> <20130823000252.GA29441@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 23 Aug 2013 15:46:10 -0600
Message-ID: <CAErSpo6+vT7-8NWZETCOzn55SMOp_h+ff46i2bfj52xYznMGTQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: avoid NULL deref in alloc_pcie_link_state
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>, Shaohua Li <shli@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Shaohua]

On Thu, Aug 22, 2013 at 6:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Aug 08, 2013 at 03:57:07PM +0200, Radim Krčmář wrote:
>> PCIe switch can be connected directly to the PCIe root complex in QEMU;
>> ASPM does not expect this topology and dereferences NULL pointer when
>> initializing.
>>
>> Downstream port can be also connected to the root complex without
>> upstream one, so code checks for both, otherwise they dereference NULL
>> on line drivers/pci/pcie/aspm.c:530 (alloc_pcie_link_state+13):
>>               parent = pdev->bus->parent->self->link_state;
>> "pdev->bus->parent->self == NULL" if upstream port is connected directly
>> to the root bus and "pdev->bus->parent == NULL" in the second case.
>>
>> v1 -> v2: (https://lkml.org/lkml/2013/6/19/753)
>>  - Initialization is aborted in pcie_aspm_init_link_state, where other
>>    special cases are being handled
>>  - pci_is_root_bus is used
>>  - Warning is printed
>>
>> Reproducer for "downstream -- root" and "downstream -- upstream -- root"
>> (used qemu-kvm 1.5, q35 machine type might be missing on older ones)
>>
>>   for parent in pcie.0 upstream; do
>>    qemu-kvm -m 128 -M q35 -nographic -no-reboot \
>>      -device x3130-upstream,bus=pcie.0,id=upstream \
>>      -device xio3130-downstream,bus=$parent,id=downstream,chassis=1 \
>>      -device virtio-blk-pci,bus=downstream,id=virtio-zero,drive=zero \
>>      -drive  file=/dev/zero,id=zero,format=raw \
>>      -kernel bzImage -append "console=ttyS0 panic=3" # pcie_aspm=off
>>   done
>>
>> ASPM in QEMU works if we connect upstream through root port
>>   -device ioh3420,bus=pcie.0,id=root.0 \
>>   -device x3130-upstream,bus=root.0,id=upstream
>>
>> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
>> ---
>>  drivers/pci/pcie/aspm.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
>> index 403a443..209cd7f 100644
>> --- a/drivers/pci/pcie/aspm.c
>> +++ b/drivers/pci/pcie/aspm.c
>> @@ -570,6 +570,15 @@ void pcie_aspm_init_link_state(struct pci_dev *pdev)
>>           pdev->bus->self)
>>               return;
>>
>> +     /* We require at least two ports between downstream and root bus */
>> +     if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM &&
>> +         (pci_is_root_bus(pdev->bus) ||
>> +          pci_is_root_bus(pdev->bus->parent))) {
>> +             dev_warn(&pdev->dev, "ASPM disabled"
>> +                                  " (connected directly to root bus)\n");
>> +             return;
>> +     }
>
> I don't really want to detect invalid topologies piecemeal -- we will
> likely find other areas (MPS, AER, link speed management, etc.) that
> have similar dependencies.  I'd rather do it generically, maybe with
> something like the following patch.
>
> I tried this with the following qemu invocation:
>
>     $ /usr/local/bin/qemu-system-x86_64 -M q35 -enable-kvm -m 512   -device x3130-upstream,bus=pcie.0,id=upstream   -device xio3130-downstream,bus=upstream,id=downstream,chassis=1   -drive file=ubuntu.img,if=none,id=mydisk   -device ide-drive,drive=mydisk,bus=ide.0   -drive file=scratch.img,id=disk1 -device virtio-blk-pci,bus=downstream,id=virtio-disk1,drive=disk1 -nographic -kernel ~/linux/arch/x86/boot/bzImage   -append "console=ttyS0,115200n8 root=/dev/sda1 ignore_loglevel"
>
> With unmodified v3.11-rc2, I see the NULL pointer dereference, but with
> the patch below applied, we just ignore the 00:03.0 device and the kernel
> boots fine.

Thinking about this some more, I'm inclined to do nothing.  The patch
below *would* avoid the issue, but it's a fair bit of code and
comments that future code readers would have to wade through, and the
only benefit is for topologies that are completely invalid and will
never be seen in real hardware.

I think that we could also avoid this issue by reworking our ASPM
support, and if we were to do anything, that's what I would prefer.
For example, consider the following (legal and common) topology:

    00:1c.0 Root Port (bridge leading to [bus 01-03])
    01:00.0 Upstream Port (bridge leading to [bus 02-03])
    02:00.0 Downstream Port (bridge leading to [bus 03])

When we initialize ASPM link state for 02:00.0, we look all the way up
to the link state for 00:1c.0 (the
"pdev->bus->parent->self->link_state" in alloc_pcie_link_state()).  I
think that's crazy.  ASPM is fundamentally a feature of a *link*, and
the only link directly related to 02:00.0 is the one leading
*downstream* to device 03:00.0.

I know there are latency questions where we do care about upstream
links, and there's commit 46bbdfa44c, which is what originally added
this "pdev->bus->parent->self->link_state" expression.  It suggests
that we need to check the whole hierarchy up to the root port.  But
there's not enough information in the changelog to really explain it.

So I strongly support rework that would simplify ASPM management
overall.   I just don't want to add point fixes that only handle
special cases, especially when they don't occur in the real world.

Bjorn

> ---
>  arch/powerpc/kernel/pci_of_scan.c |    7 ++++++-
>  arch/sparc/kernel/pci.c           |    7 ++++++-
>  drivers/pci/probe.c               |   37 +++++++++++++++++++++++++++++++++----
>  include/linux/pci.h               |    2 +-
>  4 files changed, 46 insertions(+), 7 deletions(-)
>
> diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
> index 6b0ba58..f6ef4dd 100644
> --- a/arch/powerpc/kernel/pci_of_scan.c
> +++ b/arch/powerpc/kernel/pci_of_scan.c
> @@ -143,7 +143,6 @@ struct pci_dev *of_create_pci_dev(struct device_node *node,
>         dev->devfn = devfn;
>         dev->multifunction = 0;         /* maybe a lie? */
>         dev->needs_freset = 0;          /* pcie fundamental reset required */
> -       set_pcie_port_type(dev);
>
>         list_for_each_entry(slot, &dev->bus->slots, list)
>                 if (PCI_SLOT(dev->devfn) == slot->number)
> @@ -164,6 +163,12 @@ struct pci_dev *of_create_pci_dev(struct device_node *node,
>         pr_debug("    class: 0x%x\n", dev->class);
>         pr_debug("    revision: 0x%x\n", dev->revision);
>
> +       if (set_pcie_port_type(dev)) {
> +               pci_bus_put(dev->bus);
> +               kfree(dev);
> +               return NULL;
> +       }
> +
>         dev->current_state = PCI_UNKNOWN;       /* unknown power state */
>         dev->error_state = pci_channel_io_normal;
>         dev->dma_mask = 0xffffffff;
> diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
> index bc4d3f5..5600849 100644
> --- a/arch/sparc/kernel/pci.c
> +++ b/arch/sparc/kernel/pci.c
> @@ -287,7 +287,6 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
>         dev->dev.of_node = of_node_get(node);
>         dev->devfn = devfn;
>         dev->multifunction = 0;         /* maybe a lie? */
> -       set_pcie_port_type(dev);
>
>         list_for_each_entry(slot, &dev->bus->slots, list)
>                 if (PCI_SLOT(dev->devfn) == slot->number)
> @@ -319,6 +318,12 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
>                 printk("    class: 0x%x device name: %s\n",
>                        dev->class, pci_name(dev));
>
> +       if (set_pcie_port_type(dev)) {
> +               pci_bus_put(dev->bus);
> +               kfree(dev);
> +               return NULL;
> +       }
> +
>         /* I have seen IDE devices which will not respond to
>          * the bmdma simplex check reads if bus mastering is
>          * disabled.
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index cf57fe7..a8cc929 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -970,20 +970,47 @@ static void pci_read_irq(struct pci_dev *dev)
>         dev->irq = irq;
>  }
>
> -void set_pcie_port_type(struct pci_dev *pdev)
> +int set_pcie_port_type(struct pci_dev *pdev)
>  {
> -       int pos;
> +       int pos, type;
>         u16 reg16;
> +       struct pci_dev *parent;
>
>         pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
>         if (!pos)
> -               return;
> +               return 0;
> +
>         pdev->is_pcie = 1;
>         pdev->pcie_cap = pos;
>         pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
>         pdev->pcie_flags_reg = reg16;
>         pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
>         pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
> +
> +       type = pci_pcie_type(pdev);
> +       parent = pdev->bus->self;
> +
> +       /* An Upstream Port must be below a Root Port or a Downstream Port */
> +       if (type == PCI_EXP_TYPE_UPSTREAM) {
> +               if (!parent ||
> +                   (pci_pcie_type(parent) != PCI_EXP_TYPE_ROOT_PORT &&
> +                    pci_pcie_type(parent) != PCI_EXP_TYPE_DOWNSTREAM)) {
> +                       dev_warn(&pdev->dev,
> +                                "ignoring improperly connected PCIe switch\n");
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       /* A Downstream Port must be directly below an Upstream Port */
> +       if (type == PCI_EXP_TYPE_DOWNSTREAM) {
> +               if (!parent ||
> +                   pci_pcie_type(parent) != PCI_EXP_TYPE_UPSTREAM) {
> +                       dev_warn(&pdev->dev, "ignoring malformed PCIe switch (no Upstream Port)\n");
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       return 0;
>  }
>
>  void set_pcie_hotplug_bridge(struct pci_dev *pdev)
> @@ -1025,7 +1052,6 @@ int pci_setup_device(struct pci_dev *dev)
>         dev->hdr_type = hdr_type & 0x7f;
>         dev->multifunction = !!(hdr_type & 0x80);
>         dev->error_state = pci_channel_io_normal;
> -       set_pcie_port_type(dev);
>
>         list_for_each_entry(slot, &dev->bus->slots, list)
>                 if (PCI_SLOT(dev->devfn) == slot->number)
> @@ -1046,6 +1072,9 @@ int pci_setup_device(struct pci_dev *dev)
>         dev_printk(KERN_DEBUG, &dev->dev, "[%04x:%04x] type %02x class %#08x\n",
>                    dev->vendor, dev->device, dev->hdr_type, dev->class);
>
> +       if (set_pcie_port_type(dev))
> +               return -EINVAL;
> +
>         /* need to have dev->class ready */
>         dev->cfg_size = pci_cfg_space_size(dev);
>
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 89ed123..a61134b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -982,7 +982,7 @@ void pci_disable_ltr(struct pci_dev *dev);
>  int pci_set_ltr(struct pci_dev *dev, int snoop_lat_ns, int nosnoop_lat_ns);
>
>  /* For use by arch with custom probe code */
> -void set_pcie_port_type(struct pci_dev *pdev);
> +int set_pcie_port_type(struct pci_dev *pdev);
>  void set_pcie_hotplug_bridge(struct pci_dev *pdev);
>
>  /* Functions for PCI Hotplug drivers to use */
