Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3FGIr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:47:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57758 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3FGIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:47:21 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51B19DF3.2070009@jp.fujitsu.com>
Date: Fri, 07 Jun 2013 17:46:43 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: bhelgaas@google.com
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        ishii.hironobu@jp.fujitsu.com, ddutile@redhat.com, bill.sumner@hp.com,
        alex.williamson@redhat.com
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com> <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>
In-Reply-To: <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comments!

(2013/06/07 13:14), Bjorn Helgaas wrote:
> Sorry it's taken me so long to look at this.  I've been putting this
> off because the patch doesn't seem "obviously correct," and I don't
> feel like I really understand the problem.  I'm naive about both
> IOMMUs and kexec/kdump, so please pardon (and help me with) any silly
> questions or assumptions below.
> 
> On Mon, May 13, 2013 at 11:29 PM, Takao Indoh
> <indou.takao@jp.fujitsu.com> wrote:
>> This patch resets PCIe devices on boot to stop ongoing DMA. When
>> "pci=pcie_reset_endpoint_devices" is specified, a hot reset is triggered
>> on each PCIe root port and downstream port to reset its downstream
>> endpoint.
>>
>> Problem:
>> This patch solves the problem that kdump can fail when intel_iommu=on is
>> specified. When intel_iommu=on is specified, many dma-remapping errors
>> occur in second kernel and it causes problems like driver error or PCI
>> SERR, at last kdump fails. This problem is caused as follows.
>> 1) Devices are working on first kernel.
>> 2) Switch to second kernel(kdump kernel). The devices are still working
>>     and its DMA continues during this switch.
>> 3) iommu is initialized during second kernel boot and ongoing DMA causes
>>     dma-remapping errors.
> 
> If I understand correctly, the problem only happens on systems with an
> IOMMU that's enabled in either the system or kdump kernel (or both).
> For systems without an IOMMU (or if it is disabled in both the system
> and kdump kernels),  any ongoing DMA should use addresses that target
> system-kernel memory and should not affect the kdump kernel.

Yes, that's correct.

> One thing I'm not sure about is that you are only resetting PCIe
> devices, but I don't think the problem is actually specific to PCIe,
> is it?  I think the same issue could occur on any system with an
> IOMMU.  In the x86 PC world, most IOMMUs are connected with PCIe, but
> there are systems with IOMMUs for plain old PCI devices, e.g.,
> PA-RISC.

Right, this is not specific to PCIe. The reasons why the target is only
PCIe is just to make algorithm to reset simple. It is possible to reset
legacy PCI devices in my patch, but code becomes somewhat complicated. I
thought recently most systems used PCIe and there was little demand for
resetting legacy PCI. Therefore I decided not to reset legacy PCI
devices, but I'll do if there are requests :-)

> 
> I tried to make a list of the interesting scenarios and the events
> that are relevant to this problem:
> 
>      Case 1: IOMMU off in system, off in kdump kernel
>        system kernel leaves IOMMU off
>          DMA targets system-kernel memory
>        kexec to kdump kernel (IOMMU off, devices untouched)
>          DMA targets system-kernel memory (harmless)
>        kdump kernel re-inits device
>          DMA targets kdump-kernel memory
> 
>      Case 2: IOMMU off in system kernel, on in kdump kernel
>        system kernel leaves IOMMU off
>          DMA targets system-kernel memory
>        kexec to kdump kernel (IOMMU off, devices untouched)
>          DMA targets system-kernel memory (harmless)
>        kdump kernel enables IOMMU with no valid mappings
>          DMA causes IOMMU errors (annoying but harmless)
>        kdump kernel re-inits device
>          DMA targets IOMMU-mapped kdump-kernel memory
> 
>      Case 3a: IOMMU on in system kernel, kdump kernel doesn't touch IOMMU
>        system kernel enables IOMMU
>          DMA targets IOMMU-mapped system-kernel memory
>        kexec to kdump kernel (IOMMU on, devices untouched)
>          DMA targets IOMMU-mapped system-kernel memory
>        kdump kernel doesn't know about IOMMU or doesn't touch it
>          DMA targets IOMMU-mapped system-kernel memory
>        kdump kernel re-inits device
>          kernel assumes no IOMMU, so all new DMA mappings are invalid
> because DMAs actually do go through the IOMMU
>          (** corruption or other non-recoverable error likely **)
> 
>      Case 3b: IOMMU on in system kernel, kdump kernel disables IOMMU
>        system kernel enables IOMMU
>          DMA targets IOMMU-mapped system-kernel memory
>        kexec to kdump kernel (IOMMU on, devices untouched)
>          DMA targets IOMMU-mapped system-kernel memory
>        kdump kernel disables IOMMU
>          DMA targets IOMMU-mapped system-kernel memory, but IOMMU is disabled
>          (** corruption or other non-recoverable error likely **)
>        kdump kernel re-inits device
>          DMA targets kdump-kernel memory
> 
>      Case 4: IOMMU on in system kernel, on in kdump kernel
>        system kernel enables IOMMU
>          DMA targets IOMMU-mapped system-kernel memory
>        kexec to kdump kernel (IOMMU on, devices untouched)
>          DMA targets IOMMU-mapped system-kernel memory
>        kdump kernel enables IOMMU with no valid mappings
>          DMA causes IOMMU errors (annoying but harmless)

