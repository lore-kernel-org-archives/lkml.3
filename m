Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab3GBEzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:55:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:31476 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab3GBEzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:55:41 -0400
Message-ID: <51D25CB5.8080604@huawei.com>
Date: Tue, 2 Jul 2013 12:53:09 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Tom Zanussi <tom.zanussi@linux.intel.com>, <rostedt@goodmis.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v2 00/11] tracing: trace event triggers
References: <cover.1372479499.git.tom.zanussi@linux.intel.com> <51CEA92F.3040802@huawei.com> <51D176F6.9050409@hitachi.com>
In-Reply-To: <51D176F6.9050409@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/1 20:32, Masami Hiramatsu wrote:
> (2013/06/29 18:30), zhangwei(Jovi) wrote:
>>> This patchset implements 'trace event triggers', which are similar to
>>> the function triggers implemented for 'ftrace filter commands' (see
>>> 'Filter commands' in Documentation/trace/ftrace.txt), but instead of
>>> being invoked from function calls are invoked by trace events.
>>> Basically the patchset allows 'commands' to be triggered whenever a
>>> given trace event is hit.  The set of commands implemented by this
>>> patchset are:
>>>
>>>  - enable/disable_event - enable or disable another event whenever
>>>    the trigger event is hit
>>>
>>>  - stacktrace - dump a stacktrace to the trace buffer whenever the
>>>    trigger event is hit
>>>
>>>  - snapshot - create a snapshot of the current trace buffer whenever
>>>    the trigger event is hit
>>>
>>>  - traceon/traceoff - turn tracing on or off whenever the trigger
>>>    event is hit
>>>
>>> Triggers can also be conditionally invoked by associating a standard
>>> trace event filter with them - if the given event passes the filter,
>>> the trigger is invoked, otherwise it's not. (see 'Event filtering' in
>>> Documentation/trace/events.txt for info on event filters).
>>>
>>
>> I just aware that we are implementing more and more scripting functionality into
>> tracing subsystem, like filter and trigger mode, of cause we don't call it
>> as scripting, but basically the pattern is same, all is "do something when event hit".
> 
> Agreed, that's a good direction to handle event by script in kernel :)
> That may be simply done with an extension of "event trigger". Of course
> your ktap work will be the next step for ftrace. But I think, the basic
> implementation can be done by just passing recorded event entry to
> each action. (other works are for debugfs management)
> And that could be a generic trace-event interface for other users too.
> 
Fully agree "passing recorded event entry to each action".
Actually there already have this interface, it's perf.

struct perf_event *
perf_event_create_kernel_counter(struct perf_event_attr *attr,
                                int cpu,
                                struct task_struct *task,
                                perf_overflow_handler_t callback,
                                void *context);

As we known, each event has a id, register this id in perf_event_attr, and
give a callback function, then it will call the callback function when event hit.

void overflow_callback(struct perf_event *event,
                       struct perf_sample_data *data,
                       struct pt_regs *regs)

the recorded event entry is passed as data->raw->data;

This perf interface is a generic action trigger interface now, it support
tracepoint, k(ret)probe, u(ret)probe, PMU, hw_breakpoint(perhaps we could implement
PMU and hw_breakpoint trigger in future)

So why we need to reinvent another trigger interface as this patchset did?
(this patchset changed lots of places, include macro in ftrace.h, and will change more
if support kprobe/uprobe trigger in future.)

jovi





