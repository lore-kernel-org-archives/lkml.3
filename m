Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3GBD7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 23:59:20 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:54454 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3GBD7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 23:59:19 -0400
Message-ID: <51D24F11.7090201@huawei.com>
Date: Tue, 2 Jul 2013 11:54:57 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
CC: <rostedt@goodmis.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v2 00/11] tracing: trace event triggers
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>  <51CEA92F.3040802@huawei.com> <1372693762.4072.96.camel@empanada>
In-Reply-To: <1372693762.4072.96.camel@empanada>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/1 23:49, Tom Zanussi wrote:
> Hi jovi,
> 
> On Sat, 2013-06-29 at 17:30 +0800, zhangwei(Jovi) wrote:
>> On 2013/6/29 13:08, Tom Zanussi wrote:
>>> Hi,
>>>
>>> This is v2 of the trace event triggers patchset, addressing comments
>>> from Masami Hiramatsu, zhangwei(Jovi), and Steve Rostedt (thanks for
>>> reviewing v1).
>>>
>>> v2:
>>>  - removed all changes to __ftrace_event_enable_disable() (except
>>>    for patch 04/11 which clears the soft_disabled bit as discussed)
>>>    and created a separate trace_event_trigger_enable_disable() that
>>>    calls it after setting/clearing the TRIGGER_MODE_BIT.
>>>  - added a trigger_mode enum for future patches that break up the
>>>    trigger calls for filtering, but that's also now used as a command
>>>    id for registering/unregistering commands.
>>>  - removed the enter_file/exit_file members that were added to
>>>    syscall_metadata after realizing that they were unnecessary if
>>>    ftrace_syscall_enter/exit() were modified to receive a pointer
>>>    to the ftrace_file instead of the pointer to the trace_array in
>>>    the ftrace_file.
>>>  - broke up the trigger invocation into two parts so that triggers
>>>    like 'stacktrace' that themselves log into the trace buffer can
>>>    defer the actual trigger invocation until after the current
>>>    record is closed, which is needed for the filter check that
>>>    in turn determines whether the trigger gets invoked.
>>>  - other minor cleanup
>>>
>>>
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
>>
> 
> Not really - this patchset is just reusing the existing filter code
> that's been there for years, and yes, it does follow the pattern of
> 'doing something when an event is hit', but the things it does are
> really dirt simple - toggling of other events or the global tracing
> on/off switch, snapshotting trace buffers, etc.  All things that don't
> require any kind of scripting - this is more on the level of wiring
> things together on a breadboard.  And it's all available by simply using
> 'cat' and 'echo' - no separate command and scripts to keep track of.  
> 
>> FYI, a pretty simple scripting module of tracing is there:
>> 	https://github.com/ktap/ktap.git
>>
> 
> It looks pretty nice, but I wonder if Linux is ready for a full-fledged
> language interpreter in the kernel.  It's been tried before - see
> DProbes (in fact that effort is where kprobes came from - after it was
> obvious DProbes wouldn't make it into the kernel, it was broken up into
> multiple pieces - kprobes and uprobes eventually got in, but the RPN
> interpreter, which also had an ANSI C compiler targeting the bytecode
> (dpcc) never did...).  Well, following that, DTrace came along and
> showed how useful it could be, so maybe there wouldn't be as much
> resistance these days...

Actually ktap is very lightweight compare with Dtrace and other tools,
it doesn't reinvent tracing interface, it make use on kprobe/uprobe/tracepoint/perf,
it doesn't engage with debugging info, just a simple script interface for tracing,
as demoed in example, the tracing interface is same as perf.
> 
> Also, assuming an in-kernel language interpreter would fly, did you
> consider starting with something already-baked rather than starting from
> scratch?  How about taking something like the parrot VM and carving out
> a minimal core subset of that suitable for embedding in the kernel?  It
> probably wouldn't be easy, but you'd be building on a relatively mature
> and tested VM that's been designed for targeting many languages
> (including lua).
> 
ktap is building on mature interpreter(lua) which proven fast and widely used,
the core interpreter is very simple and small, and really easy to hack it.

I will never try to put a general purpose VM(like parrot) into kernel, we need to
care on safety, size, performance, memory footprint, etc. Compared with
many other languages, you will find ktap interpreter(based on lua) is
very suit for kernel than others, the interpreter just have 5000 LOC, with
40+ bytecodes, and there have a lot of space to improve.

