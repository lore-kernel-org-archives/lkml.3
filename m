Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767AbbA1UiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:38:21 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45519 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652AbbA1UiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:38:12 -0500
Date: Wed, 28 Jan 2015 14:38:52 +0000
From: Will Deacon <will.deacon@arm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robin Murphy <Robin.Murphy@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "jroedel@suse.de" <jroedel@suse.de>
Subject: Re: [PATCH 4/5] iommu: Make sure a device is always attached to a
 domain
Message-ID: <20150128143852.GS1569@arm.com>
References: <1422317339-22620-1-git-send-email-joro@8bytes.org>
 <1422317339-22620-5-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422317339-22620-5-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 12:08:58AM +0000, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Make use of the default domain and re-attach a device to it
> when it is detached from another domain. Also enforce that a
> device has to be in the default domain before it can be
> attached to a different domain.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/iommu.c | 34 +++++++++++++++++++++++++++++++---
>  1 file changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index b63a550..5080759 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -53,6 +53,7 @@ struct iommu_group {
>  	int id;
>  	unsigned dev_cnt;
>  	struct iommu_domain *default_domain;
> +	struct iommu_domain *domain;
>  };
>  
>  struct iommu_device {
> @@ -1040,8 +1041,17 @@ static int iommu_group_do_attach_device(struct device *dev, void *data)
>  
>  int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
>  {
> -	return iommu_group_for_each_dev(group, domain,
> -					iommu_group_do_attach_device);
> +	int ret;
> +
> +	if (group->default_domain && group->domain != group->default_domain)
> +		return -EBUSY;

I think this is now racy with itself and detach, whereas before we always
held the group->mutex by virtue of iommu_group_for_each_dev.

Will
