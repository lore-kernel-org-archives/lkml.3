Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaBFKvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:51:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:55537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901AbaBFKut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:50:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="478983257"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v1 00/11] perf: Add support for Intel Processor Trace
Date: Thu,  6 Feb 2014 12:50:23 +0200
Message-Id: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and all,

Here's the second attempt at Intel PT support patchset, this time I
only include the kernel part, since it requires more scrutiny. The
whole patchset including the userspace currently can be found in my
github repo [1]. Major changes since the previous version are:

 * magic mmap() offset got replaced with a separate file descriptor,
 which is a 2nd ring buffer attached to the same event; this way, the
 first ring buffer (perf stream) receives trace buffer related events
 such as the one that signals trace data being lost (ITRACE_LOST), in
 addition to the normal sideband data,
 * added a driver for BTS per Ingo's request, now BTS can be used via
 the same interface as Intel PT, thus illustrating the capabilities of
 "itrace" framework to those who are interested,
 * massive patches got split into more digestible ones for the benefit
 of the reviewer,
 * added support for multiple itrace pmus (since we have to accomodate
 both PT and BTS now),
 * various small changes.

This patchset adds support for Intel Processor Trace (PT) extension [2] of
Intel Architecture that allows the capture of information about software
execution flow, to the perf kernel and userspace infrastructure. We
provide an abstraction for it called "itrace" for "instruction
trace" ([3]).

The single most notable thing is that while PT outputs trace data in a
compressed binary format, it will still generate hundreds of megabytes
of trace data per second per core. Decoding this binary stream takes
2-3 orders of magnitude the cpu time that it takes to generate
it. These considerations make it impossible to carry out decoding in
kernel space. Therefore, the trace data is exported to userspace as a
zero-copy mapping that userspace can collect and store for later
decoding. To that end, perf is extended to support an additional ring
buffer per event, which will export the trace data. This ring buffer
is mapped from a file descriptor, which is derived from the event's
file descriptor. This ring buffer has its own user page with data_head
and data_tail (in case the buffer is mapped writable) pointers used as
read/write pointers in the buffer.

This way we get a normal perf data stream that provides sideband
information that is required to decode the trace data, such as MMAPs,
COMMs etc, plus the actual trace in a separate buffer.

If the trace buffer is mapped writable, the driver will stop tracing
when it fills up (data_head approaches data_tail), till data is read,
data_tail pointer is moved forward and an ioctl() is issued to
re-enable tracing. If the trace buffer is mapped read only, the
tracing will continue, overwriting older data, so that the buffer
always contains the most recent data. Tracing can be stopped with an
ioctl() and restarted once the data is collected.

Another use case is annotating samples of other perf events: if you
set PERF_SAMPLE_ITRACE, attr.itrace_sample_size bytes of trace will be
included in each event's sample.

Also, itrace data can be included in process core dumps, which can be
enabled with a new rlimit -- RLIMIT_ITRACE.

[1] https://github.com/virtuoso/linux-perf/tree/intel_pt
[2] http://download-software.intel.com/sites/default/files/managed/50/1a/319433-018.pdf
[3] http://events.linuxfoundation.org/sites/events/files/slides/lcna13_kleen.pdf

Alexander Shishkin (11):
  x86: Add Intel Processor Trace (INTEL_PT) cpu feature detection
  perf: Abstract ring_buffer backing store operations
  perf: Allow for multiple ring buffers per event
  itrace: Infrastructure for instruction flow tracing units
  itrace: Add functionality to include traces in perf event samples
  itrace: Add functionality to include traces in process core dumps
  x86: perf: intel_pt: Intel PT PMU driver
  x86: perf: intel_pt: Add sampling functionality
  x86: perf: intel_pt: Add core dump functionality
  x86: perf: intel_bts: Add BTS PMU driver
  x86: perf: intel_bts: Add core dump related functionality

 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/include/uapi/asm/msr-index.h      |   18 +
 arch/x86/kernel/cpu/Makefile               |    1 +
 arch/x86/kernel/cpu/intel_pt.h             |  129 +++
 arch/x86/kernel/cpu/perf_event.c           |    4 +
 arch/x86/kernel/cpu/perf_event.h           |    6 +
 arch/x86/kernel/cpu/perf_event_intel.c     |   16 +-
 arch/x86/kernel/cpu/perf_event_intel_bts.c |  500 ++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |    3 +-
 arch/x86/kernel/cpu/perf_event_intel_pt.c  | 1180 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/scattered.c            |    1 +
 fs/binfmt_elf.c                            |    6 +
 fs/proc/base.c                             |    1 +
 include/asm-generic/resource.h             |    1 +
 include/linux/itrace.h                     |  162 ++++
 include/linux/perf_event.h                 |   34 +-
 include/uapi/asm-generic/resource.h        |    3 +-
 include/uapi/linux/elf.h                   |    1 +
 include/uapi/linux/perf_event.h            |   22 +-
 kernel/events/Makefile                     |    2 +-
 kernel/events/core.c                       |  341 +++++---
 kernel/events/internal.h                   |   39 +-
 kernel/events/itrace.c                     |  705 +++++++++++++++++
 kernel/events/ring_buffer.c                |  178 +++--
 kernel/exit.c                              |    3 +
 kernel/sys.c                               |    5 +
 26 files changed, 3189 insertions(+), 173 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/intel_pt.h
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_bts.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_pt.c
 create mode 100644 include/linux/itrace.h
 create mode 100644 kernel/events/itrace.c

-- 
1.8.5.2

