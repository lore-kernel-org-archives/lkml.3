Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaA2VdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 16:33:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35082 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaA2Vc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 16:32:59 -0500
Date: Wed, 29 Jan 2014 14:32:56 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH] block: __elv_next_request() shouldn't call into the
 elevator if bypassing
Message-ID: <20140129213256.GF6403@kernel.dk>
References: <20140129202633.GQ30842@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129202633.GQ30842@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29 2014, Tejun Heo wrote:
> request_queue bypassing is used to suppress higher-level function of a
> request_queue so that they can be switched, reconfigured and shut
> down.  A request_queue does the followings while bypassing.
> 
> * bypasses elevator and io_cq association and queues requests directly
>   to the FIFO dispatch queue.
> 
> * bypasses block cgroup request_list lookup and always uses the root
>   request_list.
> 
> Once confirmed to be bypassing, specific elevator and block cgroup
> policy implementations can assume that nothing is in flight for them
> and perform various operations which would be dangerous otherwise.
> 
> Such confirmation is acheived by short-circuiting all new requests
> directly to the dispatch queue and waiting for all the requests which
> were issued before to finish.  Unfortunately, while the request
> allocating and draining sides were properly handled, we forgot to
> actually plug the request dispatch path.  Even after bypassing mode is
> confirmed, if the attached driver tries to fetch a request and the
> dispatch queue is empty, __elv_next_request() would invoke the current
> elevator's elevator_dispatch_fn() callback.  As all in-flight requests
> were drained, the elevator wouldn't contain any request but once
> bypass is confirmed we don't even know whether the elevator is even
> there.  It might be in the process of being switched and half torn
> down.
> 
> Frank Mayhar reports that this actually happened while switching
> elevators, leading to an oops.
> 
> Let's fix it by making __elv_next_request() avoid invoking the
> elevator_dispatch_fn() callback if the queue is bypassing.  It already
> avoids invoking the callback if the queue is dying.  As a dying queue
> is guaranteed to be bypassing, we can simply replace blk_queue_dying()
> check with blk_queue_bypass().

Thanks Tejun, will queue up right after Linus has merged the previous
requests. And will add Franks tested-by.

-- 
Jens Axboe

