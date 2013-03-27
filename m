Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3C0QsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:48:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab3C0QsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:48:12 -0400
Date: Wed, 27 Mar 2013 12:48:04 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/6] idr: introduce idr_alloc_cyclic
Message-ID: <20130327124804.3ceef49a@tlielax.poochiereds.net>
In-Reply-To: <20130327162553.GB7395@htj.dyndns.org>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
	<1364390288-30968-2-git-send-email-jlayton@redhat.com>
	<20130327162553.GB7395@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013 09:25:53 -0700
Tejun Heo <tj@kernel.org> wrote:

> Hello, Jeff.
> 
> On Wed, Mar 27, 2013 at 09:18:03AM -0400, Jeff Layton wrote:
> > + * Note that people using cyclic allocation to avoid premature reuse of an
> > + * already-used ID may be in for a nasty surprise after idr->cur wraps. The
> > + * IDR code is designed to avoid unnecessary allocations. If there is space
> > + * in an existing layer that holds high IDs then it will return one of those
> > + * instead of allocating a new layer at the bottom of the range.
> 
> Ooh, does it?  Where?
> 

That's what I gathered from looking at idr_get_empty_slot. I could be
wrong here, so please correct me if I am. The IDR internals are really
hard to follow...

In any case, it looks like it only tries to allocate a new layer if:

idr->top is empty

...or...

while (id > idr_max(layers)) {
...
}

After the wrap, idr->top won't be empty if we have at least one layer
still in use. We start with id = starting_id, which after wrap will be
much lower than idr_max() at that point (right?).

So we'll skip the while loop and fall right into sub_alloc and will
quite possibly end up allocating a slot out of the current layer, which
is almost certainly not near the bottom of the range.

Again, I'm far from sure of my understanding of the internals here, so
please do correct me if that's not right...

> > +int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end,
> > +			gfp_t gfp_mask)
> > +{
> > +	int id;
> > +	int cur = idr->cur;
> > +
> > +	if (unlikely(start > cur))
> > +		cur = start;
> > +
> > +	id = idr_alloc(idr, ptr, cur, end, gfp_mask);
> 
> Would max(id->cur, start) be easier to follow?
> 

Sure. I also noticed that the kerneldoc has an extra parm in it, so I
need to fix that too.

> > +	if (id == -ENOSPC)
> > +		id = idr_alloc(idr, ptr, start, end, gfp_mask);
> > +
> > +	if (likely(id >= 0))
> > +		idr->cur = id + 1;
> 
> If @id is INT_MAX, idr->cur will be -1 which is okay as start > cur
> test above will correct it on the next iteration but maybe we can do
> idr->cur = max(id + 1, 0); for clarity?
> 

We could, but that means we'll have to evaluate that max() on every
call into here. I think it's more efficient overall to just do the
retry when we hit INT_MAX since that should be pretty rare.

-- 
Jeff Layton <jlayton@redhat.com>
