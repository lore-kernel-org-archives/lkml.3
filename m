Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3ATX3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:29:38 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47833 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab3ATX3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:29:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 1/8] PCI: make PCI device create/destroy logic symmetric
Date: Mon, 21 Jan 2013 00:35:35 +0100
Message-ID: <4306778.V6LZtQIM99@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358525267-14268-2-git-send-email-jiang.liu@huawei.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <1358525267-14268-2-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 19, 2013 12:07:39 AM Jiang Liu wrote:
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

This seems to be the same as https://patchwork.kernel.org/patch/2000051/

Can you please avoid sending duplicates?

Rafael


> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c  |    1 -
>  drivers/pci/remove.c |    4 ++--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 4f7f963..ec5d28f 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1294,7 +1294,6 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>  {
>  	device_initialize(&dev->dev);
>  	dev->dev.release = pci_release_dev;
> -	pci_dev_get(dev);
>  
>  	dev->dev.dma_mask = &dev->dma_mask;
>  	dev->dev.dma_parms = &dev->dma_parms;
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 513972f..10693f5 100644
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
