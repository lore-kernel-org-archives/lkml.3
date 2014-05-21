Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaEUFgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:36:38 -0400
Received: from verein.lst.de ([213.95.11.211]:44821 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbaEUFgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:36:37 -0400
Date: Wed, 21 May 2014 07:36:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
	flush worker
Message-ID: <20140521053634.GA4764@lst.de>
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com> <20140519151824.GA21762@lst.de> <CACVXFVNprzhEpXGKze=A4T2b-y35vXRxRTOUqpywu+Et=t37Kw@mail.gmail.com> <20140520152303.GA20352@lst.de> <CACVXFVNP--zj_-UtygxfXk7GvSXwKm2KMKFs=h9KsrL=ZzbWVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNP--zj_-UtygxfXk7GvSXwKm2KMKFs=h9KsrL=ZzbWVQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 01:16:14PM +0800, Ming Lei wrote:
> I am wondering if virtio-blk is trivial block driver, :-)

It's about as simple as it gets.

> > The scsi-mq work that I plant to submit for the next merge window is
> > the prime example.
> 
> It depends if one scsi-mq req has to requeue itself with rq->requeue_work
> inside its own .softirq_done_fn. If yes, we can't put call_single_data
> and requeue_work into one union simply. From you last scsi-mq post,
> looks the request may do that if I understand correctly.

Requeueing a request from the completion handler is indeed what we'll
need with various more complete drivers.

> I think the patch is clean and simple, with documenting the special
> conflict case clearly too.

While I can't say anything against the fact that it fixes the issue
it's neither clean nor simple.

> Follows current ideas:
> 1), this patch with scsi-mq sharing abort_work together?
> 2), move requeue_work out of the union inside request
> 3), spin_lock_irqsave(&ctx->lock) everywhere and requeue
> request directly to ctx without using work

I think Jens very much wanted to avoid irq disabling in the I/O path
if possible. If we have a separate requeue list with it's separate
lock we can avoid that unless we actually have to take requests of
that requeue list.  I can look into that implementation.

