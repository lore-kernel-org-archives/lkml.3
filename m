Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaKQTIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:08:04 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51682 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaKQTIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:08:01 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v3 00/13] perf/x86: implement HT counter corruption workaround
Date: Mon, 17 Nov 2014 20:06:52 +0100
Message-Id: <1416251225-17721-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

This patch series addresses a serious known erratum in the PMU
of Intel SandyBridge, IvyBrige, Haswell processors with hyper-threading
enabled.

The erratum is documented in the Intel specification update documents
for each processor under the errata listed below:
 - SandyBridge: BJ122
 - IvyBridge: BV98
 - Haswell: HSD29

The bug causes silent counter corruption across hyperthreads only
when measuring certain memory events (0xd0, 0xd1, 0xd2, 0xd3).
Counters measuring those events may leak counts to the sibling
counter. For instance, counter 0, thread 0 measuring event 0x81d0,
may leak to counter 0, thread 1, regardless of the event measured
there. The size of the leak is not predictible. It all depends on
the workload and the state of each sibling hyper-thread. The
corrupting events do undercount as a consequence of the leak. The
leak is compensated automatically only when the sibling counter measures
the exact same corrupting event AND the workload is on the two threads
is the same. Given, there is no way to guarantee this, a workaround
is necessary. Furthermore, there is a serious problem if the leaked counts
are added to a low-occurrence event. In that case the corruption on
the low occurrence event can be very large, e.g., orders of magnitude.

There is no HW or FW workaround for this problem.

The bug is very easy to reproduce on a loaded system.
Here is an example on a Haswell client, where CPU0 and CPU4
are siblings. We load the CPUs with a simple triad app
streaming large floating-point vector. We use 0x81d0
corrupting event (MEM_UOPS_RETIRED:ALL_LOADS) and
0x20cc (ROB_MISC_EVENTS:LBR_INSERTS). Given we are not
using the LBR, the 0x20cc event should be zero.

 $ taskset -c 0 triad &
 $ taskset -c 4 triad &
 $ perf stat -a -C 0 -e r81d0 sleep 100 &
 $ perf stat -a -C 4 -r20cc sleep 10
 Performance counter stats for 'system wide':
       139 277 291      r20cc
      10,000969126 seconds time elapsed

In this example, 0x81d0 and r20cc are using sibling counters
on CPU0 and CPU4. 0x81d0 leaks into 0x20cc and corrupts it
from 0 to 139 millions occurrences.

This patch provides a software workaround to this problem by modifying the
way events are scheduled onto counters by the kernel. The patch forces
cross-thread mutual exclusion between sibling counters in case a
corrupting event is measured by one of the hyper-threads. If thread 0,
counter 0 is measuring event 0x81d0, then nothing can be measured on
counter 0, thread 1. If no corrupting event is measured on any hyper-thread,
event scheduling proceeds as before.

The same example run with the workaround enabled, yields the correct answer:
 $ taskset -c 0 triad &
 $ taskset -c 4 triad &
 $ perf stat -a -C 0 -e r81d0 sleep 100 &
 $ perf stat -a -C 4 -r20cc sleep 10
 Performance counter stats for 'system wide':
       0 r20cc
      10,000969126 seconds time elapsed

The patch does provide correctness for all non-corrupting events. It does not
"repatriate" the leaked counts back to the leaking counter. This is planned
for a second patch series. This patch series however makes this repatriation
easier by guaranteeing that the sibling counter is not measuring any useful event.

The patch introduces dynamic constraints for events. That means that events which
did not have constraints, i.e., could be measured on any counters, may now be
constrained to a subset of the counters depending on what is going on the sibling
thread. The algorithm is similar to a cache coherency protocol. We call it XSU
in reference to Exclusive, Shared, Unused, the 3 possible states of a PMU 
counter.  

As a consequence of the workaround, users may see an increased amount of event
multiplexing, even in situtations where there are fewer events than counters measured
on a CPU.

Patch has been tested on all three impacted processors. Note that when
HT is off, there is no corruption. However, the workaround is still enabled,
yet not costing too much. Adding a dynamic detection of HT on turned out to
be complex are requiring too much to code to be justified. This patch series
also covers events used with PEBS.

Special thanks to Maria for working out a solution to this complex problem.

In V2, we rebased to 3.17, we also addressed all the feedback received
for LKML from V1. In particular, we now automatically detect if HT is
disabled, and if so we disable the workaround altogether. This is done
as a 2-step initcall as suggested by PeterZ. We also fixed the spinlock
irq masking. We pre-allocate the dynamic constraints in the per-cpu cpuc
struct. We have isolated the sysfs sysctl to make it optional.

In V3, we rebased the code to 3.18-rc5. We cleaned up the auto-detection
of Hyperthreading. But more importantly, we implemented a solution suggested
by PeterZ to avoid the counter starvation introduced by the workaround.
Because of exclusive access across HT threads, one HT can starve the other
by measuring 4 corrupting events. Though this would be rare, we wanted to
mitigate this problem. The idea of Peter was to artificially limit the number
of counters available to each HT to half the actual number, i.e., 2. That
way, we guarantee that at least 2 counters are not in exclusive mode. This
mitigates the starvation situations though some corner cases still exist.
But we think this is better than not having it.

Maria Dimakopoulou (6):
  perf/x86: add 3 new scheduling callbacks
  perf/x86: add cross-HT counter exclusion infrastructure
  perf/x86: implement cross-HT corruption bug workaround
  perf/x86: enforce HT bug workaround for SNB/IVB/HSW
  perf/x86: enforce HT bug workaround with PEBS for SNB/IVB/HSW
  perf/x86: add syfs entry to disable HT bug workaround

Stephane Eranian (7):
  perf,x86: rename er_flags to flags
  perf/x86: vectorize cpuc->kfree_on_online
  perf/x86: add index param to get_event_constraint() callback
  perf/x86: fix intel_get_event_constraints() for dynamic constraints
  perf/x86: limit to half counters to avoid exclusive mode starvation
  watchdog: add watchdog enable/disable all functions
  perf/x86: make HT bug workaround conditioned on HT enabled

 arch/x86/kernel/cpu/perf_event.c          |  98 +++++-
 arch/x86/kernel/cpu/perf_event.h          |  95 +++++-
 arch/x86/kernel/cpu/perf_event_amd.c      |   9 +-
 arch/x86/kernel/cpu/perf_event_intel.c    | 544 ++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  28 +-
 include/linux/watchdog.h                  |   8 +
 kernel/watchdog.c                         |  28 ++
 7 files changed, 744 insertions(+), 66 deletions(-)

-- 
1.9.1
