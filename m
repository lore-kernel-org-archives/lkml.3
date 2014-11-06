Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaKFMXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:23:33 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51527 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaKFMX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:23:28 -0500
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v3 00/11] perf: Intel Cache QoS Monitoring support
Date: Thu,  6 Nov 2014 12:23:11 +0000
Message-Id: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

This patch series adds a new PMU driver for the Intel Cache Monitoring
hardware feature available in Intel Xeon processors, which allows
monitoring of LLC occupancy on a task, group or system-wide basis.

The first few patches modify tools/perf to handle per-package counters,
which necessitates discarding some values when doing per-cpu reads to
avoid getting duplicate data. The rest add support for the new PMU code.

I've left a notoriously funky bit of code as the last patch, the RMID
rotation code, in an attempt to simplify things. Doing the rotation
provides the ability to multiplex the RMIDs and basically overcome the
hardware limitation, but the rest of the patches work fine without it.
But there are a number of scenarios where being able to monitor more
tasks than RMIDs is extremely useful.

The series is based on tip/perf/core.

Jiri Olsa (1):
  perf tools: Implement snapshot event file logic

Changes in v3:

 - Dropped patches that have been applied in tip/perf/core

 - Upated commit message in PATCH 3 based on Peter's feedback

 - Simplified PATCH 5 by only using int cgroup_fd as param

 - Added a new patch (11) to perform internal scheduling on conflict
   monitoring events

 - Make RMIDs wait in limbo for a minimium queue time to avoid IPIs
   wherever possible

 - Provide a user-configurable upper bound on the recycling threshold 

 - Reduce the size of a preemption disabled section (pointed out by
   Thomas Gleixner)

 - Reduce the limbo bitmap size due to worries of mass memory
   consumption on larg CPU systems (Peter Zijlstra)

 - Picked a patch (2) from Jiri to fix the -I (interval) mode of perf
   stat with CQM

Changes in v2:

 - Added Jiri Olsa's Acked-by to PATCH 02/11.

 - Use x86_match_cpu() in intel_cqm_init() and make sure we grab the
   hotplug lock to prevent races as pointed out by Andi Kleen in
   PATCH 08/11.

 - Delete a stale comment in commit message of PATCH 10/11.

Jiri Olsa (1):
  perf tools: Implement snapshot event file logic

Matt Fleming (9):
  perf tools: Parse event per-package info files
  perf: Make perf_cgroup_from_task() global
  perf: Add ->count() function to read per-package counters
  perf: Move cgroup init before PMU ->event_init()
  perf/x86/intel: Add Intel Cache QoS Monitoring support
  perf/x86/intel: Implement LRU monitoring ID allocation for CQM
  perf/x86/intel: Support task events with Intel CQM
  perf/x86/intel: Perform rotation on Intel CQM RMIDs
  perf/x86/intel: Enable conflicting event scheduling for CQM

Peter P Waskiewicz Jr (1):
  x86: Add support for Intel Cache QoS Monitoring (CQM) detection

 arch/x86/include/asm/cpufeature.h          |    9 +-
 arch/x86/include/asm/processor.h           |    3 +
 arch/x86/kernel/cpu/Makefile               |    2 +-
 arch/x86/kernel/cpu/common.c               |   39 +
 arch/x86/kernel/cpu/perf_event_intel_cqm.c | 1340 ++++++++++++++++++++++++++++
 include/linux/perf_event.h                 |   48 +
 include/uapi/linux/perf_event.h            |    1 +
 kernel/events/core.c                       |   63 +-
 tools/perf/builtin-stat.c                  |   88 +-
 tools/perf/util/evsel.c                    |   12 +-
 tools/perf/util/evsel.h                    |    9 +-
 tools/perf/util/parse-events.c             |    2 +
 tools/perf/util/pmu.c                      |   74 +-
 tools/perf/util/pmu.h                      |    4 +
 14 files changed, 1634 insertions(+), 60 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_cqm.c

-- 
1.9.3

