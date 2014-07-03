Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbaGCTQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:16:15 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58744 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbaGCTQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:16:04 -0400
Date: Thu, 3 Jul 2014 12:14:31 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Vlastimil Babka <vbabka@suse.cz>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] shmem: fix faulting into a hole while it's punched,
 take 2
In-Reply-To: <53B578BC.4050300@suse.cz>
Message-ID: <alpine.LSU.2.11.1407031202340.1370@eggly.anvils>
References: <alpine.LSU.2.11.1407021204180.12131@eggly.anvils> <alpine.LSU.2.11.1407021209570.12131@eggly.anvils> <53B578BC.4050300@suse.cz>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014, Vlastimil Babka wrote:
> On 07/02/2014 09:11 PM, Hugh Dickins wrote:
> > 
> > --- 3.16-rc3+/mm/shmem.c	2014-07-02 03:31:12.956546569 -0700
> > +++ linux/mm/shmem.c	2014-07-02 03:34:13.172550852 -0700
> > @@ -467,23 +467,20 @@ static void shmem_undo_range(struct inod
> >   		return;
> > 
> >   	index = start;
> > -	for ( ; ; ) {
> > +	while (index < end) {
> >   		cond_resched();
> > 
> >   		pvec.nr = find_get_entries(mapping, index,
> >   				min(end - index, (pgoff_t)PAGEVEC_SIZE),
> >   				pvec.pages, indices);
> >   		if (!pvec.nr) {
> > -			if (index == start || unfalloc)
> > +			/* If all gone or hole-punch or unfalloc, we're done
> > */
> > +			if (index == start || end != -1)
> >   				break;
> > +			/* But if truncating, restart to make sure all gone
> > */
> >   			index = start;
> >   			continue;
> >   		}
> > -		if ((index == start || unfalloc) && indices[0] >= end) {
> > -			pagevec_remove_exceptionals(&pvec);
> > -			pagevec_release(&pvec);
> > -			break;
> > -		}
> >   		mem_cgroup_uncharge_start();
> >   		for (i = 0; i < pagevec_count(&pvec); i++) {
> >   			struct page *page = pvec.pages[i];
> > @@ -495,8 +492,12 @@ static void shmem_undo_range(struct inod
> >   			if (radix_tree_exceptional_entry(page)) {
> >   				if (unfalloc)
> >   					continue;
> > -				nr_swaps_freed += !shmem_free_swap(mapping,
> > -								index, page);
> > +				if (shmem_free_swap(mapping, index, page)) {
> > +					/* Swap was replaced by page: retry
> > */
> > +					index--;
> > +					break;
> > +				}
> > +				nr_swaps_freed++;
> >   				continue;
> 
> Ugh, a warning to anyone trying to backport this. This hunk can match both
> instances of the same code in the function, and I've just seen patch picking
> the wrong one.

Thanks for the warning.

Yes, as it ends up, there are only two hunks: so if the first fails
to apply (and down the releases there may be various trivial reasons
why it would fail to apply cleanly, although easily edited by hand),
patch might very well choose the first match to apply the second hunk.

I'm expecting to have to do (or at least to check) each -stable by
hand as it comes by.  I did just check mmotm, and it came out fine.

Hugh
