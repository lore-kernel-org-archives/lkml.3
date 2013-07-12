Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab3GLHV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:21:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:64777 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab3GLHV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:21:58 -0400
X-Spam-Score: -100.8
Message-ID: <51DFAE5A.2060005@asianux.com>
Date: Fri, 12 Jul 2013 15:20:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: trace: remove __init from race_selftest_startup_function()
 and trace_selftest_startup_function_graph()
References: <51DDFCF8.2090808@asianux.com>   <1373561279.17876.45.camel@gandalf.local.home>   <51DF44FA.9060000@asianux.com>  <1373593261.17876.61.camel@gandalf.local.home>  <51DF62DB.3010409@asianux.com> <1373596735.17876.84.camel@gandalf.local.home> <51DF7250.9020209@asianux.com>
In-Reply-To: <51DF7250.9020209@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 11:04 AM, Chen Gang wrote:
> On 07/12/2013 10:38 AM, Steven Rostedt wrote:
>> On Fri, 2013-07-12 at 09:58 +0800, Chen Gang wrote:
>>> On 07/12/2013 09:41 AM, Steven Rostedt wrote:
>>>> On Fri, 2013-07-12 at 07:51 +0800, Chen Gang wrote:
>>>>
>>>>>> Hmm, can all trace_selftest_startup_* (*selftest* in trace_selftest.c)
>>>>>> use '__init', so not waste memory keeping them around ?
>>>> Yeah, they should all be set to __init, but that's pretty low on the
>>>> totem poll, as distros don't enable selftests in their main kernels.
>>>
>>> Excuse me, my English is not quite well, I guess your meaning is:
>>>
>>>   they should all be set to '__init', although it is minor in real world.
>>>
>>> Is it correct ?
>>
>> Correct.
>>
>>>
>>>
>>> For me, I recommend to let all *selftest* as the same: "all add '
>>> __init' or none add '__init'" (if choose add, all report warnings).
>>>
>>> Is it suitable to still send new related patch for it ? If so, could
>>> you provide your suggesting choice (all add, or none add) ?
>>
>> Does this patch fix your warning?
>>
>> -- Steve
>>
> 

After the test, they will not report the related warning.

Hmm..., but that will let another none *selftest* functions miss
'__read_mostly'.

Do the original *selftest* intend to have no '__init' so can fit other
none *selftest* with '__read_mostly', and without warnings ?

Welcome any members' suggestions or completions.

Thanks.

> I guess it can (although I do not give a compiling test), it seems a
> better fixing.
> 
> And is it suitable to let all *selftest* as the same ? (all add, or none
> add '__init').
> 
> Thanks.
> 
>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
>> index a4ed382..5e794d1 100644
>> --- a/kernel/trace/trace.h
>> +++ b/kernel/trace/trace.h
>> @@ -680,6 +680,15 @@ extern int trace_selftest_startup_sched_switch(struct tracer *trace,
>>  					       struct trace_array *tr);
>>  extern int trace_selftest_startup_branch(struct tracer *trace,
>>  					 struct trace_array *tr);
>> +/*
>> + * Tracer data references selftest functions that only occur
>> + * on boot up. These can be __init functions. Thus, when selftests
>> + * are enabled, then the tracers need to reference __init functions.
>> + */
>> +#define __tracer_data		__refdata
>> +#else
>> +/* Tracers are seldom changed. Optimize when selftests are disabled. */
>> +#define __tracer_data		__read_mostly
>>  #endif /* CONFIG_FTRACE_STARTUP_TEST */
>>  
>>  extern void *head_page(struct trace_array_cpu *data);
>> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
>> index b863f93..38fe148 100644
>> --- a/kernel/trace/trace_functions.c
>> +++ b/kernel/trace/trace_functions.c
>> @@ -199,7 +199,7 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
>>  	return 0;
>>  }
>>  
>> -static struct tracer function_trace __read_mostly =
>> +static struct tracer function_trace __tracer_data =
>>  {
>>  	.name		= "function",
>>  	.init		= function_trace_init,
>>
>>
>>
>>
> 
> 


-- 
Chen Gang
