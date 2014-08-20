Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaHTMjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:39:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:23530 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbaHTMje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:39:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,902,1400050800"; 
   d="scan'208";a="561069322"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v4 00/22] perf: Add infrastructure and support for Intel PT
Date: Wed, 20 Aug 2014 15:35:57 +0300
Message-Id: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and all,

This patchset adds support for Intel Processor Trace (PT) extension [1] of
Intel Architecture that allows the capture of information about software
execution flow, to the perf kernel infrastructure.

The single most notable thing is that while PT outputs trace data in a
compressed binary format, it will still generate hundreds of megabytes
of trace data per second per core. Decoding this binary stream takes
2-3 orders of magnitude the cpu time that it takes to generate
it. These considerations make it impossible to carry out decoding in
kernel space. Therefore, the trace data is exported to userspace as a
zero-copy mapping that userspace can collect and store for later
decoding. To address this, this patchset extends perf ring buffer with
an "AUX space", which is allocated for hardware blocks such as PT to
export their trace data with minimal overhead. This space can be
configured via buffer's user page and mmapped from the same file
descriptor with a given offset. Data can then be collected from it
by reading the aux_head (write) pointer from the user page and updating
aux_tail (read) pointer similarly to data_{head,tail} of the
traditional perf buffer. There is an api between perf core and pmu
drivers that wish to make use of this AUX space to export their data.

For tracing blocks that don't support hardware scatter-gather tables,
we provide high-order physically contiguous allocations to minimize
the overhead needed for software double buffering and PMI pressure.

This way we get a normal perf data stream that provides sideband
information that is required to decode the trace data, such as MMAPs,
COMMs etc, plus the actual trace in its own logical space.

If the trace buffer is mapped writable, the driver will stop tracing
when it fills up (aux_head approaches aux_tail), till data is read,
aux_tail pointer is moved forward and an ioctl() is issued to
re-enable tracing. If the trace buffer is mapped read only, the
tracing will continue, overwriting older data, so that the buffer
always contains the most recent data. Tracing can be stopped with an
ioctl() and restarted once the data is collected.

Another use case is annotating samples of other perf events: setting
PERF_SAMPLE_AUX requests attr.aux_sample_size bytes of trace to be
included in each event's sample.

This patchset consists of necessary changes to the perf kernel
infrastructure, and PT and BTS pmu drivers. The tooling support is not
included in this series, however, it can be found in my github tree [2].

This version changes the way watermarks are handled for AUX area and
gets rid of the notion of "itrace" both in the core and in the perf
interface (event attribute), which makes it more logical.

[1] http://software.intel.com/en-us/intel-isa-extensions
[2] http://github.com/virtuoso/linux-perf/tree/intel_pt

Alexander Shishkin (21):
  perf: Add data_{offset,size} to user_page
  perf: Support high-order allocations for AUX space
  perf: Add a capability for AUX_NO_SG pmus to do software double
    buffering
  perf: Add a pmu capability for "exclusive" events
  perf: Redirect output from inherited events to parents
  perf: Add api for pmus to write to AUX space
  perf: Add AUX record
  perf: Support overwrite mode for AUX area
  perf: Add wakeup watermark control to AUX area
  perf: add ITRACE_START record to indicate that tracing has started
  x86: Add Intel Processor Trace (INTEL_PT) cpu feature detection
  x86: perf: Intel PT and LBR/BTS are mutually exclusive
  x86: perf: intel_pt: Intel PT PMU driver
  x86: perf: intel_bts: Add BTS PMU driver
  perf: Add rb_{alloc,free}_kernel api
  perf: Add a helper to copy AUX data in the kernel
  perf: Add a helper for looking up pmus by type
  perf: Add infrastructure for using AUX data in perf samples
  perf: Allocate ring buffers for inherited per-task kernel events
  perf: Allow AUX sampling for multiple events
  perf: Allow sampling of inherited events

Peter Zijlstra (1):
  perf: Add AUX area to ring buffer for raw data streams

 arch/x86/include/asm/cpufeature.h          |   1 +
 arch/x86/include/uapi/asm/msr-index.h      |  18 +
 arch/x86/kernel/cpu/Makefile               |   1 +
 arch/x86/kernel/cpu/intel_pt.h             | 129 ++++
 arch/x86/kernel/cpu/perf_event.h           |  14 +
 arch/x86/kernel/cpu/perf_event_intel.c     |  14 +-
 arch/x86/kernel/cpu/perf_event_intel_bts.c | 501 +++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |  11 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   9 +-
 arch/x86/kernel/cpu/perf_event_intel_pt.c  | 973 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/scattered.c            |   1 +
 include/linux/perf_event.h                 |  56 +-
 include/uapi/linux/perf_event.h            |  69 +-
 kernel/events/core.c                       | 545 +++++++++++++++-
 kernel/events/internal.h                   |  50 ++
 kernel/events/ring_buffer.c                | 310 ++++++++-
 16 files changed, 2658 insertions(+), 44 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/intel_pt.h
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_bts.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_pt.c

-- 
2.1.0

