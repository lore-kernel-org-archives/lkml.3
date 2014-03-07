Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaCGUpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:45:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbaCGUpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:45:40 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        linux-kernel@vger.kernel.org, msnitzer@redhat.com
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
References: <20140130132620.GA6031@infradead.org>
	<20140130132630.GB6031@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 07 Mar 2014 15:45:09 -0500
In-Reply-To: <20140130132630.GB6031@infradead.org> (Christoph Hellwig's
	message of "Thu, 30 Jan 2014 05:26:30 -0800")
Message-ID: <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> Witch to using a preallocated flush_rq for blk-mq similar to what's done
> with the old request path.  This allows us to set up the request properly
> with a tag from the actually allowed range and ->rq_disk as needed by
> some drivers.  To make life easier we also switch to dynamic allocation
> of ->flush_rq for the old path.
>
> This effectively reverts most of
>
>     "blk-mq: fix for flush deadlock"
>
> and
>
>     "blk-mq: Don't reserve a tag for flush request"
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

[snip]

> -static void blk_mq_flush_data_insert(struct request *rq)
> +static bool blk_flush_queue_rq(struct request *rq)
>  {
> -	INIT_WORK(&rq->mq_flush_data, mq_flush_data_run);
> -	kblockd_schedule_work(rq->q, &rq->mq_flush_data);
> +	if (rq->q->mq_ops) {
> +		INIT_WORK(&rq->mq_flush_work, mq_flush_run);
> +		kblockd_schedule_work(rq->q, &rq->mq_flush_work);
> +		return false;
> +	} else {
> +		list_add_tail(&rq->queuelist, &rq->q->queue_head);
> +		return true;
> +	}
>  }
>  
>  /**
> @@ -187,12 +193,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
>  
>  	case REQ_FSEQ_DATA:
>  		list_move_tail(&rq->flush.list, &q->flush_data_in_flight);
> -		if (q->mq_ops)
> -			blk_mq_flush_data_insert(rq);
> -		else {
> -			list_add(&rq->queuelist, &q->queue_head);
> -			queued = true;
> -		}
> +		queued = blk_flush_queue_rq(rq);
>  		break;

Hi, Christoph,

Did you mean to switch from list_add to list_add_tail?  That seems like
a change that warrants mention.

Cheers,
Jeff
