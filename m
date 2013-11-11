Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3KKXpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:45:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab3KKXpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:45:33 -0500
Message-ID: <1384211375.22415.69.camel@ul30vt.home>
Subject: Re: [PATCH] iommu: Split iommu_unmaps
From: Alex Williamson <alex.williamson@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Date: Mon, 11 Nov 2013 16:09:35 -0700
In-Reply-To: <1383842247.27315.117.camel@shinybook.infradead.org>
References: <20130524171401.14099.78694.stgit@bling.home>
	 <1383842247.27315.117.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 16:37 +0000, David Woodhouse wrote:
> On Fri, 2013-05-24 at 11:14 -0600, Alex Williamson wrote:
> > iommu_map splits requests into pages that the iommu driver reports
> > that it can handle.  The iommu_unmap path does not do the same.  This
> > can cause problems not only from callers that might expect the same
> > behavior as the map path, but even from the failure path of iommu_map,
> > should it fail at a point where it has mapped and needs to unwind a
> > set of pages that the iommu driver cannot handle directly.  amd_iommu,
> > for example, will BUG_ON if asked to unmap a non power of 2 size.
> > 
> > Fix this by extracting and generalizing the sizing code from the
> > iommu_map path and use it for both map and unmap.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> Ick, this is horrid and looks like it will introduce a massive
> performance hit.

For x86 there are essentially two users of iommu_unmap(), KVM and VFIO.
Both of them try to unmap an individual page and look at the result to
see how much was actually unmapped.  Everything else appears to be error
paths.  So where exactly is this massive performance hit?

> Surely the answer is to fix the AMD driver so that it will just get on
> with it and unmap the {address, range} that it's asked to map?

The IOMMU API allows iommu drivers to expose the page sizes they
support.  Mappings are done using these sizes so it only seems fair that
unmappings should as well.  At least that's what amd_iommu was
expecting.

> And fix the generic iommu_map() code while we're at it, to do it the
> same way.
> 
> IOTLB flushes are *slow*, and on certain hardware with
> non-cache-coherent page tables even the dcache flush for the page table
> is slow. If you deliberately break it up into individual pages and do
> the flush between each one, rather than just unmapping the range, you
> are pessimising the performance quite hard.
> 
> A while back, I went through the Intel IOMMU code to make sure it was
> doing this right — it used to have this kind of bogosity with repeated
> per-page cache and IOTLB flushes *internally*, and the resulting
> performance improvement was shown at http://david.woodhou.se/iommu.png
> 
> You will basically be undoing that work, by ensuring that the low-level
> driver never *sees* the full range.

That data is for dma_ops interfaces, not IOMMU API.  How is changing
iommu_unmap() in this way undoing any of your previous work?

> If the AMD driver really can't handle more than one page at a time, let
> it loop for *itself* over the pages.

Sure, but that's a change to the API where I think this fix was
correcting a bug in the implementation of the API.  Are there users of
iommu_unmap() that I don't know about?  Given the in-tree users, there's
not really a compelling argument to optimize.  Thanks,

Alex

