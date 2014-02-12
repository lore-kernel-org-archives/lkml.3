Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaBLHev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:34:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37704 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaBLHet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:34:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,829,1384272000"; 
   d="scan'208";a="9512162"
Message-ID: <52FB2222.20402@cn.fujitsu.com>
Date: Wed, 12 Feb 2014 15:26:26 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Paul Bolle <pebolle@tiscali.nl>, Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH part1 v6 4/7] PCI: Introduce pci_serial_number_changed()
References: <1392173573-59844-1-git-send-email-wangyijing@huawei.com> <1392173573-59844-5-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1392173573-59844-5-git-send-email-wangyijing@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/12 15:32:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/12 15:32:45
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yijing,
On 02/12/2014 10:52 AM, Yijing Wang wrote:

> Sometimes OS do not know the physical device swap,
> for instance, some device hotplug during system suspend.
> Interrupt can not deliver to OS in some platform.
> So we can use pci serial number capability to detect this
> issue if device supports serial number.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Paul Bolle <pebolle@tiscali.nl>
> Cc: Oliver Neukum <oneukum@suse.de>
> Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/pci.c   |   28 ++++++++++++++++++++++++++++
>  include/linux/pci.h |    2 ++
>  2 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index a8c1c2d..af34057 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2199,6 +2199,34 @@ void pci_dsn_init(struct pci_dev *dev)
>  }
>  
>  /**
> + * pci_serial_number_changed - check the device SN is changed

How about the name “pci_device_changed”? I think it's more readable,
though the judgement is according to SN.

Regards,
Gu

> + * @pdev: the PCI device
> + *
> + * check the device serial number is changed.
> + * if device does not support device serial number,
> + * return false.
> + */
> +bool pci_serial_number_changed(struct pci_dev *pdev)
> +{
> +	u64 old, new;
> +	old = pdev->sn;
> +
> +	if (!pci_is_pcie(pdev))
> +		return false;
> +
> +	new = pci_device_serial_number(pdev->bus,
> +			pdev->devfn);
> +
> +	if (old != new) {
> +		pr_info("%s: Device Serial Number Changed!\n",
> +				pci_name(pdev));
> +		return true;
> +	} else
> +		return false;
> +}
> +EXPORT_SYMBOL(pci_serial_number_changed);
> +
> +/**
>   * pci_configure_ari - enable or disable ARI forwarding
>   * @dev: the PCI device
>   *
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 3631859..d60c0b6 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1025,6 +1025,8 @@ void pci_unlock_rescan_remove(void);
>  ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
>  ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
>  
> +bool pci_serial_number_changed(struct pci_dev *pdev);
> +
>  /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
>  resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
>  void pci_bus_assign_resources(const struct pci_bus *bus);


