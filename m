Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3DZOXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:23:15 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:51186 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3DZOXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:23:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130426130835.GA13964@dyad.programming.kicks-ass.net>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
	<1366910611-20048-8-git-send-email-vincent.guittot@linaro.org>
	<20130426130835.GA13964@dyad.programming.kicks-ass.net>
Date: Fri, 26 Apr 2013 16:23:10 +0200
Message-ID: <CAKfTPtCCX+wue+EupB=0firvaA8mZAFpGwtPOb43BUCNKOfJxg@mail.gmail.com>
Subject: Re: [PATCH 07/14] sched: agressively pack at wake/fork/exec
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 15:08, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Apr 25, 2013 at 07:23:23PM +0200, Vincent Guittot wrote:
>> According to the packing policy, the scheduler can pack tasks at different
>> step:
>> -SCHED_PACKING_NONE level: we don't pack any task.
>> -SCHED_PACKING_DEFAULT: we only pack small tasks at wake up when system is not
>> busy.
>> -SCHED_PACKING_FULL: we pack tasks at wake up until a CPU becomes full. During
>> a fork or a exec, we assume that the new task is a full running one and we
>> look for an idle CPU close to the buddy CPU.
>
> This changelog is very short on explaining how it will go about achieving these
> goals.

I could move some explanation of the cover letter inside the commit :
 In this case, the CPUs pack their tasks in their buddy until they
becomes full. Unlike
the previous step, we can't keep the same buddy so we update it during load
balance. During the periodic load balance, the scheduler computes the activity
of the system thanks the runnable_avg_sum and the cpu_power of all CPUs and
then it defines the CPUs that will be used to handle the current activity. The
selected CPUs will be their own buddy and will participate to the default
load balancing mecanism in order to share the tasks in a fair way, whereas the
not selected CPUs will not, and their buddy will be the last selected CPU.
The behavior can be summarized as: The scheduler defines how many CPUs are
required to handle the current activity, keeps the tasks on these CPUS and
perform normal load balancing

>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c |   47 ++++++++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 42 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 98166aa..874f330 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3259,13 +3259,16 @@ static struct sched_group *
>>  find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>
>

A task that wakes up will be caught by the function check_pack_buddy
in order to stay in the CPUs that participates to the packing effort.
We will use the find_idlest_group only for fork/exec tasks which are
considered as full running tasks so we looks for the idlest CPU close
to the buddy.

> So for packing into power domains, wouldn't you typically pick the busiest non-
> full domain to fill from other non-full?
>
> Picking the idlest non-full seems like it would generate a ping-pong or not
> actually pack anything.
