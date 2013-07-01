Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3GAMdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:33:01 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36396 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3GAMc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:32:59 -0400
Message-ID: <51D176F6.9050409@hitachi.com>
Date: Mon, 01 Jul 2013 21:32:54 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Re: [PATCH v2 00/11] tracing: trace event triggers
References: <cover.1372479499.git.tom.zanussi@linux.intel.com> <51CEA92F.3040802@huawei.com>
In-Reply-To: <51CEA92F.3040802@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/29 18:30), zhangwei(Jovi) wrote:
>> This patchset implements 'trace event triggers', which are similar to
>> the function triggers implemented for 'ftrace filter commands' (see
>> 'Filter commands' in Documentation/trace/ftrace.txt), but instead of
>> being invoked from function calls are invoked by trace events.
>> Basically the patchset allows 'commands' to be triggered whenever a
>> given trace event is hit.  The set of commands implemented by this
>> patchset are:
>>
>>  - enable/disable_event - enable or disable another event whenever
>>    the trigger event is hit
>>
>>  - stacktrace - dump a stacktrace to the trace buffer whenever the
>>    trigger event is hit
>>
>>  - snapshot - create a snapshot of the current trace buffer whenever
>>    the trigger event is hit
>>
>>  - traceon/traceoff - turn tracing on or off whenever the trigger
>>    event is hit
>>
>> Triggers can also be conditionally invoked by associating a standard
>> trace event filter with them - if the given event passes the filter,
>> the trigger is invoked, otherwise it's not. (see 'Event filtering' in
>> Documentation/trace/events.txt for info on event filters).
>>
> 
> I just aware that we are implementing more and more scripting functionality into
> tracing subsystem, like filter and trigger mode, of cause we don't call it
> as scripting, but basically the pattern is same, all is "do something when event hit".

Agreed, that's a good direction to handle event by script in kernel :)
That may be simply done with an extension of "event trigger". Of course
your ktap work will be the next step for ftrace. But I think, the basic
implementation can be done by just passing recorded event entry to
each action. (other works are for debugfs management)
And that could be a generic trace-event interface for other users too.

> 
> FYI, a pretty simple scripting module of tracing is there:
> 	https://github.com/ktap/ktap.git
> 
> For the trigger mode, you can perform any command when event hit if using scripting,
> in contrast with this patchset, ktap use perf callback handler to invoke command,
> so it don't need extra code to support trigger mode in tracepoint/k(ret)probe/u(ret)probe.
> 
> 	---------------------
> 	trace "syscalls:*" function (e) {
>                 printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
>         }
> 	---------------------
> 	trace "probe:do_sys_open dfd=%di filename=%dx flags=%cx mode=+4($stack)" function (e) {
>                 printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
>         }
> 	---------------------
> 	trace "probe:do_sys_open%return fd=$retval" function (e) {
>                 printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
>         }
> 	---------------------
> 	trace "probe:/lib/libc.so.6:0x000773c0" function (e) {
>                 printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
>         }

Nice! so the ktap can use perf probe to define new events - without involving
any dwarf hacks :)


> what I'm thinking now is perhaps we can use a more generic mechanism in future
> to let user do more magic things when event hit.
> 
> To be clear, I'm not against on this patchset, I'm on the same side with Tom,
> the trigger mode of this patchset is useful(awesome work). I'm just sharing some extra info,
> hopeful you don't mind it :)

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


