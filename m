Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbbA1UdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:33:16 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45508 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbbA1UdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:33:12 -0500
Date: Wed, 28 Jan 2015 14:35:24 +0000
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
Subject: Re: [PATCH 3/5] iommu: Limit iommu_attach/detach_device to devices
 with their own group
Message-ID: <20150128143523.GR1569@arm.com>
References: <1422317339-22620-1-git-send-email-joro@8bytes.org>
 <1422317339-22620-4-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422317339-22620-4-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 12:08:57AM +0000, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> This patch changes the behavior of the iommu_attach_device
> and iommu_detach_device functions. With this change these
> functions only work on devices that have their own group.
> For all other devices the iommu_group_attach/detach
> functions must be used.

I like this a lot. Currently, if somebody detaches a device from the ARM
SMMU, I end up detaching its group as well, which I've always found slightly
odd.

> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/iommu.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 59 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 8f33ddd3..b63a550 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -51,6 +51,7 @@ struct iommu_group {
>  	void (*iommu_data_release)(void *iommu_data);
>  	char *name;
>  	int id;
> +	unsigned dev_cnt;

Is this actually used on a fast path, or can we just inspect the list of
devices on the group instead?

Will
