Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaJ1NVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:21:35 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:64307 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaJ1NVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:21:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v5] timekeeping: Added a function to return tv_sec portion of ktime_get_ts64()
Date: Tue, 28 Oct 2014 14:21:24 +0100
Message-ID: <2648728.72C2VHStFS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410281219360.5308@nanos>
References: <20141025123406.GA13128@heena.com> <12673353.5lG2WgRb0V@wuerfel> <alpine.DEB.2.11.1410281219360.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:KRkLzyRtaI6ZMacx2AlEWRONUCw0BQ+f57phQzw/U58
 G7vQB67BTlCP9dcNX+C3WHnHtU+EucF1qCgqBvL+HnGNZZtpcn
 873iO5vDlcIwpHmDqKd6/8B1wAp1nOItyfi5YgtYEzXJVXpfnr
 5wImJzqHqh8/N1L8MjwaaEESLwjofqHfNckspPC3NEngEW9E5s
 L5PG9B9kAr7u0N3LoYAoNqP00JnEU+dln7DQs4aGXkNIVX3slB
 WgnMbL3s0GTEiBlbJcBC71OC5ViQ5jONdA5TDD8LwW9M3u1wH3
 zyNL6cn6PMkXMggSZdX6jLVvYq2wAA1yvLIHF5lZP+oPEUCcNN
 lymwIs9y7r3Gj9P8DYb4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 12:26:15 Thomas Gleixner wrote:
> On Sun, 26 Oct 2014, Arnd Bergmann wrote:
> > On Saturday 25 October 2014 19:32:09 Thomas Gleixner wrote:
> > > On Sat, 25 Oct 2014, Arnd Bergmann wrote:
> > > > On Saturday 25 October 2014 17:22:23 Thomas Gleixner wrote:
> > > > > Hmm. Thinking more about it. That's actually overkill. For ktime_sec a
> > > > > 32bit value is plenty enough unless we care about systems with more
> > > > > than 136 years uptime. So if we calculate the seconds value of ktime,
> > > > > i.e. CLOCK_MONOTONIC, in the update function, we can read it on both
> > > > > 32 and 64bit w/o the seqcount loop.
> > > > 
> > > > Ah, very good point. That opens the question which type that function
> > > > should return. I really want to remove all uses of time_t from the
> > > > kernel, mostly so we know when we're done with this. However as you
> > > > say we know that we only need a 32-bit value here. Some possible
> > > > ideas:
> > > > 
> > > > - use time64_t here anyway and accept the slight inefficiency in return
> > > >   for clarity
> > > 
> > > Probably the simplest option.
> > > 
> > > > - introduce a monotonic_time_t (we probably also want a struct
> > > >   monotonic_timespec if we do that) which is basically the old time_t
> > > >   but is known to be y2038 safe because we only ever use it to store
> > > >   monotonic times.
> > > 
> > > Not sure whether its worth the trouble.
> > 
> > We have around 20 drivers using ktime_get_ts() or getrawmonotonic().
> > If we had a 'struct monotonic_timespec', we could trivially convert
> > them, otherwise we have to look at each one individually to figure
> > out what they should use, in particular if they would have noticeably
> > worse performance by moving to ktime_get_ts64 or getrawmonotonic64.
> > 
> > The way to do that would be to add 
> > 
> > #define monotonic_timespec timespec
> > 
> > now, and rename timespec to monotonic_timespec after we are done
> > converting all other in-kernel users of timespec. There are probably
> 
> You can't do that because timespec will have to stay for the "compat"
> syscalls.

My plan is to change those to use compat_timespec even on 32-bit systems,
so we have a shared implementation for 32-bit time syscalls on both 32-bit
native compat-time and 64-bit compat compat-time ABIs.

> > a few drivers that today use do_gettimeofday or getnstimeofday that
> > could be converted to use ktime_get_ts using a 32-bit
> > monotonic_timespec.
> > 
> > The alternative to that would be to make them all use ktime_t, which
> > might be more efficient but also more work to do.
> 
> If you touch a file anyway then you better chose the best
> solution. The only reason why you want to use the less work option is
> if you can do a conversion scripted w/o actually analyzing each
> changed file deeply.
>
> > > > - return u32 and use the same type in the callers instead of
> > > >   time_t/time64_t/monotonic_time_t.
> > > 
> > > Works as well. I have no immediate preference.
> > 
> > I think I like the u32 approach better than ktime_t, but it's a
> > very mild preference. I'll wait for your reply on the monotonic_time_t/
> > monotonic_timespec comments above. Maybe John has an opinion as well.
> 
> You really should look at the call sites and judge based on the
> requirements of those.


I looked at most users of do_gettimeofday and getnstimeofday now. About
half of them actually want wall-clock and need 64-bit time_t.

The others seem to all be in the category that should be converted to
ktime_t anyway. Let's forget about monotonic_timespec then.

One interface that we may want to add however is something that either
provides the difference between two ktime_t in milliseconds/microseconds/
nanoseconds, or provides the elapsed time since a previous ktime_t.

One or more of these

static inline s64 ktime_sub_divns(ktime_t new, ktime_t old, unsigned long unit)
{
	return ktime_divns(ktime_sub(new, old), unit);
}

static inline s64 ktime_diff_ms(ktime_t new, ktime_t old)
{
	return ktime_divns(ktime_sub(new, old), MSEC_PER_NSEC);
}

static inline s64 ktime_diff_us(ktime_t new, ktime_t old)
{
	return ktime_divns(ktime_sub(new, old), USEC_PER_NSEC);
}

static inline s64 ktime_expired_us(ktime_t old)
{
	return ktime_divns(ktime_sub(ktime_get(), old), USEC_PER_NSEC);
}

After some more discussion with Heena, I actually realized that we
might not need a new get_seconds() replacement at all: get_seconds()
returns an "unsigned long" number of seconds, and the current definition
means that it's good until 2106, not just 2038.

So my current line of thinking now is that we should not even bother
introducing ktime_get_real_seconds() but instead only audit the users
of get_seconds() to ensure they don't assign the returned value to
a time_t but use either time64_t or unsigned long as the local variable.

For consistency, ktime_get_seconds() should then also return
'unsigned long'.

	Arnd
