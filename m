Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab3BMPmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:42:08 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:44284 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176Ab3BMPmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:42:05 -0500
MIME-Version: 1.0
In-Reply-To: <511BADE3.4050009@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
 <1358996820-23036-8-git-send-email-alex.shi@intel.com> <1360664784.4485.17.camel@laptop>
 <511BADE3.4050009@intel.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 13 Feb 2013 07:41:32 -0800
Message-ID: <CAPM31RJw7a-+QNRwwukg3h3bHCQs++cnT3DgCyHaJTZY7qDsXA@mail.gmail.com>
Subject: Re: [patch v4 07/18] sched: set initial load avg of new forked task
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, namhyung@kernel.org,
        efault@gmx.de, vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 7:14 AM, Alex Shi <alex.shi@intel.com> wrote:
> On 02/12/2013 06:26 PM, Peter Zijlstra wrote:
>> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>>> +       /*
>>> +        * set the initial load avg of new task same as its load
>>> +        * in order to avoid brust fork make few cpu too heavier
>>> +        */
>>> +       if (flags & ENQUEUE_NEWTASK)
>>> +               se->avg.load_avg_contrib = se->load.weight;
>>
>> I seem to have vague recollections of a discussion with pjt where we
>> talk about the initial behaviour of tasks; from this haze I had the
>> impression that new tasks should behave like full weight..
>>
>
> Here just make the new task has full weight..
>
>> PJT is something more fundamental screwy?
>>

So tasks get the quotient of their runnability over the period.  Given
the period initially is equivalent to runnability it's definitely the
*intent* to start at full-weight and ramp-down.

Thinking on it, perhaps this is running a-foul of amortization -- in
that we only recompute this quotient on each 1024ns boundary; perhaps
in the fork-bomb case we're too slow to accumulate these.

Alex, does something like the following help?  This would force an
initial __update_entity_load_avg_contrib() update the first time we
see the task.

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1dff78a..9d1c193 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1557,8 +1557,8 @@ static void __sched_fork(struct task_struct *p)
  * load-balance).
  */
 #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
-       p->se.avg.runnable_avg_period = 0;
-       p->se.avg.runnable_avg_sum = 0;
+       p->se.avg.runnable_avg_period = 1024;
+       p->se.avg.runnable_avg_sum = 1024;
 #endif
 #ifdef CONFIG_SCHEDSTATS
        memset(&p->se.statistics, 0, sizeof(p->se.statistics));



>
>
> --
> Thanks
>     Alex
