Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3J1IwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:52:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37477 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3J1IwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:52:07 -0400
Date: Mon, 28 Oct 2013 01:52:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio_blk: blk-mq support
Message-ID: <20131028085206.GB31270@infradead.org>
References: <20131025130459.730903511@bombadil.infradead.org>
 <20131025130735.637242058@bombadil.infradead.org>
 <87ob6aglgl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob6aglgl.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 01:17:54PM +1030, Rusty Russell wrote:
> Let's pretend I'm stupid.
> 
> We don't actually have multiple queues through to the host, but we're
> pretending to, because it makes the block layer go faster?
> 
> Do I want to know *why* it's faster?  Or should I look the other way?

You shouldn't.  To how multiple queues benefit here I'd like to defer to
Jens, given the single workqueue I don't really know where to look here.

The real benefit that unfortunately wasn't obvious from the description
is that even with just a single queue the blk-multiqueue infrastructure
will be a lot faster, because it is designed in a much more streaminline
fashion and avoids lots of lock roundtrips both during submission itself
and for submission vs complettion.  Back when I tried to get virtio-blk
to perform well on high-end flash (the work that Asias took over later)
the queue_lock contention was the major issue in virtio-blk and this
patch gets rid of that even with a single queue.

A good example are the patches from Nick to move scsi drivers over to
the infrastructure that only support a single queue.  Even that gave
over a 10 fold improvement over the old code.

Unfortunately I do not have access to this kind of hardware at the
moment, but I'd love to see if Asias or anyone at Red Hat could redo
those old numbers.
