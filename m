Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3EYOX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 10:23:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab3EYOXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 10:23:55 -0400
Message-ID: <1369491828.2646.155.camel@ul30vt.home>
Subject: Re: [PATCH 2/2] vfio: hugepage support for vfio_iommu_type1
From: Alex Williamson <alex.williamson@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: iommu@lists.linux-foundation.org, chegu_vinod@hp.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 25 May 2013 08:23:48 -0600
In-Reply-To: <20130525112009.GC2418@localhost.localdomain>
References: <20130524171613.14229.84050.stgit@bling.home>
	 <20130524172438.14229.59476.stgit@bling.home>
	 <20130525112009.GC2418@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-05-25 at 07:20 -0400, Konrad Rzeszutek Wilk wrote:
> > + * Turns out AMD IOMMU has a page table bug where it won't map large pages
> > + * to a region that previously mapped smaller pages.  This should be fixed
> > + * soon, so this is just a temporary workaround to break mappings down into
> > + * PAGE_SIZE.  Better to map smaller pages than nothing.
> > + */
> > +static int map_try_harder(struct vfio_iommu *iommu, dma_addr_t iova,
> > +			  unsigned long pfn, long npage, int prot)
> > +{
> > +	long i;
> > +	int ret;
> > +
> > +	for (i = 0; i < npage; i++, pfn++, iova += PAGE_SIZE) {
> > +		ret = iommu_map(iommu->domain, iova,
> > +				(phys_addr_t)pfn << PAGE_SHIFT,
> > +				PAGE_SIZE, prot);
> > +		if (ret)
> > +			break;
> > +	}
> > +
> > +	for (; i < npage && i > 0; i--, iova -= PAGE_SIZE)
> > +		iommu_unmap(iommu->domain, iova, PAGE_SIZE);
> > +
> >  	return ret;
> >  }
> 
> This looks to belong to a vfio-quirk file (a something else) that deals with
> various IOMMU's quirks.

This is a software bug in amd_iommu, which Joerg knows about, so I'm
hoping this is a short lived quirk.  I dropped it here for convenience,
but I expect to be able to remove it before long.  If we find some
hardware quirks, I expect we'd want the quirks in the drivers themselves
so the consumers, like vfio, don't need to worry about them.  Thanks,

Alex

