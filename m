Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3JDRsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:48:16 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49234 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab3JDRsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:48:15 -0400
Message-ID: <524EFD55.4050701@cs.wisc.edu>
Date: Fri, 04 Oct 2013 12:39:33 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] [PATCH 2/5] revert: "blk-mq: blk-mq should free bios
 in pass through case"
References: <20131004134908.231874670@bombadil.infradead.org> <20131004135014.524075942@bombadil.infradead.org>
In-Reply-To: <20131004135014.524075942@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/13 8:49 AM, Christoph Hellwig wrote:
> This patch causes boot failures when using REQ_FLUSH requests.  Also the
> following statement in the commit log:
>
>      For non mq calls, the block layer will free the bios when
>      blk_finish_request is called.

Sorry, messed up function name. I meant blk_end_request*.

For blk_execute_rq_nowait/blk_execute_rq and normal request use, the 
lower levels free the bios as they are completed by one of the 
blk_finish_request* calls. The caller of of 
blk_execute_rq_nowait/blk_execute_rq does not have to worry about 
freeing bios. It just frees the request when it is done with it.

>
>      For mq calls, the blk mq code wants the caller to do this.

The problem was that Nick's scsi-mq code added a async
blk_mq_execute_rq support and it did not complete bios in the rq->end_io 
callback because he most likely expected it to work like the non-mq case 
above.

The goal of my patch was to make the underlying behavior and the 
function naming similar.

If we can get the the core block code to finish the bios as they are 
completed like is done in the non mq case like I was trying to do, then 
with your other patches in this set we do not need to have the rq end_io 
callbacks have this:

>   	if (q->mq_ops) {
> -		blk_mq_free_request(flush_rq);
> +		blk_mq_finish_request(flush_rq, error);
>   		spin_lock_irqsave(&q->mq_flush_lock, flags);


The block code would free the bios no matter who sent it and mq type, 
and the callers of blk_execute* would just call blk_put_request.
