Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423518Ab3FURaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:30:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:38242 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423122Ab3FURaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:30:14 -0400
X-IronPort-AV: E=Sophos;i="4.87,914,1363132800"; 
   d="scan'208";a="32722127"
Message-ID: <51C48DA3.4010307@citrix.com>
Date: Fri, 21 Jun 2013 18:30:11 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] hrtimers: provide a hrtimers_late_resume() call
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-2-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210947410.4013@ionos.tec.linutronix.de> <51C447E3.9030009@citrix.com> <alpine.DEB.2.02.1306211610100.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306211610100.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/13 15:32, Thomas Gleixner wrote:
> On Fri, 21 Jun 2013, David Vrabel wrote:
>> On 21/06/13 08:53, Thomas Gleixner wrote:
>>> This is the completely wrong approach. If an architecture does not
>>> shut down the non boot cpus on suspend, then this wants to be handled
>>> in the core code and not in some random arch specific driver.
>>
>> Agreed.  Does the following meet your requirements?
> 
> Indeed. That's looks way more reasonable. Though...
> 
>> hrtimers_resume() cannot call on_each_cpu(retrigger_next_event,...)
>> as the other CPUs will be stopped with IRQs disabled.  Instead, defer
>> the call to the next softirq.
> 
> that's just working by chance and not by design as there is no
> guarantee that the next interrupt, which invokes the softirq, will
> arrive in time. So you want to make sure that an interrupt arrives.

That is a good point.

> Invoking retrigger_next_event(NULL) from hrtimer_resume() should do
> the trick.

But I'm not sure that would be sufficient, although I may not be
understanding how the hrtimers work or are used.

There may be timers on other CPUs that are supposed to fire earlier than
those on the current CPU.  There may even be no timers scheduled on the
current CPU.

I think there needs to be something like:

hrtimers_resume()
{
    retrigger_next_event(NULL);

    /* Timers on other CPUs might expire earlier.
       Program an earlier event and use this to kick the softirq to
       correctly reprogram the events on the other CPUs. */
    expires_next = cpu_base->expires_next;
    for_each_online_cpu(cpu) {
        expires = hrtimers_next_event_on_cpu(cpu)
        if (expires < expires_next)
            expires_next = expires;
   }
   tick_program_event(expires_next, 1);
   cpu_base->clock_was_set = 1;
   __raise_softirq_irqoff(HRTIMER_SOFTIRQ);
}

However, since hrtimers require the use of a one-shot ticker and when
one-shot timers are resumed they are armed to fire immediately (see
tick_resume_oneshot()) this interrupt is sufficient to kick the require
softirq.

So, as proposed before:

hrtimers_resume()
{
   /* This CPU's tick is armed to fire immediately by
      tick_oneshot_resume(). Just need raise a softirq to program
      the timers on all CPUs. */
   cpu_base->clock_was_set = 1;
   __raise_softirq_irqoff(HRTIMER_SOFTIRQ);
}

Do you agree or disagree?

David
