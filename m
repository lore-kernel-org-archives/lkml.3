Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaGJJOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:14:55 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38221 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaGJJOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:14:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140709104332.GS19379@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-2-git-send-email-vincent.guittot@linaro.org>
 <53BB61E9.80200@linux.vnet.ibm.com> <CAKfTPtA8BVPtRRLzomqnGp7_uaSbFYmFTrrt4fpQTOb7qyjddg@mail.gmail.com>
 <53BCBD0E.2070609@linux.vnet.ibm.com> <20140709104332.GS19379@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 10 Jul 2014 11:14:29 +0200
Message-ID: <CAKfTPtB-S=9irbZUVnr6zn3XTix2NDep_d+0FtDNRaB-x78_Vw@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] sched: fix imbalance flag reset
To: Peter Zijlstra <peterz@infradead.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 12:43, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jul 09, 2014 at 09:24:54AM +0530, Preeti U Murthy wrote:

[snip]

>
>> Continuing with the above explanation; when LBF_ALL_PINNED flag is
>> set,and we jump to out_balanced, we clear the imbalance flag for the
>> sched_group comprising of cpu0 and cpu1,although there is actually an
>> imbalance. t2 could still be migrated to say cpu2/cpu3 (t2 has them in
>> its cpus allowed mask) in another sched group when load balancing is
>> done at the next sched domain level.
>
> And this is where Vince is wrong; note how
> update_sg_lb_stats()/sg_imbalance() uses group->sgc->imbalance, but
> load_balance() sets: sd_parent->groups->sgc->imbalance, so explicitly
> one level up.
>

I forgot this behavior when studying preeti use case

> So what we can do I suppose is clear 'group->sgc->imbalance' at
> out_balanced.
>
> In any case, the entirely of this group imbalance crap is just that,
> crap. Its a terribly difficult situation and the current bits more or
> less fudge around some of the common cases. Also see the comment near
> sg_imbalanced(). Its not a solid and 'correct' anything. Its a bunch of
> hacks trying to deal with hard cases.
>
> A 'good' solution would be prohibitively expensive I fear.

I have tried to summarized several use cases that have been discussed
for this patch

The 1st use case is the one that i described in the commit message of
this patch: If we have a sporadic imbalance that set the imbalance
flag, we don't clear it after and it generates spurious and useless
active load balance

Then preeti came with the following use case :
we have a sched_domain made of CPU0 and CPU1 in 2 different sched_groups
2 tasks A and B are on CPU0, B can't run on CPU1, A is the running task.
When CPU1's sched_group is doing load balance, the imbalance should be
set. That's still happen with this patchset because the LBF_ALL_PINNED
flag will be cleared thanks to task A.

Preeti also explained me the following use cases on irc:

If we have both tasks A and B that can't run on CPU1, the
LBF_ALL_PINNED will stay set. As we can't do anything, we conclude
that we are balanced, we go to out_balanced and we clear the imbalance
flag. But we should not consider that as a balanced state but as a all
tasks pinned state instead and we should let the imbalance flag set.
If we now have 2 additional CPUs which are in the cpumask of task A
and/or B at the parent sched_domain level , we should migrate one task
in this group but this will not happen (with this patch) because the
sched_group made of CPU0 and CPU1 is not overloaded (2 tasks for 2
CPUs) and the imbalance flag has been cleared as described previously.

I'm going to send a new revision of the patchset with the correction

Vincent