This is not harmless. Errors like PCI SERR are detected here, and it
makes driver or system unstable, and kdump fails. I also got report that
system hangs up due to this.


>        kdump kernel re-inits device
>          DMA targets IOMMU-mapped kdump-kernel memory
> 
> The problem cases I see are 3a and 3b, but that's not the problem
> you're describing.  Obviously I'm missing something.
> 
> It sounds like you're seeing problems in case 2 or case 4, where the
> IOMMU is enabled in the kdump kernel.  Maybe my assumption about the
> IOMMU being enabled with no valid mappings is wrong?  Or maybe those
> IOMMU errors are not actually harmless?

As I wrote above, IOMMU errors are not harmless. What I know is:

Case 1:  Harmless
Case 2:  Not tested
Case 3a: Not tested
Case 3b: Cause problem, fixed by my patch
Case 4:  Cause problem, fixed by my patch

I have never tested case 2 and 3a, but I think it also causes problem.

 
> Resetting PCI/PCIe devices will help with cases 2, 4, and 3b, but not
> with case 3a.  Therefore, it seems like the kdump kernel *must*
> contain IOMMU support unless it knows for certain that the system
> kernel wasn't using the IOMMU.

Yes, kdump kernel has to be compiled with support for IOMMU.


> 
> Do you have any bugzilla references or problem report URLs you could
> include here?

I know three Red Hat bugzilla, but I think these are private article and
you cannot see. I'll add you Cc list in bz so that you can see.

BZ#743790: Kdump fails with intel_iommu=on
https://bugzilla.redhat.com/show_bug.cgi?id=743790

BZ#743495: Hardware error is detected with intel_iommu=on
https://bugzilla.redhat.com/show_bug.cgi?id=743495

BZ#833299: megaraid_sas doesn't work well with intel_iommu=on and iommu=pt
https://bugzilla.redhat.com/show_bug.cgi?id=833299

> 
> Obviously I'm very confused here, so please help educate me :)
> 
> Also, you mentioned PCI passthrough with a KVM guest as being a
> problem.  Can you explain more about what makes that a problem?  I
> don't know enough about passthrough to know why a device being used by
> a KVM guest would cause more problems than a device being used
> directly by the host.

Sorry, my explanation was misleading. I mentioned PCI passthrough as
usage example of IOMMU. To assign devices to KVM guest directly using
PCI passthrough, we have to enable IOMMU for host kernel. But if you
enable IOMMU and panic happens in the host, kdump starts in the host but
it fails due to the problem I mentioned in patch description.
Did I answer your question?

Thanks,
Takao Indoh


