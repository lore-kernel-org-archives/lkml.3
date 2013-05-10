Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3EJVqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:46:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab3EJVqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:46:50 -0400
Message-ID: <1368222408.3334.29.camel@ul30vt.home>
Subject: Re: [PATCH v2 3/8] pci: Add pci_hp_reset_slot
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 10 May 2013 15:46:48 -0600
In-Reply-To: <20130508025753.30771.43656.stgit@bling.home>
References: <20130508025339.30771.61937.stgit@bling.home>
	 <20130508025753.30771.43656.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 20:57 -0600, Alex Williamson wrote:
> Provide an interface to get to hotplug controller reset_slot callback
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/pci/hotplug/pci_hotplug_core.c |   24 ++++++++++++++++++++++++
>  include/linux/pci_hotplug.h            |    8 ++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
> index 202f4a9..1d0fee4 100644
> --- a/drivers/pci/hotplug/pci_hotplug_core.c
> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -537,6 +537,29 @@ int __must_check pci_hp_change_slot_info(struct hotplug_slot *hotplug,
>  	return 0;
>  }
>  
> +/**
> + * pci_hp_reset_slot - reset slot
> + *
> + * @hotplug: pointer to hotplug slot to reset
> + * @probe: reset slot (0) or just probe
> + *
> + * Returns 0 if successful, anything else for an error.
> + */
> +int pci_hp_reset_slot(struct hotplug_slot *hotplug, int probe)
> +{
> +	int result = -ENOTTY;
> +
> +	if (!hotplug || !try_module_get(hotplug->ops->owner))
> +		return result;
> +
> +	if (hotplug->ops->reset_slot)
> +		result = hotplug->ops->reset_slot(hotplug, probe);
> +
> +	module_put(hotplug->ops->owner);
> +
> +	return result;
> +}
> +
>  static int __init pci_hotplug_init (void)
>  {
>  	int result;
> @@ -570,3 +593,4 @@ MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
>  EXPORT_SYMBOL_GPL(__pci_hp_register);
>  EXPORT_SYMBOL_GPL(pci_hp_deregister);
>  EXPORT_SYMBOL_GPL(pci_hp_change_slot_info);
> +EXPORT_SYMBOL_GPL(pci_hp_reset_slot);
> diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
> index 0d3a604..d771cee 100644
> --- a/include/linux/pci_hotplug.h
> +++ b/include/linux/pci_hotplug.h
> @@ -135,6 +135,14 @@ extern int __pci_hp_register(struct hotplug_slot *slot, struct pci_bus *pbus,
>  extern int pci_hp_deregister(struct hotplug_slot *slot);
>  extern int __must_check pci_hp_change_slot_info	(struct hotplug_slot *slot,
>  						 struct hotplug_slot_info *info);
> +#ifdef CONFIG_HOTPLUG_PCI
> +int pci_hp_reset_slot(struct hotplug_slot *slot, int probe);
> +#else
> +static inline int pci_hp_reset_slot(struct hotplug_slot *slot, int probe)
> +{
> +	return -ENOTTY;
> +}
> +#endif
>  
>  /* use a define to avoid include chaining to get THIS_MODULE & friends */
>  #define pci_hp_register(slot, pbus, devnr, name) \
> 

There's a bug here when CONFIG_HOTPLUG_PCI=m.  I'll fix and repost.
self NAK.  Thanks,

Alex

