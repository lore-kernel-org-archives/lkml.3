Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3AOGq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:46:58 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64772 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab3AOGqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:46:55 -0500
Message-ID: <50F4FB24.80200@huawei.com>
Date: Tue, 15 Jan 2013 14:45:56 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v8 01/22] PCI, acpiphp: Add is_hotplug_bridge detection
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-2-git-send-email-yinghai@kernel.org>
In-Reply-To: <1357944049-29620-2-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/12 6:40, Yinghai Lu wrote:
> When system support hotplug bridge with children hotplug slots, we need
> to make sure that parent bridge get preallocated resource so later when
> device is plugged into children slot, those children devices will get
> resource allocated.
> 
> We do not meet this problem, because for pcie hotplug card, when acpiphp
> is used, pci_scan_bridge will set that for us when detect hotplug bit in
> slot cap.
> 
> Reported-and-tested-by: Jason Baron <jbaron@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Jason Baron <jbaron@redhat.com>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |   27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 91b5ad8..1e5c5df 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -797,6 +797,29 @@ static void acpiphp_set_acpi_region(struct acpiphp_slot *slot)
>  	}
>  }
>  
> +static void check_hotplug_bridge(struct acpiphp_slot *slot, struct pci_dev *dev)
> +{
> +	struct acpiphp_func *func;
> +
> +	if (!dev->subordinate)
> +		return;
> +
> +	/* quirk, or pcie could set it already */
> +	if (dev->is_hotplug_bridge)
> +		return;
> +
> +	if (PCI_SLOT(dev->devfn) != slot->device)
> +		return;
> +
> +	list_for_each_entry(func, &slot->funcs, sibling) {
> +		if (PCI_FUNC(dev->devfn) == func->function) {
> +			/* check if this bridge has ejectable slots */
> +			if ((detect_ejectable_slots(func->handle) > 0))
> +				dev->is_hotplug_bridge = 1;
> +			break;

Hi Yinghai,
   Need to put the "break" in parentheses of "if"? If the first func which device number == dev->devfn has't ejectable slot,
don't check the rest funcs whether have ejectable slots?

> +		}
> +	}
> +}
>  /**
>   * enable_device - enable, configure a slot
>   * @slot: slot to be enabled
> @@ -831,8 +854,10 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>  			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
>  			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
>  				max = pci_scan_bridge(bus, dev, max, pass);
> -				if (pass && dev->subordinate)
> +				if (pass && dev->subordinate) {
> +					check_hotplug_bridge(slot, dev);
>  					pci_bus_size_bridges(dev->subordinate);
> +				}
>  			}
>  		}
>  	}
> 


-- 
Thanks!
Yijing

