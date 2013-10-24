Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3JXLAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 07:00:40 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60720 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab3JXLAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 07:00:39 -0400
X-IronPort-AV: E=Sophos;i="4.93,561,1378857600"; 
   d="scan'208";a="64236332"
Date: Thu, 24 Oct 2013 11:44:50 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v8 13/19] swiotlb-xen: use xen_dma_map/unmap_page,
 xen_dma_sync_single_for_cpu/device
In-Reply-To: <20131023195154.GB28963@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1310241133070.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com> <1382031814-8782-13-git-send-email-stefano.stabellini@eu.citrix.com> <20131023140927.GD27771@phenom.dumpdata.com> <alpine.DEB.2.02.1310231816180.26077@kaball.uk.xensource.com>
 <20131023195154.GB28963@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Oct 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 23, 2013 at 06:20:25PM +0100, Stefano Stabellini wrote:
> > On Wed, 23 Oct 2013, Konrad Rzeszutek Wilk wrote:
> > > On Thu, Oct 17, 2013 at 06:43:28PM +0100, Stefano Stabellini wrote:
> > > > Call xen_dma_map_page, xen_dma_unmap_page, xen_dma_sync_single_for_cpu,
> > > > xen_dma_sync_single_for_device from swiotlb-xen to ensure cpu/device
> > > > coherency of the pages used for DMA, including the ones belonging to the
> > > > swiotlb buffer.
> > > 
> > > You lost me.
> > > 
> > > Isn't it the driver's responsibility to do this?
> > > 
> > > Looking at what 'xen_dma_map_page()' does for x86 it looks to add an extra
> > > call - page_to_phys - and we ignore it here.
> > 
> > map_page on arm calls the right cache flushes needed to communicate with
> > the device. Same with unmap_page.
> 
> If this is flushing the cache then I think it makes more sense to do
> that without this fancy 'dma_map_page'.
> 
> Just call it 'xen_flush_dma_page' and make it a nop on all platforms
> except ARM.

I am OK with making it a nop on x86, it makes sense.
However I would like to keep it called xen_dma_map_page: after all it
corresponds exactly to the native map_page dma_op. It is part of the same
"contract".


> > On x86 they are basically nop.
> 
> It calls page_to_phys in your patch. That is hardly nop.

I see. It is certainly worth optimizing it out on x86.
Of course if one day the x86 map_page dma_op starts doing something
useful, we can go back to call it from xen_dma_map_page.
