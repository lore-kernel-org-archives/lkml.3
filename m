Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbaEMQSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:18:22 -0400
Received: from ns.horizon.com ([71.41.210.147]:47119 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750943AbaEMQSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:18:15 -0400
Date: 13 May 2014 12:18:13 -0400
Message-ID: <20140513161813.15106.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mathieu.desnoyers@efficios.com
Subject: Re: [PATCH 4/4] timekeeping: Use printk_deferred when holding timekeeping seqlock
Cc: john.stultz@linaro.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <822806193.15621.1399988364196.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I was trying to tackle the "hard problem" of making *all* time reads
>> non-blocking, with monotonicity guarantees.  There has to be *some* bound
>> on blocking times (in particular, time between reading hardware tiemrs
>> and translating them to real time), but they can be reasonably long.

> What I gathered from my past discussion with John on this topic is that
> virtualization blows away pretty much any assumption we can make on
> "update should be reasonably short". A virtualized CPU can be preempted
> for a rather long time (AFAIU not possible to bound).

Well, there are two kinds of time reads:

1) "What is the current time now?"  This is easy, because if we stall
   it's okay to return any time in the appropriate window.
2) "Some time in the past I read the hardware clock with value c.
   What is the time in seconds corresponding to that?"

I'll call number 2 "time conversion".  This can be handled as long as the
time between reading the clock and doing the conversion is reasonable.
Otherwise, it'll fail, with "I don't remember that part of the piecewise
clock/time conversion function."

Now, obviously number 1 can be implemented by reading the hardware clock
and converting it.  As you point out, virtualization makes it impossible
to guarantee any reasonable bound on the time between the two steps.
But in case 1, we can easily handle failure by retrying the read.  (Or,
equivalently, returning the earliest time which we know how to convert.)

All we can guarantee in case 1 is that we return the timestamp of some
instant between call and return.  If that time is made very long by
the hypervisor descheduling us, it reduces the required precision.


So it's possible to allow arbirearily long delays in time writes, in
current-time reads, but conversion has a risk of failure.

I don't think it's possible to do better, so that's kind of the limit.

>> I think I have an idea that could work, but given the hairiness of
>> the timeeeping code, implementing it would be a major project.
>
> Indeed, timekeeping is not for the faint of heart. ;-)

But at least it's interesting, with problems other than undocumented bugs
in hardware.
