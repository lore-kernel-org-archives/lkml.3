Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3IKAbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:31:49 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53266 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3IKAbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:31:48 -0400
Message-ID: <522FB9F1.3070905@linaro.org>
Date: Tue, 10 Sep 2013 17:31:45 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
References: <10005394.BRCyBMYWy3@tauon> <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com> <20130910203853.GG29237@thunk.org> <522F851D.1040101@linaro.org> <20130910211009.GI29237@thunk.org> <522F984C.2070909@linaro.org> <20130910223326.GD11063@thunk.org>
In-Reply-To: <20130910223326.GD11063@thunk.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 03:33 PM, Theodore Ts'o wrote:
> On Tue, Sep 10, 2013 at 03:08:12PM -0700, John Stultz wrote:
>> One other area you might look at is using the delta between when the
>> next hrtimer was scheduled for and when we actually expired it? That's
>> something we could cheaply calculate on every hrtimer expiration. Though
>> I probably should be hesitant with my suggestions, as I'm not well
>> versed in RNG theory.
> What we need is a time source which whose granularity is substantially
> finer-grained that the rate at which interrupts are delievered to the
> system (preferably by a factor at least 8 or 16).  It also needs to be
> fast enough (since we will be calling it on every single interrupt)
> that the overhead doesn't cause architecture maintainers to break out
> their torches and pitchforks and come looking for me.  :-)

Yea, that point about "every single interrupt" vs "every timer
interrupt". I suspect that if its every timer interrupt, this can be
done easily w/ clocksources as we already do that read, but every single
interrupt would have potential problems with various other devices with
high irq frequency.



> Reading from a cycle counter is therefore ideal; it doesn't need to be
> synchronized across CPU's, and I don't care if it gets stops ticking
> when the system is suspended, and I don't care if the rate at which it
> increment is dependent on CPU clock speed getting jacked up and down
> for by power management systems.  (And in fact, if it's going to cost
> extra overhead to correct for the CPU being suspended or running at a
> 1.6 MHz instead of 2.8 MHz, that's a bug, not a feature.)  We just
> need something fine-grained.
Right so get_cycles() really sounds like the right thing here.

Although I wonder if you run into issues with counters that wrap
quickly? Or does that not matter?


> The problem is what do we do on platforms that don't have a cycle
> counter.  Stephan Mueller has proposed using the "best" clocksource as
> a default fallback.  Which might be OK, but I still remember that
> really, REALLY angry customer who discovered that gettimeofday() was
> breathtakingly slow on an IBM X440 (at least, when they were calling
> it at super high rates).
Yea, I'm familiar with that box. :)


> I just have no idea what various clock sources might do on different
> architectures, and if many of the more older ones (i.e., sparc 32,
> m32, h8, etc.) are just going to fall back to jiffies, I'm not sure
> it's worth it.

Right. In many cases jiffies is all that we have. Thus the check for
timekeeping_valid_for_hres() can be used to at least flag that case. Not
that I know what you want to do if it comes up false.

thanks
-john

