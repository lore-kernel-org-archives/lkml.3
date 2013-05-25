Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3EYLUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 07:20:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32639 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab3EYLUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 07:20:21 -0400
Date: Sat, 25 May 2013 07:20:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, chegu_vinod@hp.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio: hugepage support for vfio_iommu_type1
Message-ID: <20130525112009.GC2418@localhost.localdomain>
References: <20130524171613.14229.84050.stgit@bling.home>
 <20130524172438.14229.59476.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524172438.14229.59476.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * Turns out AMD IOMMU has a page table bug where it won't map large pages
> + * to a region that previously mapped smaller pages.  This should be fixed
> + * soon, so this is just a temporary workaround to break mappings down into
> + * PAGE_SIZE.  Better to map smaller pages than nothing.
> + */
> +static int map_try_harder(struct vfio_iommu *iommu, dma_addr_t iova,
> +			  unsigned long pfn, long npage, int prot)
> +{
> +	long i;
> +	int ret;
> +
> +	for (i = 0; i < npage; i++, pfn++, iova += PAGE_SIZE) {
> +		ret = iommu_map(iommu->domain, iova,
> +				(phys_addr_t)pfn << PAGE_SHIFT,
> +				PAGE_SIZE, prot);
> +		if (ret)
> +			break;
> +	}
> +
> +	for (; i < npage && i > 0; i--, iova -= PAGE_SIZE)
> +		iommu_unmap(iommu->domain, iova, PAGE_SIZE);
> +
>  	return ret;
>  }

This looks to belong to a vfio-quirk file (a something else) that deals with
various IOMMU's quirks.
