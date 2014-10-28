Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaJ1L0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:26:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:46218 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaJ1L0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:26:18 -0400
Date: Tue, 28 Oct 2014 12:26:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v5] timekeeping: Added a function to return tv_sec portion
 of ktime_get_ts64()
In-Reply-To: <12673353.5lG2WgRb0V@wuerfel>
Message-ID: <alpine.DEB.2.11.1410281219360.5308@nanos>
References: <20141025123406.GA13128@heena.com> <12462229.Mz3a4d4AP9@wuerfel> <alpine.DEB.2.11.1410251903000.5308@nanos> <12673353.5lG2WgRb0V@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2014, Arnd Bergmann wrote:
> On Saturday 25 October 2014 19:32:09 Thomas Gleixner wrote:
> > On Sat, 25 Oct 2014, Arnd Bergmann wrote:
> > > On Saturday 25 October 2014 17:22:23 Thomas Gleixner wrote:
> > > > Hmm. Thinking more about it. That's actually overkill. For ktime_sec a
> > > > 32bit value is plenty enough unless we care about systems with more
> > > > than 136 years uptime. So if we calculate the seconds value of ktime,
> > > > i.e. CLOCK_MONOTONIC, in the update function, we can read it on both
> > > > 32 and 64bit w/o the seqcount loop.
> > > 
> > > Ah, very good point. That opens the question which type that function
> > > should return. I really want to remove all uses of time_t from the
> > > kernel, mostly so we know when we're done with this. However as you
> > > say we know that we only need a 32-bit value here. Some possible
> > > ideas:
> > > 
> > > - use time64_t here anyway and accept the slight inefficiency in return
> > >   for clarity
> > 
> > Probably the simplest option.
> > 
> > > - introduce a monotonic_time_t (we probably also want a struct
> > >   monotonic_timespec if we do that) which is basically the old time_t
> > >   but is known to be y2038 safe because we only ever use it to store
> > >   monotonic times.
> > 
> > Not sure whether its worth the trouble.
> 
> We have around 20 drivers using ktime_get_ts() or getrawmonotonic().
> If we had a 'struct monotonic_timespec', we could trivially convert
> them, otherwise we have to look at each one individually to figure
> out what they should use, in particular if they would have noticeably
> worse performance by moving to ktime_get_ts64 or getrawmonotonic64.
> 
> The way to do that would be to add 
> 
> #define monotonic_timespec timespec
> 
> now, and rename timespec to monotonic_timespec after we are done
> converting all other in-kernel users of timespec. There are probably

You can't do that because timespec will have to stay for the "compat"
syscalls.

> a few drivers that today use do_gettimeofday or getnstimeofday that
> could be converted to use ktime_get_ts using a 32-bit
> monotonic_timespec.
> 
> The alternative to that would be to make them all use ktime_t, which
> might be more efficient but also more work to do.

If you touch a file anyway then you better chose the best
solution. The only reason why you want to use the less work option is
if you can do a conversion scripted w/o actually analyzing each
changed file deeply.

> > > - return u32 and use the same type in the callers instead of
> > >   time_t/time64_t/monotonic_time_t.
> > 
> > Works as well. I have no immediate preference.
> 
> I think I like the u32 approach better than ktime_t, but it's a
> very mild preference. I'll wait for your reply on the monotonic_time_t/
> monotonic_timespec comments above. Maybe John has an opinion as well.

You really should look at the call sites and judge based on the
requirements of those.

Thanks,

	tglx
