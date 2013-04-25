Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3DYFMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:12:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59294 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3DYFMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:12:23 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5178BAFB.9060100@jp.fujitsu.com>
Date: Thu, 25 Apr 2013 14:11:23 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: ddutile@redhat.com
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH] Reset PCIe devices to stop ongoing DMA
References: <1366779539-3584-1-git-send-email-indou.takao@jp.fujitsu.com> <51783987.2040604@redhat.com>
In-Reply-To: <51783987.2040604@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/25 4:59), Don Dutile wrote:
> On 04/24/2013 12:58 AM, Takao Indoh wrote:
>> This patch resets PCIe devices on boot to stop ongoing DMA. When
>> "pci=pcie_reset_devices" is specified, a hot reset is triggered on each
>> PCIe root port and downstream port to reset its downstream endpoint.
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
>>
>> Solution:
>> All DMA transactions have to be stopped before iommu is initialized. By
>> this patch devices are reset and in-flight DMA is stopped before
>> pci_iommu_init.
>>
>> To invoke hot reset on an endpoint, its upstream link need to be reset.
>> reset_pcie_devices() is called from fs_initcall_sync, and it finds root
>> port/downstream port whose child is PCIe endpoint, and then reset link
>> between them. If the endpoint is VGA device, it is skipped because the
>> monitor blacks out if VGA controller is reset.
>>
> Couple questions wrt VGA device:
> (1) Many graphics devices are multi-function, one function being VGA;
>      is the VGA always function 0, so this scan sees it first & doesn't
>      do a reset on that PCIe link?  if the VGA is not function 0, won't
>      this logic break (will reset b/c function 0 is non-VGA graphics) ?

VGA is not reset irrespective of its function number. The logic of this
patch is:

for_each_pci_dev(dev) {
    if (dev is not PCIe)
       continue;
    if (dev is not root port/downstream port) ---(1)
       continue;
    list_for_each_entry(child,&dev->subordinate->devices, bus_list) {
        if (child is upstream port or bridge or VGA) ---(2)
            continue;
    }
    do_reset_its_child(dev);
}

Therefore VGA itself is skipped by (1), and upstream device(root port or
downstream port) of VGA is also skipped by (2).


> (2) I'm hearing VGA will soon not be the a required console; this logic
>      assumes it is, and why it isn't blanked.
>      Q: Should the filter be based on a device having a device-class of display ?

I want to avoid the situation that user's monitor blacks out and user
cannot know what's going on. That's reason why I introduced the logic to
skip VGA. As far as I tested the logic based on device-class works well,
but I would appreciate it if there are better ways.

> 
>> Actually this is v8 patch but quite different from v7 and it's been so
>> long since previous post, so I start over again.
> Thanks for this re-start.  I need to continue reviewing the rest.

Thank you for your review!

> 
> Q: Why not force IOMMU off when re-booting a kexec kernel to perform a crash
>     dump?  After the crash dump, the system is rebooting to previous (iommu=on) setting.
>     That logic, along w/your previous patch to disable the IOMMU if iommu=off
>     is set, would remove this (relatively slow) PCI init sequencing ?

To force iommu off, all ongoing DMA have to be stopped before that since
they are accessing the device address, not physical address. If we disable
iommu without stopping in-flihgt DMA, devices access invalid memory area
and it causes memory corruption or PCI-SERR due to DMA error.

So, whether we use iommu or not in second kernel, we have to stop DMA in
second kernel if iommu is used in first kernel.

Thanks,
Takao Indoh


