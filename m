Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbbAXWlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 17:41:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:41421 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbAXWlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 17:41:13 -0500
Date: Sat, 24 Jan 2015 23:40:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>
Subject: Re: [PATCH 3.19-rc2 v15 4/8] sched_clock: Avoid deadlock during read
 from NMI
In-Reply-To: <1422022952-31552-5-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.DEB.2.11.1501242248170.5526@nanos>
References: <1422022952-31552-1-git-send-email-daniel.thompson@linaro.org> <1422022952-31552-5-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Daniel Thompson wrote:
> This patch fixes that problem by providing banked clock data in a
> similar manner to Thomas Gleixner's 4396e058c52e("timekeeping: Provide
> fast and NMI safe access to CLOCK_MONOTONIC").

By some definition of similar.

> -struct clock_data {
> -	ktime_t wrap_kt;
> +struct clock_data_banked {
>  	u64 epoch_ns;
>  	u64 epoch_cyc;
> -	seqcount_t seq;
> -	unsigned long rate;
> +	u64 (*read_sched_clock)(void);
> +	u64 sched_clock_mask;
>  	u32 mult;
>  	u32 shift;
>  	bool suspended;
>  };
>  
> +struct clock_data {
> +	ktime_t wrap_kt;
> +	seqcount_t seq;
> +	unsigned long rate;
> +	struct clock_data_banked bank[2];
> +};

....

> -static u64 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
> +static struct clock_data cd = {
> +	.bank = {
> +		[0] = {
> +			.mult	= NSEC_PER_SEC / HZ,
> +			.read_sched_clock = jiffy_sched_clock_read,
> +		},
> +	},
> +};

If you had carefully studied the changes which made it possible to do
the nmi safe clock monotonic accessor then you'd had noticed that I
went a great way to optimize the cache foot print first and then add
this new fangled thing.

So in the first place 'cd' lacks ____cacheline_aligned. It should have
been there before, but that's a different issue. You should have
noticed.

Secondly, I don't see any hint that you actually thought about the
cache foot print of the result struct clock_data. 

struct clock_data {
	ktime_t wrap_kt;
	seqcount_t seq;
	unsigned long rate;
	struct clock_data_banked bank[2];
};

wrap_kt and rate are completely irrelevant for the hotpath. The whole
thing up to the last member of bank[0] still fits into 64 byte on both
32 and 64bit, but that's not by design and not documented so anyone
who is aware of cache foot print issues will go WTF when the first
member of a hot path data structure is completely irrelevant.

>  static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
>  {
> @@ -58,50 +65,82 @@ static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
>  
>  unsigned long long notrace sched_clock(void)
>  {
> -	u64 epoch_ns;
> -	u64 epoch_cyc;
>  	u64 cyc;
>  	unsigned long seq;
> -
> -	if (cd.suspended)
> -		return cd.epoch_ns;
> +	struct clock_data_banked *b;
> +	u64 res;

So we now have

  	u64 cyc;
  	unsigned long seq;
	struct clock_data_banked *b;
	u64 res;

Let me try a different version of that:

	struct clock_data_banked *b;
  	unsigned long seq;
	u64 res, cyc;

Can you spot the difference in the reading experience?
 
>  	do {
> -		seq = raw_read_seqcount_begin(&cd.seq);
> -		epoch_cyc = cd.epoch_cyc;
> -		epoch_ns = cd.epoch_ns;
> +		seq = raw_read_seqcount(&cd.seq);
> +		b = cd.bank + (seq & 1);
> +		if (b->suspended) {
> +			res = b->epoch_ns;

So now we have read_sched_clock as a pointer in the bank. Why do you
still need b->suspended?

What's wrong with setting b->read_sched_clock to NULL at suspend and
restore the proper pointer on resume and use that as a conditional?
 
It would allow the compiler to generate better code, but that's
obviously not the goal here. Darn, this is hot path code and not some
random driver.

> +		} else {
> +			cyc = b->read_sched_clock();
> +			cyc = (cyc - b->epoch_cyc) & b->sched_clock_mask;
> +			res = b->epoch_ns + cyc_to_ns(cyc, b->mult, b->shift);

It would allow the following optimization as well:

   	 res = b->epoch_ns;
	 if (b->read_sched_clock) {
	    	...
	 }

If you think that compilers are smart enough to figure all that out
for you, you might get surprised. The more clear your code is the
better is the chance that the compiler gets it right. We have seen the
opposite of that as well, but that's clearly a compiler bug.

> +/*
> + * Start updating the banked clock data.
> + *
> + * sched_clock will never observe mis-matched data even if called from
> + * an NMI. We do this by maintaining an odd/even copy of the data and
> + * steering sched_clock to one or the other using a sequence counter.
> + * In order to preserve the data cache profile of sched_clock as much
> + * as possible the system reverts back to the even copy when the update
> + * completes; the odd copy is used *only* during an update.
> + *
> + * The caller is responsible for avoiding simultaneous updates.
> + */
> +static struct clock_data_banked *update_bank_begin(void)
> +{
> +	/* update the backup (odd) bank and steer readers towards it */
> +	memcpy(cd.bank + 1, cd.bank, sizeof(struct clock_data_banked));
> +	raw_write_seqcount_latch(&cd.seq);
> +
> +	return cd.bank;
> +}
> +
> +/*
> + * Finalize update of banked clock data.
> + *
> + * This is just a trivial switch back to the primary (even) copy.
> + */
> +static void update_bank_end(void)
> +{
> +	raw_write_seqcount_latch(&cd.seq);
>  }

What's wrong with having a master struct

struct master_data {
	struct clock_data_banked master_data;
	ktime_t wrap_kt;
	unsigned long rate;
	u64 (*real_read_sched_clock)(void);
};

Then you only have to care about the serialization of the master_data
update and then the hotpath data update would be the same simple
function as update_fast_timekeeper(). And it would have the same
ordering scheme and aside of that the resulting code would be simpler,
more intuitive to read and I'm pretty sure faster.

Thanks,

	tglx


