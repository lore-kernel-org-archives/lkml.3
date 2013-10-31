Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3JaO7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:59:55 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51723 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab3JaO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:59:54 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: [PATCH v4 0/4] perf/x86: add Intel RAPL PMU support
Date: Thu, 31 Oct 2013 15:59:38 +0100
Message-Id: <1383231582-15856-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new uncore PMU to expose the Intel
RAPL (Running Average Power Limit) energy consumption counters.
Up to 3 counters, each counting a particular RAPL event are exposed.

The RAPL counters are available on Intel SandyBridge,
IvyBridge, Haswell. The server skus add a 3rd counter to measure
DRAM power consumption.

The following events are available nd exposed in sysfs:
- power/energy-cores: power consumption of all cores on socket
- power/energy-pkg: power consumption of all cores + LLc cache
- power/energy-dram: power consumption of DRAM (server skus only)

The RAPL PMU is uncore by nature and is implemented such
that it only works in system-wide mode. Measuring only
one CPU per socket is sufficient. The /sys/devices/rapl/cpumask
is exported and can be used by tools to figure out which CPU
to monitor by default. For instance, on a 2-socket system, 2 CPUs
(one on each socket) will be shown.

The counters all count in the same unit. The perf_events API
exposes all RAPL counters as 64-bit integers counting in unit
of 1/2^32 Joules (or 0.23 nJ). User level tools must convert
the counts by multiplying them by 0.23 and divide 10^9 to
obtain Joules.  The reason for this is that the kernel avoids
doing floating point math whenever possible because it is
expensive (user floating-point state must be saved). The method
used avoids kernel floating-point and minimizes the loss of
precision (bits). Thanks to PeterZ for suggesting this approach.

To convert the raw count in Watt: W = C * 0.23 / (1e9 * time)

The kernel exposes both the scaling factor (0.23 nJ) and the
unit (Joules) in sysfs:
$ ls -1 /sys/devices/power/events/energy-*
/sys/devices/power/events/energy-cores
/sys/devices/power/events/energy-cores.scale
/sys/devices/power/events/energy-cores.unit
/sys/devices/power/events/energy-pkg
/sys/devices/power/events/energy-pkg.scale
/sys/devices/power/events/energy-pkg.unit

$ cat /sys/devices/power/events/energy-cores.scale
2.3e-10

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

The perf stat infrasrtructure is modified to now show event
unit. It also applies the scaling factor. As such it will print
RAPL events in Joules (and not increments on 0.23 nJ):

 # perf stat -a -e power/energy-pkg/,power/energy-cores/,cycles -I 1000 sleep 1000
 #          time             counts   unit events
     1.000282860               2.51 Joules power/energy-pkg/         [100.00%]
     1.000282860               0.31 Joules power/energy-cores/      
     1.000282860           37765378 ?      cycles                    [100.00%]

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

Supported CPUs: SandyBridge, IvyBridge, Haswell.

Signed-off-by: Stephane Eranian <eranian@google.com>

Stephane Eranian (4):
  perf: add active_entry list head to struct perf_event
  perf stat: add event unit and scale support
  perf,x86: add Intel RAPL PMU support
  perf,x86: add RAPL hrtimer support

 arch/x86/kernel/cpu/Makefile                |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_rapl.c |  720 +++++++++++++++++++++++++++
 include/linux/perf_event.h                  |    5 +-
 kernel/events/core.c                        |    1 +
 tools/perf/builtin-stat.c                   |   72 ++-
 tools/perf/util/evsel.c                     |    2 +
 tools/perf/util/evsel.h                     |    3 +
 tools/perf/util/parse-events.c              |    1 +
 tools/perf/util/pmu.c                       |  170 ++++++-
 tools/perf/util/pmu.h                       |    3 +
 10 files changed, 956 insertions(+), 23 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_rapl.c

-- 
1.7.9.5

