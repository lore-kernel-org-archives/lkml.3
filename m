Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaEZJUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:20:55 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51316 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaEZJUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:20:54 -0400
Message-ID: <5383065E.9030601@linux.vnet.ibm.com>
Date: Mon, 26 May 2014 14:46:14 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 01/11] sched: fix imbalance flag reset
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org> <1400860385-14555-2-git-send-email-vincent.guittot@linaro.org> <5381C70E.3030605@linux.vnet.ibm.com> <CAKfTPtDBZyrJJpUHPZcG9Jf4egneyqQ7TR3QXiR0Wff8ZBkHAw@mail.gmail.com>
In-Reply-To: <CAKfTPtDBZyrJJpUHPZcG9Jf4egneyqQ7TR3QXiR0Wff8ZBkHAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052609-7164-0000-0000-000002002CE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 01:19 PM, Vincent Guittot wrote:
> On 25 May 2014 12:33, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> Hi Vincent,
>>
>> On 05/23/2014 09:22 PM, Vincent Guittot wrote:
>>> The imbalance flag can stay set whereas there is no imbalance.
>>>
>>> Let assume that we have 3 tasks that run on a dual cores /dual cluster system.
>>> We will have some idle load balance which are triggered during tick.
>>> Unfortunately, the tick is also used to queue background work so we can reach
>>> the situation where short work has been queued on a CPU which already runs a
>>> task. The load balance will detect this imbalance (2 tasks on 1 CPU and an idle
>>> CPU) and will try to pull the waiting task on the idle CPU. The waiting task is
>>> a worker thread that is pinned on a CPU so an imbalance due to pinned task is
>>> detected and the imbalance flag is set.
>>> Then, we will not be able to clear the flag because we have at most 1 task on
>>> each CPU but the imbalance flag will trig to useless active load balance
>>> between the idle CPU and the busy CPU.
>>
>> Why do we do active balancing today when there is at-most 1 task on the
>> busiest cpu? Shouldn't we be skipping load balancing altogether? If we
>> do active balancing when the number of tasks = 1, it will lead to a ping
>> pong right?
> 
> That's the purpose of the patch to prevent this useless active load
> balance. When the imbalance flag is set, an active load balance is
> triggered whatever the load balance is because of pinned tasks that
> prevents a balance state.

No I mean this:

sched:Do not continue load balancing when the busiest cpu has one
running task

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>


---
 kernel/sched/fair.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c9617b7..b175333 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6626,6 +6626,8 @@ more_balance:
 			}
 			goto out_balanced;
 		}
+	} else {
+		goto out;
 	}

 	if (!ld_moved) {


}

Regards
Preeti U Murthy
> 
> Vincent
> 
>>
>> Regards
>> Preeti U Murthy
>>
> 

