Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3A2WGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:06:49 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:58585 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3A2WGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:06:46 -0500
Date: Tue, 29 Jan 2013 14:06:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130129220642.GL6824@mtj.dyndns.org>
References: <20130128211832.GK22465@mtj.dyndns.org>
 <20130128212407.GF26407@google.com>
 <20130128212814.GL22465@mtj.dyndns.org>
 <20130128214506.GG26407@google.com>
 <20130128215042.GN22465@mtj.dyndns.org>
 <20130129163942.GI26407@google.com>
 <20130129192904.GA6824@mtj.dyndns.org>
 <20130129195141.GO26407@google.com>
 <20130129200218.GJ6824@mtj.dyndns.org>
 <20130129214537.GA18571@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129214537.GA18571@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Kent.

On Tue, Jan 29, 2013 at 01:45:37PM -0800, Kent Overstreet wrote:
> It would definitely be cleaner if the global counter was also 32 bits (I
> probably should've done it that way at first) but it works with it being
> bigger _provided the sum of the percpu counters is sign extended_ when
> collecting them up at the end.
> 
> With the bias though we kind of want the global counter to be bigger...
> the bias needs to fit in the global counter.

Yeah, the size being 64bit is fine as long as the summation and the
result is done in 32bits.

> > I don't know.  I think it's a correctness issue.  If you
> > over/underflow into global counter, you need buffer space to be
> > (practically) correct. 
> 
> Not quite sure what you mean... 

If you compute w/o sign extension, it becomes buggy.

> It doesn't really make sense to use more than 32 bits for the global sum
> (ignoring the bias value... that complicates it) but it does work, with
> the sign extending. I haven't figured out a good way of explaining why
> though... I should probably look at what happens without it again. (I
> missed the sign extending when I first coded it, had to debug that).

I think it would be easier to understand if we use only the lower
32bits for the actual counting.

> > There really is no point in adding complexity which isn't needed.  It
> > slows down the code unnecessarily (however minute) and adds
> > maintenance overhead.  Why do that when there's no need?
> 
> Well, like I said I want this to be a drop in replacement for atomic_t
> anyone can use without having to think about the potential overhead.
> 
> If it really does turn out there aren't enough uses for it to be worth
> it I'll be ok with ripping out the dynamic alloc... but the slowdown is
> pretty damn minute (one instruction in the fast path) and the additional
> complexity is fairly minor and quite self contained so I'm just not
> seeing the urgency.

I really don't think this can be drop-in replacement given the
significant overhead on base ref put and you build up complexity with
use cases not the other way around.  When you're looking at each
specific implementation, it might not look like much but it really
sucks to have a lot of unneeded / unused complexities around.  It
raises maintenance overhead for no good reason.  Like you said, it's
not like extending the design is difficult if we find out that the
dynamic allocation is actually useful, and there just is no reason to
do it the other way around.

Thanks.

-- 
tejun
