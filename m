Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121Ab3ICN3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:29:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44923 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997Ab3ICN3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:29:37 -0400
Date: Tue, 3 Sep 2013 15:29:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.12
Message-ID: <20130903132933.GA24955@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

   HEAD: 61bf86ad86443a710ae7eed372cccb8ed5038eda Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core

As a first remark I'd like to point out that the obsolete '-f' (--force) 
option, which has not done anything for several releases, has been removed 
from 'perf record' and related utilities. Everyone please update muscle 
memory accordingly! :-)

Main changes on the perf kernel side:

   * Performance optimizations:
        . for trace events, by Steve Rostedt.
        . for time values, by Peter Zijlstra

   * New hardware support:
        . for Intel Silvermont (22nm Atom) CPUs, by Zheng Yan
        . for Intel SNB-EP uncore PMUs, by Zheng Yan

   * Enhanced hardware support:
        . for Intel uncore PMUs: add filter support for QPI boxes, by Zheng Yan

   * Core perf events code enhancements and fixes:
        . for full-nohz feature handling, by Frederic Weisbecker
        . for group events, by Jiri Olsa
        . for call chains, by Frederic Weisbecker
        . for event stream parsing, by Adrian Hunter

   * New ABI details:
        . Add attr->mmap2 attribute, by Stephane Eranian
        . Add PERF_EVENT_IOC_ID ioctl to return event ID, by Jiri Olsa
        . Export u64 time_zero on the mmap header page to allow TSC
          calculation, by Adrian Hunter
        . Add dummy software event, by Adrian Hunter.
        . Add a new PERF_SAMPLE_IDENTIFIER to make samples always 
          parseable, by Adrian Hunter.
        . Make Power7 events available via sysfs, by Runzhen Wang.
        
   * Code cleanups and refactorings:
        . for nohz-full, by Frederic Weisbecker
        . for group events, by Jiri Olsa

   * Documentation updates:
        . for perf_event_type, by Peter Zijlstra

