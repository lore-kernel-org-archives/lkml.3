Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaGZXRL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 19:17:11 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57183 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaGZXRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 19:17:10 -0400
Date: Sat, 26 Jul 2014 16:15:25 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Vlastimil Babka <vbabka@suse.cz>
cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>,
        Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix direct reclaim writeback regression
In-Reply-To: <53D42F80.7000000@suse.cz>
Message-ID: <alpine.LSU.2.11.1407261600570.14577@eggly.anvils>
References: <alpine.LSU.2.11.1407261248140.13796@eggly.anvils> <53D42F80.7000000@suse.cz>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2014, Vlastimil Babka wrote:
> On 07/26/2014 09:58 PM, Hugh Dickins wrote:
> > Yes, 3.16-rc1's 68711a746345 ("mm, migration: add destination page
> > freeing callback") has provided such a way to compaction: if migrating
> > a SwapBacked page fails, its newpage may be put back on the list for
> > later use with PageSwapBacked still set, and nothing will clear it.
> 
> Ugh good catch. So is this the only flag that can become "stray" like
> this? It seems so from quick check...

Yes, it seemed so to me too; but I would prefer a regime in which
we only mess with newpage once it's sure to be successful.

> > --- 3.16-rc6/mm/migrate.c	2014-06-29 15:22:10.584003935 -0700
> > +++ linux/mm/migrate.c	2014-07-26 11:28:34.488126591 -0700
> > @@ -988,9 +988,10 @@ out:
> >  	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
> >  	 * during isolation.
> >  	 */
> > -	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
> > +	if (rc != MIGRATEPAGE_SUCCESS && put_new_page) {
> > +		ClearPageSwapBacked(newpage);
> >  		put_new_page(newpage, private);
> > -	else
> > +	} else
> >  		putback_lru_page(newpage);
> >  
> >  	if (result) {
> 
> What about unmap_and_move_huge_page()? Seems to me it can also get the
> same stray flag. Although compaction, who is the only user so far of
> custom put_new_page, wouldn't of course migrate huge pages. But might
> bite us in the future, if a new user appears before a cleanup...

I think you're right, thanks for pointing it out.  We don't have an
actual bug there at present, so no need to rush back and fix up the
patch now in Linus's tree; but unmap_and_move_huge_page() gives
another reason why my choice was "probably the worst place to fix it".

More reason for a cleanup, but not while the memcg interface is in flux.
In mmotm I'm a little anxious about the PageAnon case when newpage's
mapping is left set, I wonder if that might also be problematic: I
mailed Hannes privately to think about that - perhaps that will give
more impulse for a cleanup, though I've not noticed any bug from it.

Hugh
