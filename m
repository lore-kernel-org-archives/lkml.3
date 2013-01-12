Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3ALVe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:34:28 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39084 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab3ALVe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:34:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 05/22] PCI: make PCI device create/destroy logic symmetric
Date: Sat, 12 Jan 2013 22:40:14 +0100
Message-ID: <1689874.eC9grEviHZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-6-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:32 PM Yinghai Lu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> According to device model documentation, the way to create/destroy PCI
> devices should be symmetric.
> 
> /**
>  * device_del - delete device from system.
>  * @dev: device.
>  *
>  * This is the first part of the device unregistration
>  * sequence. This removes the device from the lists we control
>  * from here, has it removed from the other driver model
>  * subsystems it was added to in device_add(), and removes it
>  * from the kobject hierarchy.
>  *
>  * NOTE: this should be called manually _iff_ device_add() was
>  * also called manually.
>  */
> 
> The rule is to either use
> 1) device_register()/device_unregister()
> or
> 2) device_initialize()/device_add()/device_del()/put_device().
> 
> So change PCI core logic to follow the rule and get rid of the redundant
> pci_dev_get()/pci_dev_put() pair.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-by: Yinghai Lu <yinghai@kernel.org>

Signed-off-by I suppose?

Apart from this:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/pci/probe.c  |    1 -
>  drivers/pci/remove.c |    4 ++--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index b97dea5..48b35e1 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1298,7 +1298,6 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>  {
>  	device_initialize(&dev->dev);
>  	dev->dev.release = pci_release_dev;
> -	pci_dev_get(dev);
>  
>  	set_dev_node(&dev->dev, pcibus_to_node(bus));
>  	dev->dev.dma_mask = &dev->dma_mask;
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 7c0fd92..fc38c48 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -22,7 +22,7 @@ static void pci_stop_dev(struct pci_dev *dev)
>  	if (dev->is_added) {
>  		pci_proc_detach_device(dev);
>  		pci_remove_sysfs_dev_files(dev);
> -		device_unregister(&dev->dev);
> +		device_del(&dev->dev);
>  		dev->is_added = 0;
>  	}
>  
> @@ -37,7 +37,7 @@ static void pci_destroy_dev(struct pci_dev *dev)
>  	up_write(&pci_bus_sem);
>  
>  	pci_free_resources(dev);
> -	pci_dev_put(dev);
> +	put_device(&dev->dev);
>  }
>  
>  void pci_remove_bus(struct pci_bus *bus)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
