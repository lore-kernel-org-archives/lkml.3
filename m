Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3ALVaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:30:09 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39065 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab3ALVaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:30:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 01/22] PCI, acpiphp: Add is_hotplug_bridge detection
Date: Sat, 12 Jan 2013 22:35:55 +0100
Message-ID: <15994211.6fY1r0IKoV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-2-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:28 PM Yinghai Lu wrote:
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

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
