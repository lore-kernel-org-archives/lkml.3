Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3KERCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:02:03 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62158 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3KERCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:02:00 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: [PATCH v5 0/4] perf/x86: add Intel RAPL PMU support
Date: Tue,  5 Nov 2013 18:01:22 +0100
Message-Id: <1383670886-30827-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new uncore PMU to expose the Intel
RAPL (Running Average Power Limit) energy consumption counters.
Up to 3 counters, each counting a single RAPL event are exposed.

The RAPL counters are available on Intel SandyBridge, IvyBridge,
Haswell. The server processors add a 3rd counter to measure
DRAM power consumption.

The following events are available and exposed in sysfs:
- power/energy-cores: power consumption of all cores on socket
- power/energy-pkg  : power consumption of all cores + LLC cache
- power/energy-dram : power consumption of DRAM (servers only)

The RAPL PMU is uncore by nature and is implemented such
that it only works in system-wide mode. Measuring only
one CPU per socket is sufficient. 

The counters all count in the same unit. The perf_events API
exposes all RAPL counters as 64-bit integers counting in unit
of 1/2^32 Joules (about 0.23 nJ). User level tools must convert
the counts by multiplying them by the scaling factor exposed
in the correponding event .scale file in sysfs to obtain a value
expressed in Joules. The reason for this approach is that the kernel
avoids doing floating point math whenever possible because it is
expensive (user floating-point state must be saved). The method
used avoids kernel floating-point and does not incur any precision
loss. Thanks to PeterZ for suggesting this approach.

To convert the raw count in Watts: W = C * 2.3 / (1e10 * time)

The kernel exposes both the scaling factor and the unit (Joules)
in sysfs:
$ ls -1 /sys/devices/power/events/energy-*
/sys/devices/power/events/energy-cores
/sys/devices/power/events/energy-cores.scale
/sys/devices/power/events/energy-cores.unit
/sys/devices/power/events/energy-pkg
/sys/devices/power/events/energy-pkg.scale
/sys/devices/power/events/energy-pkg.unit

$ cat /sys/devices/power/events/energy-cores.scale
2.3283064365386962890625e-10

$ cat cat /sys/devices/power/events/energy-cores.unit
Joules

RAPL PMU is a new standalone PMU which registers with the
perf_event core subsystem. The PMU type (attr->type) is
dynamically allocated and is available from /sys/device/rapl/type.

Sampling is not supported by the RAPL PMU. There is no
privilege level filtering either.

The PMU exports a cpumask in /sys/devices/power/cpumask. It
is used by perf to ensure only one instance of each RAPL event
is measured per processor socket. Hotplug CPU is also supported.

The perf stat infrastrructure is enhanced to show events
units. It also applies the scaling factor. As such, perf stat prints
RAPL events in Joules (and not increments of 0.23 nJ):

 # perf stat -a -e power/energy-pkg/,power/energy-cores/,cycles -I 1000 sleep 1000
 #          time             counts   unit events
     1.000282860               2.51 Joules power/energy-pkg/
     1.000282860               0.31 Joules power/energy-cores/
     1.000282860           37765378        cycles

The patch adds a hrtimer to poll the counters given that
they do no interrupt on overflow. Hardware counters are 32-bit
wide.

In v2, we add the locking necesarry to protect the rapl_pmu
struct. We also add a description at the top of the file.
We check for Intel only processor. We improved the data
layout of the rapl_pmu struct. We also lifted the restriction
of the number of instances of RAPL counters that can be active
at the same time. RAPL is free running counters, so ought to be
able to measure events as many times as necessary in parallel
via multiple tools. There is never multiplexing among RAPL events.

In v3, we have renamed the event to be more generic power/* instead
of rapl/*. We have modified perf stat to print the event with the
unit and scaling factors.

In v4, we integrate the feedback from Jiri and rebase to 3.12-rc7+
from tip.git.

In v5, we export the full scaling factor to increase prescision.
In the perf tool, we changed the way the .unit and .scale syfs
entries are parsed. Thank to Jiri for this contribution on this.
We also fix a couple of printf() issues with perf stat and units.
Now, we print no unit symbol when the event has no unit (was ? before).
Patch is relative to 3.12 from tip.git.

Thanks to all contributors to this patch series: PeterZ, Jiri, Maria,
Arnaldo, Andi, Ingo.

Supported CPUs: SandyBridge, IvyBridge, Haswell.

Signed-off-by: Stephane Eranian <eranian@google.com>

Stephane Eranian (4):
  perf: add active_entry list head to struct perf_event
  perf stat: add event unit and scale support
  perf,x86: add Intel RAPL PMU support
  perf,x86: add RAPL hrtimer support

 arch/x86/kernel/cpu/Makefile                |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_rapl.c |  721 +++++++++++++++++++++++++++
 include/linux/perf_event.h                  |    5 +-
 kernel/events/core.c                        |    1 +
 tools/perf/builtin-stat.c                   |  114 +++--
 tools/perf/util/evsel.c                     |    2 +
 tools/perf/util/evsel.h                     |    3 +
 tools/perf/util/parse-events.c              |   28 +-
 tools/perf/util/pmu.c                       |  144 +++++-
 tools/perf/util/pmu.h                       |    3 +-
 10 files changed, 978 insertions(+), 45 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_rapl.c

-- 
1.7.9.5

