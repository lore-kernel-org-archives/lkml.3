Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaETPXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:23:08 -0400
Received: from verein.lst.de ([213.95.11.211]:43404 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaETPXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:23:06 -0400
Date: Tue, 20 May 2014 17:23:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
	flush worker
Message-ID: <20140520152303.GA20352@lst.de>
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com> <20140519151824.GA21762@lst.de> <CACVXFVNprzhEpXGKze=A4T2b-y35vXRxRTOUqpywu+Et=t37Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNprzhEpXGKze=A4T2b-y35vXRxRTOUqpywu+Et=t37Kw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:20:25AM +0800, Ming Lei wrote:
> - the conflict on the two structures just happens with flush
> requests because rq->requeue_work is only used to queue
> flush requests

Once we get non-trivial block drivers we'll need to be able
to requeue arbitrary requests, that's why I added blk_mq_requeue_request.
The scsi-mq work that I plant to submit for the next merge window is
the prime example.

I'd really prefer to avoid breaking that use case if we can avoid it.


Note that the flush code already is very nasy for blk-mq and this just
makes it worse.

One fix that would also help to sort out some of the flush issues would
be to add a list of requests that need requeueing to the blk_mq context,
which we can add requeusts to from irq context.  The next time we run
hw contexts for the queue we'll pick them up in user context and insert
them.

