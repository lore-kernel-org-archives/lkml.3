Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbbAZU25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:28:57 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62546 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAZU2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:28:52 -0500
Message-ID: <54C6A383.6060409@linaro.org>
Date: Mon, 26 Jan 2015 20:28:51 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
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
References: <1422022952-31552-1-git-send-email-daniel.thompson@linaro.org> <1422022952-31552-5-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1501242248170.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501242248170.5526@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/15 22:40, Thomas Gleixner wrote:
> On Fri, 23 Jan 2015, Daniel Thompson wrote:
>> This patch fixes that problem by providing banked clock data in a
>> similar manner to Thomas Gleixner's 4396e058c52e("timekeeping: Provide
>> fast and NMI safe access to CLOCK_MONOTONIC").
> 
> By some definition of similar.

Fair point, I copied only the NMI-safety concept.

Anyhow, thanks very much for the review.


>> -struct clock_data {
>> -	ktime_t wrap_kt;
>> +struct clock_data_banked {
>>  	u64 epoch_ns;
>>  	u64 epoch_cyc;
>> -	seqcount_t seq;
>> -	unsigned long rate;
>> +	u64 (*read_sched_clock)(void);
>> +	u64 sched_clock_mask;
>>  	u32 mult;
>>  	u32 shift;
>>  	bool suspended;
>>  };
>>  
>> +struct clock_data {
>> +	ktime_t wrap_kt;
>> +	seqcount_t seq;
>> +	unsigned long rate;
>> +	struct clock_data_banked bank[2];
>> +};
> 
> ....
> 
>> -static u64 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
>> +static struct clock_data cd = {
>> +	.bank = {
>> +		[0] = {
>> +			.mult	= NSEC_PER_SEC / HZ,
>> +			.read_sched_clock = jiffy_sched_clock_read,
>> +		},
>> +	},
>> +};
> 
> If you had carefully studied the changes which made it possible to do
> the nmi safe clock monotonic accessor then you'd had noticed that I
> went a great way to optimize the cache foot print first and then add
> this new fangled thing.
> 
> So in the first place 'cd' lacks ____cacheline_aligned. It should have
> been there before, but that's a different issue. You should have
> noticed.
> 
> Secondly, I don't see any hint that you actually thought about the
> cache foot print of the result struct clock_data.

I did think about the cache footprint but only to the point of believing
my patch was unlikely to regress performance. As it happens it was the
absence of __cacheline_aligned on cd in the current code that made be
believe absence of regression would be enough (once I'd managed that I
ordered the members within the structure to get best locality of
reference within the *patch* in order to make code review easier).

I guess I did two things wrong here: inadequately documenting what work
I did and possessing insufficient ambition to improve!

I'll work on both of these.


> struct clock_data {
> 	ktime_t wrap_kt;
> 	seqcount_t seq;
> 	unsigned long rate;
> 	struct clock_data_banked bank[2];
> };
> 
> wrap_kt and rate are completely irrelevant for the hotpath. The whole
> thing up to the last member of bank[0] still fits into 64 byte on both
> 32 and 64bit, but that's not by design and not documented so anyone
> who is aware of cache foot print issues will go WTF when the first
> member of a hot path data structure is completely irrelevant.

Agreed.

It looks like I also put the function pointer in the wrong place within
clock_data_banked. It should occupy the space between the 64-bit and
32-bit members shouldn't it?


>>  static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
>>  {
>> @@ -58,50 +65,82 @@ static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
>>  
>>  unsigned long long notrace sched_clock(void)
>>  {
>> -	u64 epoch_ns;
>> -	u64 epoch_cyc;
>>  	u64 cyc;
>>  	unsigned long seq;
>> -
>> -	if (cd.suspended)
>> -		return cd.epoch_ns;
>> +	struct clock_data_banked *b;
>> +	u64 res;
> 
> So we now have
> 
>   	u64 cyc;
>   	unsigned long seq;
> 	struct clock_data_banked *b;
> 	u64 res;
> 
> Let me try a different version of that:
> 
> 	struct clock_data_banked *b;
>   	unsigned long seq;
> 	u64 res, cyc;
> 
> Can you spot the difference in the reading experience?

Will fix.

>  
>>  	do {
>> -		seq = raw_read_seqcount_begin(&cd.seq);
>> -		epoch_cyc = cd.epoch_cyc;
>> -		epoch_ns = cd.epoch_ns;
>> +		seq = raw_read_seqcount(&cd.seq);
>> +		b = cd.bank + (seq & 1);
>> +		if (b->suspended) {
>> +			res = b->epoch_ns;
> 
> So now we have read_sched_clock as a pointer in the bank. Why do you
> still need b->suspended?
> 
> What's wrong with setting b->read_sched_clock to NULL at suspend and
> restore the proper pointer on resume and use that as a conditional?
>  
> It would allow the compiler to generate better code, but that's
> obviously not the goal here. Darn, this is hot path code and not some
> random driver.

The update code probably won't be as easy to read but, as you say, this
is hot patch code.

>> +		} else {
>> +			cyc = b->read_sched_clock();
>> +			cyc = (cyc - b->epoch_cyc) & b->sched_clock_mask;
>> +			res = b->epoch_ns + cyc_to_ns(cyc, b->mult, b->shift);
> 
> It would allow the following optimization as well:
> 
>    	 res = b->epoch_ns;
> 	 if (b->read_sched_clock) {
> 	    	...
> 	 }
> 
> If you think that compilers are smart enough to figure all that out
> for you, you might get surprised. The more clear your code is the
> better is the chance that the compiler gets it right. We have seen the
> opposite of that as well, but that's clearly a compiler bug.

Good idea and, in this case there is a function pointer with unknown
side effects so a compiler would never be able to make that optimization.


>> +/*
>> + * Start updating the banked clock data.
>> + *
>> + * sched_clock will never observe mis-matched data even if called from
>> + * an NMI. We do this by maintaining an odd/even copy of the data and
>> + * steering sched_clock to one or the other using a sequence counter.
>> + * In order to preserve the data cache profile of sched_clock as much
>> + * as possible the system reverts back to the even copy when the update
>> + * completes; the odd copy is used *only* during an update.
>> + *
>> + * The caller is responsible for avoiding simultaneous updates.
>> + */
>> +static struct clock_data_banked *update_bank_begin(void)
>> +{
>> +	/* update the backup (odd) bank and steer readers towards it */
>> +	memcpy(cd.bank + 1, cd.bank, sizeof(struct clock_data_banked));
>> +	raw_write_seqcount_latch(&cd.seq);
>> +
>> +	return cd.bank;
>> +}
>> +
>> +/*
>> + * Finalize update of banked clock data.
>> + *
>> + * This is just a trivial switch back to the primary (even) copy.
>> + */
>> +static void update_bank_end(void)
>> +{
>> +	raw_write_seqcount_latch(&cd.seq);
>>  }
> 
> What's wrong with having a master struct
> 
> struct master_data {
> 	struct clock_data_banked master_data;
> 	ktime_t wrap_kt;
> 	unsigned long rate;
> 	u64 (*real_read_sched_clock)(void);
> };
> 
> Then you only have to care about the serialization of the master_data
> update and then the hotpath data update would be the same simple
> function as update_fast_timekeeper(). And it would have the same
> ordering scheme and aside of that the resulting code would be simpler,
> more intuitive to read and I'm pretty sure faster.

Sorry. I don't quite understand this.

Is the intent to have a single function to update the hotpath data used
by both update_sched_clock() and sched_clock_register() to replace the
pairing of update_bank_begin/end()?

If so, I started out doing that but eventually concluded that
update_sched_clock() didn't really benefit from having to make a third
copy of the values it consumes rather than updates.

However if that's an unconvincing reason I'm happy to switch to having
an update structure.


Daniel.