> Another thing you could consider is taking a page from the DProbes and
> breaking up and submitting ktap piecemeal.  For instance, you could
> break out and submit the associative array piece and with a little
> thought tie it to a 'histogram' trigger e.g. something like:
> 
> echo 'hist[key,val] if filter' > trigger
> 
> For example, something like this could be used to accomplish a similar
> thing to your scripts/syscalls_histogram.kp script (keeping and dumping
> a per-syscall count):
> 
> echo 'hist[e.name,count()]' > /syscalls/trigger
> 
> Similarly, this would keep a per-executable syscall count like
> syscalls_histogram2.kp:
> 
> echo 'hist[comm,count()]' > /syscalls/trigger
> 
> Any field defined in an event's 'format' file could be used as a key or
> value (e.g. using 'comm' as a hash key as above).  For example, keeping
> a per-pid hash of total bytes written by 'sys_exit_write' (both
> common_pid and ret are sys_exit_write fields, and I assume a small set
> of utility functions that say what to do with numeric fields, perhaps
> 'add' could be the default) would show which process is doing most of
> the writing:
> 
> echo 'hist[common_pid,add(ret)]' > syscalls/sys_exit_write/trigger
> 
> Making the trace_dump_stack() available as a utility function would
> allow things like this: 
> 
> echo 'hist[stacktrace(),count()] if bytes_req > 16384' >
> kmem/kmalloc/trigger
> 
> Basically the above would use the stacktrace itself as a hash key and
> the value stored for each key would be a per-execution-path count of >
> 16k kernel memory requests.  Dumping out the hash would show the top
> execution paths leading to large kmalloc requests.
> 
> This would give users the ability to accomplish what a lot of them seem
> to use these tools for, and without any scripting  (I'm not saying
> scripting wouldn't be useful, but I think you can still accomplish quite
> a bit without it).
> 
> Tom

Thanks for your comments.

There have some technical limitation if using oneline echo/cat style trigger.

- subsystem level trigger
  How to handle subsystem level trigger like "syscalls:*" and all tracepoint "*:*"?
  you need to add /sys/kernel/debug/tracing/events/$system/trigger file, otherwise
  user need to use echo command to all events belong the subsystem.

- userspace uprobe (debugging info)
  I couldn't image how to handle userspace probe if only use echo/cat(you will need
  help from perf-probe), the other issue is userspace symbol resolving(like call stack),
  there must need some userspace utility in there, like perf, systemtap, dtrace, etc.

- timer
  I also cannot image how to handle timer into there, normally we need to record
  timestamps when event is hit and calculate duration.

- associative array
  Is really use echo/cat to present associative array would be more descriptive than
  scripting?

- arith calculation
  Usually we need to do arith calculation in script, but it will be hard to do in oneline.

- variable declaration
  Of course there don't have variable declaration in oneline style trigger.

There have many technical advantage to use script in there which I can't list all.

The question is if you put more and more trigger command into event tracing, eventually it
will became a script engine, from this point of view, script tracing is a flexible and extendable
framework of trace event trigger.

Since this thread is purpose on trace event trigger patchset, it's not suit for ktap detail
discussion, I will open a new ktap thread in LKML soon, feel free to give your comment in there. :)

jovi
> 
> 
>> For the trigger mode, you can perform any command when event hit if using scripting,
>> in contrast with this patchset, ktap use perf callback handler to invoke command,
>> so it don't need extra code to support trigger mode in tracepoint/k(ret)probe/u(ret)probe.
>>
>> 	---------------------
>> 	trace "syscalls:*" function (e) {
>>                 printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
>>         }
>> 	---------------------
>> 	trace "probe:do_sys_open dfd=%di filename=%dx flags=%cx mode=+4($stack)" function (e) {
>>                 printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
>>         }
>> 	---------------------
>> 	trace "probe:do_sys_open%return fd=$retval" function (e) {
>>                 printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
>>         }
>> 	---------------------
>> 	trace "probe:/lib/libc.so.6:0x000773c0" function (e) {
>>                 printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
>>         }
>>
>>
>> what I'm thinking now is perhaps we can use a more generic mechanism in future
>> to let user do more magic things when event hit.
>>
>> To be clear, I'm not against on this patchset, I'm on the same side with Tom,
>> the trigger mode of this patchset is useful(awesome work). I'm just sharing some extra info,
>> hopeful you don't mind it :)
>>
>> Thanks.
>> jovi
>>
>>


