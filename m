Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab3BSOOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:14:23 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:63546 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab3BSOOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:14:21 -0500
Date: Tue, 19 Feb 2013 15:14:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.9
Message-ID: <20130219141416.GA12486@gmail.com>
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

   HEAD: e259514eef764a5286873618e34c560ecb6cff13 perf/x86/amd: Enable northbridge performance counters on AMD family 15h

There are lots of improvements, the biggest changes are:

Main kernel side changes:

  * Improve uprobes performance by adding 'pre-filtering' 
    support, by Oleg Nesterov.

  * Make some POWER7 events available in sysfs, equivalent to
    what was done on x86, from Sukadev Bhattiprolu.

  * tracing updates by Steve Rostedt - mostly misc fixes and
    smaller improvements.

  * Use perf/event tracing to report PCI Express advanced 
    errors, by Tony Luck.

  * Enable northbridge performance counters on AMD family 15h, 
    by Jacob Shin.

  * This tracing commit:
    
          tracing: Remove the extra 4 bytes of padding in events
    
    changes the ABI. All involved parties (PowerTop in 
    particular) seem to agree that it's safe to do now with the 
    introduction of libtraceevent, but the devil is in the 
    details ...

Main tooling side changes:

  * Add 'event group view', from Namyung Kim:
    
    To use it, 'perf record' should group events when
    recording. And then perf report parses the saved group 
    relation from file header and prints them
    together if --group option is provided. You can use the
    'perf evlist' command to see event group information:
    
        $ perf record -e '{ref-cycles,cycles}' noploop 1
        [ perf record: Woken up 2 times to write data ]
        [ perf record: Captured and wrote 0.385 MB perf.data (~16807 samples) ]
    
        $ perf evlist --group
        {ref-cycles,cycles}

     With this example, default perf report will show you each 
     event separately.

     You can use --group option to enable event group view:

        $ perf report --group
        ...
        # group: {ref-cycles,cycles}
        # ========
        # Samples: 7K of event 'anon group { ref-cycles, cycles }'
        # Event count (approx.): 6876107743
        #
        #         Overhead  Command      Shared Object                      Symbol
        # ................  .......  .................  ..........................
            99.84%  99.76%  noploop  noploop            [.] main
             0.07%   0.00%  noploop  ld-2.15.so         [.] strcmp
             0.03%   0.00%  noploop  [kernel.kallsyms]  [k] timerqueue_del
             0.03%   0.03%  noploop  [kernel.kallsyms]  [k] sched_clock_cpu
             0.02%   0.00%  noploop  [kernel.kallsyms]  [k] account_user_time
             0.01%   0.00%  noploop  [kernel.kallsyms]  [k] __alloc_pages_nodemask
             0.00%   0.00%  noploop  [kernel.kallsyms]  [k] native_write_msr_safe
             0.00%   0.11%  noploop  [kernel.kallsyms]  [k] _raw_spin_lock
             0.00%   0.06%  noploop  [kernel.kallsyms]  [k] find_get_page
             0.00%   0.02%  noploop  [kernel.kallsyms]  [k] rcu_check_callbacks
             0.00%   0.02%  noploop  [kernel.kallsyms]  [k] __current_kernel_time


      As you can see the Overhead column now contains both of 
      ref-cycles and cycles and header line shows group 
      information also - 'anon group { ref-cycles, cycles }'.  
      The output is sorted by period of group leader first.

  * Initial GTK+ annotate browser, from Namhyung Kim.

  * Add option for runtime switching perf data file in perf 
    report, just press 's' and a menu with the valid files found 
    in the current directory will be presented, from Feng Tang.

  * Add support to display whole group data for raw columns, 
    from Jiri Olsa.

  * Add per processor socket count aggregation in perf stat, 
    from Stephane Eranian.

  * Add interval printing in 'perf stat', from Stephane Eranian.

  * 'perf test' improvements

  * Add support for wildcards in tracepoint system name, from 
    Jiri Olsa.

  * Add anonymous huge page recognition, from Joshua Zhu.

  * perf build-id cache now can show DSOs present in a perf.data 
    file that are not in the cache, to integrate with build-id 
    servers being put in place by organizations such as Fedora.

  * perf top now shares more of the evsel config/creation 
    routines with 'record', paving the way for further 
    integration like 'top' snapshots, etc.
    
  * perf top now supports DWARF callchains.

  * Fix mmap limitations on 32-bit, fix from David Miller.

  * 'perf bench numa mem' NUMA performance measurement suite

  * ... and lots of fixes, performance improvements, cleanups 
    and other improvements I failed to list - see the shortlog 
    and git log for details.

 Thanks,

	Ingo

