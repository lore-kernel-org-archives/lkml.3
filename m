Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3IJWIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:08:16 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55526 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3IJWIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:08:15 -0400
Message-ID: <522F984C.2070909@linaro.org>
Date: Tue, 10 Sep 2013 15:08:12 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
References: <10005394.BRCyBMYWy3@tauon> <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com> <20130910203853.GG29237@thunk.org> <522F851D.1040101@linaro.org> <20130910211009.GI29237@thunk.org>
In-Reply-To: <20130910211009.GI29237@thunk.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 02:10 PM, Theodore Ts'o wrote:
> On Tue, Sep 10, 2013 at 01:46:21PM -0700, John Stultz wrote:
>> We do read the clocksource fairly frequently though, so rather then
>> re-reading on each interrupt, could you instead re-use the points at
>> interrupt time where we already read the clocksource, like in
>> hrtimer_interrupt()?
> How often is that time updated?  Is there some documentation whree I
> can understand how this works?  I confess to be pretty ignorant about
> the details of how our time keeping systems work inside Linux.

So its not how often a time is updated, but re-using where we already
read the time. And yea, there's no real documentation as things are
always in transition: ie For hrtimer_interrupt, it depends on config and
hardware, but its every HZ on every cpu, except except on HRT systems,
where it can be more frequent depending on how far away the next hrtimer
is set to expire, and with the idle NOHZ where it may be longer the HZ
on idle cpus. NOHZ_FULL further complicates this to be even more rarely,
but I've not followed that work as closely, so Fredric could probably be
of more help here.

One other area you might look at is using the delta between when the
next hrtimer was scheduled for and when we actually expired it? That's
something we could cheaply calculate on every hrtimer expiration. Though
I probably should be hesitant with my suggestions, as I'm not well
versed in RNG theory.

> Same question for sched_clock(); what are its guarantees, both in
> terms of granularity and cost of overhead.  Is there any comprehensive
> documentation that I should be reading?

No. sched_clock has changed as well over the last few years. 
sched_clock should be more performant then any of the timekeeping calls,
since it has lower correctness requirements, but it may just be backed
by jiffies in some cases.


thanks
-john
