Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaJWXmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:42:16 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:44322 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJWXmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:42:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 1/4] mm: cma: Don't crash on allocation if CMA area can't be activated
Date: Fri, 24 Oct 2014 02:42:10 +0300
Message-ID: <1463193.4qGZjcvNod@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <xa1tmw8mlobz.fsf@mina86.com>
References: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1414074828-4488-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <xa1tmw8mlobz.fsf@mina86.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Thursday 23 October 2014 18:53:36 Michal Nazarewicz wrote:
> On Thu, Oct 23 2014, Laurent Pinchart wrote:
> > If activation of the CMA area fails its mutex won't be initialized,
> > leading to an oops at allocation time when trying to lock the mutex. Fix
> > this by failing allocation if the area hasn't been successfully actived,
> > and detect that condition by moving the CMA bitmap allocation after page
> > block reservation completion.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Cc: <stable@vger.kernel.org>  # v3.17
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> As a matter of fact, this is present in kernels earlier than 3.17 but in
> the 3.17 the code has been moved from drivers/base/dma-contiguous.c to
> mm/cma.c so this might require separate stable patch.  I can track this
> and prepare a patch if you want.

That could be done, but I'm not sure if it's really worth it. The bug only 
occurs when the CMA zone activation fails. I've ran into that case due to a 
bug introduced in v3.18-rc1, but this shouldn't be the case for older kernel 
versions.

If you think the fix should be backported to stable kernels older than v3.17 
please feel free to cook up a patch.

> > ---
> > 
> >  mm/cma.c | 17 ++++++-----------
> >  1 file changed, 6 insertions(+), 11 deletions(-)
> > 
> > diff --git a/mm/cma.c b/mm/cma.c
> > index 963bc4a..16c6650 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -93,11 +93,6 @@ static int __init cma_activate_area(struct cma *cma)
> >  	unsigned i = cma->count >> pageblock_order;
> >  	struct zone *zone;
> > 
> > -	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> > -
> > -	if (!cma->bitmap)
> > -		return -ENOMEM;
> > -
> >  	WARN_ON_ONCE(!pfn_valid(pfn));
> >  	zone = page_zone(pfn_to_page(pfn));
> > 
> > @@ -114,17 +109,17 @@ static int __init cma_activate_area(struct cma *cma)
> >  			 * to be in the same zone.
> >  			 */
> >  			if (page_zone(pfn_to_page(pfn)) != zone)
> > -				goto err;
> > +				return -EINVAL;
> >  		}
> >  		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
> >  	} while (--i);
> > 
> > +	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> > +	if (!cma->bitmap)
> > +		return -ENOMEM;
> > +
> >  	mutex_init(&cma->lock);
> >  	return 0;
> > -
> > -err:
> > -	kfree(cma->bitmap);
> > -	return -EINVAL;
> >  }
> >  
> >  static int __init cma_init_reserved_areas(void)
> > @@ -313,7 +308,7 @@ struct page *cma_alloc(struct cma *cma, int count,
> > unsigned int align)
> >  	struct page *page = NULL;
> >  	int ret;
> > 
> > -	if (!cma || !cma->count)
> > +	if (!cma || !cma->count || !cma->bitmap)
> >  		return NULL;
> >  	
> >  	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,

-- 
Regards,

Laurent Pinchart

