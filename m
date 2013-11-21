Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3KUN0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:26:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:60834 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab3KUN0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:26:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,744,1378882800"; 
   d="scan'208";a="439187725"
Message-ID: <528E09F9.9030501@linux.intel.com>
Date: Thu, 21 Nov 2013 15:26:17 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 6/7] sched: Clean up preempt_enable_no_resched() abuse
References: <20131120160450.072555619@infradead.org> <20131120162736.691879744@infradead.org> <528CF94E.8020300@linux.intel.com> <20131121101018.GX10022@twins.programming.kicks-ass.net>
In-Reply-To: <20131121101018.GX10022@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/2013 12:10, Peter Zijlstra wrote:
> On Wed, Nov 20, 2013 at 08:02:54PM +0200, Eliezer Tamir wrote:
>> IMHO This has been reviewed thoroughly.
>>
>> When Ben Hutchings voiced concerns I rewrote the code to use time_after,
>> so even if you do get switched over to a CPU where the time is random
>> you will at most poll another full interval.
>>
>> Linus asked me to remove this since it makes us use two time values
>> instead of one. see https://lkml.org/lkml/2013/7/8/345.
> 
> I'm not sure I see how this would be true.
> 
> So the do_select() code basically does:
> 
>   for (;;) {
> 
>     /* actual poll loop */
> 
>     if (!need_resched()) {
>       if (!busy_end) {
> 	busy_end = now() + busypoll;
> 	continue;
>       }
>       if (!((long)(busy_end - now()) < 0))
> 	continue;
>     }
> 
>     /* go sleep */
> 
>   }
> 
> So imagine our CPU0 timebase is 1 minute ahead of CPU1 (60e9 vs 0), and we start by:
> 
>   busy_end = now() + busypoll; /* CPU0: 60e9 + d */
> 
> but then we migrate to CPU1 and do:
> 
>   busy_end - now() /* CPU1: 60e9 + d' */
> 
> and find we're still a minute out; and in fact we'll keep spinning for
> that entire minute barring a need_resched().

not exactly, poll will return if there are any events to report of if
a signal is pending.

> Surely that's not intended and desired?

This limit is an extra safety net, because busy polling is expensive,
we limit the time we are willing to do it.

We don't override any limit the user has put on the system call.
A signal or having events to report will also stop the looping.
So we are mostly capping the resources an _idle_ system will waste
on busy polling.

We want to globally cap the amount of time the system busy polls, on
average. Nothing catastrophic will happen in the extremely rare occasion
that we miss.

The alternative is to use one more int on every poll/select all the
time, this seems like a bigger cost.
