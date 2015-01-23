Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbbAWSpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:45:55 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51758 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbAWSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:45:52 -0500
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v5 0/9] perf: Intel Cache QoS Monitoring support
Date: Fri, 23 Jan 2015 18:45:39 +0000
Message-Id: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

This patch series adds a new PMU driver for the Intel Cache Monitoring
hardware feature available in Intel Xeon processors, which allows
monitoring of LLC occupancy on a task, group or system-wide basis.

All the tools/perf changes have already been merged. 

I've left a notoriously funky bit of code near the end of the series,
the RMID rotation code, in an attempt to simplify things. Doing the
rotation provides the ability to multiplex the RMIDs and basically
overcome the hardware limitation, but the rest of the patches work fine
without it. But there are a number of scenarios where being able to
monitor more tasks than RMIDs is extremely useful.

The series is based on tip/perf/core.

Changes in v5:

 - Drop the patches to tools/perf that have been picked up

 - Use ACCESS_ONCE() to grab RMID instead of using locks

 - Pack struct cqm_rmid_entry by rearranging members

 - Add steal limit code to mitigate all RMIDs ending up in limbo

 - s/intel_cqm_sched_out_events/intel_cqm_sched_out_conflicting_events/

 - Drop list_move_tail() from scheduling code as it breaks fairness

Changes in v4:

 - Swapped smp_call_function_many() for on_each_cpu_mask()

 - Use atomic_t for serialisation for cache occupancy IPI reads 

 - Calculate a max threshold value based on number of RMIDs and LLC size

 - Drop the list, bitmap, list juggle in favour of RMID ->state member

 - Use pmu::hrtimer_interval_ms as rotation timer tick for consistency

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


Matt Fleming (8):
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
 arch/x86/kernel/cpu/perf_event_intel_cqm.c | 1379 ++++++++++++++++++++++++++++
 include/linux/perf_event.h                 |   48 +
 include/uapi/linux/perf_event.h            |    1 +
 kernel/events/core.c                       |   63 +-
 8 files changed, 1502 insertions(+), 42 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_cqm.c

-- 
1.9.3

