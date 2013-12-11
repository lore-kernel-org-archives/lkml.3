Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3LKMoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:44:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:39469 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab3LKMnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:43:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448281856"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 71/71] perf tools: Take Intel PT into use
Date: Wed, 11 Dec 2013 14:37:23 +0200
Message-Id: <1386765443-26966-72-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

To record an Instruction Trace, the weak function
itrace_record__init() must be implemented.

Equally to decode an Instruction Trace, the
Instruction Tracing type must be added to the
perf_event__process_itrace_info() function.

This patch makes those two changes plus hooks
up default config for the intel_pt PMU.  Also
some brief documentation is provided for
using the tools with intel_pt.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/intel-pt.txt | 581 ++++++++++++++++++++++++++++++++++
 tools/perf/arch/x86/Makefile          |   2 +
 tools/perf/arch/x86/util/itrace.c     |  41 +++
 tools/perf/arch/x86/util/pmu.c        |  13 +
 tools/perf/util/itrace.c              |   7 +-
 5 files changed, 642 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/Documentation/intel-pt.txt
 create mode 100644 tools/perf/arch/x86/util/itrace.c
 create mode 100644 tools/perf/arch/x86/util/pmu.c

diff --git a/tools/perf/Documentation/intel-pt.txt b/tools/perf/Documentation/intel-pt.txt
new file mode 100644
index 0000000..977f5a0
--- /dev/null
+++ b/tools/perf/Documentation/intel-pt.txt
@@ -0,0 +1,581 @@
+Intel Processor Trace
+=====================
+
+perf record
+===========
+
+new event
+---------
+
+The Intel PT kernel driver creates a new PMU for Intel PT.  PMU events are
+selected by providing the PMU name followed by the "config" separated by slashes.
+An enhancement has been made to allow default "config" e.g. the option
+
+	-e intel_pt//
+
+will use a default config value.  Currently that is the same as
+
+	-e intel_pt/tsc,noretcomp=0/
+
+which is the same as
+
+	-e intel_pt/tsc=1,noretcomp=0/
+
+The config terms are listed in /sys/devices/intel_pt/format.  They are bit
+fields within the itrace_config member of the struct perf_event_attr which is
+passed to the kernel by the perf_event_open system call.  They correspond to bit
+fields in the IA32_RTIT_CTL MSR.  Here is a list of them and their definitions:
+
+	$ for f in `ls /sys/devices/intel_pt/format`;do
+	> echo $f
+	> cat /sys/devices/intel_pt/format/$f
+	> done
+	noretcomp
+	itrace_config:11
+	tsc
+	itrace_config:10
+
+Note that the default config must be overridden for each term i.e.
+
+	-e intel_pt/noretcomp=0/
+
+is the same as:
+
+	-e intel_pt/tsc=1,noretcomp=0/
+
+So, to disable TSC packets use:
+
+	-e intel_pt/tsc=0/
+
+It is also possible to specify the itrace_config value explicitly:
+
+	-e intel_pt/itrace_config=0x400/
+
+Note that, as with all events, the event is suffixed with event modifiers:
+
+	u	userspace
+	k	kernel
+	h	hypervisor
+	G	guest
+	H	host
+	p	precise ip
+
+'h', 'G' and 'H' are for virtualization which is not supported by Intel PT.
+'p' is also not relevant to Intel PT.  So only options 'u' and 'k' are
+meaningful for Intel PT.
+
+perf_event_attr is displayed if the -vv option is used e.g.
+
+	------------------------------------------------------------
+	perf_event_attr:
+	type                6
+	size                120
+	config              0
+	sample_period       1
+	sample_freq         1
+	sample_type         0x10087
+	read_format         0x4
+	disabled            1    inherit             1
+	pinned              0    exclusive           0
+	exclude_user        0    exclude_kernel      1
+	exclude_hv          1    exclude_idle        0
+	mmap                0    comm                0
+	freq                0    inherit_stat        0
+	enable_on_exec      1    task                0
+	watermark           0    precise_ip          0
+	mmap_data           0    sample_id_all       1
+	exclude_host        0    exclude_guest       0
+	excl.callchain_kern 0    excl.callchain_user 0
+	mmap2               0
+	wakeup_events       0
+	wakeup_watermark    0
+	bp_type             0
+	bp_addr             0
+	config1             0
+	bp_len              0
+	config2             0
+	branch_sample_type  0
+	sample_regs_user    0
+	sample_stack_user   0
+	itrace_config       0xc00
+	itrace_watermark    0
+	itrace_sample_type  0
+	itrace_sample_size  0
+	------------------------------------------------------------
+	perf_event_open: pid 20956  cpu 0  group_fd -1  flags 0
+	perf_event_open: pid 20956  cpu 1  group_fd -1  flags 0
+	perf_event_open: pid 20956  cpu 2  group_fd -1  flags 0
+	perf_event_open: pid 20956  cpu 3  group_fd -1  flags 0
+	------------------------------------------------------------
+
+
+new sampling option
+-------------------
+
+To select Intel PT "sampling" a new option has been added:
+
+	-I
+
+Optionally it can be followed by the sample size in bytes e.g.
+
+	-I4096
+
+It is important to select a sample size that is big enough to contain at least
+one PSB packet.  If not a warning will be displayed:
+
+	Intel PT sample size (%zu) may be too small for PSB period (%zu)
+
+The calculation used for that is: if sample_size <= psb_period + 256 display the
+warning.
+
+The default sample size is currently 4KiB
+
+The sample size is passed in itrace_sample_size in struct perf_event_attr.  The
+sample size is limited by the maximum event size which is 64KiB.  It is
+difficult to know how big the event might be without the trace sample attached,
+but the tool validates that the sample size is not greater than 60KiB.
+
+The sample size is displayed if the option -vv is used e.g.
+
+	Intel PT sample size: %zu
+
+Optionally the "config" can be specified in exactly the same fashion as the
+intel_pt event but without slashes e.g.
+
+	-Itsc=0,noretcomp=0
+
+or
+
+	-I1024tsc=0,noretcomp=0
+
+
+new snapshot option
+-------------------
+
+To select snapshot mode a new option has been added:
+
+	-S
+
+Optionally it can be followed by the snapshot size e.g.
+
+	-S0x100000
+
+The default snapshot size is the itrace mmap size.  If neither itrace mmap size
+nor snapshot size is specified, then the default is 4MiB for privileged users
+(or if /proc/sys/kernel/perf_event_paranoid < 0), 128KiB for unprivileged users.
+If an unprivileged user does not specify mmap pages, the mmap pages will be
+reduced as described in the 'new itrace mmap size option' section below.
+
+The snapshot size is displayed if the option -vv is used e.g.
+
+	Intel PT snapshot size: %zu
+
+
+new itrace mmap size option
+---------------------------
+
+Intel PT buffer size is specified by an addition to the -m option e.g.
+
+	-m,16
+
+selects a buffer size of 16 pages i.e. 64KiB.
+
+Note that the existing functionality of -m is unchanged.  The itrace mmap size
+is specified by the optional addition of a comma and the value.
+
+The default itrace mmap size for Intel PT is 4MiB/page_size for privileged users
+(or if /proc/sys/kernel/perf_event_paranoid < 0), 128KiB for unprivileged users.
+If an unprivileged user does not specify mmap pages, the mmap pages will be
+reduced from the default 512KiB/page_size to 256KiB/page_size, otherwise the
+user is likely to get an error as they exceed their mlock limit (Max locked
+memory as shown in /proc/self/limits).  Note that perf does not count the first
+512KiB (actually /proc/sys/kernel/perf_event_mlock_kb minus 1 page) per cpu
+against the mlock limit so an unprivileged user is allowed 512KiB per cpu plus
+their mlock limit (which defaults to 64KiB but is not multiplied by the number
+of cpus).
+
+In full-trace mode, powers of two and multiples of 128MiB are allowed for buffer
+size, with a minimum size of 1 page.  In snapshot mode, it is the same but the
+minimum size is 2 pages.  In sample mode, the driver manages the buffer size.
+
+The mmap size and itrace mmap size are displayed if the -vv option is used e.g.
+
+	mmap length 528384
+	itrace mmap length 4198400
+
+
+Intel PT modes of operation
+---------------------------
+
+Intel PT can be used in 3 modes:
+	full-trace mode
+	sample mode
+	snapshot mode
+
+Full-trace mode traces continuously e.g.
+
+	perf record -e intel_pt//u uname
+
+Sample mode attaches a Intel PT sample to other events e.g.
+
+	perf record -e branch-misses:u -I uname
+
+Snapshot mode captures the available data when a signal is sent e.g.
+
+	perf record -v -e intel_pt//u -S ./loopy 1000000000 &
+	[1] 11435
+	kill -USR2 11435
+	Recording instruction tracing snapshot
+
+Note that the signal sent is SIGUSR2.
+Note that "Recording instruction tracing snapshot" is displayed because the -v
+option is used.
+
+None of the 3 modes can be used together.
+
+
+Buffer handling
+---------------
+
+There may be buffer limitations (i.e. single ToPa entry) which means that actual
+buffer sizes are limited to powers of 2 up to 128MiB.  In order to provide other
+sizes, and in particular an arbitrarily large size, multiple buffers are
+logically concatenated.  However an interrupt must be used to switch between
+buffers.  That has two potential problems:
+	a) the interrupt may not be handled in time so that the current buffer
+	becomes full and some trace data is lost.
+	b) the interrupts may slow the system and affect the performance
+	results.
+
+If trace data is lost, the driver adds a PERF_RECORD_ITRACE_LOST event to the
+event stream which the tools report as an error.
+
+In full-trace mode, the driver waits for data to be copied out before allowing
+the (logical) buffer to wrap-around.  If data is not copied out quickly enough,
+again a PERF_RECORD_ITRACE_LOST event is added to the event stream.  If the
+driver has to wait, the intel_pt event gets disabled.  Because it is difficult
+to know when that happens, perf tools always re-enable the intel_pt event
+after copying out data.
+
+Note that the choice of buffer size and output device (e.g. a fast SSD vs a slow
+disk) will affect the ability to capture a complete trace.
+
+
+Intel PT and build ids
+----------------------
+
+By default "perf record" post-processes the event stream to find all build ids
+for executables for all addresses sampled.  Deliberately, Intel PT is not
+decoded for that purpose (it would take too long).  Instead the build ids for
+all executables encountered (due to mmap, comm or task events) are included
+in the perf.data file.
+
+To see buildids included in the perf.data file use the command:
+
+	perf buildid-list
+
+If the perf.data file contains Intel PT data, that is the same as:
+
+	perf buildid-list --with-hits
+
+
+Snapshot mode and event disabling
+---------------------------------
+
+In order to make a snapshot, the intel_pt event is disabled using an IOCTL,
+namely PERF_EVENT_IOC_DISABLE.  However doing that can also disable the
+collection of side-band information.  In order to prevent that,  a dummy
+software event has been introduced that permits tracking events (like mmaps) to
+continue to be recorded while intel_pt is disabled.  That is important to ensure
+there is complete side-band information to allow the decoding of subsequent
+snapshots.
+
+A test has been created for that.  To find the test:
+
+	perf test list
+	...
+	23: Test using a dummy software event to keep tracking
+
+To run the test:
+
+	perf test 23
+	23: Test using a dummy software event to keep tracking     : Ok
+
+
+perf record modes (nothing new here)
+------------------------------------
+
+perf record essentially operates in one of three modes:
+	per thread
+	per cpu
+	workload only
+
+"per thread" mode is selected by -t or by --per-thread (with -p or -u or just a
+workload).
+"per cpu" is selected by -C or -a.
+"workload only" mode is selected by not using the other options but providing a
+command to run (i.e. the workload).
+
+In per-thread mode an exact list of threads is traced.  There is no inheritance.
+Each thread has its own event buffer.
+
+In per-cpu mode all processes (or processes from the selected cgroup i.e. -G
+option, or processes selected with -p or -u) are traced.  Each cpu has its own
+buffer. Inheritance is allowed.
+
+In workload-only mode, the workload is traced but with per-cpu buffers.
+Inheritance is allowed.  Note that you can now trace a workload in per-thread
+mode by using the --per-thread option.
+
+
+Privileged vs non-privileged users
+----------------------------------
+
+Unless /proc/sys/kernel/perf_event_paranoid is set to -1, unprivileged users
+have memory limits imposed upon them.  That affects what buffer sizes they can
+have as outlined above.
+
+Unless /proc/sys/kernel/perf_event_paranoid is set to -1, unprivileged users are
+not permitted to use tracepoints which means there is insufficient side-band
+information to decode Intel PT in per-cpu mode, and potentially workload-only
+mode too if the workload creates new processes.
+
+Note also, that to use tracepoints, read-access to debugfs is required.  So if
+debugfs is not mounted or the user does not have read-access, it will again not
+be possible to decode Intel PT in per-cpu mode.
+
+Note however, Intel PT samples are always decoded because the sample is very
+likely to be mainly from the thread that was running when the sample was taken.
+Obviously, if the sample includes a context switch from another process the
+decoding will fail if tracepoints were not available.
+
+
+sched_switch tracepoint
+-----------------------
+
+The sched_switch tracepoint is used to provide side-band data for Intel PT
+decoding.  sched_switch events are automatically added. e.g. the second event
+shown below
+
+	$ perf record -vv -e intel_pt//u uname
+	------------------------------------------------------------
+	perf_event_attr:
+	type                6
+	size                120
+	config              0
+	sample_period       1
+	sample_freq         1
+	sample_type         0x10087
+	read_format         0x4
+	disabled            1    inherit             1
+	pinned              0    exclusive           0
+	exclude_user        0    exclude_kernel      1
+	exclude_hv          1    exclude_idle        0
+	mmap                0    comm                0
+	freq                0    inherit_stat        0
+	enable_on_exec      1    task                0
+	watermark           0    precise_ip          0
+	mmap_data           0    sample_id_all       1
+	exclude_host        0    exclude_guest       0
+	excl.callchain_kern 0    excl.callchain_user 0
+	mmap2               0
+	wakeup_events       0
+	wakeup_watermark    0
+	bp_type             0
+	bp_addr             0
+	config1             0
+	bp_len              0
+	config2             0
+	branch_sample_type  0
+	sample_regs_user    0
+	sample_stack_user   0
+	itrace_config       0xc00
+	itrace_watermark    0
+	itrace_sample_type  0
+	itrace_sample_size  0
+	------------------------------------------------------------
+	perf_event_open: pid 21206  cpu 0  group_fd -1  flags 0
+	perf_event_open: pid 21206  cpu 1  group_fd -1  flags 0
+	perf_event_open: pid 21206  cpu 2  group_fd -1  flags 0
+	perf_event_open: pid 21206  cpu 3  group_fd -1  flags 0
+	------------------------------------------------------------
+	perf_event_attr:
+	type                2
+	size                120
+	config              0x143
+	sample_period       1
+	sample_freq         1
+	sample_type         0x10587
+	read_format         0x4
+	disabled            0    inherit             1
+	pinned              0    exclusive           0
+	exclude_user        0    exclude_kernel      0
+	exclude_hv          0    exclude_idle        0
+	mmap                0    comm                0
+	freq                0    inherit_stat        0
+	enable_on_exec      0    task                0
+	watermark           0    precise_ip          0
+	mmap_data           0    sample_id_all       1
+	exclude_host        0    exclude_guest       1
+	excl.callchain_kern 0    excl.callchain_user 0
+	mmap2               0
+	wakeup_events       0
+	wakeup_watermark    0
+	bp_type             0
+	bp_addr             0
+	config1             0
+	bp_len              0
+	config2             0
+	branch_sample_type  0
+	sample_regs_user    0
+	sample_stack_user   0
+	itrace_config       0
+	itrace_watermark    0
+	itrace_sample_type  0
+	itrace_sample_size  0
+	------------------------------------------------------------
+	perf_event_open: pid -1  cpu 0  group_fd -1  flags 0
+	perf_event_open: pid -1  cpu 1  group_fd -1  flags 0
+	perf_event_open: pid -1  cpu 2  group_fd -1  flags 0
+	perf_event_open: pid -1  cpu 3  group_fd -1  flags 0
+	------------------------------------------------------------
+	perf_event_attr:
+	type                1
+	size                120
+	config              0x9
+	sample_period       1
+	sample_freq         1
+	sample_type         0x10007
+	read_format         0x4
+	disabled            1    inherit             1
+	pinned              0    exclusive           0
+	exclude_user        0    exclude_kernel      1
+	exclude_hv          1    exclude_idle        0
+	mmap                1    comm                1
+	freq                0    inherit_stat        0
+	enable_on_exec      1    task                0
+	watermark           0    precise_ip          0
+	mmap_data           0    sample_id_all       1
+	exclude_host        0    exclude_guest       0
+	excl.callchain_kern 0    excl.callchain_user 0
+	mmap2               1
+	wakeup_events       0
+	wakeup_watermark    0
+	bp_type             0
+	bp_addr             0
+	config1             0
+	bp_len              0
+	config2             0
+	branch_sample_type  0
+	sample_regs_user    0
+	sample_stack_user   0
+	itrace_config       0
+	itrace_watermark    0
+	itrace_sample_type  0
+	itrace_sample_size  0
+	------------------------------------------------------------
+	perf_event_open: pid 21206  cpu 0  group_fd -1  flags 0
+	perf_event_open: pid 21206  cpu 1  group_fd -1  flags 0
+	perf_event_open: pid 21206  cpu 2  group_fd -1  flags 0
+	perf_event_open: pid 21206  cpu 3  group_fd -1  flags 0
+	mmap length 528384
+	itrace mmap length 4198400
+	perf event ring buffer mmapped per cpu
+	Synthesizing itrace information
+	Linux
+	[ perf record: Woken up 1 times to write data ]
+	[ perf record: Captured and wrote 0.060 MB perf.data ]
+
+Note, the sched_switch event is only added if the user is permitted to use it
+and only in per-cpu mode.
+
+Note also, the sched_switch event is only added if TSC packets are requested.
+That is because, in the absence of timing information, the sched_switch events
+cannot be matched against the Intel PT trace.
+
+
+perf script
+===========
+
+By default, perf script will decode trace data found in the perf.data file.
+This can be further controlled by new option -Z.
+
+
+New instruction trace option
+----------------------------
+
+Having no option is the same as
+
+	-Z
+
+which, in turn, is the same as
+
+	-Zibe
+
+The letters are:
+
+	i	synthesize "instructions" events
+	b	synthesize "branches" events
+	e	synthesize tracing error events
+
+"Instructions" events look like they were recorded by "perf record -e
+instructions".
+
+"Branches" events look like they were recorded by "perf record -e branches".
+
+Error events are new.  They show where the decoder lost the trace.  Error events
+are quite important.  Users must know if what they are seeing is a complete
+picture or not.
+
+In addition, the period of the "instructions" event can be specified. e.g.
+
+	-Zi10us
+
+sets the period to 10us i.e. one  instruction sample is synthesized for each 10
+microseconds of trace.  Alternatives to "us" are "ms" (milliseconds),
+"ns" (nanoseconds), "t" (TSC ticks) or "i" (instructions).
+
+"ms", "us" and "ns" are converted to TSC ticks.
+
+The timing information included with Intel PT does not give the time of every
+instruction.  Consequently, for the purpose of sampling, the decoder estimates
+the time since the last timing packet based on 1 tick per instruction.  The time
+on the sample is *not* adjusted and reflects the last known value of TSC.
+
+For Intel PT, the default period is 1000 instructions.
+
+To disable trace decoding entirely, use the option --no-itrace.
+
+
+dump option
+-----------
+
+perf script has an option (-D) to "dump" the events i.e. display the binary
+data.
+
+When -D is used, Intel PT packets are displayed.  The packet decoder does not
+pay attention to PSB packets, but just decodes the bytes - so the packets seen
+by the actual decoder may not be identical in places where the data is corrupt.
+One example of that would be when the buffer-switching interrupt has been too
+slow, and the buffer has been filled completely.  In that case, the last packet
+in the buffer might be truncated and immediately followed by a PSB as the trace
+continues in the next buffer.
+
+To disable the display of Intel PT packets, combine the -D option with
+--no-itrace.
+
+
+perf report
+===========
+
+By default, perf report will decode trace data found in the perf.data file.
+This can be further controlled by new option -Z exactly the same as perf script.
+
+
+perf inject
+===========
+
+perf inject also accepts the -Z option in which case tracing data is removed and
+replaced with the synthesized events. e.g.
+
+	perf inject -Z -i perf.data -o perf.data.new
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 8801fe0..2700698 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -7,4 +7,6 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/pmu.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/itrace.o
 LIB_H += arch/$(ARCH)/util/tsc.h
