Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3EHXni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:43:38 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44606 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3EHXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:43:36 -0400
Date: Wed, 8 May 2013 17:43:32 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] PCI: Fix racing for pci device removing via sysfs
Message-ID: <20130508234332.GA7037@google.com>
References: <1366940841-15370-1-git-send-email-yinghai@kernel.org>
 <CAErSpo5zfHR-agNBdgqfVjCU+-KcTZV+1bvML5Uw-+icDqzzEA@mail.gmail.com>
 <CAE9FiQVEQO-dLJRjn9Z7JgwGWAn1M8S1Tn2_V0Fq+6kB0rG=Bg@mail.gmail.com>
 <CAErSpo7DUDQ_XgVKAfWxqYJA=q85ps46bffV-4a7b0vOzAP5DA@mail.gmail.com>
 <CAE9FiQWv-bN2XzHiQ0WU+Y678zcqs_Owua6vXXijdMO6=0OWpg@mail.gmail.com>
 <517E45C8.4060407@cn.fujitsu.com>
 <CAE9FiQUXxCH0xjFPk1S7e_JRsBPosqQ=N5Kpcrjp3RNWDh9yZQ@mail.gmail.com>
 <20130429181550.GA17343@google.com>
 <CAE9FiQURZTOEWn64AE4y6agoJhRLSW8983ZJ9RBs8Td9d9tpGA@mail.gmail.com>
 <CAE9FiQX-HKOm5qDsJycG_Yo5JPngk6dxSFehg9n6mmj2sbcmWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQX-HKOm5qDsJycG_Yo5JPngk6dxSFehg9n6mmj2sbcmWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 02:29:35PM -0700, Yinghai Lu wrote:
> On Mon, Apr 29, 2013 at 3:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Mon, Apr 29, 2013 at 11:15 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >>
> >> I think the 1a:01.0 pci_dev should retain its reference to the pci_bus
> >> for as long as the pci_dev exists, so the pci_bus_put() should go in
> >> pci_release_dev() instead.
> >
> > Good point.
> >
> > will rework pci remove sequence.
> 
> Please check attached version that will not need to touch pci sysfs bits.

I use patchwork to keep track of things I need to look at, and I don't
think patchwork looks at attachments.  Just FYI in case I seem to be
ignoring things; it might be that they just didn't appear on my patchwork
"to-do" list.

I completely agree that gmail makes it impossible to send patches in-line.
On the other hand, sending them as attachments is easy for you but makes it
difficult for others to review and reply to them.  I'm using mutt to
comment on your patch, but eventually I'll get tired of doing the extra
work on my end :)

I tried to apply this on top of 96a3e8af5a (Linus' merge of the v3.10 PCI
changes), but it didn't apply cleanly.  I assume you'll rebase it to
v3.10-rc1 when it comes out.

