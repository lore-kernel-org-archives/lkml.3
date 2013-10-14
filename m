Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab3JNMtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:49:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45083 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755665Ab3JNMtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:49:10 -0400
Date: Mon, 14 Oct 2013 13:48:16 +0100
From: Will Deacon <will.deacon@arm.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        "B08248@freescale.com" <B08248@freescale.com>
Subject: Re: [PATCH 1/2] ARM: SMMU: add devices attached to the SMMU to an
 IOMMU group
Message-ID: <20131014124815.GC10491@mudshark.cambridge.arm.com>
References: <1381497887-14586-1-git-send-email-a.motakis@virtualopensystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381497887-14586-1-git-send-email-a.motakis@virtualopensystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonios,

On Fri, Oct 11, 2013 at 02:24:46PM +0100, Antonios Motakis wrote:
> IOMMU groups are expected by certain users of the IOMMU API,
> e.g. VFIO. Add new devices found by the SMMU driver to an IOMMU
> group to satisfy those users.

Cheers for looking at this: VFIO has been on my TODO list for some time.

> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/iommu/arm-smmu.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index 0f45a48..8b71332 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1502,6 +1502,8 @@ static int arm_smmu_add_device(struct device *dev)
>  {
>  	struct arm_smmu_device *child, *parent, *smmu;
>  	struct arm_smmu_master *master = NULL;
> +	struct iommu_group *group;
> +	int ret;
>  
>  	spin_lock(&arm_smmu_devices_lock);
>  	list_for_each_entry(parent, &arm_smmu_devices, list) {
> @@ -1534,13 +1536,27 @@ static int arm_smmu_add_device(struct device *dev)
>  	if (!master)
>  		return -ENODEV;
>  
> +	group = iommu_group_get(dev);

I'm not especially familiar with IOMMU groups (I understand them as the
minimum translation granularity, which would mean single StreamID for the
ARM SMMU), but under what circumstances would you expect to receive a
non-NULL group here? I can't see any other code adding devices to groups
(outside of other drivers)...

Will
