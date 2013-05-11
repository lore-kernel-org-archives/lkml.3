Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3EKCSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 22:18:00 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35459 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3EKCR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 22:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130511005613.GC13340@somewhere>
References: <1367556468-4021-1-git-send-email-kosaki.motohiro@gmail.com>
 <1367556468-4021-4-git-send-email-kosaki.motohiro@gmail.com> <20130511005613.GC13340@somewhere>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 10 May 2013 22:17:38 -0400
Message-ID: <CAHGf_=rdUFC5coUV4YxPorn8785gzfCL11x6LTAiRKLkMvk3Zg@mail.gmail.com>
Subject: Re: [PATCH 2/7] posix-cpu-timers: fix acounting delta_exec twice
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -250,8 +250,13 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
>>                * values through the TIMER_ABSTIME flag, therefore we have
>>                * to synchronize the timer to the clock every time we start
>>                * it.
>> +              *
>> +              * Do not add the current delta, because
>> +              * account_group_exec_runtime() will also this delta and we
>> +              * wouldn't want to double account time and get ahead of
>> +              * ourselves.
>>                */
>> -             thread_group_cputime(tsk, &sum);
>> +             thread_group_cputime(tsk, false, &sum);
>>               raw_spin_lock_irqsave(&cputimer->lock, flags);
>
> I wonder if we should move thread_group_cputime() inside this lock.
> Otherwise we can miss some updates in-between.

Hmm..

I don't agree with this. Right, we can miss some updates. But 1)
cputimer->lock doesn't
prevent any update update_curr() only take rq_lock, and 2) POSIX timer
and sleeping
semantics allow longer sleep than an argument. Then, the missing is
safe, nobody
can observe which of the timer_setime() syscall and update_curr()
happened earlier.

Ah, I'm now finding when update_gt_cputime() effectively work. It
helps to avoid timer_settime() vs timer_settime() mess.
