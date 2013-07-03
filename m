Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3GCEMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 00:12:54 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:42329 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3GCEMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 00:12:53 -0400
Message-ID: <51D3A495.3080908@huawei.com>
Date: Wed, 3 Jul 2013 12:12:05 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <fweisbec@gmail.com>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 11/12] tracing: guard tracing_selftest_disabled by
 CONFIG_FTRACE_STARTUP_TEST
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>  <1365564393-10972-12-git-send-email-jovi.zhangwei@huawei.com> <1372809403.22688.90.camel@gandalf.local.home>
In-Reply-To: <1372809403.22688.90.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/3 7:56, Steven Rostedt wrote:
> On Wed, 2013-04-10 at 11:26 +0800, zhangwei(Jovi) wrote:
>> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
>>
>> Variable tracing_selftest_disabled have not any sense when
>> CONFIG_FTRACE_STARTUP_TEST is disabled.
>>
>> This patch also remove __read_mostly attribute, since variable
>> tracing_selftest_disabled really not read mostly.
> 
> Yes it is mostly read only. Sure, it's not read much, but it is also
> only written to once. That makes it, "read mostly".
> 
> -- Steve
> 
Ok, we can leave the __read_mostly attribute.

And tracing_selftest_disabled still can move to CONFIG_FTRACE_STARTUP_TEST
guard, normally CONFIG_FTRACE_STARTUP_TEST is disabled in most system.

Do I need to resend this patch?

jovi

>>
>> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
>> ---
>>  kernel/trace/trace.c        |    6 ++++--
>>  kernel/trace/trace.h        |    2 +-
>>  kernel/trace/trace_events.c |    2 ++
>>  3 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index ee4e110..09a3aa8 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -58,10 +58,12 @@ bool ring_buffer_expanded;
>>   */
>>  static bool __read_mostly tracing_selftest_running;
>>  
>> +#ifdef CONFIG_FTRACE_STARTUP_TEST
>>  /*
>>   * If a tracer is running, we do not want to run SELFTEST.
>>   */
>> -bool __read_mostly tracing_selftest_disabled;
>> +bool tracing_selftest_disabled;
>> +#endif
>>  
>>  /* For tracers that don't implement custom flags */
>>  static struct tracer_opt dummy_tracer_opt[] = {
>> @@ -1069,8 +1071,8 @@ int register_tracer(struct tracer *type)
>>  	tracing_set_tracer(type->name);
>>  	default_bootup_tracer = NULL;
>>  	/* disable other selftests, since this will break it. */
>> -	tracing_selftest_disabled = true;
>>  #ifdef CONFIG_FTRACE_STARTUP_TEST
>> +	tracing_selftest_disabled = true;
>>  	printk(KERN_INFO "Disabling FTRACE selftests due to running tracer '%s'\n",
>>  	       type->name);
>>  #endif
>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
>> index 9b8afa7..e9ef8b7 100644
>> --- a/kernel/trace/trace.h
>> +++ b/kernel/trace/trace.h
>> @@ -546,10 +546,10 @@ extern int DYN_FTRACE_TEST_NAME(void);
>>  extern int DYN_FTRACE_TEST_NAME2(void);
>>  
>>  extern bool ring_buffer_expanded;
>> -extern bool tracing_selftest_disabled;
>>  DECLARE_PER_CPU(int, ftrace_cpu_disabled);
>>  
>>  #ifdef CONFIG_FTRACE_STARTUP_TEST
>> +extern bool tracing_selftest_disabled;
>>  extern int trace_selftest_startup_function(struct tracer *trace,
>>  					   struct trace_array *tr);
>>  extern int trace_selftest_startup_function_graph(struct tracer *trace,
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index 7c52a51..7c4a16b 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -2251,7 +2251,9 @@ static __init int setup_trace_event(char *str)
>>  {
>>  	strlcpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
>>  	ring_buffer_expanded = true;
>> +#ifdef CONFIG_FTRACE_STARTUP_TEST
>>  	tracing_selftest_disabled = true;
>> +#endif
>>  
>>  	return 1;
>>  }
> 
> 
> 
> .
> 


