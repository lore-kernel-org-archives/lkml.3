Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3GKNv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:51:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab3GKNvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:51:55 -0400
Message-ID: <51DE8032.4040808@redhat.com>
Date: Thu, 11 Jul 2013 05:51:46 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com
Subject: Re: [PATCH -v2 1/3] PCI: introduce PCIe Device Serial Number Capability
 support
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com> <1373535825-49972-2-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1373535825-49972-2-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 05:43 AM, Yijing Wang wrote:
> Introduce PCIe Ext Capability Device Serial Number support,
> so we can use the unique device serial number to identify
> the physical device. During system suspend, if the PCIe
> device was removed and inserted a new same device, after
> system resume there is no good way to identify it, maybe
> Device Serial Number is a good choice if device support.
>
> Signed-off-by: Yijing Wang<wangyijing@huawei.com>
> ---
>   drivers/pci/pci.c   |   27 +++++++++++++++++++++++++++
>   drivers/pci/probe.c |    2 ++
>   include/linux/pci.h |    3 +++
>   3 files changed, 32 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index e37fea6..2e855b5 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2048,6 +2048,33 @@ void pci_free_cap_save_buffers(struct pci_dev *dev)
>   }
>
>   /**
> + * pci_device_serial_number - get device serial number
> + * @dev: the PCI device
> + *
> + * return the device serial number if device support,
> + * otherwise return 0.
> + */
> +u64 pci_device_serial_number(struct pci_dev *dev)
See comment below:
void  pci_device_serial_number(struct pci_dev *dev)

> +{
> +	int pos;
> +	u64 sn;
> +	u32 lo, hi;
> +
> +	if (!pci_is_pcie(dev))
> +		return 0;
> +
See comment below:
if (!pci_is_pcie(dev)) {
	dev->sn = 0;
	return;
}
> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
> +	if (!pos)
> +		return 0;
> +
> +	pci_read_config_dword(dev, pos + 4,&lo);
> +	pci_read_config_dword(dev, pos + 8,&hi);
> +	sn = ((u64)hi<<  32) | lo;
See comment below:
	dev->sn = ((u64)hi<<  32) | lo;
	return;
> +	return sn;
> +}
> +EXPORT_SYMBOL(pci_device_serial_number);
> +
> +/**
>    * pci_configure_ari - enable or disable ARI forwarding
>    * @dev: the PCI device
>    *
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 46ada5c..c4c1a2b 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1322,6 +1322,8 @@ static void pci_init_capabilities(struct pci_dev *dev)
>   	/* Power Management */
>   	pci_pm_init(dev);
>
> +	dev->sn = pci_device_serial_number(dev);
> +
Finally, 'the comment below':
I know you were following Bjorn's suggestion, which I thought
was an improvement, but why not do above assignment in pci_device_serial_number() ?
See above....
- Don

>   	/* Vital Product Data */
>   	pci_vpd_pci22_init(dev);
>
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 0fd1f15..10d190b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -342,6 +342,7 @@ struct pci_dev {
>   	struct list_head msi_list;
>   	struct kset *msi_kset;
>   #endif
> +	u64 sn;		/* device serieal number, 0 if not support */
>   	struct pci_vpd *vpd;
>   #ifdef CONFIG_PCI_ATS
>   	union {
> @@ -995,6 +996,8 @@ ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
>   ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
>   int pci_vpd_truncate(struct pci_dev *dev, size_t size);
>
> +u64 pci_device_serial_number(struct pci_dev *dev);
> +
>   /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
>   resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
>   void pci_bus_assign_resources(const struct pci_bus *bus);

