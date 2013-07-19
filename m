Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3GSVAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:00:38 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37932 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3GSVAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:00:37 -0400
Message-ID: <51E9A8FA.2080205@gmail.com>
Date: Fri, 19 Jul 2013 15:00:42 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] Teach perf_trace_##call() to check hlist_empty(perf_events)
References: <20130718183018.GA4043@redhat.com>  <20130719074339.GA22597@gmail.com> <1374265641.3356.31.camel@gandalf.local.home>
In-Reply-To: <1374265641.3356.31.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/13 2:27 PM, Steven Rostedt wrote:
> On Fri, 2013-07-19 at 09:43 +0200, Ingo Molnar wrote:
>> * Oleg Nesterov <oleg@redhat.com> wrote:
>>
>>> Hello.
>>>
>>> The patches are the same, I only tried to update the changelogs a bit.
>>> I am also quoting my old email below, to explain what this hack tries
>>> to do.
>>>
>>> 	Say, "perf record -e sched:sched_switch -p1".
>>>
>>> 	Every task except /sbin/init will do perf_trace_sched_switch() and
>>> 	perf_trace_buf_prepare() + perf_trace_buf_submit for no reason(),
>>> 	it doesn't have a counter.
>>>
>>> 	So it makes sense to add the fast-path check at the start of
>>> 	perf_trace_##call(),
>>>
>>> 		if (hlist_empty(event_call->perf_events))
>>> 			return;
>>>
>>> 	The problem is, we should not do this if __task != NULL (iow, if
>>> 	DECLARE_EVENT_CLASS() uses __perf_task()), perf_tp_event() has the
>>> 	additional code for this case.
>>>
>>> 	So we should do
>>>
>>> 		if (!__task && hlist_empty(event_call->perf_events))
>>> 			return;
>>>
>>> 	But __task is changed by "{ assign; }" block right before
>>> 	perf_trace_buf_submit(). Too late for the fast-path check,
>>> 	we already called perf_trace_buf_prepare/fetch_regs.
>>>
>>> 	So. After 2/3 __perf_task() (and __perf_count/addr) is called
>>> 	when ftrace_get_offsets_##call(args) evaluates the arguments,
>>> 	and we can check !__task && hlist_empty() right after that.
>>>
>>> Oleg.
>>
>> Nice improvement.
>>
>> Peter, Steve, any objections?
>>
>
> Yep, agreed.
>
>
> The whole series...
>
> Reviewed-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>

For what it is worth,
Tested-by: David Ahern <dsahern@gmail.com>


