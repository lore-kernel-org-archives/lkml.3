Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaFCJuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:50:24 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:47374 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaFCJuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:50:22 -0400
MIME-Version: 1.0
In-Reply-To: <538C17D6.60100@linux.vnet.ibm.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-12-git-send-email-vincent.guittot@linaro.org>
 <20140529135510.GG11074@laptop.programming.kicks-ass.net> <538C17D6.60100@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 3 Jun 2014 11:50:01 +0200
Message-ID: <CAKfTPtAF+HNzs8B-xP2jPbJ+iJVO2wR0frmZ=EgQs35A_wXyNA@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] sched: replace capacity by activity
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 June 2014 08:21, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> On 05/29/2014 07:25 PM, Peter Zijlstra wrote:
>> On Fri, May 23, 2014 at 05:53:05PM +0200, Vincent Guittot wrote:
>>> The scheduler tries to compute how many tasks a group of CPUs can handle by
>>> assuming that a task's load is SCHED_LOAD_SCALE and a CPU capacity is
>>> SCHED_POWER_SCALE.
>>> We can now have a better idea of the utilization of a group fo CPUs thanks to
>>> group_actitvity and deduct how many capacity is still available.
>>>
>>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>>> ---
>>
>> Right, so as Preeti already mentioned, this wrecks SMT. It also seems to
>> loose the aggressive spread, where we want to run 1 task on each 'core'
>> before we start 'balancing'.
>
> True. I just profiled the ebizzy runs and found that ebizzy threads were
> being packed onto a single core which is SMT-8 capable before spreading.
> This was a 6 core, SMT-8 machine. So for instance if I run 8 threads of
> ebizzy. the load balancing as record by perf sched record showed that
> two cores were packed upto 3 ebizzy threads and one core ran two ebizzy
> threads while the rest of the 3 cores were idle.
>
> I am unable to understand which part of this patch is aiding packing to
> a core.  There is this check in this patch right?
>
> if (sgs->group_capacity < 0)
>                 return true;
>
> which should ideally prevent such packing? Because irrespective of the
> number of SMT threads, the capacity of a core is unchanged. And in the
> above scenario, we have 6 tasks on 3 cores. So shouldn't the above check
> have caught it?

yes, it should. the group_capacity should become < 0 because the CPU
are fully loaded and the activity reach the max capacity value +
nr_running

>
> Regards
> Preeti U Murthy
>>
>> So I think we should be able to fix this by setting PREFER_SIBLING on
>> the SMT domain, that way we'll get single tasks running on each SMT
>> domain before filling them up until capacity.
>>
>> Now, its been a while since I looked at PREFER_SIBLING, and I've not yet
>> looked at what your patch does to it, but it seems to me that that is
>> the first direction we should look for an answer to this.
>>
>