------------------>
Al Cooper (1):
      perf tools: Fix GNU make v3.80 compatibility issue

Arnaldo Carvalho de Melo (56):
      perf top: Add missing newline on pr_err call
      perf tools: Don't check configuration on make tags
      perf tools: Fix TUI helpline output
      perf buildid-list: We need to check if a file is ELF first
      perf symbols: Generalize filter in __fprintf_buildid methods
      perf buildid-cache: Add option to show build ids that are missing in the cache
      perf machine: Move more machine methods to machine.c
      perf evsel: Update sample_size when setting sample_type bits
      perf test: Fixup error reporting in basic mmap test
      perf test: Use perf_evsel__newtp constructor in the tracepoint tests
      perf evsel: Introduce method to request IDs be used
      perf evsel: No need to always ask for PERF_FORMAT_ID in read_format
      perf evsel: No need to always ask for PERF_FORMAT_TOTAL_TIME_{ENABLED,RUNNING}
      perf evlist: Set the leader in the perf_evlist__config method
      perf evsel: Adopt fprintf routine from 'perf evlist'
      perf tools: Add install-bin Makefile target
      perf evsel: Decode read_format and sample_type in perf_evsel__fprintf
      perf record: Pass perf_record_opts to the callchain cmdline parsing callback
      perf record: Export the callchain parsing routine and help
      perf top: Use perf_evlist__config()
      perf test: Remove leftover temp file left by one of the attr tests
      perf tests: Adjust some message log levels to help diagnosing problems in attr tests
      perf evsel: Do missing feature fallbacks in just one place
      perf evsel: Introduce event fallback method
      perf evsel: Introduce perf_evsel__open_strerror method
      perf test: Check for linking problems in the python binding
      perf python: Fix breakage introduced by the test_attr infrastructure
      perf record: Don't pass host machine to guest synthesizer
      perf hists: Rename hists__fprintf_nr_events to events_stats__fprintf
      perf session: There is no need for a per session hists instance
      perf machine: Introduce struct machines
      perf machine: Simplify accessing the host machine
      perf kvm: Initialize file_name var to fix segfault
      perf tests: Don't fail if a matching vmlinux isn't found, skip that test
      perf tools: Fix usage of __ in parse_events_term struct
      perf pmu: Fix usage of __ in struct names
      perf ui browsers: Fix usage of __ in struct names
      perf tools: Fix usage of __ in event parsing struct names
      perf tests: Use ARRAY_SIZE() were applicable
      perf pmu: Privatize perf_pmu_{format,alias} structs
      perf tools: Remove some needless die() calls from the main routine
      perf tools: Allow passing NULL to intlist__find
      perf tools: Allow passing a list to intlist__new
      perf test: Allow skipping tests
      perf tools: Stop using 'self' in strlist
      perf tools: Stop using 'self' in map.[ch]
      perf tools: Use memdup in map__clone
      perf kmem: Use memdup()
      perf header: Stop using die() calls when processing tracing data
      perf ui browser: Free browser->helpline() on ui_browser__hide()
      perf tests: Call machine__exit in the vmlinux matches kallsyms test
      perf tests: Fix leaks on PERF_RECORD_* test
      perf top: Stop using exit()
      perf top: Delete maps on exit
      perf evlist: Pass the event_group info via perf_attr_details
      perf python: Link with sysfs.o

Borislav Petkov (2):
      tools: Correct typo in tools Makefile
      perf tools: Check for flex and bison before continuing building

Daniel Baluta (1):
      perf/hwbp: Fix cleanup in case of kzalloc failure

David Ahern (4):
      perf symbols: Move name malloc to when needed in dso__load
      perf symbols: Mark vmlinux filename as allocated
      perf tools: Move get_term_dimensions from top to util.c
      perf evlist: Make event_copy local to mmaps

David Miller (1):
      perf tools: Fix mmap limitations on 32-bit

Feng Tang (2):
      perf hists browser: Add option for runtime switching perf data file
      perf report: Enable the runtime switching of perf data file

Fengguang Wu (1):
      tracing/syscalls: Make local functions static

