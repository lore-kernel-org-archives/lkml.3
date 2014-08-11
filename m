Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaHKPRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:17:10 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:64230 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbaHKPRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:17:08 -0400
Date: Mon, 11 Aug 2014 11:17:14 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Mario Kleiner <mario.kleiner.de@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Airlie <airlied@redhat.com>, kamal@canonical.com,
        ben@decadent.org.uk, LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        m.szyprowski@samsung.com
Subject: Re: CONFIG_DMA_CMA causes ttm performance problems/hangs.
Message-ID: <20140811151712.GA3541@gmail.com>
References: <53E50C1B.9080507@gmail.com>
 <53E5B41B.3030009@vmware.com>
 <60bd3db2-4919-40c4-a4ff-1b7b043cadfc@email.android.com>
 <53E628FE.10808@vmware.com>
 <53E6E2CE.8070005@gmail.com>
 <53E75192.3070003@vmware.com>
 <53E7B39D.2060900@gmail.com>
 <53E896C9.5010501@vmware.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53E896C9.5010501@vmware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 11, 2014 at 12:11:21PM +0200, Thomas Hellstrom wrote:
> On 08/10/2014 08:02 PM, Mario Kleiner wrote:
> > On 08/10/2014 01:03 PM, Thomas Hellstrom wrote:
> >> On 08/10/2014 05:11 AM, Mario Kleiner wrote:
> >>> Resent this time without HTML formatting which lkml doesn't like.
> >>> Sorry.
> >>>
> >>> On 08/09/2014 03:58 PM, Thomas Hellstrom wrote:
> >>>> On 08/09/2014 03:33 PM, Konrad Rzeszutek Wilk wrote:
> >>>>> On August 9, 2014 1:39:39 AM EDT, Thomas
> >>>>> Hellstrom<thellstrom@vmware.com>  wrote:
> >>>>>> Hi.
> >>>>>>
> >>>>> Hey Thomas!
> >>>>>
> >>>>>> IIRC I don't think the TTM DMA pool allocates coherent pages more
> >>>>>> than
> >>>>>> one page at a time, and _if that's true_ it's pretty unnecessary for
> >>>>>> the
> >>>>>> dma subsystem to route those allocations to CMA. Maybe Konrad could
> >>>>>> shed
> >>>>>> some light over this?
> >>>>> It should allocate in batches and keep them in the TTM DMA pool for
> >>>>> some time to be reused.
> >>>>>
> >>>>> The pages that it gets are in 4kb granularity though.
> >>>> Then I feel inclined to say this is a DMA subsystem bug. Single page
> >>>> allocations shouldn't get routed to CMA.
> >>>>
> >>>> /Thomas
> >>> Yes, seems you're both right. I read through the code a bit more and
> >>> indeed the TTM DMA pool allocates only one page during each
> >>> dma_alloc_coherent() call, so it doesn't need CMA memory. The current
> >>> allocators don't check for single page CMA allocations and therefore
> >>> try to get it from the CMA area anyway, instead of skipping to the
> >>> much cheaper fallback.
> >>>
> >>> So the callers of dma_alloc_from_contiguous() could need that little
> >>> optimization of skipping it if only one page is requested. For
> >>>
> >>> dma_generic_alloc_coherent
> >>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3Ddma_generic_alloc_coherent&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=d1852625e2ab2ff07eb34a7f33fc1f55f7f13959912d5a6ce9316d23070ce939>
> >>>
> >>> andintel_alloc_coherent
> >>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3Dintel_alloc_coherent&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=82d587e9b6aeced5cf9a7caefa91bf47fba809f3522b7379d22e45a2d5d35ebd> 
> >>> this
> >>> seems easy to do. Looking at the arm arch variants, e.g.,
> >>>
> >>> https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/source/arch/arm/mm/dma-mapping.c%23L1194&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=4c178257eab9b5d7ca650dedba76cf27abeb49ddc7aebb9433f52b6c8bb3bbac
> >>>
> >>>
> >>> and
> >>>
> >>> https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/source/arch/arm64/mm/dma-mapping.c%23L44&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=5f62f4cbe8cee1f1dd4cbba656354efe6867bcdc664cf90e9719e2f42a85de08
> >>>
> >>>
> >>> i'm not sure if it is that easily done, as there aren't any fallbacks
> >>> for such a case and the code looks to me as if that's at least
> >>> somewhat intentional.
> >>>
> >>> As far as TTM goes, one quick one-line fix to prevent it from using
> >>> the CMA at least on SWIOTLB, NOMMU and Intel IOMMU (when using the
> >>> above methods) would be to clear the __GFP_WAIT
> >>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3D__GFP_WAIT&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=d56d076770d3416264be6c9ea2829ac0d6951203696fa3ad04144f13307577bc>
> >>> flag from the
> >>> passed gfp_t flags. That would trigger the well working fallback.
> >>> So, is
> >>>
> >>> __GFP_WAIT 
> >>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3D__GFP_WAIT&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=d56d076770d3416264be6c9ea2829ac0d6951203696fa3ad04144f13307577bc> 
> >>> needed
> >>> for those single page allocations that go through__ttm_dma_alloc_page
> >>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3D__ttm_dma_alloc_page&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=7898522bba274e4dcc332735fbcf0c96e48918f60c2ee8e9a3e9c73ab3487bd0>?
> >>>
> >>>
> >>> It would be nice to have such a simple, non-intrusive one-line patch
> >>> that we still could get into 3.17 and then backported to older stable
> >>> kernels to avoid the same desktop hangs there if CMA is enabled. It
> >>> would be also nice for actual users of CMA to not use up lots of CMA
> >>> space for gpu's which don't need it. I think DMA_CMA was introduced
> >>> around 3.12.
> >>>
> >> I don't think that's a good idea. Omitting __GFP_WAIT would cause
> >> unnecessary memory allocation errors on systems under stress.
> >> I think this should be filed as a DMA subsystem kernel bug / regression
> >> and an appropriate solution should be worked out together with the DMA
> >> subsystem maintainers and then backported.
> >
> > Ok, so it is needed. I'll file a bug report.
> >
> >>> The other problem is that probably TTM does not reuse pages from the
> >>> DMA pool. If i trace the __ttm_dma_alloc_page
> >>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3D__ttm_dma_alloc_page&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=7898522bba274e4dcc332735fbcf0c96e48918f60c2ee8e9a3e9c73ab3487bd0>
> >>> and
> >>> __ttm_dma_free_page
> >>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3D__ttm_dma_alloc_page&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=7898522bba274e4dcc332735fbcf0c96e48918f60c2ee8e9a3e9c73ab3487bd0>
> >>> calls for
> >>> those single page allocs/frees, then over a 20 second interval of
> >>> tracing and switching tabs in firefox, scrolling things around etc. i
> >>> find about as many alloc's as i find free's, e.g., 1607 allocs vs.
> >>> 1648 frees.
> >> This is because historically the pools have been designed to keep only
> >> pages with nonstandard caching attributes since changing page caching
> >> attributes have been very slow but the kernel page allocators have been
> >> reasonably fast.
> >>
> >> /Thomas
> >
> > Ok. A bit more ftraceing showed my hang problem case goes through the
> > "if (is_cached)" paths, so the pool doesn't recycle anything and i see
> > it bouncing up and down by 4 pages all the time.
> >
> > But for the non-cached case, which i don't hit with my problem, could
> > one of you look at line 954...
> >
> > https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/source/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c%23L954&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=e15c51805d429ee6d8960d6b88035e9811a1cdbfbf13168eec2fbb2214b99c60
> >
> >
> > ... and tell me why that unconditional npages = count; assignment
> > makes sense? It seems to essentially disable all recycling for the dma
> > pool whenever the pool isn't filled up to/beyond its maximum with free
> > pages? When the pool is filled up, lots of stuff is recycled, but when
> > it is already somewhat below capacity, it gets "punished" by not
> > getting refilled? I'd just like to understand the logic behind that line.
> >
> > thanks,
> > -mario
> 
> I'll happily forward that question to Konrad who wrote the code (or it
> may even stem from the ordinary page pool code which IIRC has Dave
> Airlie / Jerome Glisse as authors)

