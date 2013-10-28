Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3J1TjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:39:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58973 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3J1TjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:39:02 -0400
Message-ID: <526EBD51.1010804@kernel.dk>
Date: Mon, 28 Oct 2013 13:38:57 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>,
        Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: blk-mq flush fix
References: <20131026114612.GA8576@infradead.org>	<20131026153124.GA22227@infradead.org>	<20131027222914.GG22549@kernel.dk>	<20131028084821.GA31270@infradead.org>	<526E90D7.1070604@kernel.dk> <CANejiEWyznEOtRAXrsgEqGoo2EWJDGBt7XH4AZFksWSmR4UY+Q@mail.gmail.com>
In-Reply-To: <CANejiEWyznEOtRAXrsgEqGoo2EWJDGBt7XH4AZFksWSmR4UY+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 10:57 AM, Shaohua Li wrote:
> 
> 
> 
> 2013/10/28 Jens Axboe <axboe@kernel.dk <mailto:axboe@kernel.dk>>
> 
>     On 10/28/2013 02:48 AM, Christoph Hellwig wrote:
>     > On Sun, Oct 27, 2013 at 10:29:25PM +0000, Jens Axboe wrote:
>     >> On Sat, Oct 26 2013, Christoph Hellwig wrote:
>     >>> I think this variant of the patch from Alexander should fix the
>     issue
>     >>> in a minimally invasive way.  Longer term I'd prefer to use
>     q->flush_rq
>     >>> like in the non-mq case by copying over the context and tag
>     information.
>     >>
>     >> This one is pretty simple, we could definitely use it as a band
>     aid. I
>     >> too would greatly prefer using the static ->flush_rq instead.
>     Just have
>     >> it marked to bypass most of the free logic.
>     >
>     > We already bypass the free logical by setting and end_io callback for
>     > a while, similar to what the old code does.  Maybe it's not all that
>     > hard to prealloc the request, let me give a sping.  Using the static
>     > allocated one will be hard due to the driver-specific extra data,
>     > though.
> 
>     It's not that I think the existing patch is THAT bad, it fits in alright
>     with the reserved tagging and works regardless of whether a driver uses
>     reserved tags or not. And it does have the upside of not requiring
>     special checks or logic for this special non-tagged request that using
>     the preallocated would might need.
> 
>     >> I'll add this one.
>     >
>     > Gimme another day or so to figure this out.
> 
>     OK, holding off.
> 
> 
> Another option: we could throttle flush-request allocation in
> blk_mq_alloc_request(), for example, flush_req_nr >= max_tags - 1, make
> the allocation wait.

That could work too. If we back off, then we could restart it once a
request completes. That does, however, requiring checking that and
potentially kicking all the queues on completion when that happens.

-- 
Jens Axboe

