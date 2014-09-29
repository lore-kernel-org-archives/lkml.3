Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaI2Nj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:39:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47140 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbaI2NjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:39:24 -0400
Message-ID: <54296109.7020205@arm.com>
Date: Mon, 29 Sep 2014 14:39:21 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "riel@redhat.com" <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Subject: Re: [PATCH v6 5/6] sched: replace capacity_factor by usage
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org> <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
X-OriginalArrivalTime: 29 Sep 2014 13:39:18.0853 (UTC) FILETIME=[C4DAAF50:01CFDBEA]
X-MC-Unique: 114092914392108901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/14 17:08, Vincent Guittot wrote:
> The scheduler tries to compute how many tasks a group of CPUs can handle by
> assuming that a task's load is SCHED_LOAD_SCALE and a CPU capacity is
> SCHED_CAPACITY_SCALE but the capacity_factor is hardly working for SMT system,
> it sometimes works for big cores but fails to do the right thing for little
> cores.
> 
> Below are two examples to illustrate the problem that this patch solves:
> 
> 1 - capacity_factor makes the assumption that max capacity of a CPU is
> SCHED_CAPACITY_SCALE and the load of a thread is always is
> SCHED_LOAD_SCALE. It compares the output of these figures with the sum
> of nr_running to decide if a group is overloaded or not.
> 
> But if the default capacity of a CPU is less than SCHED_CAPACITY_SCALE
> (640 as an example), a group of 3 CPUS will have a max capacity_factor
> of 2 ( div_round_closest(3x640/1024) = 2) which means that it will be
> seen as overloaded if we have only one task per CPU.
> 
> 2 - Then, if the default capacity of a CPU is greater than
> SCHED_CAPACITY_SCALE (1512 as an example), a group of 4 CPUs will have
> a capacity_factor of 4 (at max and thanks to the fix[0] for SMT system
> that prevent the apparition of ghost CPUs) but if one CPU is fully
> used by a rt task (and its capacity is reduced to nearly nothing), the
> capacity factor of the group will still be 4
> (div_round_closest(3*1512/1024) = 5).
> 
> So, this patch tries to solve this issue by removing capacity_factor
> and replacing it with the 2 following metrics :
> -The available CPU's capacity for CFS tasks which is the already used by
> load_balance.
> -The usage of the CPU by the CFS tasks. For the latter, I have
> re-introduced the utilization_avg_contrib which is in the range
> [0..SCHED_CPU_LOAD] whatever the capacity of the CPU is.

IMHO, this last sentence is misleading. The usage of a cpu can be
temporally unbounded (in case a lot of tasks have just been spawned on
this cpu, testcase: hackbench) but it converges very quickly towards a
value between [0..1024]. Your implementation is already handling this
case by capping usage to cpu_rq(cpu)->capacity_orig + 1 .
BTW, couldn't find the definition of SCHED_CPU_LOAD.

[...]

