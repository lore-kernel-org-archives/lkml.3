Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab3J1QpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:45:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab3J1QpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:45:10 -0400
Message-ID: <1382978662.4097.35.camel@ul30vt.home>
Subject: Re: [PATCH v2] ARM: SMMU: add devices attached to the SMMU to an
 IOMMU group
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        tech@virtualopensystems.com
Date: Mon, 28 Oct 2013 10:44:22 -0600
In-Reply-To: <1382108910-18049-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1382108910-18049-1-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 17:08 +0200, Antonios Motakis wrote:
> IOMMU groups are expected by certain users of the IOMMU API,
> e.g. VFIO. Add new devices found by the SMMU driver to an IOMMU
> group to satisfy those users.
> 
> Changes from v1:
>  * Added check that dev->archdata.iommu has not been set already by an IOMMU
>    driver. This way we can also skip checking for an existing IOMMU group.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>


Looks ok to me.

Acked-by: Alex Williamson <alex.williamson@redhat.com>

> ---
>  drivers/iommu/arm-smmu.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index 0f45a48..6762885 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1502,6 +1502,13 @@ static int arm_smmu_add_device(struct device *dev)
>  {
>  	struct arm_smmu_device *child, *parent, *smmu;
>  	struct arm_smmu_master *master = NULL;
> +	struct iommu_group *group;
> +	int ret;
> +
> +	if (dev->archdata.iommu) {
> +		dev_warn(dev, "IOMMU driver already assigned to device\n");
> +		return -EINVAL;
> +	}
>  
>  	spin_lock(&arm_smmu_devices_lock);
>  	list_for_each_entry(parent, &arm_smmu_devices, list) {
> @@ -1534,13 +1541,23 @@ static int arm_smmu_add_device(struct device *dev)
>  	if (!master)
>  		return -ENODEV;
>  
> +	group = iommu_group_alloc();
> +	if (IS_ERR(group)) {
> +		dev_err(dev, "Failed to allocate IOMMU group\n");
> +		return PTR_ERR(group);
> +	}
> +
> +	ret = iommu_group_add_device(group, dev);
> +	iommu_group_put(group);
>  	dev->archdata.iommu = smmu;
> -	return 0;
> +
> +	return ret;
>  }
>  
>  static void arm_smmu_remove_device(struct device *dev)
>  {
>  	dev->archdata.iommu = NULL;
> +	iommu_group_remove_device(dev);
>  }
>  
>  static struct iommu_ops arm_smmu_ops = {


