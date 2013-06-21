Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422992Ab3FUOVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:21:45 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38404 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161356Ab3FUOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:21:43 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 0/8] perf: add ability to sample physical data addresses
Date: Fri, 21 Jun 2013 16:20:40 +0200
Message-Id: <1371824448-7306-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series extends perf_events with the ability to sample
physical data addresses. This is useful with the memory access
sampling mode added just recently. In particular, it helps
disambiguate data addresses between two processes, such as
in the case of a shared memory segment mapped at different
addresses in different processes.

The patch adds the PERF_SAMPLE_PHYS_ADDR sample_type.
A 64-bit address is added to the sample record for
the corresponding event.

On Intel X86, it is used with the PEBS Load Latency
support. On other architectures, zero is returned.

The patch series also demonstrates the use of this
new feature by extending perf report, mem, record
with a --phys-addr option. When enable, it will 
capture physical data address and display it.
This is implemented as a new sort_order (symbol_paddr).

$ perf mem --phys-addr -t load rec ...
$ perf mem --phys-addr -t load rep ...

Note that for now on X86, only user addresses are converted
to physical whenever possible. Kernel addresses will show
as -1.

Thanks to Hugh Dickins for the uvirt_to_phys_nmi() code.

The series contains a couple of patches related to
PEBS in general:
 - Patch 1 contains a small bug fix to clear the PEBS-LL
   bits in pebs_enable in intel_pmu_pebs_disable().

 - Patch 2 removes event->flags because it is not used
   anymore. The code now uses event->hw.constraints->flags.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

Stephane Eranian (8):
  perf,x86: disable PEBS-LL in intel_pmu_pebs_disable()
  perf,x86: drop event->flags and use hw.constraint->flags
  perf,x86: add uvirt_to_phys_nmi helper function
  perf: add PERF_SAMPLE_PHYS_ADDR sample type
  perf,x86: add support for PERF_SAMPLE_PHYS_ADDR for PEBS-LL
  perf tools: add infrastructure to handle PERF_SAMPLE_PHYS_ADDR
  perf record: add option to sample physical load/store addresses
  perf mem: add physical addr sampling support

 arch/x86/include/asm/uaccess.h            |   1 +
 arch/x86/kernel/cpu/perf_event_intel.c    |   6 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  28 +++++---
 arch/x86/lib/usercopy.c                   |  43 +++++++++++
 include/linux/perf_event.h                |   3 +-
 include/uapi/linux/perf_event.h           |   3 +-
 kernel/events/core.c                      |   6 ++
 tools/perf/Documentation/perf-record.txt  |   4 ++
 tools/perf/builtin-mem.c                  | 116 +++++++++++++++++++++++-------
 tools/perf/builtin-record.c               |   2 +
 tools/perf/builtin-report.c               |   2 +-
 tools/perf/perf.h                         |   1 +
 tools/perf/util/event.h                   |   1 +
 tools/perf/util/evsel.c                   |  16 ++++-
 tools/perf/util/hist.c                    |   4 +-
 tools/perf/util/hist.h                    |   1 +
 tools/perf/util/machine.c                 |   1 +
 tools/perf/util/session.c                 |   6 ++
 tools/perf/util/sort.c                    |  42 +++++++++++
 tools/perf/util/sort.h                    |   1 +
 tools/perf/util/symbol.h                  |   1 +
 21 files changed, 243 insertions(+), 45 deletions(-)

-- 
1.8.1.2

