Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaBKPUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:20:32 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38798 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaBKPUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:20:31 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v2 0/8] perf/x86/uncore: add support for SNB/IVB/HSW integrated memory controller PMU
Date: Tue, 11 Feb 2014 16:20:06 +0100
Message-Id: <1392132015-14521-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for SandyBridge, IvyBridge, Haswell client (desktop/mobile)
processor PCI-based integrated memory controller PMU. This PMU provides a few free running
32-bit counters which can be used to determine memory bandwidth utilization.

The code is based on the documentation at:
http://software.intel.com/en-us/articles/monitoring-integrated-memory-controller-requests-in-the-2nd-3rd-and-4th-generation-intel

The patches implement a new uncore PMU called uncore_imc.
It exports its format and events in sysfs as usual.

The following events are currently defined:
  - name: uncore_imc/data_reads/
  - code: 0x1
  - unit: 64 bytes
  - number of full cacheline (64 bytes) read requests to the IMC

  - name: uncore_imc/data_writes/
  - code: 0x2
  - unit: 64 bytes
  - number of full cacheline (64 bytes) write requests to the IMC

The unit and scale of each event are also exposed in sysfs and
are picked up by perf stat (needs v3.13).

The uncore_imc PMU is by construction system-wide only and counting
mode only. There is no priv level filtering. The kernel enforces
those restrictions. Counters are 32-bit and do not generate overflow
interrupts, therefore the kernel uses a hrtimer to poll the counters
and avoid missing an overflow.

The series includes an optional patch to alter the unit of the event
to be Mebibytes in perf stat. The kernel still exports counts as
64 bytes increments (raw value of the counter).

To use the PMU with perf stat:
 # perf stat -a -e uncore_imc/data_reads/,uncore_imc/data_writes/ -I 1000 sleep 100
   #           time             counts unit events
        1.000169151             180.62 MiB  uncore_imc/data_reads/
        1.000169151               0.14 MiB  uncore_imc/data_writes/  
        2.000506913             180.37 MiB  uncore_imc/data_reads/   
        2.000506913               0.02 MiB  uncore_imc/data_writes/  
        3.000748105             180.32 MiB  uncore_imc/data_reads/   
        3.000748105               0.02 MiB  uncore_imc/data_writes/  
        4.000991441             180.30 MiB  uncore_imc/data_reads/   

In v2, we drop a couple of patches because they were not needed.
We rebased to 3.14-rc2 from tip.git.

Signed-off-by: Stephane Eranian <eranian@google.com>


Stephane Eranian (8):
  perf/x86/uncore: fix initialization of cpumask
  perf/x86/uncore: add ability to customize pmu callbacks
  perf/x86/uncore: add PCI ids for SNB/IVB/HSW IMC
  perf/x86/uncore: make hrtimer timeout configurable per box
  perf/x86/uncore: move uncore_event_to_box() and uncore_pmu_to_box()
  perf/x86/uncore: add SNB/IVB/HSW client uncore memory controller
    support
  perf/x86/uncore: add hrtimer to SNB uncore IMC PMU
  perf/x86/uncore: use MiB unit for events for SNB/IVB/HSW IMC

 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  540 +++++++++++++++++++++----
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |    5 +
 include/linux/pci_ids.h                       |    3 +
 3 files changed, 477 insertions(+), 71 deletions(-)

-- 
1.7.9.5

