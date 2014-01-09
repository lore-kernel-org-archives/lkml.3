Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaAIIzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:55:07 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:41847 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaAIIy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:54:58 -0500
Message-ID: <52CE6331.60000@huawei.com>
Date: Thu, 9 Jan 2014 16:52:01 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
CC: Ashok Raj <ashok.raj@intel.com>, Tony Luck <tony.luck@intel.com>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>
Subject: Re: [Patch Part2 V1 11/14] iommu/vt-d, PCI: update DRHD/RMRR/ATSR
 device scope caches when PCI hotplug happens
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com> <1389085234-22296-12-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1389085234-22296-12-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerry,
   This is patch solution is better than mine, it's more reliable.
I tested this patch in my huawei RH5885 platform, after applied it,
the issue is gone. But I can not test it in the case that bus number changed
after hotplug. Anyway, it's a good solution.

Thanks!
Yijing.

On 2014/1/7 17:00, Jiang Liu wrote:
> Current Intel DMAR/IOMMU driver assumes that all PCI devices associated
> with DMAR/RMRR/ATSR device scope arrays are created at boot time and
> won't change at runtime, so it caches pointers of associated PCI device
> object. That assumption may be wrong now due to:
> 1) introduction of PCI host bridge hotplug
> 2) PCI device hotplug through sysfs interfaces.
> 

> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 31c72d5..15c9ce0 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -194,6 +194,209 @@ void dmar_free_dev_scope(struct pci_dev __rcu ***devices, int *cnt)
>  	*cnt = 0;
>  }
>  
> +/* Optimize out kzalloc()/kfree() for normal cases */
> +static char dmar_pci_notify_info_buf[64];

In my idea, pci device add/remove is not a frequent action, so maybe using kzalloc and kfree make
code more simplified, this is just my personal opinion.

> +
> +static struct dmar_pci_notify_info *
> +dmar_alloc_pci_notify_info(struct pci_dev *dev, unsigned long event)
> +{
> +	int level = 0;
> +	size_t size;

