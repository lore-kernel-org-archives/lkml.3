Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbbANMWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:22:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:32518 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbbANMWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:22:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,755,1413270000"; 
   d="scan'208";a="650957777"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v9 00/14] perf: Add infrastructure and support for Intel PT
Date: Wed, 14 Jan 2015 14:18:09 +0200
Message-Id: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and all,

Here's version 9 of PT support, addressing comments to the previous
version. This series applies to tip perf/core branch and to v3.18, but
has one trivial conflict with Linus' master in cpu features department.

[full description below the changelog]

Changes since v8:
  * refuse to load if PT is enabled during driver initialization,
    issue a warning,
  * added more elaborate comments about handle_nmi in the PT driver,
  * added a comment for the ITRACE_START record.

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

This patchset consists of necessary changes to the perf kernel
infrastructure, and PT and BTS pmu drivers. The tooling support is not
included in this series, however, it can be found in my github tree [2].

[1] chapter 36 of
http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf
[2] http://github.com/virtuoso/linux-perf/tree/intel_pt

Alexander Shishkin (13):
  perf: Add data_{offset,size} to user_page
  perf: Support high-order allocations for AUX space
  perf: Add a capability for AUX_NO_SG pmus to do software double
    buffering
  perf: Add a pmu capability for "exclusive" events
  perf: Add AUX record
  perf: Add api for pmus to write to AUX area
  perf: Support overwrite mode for AUX area
  perf: Add wakeup watermark control to AUX area
  x86: Add Intel Processor Trace (INTEL_PT) cpu feature detection
  x86: perf: Intel PT and LBR/BTS are mutually exclusive
  x86: perf: intel_pt: Intel PT PMU driver
  x86: perf: intel_bts: Add BTS PMU driver
  perf: add ITRACE_START record to indicate that tracing has started

Peter Zijlstra (1):
  perf: Add AUX area to ring buffer for raw data streams

 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/include/uapi/asm/msr-index.h      |   18 +
 arch/x86/kernel/cpu/Makefile               |    1 +
 arch/x86/kernel/cpu/intel_pt.h             |  131 ++++
 arch/x86/kernel/cpu/perf_event.c           |   43 ++
 arch/x86/kernel/cpu/perf_event.h           |   49 ++
 arch/x86/kernel/cpu/perf_event_intel.c     |   40 +-
 arch/x86/kernel/cpu/perf_event_intel_bts.c |  525 +++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |    3 +-
 arch/x86/kernel/cpu/perf_event_intel_pt.c  | 1095 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/scattered.c            |    1 +
 include/linux/perf_event.h                 |   47 +-
 include/uapi/linux/perf_event.h            |   60 +-
 kernel/events/core.c                       |  268 ++++++-
 kernel/events/internal.h                   |   33 +
 kernel/events/ring_buffer.c                |  327 ++++++++-
 16 files changed, 2591 insertions(+), 51 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/intel_pt.h
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_bts.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_pt.c

-- 
2.1.4

