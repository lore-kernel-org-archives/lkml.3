Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888Ab3GQRxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:53:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964825Ab3GQRxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:53:31 -0400
Message-ID: <51E6D9B7.1030705@redhat.com>
Date: Wed, 17 Jul 2013 13:51:51 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too frequently
References: <1374002463.3944.11.camel@j-VirtualBox> <20130716202015.GX17211@twins.programming.kicks-ass.net> <1374014881.2332.21.camel@j-VirtualBox> <20130717072504.GY17211@twins.programming.kicks-ass.net> <1374048701.6000.21.camel@j-VirtualBox> <20130717093913.GP23818@dyad.programming.kicks-ass.net> <1374076741.7412.35.camel@j-VirtualBox> <20130717161815.GR23818@dyad.programming.kicks-ass.net>
In-Reply-To: <20130717161815.GR23818@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 12:18 PM, Peter Zijlstra wrote:
> On Wed, Jul 17, 2013 at 08:59:01AM -0700, Jason Low wrote:
>>

>> Do you think its worth a try to consider each newidle balance attempt as
>> the total load_balance attempts until it is able to move a task, and
>> then skip balancing within the domain if a CPU's avg idle time is less
>> than that avg time doing newidle balance?
>
> So the way I see things is that the only way newidle balance can slow down
> things is if it runs when we could have ran something useful.

Due to contention on the runqueue locks of other CPUs,
newidle also has the potential to keep _others_ from
running something useful.

> So all we need to ensure is to not run longer than we expect to be idle for and
> things should be 'free', right?
>
> So the problem I have with your proposal is that supposing we're successful
> once every 10 newidle balances. Then the sd->newidle_balance_cost gets inflated
> by a factor 10 -- for we'd count 10 of them before 'success'.
>
> However when we're idle for that amount of time (10 times longer than it takes
> to do a single newidle balance) we'd still only do a single newidle balance,
> not 10.

Could we prevent that downside by measuring both the
time spent idle, and the time spent in idle balancing,
and making sure the idle balancing time never exceeds
more than N% of the idle time?

Say, have the CPU never spend more than 10% of its
idle time in the idle balancing code, as averaged
over some time period?

That way we might still do idle balancing every X
idle periods, even if the idle periods themselves
are relatively short.

It might also be enough to prevent excessive lock
contention triggered by the idle balancing code,
though I have to admit I did not really think that
part through :)
