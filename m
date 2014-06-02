Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaFBGZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:25:52 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54872 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaFBGZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:25:50 -0400
Message-ID: <538C17D6.60100@linux.vnet.ibm.com>
Date: Mon, 02 Jun 2014 11:51:10 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Morten.Rasmussen@arm.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 11/11] sched: replace capacity by activity
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org> <1400860385-14555-12-git-send-email-vincent.guittot@linaro.org> <20140529135510.GG11074@laptop.programming.kicks-ass.net>
In-Reply-To: <20140529135510.GG11074@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060206-1542-0000-0000-0000024053A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 07:25 PM, Peter Zijlstra wrote:
> On Fri, May 23, 2014 at 05:53:05PM +0200, Vincent Guittot wrote:
>> The scheduler tries to compute how many tasks a group of CPUs can handle by
>> assuming that a task's load is SCHED_LOAD_SCALE and a CPU capacity is
>> SCHED_POWER_SCALE.
>> We can now have a better idea of the utilization of a group fo CPUs thanks to
>> group_actitvity and deduct how many capacity is still available.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
> 
> Right, so as Preeti already mentioned, this wrecks SMT. It also seems to
> loose the aggressive spread, where we want to run 1 task on each 'core'
> before we start 'balancing'.

True. I just profiled the ebizzy runs and found that ebizzy threads were
being packed onto a single core which is SMT-8 capable before spreading.
This was a 6 core, SMT-8 machine. So for instance if I run 8 threads of
ebizzy. the load balancing as record by perf sched record showed that
two cores were packed upto 3 ebizzy threads and one core ran two ebizzy
threads while the rest of the 3 cores were idle.

I am unable to understand which part of this patch is aiding packing to
a core.  There is this check in this patch right?

if (sgs->group_capacity < 0)
		return true;

which should ideally prevent such packing? Because irrespective of the
number of SMT threads, the capacity of a core is unchanged. And in the
above scenario, we have 6 tasks on 3 cores. So shouldn't the above check
have caught it?

Regards
Preeti U Murthy
> 
> So I think we should be able to fix this by setting PREFER_SIBLING on
> the SMT domain, that way we'll get single tasks running on each SMT
> domain before filling them up until capacity.
> 
> Now, its been a while since I looked at PREFER_SIBLING, and I've not yet
> looked at what your patch does to it, but it seems to me that that is
> the first direction we should look for an answer to this.
> 

