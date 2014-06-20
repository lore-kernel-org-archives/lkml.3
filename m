Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966572AbaFTUU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:20:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42010 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaFTUUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:20:24 -0400
Date: Fri, 20 Jun 2014 16:20:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, sungjinn.chung@samsung.com,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] swiotlb: Correct kernel command line handler
Message-ID: <20140620202017.GB5558@laptop.dumpdata.com>
References: <011801cf4d4c$f7ba51f0$e72ef5d0$@samsung.com>
 <20140401124606.GA7135@phenom.dumpdata.com>
 <004c01cf4e2d$1d84a1c0$588de540$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004c01cf4e2d$1d84a1c0$588de540$@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 01:36:29PM +0900, Jungseok Lee wrote:
> On Tuesday, April 01, 2014 9:46 PM, Konrad Rzeszutek Wilk wrote:
> > On Tue, Apr 01, 2014 at 10:51:58AM +0900, Jungseok Lee wrote:
> > > This patch corrects kernel command line handler when io_tlb_nslabs is
> > > set to 0.
> > >
> > > A current implementation allocates default size memory (64MB) when
> > > 0 is given to io_tlb_nslabs ("swiotlb=0") by kernel command line.
> > > In other words, memory is allocated unintentionally.
> > 
> > What are the other IOMMUs that end up taking over the DMA ops?
> 
> I think that no other IOMMUs take over it on ARM64 system, except Xen.
> 
> > Or do you end up with no DMA ops?
> 
> I focus on ARM64 system which uses swiotlb as default DMA ops.
> 
> If some ARM64 platforms would like to use memory only from
> __get_free_pages in swiotlb_alloc_coherent function, an
> interface would be needed to configure reserved memory size.
> 
> Thus, I add it to kernel command line handler.

OK. I somehow have lost track of this patch. Is this patch
still valid?

> 
> Best Regards
> Jungseok Lee
> 
> > >
> > > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > > Signed-off-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > > ---
> > >  lib/swiotlb.c |    8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/lib/swiotlb.c b/lib/swiotlb.c index b604b83..9fe9f71
> > > 100644
> > > --- a/lib/swiotlb.c
> > > +++ b/lib/swiotlb.c
> > > @@ -55,6 +55,8 @@
> > >
> > >  int swiotlb_force;
> > >
> > > +static int swiotlb_no_use;
> > > +
> > >  /*
> > >   * Used to do a quick range check in swiotlb_tbl_unmap_single and
> > >   * swiotlb_tbl_sync_single_*, to see if the memory was in fact
> > > allocated by this @@ -102,6 +104,8 @@ setup_io_tlb_npages(char *str)
> > >  		io_tlb_nslabs = simple_strtoul(str, &str, 0);
> > >  		/* avoid tail segment of size < IO_TLB_SEGSIZE */
> > >  		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> > > +		if (!io_tlb_nslabs)
> > > +			swiotlb_no_use = 1;
> > >  	}
> > >  	if (*str == ',')
> > >  		++str;
> > > @@ -212,7 +216,7 @@ swiotlb_init(int verbose)
> > >  	unsigned char *vstart;
> > >  	unsigned long bytes;
> > >
> > > -	if (!io_tlb_nslabs) {
> > > +	if (!swiotlb_no_use && !io_tlb_nslabs) {
> > >  		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
> > >  		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> > >  	}
> > > @@ -244,7 +248,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
> > >  	unsigned int order;
> > >  	int rc = 0;
> > >
> > > -	if (!io_tlb_nslabs) {
> > > +	if (!swiotlb_no_use && !io_tlb_nslabs) {
> > >  		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
> > >  		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> > >  	}
> > > --
> > > 1.7.10.4
> > >
> > >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in the body of a message
> > to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
