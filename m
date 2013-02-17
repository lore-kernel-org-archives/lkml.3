Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3BQVCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 16:02:13 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50442 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3BQVCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 16:02:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hx7iX8vZFu7pO5wLSPpEzfMD8K7n0bUsY-wK-uCsDAsEw@mail.gmail.com>
References: <20130212193901.GA18906@redhat.com>
	<alpine.LNX.2.00.1302121549500.890@eggly.anvils>
	<20130213004059.GA14451@redhat.com>
	<alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
	<20130213041629.GA28622@redhat.com>
	<alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
	<20130213193411.GA15928@redhat.com>
	<CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
	<20130215011503.GA11914@redhat.com>
	<CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
	<20130215174435.GA2792@linux.vnet.ibm.com>
	<CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com>
	<CAFTL4hyTfwAZWz=gMokk5oG3HO8iGh7=FtoNv89CMg_Lm-TPNg@mail.gmail.com>
	<CA+55aFz4vO-JGv+A7h=uxwfyWEMcK=Q3gntwHfr=a4OUVs-f+g@mail.gmail.com>
	<CAFTL4hx7iX8vZFu7pO5wLSPpEzfMD8K7n0bUsY-wK-uCsDAsEw@mail.gmail.com>
Date: Sun, 17 Feb 2013 22:02:11 +0100
Message-ID: <CAFTL4hzUy+2qDaCDK3jCUs+6Fe48-uU9KSB+Ssk+-i=zYhqaRg@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/17 Frederic Weisbecker <fweisbec@gmail.com>:
> 2013/2/17 Linus Torvalds <torvalds@linux-foundation.org>:
>> On Sun, Feb 17, 2013 at 7:11 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>
>>> preempt_value_in_interrupt() looks buggy in your patch: it makes
>>> invoke_softirq() returning if (val & HARDIRQ_MASK). But that's always
>>> true since you have moved further the sub_preempt_count(IRQ_EXIT)
>>> further.
>>
>> No, that's not it. The value hasn't been written back yet, but it already did:
>>
>> +       int offset = IRQ_EXIT_OFFSET;
>> +       int count = preempt_count() - offset;
>>
>> so the 'count' has the IRQ_EXIT_OFFSET already subtracted. So no,
>> HARDIRQ_MASK is *not* always set.
>
> Another thing. Perhaps we can push the idea of your patch a little
> further by re-entering HARDIRQ_OFFSET at the end of the softirq
> processing and do the final sub_preempt_count(HARDIRQ_OFFSET) at the
> very end of irq_exit().
>
> This way irq_exit() looks a bit more simple to me: everything there
> becomes considered as in hardirq: (ie: rcu_irq_exit() and
> tick_nohz_irq_exit() won't appear anymore as weird special cases) and
> we get rid of that IRQ_EXIT_OFFSET hack that fixes the CONFIG_PREEMPT
> case.
>
> I'm attaching an untested patch that modify yours. It's probably
> missing some corner cases that rely on in_interrupt() value in
> rcu_irq_exit() and tick_nohz_irq_exit() and may be other things.

I messed up preempt_offset_in_interrupt() with in_atomic() code
instead of in_interrupt(). Anyway the patch is untested and is more
there to get your opinion for now. I'll put some more care on it if
people like it.
