Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaKTNLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:11:24 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:59000 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaKTNLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:11:22 -0500
Date: Thu, 20 Nov 2014 08:11:18 -0500
From: Tejun Heo <tj@kernel.org>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 2/2] {block|char}_dev: remove inode->i_devices
Message-ID: <20141120131118.GB14877@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
 <20141113221139.GG2598@htj.dyndns.org>
 <546DC5AD.3040606@plexistor.com>
 <20141120115052.GA32237@htj.dyndns.org>
 <546DE065.3090502@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546DE065.3090502@plexistor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

On Thu, Nov 20, 2014 at 02:36:53PM +0200, Boaz Harrosh wrote:
>   Actually with my proposed change to "the code you submitted here"
>   there are *less* unnecessary allocations. In both our imp we have a
>   waste when element already exist in the tree, and your imp already
>   waists an allocation in every pset_preload()
> 
>   And again you are talking about a future undefined "what if", let
>   us look at the very sound imp you proposed here with rbtree and
>   do the best we can with that one.

Preloading is an established pattern and a pretty effective one at
that.  It allows its users to not worry about carrying the state
explicitly while allowing the preloaded allocation to be cached across
multiple insertions.

Whether ptrset needs it or not is debatable.  If it didn't need to be
shared between block and chardevs, I prolly would have just open coded
it with linked list.  But being a generic library feature which isn't
too different from other memory allocating indexing data structures, I
think it'd be better to follow the established pattern rather than
creating another one-off behavior.  If we demote this to something
which is shared only between block and char devs, we can go simpler
and less versatile.  Where should it go tho?

>   Again Theoretical. With your current code the only failing I see
>   from add() is allocation, so with my imp it will never fail. One
>   thing good with embedded list_heads is the void returning add.
>   And so with my proposition: void returning add.

Sure, if you look at just these two instances.  We can just require
preloading and drop @gfp from the insertion function too.  -EEXIST can
be avoided too, so let's drop the return value entirely.

Again, the problem is that it's implemented as a generic lib feature,
so it needs to consider how different use cases can be served and we
have an established pattern which proved to be effective over time for
these types of data structures and that's the pattern being followed
here.

>   When some new imp will be needed we can cross the bridge then.
> 
>   For now you have convinced me that an rbtree is good, and I want to
>   solve the preemption-disable, none interrupt ugliness, per-cpu vars,
>   as well as the double alloc in the normal lots-of-free-memory case.

It's a reserve which is kept around, one per CPU at most, which also
allows us to avoid spurious frees on insertion attempts which don't
consume the reserve.  If your point is that we don't need ptrset as a
generic lib thing, this can definitely be simpler but otherwise I'm
not sure what you're arguing.  We have an established pattern to make
prealloactions easier for generic lib functions.  Why wouldn't we use
that and make things simpler for its users?

> > so
> > overall it seems better to defer the allocation error to the actual
> > insertion point.  
> 
> That one I did not understand.

So, w/o preloading, you would do,

	error = insert();
	if (error)
		handle error;

W/ preloading, one way to do it is,

	if (preload())
		handle -ENOMEM;
	lock;
	error = insert();
	if (error)
		handle error which can't be -ENOMEM;
	unlock;
	preload_end();

Another way is

	preload();	// can't fail
	lock;
	error = insert();
	if (error)
		handle error;'
	unlock;
	preload_end();

Both ways have pros and cons.  The latter seems to lead to simpler
code in general.  Not always, but the overall.

> > It also makes conceptual sense.  The preloading
> > simply upgrades the allocation mask the insertion operation uses.
> 
> How is "upgrades", better then "always have the best mask"

Hah?  What are you talking about?  So,

	preload(GFP_KERNEL);
	lock;
	insert(GFP_NOWAIT);
	unlock;
	preload_end();

can be considered as insert() allocating memory using GFP_KERNEL.
That's what preallocation does.  My point was that deferring
allocation error to insert() time allows considering the above code
like the following.

	lock;
	insert(GFP_KERNEL);
	unlock;

And that's why the pattern usually leads to simpler code - it doesn't
create a new failure point.

Thanks.

-- 
tejun
