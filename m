Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaJYSst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:48:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:50857 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaJYSsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:48:47 -0400
Date: Sat, 25 Oct 2014 19:32:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v5] timekeeping: Added a function to return tv_sec portion
 of ktime_get_ts64()
In-Reply-To: <12462229.Mz3a4d4AP9@wuerfel>
Message-ID: <alpine.DEB.2.11.1410251903000.5308@nanos>
References: <20141025123406.GA13128@heena.com> <alpine.DEB.2.11.1410251705550.5308@nanos> <alpine.DEB.2.11.1410251714460.5308@nanos> <12462229.Mz3a4d4AP9@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014, Arnd Bergmann wrote:
> On Saturday 25 October 2014 17:22:23 Thomas Gleixner wrote:
> > Hmm. Thinking more about it. That's actually overkill. For ktime_sec a
> > 32bit value is plenty enough unless we care about systems with more
> > than 136 years uptime. So if we calculate the seconds value of ktime,
> > i.e. CLOCK_MONOTONIC, in the update function, we can read it on both
> > 32 and 64bit w/o the seqcount loop.
> 
> Ah, very good point. That opens the question which type that function
> should return. I really want to remove all uses of time_t from the
> kernel, mostly so we know when we're done with this. However as you
> say we know that we only need a 32-bit value here. Some possible
> ideas:
> 
> - use time64_t here anyway and accept the slight inefficiency in return
>   for clarity

Probably the simplest option.

> - introduce a monotonic_time_t (we probably also want a struct
>   monotonic_timespec if we do that) which is basically the old time_t
>   but is known to be y2038 safe because we only ever use it to store
>   monotonic times.

Not sure whether its worth the trouble.

> - return u32 and use the same type in the callers instead of
>   time_t/time64_t/monotonic_time_t.

Works as well. I have no immediate preference.
 
> > Where we really need the above readout mechanism is get_seconds() as
> > that will break in 2038 on 32bit. So there you need to change the
> > return value from unsigned long to time64_t and change the
> > implementation as above just xtime_sec instead of ktime_sec.
> 
> Heena already posted a first draft of that patch to the opw internal
> mailing list, I found a small issue that needs to be resolved and
> then she can post the new version to you for review.

Great!

Thanks,

	tglx
