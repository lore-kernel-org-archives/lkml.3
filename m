Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3JJOuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:50:22 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52282 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3JJOuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:50:20 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de
Subject: [PATCH v2 0/3] perf,x86: add Intel RAPL PMU support
Date: Thu, 10 Oct 2013 16:50:05 +0200
Message-Id: <1381416608-2741-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new uncore PMU to expose the Intel
RAPL energy consumption counters. Up to 3 counters,
each counting a particular RAPL event are exposed.

The RAPL counters are available on Intel SandyBridge,
IvyBridge, Haswell. The server skus add a 3rd counter.

The following events are available nd exposed in sysfs:
- rapl-energy-cores: power consumption of all cores on socket
- rapl-energy-pkg: power consumption of all cores + LLc cache
- rapl-energy-dram: power consumption of DRAM

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

RAPL PMU is a new standalone PMU which registers with the
perf_event core subsystem. The PMU type (attr->type) is
dynamically allocated and is available from /sys/device/rapl/type.

Sampling is not supported by the RAPL PMU. There is no
privilege level filtering either.

The PMU exports a cpumask in /sys/devices/uncore/cpumask. It
is used by perf to ensure only one instance of each RAPL event
is measured per processor socket. Hotplug CPU is also supported.

The second patch adds a hrtimer to poll the counters given that
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

Supported CPUs: SandyBridge, IvyBridge, Haswell.

$ perf stat -a -e rapl/rapl-energy-cores/,rapl/rapl-energy-pkg/ -I 1000 sleep 10
            time             counts events
     1.000345931        772 278 493 rapl/rapl-energy-cores/
     1.000345931     55 539 138 560 rapl/rapl-energy-pkg/    
     2.000836387        771 751 936 rapl/rapl-energy-cores/  
     2.000836387     55 326 015 488 rapl/rapl-energy-pkg/

Stephane Eranian (3):
  perf: add active_entry list head to struct perf_event
  perf,x86: add Intel RAPL PMU support
  perf,x86: add RAPL hrtimer support

 arch/x86/kernel/cpu/Makefile                |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_rapl.c |  688 +++++++++++++++++++++++++++
 include/linux/perf_event.h                  |    1 +
 kernel/events/core.c                        |    1 +
 4 files changed, 691 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_rapl.c

-- 
1.7.9.5
