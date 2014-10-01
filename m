Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaJAOgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:36:37 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53179 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaJAOgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:36:36 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2 00/11] perf: Intel Cache QoS Monitoring support
Date: Wed,  1 Oct 2014 15:36:21 +0100
Message-Id: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
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

Changes in v2:

 - Added Jiri Olsa's Acked-by to PATCH 02/11.

 - Use x86_match_cpu() in intel_cqm_init() and make sure we grab the
   hotplug lock to prevent races as pointed out by Andi Kleen in
   PATCH 08/11.

 - Delete a stale comment in commit message of PATCH 10/11.

Matt Fleming (10):
  perf stat: Fix AGGR_CORE segfault on multi-socket system
  perf tools: Refactor unit and scale function parameters
  perf tools: Parse event per-package info files
  perf: Make perf_cgroup_from_task() global
  perf: Add ->count() function to read per-package counters
  perf: Move cgroup init before PMU ->event_init()
  perf/x86/intel: Add Intel Cache QoS Monitoring support
  perf/x86/intel: Implement LRU monitoring ID allocation for CQM
  perf/x86/intel: Support task events with Intel CQM
  perf/x86/intel: Perform rotation on Intel CQM RMIDs

Peter P Waskiewicz Jr (1):
  x86: Add support for Intel Cache QoS Monitoring (CQM) detection

 arch/x86/include/asm/cpufeature.h          |    9 +-
 arch/x86/include/asm/processor.h           |    3 +
 arch/x86/kernel/cpu/Makefile               |    2 +-
 arch/x86/kernel/cpu/common.c               |   39 +
 arch/x86/kernel/cpu/perf_event_intel_cqm.c | 1171 ++++++++++++++++++++++++++++
 include/linux/perf_event.h                 |   48 ++
 include/uapi/linux/perf_event.h            |    1 +
 kernel/events/core.c                       |   63 +-
 tools/perf/builtin-stat.c                  |   81 +-
 tools/perf/util/evsel.c                    |    6 +-
 tools/perf/util/evsel.h                    |    8 +-
 tools/perf/util/parse-events.c             |   10 +-
 tools/perf/util/pmu.c                      |   66 +-
 tools/perf/util/pmu.h                      |    8 +-
 14 files changed, 1446 insertions(+), 69 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_cqm.c

-- 
1.9.3

