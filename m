Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaELSXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:23:10 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35980 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbaELSXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:23:07 -0400
Message-ID: <53711188.3050901@linaro.org>
Date: Mon, 12 May 2014 11:23:04 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [rough draft PATCH] avoid stalls on the timekeeping seqlock
References: <20140512162141.22331.qmail@ns.horizon.com>
In-Reply-To: <20140512162141.22331.qmail@ns.horizon.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 09:21 AM, George Spelvin wrote:
> Here's a non-working rough draft of that idea I suggested to make
> reading the time non-blocking, even if an update is in progress.
>
> Basically, it uses the idea proposed in a comment in update_wall_time,
> switching pointers so there's always one valid structure.
>
> This is non-working because last year the NTP variables lost their
> own locking and inherited the timekeeping locks I am redesigning.
> I haven't updated NTP yet.

An important part here is that the NTP state is really tied to the
current timekeeping structure. When everything was updated in lockstep,
we split the locks to simplify some of the locking rules. But when we
added the mirrored update in 3.10 (which is a lighter version of what
you're proposing), we had to go back to using the same locking for
everything.

Matheiu took a similar swing last year, and in doing so moved most of
the ntp state into the timekeeper. This seemed like a nice cleanup, but
since his appraoch ran into trouble, and stalled out, so we didn't get
the cleaup patches merged either.

You can check his series out here:
    https://lkml.org/lkml/2013/9/14/136


> One interesting possibility is that the write side of the locking
> is identical to a standard seqlock.  It would be possible to
> divide the timekeeping variables into non-blocking variables which
> are mirrored, and ones that require stalling during write
> seqlock updates.
>
> But that's somewhat deeper magic than I've attempted so far.
> This is a demonstration of the idea.
>
> Does it seem worth pursuing?


So again, I'd love to find a way to make it work, but I worry that the
freq changes make the non-blocking route not very feasible (though my
concerns may be overwrought - so feel free to push back here).

There's also the extra complexity of the vdso updates, which basically
are a similar update to a separate arch specific subsystem, which is
currently done under the lock. So that would have to get unified in this
non-blocking update as well.


A few small notes below:

> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index f7df8ea217..0dfa4aa6fb 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -29,15 +29,15 @@
>  #include "timekeeping_internal.h"
>  
>  #define TK_CLEAR_NTP		(1 << 0)
> -#define TK_MIRROR		(1 << 1)
>  #define TK_CLOCK_WAS_SET	(1 << 2)
>  
> -static struct timekeeper timekeeper;
> +static struct timekeeper timekeeper[2];
>  static DEFINE_RAW_SPINLOCK(timekeeper_lock);
> +/* The following is NOT used as a standard seqlock */
>  static seqcount_t timekeeper_seq;
> -static struct timekeeper shadow_timekeeper;
>  
>  /* flag for if timekeeping is suspended */
> +/* Q: What are the locking rules for this variable? */
>  int __read_mostly timekeeping_suspended;

Really this is a left over bit that needs to be cleaned up and moved to
the timekeeping structure. Its just a global flag that we use to make
sure nothing calls into timekeeping logic while we're suspended, and was
added to sort out a few suspend/resume issues that cropped up when the
original generic timkeeping core was added.


> @@ -291,6 +289,89 @@ static void timekeeping_forward_now(struct timekeeper *tk)
>  }
>  
>  /**
> + * timekeeper_write_begin: Return a timekeeper that can be updated.
> + *
> + * Must be called with the timekeeper_lock held.
> + */
> +static inline struct timekeeper *timekeeper_write_begin(void)
> +{
> +	bool b;
> +
> +	write_seqcount_begin(&timekeeper_seq);
> +	b = (timekeeper_seq.sequence >> 1) & 1;
> +	timekeeper[!b] = timekeeper[b];
> +	return timekeeper + !b;
> +}
> +
> +/**
> + * timekeeper_write_end: Finish write, mark the modified timekeeper as current.
> + *
> + * Must be called with the timekeeper_lock held.
> + */
> +static inline void timekeeper_write_end(void)
> +{
> +	write_seqcount_end(&timekeeper_seq);
> +}
> +
> +/**
> + * __timekeeper_current: Return the current (for reading) timekeeper
> + * @seq: The current sequence number
> + *
> + * Return the timekeeper corresponding to the given sequence number.
> + */
> +static inline struct timekeeper const *__timekeeper_current(unsigned seq)
> +{
> +	return timekeeper + ((seq >> 1) & 1);
> +}
> +
> +/**
> + * timekeeper_current: Return the current (for reading) timekeeper
> + *
> + * On rare occasions, we want the current timekeeper without obtaining
> + * the seqlock.  For example, if we hold the timekeeper_loc but don't
> + * intend to write it.
> + */
> +static inline struct timekeeper const *timekeeper_current(void)
> +{
> +	return __timekeeper_current(timekeeper_seq.sequence);
> +}
> +
> +/**
> + * timekeeper_read_begin: Begin reading a timekeeper.
> + * @seqp: Pointer to variable to receive sequence number.
> + *	(Because this is inline, the compiler can optimize out
> + *	the memory access.)
> + *
> + * Returns a pointer to a readable timekeeper structure.
> + *
> + * Because we have two timekeeper structures that we ping-pong
> + * between, this never blocks.  Only if there are two calls
> + * to timekeeper_write_begin between read_begin and read_retry
> + * will a retry be forced.
> + */
> +static inline struct timekeeper const *timekeeper_read_begin(unsigned *seqp)
> +{
> +	unsigned seq = ACCESS_ONCE(timekeeper_seq.sequence);
> +	smp_rmb();
> +	*seqp = seq &= ~1u;
> +	return __timekeeper_current(seq);
> +}
> +
> +/**
> + * timekeeper_read_retry: Return true if read was inconsistent, must retry
> + * @seq: The return value from timekeeper_read_begin
> + *
> + * Because we ping-pong between two timekeeper structures, the window
> + * of validity is wider than a normal seqlock, and a retry is very
> + * unlikely.
> + */
> +static inline bool timekeeper_read_retry(unsigned seq)
> +{
> +	unsigned delta = timekeeper_seq.sequence - seq;
> +	return unlikely(delta > 2);
> +}

This all looks very clean and nice! I suspect even if the non-blocking
logic doesn't work out, there's probably some similar style cleanups
that could be done to make the current mirroring code nicer to read.

thanks
-john


