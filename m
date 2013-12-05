Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3LEV0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 16:26:54 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:64013 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877Ab3LEV0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:26:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQHADTvoFJ5LHyk/2dsb2JhbABZgweDM7B3hU+BGxd0giUBAQUnExwjEAgDDgoJJQ8FJQMhE4gBwVEXFo5qB4QzA5gTikyHSIM9KA
Date: Fri, 6 Dec 2013 08:26:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [OOPS, 3.13-rc2] null ptr in dio_complete()
Message-ID: <20131205212651.GP10988@dastard>
References: <20131203215940.GX10988@dastard>
 <20131204015837.GJ10988@dastard>
 <20131205222220.5d7f4a48@tom-ThinkPad-T410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205222220.5d7f4a48@tom-ThinkPad-T410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 10:22:20PM +0800, Ming Lei wrote:
> On Wed, 4 Dec 2013 12:58:38 +1100
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > 
> > And I just hit this from running xfs_repair which is doing
> > multithreaded direct IO directly on /dev/vdc:
.....
> > So this is looking like another virtio+blk_mq problem....
> 
> This one might be caused by using-after-'free' request because the freed
> request may be allocated to another CPU immediately, and the below patch
> may be helpful, would you mind testing it?
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 6875736..2358bdf 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -311,12 +311,12 @@ void blk_mq_complete_request(struct request *rq, int error)
>  
>  	blk_account_io_completion(rq, bytes);
>  
> +	blk_account_io_done(rq);
> +
>  	if (rq->end_io)
>  		rq->end_io(rq, error);
>  	else
>  		blk_mq_free_request(rq);
> -
> -	blk_account_io_done(rq);
>  }
>  
>  void __blk_mq_end_io(struct request *rq, int error)

Testing it now. I'll let you know how it goes in couple of hours.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
