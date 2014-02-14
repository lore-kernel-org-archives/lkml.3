Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaBNBi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:38:58 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33478 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaBNBi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 20:38:57 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrW_Sij=SaXBKZnOBNWTwS359=_ZU97dsb7_6W6VeXja2Q@mail.gmail.com>
References: <20140212201709.GB6835@laptop.programming.kicks-ass.net>
 <218b548b69479baa005af8a7b04a3abbea8ed6fa.1392252790.git.luto@amacapital.net>
 <20140213145016.GA15586@twins.programming.kicks-ass.net> <CALCETrW_Sij=SaXBKZnOBNWTwS359=_ZU97dsb7_6W6VeXja2Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Feb 2014 17:38:36 -0800
Message-ID: <CALCETrUWq_gKtiMuJbuxj+RbJ2fbz4TrQARnH8sUDpvqakCURA@mail.gmail.com>
Subject: Re: [RFC] sched: Add a new lockless wake-from-idle implementation
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:58 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Feb 13, 2014 at 6:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, Feb 12, 2014 at 05:40:12PM -0800, Andy Lutomirski wrote:
>>> This is a strawman proposal to simplify the idle implementation, eliminate
>>> a race
>>>
>>> Benefits over current code:
>>>  - ttwu_queue_remote doesn't use an IPI unless needed
>>>  - The diffstat should speak for itself :)
>>>  - Less racy.  Spurious IPIs are possible, but only in narrow windows or
>>>    when two wakeups occur in rapid succession.
>>>  - Seems to work (?)
>>>
>>> Issues:
>>>  - Am I doing the percpu stuff right?
>>>  - Needs work on non-x86 architectures
>>>  - The !CONFIG_SMP case needs to be checked
>>>  - Is "idlepoll" a good name for the new code?  It doesn't have *that*
>>>    much to do with the idle state.  Maybe cpukick?
>>>
>>> If this turns out okay, TIF_NEED_RESCHED could possibly be deleted as well.
>>
>> No, we can't do away with that; its used in some fairly critical paths
>> (return to userspace) and adding a second cacheline load there would be
>> unfortunate.
>>
>> I also don't really like how the polling state is an atomic; its a cpu
>> local property.
>>
>> Now given we can't get rid of TIF_NEED_RESCHED, and we need an atomic op
>> on a remote cacheline anyhow; the simplest solution would be to convert
>> all TS_POLLING users to TIF_POLLING_NRFLAG and use an atomic_or_return()
>> like construct to do:
>>
>>   atomic_or_return(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG
>>
>> and avoid the IPI if that is false.
>>
>> Something a little like this; it does require a lot of auditing; but it
>> boots on my x86_64.
>>
>> ---
>>  arch/x86/include/asm/mwait.h       | 19 ++++----
>>  arch/x86/include/asm/thread_info.h |  4 +-
>>  arch/x86/kernel/process.c          |  8 ++--
>>  include/linux/sched.h              | 90 +++-----------------------------------
>>  kernel/sched/core.c                | 70 ++++++++++++++++++-----------
>>  kernel/sched/idle.c                | 40 ++++++++---------
>>  kernel/sched/sched.h               |  3 ++
>>  7 files changed, 88 insertions(+), 146 deletions(-)
>
> This patch changes the default from !polling to polling, right?  If
> so, doesn't it break every driver that fails to *clear* the polling
> flag?  (My patch is about to have the same problem.)

I'm playing with making polling be the default and I'm seeing all
kinds of erratic behavior.  Not sure what's going on.  Adding printks
just causes *different* weird behavior.  Sigh.

So no updated patch from me today.

--Andy
