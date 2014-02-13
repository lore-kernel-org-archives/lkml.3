Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaBMRHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:07:32 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:36563 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaBMRHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:07:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140213145016.GA15586@twins.programming.kicks-ass.net>
References: <20140212201709.GB6835@laptop.programming.kicks-ass.net>
 <218b548b69479baa005af8a7b04a3abbea8ed6fa.1392252790.git.luto@amacapital.net> <20140213145016.GA15586@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Feb 2014 09:07:10 -0800
Message-ID: <CALCETrWpDxt1xhBx=CWq-fwSBoCpbC_stoouY2mPX8u4u8XNhQ@mail.gmail.com>
Subject: Re: [RFC] sched: Add a new lockless wake-from-idle implementation
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 6:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Feb 12, 2014 at 05:40:12PM -0800, Andy Lutomirski wrote:
>> This is a strawman proposal to simplify the idle implementation, eliminate
>> a race
>>
>> Benefits over current code:
>>  - ttwu_queue_remote doesn't use an IPI unless needed
>>  - The diffstat should speak for itself :)
>>  - Less racy.  Spurious IPIs are possible, but only in narrow windows or
>>    when two wakeups occur in rapid succession.
>>  - Seems to work (?)
>>
>> Issues:
>>  - Am I doing the percpu stuff right?
>>  - Needs work on non-x86 architectures
>>  - The !CONFIG_SMP case needs to be checked
>>  - Is "idlepoll" a good name for the new code?  It doesn't have *that*
>>    much to do with the idle state.  Maybe cpukick?
>>
>> If this turns out okay, TIF_NEED_RESCHED could possibly be deleted as well.
>
> No, we can't do away with that; its used in some fairly critical paths
> (return to userspace) and adding a second cacheline load there would be
> unfortunate.
>
> I also don't really like how the polling state is an atomic; its a cpu
> local property.

Your patch also makes polling state be an atomic (albeit one that
isn't changed remotely).

>
> Now given we can't get rid of TIF_NEED_RESCHED, and we need an atomic op
> on a remote cacheline anyhow; the simplest solution would be to convert
> all TS_POLLING users to TIF_POLLING_NRFLAG and use an atomic_or_return()
> like construct to do:
>
>   atomic_or_return(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG
>
> and avoid the IPI if that is false.
>
> Something a little like this; it does require a lot of auditing; but it
> boots on my x86_64.

Hmm.

Yours is certainly a simpler change than mine.  I don't see anything
obviously wrong with it.  There are plenty of weird cases in which one
cpu schedules while another cpu is in the new cmpxchg look, but I
suspect that the worst that can happen is that a spurious wakeup later
on.

My patch (assuming that all the kinks get worked out) will probably be
faster -- there's neither an rcu lock nor a cmpxchg.  I'm not
personally inclined to fix up every arch's idle routine, though.

On the subject of major surgery, though: there are very few places in
the kernel where TIF_NEED_RESCHED gets set.  With something like my
patch applied, I think that there is no code at all that sets any
other task's TIF_NEED_RESCHED.  That suggests that all
set_tsk_need_resched callers could just call into the scheduler
directly.  If so, the change could probably delete a whole lot of
assembly code, and every kernel exit would get faster.

--Andy
