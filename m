Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaHHOYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:24:33 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35262 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaHHOYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:24:32 -0400
Message-ID: <53E4DD9C.1050306@kernel.dk>
Date: Fri, 08 Aug 2014 08:24:28 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, oren@purestorage.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race in get_request()
References: <20140808005443.GA7895@logfs.org>
In-Reply-To: <20140808005443.GA7895@logfs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 06:54 PM, Jörn Engel wrote:
> Hello Jens!
> 
> I came across the below while investigating some other problem.
> Something here doesn't seem right.  This looks like an obvious bug and
> something roughly along the lines of my patch would fix it.  But I
> must be in the wrong decade to find such a bug in the block layer.
> 
> Is this for real?  Or if not, what am I missing?
> 
> Jörn
> 
> --
> 
> If __get_request() returns NULL, get_request will call
> prepare_to_wait_exclusive() followed by io_schedule().  Not rechecking
> the sleep condition after prepare_to_wait_exclusive() leaves a race
> where the condition changes before prepare_to_wait_exclusive(), but
> not after and accordingly this thread never gets woken up.
> 
> The race must be exceedingly hard to hit, otherwise I cannot explain how
> such a classic race could outlive the last millenium.

I think that is a genuine bug, it's just extremely hard to hit in real
life. It has probably only potentially ever triggered in the cases where
we are so out of memory that a blocking ~300b alloc fails, and Linux
generally shits itself pretty hard when it gets to that stage anyway...
And for the bug to be critical, you'd need this to happen for a device
that otherwise has no IO pending, since you'd get woken up by the next
completed request anyway.

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3275353957f0..00aa6c7abe5a 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1068,6 +1068,11 @@ retry:
>  
>  	trace_block_sleeprq(q, bio, rw_flags & 1);
>  
> +	rq = __get_request(rl, rw_flags, bio, gfp_mask);
> +	if (rq) {
> +		finish_wait(&rl->wait[is_sync], &wait);
> +		return rq;
> +	}

The extra __get_request() call should go before the
trace_block_sleeprq(), however. I'll rejuggle that when applying.

-- 
Jens Axboe

