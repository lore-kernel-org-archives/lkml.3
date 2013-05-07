Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab3EGUK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:10:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab3EGUKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:10:55 -0400
Message-ID: <51895FAB.5010805@redhat.com>
Date: Tue, 07 May 2013 16:10:19 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121116 Thunderbird/10.0.11
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Takao Indoh <indou.takao@jp.fujitsu.com>, bhelgaas@google.com,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reset PCIe devices to stop ongoing DMA
References: <1366779539-3584-1-git-send-email-indou.takao@jp.fujitsu.com> <1367944782.2868.106.camel@ul30vt.home>
In-Reply-To: <1367944782.2868.106.camel@ul30vt.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 12:39 PM, Alex Williamson wrote:
> On Wed, 2013-04-24 at 13:58 +0900, Takao Indoh wrote:
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
>> Actually this is v8 patch but quite different from v7 and it's been so
>> long since previous post, so I start over again.
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
>>   				any pair of devices, possibly at the cost of
>>   				reduced performance.  This also guarantees
>>   				that hot-added devices will work.
>> +		pcie_reset_devices	Reset PCIe endpoint on boot by hot
>> +				reset
>>   		cbiosize=nn[KMG]	The fixed amount of bus space which is
>>   				reserved for the CardBus bridge's IO window.
>>   				The default value is 256 bytes.
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
>> +	struct pci_bus *subordinate;
>> +	struct pci_dev *child;
>> +
>> +	if (!pci_is_pcie(dev) || !dev->subordinate ||
>> +	    list_empty(&dev->subordinate->devices) ||
>> +	    ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT)&&
>> +	     (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
>> +		return 0;
>> +
>> +	subordinate = dev->subordinate;
>> +	list_for_each_entry(child,&subordinate->devices, bus_list) {
>> +		if ((pci_pcie_type(child) == PCI_EXP_TYPE_UPSTREAM) ||
>> +		    (pci_pcie_type(child) == PCI_EXP_TYPE_PCI_BRIDGE) ||
>> +		    ((child->class>>  16) == PCI_BASE_CLASS_DISPLAY))
>> +			/* Don't reset switch, bridge, VGA device */
>> +			return 0;
>> +	}
>> +
>> +	return 1;
>> +}
>> +
>> +static void __init save_config(struct pci_dev *dev)
>> +{
>> +	struct pci_bus *subordinate;
>> +	struct pci_dev *child;
>> +
>> +	if (!need_reset(dev))
>> +		return;
>> +
>> +	subordinate = dev->subordinate;
>> +	list_for_each_entry(child,&subordinate->devices, bus_list) {
>> +		dev_info(&child->dev, "save state\n");
>> +		pci_save_state(child);
>> +	}
>> +}
>> +
>> +static void __init restore_config(struct pci_dev *dev)
>> +{
>> +	struct pci_bus *subordinate;
>> +	struct pci_dev *child;
>> +
>> +	if (!need_reset(dev))
>> +		return;
>> +
>> +	subordinate = dev->subordinate;
>> +	list_for_each_entry(child,&subordinate->devices, bus_list) {
>> +		dev_info(&child->dev, "restore state\n");
>> +		pci_restore_state(child);
>> +	}
>> +}
>> +
>> +static void __init do_device_reset(struct pci_dev *dev)
>> +{
>> +	u16 ctrl;
>> +
>> +	if (!need_reset(dev))
>> +		return;
>> +
>> +	dev_info(&dev->dev, "Reset Secondary bus\n");
>> +
>> +	/* Assert Secondary Bus Reset */
>> +	pci_read_config_word(dev, PCI_BRIDGE_CONTROL,&ctrl);
>> +	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
>> +	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>> +
>> +	msleep(2);
>> +
>> +	/* De-assert Secondary Bus Reset */
>> +	ctrl&= ~PCI_BRIDGE_CTL_BUS_RESET;
>> +	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>> +}
>> +
>> +static int __initdata pcie_reset_devices;
>> +static int __init reset_pcie_devices(void)
>> +{
>> +	struct pci_dev *dev = NULL;
>> +
>> +	if (!pcie_reset_devices)
>> +		return 0;
>> +
>> +	for_each_pci_dev(dev)
>> +		save_config(dev);
>> +
>> +	for_each_pci_dev(dev)
>> +		do_device_reset(dev);
>
> So we do a reset on each root port or downstream port, but the PCI to
> PCI bridge spec (1.2) states:
>
>          11.1.1. Secondary Reset Signal
>                  The secondary reset signal, RST#, is a logical OR of the
>                  primary interface RST# signal and
>                  the state of the Secondary Bus Reset bit of the Bridge
>                  Control register (see Section 3.2.5.18).
>
> I read that to mean that in a legacy topology, doing a reset on the top
> level bridge triggers a reset down the entire hierarchy.  How does this
> apply to a PCIe topology?  Can we just do a reset on the top level root
> ports?  If so, that would also imply that a reset propagates down
On PCIe, a reset does not propagate down the tree (from upstream link to
downstream link of a bridge/switch).
> through PCIe-to-PCI bridges, so legacy PCI devices may be reset and the
> option name is misleading.
>
In earlier reply, I stated that the functions ought to be renamed to
reflect their intentions: endpoint reset.
It is not a reset-all-pci-devices interface, as it implies

> Even so, you still have root complex endpoints, which are not getting
> reset through this, so it's really not a complete solution.  Thanks,
>
> Alex
>
>> +
>> +	msleep(1000);
>> +
>> +	for_each_pci_dev(dev)
>> +		restore_config(dev);
>> +
>> +	return 0;
>> +}
>> +fs_initcall_sync(reset_pcie_devices);
>> +
>>   static int __init pci_setup(char *str)
>>   {
>>   	while (str) {
>> @@ -3920,6 +4021,8 @@ static int __init pci_setup(char *str)
>>   				pcie_bus_config = PCIE_BUS_PEER2PEER;
>>   			} else if (!strncmp(str, "pcie_scan_all", 13)) {
>>   				pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
>> +			} else if (!strncmp(str, "pcie_reset_devices", 18)) {
>> +				pcie_reset_devices = 1;
>>   			} else {
>>   				printk(KERN_ERR "PCI: Unknown option `%s'\n",
>>   						str);
>
>
>
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu

