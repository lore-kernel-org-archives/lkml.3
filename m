Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab3C0RBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:01:50 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53113 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab3C0RBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:01:49 -0400
Date: Wed, 27 Mar 2013 10:01:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/6] idr: introduce idr_alloc_cyclic
Message-ID: <20130327170135.GD7395@htj.dyndns.org>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
 <1364390288-30968-2-git-send-email-jlayton@redhat.com>
 <20130327162553.GB7395@htj.dyndns.org>
 <20130327124804.3ceef49a@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327124804.3ceef49a@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 27, 2013 at 12:48:04PM -0400, Jeff Layton wrote:
> > > + * Note that people using cyclic allocation to avoid premature reuse of an
> > > + * already-used ID may be in for a nasty surprise after idr->cur wraps. The
> > > + * IDR code is designed to avoid unnecessary allocations. If there is space
> > > + * in an existing layer that holds high IDs then it will return one of those
> > > + * instead of allocating a new layer at the bottom of the range.
> > 
> > Ooh, does it?  Where?
> > 
> 
> That's what I gathered from looking at idr_get_empty_slot. I could be
> wrong here, so please correct me if I am. The IDR internals are really
> hard to follow...

Amen, it's horrible.

> In any case, it looks like it only tries to allocate a new layer if:
> 
> idr->top is empty
> 
> ...or...
> 
> while (id > idr_max(layers)) {
> ...
> }
>
> After the wrap, idr->top won't be empty if we have at least one layer
> still in use. We start with id = starting_id, which after wrap will be
> much lower than idr_max() at that point (right?).
> 
> So we'll skip the while loop and fall right into sub_alloc and will
> quite possibly end up allocating a slot out of the current layer, which
> is almost certainly not near the bottom of the range.
> 
> Again, I'm far from sure of my understanding of the internals here, so
> please do correct me if that's not right...

So, there are two paths which do layer allocation.
idr_get_empty_slot() does bottom -> top expansion.  ie. it grows the
tree if the current position can't be covered by the current tree.
Note that the tree can always point to zero.  That is, the first slot
of the top layer always includes zero.

The other part - building tree top -> bottom - happens in sub_alloc()
which traverses the tree downwards for the current position and
creates new idr_layer if it doesn't exist.

So, after wrap, the tree is already tall enough so
idr_get_empty_slot() will just call into sub_alloc() which will build
the tree downwards.  AFAICS, it does guarantee lowest-packing.

Thanks.

-- 
tejun