diff --git a/tools/perf/arch/x86/util/itrace.c b/tools/perf/arch/x86/util/itrace.c
new file mode 100644
index 0000000..507eee4
--- /dev/null
+++ b/tools/perf/arch/x86/util/itrace.c
@@ -0,0 +1,41 @@
+/*
+ * itrace.c: instruction tracing support
+ * Copyright (c) 2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include "../../util/header.h"
+#include "../../util/itrace.h"
+#include "../../util/intel-pt.h"
+
+struct itrace_record *itrace_record__init(int *err)
+{
+	char buffer[64];
+	int ret;
+
+	*err = 0;
+
+	ret = get_cpuid(buffer, sizeof(buffer));
+	if (ret) {
+		*err = ret;
+		return NULL;
+	}
+
+	if (!strncmp(buffer, "GenuineIntel,", 13))
+		return intel_pt_recording_init(err);
+
+	return NULL;
+}
diff --git a/tools/perf/arch/x86/util/pmu.c b/tools/perf/arch/x86/util/pmu.c
new file mode 100644
index 0000000..699a7c2
--- /dev/null
+++ b/tools/perf/arch/x86/util/pmu.c
@@ -0,0 +1,13 @@
+#include <string.h>
+
+#include <linux/perf_event.h>
+
+#include "../../util/intel-pt.h"
+#include "../../util/pmu.h"
+
+struct perf_event_attr *perf_pmu__get_default_config(struct perf_pmu *pmu)
+{
+	if (!strcmp(pmu->name, INTEL_PT_PMU_NAME))
+		return intel_pt_pmu_default_config(pmu);
+	return NULL;
+}
diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index 8ecbfb1..bea3cf7 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -46,6 +46,8 @@
 #include "debug.h"
 #include "parse-options.h"
 
+#include "intel-pt.h"
+
 int itrace_mmap__mmap(struct itrace_mmap *mm, struct itrace_mmap_params *mp,
 		      int fd)
 {
@@ -964,9 +966,9 @@ static bool itrace__dont_decode(struct perf_session *session)
 	       session->itrace_synth_opts->dont_decode;
 }
 
-int perf_event__process_itrace_info(struct perf_tool *tool __maybe_unused,
+int perf_event__process_itrace_info(struct perf_tool *tool,
 				    union perf_event *event,
-				    struct perf_session *session __maybe_unused)
+				    struct perf_session *session)
 {
 	enum itrace_type type = event->itrace_info.type;
 
@@ -978,6 +980,7 @@ int perf_event__process_itrace_info(struct perf_tool *tool __maybe_unused,
 
 	switch (type) {
 	case PERF_ITRACE_INTEL_PT:
+		return intel_pt_process_itrace_info(tool, event, session);
 	case PERF_ITRACE_UNKNOWN:
 	default:
 		return -EINVAL;
-- 
1.8.5.1

