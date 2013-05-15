Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab3EORwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:52:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38799 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759743Ab3EORwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:52:51 -0400
Date: Wed, 15 May 2013 19:52:43 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Joel Becker <jlbec@evilplan.org>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 21/21] block: Bio cancellation
Message-ID: <20130515175243.GL4728@kernel.dk>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-22-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368494338-7069-22-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13 2013, Kent Overstreet wrote:
> If a bio is associated with a kiocb, allow it to be cancelled.
> 
> This is accomplished by adding a pointer to a kiocb in struct bio, and
> when we go to dequeue a request we check if its bio has been cancelled -
> if so, we end the request with -ECANCELED.
> 
> We don't currently try to cancel bios if IO has already been started -
> that'd require a per bio callback function, and a way to find all the
> outstanding bios for a given kiocb. Such a mechanism may or may not be
> added in the future but this patch tries to start simple.
> 
> Currently this can only be triggered with aio and io_cancel(), but the
> mechanism can be used for sync io too.
> 
> It can also be used for bios created by stacking drivers, and bio clones
> in general - when cloning a bio, if the bi_iocb pointer is copied as
> well the clone will then be cancellable. bio_clone() could be modified
> to do this, but hasn't in this patch because all the bio_clone() users
> would need to be auditied to make sure that it's safe. We can't blindly
> make e.g. raid5 writes cancellable without the knowledge of the md code.

This is a pretty ugly hack, to be honest. It only works for aio. And it
grows struct bio just for that.

I do like the staged approach, where we just check whether a bio is
canceled when we come across it in the various parts of bio allocate to
completion.

> @@ -2124,6 +2130,12 @@ struct request *blk_peek_request(struct request_queue *q)
>  			trace_block_rq_issue(q, rq);
>  		}
>  
> +		if (rq->bio && !rq->bio->bi_next && bio_cancelled(rq->bio)) {
> +			blk_start_request(rq);
> +			__blk_end_request_all(rq, -ECANCELED);
> +			continue;
> +		}

Pretty hacky too, given that it only works for the generic case of a
non-merged bio.

So nack on this one.

-- 
Jens Axboe

