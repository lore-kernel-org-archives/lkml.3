Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaFKAMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 20:12:13 -0400
Received: from longford.logfs.org ([213.229.74.203]:43517 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaFKAMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 20:12:12 -0400
Date: Tue, 10 Jun 2014 20:10:09 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140611001009.GA24626@logfs.org>
References: <20140519211719.GA14563@logfs.org>
 <20140610161401.GC12104@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140610161401.GC12104@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 June 2014 12:14:01 -0400, Theodore Ts'o wrote:
> On Mon, May 19, 2014 at 05:17:19PM -0400, Jörn Engel wrote:
> > +/*
> > + * Ratelimit to a steady state of about once per jiffy.  A naïve approach
> > + * would be to return 1 every time jiffies changes.  But we want to avoid
> > + * being closely coupled to the timer interrupt.  So instead we increment
> > + * a counter on every call and shift it right every time jiffies changes.
> > + * If the counter is a power of two, return false;
> > + *
> > + * Effect is that some time after a jiffies change and cutting the counter
> > + * in half we reach another power of two and return false.  But the
> > + * likelihood of this happening is about the same at any time within a
> > + * jiffies interval.
> > + */
> > +static inline int ratelimited(struct fast_pool *p)
> > +{
> > +	int ret = !(p->regs_count == 0 || is_power_of_2(p->regs_count));
> > +
> > +	p->regs_count++;
> > +	if (p->last_shift != (u32)jiffies) {
> > +		p->regs_count >>= min(31u, (u32)jiffies - p->last_shift);
> > +		p->last_shift = (u32)jiffies;
> > +	}
> > +	return ret;
> > +}
> 
> I wasn't convinced this would do the right thing, so I wrote a quick
> test program where the main loop was basically this:
> 
> 	for (i=0; i < 1024; i++) {
> 		jiffies = i >> 2;
> 		r = ratelimited(jiffies);
> 		printf("%5u %5u %5u %d\n", i, jiffies, regs_count, r);
> 	}
> 
> ... which basically simulated a very simple scheme where there were
> four interrupts for each clock tick.  In the steady state ratelimited
> returns true 75% of the time.  If this was as documented, we would
> expect it to return true 25% of the time.  So I don't think this is
> working quite right:
> 
>    20     5     3 1
>    21     5     4 1
>    22     5     5 0
>    23     5     6 1
>    24     6     3 1
>    25     6     4 1
>    26     6     5 0
>    27     6     6 1
>    28     7     3 1
>    29     7     4 1
>    30     7     5 0
>    31     7     6 1
>    32     8     3 1

Doh!  Removing the "!" from "!(p->regs_count..." will fix that.  Shows
I spent 100x more time testing the bootup entropy collection.

> > +static void mix_regs(struct pt_regs *regs, struct fast_pool *fast_pool)
> > +{
> > +	struct entropy_store	*r;
> > +	/* Two variables avoid decrementing by two without using atomics */
> > +	static int boot_count = BOOT_IRQS;
> > +	int in_boot = boot_count;
> > +
> > +	if (in_boot) {
> > +		boot_count = in_boot - 1;
> > +	} else if (ratelimited(fast_pool))
> > +		return;
> > +
> > +	/* During bootup we alternately feed both pools */
> > +	r = (in_boot & 1) ? &nonblocking_pool : &input_pool;
> > +	__mix_pool_bytes(r, regs, sizeof(*regs), NULL);
> > +}
> 
> I'm also concerned about how much overhead this might eat up.  I've
> already had someone who was benchmarking a high performance storage
> array where the increased interrupt latency before adding something
> like this was something he noticed, and kvetched to me about.  The
> pt_regs structure is going to be larger than the fast_pool (which is
> only 16 bytes), and we're going to be doing it once every jiffy, which
> means between 100 and 1000 times per second.

Would that someone be me? ;)

The reason I prefer doing it once every jiffy is that it doesn't
change with interrupt load.  You get 10k interrupts per second?
You pay once per jiffy.  100k interrupts per second?  Pay once per
jiffy.

I dislike the fact that HZ is anywhere between 100 and 1000.  We could
sample every time jiffies has advanced by HZ/50, which gives a stable
sample rate of 50Hz for every currently possible config.

> If we do this only during boot up, I'd be much less concerned, but
> doing it all the time is making me a bit nervous about the overhead.
> 
> If we knew which parts of the pt_regs were actually the "best" in
> terms of entropy, we could xor that into the input[] array in
> add_interrupt_randomness(), perhaps?  
> 
> 
> > -	input[0] = cycles ^ j_high ^ irq;
> > -	input[1] = now ^ c_high;
> > +	input[0] ^= cycles ^ j_high ^ irq;
> > +	input[1] ^= now ^ c_high;
> 
> This is an unrelated change, so if you want to do this, let's discuss
> this on a separate commit.  We used to have something like this, but
> it causes static code checkers to complain about our using stack
> garbage, and people argued convincingly that it really did add as much
> unpredictability, especially when correlated with the ip field.

Will remove.

> (And yes, I know that instruction_pointer(regs) doesn't work on all
> platforms, and _RET_IP_ becomes largely static --- but this is why I'd
> much rather have each architecture tell me which parts of regs were
> actually the best, and use that as the initialized portions of the
> input[] array.)

What I like about my approach is quite the opposite.  The only thing
an architecture maintainer can mess up is not saving registers on
interrupts.  And if they mess that one up, they are very likely to
notice.

Jörn

--
Victory in war is not repetitious.
-- Sun Tzu
