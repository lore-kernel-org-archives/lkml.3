Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab3LKMho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:37:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:48013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab3LKMhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:37:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422884764"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
Date: Wed, 11 Dec 2013 14:36:12 +0200
Message-Id: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support for Intel Processor Trace (PT) extension [1] of
Intel Architecture that allows the capture of information about software
execution flow, to the perf kernel and userspace infrastructure. We
provide an abstraction for it called "itrace" for "instruction
trace" ([2]).

The single most notable thing is that while PT outputs trace data in a
compressed binary format, it will still generate hundreds of megabytes
of trace data per second per core. Decoding this binary stream takes
2-3 orders of magnitude the cpu time that it takes to generate
it. These considerations make it impossible to carry out decoding in
kernel space. Therefore, the trace data is exported to userspace as a
zero-copy mapping that userspace can collect and store for later
decoding. To that end, perf is extended to support an additional ring
buffer per event, which will export the trace data. This ring buffer
is mapped from the event's file descriptor with a special "magic"
offset. This ring buffer has its own user page with data_head and
data_tail (in case the buffer is mapped writable) pointers used as
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

This patchset consists of necessary changes to the perf kernel
infrastructure, PT pmu driver and the remaining 60+ patches
meticulously add itrace/PT support to perf userspace.

Patch Summary

  1 - 5  kernel support for Intel PT
  6      Allow set-output for task contexts of different types
  7 - 34 perf tools preparatory changes
 35 - 64 perf tools Instruction Tracing support
 65 - 71 perf tools Intel PT support

[1] http://software.intel.com/en-us/intel-isa-extensions
[2] http://events.linuxfoundation.org/sites/events/files/slides/lcna13_kleen.pdf

Adrian Hunter (66):
  perf: Allow set-output for task contexts of different types
  perf tools: Record whether a dso is 64-bit
  perf tools: Let a user specify a PMU event without any config terms
  perf tools: Let default config be defined for a PMU
  perf tools: Add perf_pmu__scan_file()
  perf tools: Add perf_event_paranoid()
  perf tools: Add dsos__hit_all()
  perf tools: Add machine__get_thread_pid()
  perf tools: Add cpu to struct thread
  perf tools: Add ability to record the current tid for each cpu
  perf tools: Allow header->data_offset to be predetermined
  perf tools: Add perf_evlist__can_select_event()
  perf session: Flag if the event stream is entirely in memory
  perf evlist: Pass mmap parameters in a struct
  perf tools: Move mem_bswap32/64 to util.c
  perf tools: Add feature test for __sync_val_compare_and_swap
  perf tools: Add option macro OPT_CALLBACK_OPTARG
  perf evlist: Add perf_evlist__to_front()
  perf evlist: Add perf_evlist__set_tracking_event()
  perf evsel: Add 'no_aux_samples' option
  perf evsel: Add 'immediate' option
  perf evlist: Add 'system_wide' option
  perf tools: Add id index
  perf pmu: Let pmu's with no events show up on perf list
  perf session: Add ability to skip 4GiB or more
  perf session: Add perf_session__deliver_synth_event()
  perf tools: Allow TSC conversion on any arch
  perf tools: Move rdtsc() function
  perf evlist: Add perf_evlist__enable_event_idx()
  perf tools: Add itrace members of struct perf_event_attr
  perf tools: Add support for parsing pmu itrace_config
  perf tools: Add support for PERF_RECORD_ITRACE_LOST
  perf tools: Add itrace sample parsing
  perf header: Add Instruction Tracing feature
  perf evlist: Add ability to mmap itrace buffers
  perf tools: Add user events for Instruction Tracing
  perf tools: Add support for Instruction Trace recording
  perf record: Add basic Instruction Tracing support
  perf record: Extend -m option for Instruction Tracing mmap pages
  perf tools: Add a user event for Instruction Tracing errors
  perf session: Add Instruction Tracing hooks
  perf session: Add Instruction Tracing options
  perf session: Make perf_event__itrace_swap() non-static
  perf itrace: Add helpers for Instruction Tracing errors
  perf itrace: Add helpers for queuing Instruction Tracing data
  perf itrace: Add a heap for sorting Instruction Tracing queues
  perf itrace: Add processing for Instruction Tracing events
  perf script: Add Instruction Tracing support
  perf script: Always allow fields 'addr' and 'cpu' for itrace
  perf report: Add Instruction Tracing support
  perf tools: Add Instruction Trace sampling support
  perf record: Add Instruction Trace sampling support
  perf tools: Add Instruction Tracing Snapshot Mode
  perf record: Add Instruction Tracing Snapshot Mode support
  perf inject: Re-pipe Instruction Tracing events
  perf inject: Add Instruction Tracing support
  perf inject: Cut Instruction Tracing samples
  perf tools: Add Instruction Tracing index
  perf tools: Hit all build ids when Instruction Tracing
  perf itrace: Add Intel PT as an Instruction Tracing type
  perf tools: Add Intel PT packet decoder
  perf tools: Add Intel PT instruction decoder
  perf tools: Add Intel PT log
  perf tools: Add Intel PT decoder
  perf tools: Add Intel PT support
  perf tools: Take Intel PT into use

