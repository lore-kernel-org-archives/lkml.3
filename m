Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3ETGhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:37:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59175 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab3ETGht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:37:49 -0400
X-IronPort-AV: E=Sophos;i="4.87,706,1363104000"; 
   d="scan'208";a="7310635"
Message-ID: <5199C433.5030902@cn.fujitsu.com>
Date: Mon, 20 May 2013 14:35:31 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2, part 1 8/9] PCI: make PCI host bridge/bus creating
 and destroying logic symmetric
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com> <1368461313-4371-9-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1368461313-4371-9-git-send-email-jiang.liu@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/20 14:36:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/20 14:36:32,
	Serialize complete at 2013/05/20 14:36:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/14/2013 12:08 AM, Jiang Liu wrote:

> This patch makes PCI host bridge/bus creating and destroying logic
> symmetric by using device_initialize()/device_add()/device_del()/put_device()
> pairs as discussed in thread at:
> http://comments.gmane.org/gmane.linux.kernel.pci/22073
> 
> It also fixes a bug in error recovery path in pci_create_root_bus()
> which may kfree() an in-use host bridge object.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c  | 84 +++++++++++++++++++++++-----------------------------
>  drivers/pci/remove.c |  3 +-
>  2 files changed, 39 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index bc075a3..a2617c2 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -451,7 +451,7 @@ void pci_read_bridge_bases(struct pci_bus *child)
>  	}
>  }
>  
> -static struct pci_bus * pci_alloc_bus(void)
> +static struct pci_bus *pci_alloc_bus(struct pci_ops *ops, void *sd, int bus)
>  {
>  	struct pci_bus *b;
>  
> @@ -464,10 +464,32 @@ static struct pci_bus * pci_alloc_bus(void)
>  		INIT_LIST_HEAD(&b->resources);
>  		b->max_bus_speed = PCI_SPEED_UNKNOWN;
>  		b->cur_bus_speed = PCI_SPEED_UNKNOWN;
> +		b->sysdata = sd;
> +		b->ops = ops;
> +		b->number = bus;
> +		b->busn_res.start = bus;
> +		b->busn_res.end = 0xff;
> +		b->busn_res.flags = IORESOURCE_BUS;
> +		b->dev.class = &pcibus_class;
> +		dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
> +		device_initialize(&b->dev);
>  	}
> +
>  	return b;
>  }
>  
> +static void pci_release_host_bridge_dev(struct device *dev)
> +{
> +	struct pci_host_bridge *bridge = to_pci_host_bridge(dev);
> +
> +	if (bridge->release_fn)
> +		bridge->release_fn(bridge);
> +
> +	pci_free_resource_list(&bridge->windows);
> +
> +	kfree(bridge);
> +}
> +
>  static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
>  {
>  	struct pci_host_bridge *bridge;
> @@ -476,6 +498,10 @@ static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
>  	if (bridge) {
>  		INIT_LIST_HEAD(&bridge->windows);
>  		bridge->bus = b;
> +		bridge->dev.release = pci_release_host_bridge_dev;
> +		dev_set_name(&bridge->dev, "pci%04x:%02x",
> +			     pci_domain_nr(b), b->number);
> +		device_initialize(&bridge->dev);
>  	}
>  
>  	return bridge;
> @@ -628,28 +654,13 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  	/*
>  	 * Allocate a new bus, and inherit stuff from the parent..
>  	 */
> -	child = pci_alloc_bus();
> +	child = pci_alloc_bus(parent->ops, parent->sysdata, busnr);
>  	if (!child)
>  		return NULL;
>  
>  	child->parent = parent;
> -	child->ops = parent->ops;
> -	child->sysdata = parent->sysdata;
>  	child->bus_flags = parent->bus_flags;
> -
> -	/* initialize some portions of the bus device, but don't register it
> -	 * now as the parent is not properly set up yet.
> -	 */
> -	child->dev.class = &pcibus_class;
> -	dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
> -
> -	/*
> -	 * Set up the primary, secondary and subordinate
> -	 * bus numbers.
> -	 */
> -	child->number = child->busn_res.start = busnr;
>  	child->primary = parent->busn_res.start;
> -	child->busn_res.end = 0xff;
>  
>  	if (!bridge) {
>  		child->dev.parent = parent->bridge;
> @@ -670,7 +681,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  	bridge->subordinate = child;
>  
>  add_dev:
> -	ret = device_register(&child->dev);
> +	ret = device_add(&child->dev);
>  	WARN_ON(ret < 0);
>  
>  	pcibios_add_bus(child);
> @@ -1190,18 +1201,6 @@ int pci_cfg_space_size(struct pci_dev *dev)
>  	return PCI_CFG_SPACE_SIZE;
>  }
>  
> -static void pci_release_bus_bridge_dev(struct device *dev)
> -{
> -	struct pci_host_bridge *bridge = to_pci_host_bridge(dev);
> -
> -	if (bridge->release_fn)
> -		bridge->release_fn(bridge);
> -
> -	pci_free_resource_list(&bridge->windows);
> -
> -	kfree(bridge);
> -}
> -
>  struct pci_dev *pci_alloc_dev(struct pci_bus *bus)
>  {
>  	struct pci_dev *dev;
> @@ -1688,13 +1687,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	char bus_addr[64];
>  	char *fmt;
>  
> -	b = pci_alloc_bus();
> +	b = pci_alloc_bus(ops, sysdata, bus);
>  	if (!b)
>  		return NULL;
>  
> -	b->sysdata = sysdata;
> -	b->ops = ops;
> -	b->number = b->busn_res.start = bus;
>  	b2 = pci_find_bus(pci_domain_nr(b), bus);
>  	if (b2) {
>  		/* If we already got to this bus through a different bridge, ignore it */
> @@ -1706,27 +1702,22 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	if (!bridge)
>  		goto err_out;
>  
> -	bridge->dev.parent = parent;
> -	bridge->dev.release = pci_release_bus_bridge_dev;
> -	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
>  	error = pcibios_root_bridge_prepare(bridge);
>  	if (error)
>  		goto bridge_dev_reg_err;
>  
> -	error = device_register(&bridge->dev);
> +	bridge->dev.parent = parent;
> +	error = device_add(&bridge->dev);
>  	if (error)
>  		goto bridge_dev_reg_err;
> +
>  	b->bridge = get_device(&bridge->dev);
>  	device_enable_async_suspend(b->bridge);
>  	pci_set_bus_of_node(b);
> -
>  	if (!parent)
>  		set_dev_node(b->bridge, pcibus_to_node(b));
> -
> -	b->dev.class = &pcibus_class;
>  	b->dev.parent = b->bridge;
> -	dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
> -	error = device_register(&b->dev);
> +	error = device_add(&b->dev);
>  	if (error)
>  		goto class_dev_reg_err;
>  
> @@ -1769,12 +1760,11 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	return b;
>  
>  class_dev_reg_err:
> -	put_device(&bridge->dev);
> -	device_unregister(&bridge->dev);
> +	device_del(&bridge->dev);
>  bridge_dev_reg_err:
> -	kfree(bridge);
> +	put_device(&bridge->dev);
>  err_out:
> -	kfree(b);
> +	put_device(&b->dev);
>  	return NULL;
>  }

Hi Jiang,
	I think the changes here may lead to memleak, doesn't it?

Best regards,
Gu

>  
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 8fc54b7..b0ce875 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -52,7 +52,8 @@ void pci_remove_bus(struct pci_bus *bus)
>  	up_write(&pci_bus_sem);
>  	pci_remove_legacy_files(bus);
>  	pcibios_remove_bus(bus);
> -	device_unregister(&bus->dev);
> +	device_del(&bus->dev);
> +	put_device(&bus->dev);
>  }
>  EXPORT_SYMBOL(pci_remove_bus);
>  


