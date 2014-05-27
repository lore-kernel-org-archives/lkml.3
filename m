Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaE0T0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:26:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38460 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaE0T0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:26:51 -0400
Message-ID: <5384E6F9.6060806@codeaurora.org>
Date: Tue, 27 May 2014 12:26:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Don't account for cpu idle time with irqsoff
 tracers
References: <1400527847-28359-1-git-send-email-sboyd@codeaurora.org> <20140527151341.4411f910@gandalf.local.home>
In-Reply-To: <20140527151341.4411f910@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/14 12:13, Steven Rostedt wrote:
> Hey! I was able to get to this.

Great!

>
> On Mon, 19 May 2014 12:30:47 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> +	if (!tracer_enabled || !tracing_is_enabled() ||
>> +			per_cpu(timings_stopped, cpu))
>> +		return;
> Micro optimization. As this gets called even when not tracing, the
> tracer_enabled is what determines if tracing is enabled or not. Can you
> keep the first condition the same, and just add your check to the one
> below:
>
> if (per_cpu(timings_stop, cpu) || per_cpu(tracing_cpu, cpu))
> 	return;

Ok.

>
>> +
>>  	if (per_cpu(tracing_cpu, cpu))
>>  		return;
>>  
>> @@ -418,7 +421,8 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
>>  	else
>>  		return;
>>  
>> -	if (!tracer_enabled || !tracing_is_enabled())
>> +	if (!tracer_enabled || !tracing_is_enabled() ||
>> +			per_cpu(timings_stopped, cpu))
>>  		return;
>>  
>>  	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
>> @@ -439,15 +443,19 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
>>  /* start and stop critical timings used to for stoppage (in idle) */
>>  void start_critical_timings(void)
>>  {
>> -	if (preempt_trace() || irq_trace())
>> +	if (preempt_trace() || irq_trace()) {
>> +		per_cpu(timings_stopped, raw_smp_processor_id()) = false;
>>  		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
>> +	}
>>  }
>>  EXPORT_SYMBOL_GPL(start_critical_timings);
>>  
>>  void stop_critical_timings(void)
>>  {
>> -	if (preempt_trace() || irq_trace())
>> +	if (preempt_trace() || irq_trace()) {
>>  		stop_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
>> +		per_cpu(timings_stopped, raw_smp_processor_id()) = true;
>> +	}
> Hmm, I think this is racy. If we enter idle with tracing enabled it
> will set timings_stopped to true for this cpu. But if we disable
> tracing while in idle, it will not turn it off.
>
> Well, this isn't really true, because once we enable tracing the
> trace_type that is used to check preempt_trace() and irq_trace() stays
> set even when tracing isn't enabled. But this may change soon and that
> can make this a problem.
>
> I don't see any reason the setting of timings_stopped can't be set
> unconditionally in these functions.

I don't see any problem either. I'll send an update.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

