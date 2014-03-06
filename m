Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaCFUad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:30:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36068 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaCFUac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:30:32 -0500
Date: Thu, 6 Mar 2014 20:30:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 1/5][RFC][CFT] percpu fixes, part 1
Message-ID: <20140306203030.GA18016@ZenIV.linux.org.uk>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
 <20140305034919.GA26528@ZenIV.linux.org.uk>
 <20140306192026.GA14033@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306192026.GA14033@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 02:20:26PM -0500, Tejun Heo wrote:

> Can you please add why this change is necessary to the description?

OK, will do...

> Also, I think it'd be better to split addition of first_free hint to a
> separate patch.

OK, but I'm not sure how much does it simplify things, actually.
 
> > +		chunk->map[++i] = off += size;
> >  }
> 
> Do we need to pass @size in the above function?  Isn't that something
> which can be easily determined?  If @size is gonna stay, we'll need to
> update the function comment too.

It's folded into the caller in the next patch.

> > @@ -483,19 +483,27 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
> >  	int oslot = pcpu_chunk_slot(chunk);
> >  	int max_contig = 0;
> >  	int i, off;
> > +	int seen_free = 0;
> 
> bool

Umm...  Matter of taste, but OK, I'll do that.

> > @@ -570,34 +584,50 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
> >  static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
> >  {
> >  	int oslot = pcpu_chunk_slot(chunk);
> > -	int i, off;
> > -
> > -	for (i = 0, off = 0; i < chunk->map_used; off += abs(chunk->map[i++]))
> > -		if (off == freeme)
> > -			break;
> > +	int off = 0;
> > +	unsigned i, j;
> > +	int to_free = 0;
> > +	int *p;
> > +
> > +	freeme |= 1;
> > +
> > +	i = 0;
> > +	j = chunk->map_used;
> > +	while (i != j) {
> > +		unsigned k = (i + j) / 2;
> > +		off = chunk->map[k];
> > +		if (off < freeme)
> > +			i = k + 1;
> > +		else if (off > freeme)
> > +			j = k;
> > +		else
> > +			i = j = k;
> > +	}
> >  	BUG_ON(off != freeme);
> > -	BUG_ON(chunk->map[i] > 0);
> 
> A comment explaining why ignoring the free bit during bin search is
> okay would be nice?

Huh?  We are not ignoring it - we are searching for exact value, including
the lower bit being set.  It might be worth adding a comment next to
"freeme |= 1;" before the loop, but that's it.  These two BUG_ON() fold
nicely - that's one of the reasons why I prefer to keep the offset of
area and is_free flag of the same area in one array element.  That's why
I prefer to have the first element of array to be <0,false> or <0,true>,
and add <total_size, true> as the sentry in the end.  Sure, we could
keep <offset of the next, is this one free> together instead, and make
that array one element shorter, but that way we get more complex logics,
including that search in freeing...

> > +	if (unlikely(align < 2))
> > +		align = 2;
> 
> Please add a comment explaining why the above min alignment is
> necessary.

Umm...  Will "we want the lowest bit of offset available for free/in_use
indicator" do?
