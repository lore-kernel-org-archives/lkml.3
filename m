Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaIOByl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 21:54:41 -0400
Received: from [119.145.14.66] ([119.145.14.66]:27913 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaIOByi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 21:54:38 -0400
Message-ID: <54164699.9020906@huawei.com>
Date: Mon, 15 Sep 2014 09:53:29 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Vinod Koul" <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
CC: Ashok Raj <ashok.raj@intel.com>, Tony Luck <tony.luck@intel.com>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        <linux-hotplug@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
Subject: Re: [Patch Part3 V5 4/8] iommu/vt-d: Search for ACPI _DSM method
 for DMAR hotplug
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com> <1410487848-6027-5-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1410487848-6027-5-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.541646B1.00EC,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: b94828c8025e3d6dacd8210bf5a4e843
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/12 10:10, Jiang Liu wrote:
> According to Intel VT-d specification, _DSM method to support DMAR
> hotplug should exist directly under corresponding ACPI object
> representing PCI host bridge. But some BIOSes doesn't conform to
> this, so search for _DSM method in the subtree starting from the
> ACPI object representing the PCI host bridge.

Reviewed-by: Yijing Wang <wangyijing@huawei.com>

> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/iommu/dmar.c |   35 +++++++++++++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index e77b5d3f2f5c..df2c2591c1a6 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -1926,21 +1926,48 @@ static int dmar_hotplug_remove(acpi_handle handle)
>  	return ret;
>  }
>  
> -static int dmar_device_hotplug(acpi_handle handle, bool insert)
> +static acpi_status dmar_get_dsm_handle(acpi_handle handle, u32 lvl,
> +				       void *context, void **retval)
> +{
> +	acpi_handle *phdl = retval;
> +
> +	if (dmar_detect_dsm(handle, DMAR_DSM_FUNC_DRHD)) {
> +		*phdl = handle;
> +		return AE_CTRL_TERMINATE;
> +	}
> +
> +	return AE_OK;
> +}
> +
> +int dmar_device_hotplug(acpi_handle handle, bool insert)
>  {
>  	int ret;
> +	acpi_handle tmp = NULL;
> +	acpi_status status;
>  
>  	if (!dmar_in_use())
>  		return 0;
>  
> -	if (!dmar_detect_dsm(handle, DMAR_DSM_FUNC_DRHD))
> +	if (dmar_detect_dsm(handle, DMAR_DSM_FUNC_DRHD)) {
> +		tmp = handle;
> +	} else {
> +		status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
> +					     ACPI_UINT32_MAX,
> +					     dmar_get_dsm_handle,
> +					     NULL, NULL, &tmp);
> +		if (ACPI_FAILURE(status)) {
> +			pr_warn("Failed to locate _DSM method.\n");
> +			return -ENXIO;
> +		}
> +	}
> +	if (tmp == NULL)
>  		return 0;
>  
>  	down_write(&dmar_global_lock);
>  	if (insert)
> -		ret = dmar_hotplug_insert(handle);
> +		ret = dmar_hotplug_insert(tmp);
>  	else
> -		ret = dmar_hotplug_remove(handle);
> +		ret = dmar_hotplug_remove(tmp);
>  	up_write(&dmar_global_lock);
>  
>  	return ret;
> 


-- 
Thanks!
Yijing

