Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbaGNUhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:37:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbaGNUhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:37:16 -0400
Date: Mon, 14 Jul 2014 13:37:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, Gioh Kim <gioh.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?=EC=9D=B4=EA=B1=B4=ED=98=B8?= <gunho.lee@lge.com>,
        Gi-Oh Kim <gurugio@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
Message-Id: <20140714133714.343ff0be6ea2bae651dc6f57@linux-foundation.org>
In-Reply-To: <20140714070225.GE11317@js1304-P5Q-DELUXE>
References: <53B664E5.5060102@lge.com>
	<20140707155252.15e81dff6683393ba3590478@linux-foundation.org>
	<xa1tpphf4x3s.fsf@mina86.com>
	<20140714070225.GE11317@js1304-P5Q-DELUXE>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 16:02:25 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> On Tue, Jul 08, 2014 at 06:46:31PM +0200, Michal Nazarewicz wrote:
> > On Mon, Jul 07 2014, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > What I proposed is that CMA call invalidate_bh_lrus() right at the
> > > outset.  Something along the lines of
> > >
> > > --- a/mm/page_alloc.c~a
> > > +++ a/mm/page_alloc.c
> > > @@ -6329,6 +6329,14 @@ int alloc_contig_range(unsigned long sta
> > >  	};
> > >  	INIT_LIST_HEAD(&cc.migratepages);
> > >  
> > > +#ifdef CONFIG_CMA
> > > +	/*
> > > +	 * Comment goes here
> > > +	 */
> > > +	if (migratetype == MIGRATE_CMA)
> > > +		invalidate_bh_lrus();
> > > +#endif
> > > +
> > 
> > This seems reasonable, except I think it should go after
> > start_isolate_page_range call because otherwise there's no guarantee
> > that someone won't grab those pages back.
> > 
> > Also to avoid the #ifdef perhaps we want this as well:
> 
> I think that we just want to remove ifdef CONFIG_CMA on above code
> snippet, because invalidate_bh_lrus() would also help user of
> alloc_contig_range() with MIGRATE_MOVABLE.

That's what I believe also.  I pinged Mel and Johannes off-list and Mel
said "I hit it, the invalidation cost wasn't worth it for a THP alloc".

So hm.  I do think it's worth additional investigation but some careful
testing would be needed to demonstrate that it's worthwhile.  If the
invalidation cost is hurting then perhaps additional logic will be
needed to perform the invalidation only as a last-resort thing.


