Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3EUXrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:47:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57340 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3EUXr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:47:29 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <519C0771.2020507@jp.fujitsu.com>
Date: Wed, 22 May 2013 08:46:57 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: bhelgaas@google.com
CC: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        ddutile@redhat.com, ishii.hironobu@jp.fujitsu.com, bill.sumner@hp.com
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com> <87d2stw74i.fsf@xmission.com>
In-Reply-To: <87d2stw74i.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

Any comments, ack/nack?

Thanks,
Takao Indoh

(2013/05/15 7:04), Eric W. Biederman wrote:
> Takao Indoh <indou.takao@jp.fujitsu.com> writes:
> 
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
>>
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
> 
> At a quick skim this patch looks reasonable.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
>> Changelog:
>> v2:
>> - Read pci config before de-assert secondary bus reset to flush previous
>>    write
>> - Change function/variable name
>> - Make a list of devices to be reset
>>
>> v1:
>> https://patchwork.kernel.org/patch/2482291/
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
>>   				any pair of devices, possibly at the cost of
>>   				reduced performance.  This also guarantees
>>   				that hot-added devices will work.
>> +		pcie_reset_endpoint_devices	Reset PCIe endpoint on boot by
>> +				hot reset
>>   		cbiosize=nn[KMG]	The fixed amount of bus space which is
>>   				reserved for the CardBus bridge's IO window.
>>   				The default value is 256 bytes.
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
>> +	struct pci_bus *subordinate;
>> +	struct pci_dev *child;
>> +
>> +	if (!pci_is_pcie(dev) || !dev->subordinate ||
>> +	    list_empty(&dev->subordinate->devices) ||
>> +	    ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT) &&
>> +	     (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
>> +		return 0;
>> +
>> +	subordinate = dev->subordinate;
>> +	list_for_each_entry(child, &subordinate->devices, bus_list) {
>> +		if ((pci_pcie_type(child) == PCI_EXP_TYPE_UPSTREAM) ||
>> +		    (pci_pcie_type(child) == PCI_EXP_TYPE_PCI_BRIDGE) ||
>> +		    ((child->class >> 16) == PCI_BASE_CLASS_DISPLAY))
>> +			/* Don't reset switch, bridge, VGA device */
>> +			return 0;
>> +	}
>> +
>> +	return 1;
>> +}
>> +
>> +static void __init save_downstream_configs(struct pci_dev *dev)
>> +{
>> +	struct pci_bus *subordinate;
>> +	struct pci_dev *child;
>> +
>> +	subordinate = dev->subordinate;
>> +	list_for_each_entry(child, &subordinate->devices, bus_list) {
>> +		dev_info(&child->dev, "save state\n");
>> +		pci_save_state(child);
>> +	}
>> +}
>> +
>> +static void __init restore_downstream_configs(struct pci_dev *dev)
>> +{
>> +	struct pci_bus *subordinate;
>> +	struct pci_dev *child;
>> +
>> +	subordinate = dev->subordinate;
>> +	list_for_each_entry(child, &subordinate->devices, bus_list) {
>> +		dev_info(&child->dev, "restore state\n");
>> +		pci_restore_state(child);
>> +	}
>> +}
>> +
>> +static void __init do_downstream_device_reset(struct pci_dev *dev)
>> +{
>> +	u16 ctrl;
>> +
>> +	dev_info(&dev->dev, "Reset Secondary bus\n");
>> +
>> +	/* Assert Secondary Bus Reset */
>> +	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &ctrl);
>> +	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
>> +	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>> +
>> +	/* Read config again to flush previous write */
>> +	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &ctrl);
>> +
>> +	msleep(2);
>> +
>> +	/* De-assert Secondary Bus Reset */
>> +	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
>> +	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>> +}
>> +
>> +struct pci_dev_entry {
>> +	struct list_head list;
>> +	struct pci_dev *dev;
>> +};
>> +static int __initdata pcie_reset_endpoint_devices;
>> +static int __init reset_pcie_endpoints(void)
>> +{
>> +	struct pci_dev *dev = NULL;
>> +	struct pci_dev_entry *pdev_entry, *tmp;
>> +	LIST_HEAD(pdev_list);
>> +
>> +	if (!pcie_reset_endpoint_devices)
>> +		return 0;
>> +
>> +	for_each_pci_dev(dev)
>> +		if (need_reset(dev)) {
>> +			pdev_entry = kmalloc(sizeof(*pdev_entry), GFP_KERNEL);
>> +			pdev_entry->dev = dev;
>> +			list_add(&pdev_entry->list, &pdev_list);
>> +		}
>> +
>> +	list_for_each_entry(pdev_entry, &pdev_list, list)
>> +		save_downstream_configs(pdev_entry->dev);
>> +
>> +	list_for_each_entry(pdev_entry, &pdev_list, list)
>> +		do_downstream_device_reset(pdev_entry->dev);
>> +
>> +	msleep(1000);
>> +
>> +	list_for_each_entry_safe(pdev_entry, tmp, &pdev_list, list) {
>> +		restore_downstream_configs(pdev_entry->dev);
>> +		kfree(pdev_entry);
>> +	}
>> +
>> +	return 0;
>> +}
>> +fs_initcall_sync(reset_pcie_endpoints);
>> +
>>   static int __init pci_setup(char *str)
>>   {
>>   	while (str) {
>> @@ -3915,6 +4025,9 @@ static int __init pci_setup(char *str)
>>   				pcie_bus_config = PCIE_BUS_PEER2PEER;
>>   			} else if (!strncmp(str, "pcie_scan_all", 13)) {
>>   				pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
>> +			} else if (!strncmp(str, "pcie_reset_endpoint_devices",
>> +						27)) {
>> +				pcie_reset_endpoint_devices = 1;
>>   			} else {
>>   				printk(KERN_ERR "PCI: Unknown option `%s'\n",
>>   						str);
> 
> 


