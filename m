Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3KEVov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:44:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3KEVou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:44:50 -0500
Date: Tue, 5 Nov 2013 13:44:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: zhang.mingjun@linaro.org, minchan@kernel.org, m.szyprowski@samsung.com,
        haojian.zhuang@linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Mingjun Zhang <troy.zhangmingjun@linaro.org>
Subject: Re: [PATCH] mm: cma: free cma page to buddy instead of being cpu
 hot page
Message-Id: <20131105134448.7677d6febbfff4721373be4b@linux-foundation.org>
In-Reply-To: <20131029093322.GA2400@suse.de>
References: <1382960569-6564-1-git-send-email-zhang.mingjun@linaro.org>
	<20131029093322.GA2400@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013 09:33:23 +0000 Mel Gorman <mgorman@suse.de> wrote:

> On Mon, Oct 28, 2013 at 07:42:49PM +0800, zhang.mingjun@linaro.org wrote:
> > From: Mingjun Zhang <troy.zhangmingjun@linaro.org>
> > 
> > free_contig_range frees cma pages one by one and MIGRATE_CMA pages will be
> > used as MIGRATE_MOVEABLE pages in the pcp list, it causes unnecessary
> > migration action when these pages reused by CMA.
> > 
> > Signed-off-by: Mingjun Zhang <troy.zhangmingjun@linaro.org>
> > ---
> >  mm/page_alloc.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 0ee638f..84b9d84 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1362,7 +1362,8 @@ void free_hot_cold_page(struct page *page, int cold)
> >  	 * excessively into the page allocator
> >  	 */
> >  	if (migratetype >= MIGRATE_PCPTYPES) {
> > -		if (unlikely(is_migrate_isolate(migratetype))) {
> > +		if (unlikely(is_migrate_isolate(migratetype))
> > +			|| is_migrate_cma(migratetype))
> >  			free_one_page(zone, page, 0, migratetype);
> >  			goto out;
> 
> This slightly impacts the page allocator free path for a marginal gain
> on CMA which are relatively rare allocations. There is no obvious
> benefit to this patch as I expect CMA allocations to flush the PCP lists
> when a range of pages have been isolated and migrated. Is there any
> measurable benefit to this patch?

The added overhead is pretty small - just a comparison of a local with
a constant.  And that cost is not incurred for MIGRATE_UNMOVABLE,
MIGRATE_RECLAIMABLE and MIGRATE_MOVABLE, which are the common cases
(yes?).

This thread is a bit straggly and inconclusive, but it sounds to me
that the benefit to CMA users is quite large and the cost to others is
small, so I'm inclined to run with the original patch.  Someone stop me
if that's wrong.

(we could speed up some of the migratetype tests if the MIGRATE_foo
constants were converted to bitfields.  The above test becomes "if
(migratetype & (MIGRATE_CMA|MIGRATE_ISOLATE))").

(why is is_migrate_cma() implemented as a macro in mmzone.h while
is_migrate_isolate() is an inline in page-isolation.h?)

