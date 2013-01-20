Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3ATXyz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:54:55 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47864 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab3ATXyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:54:53 -0500
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
Subject: Re: [RFC PATCH v5 3/8] PCI: add a blocking notifier chain for PCI bus addition/removal
Date: Mon, 21 Jan 2013 00:54:54 +0100
Message-ID: <3583141.yG8QGivRYt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358525267-14268-4-git-send-email-jiang.liu@huawei.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <1358525267-14268-4-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 19, 2013 12:07:41 AM Jiang Liu wrote:
> When adding/removing a PCI bus, some other components want to be
> notified so they could update their states. For example, the pci_slot
> driver needs to create/destroy PCI slots attaching to the PCI bus.
> So introduce a dedicate blocking notifier chain for PCI bus
> addition/removal events. It could be extended to support PCI device
> addition/removal events in the future when needed.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/pci/bus.c    |   24 ++++++++++++++++++++++++
>  drivers/pci/pci.h    |    1 +
>  drivers/pci/probe.c  |    2 ++
>  drivers/pci/remove.c |    1 +
>  include/linux/pci.h  |   12 ++++++++++++
>  5 files changed, 40 insertions(+)
> 
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 4c843cd..8bbd3f2 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -13,11 +13,33 @@
>  #include <linux/errno.h>
>  #include <linux/ioport.h>
>  #include <linux/proc_fs.h>
> +#include <linux/notifier.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  
>  #include "pci.h"
>  
> +static BLOCKING_NOTIFIER_HEAD(pci_bus_notifier_chain);
> +
> +int pci_bus_register_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_register(&pci_bus_notifier_chain, nb);
> +}
> +
> +int pci_bus_unregister_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_unregister(&pci_bus_notifier_chain, nb);
> +}
> +
> +void pci_bus_call_notifier(struct pci_bus *bus, unsigned long code)
> +{
> +	int ret;
> +
> +	ret = blocking_notifier_call_chain(&pci_bus_notifier_chain,
> +					   code, bus);
> +	WARN_ON(ret != NOTIFY_DONE && ret != NOTIFY_OK);

I'm not sure if this is a good idea.  WARN_ON() is quite a heavy tool.

> +}
> +
>  void pci_add_resource_offset(struct list_head *resources, struct resource *res,
>  			     resource_size_t offset)
>  {
> @@ -197,6 +219,8 @@ int pci_bus_add_child(struct pci_bus *bus)
>  	if (retval)
>  		return retval;
>  
> +	pci_bus_call_notifier(bus, PCI_NOTIFY_POST_BUS_ADD);
> +
>  	bus->is_added = 1;
>  
>  	/* Create legacy_io and legacy_mem files for this bus */
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 7414094..988e4b4 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -208,6 +208,7 @@ extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>  extern int pci_resource_bar(struct pci_dev *dev, int resno,
>  			    enum pci_bar_type *type);
>  extern int pci_bus_add_child(struct pci_bus *bus);
> +extern void pci_bus_call_notifier(struct pci_bus *bus, unsigned long code);
>  extern void pci_enable_ari(struct pci_dev *dev);
>  /**
>   * pci_ari_enabled - query ARI forwarding status
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index adb77c6..7db6528 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1679,6 +1679,8 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	if (error)
>  		goto class_dev_reg_err;
>  
> +	pci_bus_call_notifier(b, PCI_NOTIFY_POST_BUS_ADD);
> +
>  	/* Create legacy_io and legacy_mem files for this bus */
>  	pci_create_legacy_files(b);
>  
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 0d03026..2d8fbc8 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -50,6 +50,7 @@ void pci_remove_bus(struct pci_bus *bus)
>  	up_write(&pci_bus_sem);
>  	if (bus->is_added) {
>  		pci_remove_legacy_files(bus);
> +		pci_bus_call_notifier(bus, PCI_NOTIFY_PRE_BUS_DEL);
>  		device_del(&bus->dev);
>  	}
>  	put_device(&bus->dev);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index ee21795..12e5447 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1033,6 +1033,18 @@ const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
>  int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
>  		    int pass);
>  
> +/*
> + * All notifiers below get called with the target struct pci_bus *bus as
> + * an argument.
> + * Note: all PCI bus notifier must return success. Currently there's no
> + * error handling if any notifier returns error code.
> + */
> +#define	PCI_NOTIFY_POST_BUS_ADD		0x00000001 /* PCI bus has been added */
> +#define	PCI_NOTIFY_PRE_BUS_DEL		0x00000002 /* PCI bus will be deleted */

I would call them PCI_EVENT_BUS_ADDED and PCI_EVENT_BUS_REMOVE, respectively.

> +
> +int pci_bus_register_notifier(struct notifier_block *nb);
> +int pci_bus_unregister_notifier(struct notifier_block *nb);
> +
>  void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
>  		  void *userdata);
>  int pci_cfg_space_size_ext(struct pci_dev *dev);

Apart from the nitpicks above, looks good.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
