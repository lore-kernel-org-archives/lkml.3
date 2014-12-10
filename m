Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbaLJO7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:59:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:54112 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbaLJO7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:59:08 -0500
Date: Wed, 10 Dec 2014 15:59:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Santosh Shukla <santosh.shukla@linaro.org>
cc: fweisbec@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        preeti@linux.vnet.ibm.com, daniel.lezcano@linaro.org,
        Kevin Hilman <khilman@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Query] Spurious interrupts from clockevent device on X86
 Ivybridge
In-Reply-To: <CA+iXiiOhPxvJKR5-9U_9Hd6mOnXJadBS+WRZhtv3yPw2r8KgJQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412101539200.13233@nanos>
References: <CA+iXiiOhPxvJKR5-9U_9Hd6mOnXJadBS+WRZhtv3yPw2r8KgJQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Santosh Shukla wrote:
> The causes I could find:
> - Clockevent device's counter overflow: When we need to program a clockevt
>   device for times larger than it can handle, we program it for max time and
>   then reprogram again on expiration. Because of hardware counter limitations we
>   have to do it this way and this isn't really a spurious interrupt as we
>   programmed it that way.
> 
> - Hardware timer firing before its expiration: Yes, its hard to digest but from
>   my tests it looks like this does happen. Will circulate another mail once I am
>   sure about it.

Nothing we can do about.
 
> - Difference between time returned by hrtimer_update_base() and clockevt
>   device's notion of time: Wanted to discuss this here..

The clock event device and the clock source can run at different
frequencies. So the conversion from nsec to event ticks can cause
slight errors which are only observable when the delta gets larger.

The clock event device conversion from nsecs to timer ticks is
calculated at setup time once. It's known to be not completely
precise.

The clock source conversion which we use for reading time can be
changed by recalibration (we do that for TSC) and by NTP adjustments.

So even if we would calibrate the clock event device better, then we
still would need to take the NTP adjustments into account. And given
the zoo of timers we have, certainly not a trivial exercise.

Need to think about a bit more.

Thanks,

	tglx




