Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaFPFXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 01:23:50 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:59880 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaFPFXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 01:23:47 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 16 Jun 2014 14:27:59 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 06/10] CMA: generalize CMA reserved area management
 functionality
Message-ID: <20140616052759.GE23210@js1304-P5Q-DELUXE>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1402543307-29800-7-git-send-email-iamjoonsoo.kim@lge.com>
 <87a99fg5ir.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a99fg5ir.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 03:46:44PM +0530, Aneesh Kumar K.V wrote:
> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
> 
> > Currently, there are two users on CMA functionality, one is the DMA
> > subsystem and the other is the kvm on powerpc. They have their own code
> > to manage CMA reserved area even if they looks really similar.
> > From my guess, it is caused by some needs on bitmap management. Kvm side
> > wants to maintain bitmap not for 1 page, but for more size. Eventually it
> > use bitmap where one bit represents 64 pages.
> >
> > When I implement CMA related patches, I should change those two places
> > to apply my change and it seem to be painful to me. I want to change
> > this situation and reduce future code management overhead through
> > this patch.
> >
> > This change could also help developer who want to use CMA in their
> > new feature development, since they can use CMA easily without
> > copying & pasting this reserved area management code.
> >
> > In previous patches, we have prepared some features to generalize
> > CMA reserved area management and now it's time to do it. This patch
> > moves core functions to mm/cma.c and change DMA APIs to use
> > these functions.
> >
> > There is no functional change in DMA APIs.
> >
> > v2: There is no big change from v1 in mm/cma.c. Mostly renaming.
> >
> > Acked-by: Michal Nazarewicz <mina86@mina86.com>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> 
> .....
> 
> > +
> > +	mask = cma_bitmap_aligned_mask(cma, align);
> > +	bitmap_maxno = cma_bitmap_maxno(cma);
> > +	nr_bits = cma_bitmap_pages_to_bits(cma, count);
> > +
> > +	for (;;) {
> > +		mutex_lock(&cma->lock);
> > +		bitmapno = bitmap_find_next_zero_area(cma->bitmap,
> > +					bitmap_maxno, start, nr_bits, mask);
> > +		if (bitmapno >= bitmap_maxno) {
> > +			mutex_unlock(&cma->lock);
> > +			break;
> > +		}
> > +		bitmap_set(cma->bitmap, bitmapno, nr_bits);
> > +		/*
> > +		 * It's safe to drop the lock here. We've marked this region for
> > +		 * our exclusive use. If the migration fails we will take the
> > +		 * lock again and unmark it.
> > +		 */
> > +		mutex_unlock(&cma->lock);
> > +
> > +		pfn = cma->base_pfn + (bitmapno << cma->order_per_bit);
> > +		mutex_lock(&cma_mutex);
> > +		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
> > +		mutex_unlock(&cma_mutex);
> > +		if (ret == 0) {
> > +			page = pfn_to_page(pfn);
> > +			break;
> > +		} else if (ret != -EBUSY) {
> > +			clear_cma_bitmap(cma, pfn, count);
> > +			break;
> > +		}
> > +		
> 
> 
> For setting bit map we do
> 		bitmap_set(cma->bitmap, bitmapno, nr_bits);
>                 alloc_contig()..
>                 if (error)
>                         clear_cma_bitmap(cma, pfn, count);
> 
> Why ?
> 
> why not bitmap_clear() ?
> 

Unlike your psuedo code, for setting bitmap, we do
- grab the mutex
- bitmap_set
- release the mutex

clear_cma_bitmap() handles these things.

Thanks.