Frederic Weisbecker (1):
      profiling: Remove unused timer hook

Frederik Deweerdt (1):
      perf annotate browser: Fix segfault when drawing out-of-bounds jumps

Hiraku Toyooka (4):
      tracing: Add checks if tr->buffer is NULL in tracing_reset{_online_cpus}
      tracing: Replace static old_tracer check of tracer name
      tracing: Make a snapshot feature available from userspace
      tracing: Add documentation of snapshot utility

Hyeoncheol Lee (1):
      perf probe: Allow of casting an array of char to string

Ingo Molnar (1):
      perf: Add 'perf bench numa mem' NUMA performance measurement suite

Jacob Shin (4):
      perf/x86/amd: Use proper naming scheme for AMD bit field definitions
      perf/x86: Move MSR address offset calculation to architecture specific files
      perf/x86: Allow for architecture specific RDPMC indexes
      perf/x86/amd: Enable northbridge performance counters on AMD family 15h

Jiri Olsa (18):
      perf hists: Introduce perf_hpp__list for period related columns
      perf hists: Fix period symbol_conf.field_sep display
      perf diff: Remove displacement from struct hist_entry_diff
      perf diff: Change compute methods to work with pair directly
      perf diff: Change formula methods to work with pair directly
      perf diff: Remove displacement output option
      perf tools: Add missing closedir in multi tracepoint processing
      perf tools: Add support for wildcard in tracepoint system name
      perf tests: Add event parsing test for '*:*' tracepoints
      perf tests: Fix PYTHONPATH for python-use test tracepoints
      perf tests: Add return states enum for tests
      perf tools: Remove unused 'unset' parameter from parse_events
      tools lib traceevent: Handle dynamic array's element size properly
      perf hists browser: Add support to display whole group data for raw columns
      perf perl scripts: Fix SIGALRM and pipe read race for rwtop
      perf tools: Fix perf_evsel::exclude_GH handling
      perf tests: Adding automated parsing tests for group :GH modifiers
      perf tools: Limit unwind support to x86 archs

Jon Stanley (2):
      tools lib traceevent: Update FSF postal address to be URL's.
      tools lib traceevent: Add copyright header

Josh Stone (1):
      uprobes: Add exports for module use

Josh Triplett (1):
      tracing: Mark tracing_dentry_percpu() static

Joshua Zhu (1):
      perf tools: Add anonymous huge page recognition

Jovi Zhang (2):
      tracing: Verify target file before registering a uprobe event
      tracing: Remove second iterator initializer

Lance Ortiz (3):
      aerdrv: Trace Event for PCI Express Advanced Error Reporting
      aerdrv: Enhanced AER logging
      aerdrv: Cleanup log output for AER

Masami Hiramatsu (3):
      ftrace: Move ARCH_SUPPORTS_FTRACE_SAVE_REGS in Kconfig
      kprobes/x86: Move ftrace-based kprobe code into kprobes-ftrace.c
      kprobes/x86: Move kprobes stuff under arch/x86/kernel/kprobes/

