Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaHABOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:14:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaHABOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:14:33 -0400
Date: Thu, 31 Jul 2014 18:16:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH percpu/for-3.17 1/2] percpu: implement percpu_pool
Message-Id: <20140731181656.cf814c3d.akpm@linux-foundation.org>
In-Reply-To: <CAOS58YOVv2xcRzwtAUrs7ZobhNLML6ZpLpUEZj+NoqOhR02KCA@mail.gmail.com>
References: <20140718200804.GG13012@htj.dyndns.org>
	<20140731150328.d2b57d5f6d7aafa33f5ad979@linux-foundation.org>
	<CAOS58YOVv2xcRzwtAUrs7ZobhNLML6ZpLpUEZj+NoqOhR02KCA@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014 20:44:38 -0400 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Thu, Jul 31, 2014 at 6:03 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > I don't think we should add facilities such as this.  Because if we do,
> > people will use them and thereby make the kernel less reliable, for
> > obvious reasons.
> >
> > It would be better to leave the nasty hack localized within
> > blk-throttle.c and hope that someone finds a way of fixing it.
> 
> The thing is we need similar facilities in the IO path in other places
> too. They share exactly the same characteristics - opportunistic
> percpu allocations during IO which are expected to fail from time to
> time and they will all implement fallback behavior on allocation
> failures. I'm not sure how this makes the kernel less reliable. This
> conceptually isn't different from atomic allocations which we also use
> in a similar way.

Atomic allocations are more robust than this thing.  But yes, they also
are unreliable and their use should be discouraged for the same
reasons.

> If you're worried that people might use this
> assuming that it won't fail,

That's precisely my concern.

Yet nowhere in either the changelog or the code comments is it even
mentioned that this allocator is unreliable and that callers *must*
implement (and test!) fallback paths.

> an obvious solution is adding a failure
> injection for debugging, but really except for being a bit ghetto,
> this is just the atomic allocation for percpu areas.

If it was a try-GFP_ATOMIC-then-fall-back-to-pool thing then it would
work fairly well.  But it's not even that - a caller could trivially
chew through that pool in a single timeslice.  Especially on !SMP. 
Especially squared with !PREEMPT or SCHED_FIFO.

And that's all OK, as long as this is positioned as "opportunistic
performance optimisation which is expected to be available most of the
time in non-stressful use cases".

But please make very sure that this is how we position it.  I don't
know how to do this.  Maybe prefix the names with "blk_" to signify
that it is block-private (and won't even be there if !CONFIG_BLOCK).

Or rename percpu_pool_alloc() to percpu_pool_try_alloc() - that should
wake people up.
