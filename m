Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaEIJ0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:26:53 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:32775 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaEIJ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:26:51 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140509085311.GJ30445@twins.programming.kicks-ass.net>
References: <20140428081858.GX13658@twins.programming.kicks-ass.net>
 <535FA467.2070403@gmail.com> <20140429160441.GU11096@twins.programming.kicks-ass.net>
 <5360D9E5.9080206@gmail.com> <20140430130937.GH30445@twins.programming.kicks-ass.net>
 <20140503124355.5d927080518051ca507bc381@gmail.com> <536735E0.7020204@gmail.com>
 <20140505072114.GY11096@twins.programming.kicks-ass.net> <20140506081636.GA4460@twins.programming.kicks-ass.net>
 <536C907A.1040205@gmail.com> <20140509085311.GJ30445@twins.programming.kicks-ass.net>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 9 May 2014 11:26:30 +0200
Message-ID: <CAKgNAkixNiLjJ4crqfNYFC+cWf7SiKFVUYa+3OZTWMkjZXZO4w@mail.gmail.com>
Subject: Re: sched_{set,get}attr() manpage
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        Dhaval Giani <dhaval.giani@gmail.com>, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Insop Song <insop.song@gmail.com>, liming.wang@windriver.com,
        jkacur@redhat.com, linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, May 9, 2014 at 10:53 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 09, 2014 at 10:23:22AM +0200, Michael Kerrisk (man-pages) wrote:
>> Hi Peter,
>>
>> I'm working on this text. I see the following in kernel/sched/core.c:
>>
>> [[
>> static int __sched_setscheduler(struct task_struct *p,
>>                                 const struct sched_attr *attr,
>>                                 bool user)
>> {
>>         ...
>>
>>         int policy = attr->sched_policy;
>>         ...
>>         if (policy < 0) {
>>                 reset_on_fork = p->sched_reset_on_fork;
>>                 policy = oldpolicy = p->policy;
>> ]]
>>
>> What's a negative policy about? Is this something that should
>> be documented?
>
> That's for sched_setparam(), which internally passes policy = -1, it
> wasn't meant to be user visible, lemme double check that.
>
> sys_sched_setscheduler() -- explicit check for policy < 0
> sys_sched_setparam() -- explicitly passes policy=-1, not user visible

(Ahh -- I missed that piece in sys_sched_setparam())

> sys_sched_setattr() -- hmm, it looks like fail

Yep, I was seeing that there was no check in sched_setatr().

As I recently said, when it comes to writing a man page, show me a new
interface, and I'll show you a bug ;-).

Thanks for the clarification.

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

Cheers,

Michael


> ---
> Subject: sched: Disallow sched_attr::sched_policy < 0
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri May  9 10:49:03 CEST 2014
>
> The scheduler uses policy=-1 to preserve the current policy state to
> implement sys_sched_setparam(), this got exposed to userspace by
> accident through sys_sched_setattr(), cure this.
>
> Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-b4kbwz2qh21xlngdzje00t55@git.kernel.org
> ---
>  kernel/sched/core.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3711,6 +3711,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pi
>         if (sched_copy_attr(uattr, &attr))
>                 return -EFAULT;
>
> +       if (attr.sched_policy < 0)
> +               return -EINVAL;
> +
>         rcu_read_lock();
>         retval = -ESRCH;
>         p = find_process_by_pid(pid);



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