Namhyung Kim (61):
      perf ui: Always compile error printing code
      perf ui/helpline: Introduce ui_helpline__vshow()
      perf tools: Don't check configuration on make clean
      perf session: Free environment information when deleting session
      perf symbols: Ignore ABS symbols when loading data maps
      perf hists: Fix typo on hist__entry_add_pair
      perf hists: Link hist entry pairs to leader
      perf evsel: Set leader evsel's ->leader to itself
      perf evsel: Convert to _is_group_leader method
      perf hists: Exchange order of comparing items when collapsing hists
      perf hists: Link hist entries before inserting to an output tree
      perf diff: Use internal rb tree for compute resort
      perf test: Add a test case for hists__{match,link}
      perf tests: Check python path on attr and binding test
      perf header: Ensure read/write finished successfully
      perf ui/gtk: Factor out common browser routines
      perf ui/gtk: Setup browser window early
      perf symbols: Include elf.h header regardless LIBELF_SUPPORT
      perf bench: Flush stdout before starting bench suite
      perf sort: Move misplaced sort entry functions
      perf sort: Get rid of unnecessary __maybe_unused
      perf sort: Fix --sort pid output
      perf sort: Align cpu column to right
      perf sort: Calculate parent column width too
      perf sort: Clean up sort__first_dimension setting
      perf sort: Separate out branch stack specific sort keys
      perf report: Update documentation for sort keys
      tools lib traceevent: Fix warning on '>=' operator
      perf tools: Get rid of unused include of config.mak
      perf tools: Do not include PERF-VERSION-FILE to Makefile
      perf tools: Move ltrim() to util/string.c
      perf evsel: Fix memory leaks on evsel->counts
      tracing: Use sched_clock_cpu for trace_clock_global
      perf tools: Keep group information
      perf tests: Add group test conditions
      perf header: Add HEADER_GROUP_DESC feature
      perf report: Make another loop for linking group hists
      perf hists: Resort hist entries using group members for output
      perf ui/hist: Consolidate hpp helpers
      perf hists browser: Convert hpp helpers to a function
      perf gtk/browser: Convert hpp helpers to a function
      perf ui/hist: Add support for event group view
      perf hists browser: Move coloring logic to hpp functions
      perf hists browser: Add suppport for event group view
      perf gtk/browser: Add support for event group view
      perf gtk/browser: Trim column header string when event group enabled
      perf report: Bypass non-leader events when event group is enabled
      perf report: Show group description when event group is enabled
      perf report: Add --group option
      perf report: Add report.group config option
      perf evlist: Add --group option
      perf sort: Drop ip_[lr] arguments from _sort__sym_cmp()
      perf sort: Make setup_sorting returns an error code
      perf sort: Check return value of strdup()
      perf buildid-cache: Add --update option
      perf annotate: Fix warning message on a missing vmlinux
      perf ui/gtk: Implement basic GTK2 annotation browser
      perf gtk/annotate: Support multiple event annotation
      perf gtk/annotate: Show source lines with gray color
      perf gtk/annotate: Fail early if it can't annotate
      perf annotate: Make it to be able to skip unannotatable symbols

Oleg Nesterov (37):
      uprobes: Move __set_bit(UPROBE_SKIP_SSTEP) into alloc_uprobe()
      uprobes: Kill the pointless inode/uc checks in register/unregister
      uprobes: Kill uprobe_consumer->filter()
      uprobes: Introduce filter_chain()
      uprobes: _unregister() should always do register_for_each_vma(false)
      uprobes: _register() should always do register_for_each_vma(true)
      uprobes: Introduce uprobe->register_rwsem
      uprobes: Change filter_chain() to iterate ->consumers list
      uprobes: Kill UPROBE_RUN_HANDLER flag
      uprobes: Kill uprobe->copy_mutex
      uprobes: Kill uprobe_events, use RB_EMPTY_ROOT() instead
      uprobes: Introduce uprobe_is_active()
      uprobes: Kill uprobes_mutex[], separate alloc_uprobe() and __uprobe_register()
      uprobes: Rationalize the usage of filter_chain()
      uprobes: Reintroduce uprobe_consumer->filter()
      uprobes: Teach handler_chain() to filter out the probed task
      uprobes/x86: Change __skip_sstep() to actually skip the whole insn
      uprobes: Change handle_swbp() to expose bp_vaddr to handler_chain()
      uprobes: Move alloc_page() from xol_add_vma() to xol_alloc_area()
      uprobes: Fold xol_alloc_area() into get_xol_area()
      uprobes: Turn add_utask() into get_utask()
      uprobes: Do not play with utask in xol_get_insn_slot()
      uprobes: Fix utask->xol_vaddr leak in pre_ssout()
      uprobes: Do not allocate current->utask unnecessary
      uprobes: Kill the bogus IS_ERR_VALUE(xol_vaddr) check
      uprobes/tracing: Fix dentry/mount leak in create_trace_uprobe()
      uprobes/tracing: Fully initialize uprobe_trace_consumer before uprobe_register()
      uprobes/tracing: Ensure inode != NULL in create_trace_uprobe()
      uprobes/tracing: Introduce is_trace_uprobe_enabled()
      uprobes/tracing: Kill uprobe_trace_consumer, embed uprobe_consumer into trace_uprobe
      uprobes/perf: Always increment trace_uprobe->nhit
      perf: Introduce hw_perf_event->tp_target and ->tp_list
      uprobes: Introduce uprobe_apply()
      uprobes/perf: Teach trace_uprobe/perf code to track the active perf_event's
      uprobes/perf: Teach trace_uprobe/perf code to pre-filter
      uprobes/perf: Teach trace_uprobe/perf code to use UPROBE_HANDLER_REMOVE
      uprobes/perf: Avoid uprobe_apply() whenever possible

