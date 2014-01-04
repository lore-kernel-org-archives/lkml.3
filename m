Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaADSWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 13:22:15 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:18118 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752404AbaADSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 13:22:14 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: [PATCH RFC v2 0/4] perf: IRQ-bound performance events
Date: Sat,  4 Jan 2014 19:22:32 +0100
Message-Id: <cover.1388858996.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is version 2 of RFC "perf: IRQ-bound performance events". That is an
introduction of IRQ-bound performance events - ones that only count in a
context of a hardware interrupt handler. Ingo suggested to extend this
functionality to softirq and threaded handlers as well:

[quote]

Looks useful.

I think the main challenges are:

 - Creating a proper ABI for all this:

   - IRQ numbers alone are probably not specific enough: we'd also want to 
     be more specific to match on handler names - or handler numbers if
     the handler name is not unique.

   - another useful variant would be where IRQ numbers are too specific:
     something like 'perf top irq' would be a natural thing to do, to see 
     only overhead in hardirq execution - without limiting it to a
     specific handler. An 'all irq contexts' wildcard concept?

 - Covering softirqs as well. If we handle both hardirqs and softirqs,
   then we are pretty much feature complete: all major context types that 
   the Linux kernel cares about are covered in instrumentation. For things
   like networking the softirq overhead is obviously very important, and 
   for example on routers it will do most of the execution.

 - Covering threaded IRQs as well, in a similar model. So if someone types
   'perf top irq', and some IRQ handlers are running threaded, those
   should probaby be included as well.

 - Making the tooling friendlier: 'perf top irq' would be useful, and
   accepting handler names would be useful as well.

The runtime overhead of your patches seems to be pretty low: when no IRQ 
contexts are instrumented then it's a single 'is the list empty' check at 
context scheduling time. That looks acceptable.

Regarding the ABI and IRQ/softirq context enumeration you are breaking 
lots of new ground here, because unlike tasks, cgroups and CPUs the IRQ 
execution contexts do not have a good programmatically accessible 
namespace (yet). So it has to be thought out pretty well I think, but once 
we have it, it will be a lovely feature IMO.

Thanks,

	Ingo

[/quote]

This RFC version addresses only "Creating a proper ABI for all this"
suggestion for kernel side. Each hardware interrupt context performance
event is assigned a bitmask where each bit indicates whether the action with
the bit's number should be measured or not. A task to convert handler
name(s), wildcards etc. to bitmasks to be off-loaded to user level and is
not yet supported.

The kernel side implementation revolves around a need to make enabling and
disabling performance counters in hardware interrupt context as fast as
possible. For this reason a new command PERF_EVENT_IOC_SET_HARDIRQ pre-
allocates and initializes a per-CPU array with performance events destined
for this IRQ, before the event is started. Once, the action (aka ISR) is
called, another pre-allocated per-CPU array gets initialized with events for
this action and then submitted to relevant PMUs using a new PMU callback:

	void (*start_hardirq)(struct perf_event *events[], int count);

Since the performance events are expected known to PMUs, it should be able
to enable the counters in a performance-aware manner. I.e. in the sample
patch for Intel PMU this goal is achieved with a single pass thru the
'events' array and a single call to WRMSR instruction.

By contrast with version 1 of this RFC, per-CPU lists are replaced with
per-CPU arrays whenever possible. With an assumption there will be normally
no more than a dozen of events being counted at a time, it expected to add
to cache hit rate when the events are enabled or disabled from the hardware
interrupt context.

Besides the original purpose the design accommodates an ability to run the
same performance counter for any combination of actions and IRQs, which
makes possible a unlimited level of flexibility. This feature is not yet
supported with the perf tool, though.

Although the whole idea seems simple, I am not sure if it fits into the
current perf design and does not break some ground assumptions. The very
purpose of this RFC is to ensure the taken approach is correct.

This RFC interleaves with toggling events introduced some time ago. While
addressing a similar problem, it does not appear the toggling events could
count on per-action basis, nor to provide a flexibility this RFC assumes.
The performance is also a major concern. Perhaps, the two designs could be
merged, but at the moment I am not realizing how. Suggestions are very
welcomed.


The perf tool update for now is just a hack to make possible kernel side
testing. Here is a sample session against IRQ #8, 'rtc0' device:

# ./tools/perf/perf stat -a -e L1-dcache-load-misses:k --hardirq=8 sleep 1

 Performance counter stats for 'system wide':

                 0      L1-dcache-load-misses                                       

       1.001190052 seconds time elapsed

# ./tools/perf/perf stat -a -e L1-dcache-load-misses:k --hardirq=8 hwclock --test
Sat 04 Jan 2014 12:16:36 EST  -0.484913 seconds

 Performance counter stats for 'system wide':

               374      L1-dcache-load-misses                                       

       0.485939068 seconds time elapsed


The patchset is against Arnaldo's repo, in "perf/core" branch.

The tree could be found in "pci-next-msi-v5" branch in repo:
https://github.com/a-gordeev/linux.git

Thanks!

Alexander Gordeev (4):
  perf/core: IRQ-bound performance events
  perf/x86: IRQ-bound performance events
  perf/x86/Intel: IRQ-bound performance events
  perf/tool: IRQ-bound performance events

 arch/x86/kernel/cpu/perf_event.c       |   55 +++++-
 arch/x86/kernel/cpu/perf_event.h       |   15 ++
 arch/x86/kernel/cpu/perf_event_amd.c   |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c |   72 ++++++-
 arch/x86/kernel/cpu/perf_event_knc.c   |    2 +
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +
 arch/x86/kernel/cpu/perf_event_p6.c    |    2 +
 include/linux/irq.h                    |   10 +
 include/linux/irqdesc.h                |    4 +
 include/linux/perf_event.h             |   24 ++
 include/uapi/linux/perf_event.h        |   14 ++-
 kernel/events/Makefile                 |    2 +-
 kernel/events/core.c                   |  142 ++++++++++++-
 kernel/events/hardirq.c                |  370 ++++++++++++++++++++++++++++++++
 kernel/irq/handle.c                    |    7 +-
 kernel/irq/irqdesc.c                   |   15 ++
 tools/perf/builtin-stat.c              |    9 +
 tools/perf/util/evlist.c               |   38 ++++
 tools/perf/util/evlist.h               |    3 +
 tools/perf/util/evsel.c                |    8 +
 tools/perf/util/evsel.h                |    3 +
 tools/perf/util/parse-events.c         |   24 ++
 tools/perf/util/parse-events.h         |    1 +
 23 files changed, 811 insertions(+), 13 deletions(-)
 create mode 100644 kernel/events/hardirq.c

-- 
1.7.7.6

