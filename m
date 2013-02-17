Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab3BQPL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:11:27 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:47479 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab3BQPL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:11:26 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com>
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
Date: Sun, 17 Feb 2013 16:11:24 +0100
Message-ID: <CAFTL4hyTfwAZWz=gMokk5oG3HO8iGh7=FtoNv89CMg_Lm-TPNg@mail.gmail.com>
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

2013/2/15 Linus Torvalds <torvalds@linux-foundation.org>:
> On Fri, Feb 15, 2013 at 9:44 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
>>
>> This commit was designed to increase the probability of hitting the
>> races described in http://lwn.net/Articles/453002/.  These races result
>> in deadlocks involving the runqueue lock (and perhaps also the priority
>> inheritance locks).  And yes, I most certainly should have described
>> this in the commit message.  :-(
>
> Ugh. That particular race seems to be because the softirq handling is
> just crazy, and does the "wakeup_softirqd()" form interrupt context,
> BUT HAS SPECIFICALLY BROKEN THE IRQ COUNTING!
>
> Because it claims to do it from softirq context, which is pure
> garbage. It's not actually in softirq context.
>
> The whole hardirq -> softirq transition seems stupid. I'm sure I made
> some serious mistake in cleaning it up, and there's probably some
> missed tracepoint (or perhaps screwed-up lockdep annotation), but I
> think the hardirq -> softirq preempt thing shoudl be done as an atomic
> preempt downgrade, so that we never have a window of "uhhuh, another
> interrupt can come in between and see us as being in neither). And the
> wakeup_softirqd should be done without playing with preempt count at
> all.
>
> Something like this ENTIRELY UNTESTED patch.
>
> Note: I doubt this patch affects Dave's issue at all, I just started
> looking at that do_softirq code when I read your bug explanation.
>
> Adding random people for kernel/softirq.c to the participants list.
> Comments about the patch? Do note that it's entirely untested, so
> consider it more a RFD than a real patch.. It looks like it adds a lot
> of lines, but most of it is for comments and simplification of the
> logic.

preempt_value_in_interrupt() looks buggy in your patch: it makes
invoke_softirq() returning if (val & HARDIRQ_MASK). But that's always
true since you have moved further the sub_preempt_count(IRQ_EXIT)
further.
