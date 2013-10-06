Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3JFPDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:03:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3JFPDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:03:05 -0400
Date: Sun, 6 Oct 2013 08:02:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] [PATCH 2/5] revert: "blk-mq: blk-mq should free bios
 in pass through case"
Message-ID: <20131006150247.GA15624@infradead.org>
References: <20131004134908.231874670@bombadil.infradead.org>
 <20131004135014.524075942@bombadil.infradead.org>
 <524EFD55.4050701@cs.wisc.edu>
 <20131005105008.GA19022@infradead.org>
 <52507475.3050305@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52507475.3050305@cs.wisc.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 03:20:05PM -0500, Mike Christie wrote:
> The functions take in requests as the argument, but they end up
> operating on bios too. The scsi layer does
> scsi_io_completion->scsi_end_request-> blk_end_request ->
> blk_end_bidi_request -> blk_update_bidi_request -> blk_update_request.
> That function will then complete bios on the request passed in. It does
> not matter if the request is a REQ_TYPE_FS or REQ_TYPE_BLOCK_PC.
> 
> With my patch I was trying to make the block layer do the same for mq
> REQ_TYPE_BLOCK_PC requests inserted into the queue with
> blk_execute_rq_nowait (Nick's patch had support for something like that)
> by having the block mq layer call blk_mq_finish_request instead of
> making the code that calls blk_execute_rq_nowait do it.

Ok, I get the point now.  Didn't see that issue because I've only been
testing the non-bio REQ_TYPE_BLOCK_PC case as exposed by the virtio-blk
serial attribute so far.

> > That beeing said the old ones all require the caller to free the
> > request, and complicate that with the useless refcounting that my patch
> > 3 removes.  Take a look at the other patches how all the calling
> > conventions can be nicely unified.
> 
> I agree. I like them. I am saying though it could be better because even
> with your patches the rq->end_io functions need to have the mq_ops check
> like the flush_end_io does. If my patch worked as intended we would have
> your improvements and we would not need the rq->end_io functions to have
> that check and call blk_mq_finish_request because the blk mq layer was
> doing it for them.
> 
> That is all I am saying. I would like to be able to remove that check
> and blk_mq_finish_request call from the rq->end_io callouts.

I've found the bug that caused the regression with your patch, it's that
blk-mq incorrectly completes bios midway through a flush sequence, while
the old path didn't.

I'll send out a series soon that fixes this and re-reverts your patch,
although I split that re-revert into two patches in addition to my new
fix, given that I think your mixing up of the blk_mq_finish_request /
blk_mq_free_spit plus the confusing description made it really hard to
grasp, but I'll leave it to Jens how he wants to apply it to his tree
and make it look after the next rebase.
