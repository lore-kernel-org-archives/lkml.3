Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaJYSso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:48:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:50855 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaJYSsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:48:43 -0400
Date: Sat, 25 Oct 2014 17:22:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heena Sirwani <heenasirwani@gmail.com>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de
Subject: Re: [PATCH v5] timekeeping: Added a function to return tv_sec portion
 of ktime_get_ts64()
In-Reply-To: <alpine.DEB.2.11.1410251705550.5308@nanos>
Message-ID: <alpine.DEB.2.11.1410251714460.5308@nanos>
References: <20141025123406.GA13128@heena.com> <alpine.DEB.2.11.1410251705550.5308@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014, Thomas Gleixner wrote:
> On Sat, 25 Oct 2014, Heena Sirwani wrote:
> > +time64_t ktime_get_seconds(void)
> > +{
> > +	time64_t ts;
> > +	struct timekeeper *tk = &tk_core.timekeeper;
> > +	struct timespec64 tomono;
> > +	s32 nsec;
> > +	unsigned int seq;
> > +
> > +	WARN_ON(timekeeping_suspended);
> > +
> > +	do {
> > +		seq = read_seqcount_begin(&tk_core.seq);
> > +		ts = tk->xtime_sec;
> > +		nsec = (long)(tk->tkr.xtime_nsec >> tk->tkr.shift);
> > +		tomono = tk->wall_to_monotonic;
> > +
> > +	} while (read_seqcount_retry(&tk_core.seq, seq));
> > +
> > +	ts += tomono.tv_sec;
> > +	if (nsec + tomono.tv_nsec >= NSEC_PER_SEC)
> > +		ts += 1;
> > +	return ts;
> 
> I'd rather have an extra field in the timekeeper
> 
>     u64 xtime_sec;
> +   u64 ktime_sec;
> 
> and update this in tk_update_ktime_data() so the readout function
> boils down to
> 
> time64_t ktime_get_seconds(void)
> {
> #if BITS_PER_LONG < 64
> 	u64 sec;
> 	int seq;
> 
> 	do {
> 		seq = read_seqcount_begin(&tk_core.seq);
> 		sec = tk->ktime_sec;
> 	} while (read_seqcount_retry(&tk_core.seq, seq));
> 
> 	return sec;
> #else
> 	return tk->ktime_sec;
> #endif
> }
> 
> So 64bit can do w/o the seqcount and 32bit avoids all extra math, right?

Hmm. Thinking more about it. That's actually overkill. For ktime_sec a
32bit value is plenty enough unless we care about systems with more
than 136 years uptime. So if we calculate the seconds value of ktime,
i.e. CLOCK_MONOTONIC, in the update function, we can read it on both
32 and 64bit w/o the seqcount loop.

Where we really need the above readout mechanism is get_seconds() as
that will break in 2038 on 32bit. So there you need to change the
return value from unsigned long to time64_t and change the
implementation as above just xtime_sec instead of ktime_sec.

Thanks,

	tglx
