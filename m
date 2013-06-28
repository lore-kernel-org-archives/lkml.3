Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3F1Tt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:49:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54411 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab3F1Tt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:49:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/6] PCI: introduce pci_trim_stale_devices()
Date: Fri, 28 Jun 2013 21:59:26 +0200
Message-ID: <2795933.HtOzpJWrsk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1372177330-28013-4-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com> <1372177330-28013-4-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 25, 2013 07:22:07 PM Mika Westerberg wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> The new function stops and removes the device if it doesn't respond.
> If the device responds and it's a bus we apply the function to all
> subdevices recursively.
> 
> It's useful for hotplug bus check case, when you need drop all unplugged
> devices before looking for new ones.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

I think it'd be better to fold this into [4/6].  This way it would be clearer
what that patch did.

Thanks,
Rafael


> ---
>  drivers/pci/remove.c | 20 ++++++++++++++++++++
>  include/linux/pci.h  |  1 +
>  2 files changed, 21 insertions(+)
> 
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 8fc54b7..77b7a64 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -112,6 +112,26 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
>  
> +/**
> + * pci_trim_stale_devices - remove stale device or any stale child
> + */
> +void pci_trim_stale_devices(struct pci_dev *dev)
> +{
> +	struct pci_bus *bus = dev->subordinate;
> +	struct pci_dev *child, *tmp;
> +	bool alive;
> +	u32 l;
> +
> +	/* check if the device responds */
> +	alive = pci_bus_read_dev_vendor_id(dev->bus, dev->devfn, &l, 0);
> +	if (!alive)
> +		pci_stop_and_remove_bus_device(dev);
> +
> +	if (alive && bus)
> +		list_for_each_entry_safe(child, tmp, &bus->devices, bus_list)
> +			pci_trim_stale_devices(child);
> +}
> +
>  void pci_stop_root_bus(struct pci_bus *bus)
>  {
>  	struct pci_dev *child, *tmp;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 3a24e4f..8f6e7a0 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -754,6 +754,7 @@ struct pci_dev *pci_dev_get(struct pci_dev *dev);
>  void pci_dev_put(struct pci_dev *dev);
>  void pci_remove_bus(struct pci_bus *b);
>  void pci_stop_and_remove_bus_device(struct pci_dev *dev);
> +void pci_trim_stale_devices(struct pci_dev *dev);
>  void pci_stop_root_bus(struct pci_bus *bus);
>  void pci_remove_root_bus(struct pci_bus *bus);
>  void pci_setup_cardbus(struct pci_bus *bus);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