Alexander Shishkin (5):
  perf: Disable all pmus on unthrottling and rescheduling
  x86: Add Intel Processor Trace (INTEL_PT) cpu feature detection
  perf: Abstract ring_buffer backing store operations
  itrace: Infrastructure for instruction flow tracing units
  x86: perf: Intel PT PMU driver

 arch/x86/include/asm/cpufeature.h                  |    1 +
 arch/x86/include/uapi/asm/msr-index.h              |   18 +
 arch/x86/kernel/cpu/Makefile                       |    1 +
 arch/x86/kernel/cpu/intel_pt.h                     |  129 ++
 arch/x86/kernel/cpu/perf_event.c                   |    4 +
 arch/x86/kernel/cpu/perf_event_intel.c             |   10 +
 arch/x86/kernel/cpu/perf_event_intel_pt.c          | 1167 +++++++++++
 arch/x86/kernel/cpu/scattered.c                    |    1 +
 fs/binfmt_elf.c                                    |    6 +
 fs/proc/base.c                                     |    1 +
 include/asm-generic/resource.h                     |    1 +
 include/linux/itrace.h                             |  147 ++
 include/linux/perf_event.h                         |   33 +-
 include/uapi/asm-generic/resource.h                |    3 +-
 include/uapi/linux/elf.h                           |    1 +
 include/uapi/linux/perf_event.h                    |   25 +-
 kernel/events/Makefile                             |    2 +-
 kernel/events/core.c                               |  329 ++-
 kernel/events/internal.h                           |   21 +-
 kernel/events/itrace.c                             |  589 ++++++
 kernel/events/ring_buffer.c                        |  176 +-
 kernel/exit.c                                      |    3 +
 kernel/sys.c                                       |    5 +
 tools/perf/Documentation/intel-pt.txt              |  581 ++++++
 tools/perf/Documentation/perf-inject.txt           |   20 +
 tools/perf/Documentation/perf-record.txt           |   14 +
 tools/perf/Documentation/perf-report.txt           |   21 +
 tools/perf/Documentation/perf-script.txt           |   21 +
 tools/perf/Makefile.perf                           |   30 +-
 tools/perf/arch/x86/Makefile                       |    2 +
 tools/perf/arch/x86/util/itrace.c                  |   41 +
 tools/perf/arch/x86/util/pmu.c                     |   13 +
 tools/perf/arch/x86/util/tsc.c                     |   31 +-
 tools/perf/arch/x86/util/tsc.h                     |    3 -
 tools/perf/builtin-buildid-list.c                  |    9 +
 tools/perf/builtin-inject.c                        |  193 +-
 tools/perf/builtin-record.c                        |  277 ++-
 tools/perf/builtin-report.c                        |   12 +
 tools/perf/builtin-script.c                        |   13 +
 tools/perf/config/Makefile                         |    5 +
 tools/perf/config/feature-checks/Makefile          |    4 +
 tools/perf/config/feature-checks/test-all.c        |    5 +
 .../feature-checks/test-sync-compare-and-swap.c    |   14 +
 tools/perf/perf.h                                  |   14 +
 tools/perf/tests/perf-time-to-tsc.c                |   12 +-
 tools/perf/tests/pmu.c                             |    2 +-
 tools/perf/tests/sample-parsing.c                  |    7 +-
 tools/perf/util/dso.c                              |    1 +
 tools/perf/util/dso.h                              |    1 +
 tools/perf/util/event.c                            |   21 +
 tools/perf/util/event.h                            |   70 +
 tools/perf/util/evlist.c                           |  289 ++-
 tools/perf/util/evlist.h                           |   19 +
 tools/perf/util/evsel.c                            |   86 +-
 tools/perf/util/evsel.h                            |   19 +-
 tools/perf/util/header.c                           |   73 +-
 tools/perf/util/header.h                           |    3 +
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  | 1678 +++++++++++++++
 .../perf/util/intel-pt-decoder/intel-pt-decoder.h  |   83 +
 .../util/intel-pt-decoder/intel-pt-insn-decoder.c  |  224 ++
 .../util/intel-pt-decoder/intel-pt-insn-decoder.h  |   67 +
 tools/perf/util/intel-pt-decoder/intel-pt-log.c    |  119 ++
 tools/perf/util/intel-pt-decoder/intel-pt-log.h    |   52 +
 .../util/intel-pt-decoder/intel-pt-pkt-decoder.c   |  404 ++++
 .../util/intel-pt-decoder/intel-pt-pkt-decoder.h   |   68 +
 tools/perf/util/intel-pt.c                         | 2193 ++++++++++++++++++++
 tools/perf/util/intel-pt.h                         |   40 +
 tools/perf/util/itrace.c                           | 1273 ++++++++++++
 tools/perf/util/itrace.h                           |  476 +++++
 tools/perf/util/machine.c                          |   85 +
 tools/perf/util/machine.h                          |   11 +
 tools/perf/util/parse-events.c                     |   17 +-
 tools/perf/util/parse-events.h                     |    1 +
 tools/perf/util/parse-events.l                     |    1 +
 tools/perf/util/parse-events.y                     |   10 +
 tools/perf/util/parse-options.h                    |    5 +
 tools/perf/util/pmu.c                              |   95 +-
 tools/perf/util/pmu.h                              |   14 +-
 tools/perf/util/pmu.l                              |    1 +
 tools/perf/util/pmu.y                              |    9 +-
 tools/perf/util/record.c                           |   43 +-
 tools/perf/util/session.c                          |  343 ++-
 tools/perf/util/session.h                          |   27 +-
 tools/perf/util/symbol-elf.c                       |    3 +
 tools/perf/util/symbol-minimal.c                   |   23 +
 tools/perf/util/symbol.c                           |    1 +
 tools/perf/util/symbol.h                           |    1 +
 tools/perf/util/thread.c                           |    1 +
 tools/perf/util/thread.h                           |    1 +
 tools/perf/util/tool.h                             |   12 +-
 tools/perf/util/tsc.c                              |   30 +
 tools/perf/util/tsc.h                              |   12 +
 tools/perf/util/util.c                             |   41 +
 tools/perf/util/util.h                             |    6 +
 94 files changed, 11708 insertions(+), 361 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/intel_pt.h
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_pt.c
 create mode 100644 include/linux/itrace.h
 create mode 100644 kernel/events/itrace.c
 create mode 100644 tools/perf/Documentation/intel-pt.txt
 create mode 100644 tools/perf/arch/x86/util/itrace.c
 create mode 100644 tools/perf/arch/x86/util/pmu.c
 create mode 100644 tools/perf/config/feature-checks/test-sync-compare-and-swap.c
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-log.c
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-log.h
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.h
 create mode 100644 tools/perf/util/intel-pt.c
 create mode 100644 tools/perf/util/intel-pt.h
 create mode 100644 tools/perf/util/itrace.c
 create mode 100644 tools/perf/util/itrace.h
 create mode 100644 tools/perf/util/tsc.c
 create mode 100644 tools/perf/util/tsc.h

-- 
1.8.5.1

