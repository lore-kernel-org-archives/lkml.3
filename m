Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3JEUVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 16:21:11 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51350 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3JEUVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 16:21:10 -0400
Message-ID: <52507475.3050305@cs.wisc.edu>
Date: Sat, 05 Oct 2013 15:20:05 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.3
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] [PATCH 2/5] revert: "blk-mq: blk-mq should free bios
 in pass through case"
References: <20131004134908.231874670@bombadil.infradead.org> <20131004135014.524075942@bombadil.infradead.org> <524EFD55.4050701@cs.wisc.edu> <20131005105008.GA19022@infradead.org>
In-Reply-To: <20131005105008.GA19022@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2013 05:50 AM, Christoph Hellwig wrote:
> On Fri, Oct 04, 2013 at 12:39:33PM -0500, Mike Christie wrote:
>> Sorry, messed up function name. I meant blk_end_request*.
>>
>> For blk_execute_rq_nowait/blk_execute_rq and normal request use, the
>> lower levels free the bios as they are completed by one of the
>> blk_finish_request* calls. The caller of of
>> blk_execute_rq_nowait/blk_execute_rq does not have to worry about
>> freeing bios. It just frees the request when it is done with it.
> 
> Are you talking about bios or requests?  All these functions deal with
> requests, so the talk of bios really confuses me.

The functions take in requests as the argument, but they end up
operating on bios too. The scsi layer does
scsi_io_completion->scsi_end_request-> blk_end_request ->
blk_end_bidi_request -> blk_update_bidi_request -> blk_update_request.
That function will then complete bios on the request passed in. It does
not matter if the request is a REQ_TYPE_FS or REQ_TYPE_BLOCK_PC.

With my patch I was trying to make the block layer do the same for mq
REQ_TYPE_BLOCK_PC requests inserted into the queue with
blk_execute_rq_nowait (Nick's patch had support for something like that)
by having the block mq layer call blk_mq_finish_request instead of
making the code that calls blk_execute_rq_nowait do it.


> 
> That beeing said the old ones all require the caller to free the
> request, and complicate that with the useless refcounting that my patch
> 3 removes.  Take a look at the other patches how all the calling
> conventions can be nicely unified.

I agree. I like them. I am saying though it could be better because even
with your patches the rq->end_io functions need to have the mq_ops check
like the flush_end_io does. If my patch worked as intended we would have
your improvements and we would not need the rq->end_io functions to have
that check and call blk_mq_finish_request because the blk mq layer was
doing it for them.

That is all I am saying. I would like to be able to remove that check
and blk_mq_finish_request call from the rq->end_io callouts.
