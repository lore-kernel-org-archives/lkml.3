Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaJ2CFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:05:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47563 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaJ2CFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:05:04 -0400
Message-ID: <54504A60.2090908@linux.vnet.ibm.com>
Date: Wed, 29 Oct 2014 07:31:04 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti Murthy <preeti.lkml@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        patches@linaro.org
Subject: Re: [PATCH V2 1/5] sched: idle: cpuidle: Check the latency req before
 idle
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pOg1GFW82WD8b6Vas5xhYQrQtdP1STGxyzYtrBNSa+-Pw@mail.gmail.com> <544FE787.8090108@linaro.org>
In-Reply-To: <544FE787.8090108@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102902-0033-0000-0000-000000E633C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 12:29 AM, Daniel Lezcano wrote:
> On 10/28/2014 04:51 AM, Preeti Murthy wrote:
>> Hi Daniel,
>>
>> On Thu, Oct 23, 2014 at 2:31 PM, Daniel Lezcano
>> <daniel.lezcano@linaro.org> wrote:
>>> When the pmqos latency requirement is set to zero that means "poll in
>>> all the
>>> cases".
>>>
>>> That is correctly implemented on x86 but not on the other archs.
>>>
>>> As how is written the code, if the latency request is zero, the
>>> governor will
>>> return zero, so corresponding, for x86, to the poll function, but for
>>> the
>>> others arch the default idle function. For example, on ARM this is
>>> wait-for-
>>> interrupt with a latency of '1', so violating the constraint.
>>
>> This is not true actually. On PowerPC the idle state 0 has an
>> exit_latency of 0.
>>
>>>
>>> In order to fix that, do the latency requirement check *before*
>>> calling the
>>> cpuidle framework in order to jump to the poll function without entering
>>> cpuidle. That has several benefits:
>>
>> Doing so actually hurts on PowerPC. Because the idle loop defined for
>> idle state 0 is different from what cpu_relax() does in cpu_idle_loop().
>> The spinning is more power efficient in the former case. Moreover we
>> also set
>> certain register values which indicate an idle cpu. The ppc_runlatch bits
>> do precisely this. These register values are being read by some user
>> space
>> tools.  So we will end up breaking them with this patch
>>
>> My suggestion is very well keep the latency requirement check in
>> kernel/sched/idle.c
>> like your doing in this patch. But before jumping to cpu_idle_loop
>> verify if the
>> idle state 0 has an exit_latency > 0 in addition to your check on the
>> latency_req == 0.
>> If not, you can fall through to the regular path of calling into the
>> cpuidle driver.
>> The scheduler can query the cpuidle_driver structure anyway.
>>
>> What do you think?
> 
> Thanks for reviewing the patch and spotting this.
> 
> Wouldn't make sense to create:
> 
> void __weak_cpu_idle_poll(void) ?
> 
> and override it with your specific poll function ?
> 

No this would become ugly as far as I can see. A weak function has to be
defined under arch/* code. We will either need to duplicate the idle
loop that we already have in the drivers or point the weak function to
the first idle state defined by our driver. Both of which is not
desirable (calling into the driver from arch code is ugly). Another
reason why I don't like the idea of a weak function is that if you have
missed looking at a specific driver and they have an idle loop with
features similar to on powerpc, you will have to spot it yourself and
include the arch specific cpu_idle_poll() for them.

But by having a check on the exit_latency, you are claiming that since
the driver's 0th idle state is no better than the generic idle loop in
cases of 0 latency req, we are better off calling the latter, which
looks reasonable. That way you don't have to bother about worsening the
idle loop behavior on any other driver.

Regards
Preeti U Murthy

