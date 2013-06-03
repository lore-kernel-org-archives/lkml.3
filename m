Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3FCJlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:41:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab3FCJky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:40:54 -0400
Date: Mon, 3 Jun 2013 11:41:33 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH RFC -tip 0/6] perf: IRQ-bound performance events
Message-ID: <20130603094132.GB30878@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is against perf/core branch.

As Linux is able to measure task-bound and CPU-bound performance
events there are no convenient means to monitor performance of
an execution context which requires control and tuning probably
most - interrupt service routines.

This series is an attempt to introduce IRQ-bound performance
events - ones that only count in a context of a hardware interrupt
handler.

The implementation is pretty straightforward: an IRQ-bound event
is registered with the IRQ descriptor and gets enabled/disabled
using new PMU callbacks: pmu_enable_irq() and pmu_disable_irq().

The series has not been tested thoroughly and is a concept proof
rather than a decent implementation: no group events could be be
loaded, inappropriate (i.e. software) events are not rejected,
only Intel and AMD PMUs were tried for 'perf stat', only Intel
PMU works with precise events. Perf tool changes are just a hack.

Yet, I would like first to ensure if the approach taken is not
screwed and I did not miss anything vital. Not to mention if the
change is wanted at all.

Below is a sample session on a machine with x2apic in cluster mode.
IRQ number is passed using new argument -I <irq> (please nevermind
'...process id '8'...' in the output for now):

# cat /proc/interrupts | grep ' 8:'
   8:         23          0          0          0         21          0          0          0         23          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0         27          0          0          0         23          0          0          0         17          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-IO-APIC-edge      rtc0
# ./tools/perf/perf stat -a -e L1-dcache-load-misses:k sleep 1
 Performance counter stats for 'sleep 1':

           124,849 L1-dcache-load-misses                                       

       1.001359403 seconds time elapsed

# ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k sleep 1

 Performance counter stats for process id '8':

                 0 L1-dcache-load-misses                                       

       1.001235781 seconds time elapsed

# ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k hwclock --test
Mon 03 Jun 2013 04:42:59 AM EDT  -0.891274 seconds

 Performance counter stats for process id '8':


Alexander Gordeev (6):
  perf/core: IRQ-bound performance events
  perf/x86: IRQ-bound performance events
  perf/x86/AMD PMU: IRQ-bound performance events
  perf/x86/Core PMU: IRQ-bound performance events
  perf/x86/Intel PMU: IRQ-bound performance events
  perf/tool: Hack 'pid' as 'irq' for sys_perf_event_open()

 arch/x86/kernel/cpu/perf_event.c          |   71 ++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event.h          |   19 ++++++
 arch/x86/kernel/cpu/perf_event_amd.c      |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c    |   93 +++++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    5 +-
 arch/x86/kernel/cpu/perf_event_knc.c      |    2 +
 arch/x86/kernel/cpu/perf_event_p4.c       |    2 +
 arch/x86/kernel/cpu/perf_event_p6.c       |    2 +
 include/linux/irq.h                       |    8 ++
 include/linux/irqdesc.h                   |    3 +
 include/linux/perf_event.h                |   16 +++++
 include/uapi/linux/perf_event.h           |    1 +
 kernel/events/core.c                      |   69 +++++++++++++++----
 kernel/irq/Makefile                       |    1 +
 kernel/irq/handle.c                       |    4 +
 kernel/irq/irqdesc.c                      |   14 ++++
 kernel/irq/perf_event.c                   |  100 +++++++++++++++++++++++++++++
 tools/perf/builtin-record.c               |    8 ++
 tools/perf/builtin-stat.c                 |    8 ++
 tools/perf/util/evlist.c                  |    4 +-
 tools/perf/util/evsel.c                   |    3 +
 tools/perf/util/evsel.h                   |    1 +
 tools/perf/util/target.c                  |    4 +
 tools/perf/util/thread_map.c              |   16 +++++
 24 files changed, 422 insertions(+), 34 deletions(-)
 create mode 100644 kernel/irq/perf_event.c

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
