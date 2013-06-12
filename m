Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3FLJfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:35:04 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:45251 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3FLJfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:35:01 -0400
Message-ID: <51B840C0.7070608@gmail.com>
Date: Wed, 12 Jun 2013 11:34:56 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>
Subject: Re: [PATCH 3/3] ftrace: fix stddev calculation
References: <1370941728-15456-1-git-send-email-juri.lelli@gmail.com>  <1370941728-15456-4-git-send-email-juri.lelli@gmail.com> <1371006559.9844.250.camel@gandalf.local.home>
In-Reply-To: <1371006559.9844.250.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 05:09 AM, Steven Rostedt wrote:
> On Tue, 2013-06-11 at 11:08 +0200, Juri Lelli wrote:
>> When FUNCTION_GRAPH_TRACER is enabled, ftrace can profile kernel functions
>> and print basic statistics about them. Unfortunately, running stddev
>> calculation is wrong. This patch corrects it implementing Welford’s method:
>>
>>          s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2) .
>
> Looking at this further, we only need this fix. We don't need the other
> two patches, as that's just verifying the algorithm, and not something
> we need to do for run time tests. The run time tests is to test
> functionality, not calculations that can be done out of the kernel.
>
> Can you resubmit with just this change. And add the above line as a
> comment below.
>

Sure! No problem.

>>
>> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> ---
>>   kernel/trace/ftrace.c |    8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 6caaa0e..073a328 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -593,13 +593,17 @@ void function_stat_calc(struct ftrace_profile *rec,
>>   	if (rec->counter <= 1)
>>   		*stddev = 0;
>>   	else {
>> -		*stddev = rec->time_squared - rec->counter * (*avg) * (*avg);
>> +		/*
>> +		 * Apply Welford's method.
>
> Welford's method is not well known. Please add:
>
> 		* s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
>

Ok.

BTW, it is in general more interesting to look at distributions before
doing averages and std devs (one can miss multimodal distributions, etc.).
Is there any lightweight way to get single duration values of functions?
I mean, apart from parsing function graph trace off-line.

Thanks,

- Juri

>> +		 */
>> +		*stddev = rec->counter * rec->time_squared -
>> +			  rec->time * rec->time;
>>
>>   		/*
>>   		 * Divide only 1000 for ns^2 -> us^2 conversion.
>>   		 * trace_print_graph_duration will divide 1000 again.
>>   		 */
>> -		do_div(*stddev, (rec->counter - 1) * 1000);
>> +		do_div(*stddev, rec->counter * (rec->counter - 1) * 1000);
>>   	}
>>   }
>>
>
>
