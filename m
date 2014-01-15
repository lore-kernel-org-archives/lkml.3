Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaAOJW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:22:56 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:37071 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaAOJWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:22:49 -0500
Date: Wed, 15 Jan 2014 10:22:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: raistlin@linux.it, juri.lelli@gmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
Message-ID: <20140115092245.GA15190@gmail.com>
References: <52D64676.4040000@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D64676.4040000@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> 
> Hi all,
> 
> I use the tip/sched/core branch.
> 
> After git pulling yesterday, my host is unresponsive after booting the OS.
> 
>  * It boots normally
>  * It sends info to the console
>  * The graphics does not work
>  * The terminals show the prompt, I can enter the username but after
> pressing enter, it does not give the password prompt
>  * sysrq works more or less, I can't get the process stack but it
> receives the command
> 
> It is like no new process can be created.
> 
> I have a dual Xeon processor E5325 (2 x 4 cores).
> 
> After git bisecting, the following patch seems to introduce the bug.
> 
> commit d50dde5a10f305253cbc3855307f608f8a3c5f73
> Author: Dario Faggioli <raistlin@linux.it>
> Date:   Thu Nov 7 14:43:36 2013 +0100
> 
>     sched: Add new scheduler syscalls to support an extended
> scheduling parameters ABI
> 
>     Add the syscalls needed for supporting scheduling algorithms
>     with extended scheduling parameters (e.g., SCHED_DEADLINE).
> 
> 
> [ ... ]
> 
> 
>     Signed-off-by: Dario Faggioli <raistlin@linux.it>
>     [ Rewrote to use sched_attr. ]
>     Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
>     [ Removed sched_setscheduler2() for now. ]
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Link: http://lkml.kernel.org/r/1383831828-15501-3-git-send-email-juri.lelli@gmail.com
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>

I checked this patch again, and noticed a few oddities:

1)

There's this change to __setscheduler():

-__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
+/* Actually do priority change: must hold pi & rq lock. */
+static void __setscheduler(struct rq *rq, struct task_struct *p,
+                          const struct sched_attr *attr)
 {
+       int policy = attr->sched_policy;
+
        p->policy = policy;
-       p->rt_priority = prio;
+
+       if (rt_policy(policy))
+               p->rt_priority = attr->sched_priority;
+       else
+               p->static_prio = NICE_TO_PRIO(attr->sched_nice);
+


doesnt this change keep p->rt_priority uninitialized in the 
normalize_task() case?

I.e. rt_priority should still be set unconditionally. In the 
SCHED_NORMAL case that will be a zero initialization.

2)

It's not clear why this change to __setscheduler() was done:

        /*
         * Allow unprivileged RT tasks to decrease priority:
         */
        if (user && !capable(CAP_SYS_NICE)) {
+               if (fair_policy(policy)) {
+                       if (!can_nice(p, attr->sched_nice))
+                               return -EPERM;
+               }
+
                if (rt_policy(policy)) {


3)

On ARM:

-#define __NR_syscalls  (380)
+#define __NR_syscalls  (384)

but:

 #define __NR_finit_module              (__NR_SYSCALL_BASE+379)
+#define __NR_sched_setattr             (__NR_SYSCALL_BASE+380)
+#define __NR_sched_getattr             (__NR_SYSCALL_BASE+381)
 
 /*


Why is the syscall table increased by 4, while we only add 2 new 
syscalls?

4)

In hindsight this patch should have been 3 patches or so:

 - one that just mechanically extends __setscheduler() with an 'attr' 
   way to pass parameters

 - one that adds whatever other desired changes to __setscheduler(), 
   with an explanation.

 - one that adds the new syscalls.

Which would ease the debugging of such bugs.

Thanks,

	Ingo