> 
> Bjorn
> 
>> Solution:
>> All DMA transactions have to be stopped before iommu is initialized. By
>> this patch devices are reset and in-flight DMA is stopped before
>> pci_iommu_init.
>>
>> To invoke hot reset on an endpoint, its upstream link need to be reset.
>> reset_pcie_endpoints() is called from fs_initcall_sync, and it finds
>> root port/downstream port whose child is PCIe endpoint, and then reset
>> link between them. If the endpoint is VGA device, it is skipped because
>> the monitor blacks out if VGA controller is reset.
>>
>> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
>> ---
>>   Documentation/kernel-parameters.txt |    2 +
>>   drivers/pci/pci.c                   |  113 +++++++++++++++++++++++++++++++++++
>>   2 files changed, 115 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index c3bfacb..8c9e8e4 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2321,6 +2321,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>                                  any pair of devices, possibly at the cost of
>>                                  reduced performance.  This also guarantees
>>                                  that hot-added devices will work.
>> +               pcie_reset_endpoint_devices     Reset PCIe endpoint on boot by
>> +                               hot reset
>>                  cbiosize=nn[KMG]        The fixed amount of bus space which is
>>                                  reserved for the CardBus bridge's IO window.
>>                                  The default value is 256 bytes.
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index a899d8b..70c1205 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -3873,6 +3873,116 @@ void __weak pci_fixup_cardbus(struct pci_bus *bus)
>>   }
>>   EXPORT_SYMBOL(pci_fixup_cardbus);
>>
>> +/*
>> + * Return true if dev is PCIe root port or downstream port whose child is PCIe
>> + * endpoint except VGA device.
>> + */
>> +static int __init need_reset(struct pci_dev *dev)
>> +{
>> +       struct pci_bus *subordinate;
>> +       struct pci_dev *child;
>> +
>> +       if (!pci_is_pcie(dev) || !dev->subordinate ||
>> +           list_empty(&dev->subordinate->devices) ||
>> +           ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT) &&
>> +            (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
>> +               return 0;
>> +
>> +       subordinate = dev->subordinate;
>> +       list_for_each_entry(child, &subordinate->devices, bus_list) {
>> +               if ((pci_pcie_type(child) == PCI_EXP_TYPE_UPSTREAM) ||
>> +                   (pci_pcie_type(child) == PCI_EXP_TYPE_PCI_BRIDGE) ||
>> +                   ((child->class >> 16) == PCI_BASE_CLASS_DISPLAY))
>> +                       /* Don't reset switch, bridge, VGA device */
>> +                       return 0;
>> +       }
>> +
>> +       return 1;
>> +}
>> +
>> +static void __init save_downstream_configs(struct pci_dev *dev)
>> +{
>> +       struct pci_bus *subordinate;
>> +       struct pci_dev *child;
>> +
>> +       subordinate = dev->subordinate;
>> +       list_for_each_entry(child, &subordinate->devices, bus_list) {
>> +               dev_info(&child->dev, "save state\n");
>> +               pci_save_state(child);
>> +       }
>> +}
>> +
>> +static void __init restore_downstream_configs(struct pci_dev *dev)
>> +{
>> +       struct pci_bus *subordinate;
>> +       struct pci_dev *child;
>> +
>> +       subordinate = dev->subordinate;
>> +       list_for_each_entry(child, &subordinate->devices, bus_list) {
>> +               dev_info(&child->dev, "restore state\n");
>> +               pci_restore_state(child);
>> +       }
>> +}
>> +
>> +static void __init do_downstream_device_reset(struct pci_dev *dev)
>> +{
>> +       u16 ctrl;
>> +
>> +       dev_info(&dev->dev, "Reset Secondary bus\n");
>> +
>> +       /* Assert Secondary Bus Reset */
>> +       pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &ctrl);
>> +       ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
>> +       pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>> +
>> +       /* Read config again to flush previous write */
>> +       pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &ctrl);
>> +
>> +       msleep(2);
>> +
>> +       /* De-assert Secondary Bus Reset */
>> +       ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
>> +       pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>> +}
>> +
>> +struct pci_dev_entry {
>> +       struct list_head list;
>> +       struct pci_dev *dev;
>> +};
>> +static int __initdata pcie_reset_endpoint_devices;
>> +static int __init reset_pcie_endpoints(void)
>> +{
>> +       struct pci_dev *dev = NULL;
>> +       struct pci_dev_entry *pdev_entry, *tmp;
>> +       LIST_HEAD(pdev_list);
>> +
>> +       if (!pcie_reset_endpoint_devices)
>> +               return 0;
>> +
>> +       for_each_pci_dev(dev)
>> +               if (need_reset(dev)) {
>> +                       pdev_entry = kmalloc(sizeof(*pdev_entry), GFP_KERNEL);
>> +                       pdev_entry->dev = dev;
>> +                       list_add(&pdev_entry->list, &pdev_list);
>> +               }
>> +
>> +       list_for_each_entry(pdev_entry, &pdev_list, list)
>> +               save_downstream_configs(pdev_entry->dev);
>> +
>> +       list_for_each_entry(pdev_entry, &pdev_list, list)
>> +               do_downstream_device_reset(pdev_entry->dev);
>> +
>> +       msleep(1000);
>> +
>> +       list_for_each_entry_safe(pdev_entry, tmp, &pdev_list, list) {
>> +               restore_downstream_configs(pdev_entry->dev);
>> +               kfree(pdev_entry);
>> +       }
>> +
>> +       return 0;
>> +}
>> +fs_initcall_sync(reset_pcie_endpoints);
>> +
>>   static int __init pci_setup(char *str)
>>   {
>>          while (str) {
>> @@ -3915,6 +4025,9 @@ static int __init pci_setup(char *str)
>>                                  pcie_bus_config = PCIE_BUS_PEER2PEER;
>>                          } else if (!strncmp(str, "pcie_scan_all", 13)) {
>>                                  pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
>> +                       } else if (!strncmp(str, "pcie_reset_endpoint_devices",
>> +                                               27)) {
>> +                               pcie_reset_endpoint_devices = 1;
>>                          } else {
>>                                  printk(KERN_ERR "PCI: Unknown option `%s'\n",
>>                                                  str);
>> --
>> 1.7.1
>>
>>
> 
> 

