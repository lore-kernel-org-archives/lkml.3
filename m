Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaILJRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:17:34 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:65246 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaILJRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:17:31 -0400
Message-ID: <5412B9F5.50604@huawei.com>
Date: Fri, 12 Sep 2014 17:16:37 +0800
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
Subject: Re: [Patch Part3 V5 2/8] iommu/vt-d: Dynamically allocate and free
 seq_id for DMAR units
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com> <1410487848-6027-3-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1410487848-6027-3-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/12 10:10, Jiang Liu wrote:
> Introduce functions to support dynamic IOMMU seq_id allocating and
> releasing, which will be used to support DMAR hotplug.
> 
> Also rename IOMMU_UNITS_SUPPORTED as DMAR_UNITS_SUPPORTED.

Reviewed-by: Yijing Wang <wangyijing@huawei.com>

> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/iommu/dmar.c        |   40 ++++++++++++++++++++++++++++++++++------
>  drivers/iommu/intel-iommu.c |   13 +++----------
>  include/linux/dmar.h        |    6 ++++++
>  3 files changed, 43 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index afd46eb9a5de..b3405c50627f 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -70,6 +70,7 @@ LIST_HEAD(dmar_drhd_units);
>  struct acpi_table_header * __initdata dmar_tbl;
>  static acpi_size dmar_tbl_size;
>  static int dmar_dev_scope_status = 1;
> +static unsigned long dmar_seq_ids[BITS_TO_LONGS(DMAR_UNITS_SUPPORTED)];
>  
>  static int alloc_iommu(struct dmar_drhd_unit *drhd);
>  static void free_iommu(struct intel_iommu *iommu);
> @@ -928,11 +929,32 @@ out:
>  	return err;
>  }
>  
> +static int dmar_alloc_seq_id(struct intel_iommu *iommu)
> +{
> +	iommu->seq_id = find_first_zero_bit(dmar_seq_ids,
> +					    DMAR_UNITS_SUPPORTED);
> +	if (iommu->seq_id >= DMAR_UNITS_SUPPORTED) {
> +		iommu->seq_id = -1;
> +	} else {
> +		set_bit(iommu->seq_id, dmar_seq_ids);
> +		sprintf(iommu->name, "dmar%d", iommu->seq_id);
> +	}
> +
> +	return iommu->seq_id;
> +}
> +
> +static void dmar_free_seq_id(struct intel_iommu *iommu)
> +{
> +	if (iommu->seq_id >= 0) {
> +		clear_bit(iommu->seq_id, dmar_seq_ids);
> +		iommu->seq_id = -1;
> +	}
> +}
> +
>  static int alloc_iommu(struct dmar_drhd_unit *drhd)
>  {
>  	struct intel_iommu *iommu;
>  	u32 ver, sts;
> -	static int iommu_allocated = 0;
>  	int agaw = 0;
>  	int msagaw = 0;
>  	int err;
> @@ -946,13 +968,16 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
>  	if (!iommu)
>  		return -ENOMEM;
>  
> -	iommu->seq_id = iommu_allocated++;
> -	sprintf (iommu->name, "dmar%d", iommu->seq_id);
> +	if (dmar_alloc_seq_id(iommu) < 0) {
> +		pr_err("IOMMU: failed to allocate seq_id\n");
> +		err = -ENOSPC;
> +		goto error;
> +	}
>  
>  	err = map_iommu(iommu, drhd->reg_base_addr);
>  	if (err) {
>  		pr_err("IOMMU: failed to map %s\n", iommu->name);
> -		goto error;
> +		goto error_free_seq_id;
>  	}
>  
>  	err = -EINVAL;
> @@ -1002,9 +1027,11 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
>  
>  	return 0;
>  
> - err_unmap:
> +err_unmap:
>  	unmap_iommu(iommu);
> - error:
> +error_free_seq_id:
> +	dmar_free_seq_id(iommu);
> +error:
>  	kfree(iommu);
>  	return err;
>  }
> @@ -1028,6 +1055,7 @@ static void free_iommu(struct intel_iommu *iommu)
>  	if (iommu->reg)
>  		unmap_iommu(iommu);
>  
> +	dmar_free_seq_id(iommu);
>  	kfree(iommu);
>  }
>  
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 4af2206e41bc..7daa74ed46d0 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -328,17 +328,10 @@ static int hw_pass_through = 1;
>  /* si_domain contains mulitple devices */
>  #define DOMAIN_FLAG_STATIC_IDENTITY	(1 << 1)
>  
> -/* define the limit of IOMMUs supported in each domain */
> -#ifdef	CONFIG_X86
> -# define	IOMMU_UNITS_SUPPORTED	MAX_IO_APICS
> -#else
> -# define	IOMMU_UNITS_SUPPORTED	64
> -#endif
> -
>  struct dmar_domain {
>  	int	id;			/* domain id */
>  	int	nid;			/* node id */
> -	DECLARE_BITMAP(iommu_bmp, IOMMU_UNITS_SUPPORTED);
> +	DECLARE_BITMAP(iommu_bmp, DMAR_UNITS_SUPPORTED);
>  					/* bitmap of iommus this domain uses*/
>  
>  	struct list_head devices; 	/* all devices' list */
> @@ -2728,12 +2721,12 @@ static int __init init_dmars(void)
>  		 * threaded kernel __init code path all other access are read
>  		 * only
>  		 */
> -		if (g_num_of_iommus < IOMMU_UNITS_SUPPORTED) {
> +		if (g_num_of_iommus < DMAR_UNITS_SUPPORTED) {
>  			g_num_of_iommus++;
>  			continue;
>  		}
>  		printk_once(KERN_ERR "intel-iommu: exceeded %d IOMMUs\n",
> -			  IOMMU_UNITS_SUPPORTED);
> +			  DMAR_UNITS_SUPPORTED);
>  	}
>  
>  	g_iommus = kcalloc(g_num_of_iommus, sizeof(struct intel_iommu *),
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index fac8ca34f9a8..c8a576bc3a98 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -30,6 +30,12 @@
>  
>  struct acpi_dmar_header;
>  
> +#ifdef	CONFIG_X86
> +# define	DMAR_UNITS_SUPPORTED	MAX_IO_APICS
> +#else
> +# define	DMAR_UNITS_SUPPORTED	64
> +#endif
> +
>  /* DMAR Flags */
>  #define DMAR_INTR_REMAP		0x1
>  #define DMAR_X2APIC_OPT_OUT	0x2
> 


-- 
Thanks!
Yijing

