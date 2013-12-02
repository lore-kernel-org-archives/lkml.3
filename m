Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3LBBmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:42:15 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:21738 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3LBBmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:42:12 -0500
Message-ID: <529BE508.7090504@huawei.com>
Date: Mon, 2 Dec 2013 09:40:24 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        "Dan Williams" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>
CC: <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>
Subject: Re: [Patch Part1 V2 02/17] iommu/vt-d: fix PCI device reference leakage
 on error recovery path
References: <1385715030-20553-1-git-send-email-jiang.liu@linux.intel.com> <1385715030-20553-3-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1385715030-20553-3-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Yijing Wang <wangyijing@huawei.com>

On 2013/11/29 16:50, Jiang Liu wrote:
> Function dmar_parse_dev_scope() should release the PCI device reference
> count gained in function dmar_parse_one_dev_scope() on error recovery,
> otherwise will cause PCI device object leakage.
> 
> This patch also introduces dmar_free_dev_scope(), which will be used
> to support DMAR device hotplug.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/iommu/dmar.c |   15 +++++++++++++--
>  include/linux/dmar.h |    1 +
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 8b452c9..f3043a2 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -72,6 +72,7 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
>  	struct acpi_dmar_pci_path *path;
>  	int count;
>  
> +	*dev = NULL;
>  	bus = pci_find_bus(segment, scope->bus);
>  	path = (struct acpi_dmar_pci_path *)(scope + 1);
>  	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
> @@ -100,7 +101,6 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
>  	if (!pdev) {
>  		pr_warn("Device scope device [%04x:%02x:%02x.%02x] not found\n",
>  			segment, scope->bus, path->device, path->function);
> -		*dev = NULL;
>  		return 0;
>  	}
>  	if ((scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT && \
> @@ -151,7 +151,7 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
>  			ret = dmar_parse_one_dev_scope(scope,
>  				&(*devices)[index], segment);
>  			if (ret) {
> -				kfree(*devices);
> +				dmar_free_dev_scope(devices, cnt);
>  				return ret;
>  			}
>  			index ++;
> @@ -162,6 +162,17 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
>  	return 0;
>  }
>  
> +void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt)
> +{
> +	if (*devices && *cnt) {
> +		while (--*cnt >= 0)
> +			pci_dev_put((*devices)[*cnt]);
> +		kfree(*devices);
> +		*devices = NULL;
> +		*cnt = 0;
> +	}
> +}
> +
>  /**
>   * dmar_parse_one_drhd - parses exactly one DMA remapping hardware definition
>   * structure which uniquely represent one DMA remapping hardware unit
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index b029d1a..8adfce0 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -159,6 +159,7 @@ extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
>  extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
>  extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
>  				struct pci_dev ***devices, u16 segment);
> +extern void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt);
>  extern int intel_iommu_init(void);
>  #else /* !CONFIG_INTEL_IOMMU: */
>  static inline int intel_iommu_init(void) { return -ENODEV; }
> 


-- 
Thanks!
Yijing