This is effectively bogus code, i now wonder how it came to stay alive.
Attached patch will fix that.


> 
> /Thomas
>  

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-drm-ttm-fix-object-deallocation-to-properly-fill-in-.patch"
Content-Transfer-Encoding: 8bit

>From f65e796fea5f79e4834f4609147ea06c123d6396 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Date: Mon, 11 Aug 2014 11:10:31 -0400
Subject: [PATCH] drm/ttm: fix object deallocation to properly fill in the page
 pool.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Current code never allowed the page pool to actualy fill in anyway. This fix
it and also allow it to grow over its limit until it grow beyond the batch
size for allocation and deallocation.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index fb8259f..73744cd 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -951,14 +951,9 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
 	} else {
 		pool->npages_free += count;
 		list_splice(&ttm_dma->pages_list, &pool->free_list);
-		npages = count;
-		if (pool->npages_free > _manager->options.max_size) {
+		if (pool->npages_free >= (_manager->options.max_size +
+					  NUM_PAGES_TO_ALLOC))
 			npages = pool->npages_free - _manager->options.max_size;
-			/* free at least NUM_PAGES_TO_ALLOC number of pages
-			 * to reduce calls to set_memory_wb */
-			if (npages < NUM_PAGES_TO_ALLOC)
-				npages = NUM_PAGES_TO_ALLOC;
-		}
 	}
 	spin_unlock_irqrestore(&pool->lock, irq_flags);
 
-- 
1.9.3


--wac7ysb48OaltWcw--
