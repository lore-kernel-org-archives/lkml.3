Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaLOH0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:26:06 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49546 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaLOH0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:26:01 -0500
Message-ID: <548E8D01.9050707@linux.vnet.ibm.com>
Date: Mon, 15 Dec 2014 12:55:53 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com> <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
In-Reply-To: <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121507-0009-0000-0000-000007256981
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Let me explain why I think this is happening.

1. tick_nohz_irq_enter/exit() both get called *only if the cpu is idle*
and receives an interrupt.

2. Commit 2a16fc93d2c9568e1, cancels programming of tick_sched timer
in its handler, assuming that tick_nohz_irq_exit() will take care of
programming the clock event device appropriately, and hence it would
requeue or cancel the tick_sched timer.

3. But the intel_powerclamp driver injects an idle period only.
*The CPU however is not idle*. It has work on its runqueue and the
rq->curr != idle. This means that *tick_nohz_irq_enter()/exit() will not
get called on any interrupt*.

4. As a consequence, when we get a hrtimer interrupt during the period
that the powerclamp driver is mimicking idle, the exit path of the
interrupt never calls tick_nohz_irq_exit(). Hence the tick_sched timer
that would have got removed due to the above commit will not get
enqueued back on for any pending timers that there might be. Besides
this, *jiffies never gets updated*.

5. If you look at the code of the powerclamp driver, clamp_thread()
loops on jiffies getting updated. It continues to do so with preemption
disabled and no tick_sched timer to force a scheduler tick to update the
jiffies. Since this happens on cpus in a package, all of them get soft
lockedup.

Hope the above explanation makes sense.

Regards
Preeti U Murthy

On 12/12/2014 05:27 PM, Viresh Kumar wrote:
> Cc'ing Thomas as well..
> 
> On 12 December 2014 at 01:12, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> Hi Viresh,
>>
>> We noticed the below lockup regression on commit 2a16fc93d2c ("nohz:
>> Avoid tick's double reprogramming in highres mode").
>>
>> testbox/testcase/testparams: ivb42/idle-inject/60s-200%-10cp
>>
>> b5e995e671d8e4d7  2a16fc93d2c9568e16d45db77c
>> ----------------  --------------------------
>>        fail:runs  %reproduction    fail:runs
>>            |             |             |
>>            :5          100%           1:1     last_state.is_incomplete_run
>>            :5          100%           1:1     last_state.running
>>
>> testbox/testcase/testparams: lkp-sb03/idle-inject/60s-200%-10cp
>>
>> b5e995e671d8e4d7  2a16fc93d2c9568e16d45db77c
>> ----------------  --------------------------
>>            :7          100%           1:1     last_state.is_incomplete_run
>>            :7          100%           1:1     last_state.running
>>
>> Where test box ivb42 is Ivy Bridge-EP and lkp-sb03 is Sandy Bridge-EP.
>>
>> To reproduce:
>>
>>         apt-get install ruby ruby-oj
>>         git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
>>         cd lkp-tests
>>         bin/setup-local job.yaml # the job file attached in this email
>>         bin/run-local   job.yaml
>>
>> Basically what the test case does is to
>>
>> - find a Sandy Bridge or newer machine
>> - look for a cooling device with type “intel_powerclamp”
>> - set cur_state to 10
>> - run any CPU extensive workload
>>
>> Then expect soft lockup. It's very reproducible.
> 
> Thanks Fengguang. Yes I am able to reproduce it, but don't know yet what
> went wrong..
> 
> --
> viresh
> 

