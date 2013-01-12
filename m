Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3ALW3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 17:29:08 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39118 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab3ALW3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 17:29:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 06/22] PCI: split registration of PCI bus devices into two stages
Date: Sat, 12 Jan 2013 23:34:54 +0100
Message-ID: <3931059.ZcnvRQRmKT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-7-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-7-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:33 PM Yinghai Lu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> When handling BUS_NOTIFY_ADD_DEVICE event for a PCI bridge device,
> the notification handler can't hold reference count to the new PCI bus
> because the device object for the new bus (pci_dev->subordinate->dev)
> hasn't been initialized yet.

It doesn't look like BUS_NOTIFY_ADD_DEVICE is used by the PCI bus type
in the mainline.

Is it in linux-next?

If not, then I don't see why we need this patch.

Thanks,
Rafael


> Split the registration of PCI bus device into two stages as below,
> so that the event handler could hold reference count to the new PCI bus
> when handling BUS_NOTIFY_ADD_DEVICE event.
> 
> 1) device_initialize(&pci_dev->dev)
> 2) device_initialize(&pci_dev->subordinate->dev)
> 3) notify BUS_NOTIFY_ADD_DEVICE event for pci_dev
> 4) device_add(&pci_dev->dev)
> 5) device_add(&pci_dev->subordinate->dev)
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/bus.c    |    2 +-
>  drivers/pci/probe.c  |    4 +++-
>  drivers/pci/remove.c |   10 +++++-----
>  3 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 847f3ca..5f9c728 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -200,7 +200,7 @@ int pci_bus_add_child(struct pci_bus *bus)
>  	if (bus->bridge)
>  		bus->dev.parent = bus->bridge;
>  
> -	retval = device_register(&bus->dev);
> +	retval = device_add(&bus->dev);
>  	if (retval)
>  		return retval;
>  
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 48b35e1..dc4fde3 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -642,6 +642,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  	 */
>  	child->dev.class = &pcibus_class;
>  	dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
> +	device_initialize(&child->dev);
>  
>  	/*
>  	 * Set up the primary, secondary and subordinate
> @@ -1678,7 +1679,8 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	b->dev.class = &pcibus_class;
>  	b->dev.parent = b->bridge;
>  	dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
> -	error = device_register(&b->dev);
> +	device_initialize(&b->dev);
> +	error = device_add(&b->dev);
>  	if (error)
>  		goto class_dev_reg_err;
>  
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index fc38c48..a1fdd0f 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -48,11 +48,11 @@ void pci_remove_bus(struct pci_bus *bus)
>  	list_del(&bus->node);
>  	pci_bus_release_busn_res(bus);
>  	up_write(&pci_bus_sem);
> -	if (!bus->is_added)
> -		return;
> -
> -	pci_remove_legacy_files(bus);
> -	device_unregister(&bus->dev);
> +	if (bus->is_added) {
> +		pci_remove_legacy_files(bus);
> +		device_del(&bus->dev);
> +	}
> +	put_device(&bus->dev);
>  }
>  EXPORT_SYMBOL(pci_remove_bus);
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