> 
>> Previous post:
>> [PATCH v7 0/5] Reset PCIe devices to address DMA problem on kdump
>> https://lkml.org/lkml/2012/11/26/814
>>
>> Signed-off-by: Takao Indoh<indou.takao@jp.fujitsu.com>
>> ---
>>   Documentation/kernel-parameters.txt |    2 +
>>   drivers/pci/pci.c                   |  103 +++++++++++++++++++++++++++++++++++
>>   2 files changed, 105 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 4609e81..2a31ade 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2250,6 +2250,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>                   any pair of devices, possibly at the cost of
>>                   reduced performance.  This also guarantees
>>                   that hot-added devices will work.
>> +        pcie_reset_devices    Reset PCIe endpoint on boot by hot
>> +                reset
>>           cbiosize=nn[KMG]    The fixed amount of bus space which is
>>                   reserved for the CardBus bridge's IO window.
>>                   The default value is 256 bytes.
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index b099e00..42385c9 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -3878,6 +3878,107 @@ void __weak pci_fixup_cardbus(struct pci_bus *bus)
>>   }
>>   EXPORT_SYMBOL(pci_fixup_cardbus);
>>
>> +/*
>> + * Return true if dev is PCIe root port or downstream port whose child is PCIe
>> + * endpoint except VGA device.
>> + */
>> +static int __init need_reset(struct pci_dev *dev)
>> +{
>> +    struct pci_bus *subordinate;
>> +    struct pci_dev *child;
>> +
>> +    if (!pci_is_pcie(dev) || !dev->subordinate ||
>> +        list_empty(&dev->subordinate->devices) ||
>> +        ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT)&&
>> +         (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
>> +        return 0;
>> +
>> +    subordinate = dev->subordinate;
>> +    list_for_each_entry(child,&subordinate->devices, bus_list) {
>> +        if ((pci_pcie_type(child) == PCI_EXP_TYPE_UPSTREAM) ||
>> +            (pci_pcie_type(child) == PCI_EXP_TYPE_PCI_BRIDGE) ||
>> +            ((child->class>>  16) == PCI_BASE_CLASS_DISPLAY))
>> +            /* Don't reset switch, bridge, VGA device */
>> +            return 0;
>> +    }
>> +
>> +    return 1;
>> +}
>> +
>> +static void __init save_config(struct pci_dev *dev)
>> +{
>> +    struct pci_bus *subordinate;
>> +    struct pci_dev *child;
>> +
>> +    if (!need_reset(dev))
>> +        return;
>> +
>> +    subordinate = dev->subordinate;
>> +    list_for_each_entry(child,&subordinate->devices, bus_list) {
>> +        dev_info(&child->dev, "save state\n");
>> +        pci_save_state(child);
>> +    }
>> +}
>> +
>> +static void __init restore_config(struct pci_dev *dev)
>> +{
>> +    struct pci_bus *subordinate;
>> +    struct pci_dev *child;
>> +
>> +    if (!need_reset(dev))
>> +        return;
>> +
>> +    subordinate = dev->subordinate;
>> +    list_for_each_entry(child,&subordinate->devices, bus_list) {
>> +        dev_info(&child->dev, "restore state\n");
>> +        pci_restore_state(child);
>> +    }
>> +}
>> +
>> +static void __init do_device_reset(struct pci_dev *dev)
>> +{
>> +    u16 ctrl;
>> +
>> +    if (!need_reset(dev))
>> +        return;
>> +
>> +    dev_info(&dev->dev, "Reset Secondary bus\n");
>> +
>> +    /* Assert Secondary Bus Reset */
>> +    pci_read_config_word(dev, PCI_BRIDGE_CONTROL,&ctrl);
>> +    ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
>> +    pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>> +
>> +    msleep(2);
>> +
>> +    /* De-assert Secondary Bus Reset */
>> +    ctrl&= ~PCI_BRIDGE_CTL_BUS_RESET;
>> +    pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>> +}
>> +
>> +static int __initdata pcie_reset_devices;
>> +static int __init reset_pcie_devices(void)
>> +{
>> +    struct pci_dev *dev = NULL;
>> +
>> +    if (!pcie_reset_devices)
>> +        return 0;
>> +
>> +    for_each_pci_dev(dev)
>> +        save_config(dev);
>> +
>> +    for_each_pci_dev(dev)
>> +        do_device_reset(dev);
>> +
>> +    msleep(1000);
>> +
>> +    for_each_pci_dev(dev)
>> +        restore_config(dev);
>> +
>> +    return 0;
>> +}
>> +fs_initcall_sync(reset_pcie_devices);
>> +
>>   static int __init pci_setup(char *str)
>>   {
>>       while (str) {
>> @@ -3920,6 +4021,8 @@ static int __init pci_setup(char *str)
>>                   pcie_bus_config = PCIE_BUS_PEER2PEER;
>>               } else if (!strncmp(str, "pcie_scan_all", 13)) {
>>                   pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
>> +            } else if (!strncmp(str, "pcie_reset_devices", 18)) {
>> +                pcie_reset_devices = 1;
>>               } else {
>>                   printk(KERN_ERR "PCI: Unknown option `%s'\n",
>>                           str);
> 
> 
> 

