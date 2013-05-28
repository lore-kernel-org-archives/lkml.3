Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab3E1LH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:07:57 -0400
Received: from 8bytes.org ([85.214.48.195]:58911 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab3E1LH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:07:56 -0400
Date: Tue, 28 May 2013 13:07:52 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@redhat.com,
        iommu@lists.linux-foundation.org,
        Steven L Kinney <Steven.Kinney@amd.com>
Subject: Re: [PATCH 1/2 V3] perf/x86/amd: Adding IOMMU PC resource management
Message-ID: <20130528110752.GB2575@8bytes.org>
References: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1368819813-6481-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368819813-6481-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 28 13:07:54 2013
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51a4900a20868926915053
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 02:43:31PM -0500, Suthikulpanit, Suravee wrote:
> From: Steven L Kinney <Steven.Kinney@amd.com>
> 
> Add functionality to check the availability of the AMD IOMMU Performance
> Counters and export this functionality to other core drivers, such as in this
> case, a perf AMD IOMMU PMU.  This feature is not bound to any specific AMD
> family/model other than the presence of the IOMMU with PC enabled.
> 
> The AMD IOMMU PC support static counting only at this time.
> 
> Signed-off-by: Steven Kinney <steven.kinney@amd.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
> V2 Changes:
> 	- Modify the amd_iommu_pc_get_set_reg_val function 
> 	to support 64 bit values. 
> 	- Fix logic to properly clear amd_iommu_pc_present when
> 	initialization failed.
> 
>  drivers/iommu/amd_iommu_init.c  |  121 ++++++++++++++++++++++++++++++++++++++-
>  drivers/iommu/amd_iommu_proto.h |    7 +++
>  drivers/iommu/amd_iommu_types.h |   12 +++-
>  3 files changed, 134 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index bf51abb..395fa29 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -154,6 +154,7 @@ bool amd_iommu_iotlb_sup __read_mostly = true;
>  u32 amd_iommu_max_pasids __read_mostly = ~0;
>  
>  bool amd_iommu_v2_present __read_mostly;
> +bool amd_iommu_pc_present __read_mostly;
>  
>  bool amd_iommu_force_isolation __read_mostly;
>  
> @@ -371,21 +372,21 @@ static void iommu_disable(struct amd_iommu *iommu)
>   */
>  static u8 __iomem * __init iommu_map_mmio_space(u64 address)
>  {
> -	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu")) {
> +	if (!request_mem_region(address, MMIO_REG_END_OFFSET, "amd_iommu")) {

This length needs to be different on IOMMUv1 systems where the MMI
region is only 16kb large. Only use MMIO_REG_END_OFFSET on IOMMUv2
systems.

> +static void init_iommu_perf_ctr(struct amd_iommu *iommu)
> +{
> +	u64 val = 0xabcd, val2 = 0;
> +
> +	if (!iommu_feature(iommu, FEATURE_PC))
> +		return;
> +
> +	amd_iommu_pc_present = true;
> +
> +	/* Check if the performance counters can be written to */
> +	if ((0 != amd_iommu_pc_get_set_reg_val(0, 0, 0, 0, &val, true)) ||
> +	    (0 != amd_iommu_pc_get_set_reg_val(0, 0, 0, 0, &val2, false)) ||
> +	    (val != val2)) {
> +		pr_err("AMD-Vi: Unable to write to IOMMU perf counter.\n");
> +		amd_iommu_pc_present = false;
> +		return;
> +	}
> +
> +	pr_info("AMD-Vi: IOMMU performance counters " "supported\n");

Why are this two strings? This makes it hard to grep for the message.


> +u8 amd_iommu_pc_get_max_banks(u16 devid)
> +{
> +	struct amd_iommu *iommu;
> +
> +	/* locate the iommu governing the devid */
> +	iommu = amd_iommu_rlookup_table[devid];
> +
> +	if (iommu)
> +		return iommu->max_banks;
> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL(amd_iommu_pc_get_max_banks);

You can't return -ENODEV in a function returning u8. Return int instead.

> +
> +bool amd_iommu_pc_supported(void)
> +{
> +	return amd_iommu_pc_present;
> +}
> +EXPORT_SYMBOL(amd_iommu_pc_supported);
> +
> +u8 amd_iommu_pc_get_max_counters(u16 devid)
> +{
> +	struct amd_iommu *iommu;
> +
> +	/* locate the iommu governing the devid */
> +	iommu = amd_iommu_rlookup_table[devid];
> +
> +	if (iommu)
> +		return iommu->max_counters;
> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL(amd_iommu_pc_get_max_counters);

Same here. Please don't return negative values as u8.

> +
> +int amd_iommu_pc_get_set_reg_val(u16 devid, u8 bank, u8 cntr, u8 fxn,
> +				    u64 *value, bool is_write)
> +{
> +	struct amd_iommu *iommu;
> +	u32 offset;
> +	u32 max_offset_lim;
> +
> +	/* Make sure the IOMMU PC resource is available */
> +	if (!amd_iommu_pc_present) {
> +		pr_info("AMD IOMMU - PC Not supported.\n");

This message is redundant. You already print about about performance
counter availability in the init code. Please remove it.

> +		return -ENODEV;
> +	}
> +
> +	/* locate the iommu associated with the device ID */
> +	iommu = amd_iommu_rlookup_table[devid];
> +	if (iommu == NULL)
> +		return -ENODEV;
> +
> +	/* check for valid iommu pc register indexing */
> +	if (fxn < 0 || fxn > 0x28 || (fxn & 7))
> +		return -ENODEV;

Does this check for calling errors? If so, you might consider turning
this into a WARN_ON.

> +
> +	offset = (u32)(((0x40|bank) << 12) | (cntr << 8) | fxn);
> +
> +	/* limit the offset to the hw defined mmio region aperture */
> +	max_offset_lim = (u32)(((0x40|iommu->max_banks) << 12) |
> +				(iommu->max_counters << 8) | 0x28);
> +	if ((offset < MMIO_CNTR_REG_OFFSET) ||
> +	    (offset > max_offset_lim))
> +		return -EINVAL;
> +
> +	if (is_write) {
> +		writel((u32)*value, iommu->mmio_base + offset);
> +		writel((*value >> 32), iommu->mmio_base + offset + 4);
> +	} else {
> +		*value = readl(iommu->mmio_base + offset + 4);
> +		*value <<= 32;
> +		*value = readl(iommu->mmio_base + offset);
> +	}
> +
> +	return 0;
> +}


	Joerg


