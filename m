Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbaFSINs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 04:13:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45284 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaFSINp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 04:13:45 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 19 Jun 2014 17:18:07 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v3 -next 4/9] DMA, CMA: support arbitrary bitmap
 granularity
Message-ID: <20140619081807.GA28611@js1304-P5Q-DELUXE>
References: <1402897251-23639-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1402897251-23639-5-git-send-email-iamjoonsoo.kim@lge.com>
 <20140618134815.69c4d0a5f916846f9857e9ff@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618134815.69c4d0a5f916846f9857e9ff@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:48:15PM -0700, Andrew Morton wrote:
> On Mon, 16 Jun 2014 14:40:46 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > PPC KVM's CMA area management requires arbitrary bitmap granularity,
> > since they want to reserve very large memory and manage this region
> > with bitmap that one bit for several pages to reduce management overheads.
> > So support arbitrary bitmap granularity for following generalization.
> > 
> > ...
> >
> > --- a/drivers/base/dma-contiguous.c
> > +++ b/drivers/base/dma-contiguous.c
> > @@ -38,6 +38,7 @@ struct cma {
> >  	unsigned long	base_pfn;
> >  	unsigned long	count;
> >  	unsigned long	*bitmap;
> > +	unsigned int order_per_bit; /* Order of pages represented by one bit */
> >  	struct mutex	lock;
> >  };
> >  
> > @@ -157,9 +158,37 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
> >  
> >  static DEFINE_MUTEX(cma_mutex);
> >  
> > +static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
> > +{
> > +	return (1 << (align_order >> cma->order_per_bit)) - 1;
> > +}
> 
> Might want a "1UL << ..." here.

Okay!

> 
> > +static unsigned long cma_bitmap_maxno(struct cma *cma)
> > +{
> > +	return cma->count >> cma->order_per_bit;
> > +}
> > +
> > +static unsigned long cma_bitmap_pages_to_bits(struct cma *cma,
> > +						unsigned long pages)
> > +{
> > +	return ALIGN(pages, 1 << cma->order_per_bit) >> cma->order_per_bit;
> > +}
> 
> Ditto.  I'm not really sure what the compiler will do in these cases,
> but would prefer not to rely on it anyway!

Okay!

Thanks for fix!
