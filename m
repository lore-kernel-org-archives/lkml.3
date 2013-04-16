Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab3DPBuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 21:50:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:22793 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935300Ab3DPBuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 21:50:12 -0400
Message-ID: <516CAE35.7090204@huawei.com>
Date: Tue, 16 Apr 2013 09:49:41 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
CC: Yijing Wang <wangyijing@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>
Subject: Re: [PATCH 1/3] PCI,acpiphp: use generic pci_hp_add_bridge()
References: <1364808128-12792-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1364808128-12792-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,
   Any comments about this patch? I searched the code history and found
you introduced pci_hp_add_bridge() function at commit a8e4b9c10. In your
patchset use pci_hp_add_bridge() for all pci hotplug drivers except acpiphp.
So I use pci_hp_add_bridge() in acpiphp instead of using pci_scan_bridge()
directly. I would appreciate if you can give some suggestions.

Thanks!
Yijing.

On 2013/4/1 17:22, Yijing Wang wrote:
> Use pci_hp_add_bridge() like most other hotplug drivers
> rather than call pci_scan_bridge() directly.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |   24 ++++++++++--------------
>  1 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 270fdba..7d7ed3f 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -811,7 +811,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>  	struct pci_bus *bus = slot->bridge->pci_bus;
>  	struct acpiphp_func *func;
>  	int retval = 0;
> -	int num, max, pass;
> +	int num;
>  	acpi_status status;
>  
>  	if (slot->flags & SLOT_ENABLED)
> @@ -827,22 +827,18 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>  		goto err_exit;
>  	}
>  
> -	max = acpiphp_max_busnr(bus);
> -	for (pass = 0; pass < 2; pass++) {
> -		list_for_each_entry(dev, &bus->devices, bus_list) {
> -			if (PCI_SLOT(dev->devfn) != slot->device)
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		if (PCI_SLOT(dev->devfn) != slot->device)
>  				continue;
> -			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
> -			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
> -				max = pci_scan_bridge(bus, dev, max, pass);
> -				if (pass && dev->subordinate) {
> -					check_hotplug_bridge(slot, dev);
> -					pci_bus_size_bridges(dev->subordinate);
> -				}
> -			}
> +		if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
> +				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS))
> +			pci_hp_add_bridge(dev);
> +		if (dev->subordinate) {
> +			check_hotplug_bridge(slot, dev);
> +			pci_bus_size_bridges(dev->subordinate);
>  		}
>  	}
> -
> +
>  	pci_bus_assign_resources(bus);
>  	acpiphp_sanitize_bus(bus);
>  	acpiphp_set_hpp_values(bus);
> 


-- 
Thanks!
Yijing

