Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3A1EOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:14:23 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:62782 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab3A1EOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:14:21 -0500
Date: Sun, 27 Jan 2013 20:14:22 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Simon Jeons <simon.jeons@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/11] ksm: remove old stable nodes more thoroughly
In-Reply-To: <1359337321.6763.18.camel@kernel>
Message-ID: <alpine.LNX.2.00.1301271945300.896@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251800550.29196@eggly.anvils> <1359262556.4159.23.camel@kernel> <alpine.LNX.2.00.1301271451130.17495@eggly.anvils> <1359337321.6763.18.camel@kernel>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013, Simon Jeons wrote:
> On Sun, 2013-01-27 at 15:05 -0800, Hugh Dickins wrote:
> > On Sat, 26 Jan 2013, Simon Jeons wrote:
> > > > How can this happen?  We only permit switching merge_across_nodes when
> > > > pages_shared is 0, and usually set run 2 to force that beforehand, which
> > > > ought to unmerge everything: yet oopses still occur when you then run 1.
> > > > 
> > > > Three causes:
> > > > 
> > > > 1. The old stable tree (built according to the inverse merge_across_nodes)
>                                                    ^^^^^^^^^^^^^^^^^^^^^
> How to understand inverse merge_across_nodes here?

How not to understand it?  Either it was 0 before (in which case there
were as many stable trees as NUMA nodes) and is being changed to 1 (in
which case there is to be only one stable tree), or it was 1 before
(for one) and is being changed to 0 (for many).

> 
> > > > has not been fully torn down.  A stable node lingers until get_ksm_page()
> > > > notices that the page it references no longer references it: but the page
> 
> Do you mean page->mapping is NULL when call get_ksm_page()? Who clear it
> NULL?

I think I already pointed you to free_pages_prepare().

> 
> > > > is not necessarily freed as soon as expected, particularly when swapcache.
> 
> Why is not necessarily freed as soon as expected?

As I answered below.

> > > > 
> > > 
> > > When can this happen?  
> > 
> > Whenever there's an additional reference to the page, beyond those for
> > its ptes in userspace - swapcache for example, or pinned by get_user_pages.
> > That delays its being freed (arriving at the "page->mapping = NULL;"
> > in free_pages_prepare()).  Or it might simply be sitting in a pagevec,
> > waiting for that to be filled up, to be freed as part of a batch.

> > > mms forked will be unmerged just after ksmd's cursor since they're
> > > inserted behind it, why will be missing?
> > 
> > unmerge_and_remove_all_rmap_items() makes one pass through the list
> > from start to finish: insert behind the cursor and it will be missed.
> 
> Since mms forked will be insert just after ksmd's cursor, so it is the
> next which will be scan and unmerge, where I miss?

mms forked are normally inserted just behind (== before) ksmd's cursor,
as I've said in comments and explanations several times.

Simon, I've had enough: you clearly have much more time to spare for
asking questions than I have for answering them repeatedly: I would
rather spend my time attending to 100 higher priorities.

Please try much harder to work these things out for yourself from the
source (perhaps with help from kernelnewbies.org), before interrogating
linux-kernel and linux-mm developers.  Sometimes your questions may
help everybody to understand better, but often they just waste our time.

I'll happily admit that mm, and mm/ksm.c in particular, is not the easiest
place to start in understanding the kernel, nor I the best expositor.

Best wishes,
Hugh
