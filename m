Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaEUUMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:12:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaEUUL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:11:59 -0400
Date: Wed, 21 May 2014 13:11:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2] mm, compaction: properly signal and act upon lock
 and need_sched() contention
Message-Id: <20140521131157.3a092c5f9d8b6b5d467f8928@linux-foundation.org>
In-Reply-To: <537CB493.9090706@suse.cz>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz>
	<1400233673-11477-1-git-send-email-vbabka@suse.cz>
	<20140519163741.55998ce65534ed73d913ee2c@linux-foundation.org>
	<537CB493.9090706@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 16:13:39 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> >>
> >> ...
> >>
> >> @@ -718,9 +739,11 @@ static void isolate_freepages(struct zone *zone,
> >>   		/*
> >>   		 * This can iterate a massively long zone without finding any
> >>   		 * suitable migration targets, so periodically check if we need
> >> -		 * to schedule.
> >> +		 * to schedule, or even abort async compaction.
> >>   		 */
> >> -		cond_resched();
> >> +		if (!(block_start_pfn % (SWAP_CLUSTER_MAX * pageblock_nr_pages))
> >> +						&& compact_should_abort(cc))
> > 
> > This seems rather gratuitously inefficient and isn't terribly clear.
> > What's wrong with
> > 
> > 	if ((++foo % SWAP_CLUSTER_MAX) == 0 && compact_should_abort(cc))
> 
> It's a new variable and it differs from how isolate_migratepages_range() does this.
> But yeah, I might change it later there as well. There it makes even more sense.
> E.g. when skipping whole pageblock there, pfn % SWAP_CLUSTER_MAX will be always zero
> so the periodicity varies.
>  
> > ?
> > 
> > (Assumes that SWAP_CLUSTER_MAX is power-of-2 and that the compiler will
> > use &)
>  
> I hoped that compiler would be smart enough about SWAP_CLUSTER_MAX * pageblock_nr_pages
> as well, as those are constants and also power-of-2. But I didn't check the assembly.

Always check the assembly!  Just a quick `size mm/compaction.o' is
enough tell if you're on the right track.

> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -779,6 +779,7 @@ static void isolate_freepages(struct zone *zone,
>  	unsigned long block_start_pfn;	/* start of current pageblock */
>  	unsigned long block_end_pfn;	/* end of current pageblock */
>  	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
> +	unsigned long nr_blocks_scanned = 0; /* for periodical abort checks */
>  	int nr_freepages = cc->nr_freepages;
>  	struct list_head *freelist = &cc->freepages;
>  
> @@ -813,7 +814,7 @@ static void isolate_freepages(struct zone *zone,
>  		 * suitable migration targets, so periodically check if we need
>  		 * to schedule, or even abort async compaction.
>  		 */
> -		if (!(block_start_pfn % (SWAP_CLUSTER_MAX * pageblock_nr_pages))
> +		if ((++nr_blocks_scanned % SWAP_CLUSTER_MAX) == 0
>  						&& compact_should_abort(cc))
>  			break;

This change actually makes the code worse, and the .o file gets larger.

For some stupid reason we went and make pageblock_nr_pages all lower
case but surprise surprise, it's actually a literal constant.  So the
compiler does the multiplication at compile time and converts the
modulus operation into a bitwise AND.  Duh.

