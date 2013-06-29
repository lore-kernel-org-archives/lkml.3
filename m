Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3F2Ja5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 05:30:57 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:23215 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3F2Jaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 05:30:55 -0400
Message-ID: <51CEA92F.3040802@huawei.com>
Date: Sat, 29 Jun 2013 17:30:23 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
CC: <rostedt@goodmis.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/11] tracing: trace event triggers
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/29 13:08, Tom Zanussi wrote:
> Hi,
> 
> This is v2 of the trace event triggers patchset, addressing comments
> from Masami Hiramatsu, zhangwei(Jovi), and Steve Rostedt (thanks for
> reviewing v1).
> 
> v2:
>  - removed all changes to __ftrace_event_enable_disable() (except
>    for patch 04/11 which clears the soft_disabled bit as discussed)
>    and created a separate trace_event_trigger_enable_disable() that
>    calls it after setting/clearing the TRIGGER_MODE_BIT.
>  - added a trigger_mode enum for future patches that break up the
>    trigger calls for filtering, but that's also now used as a command
>    id for registering/unregistering commands.
>  - removed the enter_file/exit_file members that were added to
>    syscall_metadata after realizing that they were unnecessary if
>    ftrace_syscall_enter/exit() were modified to receive a pointer
>    to the ftrace_file instead of the pointer to the trace_array in
>    the ftrace_file.
>  - broke up the trigger invocation into two parts so that triggers
>    like 'stacktrace' that themselves log into the trace buffer can
>    defer the actual trigger invocation until after the current
>    record is closed, which is needed for the filter check that
>    in turn determines whether the trigger gets invoked.
>  - other minor cleanup
> 
> 
> This patchset implements 'trace event triggers', which are similar to
> the function triggers implemented for 'ftrace filter commands' (see
> 'Filter commands' in Documentation/trace/ftrace.txt), but instead of
> being invoked from function calls are invoked by trace events.
> Basically the patchset allows 'commands' to be triggered whenever a
> given trace event is hit.  The set of commands implemented by this
> patchset are:
> 
>  - enable/disable_event - enable or disable another event whenever
>    the trigger event is hit
> 
>  - stacktrace - dump a stacktrace to the trace buffer whenever the
>    trigger event is hit
> 
>  - snapshot - create a snapshot of the current trace buffer whenever
>    the trigger event is hit
> 
>  - traceon/traceoff - turn tracing on or off whenever the trigger
>    event is hit
> 
> Triggers can also be conditionally invoked by associating a standard
> trace event filter with them - if the given event passes the filter,
> the trigger is invoked, otherwise it's not. (see 'Event filtering' in
> Documentation/trace/events.txt for info on event filters).
> 

I just aware that we are implementing more and more scripting functionality into
tracing subsystem, like filter and trigger mode, of cause we don't call it
as scripting, but basically the pattern is same, all is "do something when event hit".

FYI, a pretty simple scripting module of tracing is there:
	https://github.com/ktap/ktap.git

For the trigger mode, you can perform any command when event hit if using scripting,
in contrast with this patchset, ktap use perf callback handler to invoke command,
so it don't need extra code to support trigger mode in tracepoint/k(ret)probe/u(ret)probe.

	---------------------
	trace "syscalls:*" function (e) {
                printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
        }
	---------------------
	trace "probe:do_sys_open dfd=%di filename=%dx flags=%cx mode=+4($stack)" function (e) {
                printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
        }
	---------------------
	trace "probe:do_sys_open%return fd=$retval" function (e) {
                printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
        }
	---------------------
	trace "probe:/lib/libc.so.6:0x000773c0" function (e) {
                printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
        }


what I'm thinking now is perhaps we can use a more generic mechanism in future
to let user do more magic things when event hit.

To be clear, I'm not against on this patchset, I'm on the same side with Tom,
the trigger mode of this patchset is useful(awesome work). I'm just sharing some extra info,
hopeful you don't mind it :)

Thanks.

jovi










