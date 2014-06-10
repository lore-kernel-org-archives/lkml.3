Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaFJQOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:14:10 -0400
Received: from imap.thunk.org ([74.207.234.97]:59701 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaFJQOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:14:08 -0400
Date: Tue, 10 Jun 2014 12:14:01 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140610161401.GC12104@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <20140519211719.GA14563@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140519211719.GA14563@logfs.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 05:17:19PM -0400, Jörn Engel wrote:
> +/*
> + * Ratelimit to a steady state of about once per jiffy.  A naïve approach
> + * would be to return 1 every time jiffies changes.  But we want to avoid
> + * being closely coupled to the timer interrupt.  So instead we increment
> + * a counter on every call and shift it right every time jiffies changes.
> + * If the counter is a power of two, return false;
> + *
> + * Effect is that some time after a jiffies change and cutting the counter
> + * in half we reach another power of two and return false.  But the
> + * likelihood of this happening is about the same at any time within a
> + * jiffies interval.
> + */
> +static inline int ratelimited(struct fast_pool *p)
> +{
> +	int ret = !(p->regs_count == 0 || is_power_of_2(p->regs_count));
> +
> +	p->regs_count++;
> +	if (p->last_shift != (u32)jiffies) {
> +		p->regs_count >>= min(31u, (u32)jiffies - p->last_shift);
> +		p->last_shift = (u32)jiffies;
> +	}
> +	return ret;
> +}

I wasn't convinced this would do the right thing, so I wrote a quick
test program where the main loop was basically this:

	for (i=0; i < 1024; i++) {
		jiffies = i >> 2;
		r = ratelimited(jiffies);
		printf("%5u %5u %5u %d\n", i, jiffies, regs_count, r);
	}

... which basically simulated a very simple scheme where there were
four interrupts for each clock tick.  In the steady state ratelimited
returns true 75% of the time.  If this was as documented, we would
expect it to return true 25% of the time.  So I don't think this is
working quite right:

   20     5     3 1
   21     5     4 1
   22     5     5 0
   23     5     6 1
   24     6     3 1
   25     6     4 1
   26     6     5 0
   27     6     6 1
   28     7     3 1
   29     7     4 1
   30     7     5 0
   31     7     6 1
   32     8     3 1


> +static void mix_regs(struct pt_regs *regs, struct fast_pool *fast_pool)
> +{
> +	struct entropy_store	*r;
> +	/* Two variables avoid decrementing by two without using atomics */
> +	static int boot_count = BOOT_IRQS;
> +	int in_boot = boot_count;
> +
> +	if (in_boot) {
> +		boot_count = in_boot - 1;
> +	} else if (ratelimited(fast_pool))
> +		return;
> +
> +	/* During bootup we alternately feed both pools */
> +	r = (in_boot & 1) ? &nonblocking_pool : &input_pool;
> +	__mix_pool_bytes(r, regs, sizeof(*regs), NULL);
> +}

I'm also concerned about how much overhead this might eat up.  I've
already had someone who was benchmarking a high performance storage
array where the increased interrupt latency before adding something
like this was something he noticed, and kvetched to me about.  The
pt_regs structure is going to be larger than the fast_pool (which is
only 16 bytes), and we're going to be doing it once every jiffy, which
means between 100 and 1000 times per second.

If we do this only during boot up, I'd be much less concerned, but
doing it all the time is making me a bit nervous about the overhead.

If we knew which parts of the pt_regs were actually the "best" in
terms of entropy, we could xor that into the input[] array in
add_interrupt_randomness(), perhaps?  


> -	input[0] = cycles ^ j_high ^ irq;
> -	input[1] = now ^ c_high;
> +	input[0] ^= cycles ^ j_high ^ irq;
> +	input[1] ^= now ^ c_high;

This is an unrelated change, so if you want to do this, let's discuss
this on a separate commit.  We used to have something like this, but
it causes static code checkers to complain about our using stack
garbage, and people argued convincingly that it really did add as much
unpredictability, especially when correlated with the ip field.

(And yes, I know that instruction_pointer(regs) doesn't work on all
platforms, and _RET_IP_ becomes largely static --- but this is why I'd
much rather have each architecture tell me which parts of regs were
actually the best, and use that as the initialized portions of the
input[] array.)

Cheers,

					- Ted
