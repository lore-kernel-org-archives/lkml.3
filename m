Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab3FMSxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:53:45 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36404 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab3FMSxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:53:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
Date: Thu, 13 Jun 2013 21:02:55 +0200
Message-ID: <9686208.vxkaqkMmr5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 13, 2013 11:42:16 AM Yinghai Lu wrote:
> On Thu, Jun 13, 2013 at 9:32 AM, Jiang Liu <jiang.liu@huawei.com> wrote:
> > Alexander E. Patrakov <patrakov@gmail.com> reports two bugs related to
> > dock station support on Sony VAIO VPCZ23A4R. Actually there are at least
> > four bugs related to Sony VAIO VPCZ23A4R dock support.
> > 1) can't correctly detect hotplug slot for dock state
> > 2) resource leak on undocking
> > 3) resource allocation failure for dock devices
> > 4) one bug in intel_snd_hda driver
> >
> > The first patch fixes issue 1, and the second patch fixes issue 2.
> > These two patches, if accepted, should be material for stable branches
> > too.
> > Patch 3-9 are code improvement for ACPI and dock driver.
> >
> > I have found the root cause for issue three, but still working on
> > solutions, and seems can't be solve in short time. So please help
> > to review and test patches for issue 1) and 2) first.
> 
> the 3) is about pci resource allocation?
> because pcibios_add_bus is called too early?
> 
> If that is case, we should have something like attached patch for it.

I'm including the patch below to make it easier to comment.

> With that, we will not need to worry about _OSC set for 3.10 etc.

> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index b1ff02a..68ed5d8 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -186,6 +186,14 @@ int pci_bus_add_device(struct pci_dev *dev)
>  	return 0;
>  }
>  
> +void __weak pcibios_add_bus(struct pci_bus *bus)
> +{
> +}
> +
> +void __weak pcibios_remove_bus(struct pci_bus *bus)
> +{
> +}
> +
>  /**
>   * pci_bus_add_devices - start driver for PCI devices
>   * @bus: bus to check for new devices
> @@ -198,6 +206,11 @@ void pci_bus_add_devices(const struct pci_bus *bus)
>  	struct pci_bus *child;
>  	int retval;
>  
> +	if (bus->is_added == 1) {
> +		pcibios_add_bus(bus);
> +		bus->is_added++;
> +	}

Do we need that in all of the places pci_bus_add_devices() is called?

It looks like pci_scan_child_bus() might be a better place for adding this,
or am I overlooking something?

[Hint: the bus->is_added++ hack is <explicit content> ugly.]

> +
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
>  		/* Skip already-added devices */
>  		if (dev->is_added)
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 3dfc907..51404e6 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -704,8 +704,6 @@ add_dev:
>  	ret = device_add(&child->dev);
>  	WARN_ON(ret < 0);
>  
> -	pcibios_add_bus(child);
> -
>  	/* Create legacy_io and legacy_mem files for this bus */
>  	pci_create_legacy_files(child);
>  
> @@ -1688,14 +1686,6 @@ int __weak pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
>  	return 0;
>  }
>  
> -void __weak pcibios_add_bus(struct pci_bus *bus)
> -{
> -}
> -
> -void __weak pcibios_remove_bus(struct pci_bus *bus)
> -{
> -}
> -
>  struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  		struct pci_ops *ops, void *sysdata, struct list_head *resources)
>  {
> @@ -1742,8 +1732,6 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	if (error)
>  		goto class_dev_reg_err;
>  
> -	pcibios_add_bus(b);
> -
>  	/* Create legacy_io and legacy_mem files for this bus */
>  	pci_create_legacy_files(b);
>  

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