> Subject: [PATCH -v5] PCI: Fix racing for pci device removing via sysfs
> From: Yinghai Lu <yinghai@kernel.org>
> ... 
> Index: linux-2.6/drivers/pci/probe.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/probe.c
> +++ linux-2.6/drivers/pci/probe.c
> @@ -1119,6 +1119,20 @@ static void pci_release_capabilities(str
>  	pci_free_cap_save_buffers(dev);
>  }
>  
> +static void pci_free_resources(struct pci_dev *dev)
> +{
> +	int i;
> +
> +	msi_remove_pci_irq_vectors(dev);
> +
> +	pci_cleanup_rom(dev);
> +	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> +		struct resource *res = dev->resource + i;
> +		if (res->parent)
> +			release_resource(res);
> +	}
> +}
> +
>  /**
>   * pci_release_dev - free a pci device structure when all users of it are finished.
>   * @dev: device that's been disconnected
> @@ -1131,6 +1145,13 @@ static void pci_release_dev(struct devic
>  	struct pci_dev *pci_dev;
>  
>  	pci_dev = to_pci_dev(dev);
> +
> +	down_write(&pci_bus_sem);
> +	list_del(&pci_dev->bus_list);
> +	up_write(&pci_bus_sem);
> +	pci_free_resources(pci_dev);
> +	put_device(&pci_dev->bus->dev);

Is there any reason to drop the pci_bus reference here, as opposed to
doing it after the "kfree(pci_dev)"?  We call a couple more things below,
and it's possible that they will still reference pci_dev->bus.

> +
>  	pci_release_capabilities(pci_dev);
>  	pci_release_of_node(pci_dev);
>  	kfree(pci_dev);
> @@ -1340,6 +1361,7 @@ void pci_device_add(struct pci_dev *dev,
>  	down_write(&pci_bus_sem);
>  	list_add_tail(&dev->bus_list, &bus->devices);
>  	up_write(&pci_bus_sem);
> +	get_device(&bus->dev);
>  
>  	ret = pcibios_add_device(dev);
>  	WARN_ON(ret < 0);
> Index: linux-2.6/drivers/pci/remove.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/remove.c
> +++ linux-2.6/drivers/pci/remove.c
> @@ -3,20 +3,6 @@
>  #include <linux/pci-aspm.h>
>  #include "pci.h"
>  
> -static void pci_free_resources(struct pci_dev *dev)
> -{
> -	int i;
> -
> - 	msi_remove_pci_irq_vectors(dev);
> -
> -	pci_cleanup_rom(dev);
> -	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> -		struct resource *res = dev->resource + i;
> -		if (res->parent)
> -			release_resource(res);
> -	}
> -}
> -
>  static void pci_stop_dev(struct pci_dev *dev)
>  {
>  	pci_pme_active(dev, false);
> @@ -24,8 +10,7 @@ static void pci_stop_dev(struct pci_dev
>  	if (dev->is_added) {
>  		pci_proc_detach_device(dev);
>  		pci_remove_sysfs_dev_files(dev);
> -		device_del(&dev->dev);
> -		dev->is_added = 0;
> +		device_release_driver(&dev->dev);
>  	}
>  
>  	if (dev->bus->self)
> @@ -34,12 +19,11 @@ static void pci_stop_dev(struct pci_dev
>  
>  static void pci_destroy_dev(struct pci_dev *dev)
>  {
> -	down_write(&pci_bus_sem);
> -	list_del(&dev->bus_list);
> -	up_write(&pci_bus_sem);
> -
> -	pci_free_resources(dev);
> -	put_device(&dev->dev);
> +	if (dev->is_added) {

If it's possible that "dev->is_added == 0" here, doesn't that mean
we leaked a struct pci_dev?

For example, if we're hot-adding a device, dev->is_added is zero
between points A and B here:

    pciehp_configure_device
      pci_scan_slot
        pci_scan_single_device
          pci_scan_device
            dev = alloc_pci_dev         # A) dev->is_added == 0 here
          pci_device_add
            device_initialize
            device_add
      pci_bus_add_devices
        pci_bus_add_device
          device_attach
          dev->is_added = 1             # B) dev->is_added == 1 here

If we can get to pci_destroy_dev() for that device during the
interval between A and B, dev->is_added will be zero, and I don't
know where we will ever clean up the device.

If we *can't* get here during that interval, there shouldn't be any
need to test dev->is_added.

> +		device_del(&dev->dev);
> +		put_device(&dev->dev);
> +		dev->is_added = 0;
> +	}
>  }
>  
>  void pci_remove_bus(struct pci_bus *bus)
> @@ -126,7 +110,7 @@ void pci_stop_root_bus(struct pci_bus *b
>  		pci_stop_bus_device(child);
>  
>  	/* stop the host bridge */
> -	device_del(&host_bridge->dev);
> +	device_release_driver(&host_bridge->dev);
>  }
>  
>  void pci_remove_root_bus(struct pci_bus *bus)
> @@ -145,5 +129,5 @@ void pci_remove_root_bus(struct pci_bus
>  	host_bridge->bus = NULL;
>  
>  	/* remove the host bridge */
> -	put_device(&host_bridge->dev);
> +	device_unregister(&host_bridge->dev);
>  }
