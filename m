Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3FRPSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:18:05 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40148 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3FRPSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:18:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130618142744.GG17619@somewhere.redhat.com>
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
 <1369604149-13016-9-git-send-email-kosaki.motohiro@gmail.com> <20130618142744.GG17619@somewhere.redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 18 Jun 2013 11:17:41 -0400
Message-ID: <CAHGf_=qhooSDvZVBUqct0B9khTZ-8Ju5YZ7b0yA34=3UgY+OoA@mail.gmail.com>
Subject: Re: [PATCH 6/8] sched: task_sched_runtime introduce micro optimization
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +#ifdef CONFIG_64BIT
>> +     /*
>> +      * 64-bit doesn't need locks to atomically read a 64bit value. So we
>> +      * have two optimization chances, 1) when caller doesn't need
>> +      * delta_exec and 2) when the task's delta_exec is 0. The former is
>> +      * obvious. The latter is complicated. reading ->on_cpu is racy, but
>> +      * this is ok. If we race with it leaving cpu, we'll take a lock. So
>> +      * we're correct. If we race with it entering cpu, unaccounted time
>> +      * is 0. This is indistinguishable from the read occurring a few
>> +      * cycles earlier.
>> +      */
>> +     if (!add_delta || !p->on_cpu)
>> +             return p->se.sum_exec_runtime;
>
> I'm not sure this is correct from an smp ordering POV. p->on_cpu may appear
> to be 0 whereas the task is actually running for a while and p->se.sum_exec_runtime
> can then be past the actual value on the remote CPU.

Quate form Paul's last e-mail

>Stronger:
>
>+#ifdef CONFIG_64BIT
>+       if (!p->on_cpu)
>+               return p->se.sum_exec_runtime;
>+#endif
>
>[ Or !p->on_cpu || !add_delta ].
>
>We can take the racy read versus p->on_cpu since:
>  If we race with it leaving cpu: we take lock, we're correct
>  If we race with it entering cpu: unaccounted time ---> 0, this is
>indistinguishable from the read occurring a few cycles earlier.

That said, even though we got slightly inaccurate current time, we
have no way to
know this is inaccurate. E.g. cpu clock saving feature bring us more
inaccuracy, but
we already live in such world.
