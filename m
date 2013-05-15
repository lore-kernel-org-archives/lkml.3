Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab3EOT3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:29:44 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59906 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab3EOT3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:29:42 -0400
Date: Wed, 15 May 2013 12:29:38 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Joel Becker <jlbec@evilplan.org>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 21/21] block: Bio cancellation
Message-ID: <20130515192938.GB6338@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-22-git-send-email-koverstreet@google.com>
 <20130515175243.GL4728@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515175243.GL4728@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 07:52:43PM +0200, Jens Axboe wrote:
> On Mon, May 13 2013, Kent Overstreet wrote:
> > If a bio is associated with a kiocb, allow it to be cancelled.
> > 
> > This is accomplished by adding a pointer to a kiocb in struct bio, and
> > when we go to dequeue a request we check if its bio has been cancelled -
> > if so, we end the request with -ECANCELED.
> > 
> > We don't currently try to cancel bios if IO has already been started -
> > that'd require a per bio callback function, and a way to find all the
> > outstanding bios for a given kiocb. Such a mechanism may or may not be
> > added in the future but this patch tries to start simple.
> > 
> > Currently this can only be triggered with aio and io_cancel(), but the
> > mechanism can be used for sync io too.
> > 
> > It can also be used for bios created by stacking drivers, and bio clones
> > in general - when cloning a bio, if the bi_iocb pointer is copied as
> > well the clone will then be cancellable. bio_clone() could be modified
> > to do this, but hasn't in this patch because all the bio_clone() users
> > would need to be auditied to make sure that it's safe. We can't blindly
> > make e.g. raid5 writes cancellable without the knowledge of the md code.
> 
> This is a pretty ugly hack, to be honest. It only works for aio. And it
> grows struct bio just for that.

It's only implemented for aio in this patch but it's actually completely
trivial to extend to sync kiocbs too - we can make killing a process
cancel outstanding sync DIOs, I just haven't gotten around to writing
the code. With sync kiocbs anything can use it.

I do hate to grow struct bio, but the aio attribute stuff I'm also
working on is going to need the same damn thing.

> I do like the staged approach, where we just check whether a bio is
> canceled when we come across it in the various parts of bio allocate to
> completion.

Yeah, that's the only sane way to do it imo. If we had to do it with the
ki_cancel callback, since bios -> kiocbs isn't 1:1 we'd have to keep all
the outstanding bios on a list protected by a lock so we could chase
down all the bios we need to cancel, and I don't even want to think
about stacking devices...

This is also trivial to plumb through stacking devices, for ones that
want to support it - md for example probably wouldn't want to support
cancellation for writes (raid consistency) but for reads all it has to
do is copy the kiocb pointer to the new bios it creates.

(I keep having people tell me we're (Google) going to need cancel for
outstanding NCQ/TCQ requests, to which my response has been "LALALALA GO
AWAY I CAN'T HEAR YOU").

> > @@ -2124,6 +2130,12 @@ struct request *blk_peek_request(struct request_queue *q)
> >  			trace_block_rq_issue(q, rq);
> >  		}
> >  
> > +		if (rq->bio && !rq->bio->bi_next && bio_cancelled(rq->bio)) {
> > +			blk_start_request(rq);
> > +			__blk_end_request_all(rq, -ECANCELED);
> > +			continue;
> > +		}
> 
> Pretty hacky too, given that it only works for the generic case of a
> non-merged bio.

More incomplete than hacky, imo - since with spinning disks you wouldn't
save much by cancelling one bio out of a merged request. It would make
sense to cancel the request if all the bios have been cancelled, but
wanted to start out simple and get something useful with a minimal
amount of code.

Anyways, this patch is still more at the RFC stage but there is serious
demand for cancellation (I've seen what people are using it for, it's
not all crazy and the lack of it is something people are working around
today, painfully).
