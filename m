Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3J2VeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:34:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60075 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3J2VeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:34:07 -0400
Message-ID: <527029C9.2030102@kernel.dk>
Date: Tue, 29 Oct 2013 15:34:01 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
CC: Asias He <asias@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio_blk: blk-mq support
References: <20131025130459.730903511@bombadil.infradead.org> <20131025130735.637242058@bombadil.infradead.org> <87ob6aglgl.fsf@rustcorp.com.au> <20131028085206.GB31270@infradead.org>
In-Reply-To: <20131028085206.GB31270@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 02:52 AM, Christoph Hellwig wrote:
> On Mon, Oct 28, 2013 at 01:17:54PM +1030, Rusty Russell wrote:
>> Let's pretend I'm stupid.
>>
>> We don't actually have multiple queues through to the host, but we're
>> pretending to, because it makes the block layer go faster?
>>
>> Do I want to know *why* it's faster?  Or should I look the other way?
> 
> You shouldn't.  To how multiple queues benefit here I'd like to defer to
> Jens, given the single workqueue I don't really know where to look here.

The 4 was chosen to "have some number of multiple queues" and to be able
to exercise that part, no real performance testing was done by me after
the implementation to verify whether it was faster at 1, 2, 4, or
others. But it was useful for that! For merging, we can easily just make
it 1 since that's the most logical transformation. I can set some time
aside to play with multiple queues and see if we gain anything, but that
can be done post merge.

> The real benefit that unfortunately wasn't obvious from the description
> is that even with just a single queue the blk-multiqueue infrastructure
> will be a lot faster, because it is designed in a much more streaminline
> fashion and avoids lots of lock roundtrips both during submission itself
> and for submission vs complettion.  Back when I tried to get virtio-blk
> to perform well on high-end flash (the work that Asias took over later)
> the queue_lock contention was the major issue in virtio-blk and this
> patch gets rid of that even with a single queue.
> 
> A good example are the patches from Nick to move scsi drivers over to
> the infrastructure that only support a single queue.  Even that gave
> over a 10 fold improvement over the old code.
> 
> Unfortunately I do not have access to this kind of hardware at the
> moment, but I'd love to see if Asias or anyone at Red Hat could redo
> those old numbers.

I've got a variety of fast devices, so should be able to run that.
Asias, let me know what your position is, it'd be great to have
independent results.

-- 
Jens Axboe

