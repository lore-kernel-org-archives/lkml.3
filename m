Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaKDNbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:31:06 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62784 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKDNbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:31:03 -0500
Message-ID: <5458D506.4080702@gmail.com>
Date: Tue, 04 Nov 2014 21:30:46 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] sched/deadline: support dl task migrate during cpu
 hotplug
References: <1414740497-7232-1-git-send-email-wanpeng.li@linux.intel.com> <20141103104111.GA23531@worktop.programming.kicks-ass.net> <20141103235747.GA26702@kernel> <20141104083225.GG10501@worktop.programming.kicks-ass.net> <20141104082345.GA22062@kernel> <20141104101022.GH10501@worktop.programming.kicks-ass.net>
In-Reply-To: <20141104101022.GH10501@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
On 14/11/4 下午6:10, Peter Zijlstra wrote:
> On Tue, Nov 04, 2014 at 04:23:45PM +0800, Wanpeng Li wrote:
>> On Tue, Nov 04, 2014 at 09:32:25AM +0100, Peter Zijlstra wrote:
>>> On Tue, Nov 04, 2014 at 07:57:48AM +0800, Wanpeng Li wrote:
>>>> On Mon, Nov 03, 2014 at 11:41:11AM +0100, Peter Zijlstra wrote:
>>>>> On Fri, Oct 31, 2014 at 03:28:17PM +0800, Wanpeng Li wrote:
>>>>> So what is wrong with making dl_task_timer() deal with it? The timer
>>>>> will still fire on the correct time, canceling it and or otherwise
>>>>> messing with the CBS is wrong. Once it fires, all we need to do is
>>>>> migrate it to another cpu (preferably one that is still online of course
>>>>> :-).
>>>> Do you mean what I need to do is push the task to another cpu in dl_task_timer()
>>>> if rq is offline?
>>> That does indeed appear to be the sensible fix to me.
>>>
>>>> In addition, what will happen if dl task can't preempt on
>>>> another cpu?
>>> So if we find that the rq the task was on is no longer available, we
>>> need to select a new rq, the 'right' rq would be the one running the
>>> latest deadline.
>>>
>>> If it cannot preempt the latest (running) deadline, it was not eligible
>>> for running in the first place so no worries, right?
>> I think this will lead to this deadline task cannot running on any rqs any more.
>> If my understanding is not right, when it will be picked?
> So you unconditionally place it on the rq with the latest deadline. If
> it cannot preempt, at least its on an online cpu. It will get scheduled
> whenever its deadline is one of the N earliest, with N the number of
> online CPUs.

If something like this make sense?

(Will test it tomorrow and send out a formal one)
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f3d7776..dac33d1 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -553,6 +553,41 @@ again:
push_dl_task(rq);
#endif
}
+
+ /*
+ * So if we find that the rq the task was on is no longer
+ * available, we need to select a new rq, the 'right' rq
+ * would be the one running the latest deadline.
+ *
+ * If it cannot preempt, at least it's on an online cpu. It
+ * will get scheduled whenever its deadline is one of the N
+ * earliest, with N the number of online CPUs.
+ */
+
+ if (!rq->online) {
+ struct rq *latest_rq = NULL;
+ int cpu;
+ u64 dmin = LONG_MAX;
+
+ for_each_cpu(cpu, &p->cpus_allowed)
+ if (cpu_online(cpu) &&
+ cpu_rq(cpu)->dl.earliest_dl.curr < dmin) {
+ latest_rq = cpu_rq(cpu);
+ dmin = latest_rq->dl.earliest_dl.curr;
+ }
+
+ if (!latest_rq)
+ goto unlock;
+
+ raw_spin_lock(&latest_rq->lock);
+
+ deactivate_task(rq, p, 0);
+ set_task_cpu(p, latest_rq->cpu);
+ activate_task(latest_rq, p, 0);
+
+ raw_spin_unlock(&latest_rq->lock);
+ }
+
unlock:
raw_spin_unlock(&rq->lock);

Regards,
Wanpeng Li

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