Paul Gortmaker (1):
      perf tools: Fix calloc argument ordering

Peter Hurley (1):
      perf tools: Make numa benchmark optional

Robert Richter (2):
      perf/x86/amd: Rework northbridge event constraints handler
      perf/x86/amd: Generalize northbridge constraints code for family 15h

Sasha Levin (5):
      perf tools: remove redundant checks from _sort__sym_cmp
      perf kmem: use ARRAY_SIZE instead of reinventing it
      perf script: use ARRAY_SIZE instead of reinventing it
      uprobes: remove redundant check
      tools lib traceevent: test correct variable after allocation

Shan Wei (2):
      tracing: Use this_cpu_ptr per-cpu helper
      tracing: Use __this_cpu_inc/dec operation instead of __get_cpu_var

Stephane Eranian (7):
      perf symbols: Fix dso__fprintf() print statement
      perf tools: Mark branch_info maps as referenced
      perf evsel: Add prev_raw_count field
      perf stat: Add interval printing
      perf evlist: Fix set event list leader
      perf tools: Add cpu_map processor socket level functions
      perf stat: Add per processor socket count aggregation

Steven Rostedt (20):
      tracing: Fix sparse warning with is_signed_type() macro
      ring-buffer: Remove unnecessary recusive call in rb_advance_iter()
      tracing: Remove unneeded check of max_tr->buffer before tracing_reset
      tracing/lockdep: Disable lockdep first in entering NMI
      tracing/fgraph: Add max_graph_depth to limit function_graph depth
      tracing: Remove the extra 4 bytes of padding in events
      tracing: Remove trace.h header from trace_clock.c
      tracing: Fix race with max_tr and changing tracers
      tracing: Fix selftest function recursion accounting
      ftrace: Fix global function tracers that are not recursion safe
      ftrace: Fix function tracing recursion self test
      ftrace: Optimize the function tracer list loop
      ftrace: Add context level recursion bit checking
      tracing: Make the trace recursion bits into enums
      tracing: Avoid unnecessary multiple recursion checks
      ftrace: Use only the preempt version of function tracing
      ring-buffer: User context bit recursion checking
      ring-buffer: Remove trace.h from ring_buffer.c
      tracing: Fix unsigned int compare of zero in recursion check
      tracing: Remove tracepoint sample code

Steven Rostedt (Red Hat) (3):
      tracing/fgraph: Adjust fgraph depth before calling trace return callback
      ring-buffer: Add stats field for amount read from trace ring buffer
      tracing: Init current_trace to nop_trace and remove NULL checks

Sukadev Bhattiprolu (8):
      perf tools: Fix PMU format parsing test failure
      perf tools, powerpc: Fix compile warnings in tests/attr.c
      perf/Power7: Use macros to identify perf events
      perf: Make EVENT_ATTR global
      perf/POWER7: Make generic event translations available in sysfs
      perf/POWER7: Make some POWER7 events available in sysfs
      perf: Document the ABI of perf sysfs entries
      perf/powerpc: Fix build error

Thomas Jarosch (6):
      perf tools: Fix possible (unlikely) buffer overflow
      perf tools: Fix possible double free on error
      perf sort: Use pclose() instead of fclose() on pipe stream
      perf tools: Fix memory leak on error
      perf header: Fix memory leak for the "Not caching a kptr_restrict'ed /proc/kallsyms" case
      perf header: Fix double fclose() on do_write(fd, xxx) failure

Tom Zanussi (4):
      perf tools: Reinstate 'signed' field flag for tracepoints
      perf script: Don't display trace info when invoking scripts
      perf script: hook up perf_scripting_context->pevent
      perf script: Remove workqueue-stats script

Vince Weaver (1):
      perf: Missing field in PERF_RECORD_SAMPLE documentation

