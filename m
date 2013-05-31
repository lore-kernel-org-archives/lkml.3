Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab3EaWwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:52:23 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61038 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3EaWwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:52:13 -0400
Date: Fri, 31 May 2013 15:52:10 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Joel Becker <jlbec@evilplan.org>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 21/21] block: Bio cancellation
Message-ID: <20130531225210.GI2291@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-22-git-send-email-koverstreet@google.com>
 <20130515175243.GL4728@kernel.dk>
 <20130515192938.GB6338@google.com>
 <20130515200122.GO4728@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515200122.GO4728@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:01:22PM +0200, Jens Axboe wrote:
> On Wed, May 15 2013, Kent Overstreet wrote:
> > It's only implemented for aio in this patch but it's actually completely
> > trivial to extend to sync kiocbs too - we can make killing a process
> > cancel outstanding sync DIOs, I just haven't gotten around to writing
> > the code. With sync kiocbs anything can use it.
> 
> Oh, that wasn't even my point. It only works for iocb "backed" bios was
> my point. You would ideally like cancel for other areas as well. One
> that comes to mind is truncating files, for instance.

Sorry, I was unclear - the point was, there's nothing special about
kiocbs - if some random code (truncate related, say) wants to be able to
cancel some bios, it would just stick a kiocb somewhere (on the stack,
or wherever) and point the bios at that - the kiocb would be used for
cancellation and nothing else. All the code has to do is make sure the
kiocb can't be freed until the bios return, naturally.

If we decide struct kiocb is too big/ugly to use it this way we could
easily abstract out a "struct cancel" or something that's smaller,
though since kiocbs are already somewhat generic (see the way sync
kiocbs are used) I don't think it matters that much.

As part of the aio stuff I've been pruning struct kiocb as much as I
can, so this type of usage will make more sense and struct kiocb will be
~70 bytes instead of > 200.

> > I do hate to grow struct bio, but the aio attribute stuff I'm also
> > working on is going to need the same damn thing.
> 
> If you (you being aio here) wants to support cancel, then why not just
> stuff it into bi_private?

Core block layer code (i.e. where we check if a bio/request has been
cancelled) can't depend on bi_private pointing to anything in
particular, that'd be a massive change.

_Arguably_ the right thing to do would be to, instead of having a void
bi_private pointer, have a pointer to a "struct bio_state" or somesuch -
and the owner of the bio would then embed struct bio_state into whatever
bi_private currently points to.

But that'd be a pretty massive change and I'm not sure it's the correct
approach.

> > Yeah, that's the only sane way to do it imo. If we had to do it with the
> > ki_cancel callback, since bios -> kiocbs isn't 1:1 we'd have to keep all
> > the outstanding bios on a list protected by a lock so we could chase
> > down all the bios we need to cancel, and I don't even want to think
> > about stacking devices...
> 
> Perfection is the enemy of good. Doing tracking across the full stack is
> just going to be insane, just don't do it...

Completely agree, was just explaining how insane it'd be :P

> > > Pretty hacky too, given that it only works for the generic case of a
> > > non-merged bio.
> > 
> > More incomplete than hacky, imo - since with spinning disks you wouldn't
> > save much by cancelling one bio out of a merged request. It would make
> > sense to cancel the request if all the bios have been cancelled, but
> > wanted to start out simple and get something useful with a minimal
> > amount of code.
> > 
> > Anyways, this patch is still more at the RFC stage but there is serious
> > demand for cancellation (I've seen what people are using it for, it's
> > not all crazy and the lack of it is something people are working around
> > today, painfully).
> 
> I'd be willing to entertain the idea, if the implementation is low
> enough overhead and makes sense. So not completely nacking the idea, I'd
> just prefer to see something a bit more baked.

Besides adding a real request_cancelled() function, I'm not sure what
else there is to flesh out at this time - anything else I can think of
adding should IMO wait until there's real use for it.

One thing I wasn't sure about was whether blk_peek_request() was the
right place to check if the request has been cancelled - I don't know
the request queue side of things all that well. Any opinion there?
