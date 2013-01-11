Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3AKHHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:07:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:64295 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab3AKHHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:07:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,449,1355126400"; 
   d="scan'208";a="275690235"
Message-ID: <50EFBA7D.5070907@intel.com>
Date: Fri, 11 Jan 2013 15:08:45 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 16/22] sched: add power aware scheduling in fork/exec/wake
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-17-git-send-email-alex.shi@intel.com> <20130110150108.GF2046@e103034-lin>
In-Reply-To: <20130110150108.GF2046@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 11:01 PM, Morten Rasmussen wrote:
> On Sat, Jan 05, 2013 at 08:37:45AM +0000, Alex Shi wrote:
>> This patch add power aware scheduling in fork/exec/wake. It try to
>> select cpu from the busiest while still has utilization group. That's
>> will save power for other groups.
>>
>> The trade off is adding a power aware statistics collection in group
>> seeking. But since the collection just happened in power scheduling
>> eligible condition, the worst case of hackbench testing just drops
>> about 2% with powersaving/balance policy. No clear change for
>> performance policy.
>>
>> I had tried to use rq load avg utilisation in this balancing, but since
>> the utilisation need much time to accumulate itself. It's unfit for any
>> burst balancing. So I use nr_running as instant rq utilisation.
> 
> So you effective use a mix of nr_running (counting tasks) and PJT's
> tracked load for balancing?

no, just task number here.
> 
> The problem of slow reaction time of the tracked load a cpu/rq is an
> interesting one. Would it be possible to use it if you maintained a
> sched group runnable_load_avg similar to cfs_rq->runnable_load_avg where
> load contribution of a tasks is added when a task is enqueued and
> removed again if it migrates to another cpu?
> This way you would know the new load of the sched group/domain instantly
> when you migrate a task there. It might not be precise as the load
> contribution of the task to some extend depends on the load of the cpu
> where it is running. But it would probably be a fair estimate, which is
> quite likely to be better than just counting tasks (nr_running).

For power consideration scenario, it ask task number less than Lcpu
number, don't care the load weight, since whatever the load weight, the
task only can burn one LCPU.

>> +
>> +		if (sched_policy == SCHED_POLICY_POWERSAVING)
>> +			threshold = sgs.group_weight;
>> +		else
>> +			threshold = sgs.group_capacity;
> 
> Is group_capacity larger or smaller than group_weight on your platform?

Guess most of your confusing come from the capacity != weight here.

In most of Intel CPU, a cpu core's power(with 2 HT) is usually 1178, it
just bigger than a normal cpu power - 1024. but the capacity is still 1,
while the group weight is 2.