Vinson Lee (1):
      perf tools: Fix build with bison 2.3 and older.


 .../testing/sysfs-bus-event_source-devices-events  |   62 +
 Documentation/trace/ftrace.txt                     |   83 +
 arch/Kconfig                                       |   12 +
 arch/powerpc/include/asm/perf_event_server.h       |   26 +
 arch/powerpc/perf/core-book3s.c                    |   12 +
 arch/powerpc/perf/power7-pmu.c                     |   80 +-
 arch/x86/Kconfig                                   |    2 +
 arch/x86/include/asm/cpufeature.h                  |    2 +
 arch/x86/include/asm/ftrace.h                      |    1 -
 arch/x86/include/asm/perf_event.h                  |   13 +-
 arch/x86/include/uapi/asm/msr-index.h              |    2 +
 arch/x86/kernel/Makefile                           |    3 +-
 arch/x86/kernel/cpu/perf_event.c                   |   15 +-
 arch/x86/kernel/cpu/perf_event.h                   |   25 +-
 arch/x86/kernel/cpu/perf_event_amd.c               |  322 +++-
 arch/x86/kernel/kprobes/Makefile                   |    7 +
 .../kernel/{kprobes-common.h => kprobes/common.h}  |   11 +
 arch/x86/kernel/{kprobes.c => kprobes/core.c}      |   76 +-
 arch/x86/kernel/kprobes/ftrace.c                   |   93 ++
 arch/x86/kernel/{kprobes-opt.c => kprobes/opt.c}   |    2 +-
 arch/x86/kernel/uprobes.c                          |    4 +-
 drivers/acpi/apei/cper.c                           |   19 +-
 drivers/pci/pcie/aer/aerdrv_errprint.c             |   63 +-
 include/linux/aer.h                                |    4 +-
 include/linux/ftrace.h                             |    6 +-
 include/linux/ftrace_event.h                       |    6 +-
 include/linux/hardirq.h                            |    4 +-
 include/linux/kprobes.h                            |   12 +-
 include/linux/perf_event.h                         |   20 +-
 include/linux/profile.h                            |   13 -
 include/linux/ring_buffer.h                        |    1 +
 include/linux/uprobes.h                            |   23 +-
 include/trace/events/ras.h                         |   77 +
 include/uapi/linux/perf_event.h                    |    3 +-
 kernel/events/core.c                               |    5 +-
 kernel/events/hw_breakpoint.c                      |    2 +-
 kernel/events/uprobes.c                            |  466 +++---
 kernel/kprobes.c                                   |    8 +-
 kernel/profile.c                                   |   24 -
 kernel/ptrace.c                                    |    6 +
 kernel/trace/Kconfig                               |   18 +
 kernel/trace/blktrace.c                            |    2 +-
 kernel/trace/ftrace.c                              |   88 +-
 kernel/trace/ring_buffer.c                         |  108 +-
 kernel/trace/trace.c                               |  252 ++-
 kernel/trace/trace.h                               |  134 +-
 kernel/trace/trace_clock.c                         |    4 +-
 kernel/trace/trace_events.c                        |    1 -
 kernel/trace/trace_functions.c                     |   61 +-
 kernel/trace/trace_functions_graph.c               |   68 +-
 kernel/trace/trace_probe.h                         |    1 -
 kernel/trace/trace_selftest.c                      |   21 +-
 kernel/trace/trace_syscalls.c                      |   18 +-
 kernel/trace/trace_uprobe.c                        |  217 ++-
 samples/Kconfig                                    |    6 -
 samples/Makefile                                   |    2 +-
 samples/tracepoints/Makefile                       |    6 -
 samples/tracepoints/tp-samples-trace.h             |   11 -
 samples/tracepoints/tracepoint-probe-sample.c      |   57 -
 samples/tracepoints/tracepoint-probe-sample2.c     |   44 -
 samples/tracepoints/tracepoint-sample.c            |   57 -
 tools/Makefile                                     |    2 +-
 tools/lib/traceevent/event-parse.c                 |   49 +-
 tools/lib/traceevent/event-parse.h                 |    3 +-
 tools/lib/traceevent/event-utils.h                 |    3 +-
 tools/lib/traceevent/parse-filter.c                |    3 +-
 tools/lib/traceevent/parse-utils.c                 |   19 +
 tools/lib/traceevent/trace-seq.c                   |    3 +-
 tools/perf/Documentation/Makefile                  |    4 +
 tools/perf/Documentation/perf-annotate.txt         |    7 +-
 tools/perf/Documentation/perf-buildid-cache.txt    |    7 +
 tools/perf/Documentation/perf-diff.txt             |    4 -
 tools/perf/Documentation/perf-evlist.txt           |    4 +
 tools/perf/Documentation/perf-report.txt           |   41 +-
 tools/perf/Documentation/perf-script-python.txt    |    2 -
 tools/perf/Documentation/perf-stat.txt             |   11 +
 tools/perf/Documentation/perf-test.txt             |    4 +
 tools/perf/Documentation/perf-top.txt              |    2 +-
 tools/perf/Makefile                                |  104 +-
 tools/perf/arch/common.c                           |    1 +
 tools/perf/bench/bench.h                           |    1 +
 tools/perf/bench/numa.c                            | 1731 ++++++++++++++++++++
 tools/perf/builtin-annotate.c                      |   30 +-
 tools/perf/builtin-bench.c                         |   19 +
 tools/perf/builtin-buildid-cache.c                 |   96 +-
 tools/perf/builtin-buildid-list.c                  |   21 +-
 tools/perf/builtin-diff.c                          |  205 +--
 tools/perf/builtin-evlist.c                        |   88 +-
 tools/perf/builtin-kmem.c                          |   16 +-
 tools/perf/builtin-kvm.c                           |    3 +-
 tools/perf/builtin-record.c                        |  168 +-
 tools/perf/builtin-report.c                        |   93 +-
 tools/perf/builtin-sched.c                         |    6 +-
 tools/perf/builtin-script.c                        |   17 +-
 tools/perf/builtin-stat.c                          |  328 +++-
 tools/perf/builtin-top.c                           |  372 ++---
 tools/perf/builtin-trace.c                         |    2 +-
 tools/perf/config/feature-tests.mak                |   11 +
 tools/perf/config/utilities.mak                    |    6 +-
 tools/perf/perf.c                                  |   32 +-
 tools/perf/perf.h                                  |   32 -
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 -
 tools/perf/scripts/perl/bin/workqueue-stats-report |    3 -
 tools/perf/scripts/perl/rwtop.pl                   |    6 +-
 tools/perf/scripts/perl/workqueue-stats.pl         |  129 --
 tools/perf/tests/attr.c                            |    9 +-
 tools/perf/tests/attr.py                           |   27 +-
 tools/perf/tests/attr/base-record                  |    2 +-
 tools/perf/tests/attr/test-record-group            |    2 +
 tools/perf/tests/attr/test-record-group1           |    4 +-
 tools/perf/tests/builtin-test.c                    |   40 +-
 tools/perf/tests/evsel-roundtrip-name.c            |    4 +-
 tools/perf/tests/hists_link.c                      |  500 ++++++
 tools/perf/tests/mmap-basic.c                      |   40 +-
 tools/perf/tests/open-syscall-all-cpus.c           |   19 +-
 tools/perf/tests/open-syscall.c                    |   17 +-
 tools/perf/tests/parse-events.c                    |  324 +++-
 tools/perf/tests/perf-record.c                     |   20 +-
 tools/perf/tests/pmu.c                             |   11 +-
 tools/perf/tests/python-use.c                      |   23 +
 tools/perf/tests/tests.h                           |   11 +-
 tools/perf/tests/util.c                            |   30 -
 tools/perf/tests/vmlinux-kallsyms.c                |    7 +-
 tools/perf/ui/browser.c                            |    6 +-
 tools/perf/ui/browsers/annotate.c                  |   33 +-
 tools/perf/ui/browsers/hists.c                     |  341 +++-
 tools/perf/ui/gtk/annotate.c                       |  229 +++
 tools/perf/ui/gtk/browser.c                        |  235 +--
 tools/perf/ui/gtk/gtk.h                            |   10 +-
 tools/perf/ui/gtk/helpline.c                       |   23 +-
 tools/perf/ui/gtk/hists.c                          |  312 ++++
 tools/perf/ui/helpline.c                           |   12 +
 tools/perf/ui/helpline.h                           |   22 +-
 tools/perf/ui/hist.c                               |  481 +++---
 tools/perf/ui/keysyms.h                            |    1 +
 tools/perf/ui/setup.c                              |    3 +-
 tools/perf/ui/stdio/hist.c                         |   25 +-
 tools/perf/ui/tui/helpline.c                       |   29 +-
 tools/perf/ui/util.c                               |    1 -
 tools/perf/util/PERF-VERSION-GEN                   |    4 +-
 tools/perf/util/annotate.c                         |    2 +-
 tools/perf/util/annotate.h                         |   24 +
 tools/perf/util/callchain.c                        |    2 +-
 tools/perf/util/callchain.h                        |    5 +
 tools/perf/util/cpumap.c                           |   54 +
 tools/perf/util/cpumap.h                           |    9 +
 tools/perf/util/debug.c                            |   28 +-
 tools/perf/util/debug.h                            |   34 +-
 tools/perf/util/dso.c                              |    6 +-
 tools/perf/util/dso.h                              |    2 +-
 tools/perf/util/event.c                            |    4 +-
 tools/perf/util/evlist.c                           |   31 +-
 tools/perf/util/evlist.h                           |   34 +-
 tools/perf/util/evsel.c                            |  370 ++++-
 tools/perf/util/evsel.h                            |   50 +-
 tools/perf/util/header.c                           |  266 ++-
 tools/perf/util/header.h                           |    2 +
 tools/perf/util/hist.c                             |  142 +-
 tools/perf/util/hist.h                             |   26 +-
 tools/perf/util/include/linux/bitops.h             |    1 +
 tools/perf/util/intlist.c                          |   36 +-
 tools/perf/util/intlist.h                          |    2 +-
 tools/perf/util/machine.c                          |  784 ++++++++-
 tools/perf/util/machine.h                          |   41 +-
 tools/perf/util/map.c                              |  121 +-
 tools/perf/util/map.h                              |   24 +-
 tools/perf/util/parse-events.c                     |   96 +-
 tools/perf/util/parse-events.h                     |   22 +-
 tools/perf/util/parse-events.y                     |   75 +-
 tools/perf/util/pmu.c                              |   46 +-
 tools/perf/util/pmu.h                              |   15 +-
 tools/perf/util/pmu.y                              |    1 -
 tools/perf/util/probe-finder.c                     |   10 +-
 tools/perf/util/python-ext-sources                 |    1 +
 tools/perf/util/python.c                           |    9 +
 .../perf/util/scripting-engines/trace-event-perl.c |    1 +
 .../util/scripting-engines/trace-event-python.c    |    1 +
 tools/perf/util/session.c                          |  325 +---
 tools/perf/util/session.h                          |   35 +-
 tools/perf/util/sort.c                             |  245 +--
 tools/perf/util/sort.h                             |   15 +-
 tools/perf/util/string.c                           |   18 +
 tools/perf/util/strlist.c                          |   54 +-
 tools/perf/util/strlist.h                          |   42 +-
 tools/perf/util/symbol-elf.c                       |   14 +-
 tools/perf/util/symbol-minimal.c                   |    1 -
 tools/perf/util/symbol.c                           |  536 +-----
 tools/perf/util/symbol.h                           |    9 +-
 tools/perf/util/sysfs.c                            |    2 +-
 tools/perf/util/thread.c                           |   20 +-
 tools/perf/util/thread.h                           |    1 +
 tools/perf/util/top.c                              |   22 +-
 tools/perf/util/top.h                              |   10 +-
 tools/perf/util/util.c                             |   24 +
 tools/perf/util/util.h                             |    4 +
 195 files changed, 8995 insertions(+), 4097 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-events
 create mode 100644 arch/x86/kernel/kprobes/Makefile
 rename arch/x86/kernel/{kprobes-common.h => kprobes/common.h} (90%)
 rename arch/x86/kernel/{kprobes.c => kprobes/core.c} (94%)
 create mode 100644 arch/x86/kernel/kprobes/ftrace.c
 rename arch/x86/kernel/{kprobes-opt.c => kprobes/opt.c} (99%)
 create mode 100644 include/trace/events/ras.h
 delete mode 100644 samples/tracepoints/Makefile
 delete mode 100644 samples/tracepoints/tp-samples-trace.h
 delete mode 100644 samples/tracepoints/tracepoint-probe-sample.c
 delete mode 100644 samples/tracepoints/tracepoint-probe-sample2.c
 delete mode 100644 samples/tracepoints/tracepoint-sample.c
 create mode 100644 tools/perf/bench/numa.c
 delete mode 100644 tools/perf/scripts/perl/bin/workqueue-stats-record
 delete mode 100644 tools/perf/scripts/perl/bin/workqueue-stats-report
 delete mode 100644 tools/perf/scripts/perl/workqueue-stats.pl
 create mode 100644 tools/perf/tests/hists_link.c
 create mode 100644 tools/perf/tests/python-use.c
 delete mode 100644 tools/perf/tests/util.c
 create mode 100644 tools/perf/ui/gtk/annotate.c
 create mode 100644 tools/perf/ui/gtk/hists.c

[ full diff removed due to lkml email size limits. ]
