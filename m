Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaBLHzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:55:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10054 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaBLHzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:55:01 -0500
X-IronPort-AV: E=Sophos;i="4.95,830,1384272000"; 
   d="scan'208";a="9512250"
Message-ID: <52FB26DC.1050804@cn.fujitsu.com>
Date: Wed, 12 Feb 2014 15:46:36 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH part1 v6 5/7] PCI: Add pci_dummy_ops to isolate pci device
 temporarily
References: <1392173573-59844-1-git-send-email-wangyijing@huawei.com> <1392173573-59844-6-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1392173573-59844-6-git-send-email-wangyijing@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/12 15:52:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/12 15:52:55,
	Serialize complete at 2014/02/12 15:52:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yijing,
On 02/12/2014 10:52 AM, Yijing Wang wrote:

> Pci_dummy_ops does nothing when we use it to read/write
> pci_device. So we can isolate pci device by replace its
> bus pci_ops by pci_dummy_ops. This is preparation for
> the later patch.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/pci/pci.c   |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |    4 +++
>  2 files changed, 66 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index af34057..283e82e 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2226,6 +2226,68 @@ bool pci_serial_number_changed(struct pci_dev *pdev)
>  }
>  EXPORT_SYMBOL(pci_serial_number_changed);
>  
> +static int pci_dummy_read(struct pci_bus *bus, unsigned int devfn,
> +		int where, int size, u32 *val)
> +{
> +	return PCIBIOS_DEVICE_NOT_FOUND;
> +}
> +
> +static int pci_dummy_write(struct pci_bus *bus, unsigned int devfn,
> +		int reg, int size, u32 val)
> +{
> +	return PCIBIOS_DEVICE_NOT_FOUND;
> +}
> +
> +static struct pci_ops pci_dummy_ops = {
> +	.read = pci_dummy_read,
> +	.write = pci_dummy_write,
> +};
> +
> +static DEFINE_SPINLOCK(pci_freeze_lock);
> +/**
> + * pci_bus_freeze_device - freeze pci bus to access pci device
> + * @bus: the pci bus to freeze
> + *
> + * Replace pci bus ops by pci_dummy_ops, protect system from
> + * accessing pci devices.
> + */
> +void pci_bus_freeze_device(struct pci_bus *bus)
> +{
> +	struct pci_ops *ops;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pci_freeze_lock, flags);
> +	if (bus->is_frozen)
> +		goto out;
> +	bus->is_frozen = 1;
> +	ops = pci_bus_set_ops(bus, &pci_dummy_ops);
> +	bus->save_ops = ops;
> +out:
> +	spin_unlock_irqrestore(&pci_freeze_lock, flags);
> +}
> +
> +/**
> + * pci_bus_unfreeze_device - unfreeze pci bus to acess pci devices
> + * @bus: the pci bus to unfreeze
> + *
> + * Restore pci bus original ops, so pci bus can access
> + * pci devices normally.
> + */
> +void pci_bus_unfreeze_device(struct pci_bus *bus)
> +{
> +	unsigned long flags;
> +
> +	BUG_ON(!bus->save_ops);
> +	spin_lock_irqsave(&pci_freeze_lock, flags);
> +	if (!bus->is_frozen)
> +		goto out;

It seems that the BUG_ON() should placed here, otherwise it will be
triggered if we try to unfreeze the same bus multiply.

Regards,
Gu

> +	pci_bus_set_ops(bus, bus->save_ops);
> +	bus->save_ops = NULL;
> +	bus->is_frozen = 0;
> +out:
> +	spin_unlock_irqrestore(&pci_freeze_lock, flags);
> +}
> +
>  /**
>   * pci_configure_ari - enable or disable ARI forwarding
>   * @dev: the PCI device
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index d60c0b6..e3dd4ea 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -442,6 +442,7 @@ struct pci_bus {
>  	struct resource busn_res;	/* bus numbers routed to this bus */
>  
>  	struct pci_ops	*ops;		/* configuration access functions */
> +	struct pci_ops	*save_ops; /* save configuration access functions */
>  	struct msi_chip	*msi;		/* MSI controller */
>  	void		*sysdata;	/* hook for sys-specific extension */
>  	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/pci */
> @@ -460,6 +461,7 @@ struct pci_bus {
>  	struct bin_attribute	*legacy_io; /* legacy I/O for this bus */
>  	struct bin_attribute	*legacy_mem; /* legacy mem */
>  	unsigned int		is_added:1;
> +	unsigned int		is_frozen:1;
>  };
>  
>  #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
> @@ -1026,6 +1028,8 @@ ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
>  ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
>  
>  bool pci_serial_number_changed(struct pci_dev *pdev);
> +void pci_bus_freeze_device(struct pci_bus *bus);
> +void pci_bus_unfreeze_device(struct pci_bus *bus);
>  
>  /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
>  resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);


