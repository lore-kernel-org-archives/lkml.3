Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaHABXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:23:07 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:42605 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaHABXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:23:05 -0400
Date: Thu, 31 Jul 2014 21:23:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH percpu/for-3.17 1/2] percpu: implement percpu_pool
Message-ID: <20140801012301.GB1967@htj.dyndns.org>
References: <20140718200804.GG13012@htj.dyndns.org>
 <20140731150328.d2b57d5f6d7aafa33f5ad979@linux-foundation.org>
 <CAOS58YOVv2xcRzwtAUrs7ZobhNLML6ZpLpUEZj+NoqOhR02KCA@mail.gmail.com>
 <20140731181656.cf814c3d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731181656.cf814c3d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Jul 31, 2014 at 06:16:56PM -0700, Andrew Morton wrote:
> Yet nowhere in either the changelog or the code comments is it even
> mentioned that this allocator is unreliable and that callers *must*
> implement (and test!) fallback paths.

Hmmm, yeah, somehow the atomic behavior seemed obvious to me.  I'll
try to make it clear that this thing can and does fail.

> > an obvious solution is adding a failure
> > injection for debugging, but really except for being a bit ghetto,
> > this is just the atomic allocation for percpu areas.
> 
> If it was a try-GFP_ATOMIC-then-fall-back-to-pool thing then it would
> work fairly well.  But it's not even that - a caller could trivially
> chew through that pool in a single timeslice.  Especially on !SMP. 
> Especially squared with !PREEMPT or SCHED_FIFO.

Yeap, occassional pool depletion would be a normal thing to happen,
which isn't a correctness issue and most likely not even a performance
issue.

> But please make very sure that this is how we position it.  I don't
> know how to do this.  Maybe prefix the names with "blk_" to signify
> that it is block-private (and won't even be there if !CONFIG_BLOCK).
> 
> Or rename percpu_pool_alloc() to percpu_pool_try_alloc() - that should
> wake people up.

Sounds good to me.  I'll rename it to percpu_pool_try_alloc() and make
it clear in the comment that the allocation is opportunistic.

Thanks.

-- 
tejun
