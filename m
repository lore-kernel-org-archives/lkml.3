Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaBCKOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:14:10 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:37379 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaBCKOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:14:09 -0500
Message-ID: <52EF6BED.7050001@gmail.com>
Date: Mon, 03 Feb 2014 11:14:05 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>
CC: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/core: fix sched_rt_global_validate
References: <1391186607-11247-1-git-send-email-juri.lelli@gmail.com> <20140203095302.GA13242@austad.us>
In-Reply-To: <20140203095302.GA13242@austad.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 10:53 AM, Henrik Austad wrote:
> On Fri, Jan 31, 2014 at 05:43:27PM +0100, Juri Lelli wrote:
>> Don't compare sysctl_sched_rt_runtime against sysctl_sched_rt_period if
>> the former is equal to RUNTIME_INF, otherwise disabling -rt bandwidth
>> management always fails.
>>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
>> ---
>>  kernel/sched/core.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 210a12a..5c0a304 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -7477,7 +7477,8 @@ static int sched_rt_global_validate(void)
>>  	if (sysctl_sched_rt_period <= 0)
>>  		return -EINVAL;
>>  
>> -	if (sysctl_sched_rt_runtime > sysctl_sched_rt_period)
>> +	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
>> +		(sysctl_sched_rt_runtime > sysctl_sched_rt_period))
>>  		return -EINVAL;
> 
> Won't this be caught by the test above?
> 
> #define RUNTIME_INF ((u64)~0ULL)
> 
> which means that if sysctl_sched_rt_runtime is set to RUNTIME_INF, it will 
> trigger on the previous test, and the first part of this test will always 
> be true.
> 
> Or have I suffered catastrophic monday-morning braindamage?
> 

As I understand it. When you do

 echo -1 > /proc/sys/kernel/sched_rt_runtime_us

sysctl_sched_rt_runtime is actually set to -1 (being an int).
But then you compare it against and unsigned int, so the cast converts it to
actually be RUNTIME_INF, and thus greater than sysctl_sched_rt_period (so the
function returns -EINVAL, while you'd want it to return 0, as you are disabling
-rt throttling).

Makes sense?

Thanks,

- Juri
