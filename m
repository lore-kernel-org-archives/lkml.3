Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3L0PDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 10:03:14 -0500
Received: from 10.mo6.mail-out.ovh.net ([87.98.157.236]:38975 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754581Ab3L0PDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 10:03:13 -0500
MIME-Version: 1.0
In-Reply-To: <1387313151.3051.39.camel@empanada>
References: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
	<52AFA5E0.7040707@hitachi.com>
	<CACh+v5NgwyAD5xy-feykUDXpzVUuF2yFxP35TsnGk3r+LFtRPA@mail.gmail.com>
	<1387304970.3051.35.camel@empanada>
	<20131217140502.2aed31aa@gandalf.local.home>
	<1387313151.3051.39.camel@empanada>
Date: Fri, 27 Dec 2013 15:54:29 +0100
Message-ID: <CACh+v5NqzGWi+g+cSO65UJOfcajq721HUoAjN__BWqLLOG3zkA@mail.gmail.com>
Subject: Re: [PATCH] Tracing events with GPIOs
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 10712093188708980760
X-Ovh-Remote: 209.85.220.43 (mail-pa0-f43.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddruddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddruddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom, Steven,

I'm currently doing some tests with the event triggers
(git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next).
At the moment I can't use event triggers with probes dynamically
created (with perf probe or via
/sys/kernel/debug/tracing/kprobe_events)
Predefined probes like
/sys/kernel/debug/tracing/events/kmem/kmalloc/trigger are working
fine.
Am I missing something ?

example:

----------------------------------------------------------------
with a predefined probe
----------------------------------------------------------------

prompt> echo 'stacktrace' >
/sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
prompt> ls
prompt> cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 14/14   #P:1
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
              ls-971   [000] ....   298.050000: <stack trace>
 => ftrace_raw_event_kmem_alloc
 => kmem_cache_alloc_trace
 => do_execve
 => SyS_execve
 => ret_fast_syscall
              ls-971   [000] ....   298.050000: <stack trace>
 => ftrace_raw_event_kmem_alloc
 => kmem_cache_alloc_trace
 => load_elf_binary
[...]

----------------------------------------------------------------
with a dynamically defined probe
----------------------------------------------------------------

prompt> perf probe -a in_kmalloc=__kmalloc
prompt> echo 'stacktrace' >
/sys/kernel/debug/tracing/events/probe/in_kmalloc/trigger
prompt> perf record -e probe:in_kmalloc -aR sleep 10&
[... do something here ...]
prompt> perf report
[...]
# Samples: 24  of event 'probe:in_kmalloc'
# Event count (approx.): 24
#
# Overhead  Command      Shared Object         Symbol
# ........  .......  .................  .............
#
    50.00%       ls  [kernel.kallsyms]  [k] __kmalloc
    12.50%    sleep  [kernel.kallsyms]  [k] __kmalloc
    12.50%       sh  [kernel.kallsyms]  [k] __kmalloc
    12.50%     perf  [kernel.kallsyms]  [k] __kmalloc
    12.50%     more  [kernel.kallsyms]  [k] __kmalloc
[...]

prompt> cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 0/0   #P:1
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#              random: nonblocking pool is initialized
              ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