Main changes on the perf tooling side (some of these tooling changes 
utilize the above kernel side changes):

   * Lots of 'perf trace' enhancements:

        . Make 'perf trace' command line arguments consistent with
          'perf record', by David Ahern.
    
        . Allow specifying syscalls a la strace, by Arnaldo Carvalho de Melo.

        . Add --verbose and -o/--output options, by Arnaldo Carvalho de Melo.

        . Support ! in -e expressions, to filter a list of syscalls,
          by Arnaldo Carvalho de Melo.
 
        . Arg formatting improvements to allow masking arguments in 
          syscalls such as futex and open, where the some arguments are 
          ignored and thus should not be printed depending on other args, 
          by Arnaldo Carvalho de Melo.
    
        . Beautify futex open, openat, open_by_handle_at, lseek and futex
          syscalls, by Arnaldo Carvalho de Melo.
    
        . Add option to analyze events in a file versus live, so that one can do:
    
           [root@zoo ~]# perf record -a -e raw_syscalls:* sleep 1
           [ perf record: Woken up 0 times to write data ]
           [ perf record: Captured and wrote 25.150 MB perf.data (~1098836 samples) ]
           [root@zoo ~]# perf trace -i perf.data -e futex --duration 1
              17.799 ( 1.020 ms): 7127 futex(uaddr: 0x7fff3f6c6674, op: 393, val: 1, utime: 0x7fff3f6c6470, ua
             113.344 (95.429 ms): 7127 futex(uaddr: 0x7fff3f6c6674, op: 393, val: 1, utime: 0x7fff3f6c6470, uaddr2: 0x7fff3f6c6648, val3: 4294967
             133.778 ( 1.042 ms): 18004 futex(uaddr: 0x7fff3f6c6674, op: 393, val: 1, utime: 0x7fff3f6c6470, uaddr2: 0x7fff3f6c6648, val3: 429496
           [root@zoo ~]#
    
          By David Ahern.
    
        . Honor target pid / tid options when analyzing a file, by David Ahern.
    
        . Introduce better formatting of syscall arguments, including so 
          far beautifiers for mmap, madvise, syscall return values,
          by Arnaldo Carvalho de Melo.
    
        . Handle HUGEPAGE defines in the mmap beautifier, by David Ahern.


   * 'perf report/top' enhancements:

        . Do annotation using /proc/kcore and /proc/kallsyms when 
          available, removing the forced need for a vmlinux file kernel 
          assembly annotation. This also improves this use case because 
          vmlinux has just the initial kernel image, not what is actually 
          in use after various code patchings by things like alternatives.
          By Adrian Hunter.
    
        . Add --ignore-callees=<regex> option to collapse undesired parts 
          of call graphs, by Greg Price.

        . Simplify symbol filtering by doing it at machine class level,
          by Adrian Hunter.

        . Add support for callchains in the gtk UI, by Namhyung Kim.
    
        . Add --objdump option to 'perf top', by Sukadev Bhattiprolu.

    
   * 'perf kvm' enhancements:

        . Add option to print only events that exceed a specified time
          duration, by David Ahern.

        . Improve stack trace printing, by David Ahern.
    
        . Update documentation of the live command, by David Ahern

        . Add perf kvm stat live mode that combines aspects of 'perf kvm 
          stat' record and report, by David Ahern.
    
        . Add option to analyze specific VM in perf kvm stat report, by 
          David Ahern.
    
        . Do not require /lib/modules/* on a guest, by Jason Wessel.

    
   * 'perf script' enhancements:
     
        . Fix symbol offset computation for some dsos, by David Ahern.

        . Fix named threads support, by David Ahern.

        . Don't install scripting files files when perl/python support
          is disabled, by Arnaldo Carvalho de Melo.

    
   * 'perf test' enhancements:

        . Add various improvements and fixes to the "vmlinux matches 
          kallsyms" 'perf test' entry, related to the /proc/kcore 
          annotation feature. By Arnaldo Carvalho de Melo.
    
        . Add sample parsing test, by Adrian Hunter.

        . Add test for reading object code, by Adrian Hunter.

        . Add attr record group sampling test, by Jiri Olsa.
    
        . Misc testing infrastructure improvements and other details,
          by Jiri Olsa.


   * 'perf list' enhancements:

        . Skip unsupported hardware events, by Namhyung Kim.
    
        . List pmu events, by Andi Kleen.

    
   * 'perf diff' enhancements:    
    
        . Add support for more than two files comparison, by Jiri Olsa.
    
    
   * 'perf sched' enhancements:
    
        . Various improvements, including removing reliance on some 
          scheduler tracepoints that provide the same information as the 
          PERF_RECORD_{FORK,EXIT} events. By Arnaldo Carvalho de Melo.

        . Remove odd build stall by moving a large struct initialization
          from a local variable to a global one, by Namhyung Kim.
    
   * 'perf stat' enhancements:

        . Add --initial-delay option to skip measuring for a defined
          startup phase, by Andi Kleen.

   * Generic perf tooling infrastructure/plumbing changes:

        . Tidy up sample parsing validation, by Adrian Hunter.
    
        . Fix up jobserver setup in libtraceevent Makefile.
          by Arnaldo Carvalho de Melo.
    
        . Debug improvements, by Adrian Hunter.
    
        . Fix correlation of samples coming after PERF_RECORD_EXIT event, 
          by David Ahern.
    
        . Improve robustness of the topology parsing code,
          by Stephane Eranian.
    
        . Add group leader sampling, that allows just one event in a group 
          to sample while the other events have just its values read,
          by Jiri Olsa.
    
        . Add support for a new modifier "D", which requests that the 
          event, or group of events, be pinned to the PMU.
          By Michael Ellerman.
    
        . Support callchain sorting based on addresses, by Andi Kleen

        . Prep work for multi perf data file storage, by Jiri Olsa.

        . libtraceevent cleanups, by Namhyung Kim.

And lots and lots of other fixes and code reorganizations that did not 
make it into the list, see the shortlog, diffstat and the Git log for 
details!

 Thanks,

	Ingo

------------------>
Adrian Hunter (48):
      perf inject: Remove unused parameter
      perf tools: Fix missing tool parameter
      perf inject: Add missing 'finished_round'
      perf tools: Add const specifier to perf_pmu__find name parameter
      perf evlist: Tidy duplicated munmap code
      perf tools: Validate perf event header size
      perf tools: struct thread has a tid not a pid
      perf: Fix broken union in 'struct perf_event_mmap_page'
      perf/x86: Add ability to calculate TSC from perf sample timestamps
      perf tools: Add test for converting perf time to/from TSC
      perf symbols: avoid SyS kernel syscall aliases
      perf tests: Add test for reading object code
      perf symbols: Load kernel maps before using
      perf tools: Make it possible to read object code from vmlinux
      perf tests: Adjust the vmlinux symtab matches kallsyms test
      perf tools: Make it possible to read object code from kernel modules
      perf symbols: Add support for reading from /proc/kcore
      perf tests: Adjust the vmlinux symtab matches kallsyms test again
      perf tests: Add kcore to the object code reading test
      perf annotate: Allow disassembly using /proc/kcore
      perf annotate: Put dso name in symbol annotation title
      perf annotate: Remove nop at end of annotation
      perf annotate: Add call target name if it is missing
      perf machine: Add symbol filter to struct machine
      perf top: Set the machines symbol filter
      perf report: Set the machines symbol filter
      perf mem: Remove unused symbol filter member
      perf annotate: Set the machines symbol filter
      perf tools: Remove filter parameter of perf_event__preprocess_sample()
      perf tools: Remove filter parameter of thread__find_addr_location()
      perf tools: Remove filter parameter of thread__find_addr_map()
      perf tools: Re-implement debug print function for linking python/perf.so
      perf tools: Add debug prints
      perf tools: Add pid to struct thread
      perf tools: change machine__findnew_thread() to set thread pid
      perf evsel: Tidy up sample parsing overflow checking
      perf callchain: Remove unnecessary validation
      perf tools: Remove references to struct ip_event
      perf: make events stream always parsable
      perf evlist: Move perf_evlist__config() to a new source file
      perf tools: Add support for PERF_SAMPLE_IDENTIFIER
      perf tools: Add missing 'abi' member to 'struct regs_dump'
      perf tools: Expand perf_event__synthesize_sample()
      perf tools: Add a function to calculate sample event size
      perf tests: Add a sample parsing test
      perf: Add a dummy software event to keep tracking
      perf tools: Add support for PERF_COUNT_SW_DUMMY
      perf tests: Add 'keep tracking' test

Andi Kleen (10):
      perf tools: Default to cpu// for events v5
      perf list: List kernel supplied event aliases
      perf bench: Fix memcpy benchmark for large sizes
      perf tools: Support callchain sorting based on addresses
      perf tools: Move weight back to common sort keys
      perf evlist: Remove obsolete dummy execve
      perf evsel: Add support for enabling counters
      perf stat: Add support for --initial-delay option
      perf stat: Flush output after each line in interval mode
      perf tools: Try to increase the file descriptor limits on EMFILE

Arnaldo Carvalho de Melo (23):
      perf trace: Beautify 'connect' result
      perf python: Remove duplicate TID bit from mask
      perf annotate browser: Improve description of '?' hotkey
      perf trace: Allow specifying which syscalls to trace
      perf trace: Implement -o/--output filename
      perf tools: Don't install scripting files files when disabled
      perf trace: Support ! in -e expressions
      perf trace: Add --verbose option
      perf trace: Hide sys_exit messages about syscall id = -1
      perf trace: Introduce syscall arg formatters
      perf trace: Simplify sys_exit return printing
      perf trace: Allow printing syscall return values in hex
      perf trace: Add aliases to remaining syscalls of the sys_enter_newfoo
      perf trace: Allow overiding the formatting of syscall fields
      perf trace: Add beautifier for mmap prot parm
      perf trace: Add beautifier for mmap flags parm
      perf trace: Add beautifier for madvise behaviour/advice parm
      tools lib traceevent: Fixup jobserver setup
      perf trace: Allow syscall arg formatters to mask args
      perf trace: Add beautifier for futex 'operation' parm
      perf trace: Add beautifier for lseek's whence arg
      perf trace: Add beautifier for open's flags arg
      perf trace: Tell arg formatters the arg index

David Ahern (36):
      perf tools: Add methods for setting/retrieving priv element of thread struct
      perf evlist: Fix use of uninitialized variable
      perf tools: Don't free list head in parse_events__free_terms
      perf tests: Make terms a stack variable in test_term
      perf parse events: Demystify memory allocations
      perf script: Fix named threads support
      perf evsel: Handle ENODEV on default cycles event
      perf evsel: Actually show symbol offset in stack trace when requested
      perf tools: Fix compile of util/tsc.c
      perf top: move CONSOLE_CLEAR to header file
      perf stats: Add max and min stats
      perf session: Export a few functions for event processing
      perf kvm: Split out tracepoints from record args
      perf session: Export queue_event function
      perf kvm: Add live mode
      perf kvm: Add min and max stats to display
      perf kvm stat report: Add option to analyze specific VM
      perf kvm: Option to print events that exceed a duration
      perf kvm: Update documentation with live command
      perf sched: Simplify arguments to read_events
      perf sched: Remove thread lookup in sample handler
      perf sched: Remove sched_process_exit tracepoint
      perf sched: Remove sched_process_fork tracepoint
      perf tool: Simplify options to perf_evsel__print_ip
      perf evsel: Add option to print stack trace on single line
      perf evsel: Add option to limit stack depth in callchain dumps
      perf session: Change perf_session__has_traces to actually check for tracepoints
      perf tests: Fix compile failure on do_sort_something
      perf kvm: Remove force option to cmd_record
      perf trace: Make command line arguments consistent with perf-record
      perf tools: Sample after exit loses thread correlation
      perf evlist: Add tracepoint lookup by name
      perf trace: Add option to analyze events in a file versus live
      perf trace: Honor target pid / tid options when analyzing a file
      perf trace: Handle missing HUGEPAGE defines
      perf tools: Fix symbol offset computation for some dsos

Frederic Weisbecker (10):
      perf: Fix branch stack refcount leak on callchain init failure
      perf: Sanitize get_callchain_buffer()
      perf: Factor out event accounting code to account_event()/__free_event()
      perf: Split the per-cpu accounting part of the event accounting code
      perf: Migrate per cpu event accounting
      perf: Account freq events per cpu
      perf: Implement finer grained full dynticks kick
      watchdog: Make it work under full dynticks
      perf: Roll back callchain buffer refcount under the callchain mutex
      perf: Account freq events globally

Greg Price (1):
      perf report/top: Add option to collapse undesired parts of call graph

Ingo Molnar (1):
      perf annotate browser: Fix typo

Jason Wessel (1):
      perf machine: Do not require /lib/modules/* on a guest

Jiri Kosina (3):
      x86: Introduce int3 (breakpoint)-based instruction patching
      x86: Make jump_label use int3-based patching
      kprobes/x86: Call out into INT3 handler directly instead of using notifier

Jiri Olsa (46):
      perf: Remove the 'match' callback for auxiliary events processing
      perf tools: Remove cwd from perf_session struct
      perf tests: Omit end of the symbol check failure for test 1
      perf tests: Make TEST_ASSERT_VAL global
      perf tools: Remove callchain_cursor_reset call
      perf tools: Do not elide parent symbol column
      perf report: Fix perf_session__delete removal
      perf tools: Add struct perf_hpp_fmt into hpp callbacks
      perf tools: Centralize default columns init in perf_hpp__init
      perf diff: Introducing diff_data object to hold files
      perf diff: Switching the base hists to be pairs head
      perf hists: Marking dummy hists entries
      perf diff: Display data file info ahead of the diff output
      perf diff: Move diff related columns into diff command
      perf diff: Move columns into struct data__file
      perf diff: Change diff command to work over multiple data files
      perf diff: Update perf diff documentation for multiple data comparison
      perf diff: Making compute functions static
      perf diff: Add generic order option for compute sorting
      perf tools: Move hist_entry__period_snprintf into stdio code
      perf timechart: Use traceevent lib event-parse.h include
      perf timechart: Remove event types framework only user
      perf tools: Remove event types from perf data file
      perf record: Remove event types pushing
      perf tools: Remove event types framework completely
      perf tests: Check proper prev_state size for sched_switch tp
      perf session: Use session->fd instead of passing fd as argument
      perf header: Remove data_offset seek as it's not needed
      perf header: Remove attr_offset from perf_header
      perf header: Introduce feat_offset into perf_header
      perf header: Recognize version number for perf data file
      perf tests: Run ctags/cscope make tests only with needed binaries
      perf tests: Rename TMP to TMP_O tests/make variable
      perf tests: Add DESTDIR=TMP_DEST tests/make variable
      perf tests: Add 'make install/install-bin' tests into tests/make
      perf tests: Add broken install-* tests into tests/make
      perf: Add PERF_EVENT_IOC_ID ioctl to return event ID
      perf: Do not get values from disabled counters in group format read
      perf evlist: Use PERF_EVENT_IOC_ID perf ioctl to read event id
      perf tools: Add support for parsing PERF_SAMPLE_READ sample type
      perf evlist: Fix event ID retrieval for group format read case
      perf evlist: Add perf_evlist__id2sid method to get event ID related data
      perf evsel: Add PERF_SAMPLE_READ sample related processing
      perf tools: Add 'S' event/group modifier to read sample value
      perf tests: Add attr record group sampling test
      perf tests: Add parse events tests for leader sampling

Joe Perches (1):
      perf: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node()

Joonsoo Kim (1):
      Revert "tools lib lk: Fix for cross build"

Kirill A. Shutemov (1):
      perf tools: Fix build with perl 5.18

Masami Hiramatsu (3):
      kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
      kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()
      kprobes/x86: Remove unused text_poke_smp() and text_poke_smp_batch() functions

Michael Ellerman (2):
      perf tools: Add support for pinned modifier
      perf tests: Add tests of new pinned modifier

Michael Wang (1):
      sched: Implement smarter wake-affine logic

Namhyung Kim (29):
      perf util: Move debugfs/tracing helper functions to util.c
      perf util: Use evsel->name to get tracepoint_paths
      tools lib traceevent: Remove unused install targets
      tools lib traceevent: Get rid of unused gui target
      tools lib traceevent: Add const qualifier to string arguments
      tools lib traceevent: Add trace_seq_reset()
      tools lib traceevent: Add page_size field to pevent
      tools lib traceevent: Port kbuffer parser routines
      perf util: Save page size in a trace file to pevent
      perf util: Save long size of traced system
      perf util: Make file/host_bigendian variable local
      perf util: Skip reading header_event file
      perf util: Parse header_page to get proper long size
      perf util: Get rid of unused header_page_* variables
      perf script: Adopt latency_format variable
      perf util: Rename read_*() functions in trace-event-info.c
      perf util: No need to call read_trace_init() in tracing_data_header()
      perf util: Remove unused enum and macro in trace-event.h
      perf sched: Move struct perf_sched definition out of cmd_sched()
      perf gtk/hists: Use GtkTreeStore instead of GtkListStore
      perf gtk/hists: Add support for callchains
      perf gtk/hists: Display callchain overhead also
      perf gtk/hists: Make column headers resizable
      perf gtk/hists: Add a double-click handler for callchains
      perf gtk/hists: Set rules hint for the hist browser
      perf symbols: Do not apply symfs for an absolute vmlinux path
      perf util: Add parse_nsec_time() function
      perf ui/gtk: Fix segmentation fault on perf_hpp__for_each_format loop
      perf list: Skip unsupported events

Oleg Nesterov (3):
      tracing/perf: Expand TRACE_EVENT(sched_stat_runtime)
      tracing/perf: Reimplement TP_perf_assign() logic
      tracing/perf: Avoid perf_trace_buf_*() in perf_trace_##call() when possible

Peter Zijlstra (3):
      perf: Update perf_event_type documentation
      sched: Micro-optimize the smart wake-affine logic
      perf: Do not compute time values unnecessarily

Robert Richter (2):
      perf tools: Use default include path notation for libtraceevent headers
      perf tools: Fix 'make tools/perf'

Runzhen Wang (1):
      perf tools: Make Power7 events available for perf

Stephane Eranian (2):
      perf tools: Improve robustness of topology parsing code
      perf: Add attr->mmap2 attribute to an event

Sukadev Bhattiprolu (2):
      perf tools: Rename cpu_map__all() to cpu_map__empty()
      perf top: Add --objdump option

Vince Weaver (1):
      perf: Export struct perf_branch_entry to userspace

Vladimir Davydov (1):
      sched: Move h_load calculation to task_h_load()

Yan, Zheng (5):
      perf/x86/intel/uncore: Add auxiliary pci device support
      perf/x86/intel/uncore: Add filter support for QPI boxes
      perf/x86/intel/uncore: Enable EV_SEL_EXT bit for PCU
      perf/x86: use INTEL_UEVENT_EXTRA_REG to define MSR_OFFCORE_RSP_X
      perf/x86: Add Silvermont (22nm Atom) support


 arch/powerpc/include/asm/perf_event_server.h       |   4 +-
 arch/powerpc/perf/power7-events-list.h             | 548 +++++++++++++++
 arch/powerpc/perf/power7-pmu.c                     | 148 +---
 arch/x86/Kconfig                                   |   5 -
 arch/x86/include/asm/alternative.h                 |  14 +-
 arch/x86/include/asm/tsc.h                         |   1 +
 arch/x86/kernel/alternative.c                      | 155 +++--
 arch/x86/kernel/cpu/perf_event.c                   |   6 +
 arch/x86/kernel/cpu/perf_event.h                   |   2 +
 arch/x86/kernel/cpu/perf_event_amd.c               |   3 +-
 arch/x86/kernel/cpu/perf_event_intel.c             | 180 ++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  32 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      | 254 +++++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.h      |  10 +
 arch/x86/kernel/jump_label.c                       |  16 +-
 arch/x86/kernel/kprobes/common.h                   |   5 -
 arch/x86/kernel/kprobes/core.c                     |   2 +-
 arch/x86/kernel/kprobes/opt.c                      | 110 +--
 arch/x86/kernel/traps.c                            |   4 +
 arch/x86/kernel/tsc.c                              |   6 +
 include/linux/perf_event.h                         |  24 -
 include/linux/sched.h                              |   3 +
 include/trace/events/sched.h                       |  22 +-
 include/trace/ftrace.h                             |  33 +-
 include/uapi/linux/perf_event.h                    | 123 +++-
 kernel/events/callchain.c                          |   3 +
 kernel/events/core.c                               | 381 +++++++----
 kernel/sched/core.c                                |   7 +-
 kernel/sched/fair.c                                | 105 ++-
 kernel/sched/sched.h                               |   8 +-
 kernel/watchdog.c                                  |   8 -
 tools/lib/lk/Makefile                              |  15 -
 tools/lib/traceevent/Makefile                      |  20 +-
 tools/lib/traceevent/event-parse.c                 |   7 +-
 tools/lib/traceevent/event-parse.h                 |  15 +-
 tools/lib/traceevent/kbuffer-parse.c               | 732 ++++++++++++++++++++
 tools/lib/traceevent/kbuffer.h                     |  67 ++
 tools/lib/traceevent/trace-seq.c                   |  13 +
 tools/perf/Documentation/perf-diff.txt             |  79 ++-
 tools/perf/Documentation/perf-kvm.txt              |  46 +-
 tools/perf/Documentation/perf-list.txt             |   6 +-
 tools/perf/Documentation/perf-report.txt           |  13 +-
 tools/perf/Documentation/perf-stat.txt             |   5 +
 tools/perf/Documentation/perf-top.txt              |   5 +
 tools/perf/Documentation/perf-trace.txt            |  24 +
 tools/perf/Makefile                                |  21 +-
 tools/perf/arch/x86/Makefile                       |   2 +
 tools/perf/arch/x86/util/tsc.c                     |  59 ++
 tools/perf/arch/x86/util/tsc.h                     |  20 +
 tools/perf/bench/mem-memcpy.c                      |   2 +
 tools/perf/builtin-annotate.c                      |   5 +-
 tools/perf/builtin-diff.c                          | 664 ++++++++++++++----
 tools/perf/builtin-inject.c                        |  53 +-
 tools/perf/builtin-kmem.c                          |   5 +-
 tools/perf/builtin-kvm.c                           | 754 +++++++++++++++++++--
 tools/perf/builtin-list.c                          |   3 +
 tools/perf/builtin-lock.c                          |   3 +-
 tools/perf/builtin-mem.c                           |   6 +-
 tools/perf/builtin-record.c                        |  13 -
 tools/perf/builtin-report.c                        |  88 +--
 tools/perf/builtin-sched.c                         | 161 ++---
 tools/perf/builtin-script.c                        |  42 +-
 tools/perf/builtin-stat.c                          |  24 +-
 tools/perf/builtin-timechart.c                     | 176 ++---
 tools/perf/builtin-top.c                           |  36 +-
 tools/perf/builtin-trace.c                         | 721 ++++++++++++++++++--
 tools/perf/config/Makefile                         |   5 +-
 tools/perf/perf.h                                  |   3 +
 tools/perf/python/twatch.py                        |   2 +-
 tools/perf/tests/attr/test-record-group-sampling   |  36 +
 tools/perf/tests/builtin-test.c                    |  18 +
 tools/perf/tests/code-reading.c                    | 572 ++++++++++++++++
 tools/perf/tests/dso-data.c                        |   8 -
 tools/perf/tests/evsel-tp-sched.c                  |   4 +-
 tools/perf/tests/hists_link.c                      |  27 +-
 tools/perf/tests/keep-tracking.c                   | 154 +++++
 tools/perf/tests/make                              |  67 +-
 tools/perf/tests/mmap-basic.c                      |   2 +-
 tools/perf/tests/parse-events.c                    | 190 +++++-
 tools/perf/tests/perf-time-to-tsc.c                | 177 +++++
 tools/perf/tests/sample-parsing.c                  | 316 +++++++++
 tools/perf/tests/tests.h                           |  12 +
 tools/perf/tests/vmlinux-kallsyms.c                |  49 +-
 tools/perf/ui/browsers/annotate.c                  |  20 +-
 tools/perf/ui/browsers/hists.c                     |  18 +-
 tools/perf/ui/gtk/hists.c                          | 128 +++-
 tools/perf/ui/hist.c                               | 258 +------
 tools/perf/ui/setup.c                              |   1 -
 tools/perf/ui/stdio/hist.c                         |  45 +-
 tools/perf/util/annotate.c                         |  60 +-
 tools/perf/util/build-id.c                         |  11 +-
 tools/perf/util/callchain.c                        |  15 +-
 tools/perf/util/callchain.h                        |  11 +-
 tools/perf/util/cpumap.h                           |   2 +-
 tools/perf/util/dso.c                              |  10 +-
 tools/perf/util/dso.h                              |  17 +
 tools/perf/util/event.c                            |  31 +-
 tools/perf/util/event.h                            |  41 +-
 tools/perf/util/evlist.c                           | 294 ++++++--
 tools/perf/util/evlist.h                           |  21 +-
 tools/perf/util/evsel.c                            | 581 ++++++++++++++--
 tools/perf/util/evsel.h                            |  19 +-
 tools/perf/util/header.c                           | 161 +----
 tools/perf/util/header.h                           |  40 +-
 tools/perf/util/hist.c                             |   4 +-
 tools/perf/util/hist.h                             |  26 +-
 tools/perf/util/include/linux/string.h             |   1 +
 tools/perf/util/machine.c                          | 155 +++--
 tools/perf/util/machine.h                          |  14 +-
 tools/perf/util/map.c                              |  67 +-
 tools/perf/util/map.h                              |  13 +
 tools/perf/util/parse-events.c                     | 174 +++--
 tools/perf/util/parse-events.h                     |  11 +-
 tools/perf/util/parse-events.l                     |   4 +-
 tools/perf/util/parse-events.y                     |  62 +-
 tools/perf/util/pmu.c                              |  87 ++-
 tools/perf/util/pmu.h                              |   5 +-
 tools/perf/util/python.c                           |  21 +
 tools/perf/util/record.c                           | 108 +++
 .../perf/util/scripting-engines/trace-event-perl.c |  14 +-
 .../util/scripting-engines/trace-event-python.c    |   9 +-
 tools/perf/util/session.c                          | 241 +++++--
 tools/perf/util/session.h                          |  14 +-
 tools/perf/util/sort.c                             |  12 +-
 tools/perf/util/sort.h                             |  13 +-
 tools/perf/util/stat.c                             |   6 +
 tools/perf/util/stat.h                             |   9 +
 tools/perf/util/string.c                           |  24 +
 tools/perf/util/symbol-elf.c                       | 174 ++++-
 tools/perf/util/symbol-minimal.c                   |   7 +
 tools/perf/util/symbol.c                           | 285 +++++++-
 tools/perf/util/symbol.h                           |   5 +
 tools/perf/util/thread.c                           |  11 +-
 tools/perf/util/thread.h                           |  23 +-
 tools/perf/util/tool.h                             |  10 +-
 tools/perf/util/top.h                              |   2 +
 tools/perf/util/trace-event-info.c                 |  96 +--
 tools/perf/util/trace-event-parse.c                |   6 -
 tools/perf/util/trace-event-read.c                 |  52 +-
 tools/perf/util/trace-event-scripting.c            |   3 +-
 tools/perf/util/trace-event.h                      |  21 +-
 tools/perf/util/unwind.c                           |   2 +-
 tools/perf/util/util.c                             |  92 +++
 tools/perf/util/util.h                             |   5 +
 144 files changed, 9132 insertions(+), 2309 deletions(-)
 create mode 100644 arch/powerpc/perf/power7-events-list.h
 create mode 100644 tools/lib/traceevent/kbuffer-parse.c
 create mode 100644 tools/lib/traceevent/kbuffer.h
 create mode 100644 tools/perf/arch/x86/util/tsc.c
 create mode 100644 tools/perf/arch/x86/util/tsc.h
 create mode 100644 tools/perf/tests/attr/test-record-group-sampling
 create mode 100644 tools/perf/tests/code-reading.c
 create mode 100644 tools/perf/tests/keep-tracking.c
 create mode 100644 tools/perf/tests/perf-time-to-tsc.c
 create mode 100644 tools/perf/tests/sample-parsing.c
 create mode 100644 tools/perf/util/record.c

[ Full diff omitted for size reasons. ]
