Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3L0Qvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 11:51:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:23049 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab3L0Qvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 11:51:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,561,1384329600"; 
   d="scan'208";a="456546099"
Message-ID: <1388163096.9098.10.camel@empanada>
Subject: Re: [PATCH] Tracing events with GPIOs
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 27 Dec 2013 10:51:36 -0600
In-Reply-To: <CACh+v5NqzGWi+g+cSO65UJOfcajq721HUoAjN__BWqLLOG3zkA@mail.gmail.com>
References: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
	 <52AFA5E0.7040707@hitachi.com>
	 <CACh+v5NgwyAD5xy-feykUDXpzVUuF2yFxP35TsnGk3r+LFtRPA@mail.gmail.com>
	 <1387304970.3051.35.camel@empanada>
	 <20131217140502.2aed31aa@gandalf.local.home>
	 <1387313151.3051.39.camel@empanada>
	 <CACh+v5NqzGWi+g+cSO65UJOfcajq721HUoAjN__BWqLLOG3zkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-27 at 15:54 +0100, Jean-Jacques Hiblot wrote:
> Hi Tom, Steven,
> 
> I'm currently doing some tests with the event triggers
> (git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> for-next).
> At the moment I can't use event triggers with probes dynamically
> created (with perf probe or via
> /sys/kernel/debug/tracing/kprobe_events)
> Predefined probes like
> /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger are working
> fine.
> Am I missing something ?
> 

No, it's just that kprobes hasn't been hooked up yet to actually invoke
the triggers.

Let me look at doing that over the weekend...

Tom

> example:
> 
> ----------------------------------------------------------------
> with a predefined probe
> ----------------------------------------------------------------
> 
> prompt> echo 'stacktrace' >
> /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
> prompt> ls
> prompt> cat /sys/kernel/debug/tracing/trace
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 14/14   #P:1
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>               ls-971   [000] ....   298.050000: <stack trace>
>  => ftrace_raw_event_kmem_alloc
>  => kmem_cache_alloc_trace
>  => do_execve
>  => SyS_execve
>  => ret_fast_syscall
>               ls-971   [000] ....   298.050000: <stack trace>
>  => ftrace_raw_event_kmem_alloc
>  => kmem_cache_alloc_trace
>  => load_elf_binary
> [...]
> 
> ----------------------------------------------------------------
> with a dynamically defined probe
> ----------------------------------------------------------------
> 
> prompt> perf probe -a in_kmalloc=__kmalloc
> prompt> echo 'stacktrace' >
> /sys/kernel/debug/tracing/events/probe/in_kmalloc/trigger
> prompt> perf record -e probe:in_kmalloc -aR sleep 10&
> [... do something here ...]
> prompt> perf report
> [...]
> # Samples: 24  of event 'probe:in_kmalloc'
> # Event count (approx.): 24
> #
> # Overhead  Command      Shared Object         Symbol
> # ........  .......  .................  .............
> #
>     50.00%       ls  [kernel.kallsyms]  [k] __kmalloc
>     12.50%    sleep  [kernel.kallsyms]  [k] __kmalloc
>     12.50%       sh  [kernel.kallsyms]  [k] __kmalloc
>     12.50%     perf  [kernel.kallsyms]  [k] __kmalloc
>     12.50%     more  [kernel.kallsyms]  [k] __kmalloc
> [...]
> 
> prompt> cat /sys/kernel/debug/tracing/trace
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 0/0   #P:1
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #              random: nonblocking pool is initialized
>               ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |


