Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3ALXs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 18:48:29 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39229 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab3ALXs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 18:48:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 22/22] PCI: move device_add out of pci_bus_add_device()
Date: Sun, 13 Jan 2013 00:54:16 +0100
Message-ID: <1620774.KjdX6JUoJy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-23-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-23-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:49 PM Yinghai Lu wrote:
> Move out device registering out of pci_bus_add_devices, so we could
> put new created pci devices in device tree early.
> 
> new pci_bus_add_devices will do the device_attach work to load pci drivers
> instead.

I wonder what problem it solves?

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/bus.c   |   47 +++--------------------------------------------
>  drivers/pci/iov.c   |    7 -------
>  drivers/pci/probe.c |   34 +++++++++++++++++++++++++++-------
>  3 files changed, 30 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 1f5916a..0a55845 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -178,22 +178,9 @@ static void pci_bus_attach_device(struct pci_dev *dev)
>   */
>  int pci_bus_add_device(struct pci_dev *dev)
>  {
> -	int retval;
> -
> -	pci_fixup_device(pci_fixup_final, dev);
> -
> -	retval = pcibios_add_device(dev);
> -	if (retval)
> -		return retval;
> -
> -	retval = device_add(&dev->dev);
> -	if (retval)
> -		return retval;
> -
>  	pci_bus_attach_device(dev);
>  	dev->is_added = 1;
> -	pci_proc_attach_device(dev);
> -	pci_create_sysfs_dev_files(dev);
> +
>  	return 0;
>  }
>  
> @@ -205,21 +192,9 @@ int pci_bus_add_device(struct pci_dev *dev)
>   */
>  int pci_bus_add_child(struct pci_bus *bus)
>  {
> -	int retval;
> -
> -	if (bus->bridge)
> -		bus->dev.parent = bus->bridge;
> -
> -	retval = device_add(&bus->dev);
> -	if (retval)
> -		return retval;
> -
>  	bus->is_added = 1;
>  
> -	/* Create legacy_io and legacy_mem files for this bus */
> -	pci_create_legacy_files(bus);
> -
> -	return retval;
> +	return 0;
>  }
>  
>  /**
> @@ -245,36 +220,20 @@ void pci_bus_add_devices(const struct pci_bus *bus)
>  		if (dev->is_added)
>  			continue;
>  		retval = pci_bus_add_device(dev);
> -		if (retval)
> -			dev_err(&dev->dev, "Error adding device, continuing\n");
>  	}
>  
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
>  		BUG_ON(!dev->is_added);
>  
>  		child = dev->subordinate;
> -		/*
> -		 * If there is an unattached subordinate bus, attach
> -		 * it and then scan for unattached PCI devices.
> -		 */
> +
>  		if (!child)
>  			continue;
> -		if (list_empty(&child->node)) {
> -			down_write(&pci_bus_sem);
> -			list_add_tail(&child->node, &dev->bus->children);
> -			up_write(&pci_bus_sem);
> -		}
>  		pci_bus_add_devices(child);
>  
> -		/*
> -		 * register the bus with sysfs as the parent is now
> -		 * properly registered.
> -		 */
>  		if (child->is_added)
>  			continue;
>  		retval = pci_bus_add_child(child);
> -		if (retval)
> -			dev_err(&dev->dev, "Error adding bus, continuing\n");
>  	}
>  }
>  
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index bafd2bb..dbad72e 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -48,12 +48,7 @@ static struct pci_bus *virtfn_add_bus(struct pci_bus *bus, int busnr)
>  		return NULL;
>  
>  	pci_bus_insert_busn_res(child, busnr, busnr);
> -	child->dev.parent = bus->bridge;
>  	rc = pci_bus_add_child(child);
> -	if (rc) {
> -		pci_remove_bus(child);
> -		return NULL;
> -	}
>  
>  	return child;
>  }
> @@ -123,8 +118,6 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
>  	virtfn->is_virtfn = 1;
>  
>  	rc = pci_bus_add_device(virtfn);
> -	if (rc)
> -		goto failed1;
>  	sprintf(buf, "virtfn%u", id);
>  	rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
>  	if (rc)
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index dc4fde3..84c92a0 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -623,6 +623,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  {
>  	struct pci_bus *child;
>  	int i;
> +	int ret;
>  
>  	/*
>  	 * Allocate a new bus, and inherit stuff from the parent..
> @@ -637,8 +638,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  	child->bus_flags = parent->bus_flags;
>  
>  	/* initialize some portions of the bus device, but don't register it
> -	 * now as the parent is not properly set up yet.  This device will get
> -	 * registered later in pci_bus_add_devices()
> +	 * now as the parent is not properly set up yet.
>  	 */
>  	child->dev.class = &pcibus_class;
>  	dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
> @@ -652,11 +652,14 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  	child->primary = parent->busn_res.start;
>  	child->busn_res.end = 0xff;
>  
> -	if (!bridge)
> -		return child;
> +	if (!bridge) {
> +		child->dev.parent = parent->bridge;
> +		goto add_dev;
> +	}
>  
>  	child->self = bridge;
>  	child->bridge = get_device(&bridge->dev);
> +	child->dev.parent = child->bridge;
>  	pci_set_bus_of_node(child);
>  	pci_set_bus_speed(child);
>  
> @@ -667,6 +670,13 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  	}
>  	bridge->subordinate = child;
>  
> +add_dev:
> +	ret = device_add(&child->dev);
> +	WARN_ON(ret < 0);
> +
> +	/* Create legacy_io and legacy_mem files for this bus */
> +	pci_create_legacy_files(child);
> +
>  	return child;
>  }
>  
> @@ -1297,6 +1307,8 @@ static void pci_init_capabilities(struct pci_dev *dev)
>  
>  void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>  {
> +	int ret;
> +
>  	device_initialize(&dev->dev);
>  	dev->dev.release = pci_release_dev;
>  
> @@ -1327,6 +1339,16 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>  	down_write(&pci_bus_sem);
>  	list_add_tail(&dev->bus_list, &bus->devices);
>  	up_write(&pci_bus_sem);
> +
> +	pci_fixup_device(pci_fixup_final, dev);
> +        ret = pcibios_add_device(dev);

Broken whitespace?

> +	WARN_ON(ret < 0);
> +	/* notifier could use pci capabilities */
> +	ret = device_add(&dev->dev);
> +	WARN_ON(ret < 0);

These WARN_ON() things make me kind of nervous.

> +
> +	pci_proc_attach_device(dev);
> +	pci_create_sysfs_dev_files(dev);
>  }
>  
>  struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
> @@ -1645,13 +1667,13 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	char bus_addr[64];
>  	char *fmt;
>  
> -
>  	b = pci_alloc_bus();
>  	if (!b)
>  		return NULL;
>  
>  	b->sysdata = sysdata;
>  	b->ops = ops;
> +	b->number = b->busn_res.start = bus;
>  	b2 = pci_find_bus(pci_domain_nr(b), bus);
>  	if (b2) {
>  		/* If we already got to this bus through a different bridge, ignore it */
> @@ -1687,8 +1709,6 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	/* Create legacy_io and legacy_mem files for this bus */
>  	pci_create_legacy_files(b);
>  
> -	b->number = b->busn_res.start = bus;
> -
>  	if (parent)
>  		dev_info(parent, "PCI host bridge to bus %s\n", dev_name(&b->dev));
>  	else
> 

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
