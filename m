Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170Ab3HHKps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:45:48 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:11928 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965127Ab3HHKpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:45:43 -0400
Message-ID: <52037468.30401@huawei.com>
Date: Thu, 8 Aug 2013 18:35:20 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, <jovi.zhangwei@gmail.com>
Subject: [RFC] ktap: enable scripting for Linux tracing subsystem
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ktap was released 0.2 at several days ago, you can read the release note
in: http://lwn.net/Articles/561568/

The public location of ktap is in: https://github.com/ktap/ktap.git	

ktap v0.2 release brought a lots of new valuable changes, in summary,
the architecture of ktap is easy to integrate with current tracing
infrastructure, that's why I want to start this RFC discussion now.

The highlight features of ktap includes:

   - support tracepoints, k(ret)probe, u(ret)probe, function tracing,
     and timer
   - support x86, x86-64, powerpc, arm, and preempt-rt kernel
   - support kernel 3.1 and later versions, include Linux mainline
   - similar event syntax interface with perf
   - support event filter
   - unified backend perf callback mechanism
   - ring buffer transport (same with ftrace)
   - oneline scripting

To make us understand deeply on ktap, the contents splits into 5 parts:
Introduction, The design, Implementation, Link, Upstream.

1. Introduction
---------------

ktap is a simple and lightweight dynamic tracing tool for Linux, it's
similar with Linux mainstream dynamic tracing tool systemtap, and Dtrace
in Solaris.
ktap have different design principles from Linux mainstream dynamic
tracing tool in that it's based on bytecode interpreter, so it doesn't
depend upon GCC, doesn't require compiling kernel module for each
script, fulfilling the embedded ecosystem's tracing needs.

ktap doesn't invent any new tracing build-block, it leverage current
tracing building blocks(tracepoint, kprobe, uprobe, function tracing,
pmu)in Linux kernel, it just combine all these tracing building blocks
together, to explore as a unified script tracing interface.


2. The design
-------------

                   ktap compiler      io thread
                        |                ^
                 -------|----------------|-----------
                        |                |
                        v                |
                     ktapvm --------> ringbuffer
                        |
                        |
                        v
                 tracepoints kprobe uprobe
                 pmu hw_breakpoint timer

ktap compiler: responsible for compile source script to bytecode, then
use ioctl to notify ktapvm load and execute bytecode.

ktapvm: core script engine, responsible for load and execute bytecode,
calling into built-in or library function, also interact with ringbuffer
transport. ktapvm register perf event by id, the overflow callback will
call by event is hit, then calling into ktap script engine.

ringbuffer: this is based on ftrace ring buffer, responsible for
transport to userspace. Possibly ktap will share same ring buffer output
code with ftrace in future.

io thread: reading the ring buffer, output to stdout.


3. Implementation
-----------------

The script engine and compiler is based on lua initially, a widely used
fast dynamic typed language, registered based, extendable interpreter,
support associative array.
(Note that ktap already changed a lot on interpreter core and compiler,
so it's cannot call it as lua anymore :-))

Language syntax is C-like, so it's easy to make us(kernel developers) to
adapt it, smooth learning curve.

ktapvm code of lines is only 5K+, and userspace compiler is only 4K+,
code is very easy to read and review, especially ktapvm, easy to hack,
it just have 40 bytecodes.

One thing need to aware is ktap tracing core is heavily based on perf
event, in this point of view, ktap is a kernel script interface for perf
tool, there already have perf-script tools(based on python/perl), ktap
differences with perf-script is we can programming each event when event
is hit, in real time manner.

Currently debuginfo is not handled, ktap just reuse perf-probe, in case
some embedded Linux system don't have available debuginfo, they still
could get local variable or register based on
kprobe-tracer/uprobe-tracer, so debuginfo won't hurt the simplicity of
ktap, which recognized as largest advantage of ktap.

The event filter in ktap is based on kernel tracing event filter.

Based on these design, I'm also willing to discuss perf-ktap integrating
if others want too.

This is the whole design overview for ktap, it reuse current tracing
building block, to keep its simplicity.

More info is available in ktap/doc/, and sample scripts is in scripts/

4. Link
-------

There have ktap v0.1 review on LWN(wrote by Corbet):
http://lwn.net/Articles/551314/

example in that link have a little out of date.


5. Upstream
-----------

why I want to upstream ktap now?

ktap is still in early stage, there have many items in my todo list, but
small start is a good start, it would be good to shape and polish this
tool under eyes of community, community collaboration will make ktap to
be more valuable for all of us, it have been shown that ktap is very
useful for embedded Linux system, and we are enter an age where embedded
system is deployed to large user base than before.

I hope in future we will have a robust, low overhead, mature, extendable
kernel interpreter.

I appreciate any feedback from you, thank you.

jovi















