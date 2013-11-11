Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab3KKPNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:13:15 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38464 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3KKPNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:13:00 -0500
Date: Mon, 11 Nov 2013 16:12:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.13
Message-ID: <20131111151257.GA10435@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

   # HEAD: caea6cf52139116e43e615d87fcbf9823e197fdf Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core

As a first remark I'd like to note that the way to build perf tooling has 
been simplified and sped up, in the future it should be enough for you to 
build perf via:

	cd tools/perf/
	make install

(i.e. without the -j option.) The build system will figure out the number 
of CPUs and will do a parallel build+install.

The various build system inefficiencies and breakages you (Linus) reported 
against the v3.12 pull request should now be resolved - please (re-)report 
any remaining annoyances or bugs.

Main changes on the perf kernel side:

   * Performance optimizations:
      . perf ring-buffer code optimizations,                      by Peter Zijlstra
      . perf ring-buffer code optimizations,                      by Oleg Nesterov
      . x86 NMI call-stack processing optimizations,              by Peter Zijlstra
      . perf context-switch optimizations,                        by Peter Zijlstra
      . perf sampling speedups,                                   by Peter Zijlstra
      . x86 Intel PEBS processing speedups,                       by Peter Zijlstra

   * Enhanced hardware support:
      . for Intel Ivy Bridge-EP uncore PMUs,                      by Zheng Yan
      . for Haswell transactions,                                 by Andi Kleen, Peter Zijlstra

   * Core perf events code enhancements and fixes:
      . for uprobes, if fork() is called with pending ret-probes, by Oleg Nesterov.
      . for uprobes platform support code,                        by Oleg Nesterov.

   * New ABI details:
      . Report x86 Haswell TSX transaction abort cost as weight,  by Andi Kleen

Main changes on the perf tooling side (some of these tooling changes
utilize the above kernel side changes):

   * 'perf report/top' enhancements:

      . Convert callchain children list to rbtree, greatly reducing the time
        taken for callchain processing, from Namhyung Kim.

      . Add new COMM infrastructure, further improving histogram processing, from
        Frédéric Weisbecker, one fix from Namhyung Kim.

      . Add /proc/kcore based live-annotation improvements, including 
        build-id cache support, multi map 'call' instruction navigation 
        fixes, kcore address validation, objdump workarounds. From Adrian 
        Hunter.

      . Show progress on histogram collapsing, that can take a long time, from
        Namhyung Kim.

      . Add --max-stack option to limit callchain stack scan in 'top' and 'report',
        improving callchain processing when reducing the stack depth is an option,
        from Waiman Long.

      . Add new option --ignore-vmlinux for perf top, from Willy Tarreau.


   * 'perf trace' enhancements:

      . 'perf trace' now can can use a 'perf probe' dynamic tracepoints to hook into
        the userspace -> kernel pathname copy so that it can map fds to pathnames
        without reading /proc/pid/fd/ symlinks. From Arnaldo Carvalho de Melo.

      . Show VFS path associated with fd in live sessions, using a 
        'vfs_getname' 'perf probe' created dynamic tracepoint or by 
        looking at /proc/pid/fd, from Arnaldo Carvalho de Melo.

      . Add 'trace' beautifiers for lots of syscall arguments, from 
        Arnaldo Carvalho de Melo.

      . Implement more compact 'trace' output by suppressing zeroed args, 
        from Arnaldo Carvalho de Melo.

      . Show thread COMM by default in 'trace', from Arnaldo Carvalho de Melo.

      . Add option to show full timestamp in 'trace', from David Ahern.

      . Add 'record' command in 'trace', to record raw_syscalls:*, from David Ahern.

      . Add summary option to dump syscall statistics in 'trace', from David Ahern.

      . Improve error messages in 'trace', providing hints about system configuration
        steps needed for using it, from Ramkumar Ramachandra.

      . 'perf trace' now emits hints as to why tracing is not possible, helping the
        user to setup the system to allow tracing in the desired permission
        granularity, telling if the problem is due to debugfs not being mounted or
        with not enough permission for !root, /proc/sys/kernel/perf_event_paranoit
        value, etc. From Arnaldo Carvalho de Melo.


   * 'perf record' enhancements:

      . Check maximum frequency rate for record/top, emitting better error
        messages, from Jiri Olsa.

      . 'perf record' code cleanups, from David Ahern.

      . Improve write_output error message in 'perf record', from Adrian Hunter.

      . Allow specifying B/K/M/G unit to the --mmap-pages arguments, from Jiri Olsa.

      . Fix command line callchain attribute tests to handle the new
        -g/--call-chain semantics, from Arnaldo Carvalho de Melo.


   * 'perf kvm' enhancements:

      . Disable live kvm command if timerfd is not supported, from David Ahern.

      . Fix detection of non-core features, from David Ahern.


   * 'perf list' enhancements:

      . Add usage to 'perf list', from David Ahern.

      . Show error in 'perf list' if tracepoints not available, from Pekka Enberg.


   * 'perf probe' enhancements:

      . Support "$vars" meta argument syntax for local variables, allowing
        asking for all possible variables at a given probe point to be
        collected when it hits, from Masami Hiramatsu.


   * 'perf sched' enhancements:

      . Address the root cause of that 'perf sched' stack initialization build
        slowdown, by programmatically setting a big array after moving the
        global variable back to the stack. Fix from Adrian Hunter.


   * 'perf script' enhancements:

      . Set up output options for in-stream attributes, from Adrian Hunter.

      . Print addr by default for BTS in 'perf script', from Adrian Juntmer


   * 'perf stat' enhancements:

      . Improved messages when doing profiling in all or a subset of CPUs
        using a workload as the session delimitator, as in:

         'perf stat --cpu 0,2 sleep 10s'

        from Arnaldo Carvalho de Melo.

      . Add units to nanosec-based counters in 'perf stat', from David Ahern.

      . Remove bogus info when using 'perf stat' -e cycles/instructions, from
        Ramkumar Ramachandra.


   * 'perf lock' enhancements:

      . 'perf lock' fixes and cleanups, from Davidlohr Bueso.


   * 'perf test' enhancements:

      . Fixup PERF_SAMPLE_TRANSACTION handling in sample synthesizing and
        'perf test', from Adrian Hunter.

      . Clarify the "sample parsing" test entry, from Arnaldo Carvalho de Melo.

      . Consider PERF_SAMPLE_TRANSACTION in the "sample parsing" test,
        from Arnaldo Carvalho de Melo.

      . Memory leak fixes in 'perf test', from Felipe Pena.


   * 'perf bench' enhancements:

      . Change the procps visible command-name of invididual benchmark tests
        plus cleanups, from Ingo Molnar.


   * Generic perf tooling infrastructure/plumbing changes:

      . Separating data file properties from session, code reorganization from
        Jiri Olsa.

      . Fix version when building out of tree, as when using one of these:

        $ make help | grep perf
          perf-tar-src-pkg    - Build perf-3.12.0.tar source tarball
          perf-targz-src-pkg  - Build perf-3.12.0.tar.gz source tarball
          perf-tarbz2-src-pkg - Build perf-3.12.0.tar.bz2 source tarball
          perf-tarxz-src-pkg  - Build perf-3.12.0.tar.xz source tarball
        $

        from David Ahern.

      . Enhance option parse error message, showing just the help lines of the
        options affected, from Namhyung Kim.

      . libtraceevent updates from upstream trace-cmd repo, from Steven Rostedt.

      . Always use perf_evsel__set_sample_bit to set sample_type, from Adrian Hunter.

      . Memory and mmap leak fixes from Chenggang Qin.

      . Assorted build fixes for from David Ahern and Jiri Olsa.

      . Speed up and prettify the build system, from Ingo Molnar.

      . Implement addr2line directly using libbfd, from Roberto Vitillo.

      . Separate the GTK support in a separate libperf-gtk.so DSO, that is
        only loaded when --gtk is specified, from Namhyung Kim.

      . perf bash completion fixes and improvements from Ramkumar Ramachandra.

      . Support for Openembedded/Yocto -dbg packages, from Ricardo Ribalda Delgado.

And lots and lots of other fixes and code reorganizations that did not 
make it into the list, see the shortlog, diffstat and the Git log for 
details!

 Thanks,

	Ingo

------------------>
Adrian Hunter (37):
      perf machine: Use snprintf instead of sprintf
      perf symbols: Make a separate function to parse /proc/modules
      perf symbols: Validate kcore module addresses
      perf symbols: Workaround objdump difficulties with kcore
      perf annotate: Find kcore symbols on other maps
      perf tools: Add copyfile_mode()
      perf symbols: Add ability to find kcore in build-id cache
      perf annotate: Fix annotate_browser__callq()
      perf buildid-cache: Add ability to add kcore to the cache
      perf annotate: Another fix for annotate_browser__callq()
      perf evsel: Add missing 'mmap2' from debug print
      perf evsel: Add missing decrement in id sample parsing
      perf record: Improve write_output error message
      perf session: Add missing sample flush for piped events
      perf session: Add missing members to perf_event__attr_swap()
      perf evlist: Fix 32-bit build error
      perf tools: Fix test_on_exit for 32-bit build
      perf tools: Fix bench/numa.c for 32-bit build
      perf evlist: Fix perf_evlist__mmap comments
      perf evlist: Factor out duplicated mmap code
      perf script: Print addr by default for BTS
      perf sched: Make struct perf_sched sched a local variable
      perf sched: Optimize build time
      perf script: Make perf_script a local variable
      perf inject: Do not repipe attributes to a perf.data file
      perf tools: Do not accept parse_tag_value() overflow
      perf evlist: Validate that mmap_pages is not too big
      perf tools: Fix non-debug build
      perf evsel: Add a debug print if perf_event_open fails
      perf script: Set up output options for in-stream attributes
      perf tools: Fix 32-bit cross build
      perf tools: Fix libunwind build and feature detection for 32-bit build
      perf evlist: Add a debug print if event buffer mmap fails
      perf evsel: Always use perf_evsel__set_sample_bit()
      perf evsel: Add missing overflow check for TRANSACTION
      perf test: Update "sample parsing" test for PERF_SAMPLE_TRANSACTION
      perf evsel: Synthesize PERF_SAMPLE_TRANSACTION

Andi Kleen (11):
      perf/x86/intel: Avoid checkpointed counters causing excessive TSX aborts
      perf/x86: Report TSX transaction abort cost as weight
      perf/x86/intel: Add Haswell TSX event aliases
      tools/perf: Fix sorting for 64bit entries
      tools/perf/stat: Add perf stat --transaction
      perf: Add generic transaction flags
      perf/x86: Add Haswell specific transaction flag reporting
      tools/perf: Support sorting by in_tx or abort branch flags
      tools/perf/record: Add abort_tx,no_tx,in_tx branch filter options to perf record -j
      tools/perf: Add support for record transaction flags
      perf/x86: Suppress duplicated abort LBR records

Arnaldo Carvalho de Melo (45):
      perf trace: Put syscall formatter parms into struct
      perf trace: Allow passing parms to arg formatters
      perf trace: Use strarray for ltrace's whence arg
      perf trace: Beautify fcntl 'cmd' arg
      perf trace: Beautify rt_sigprocmask 'how' arg
      perf trace: Beautify signal number arg in several syscalls
      perf trace: Beautify socket 'family' arg
      perf trace: Beautify socket 'type' arg
      perf trace: Beautify access 'mode' arg
      perf trace: Beautify rlmimit resources
      perf trace: Don't print zeroed args
      perf trace: Beautify send/recv syscall 'flags' arg
      perf trace: Beautify eventfd2 'flags' arg
      perf trace: Add option to show process COMM
      perf trace: Beautify epoll_ctl 'op' arg
      perf trace: Beautify flock 'cmd' arg
      perf trace: Add helper for syscalls with a single strarray arg
      perf trace: Don't supress zeroed args when there is an strarray entry for it
      perf trace: Use socket's beautifiers in socketpair
      perf trace: Beautify pipe2 'flags' arg
      perf trace: Beautify mlock & friends 'addr' arg
      perf trace: Show path associated with fd in live sessions
      perf trace: Add 'trace' alias to 'perf trace'
      perf trace: Allow specifying index offset in strarrays
      perf trace: Prepare the strarray scnprintf method for reuse
      perf trace: Initial beautifier for ioctl's 'cmd' arg
      perf symbols: Add map_groups__find_ams()
      perf scripting perl: Fix build error on Fedora 12
      perf trace: Split fd -> pathname array handling
      perf trace: Use vfs_getname hook if available
      perf trace: Improve event processing exit
      perf evlist: Introduce perf_evlist__strerror_tp method
      perf tools: Introduce filename__read_int helper
      perf trace: Improve messages related to /proc/sys/kernel/perf_event_paranoid
      perf test: Clarify the "sample parsing" test entry
      perf test: Consider PERF_SAMPLE_TRANSACTION in the "sample parsing" test
      perf tools: Stop using 'self' in some more places
      perf ui: Rename ui_progress to ui_progress_ops
      perf ui progress: Per progress bar state
      perf test: Update command line callchain attribute tests
      perf probe: Fix typo
      perf fs: Rename NAME_find_mountpoint() to NAME__mountpoint()
      perf tools: Finish the removal of 'self' arguments
      perf evsel: Ditch evsel->handler.data field
      perf trace: Don't relookup fields by name in each sample

Chenggang Qin (2):
      perf symbols: Fix a memory leak due to symbol__delete not being used
      perf symbols: Fix a mmap and munmap mismatched bug

David A. Long (1):
      uprobes: Move function declarations out of arch

David Ahern (23):
      perf trace: Add option to show full timestamp
      perf trace: Remove duplicate mmap entry in syscall_fmts array
      perf trace: Add beautifier for clock_gettime's clk_id argument
      perf trace: Handle MSG_WAITFORONE not defined
      perf stat: Fix misleading message when specifying cpu list or system wide
      perf stat: Don't require a workload when using system wide or CPU options
      perf stat: Add units to nanosec-based counters
      perf trace: Fix comm resolution when reading events from file
      perf trace: Add record option
      perf machine: Add method to loop over threads and invoke handler
      perf trace: Use new machine method to loop over threads
      perf intlist: Add priv member
      perf util: Add findnew method to intlist
      perf trace: Add summary option to dump syscall statistics
      perf tools: Fix old GCC build error in 'get_srcline'
      perf kvm: Disable live command if timerfd is not supported
      tools/perf/build: Fix detection of non-core features
      perf list: Remove a level of indentation
      perf list: Add usage
      perf tools: Fix version when building out of tree
      perf record: Refactor feature handling into a separate function
      perf record: Remove advance_output function
      perf record: Remove post_processing_offset variable

Davidlohr Bueso (6):
      perf lock: Remove dead code
      perf lock: Return proper code in report_lock_*_event
      perf lock: Plug some memleaks
      perf lock: Redo __cmd_report
      perf lock: Limit bad rate precision
      perf lock: Account for lock average wait time

Felipe Pena (1):
      perf tests: Fix memory leak in dso-data.c

Frederic Weisbecker (4):
      perf tools: Use an accessor to read thread comm
      perf tools: Add time argument on COMM setting
      perf tools: Add new COMM infrastructure
      perf tools: Compare hists comm by addresses

Howard Cochran (1):
      tools lib traceevent: Handle __print_hex(__get_dynamic_array(fieldname), len)

Ingo Molnar (67):
      perf/x86/intel: Clean up EVENT_ATTR_STR() muck
      tools/perf: Standardize feature support define names to: HAVE_{FEATURE}_SUPPORT
      tools/perf/build: Add feature check core code
      tools/perf/build: Add 'autodep' functionality, generate feature test dependencies automatically
      tools/perf/build: Split out feature check: 'libnuma'
      tools/perf/build: Split out feature check: 'stackprotector-all'
      tools/perf/build: Split out feature check: 'stackprotector'
      tools/perf/build: Split out feature check: 'volatile-register-var'
      tools/perf/build: Split out feature check: 'fortify-source'
      tools/perf/build: Split out feature check: 'bionic'
      tools/perf/build: Clean up the libelf logic in config/Makefile
      tools/perf/build: Split out feature check: 'libelf'
      tools/perf/build: Split out feature check: 'glibc'
      tools/perf/build: Split out feature check: 'dwarf'
      tools/perf/build: Clean up the mmap logic in config/Makefile
      tools/perf/build: Split out feature check: 'libelf-mmap'
      tools/perf/build: Split out feature check: 'libelf-getphdrnum'
      tools/perf/build: Clean up the libunwind logic in config/Makefile
      tools/perf/build: Split out feature check: 'libunwind'
      tools/perf/build: Split out feature check: 'libaudit'
      tools/perf/build: Split out feature check: 'libslang'
      tools/perf/build: Split out feature check: 'gtk2'
      tools/perf/build: Split out feature check: 'gtk2-infobar'
      tools/perf/build: Split out feature check: 'libperl'
      tools/perf/build: Split out feature check: 'libpython'
      tools/perf/build: Split out feature check: 'libpython-version'
      tools/perf/build: Split out feature check: 'libbfd'
      tools/perf/build: Split out feature check: 'strlcpy'
      tools/perf/build: Split out feature check: 'on-exit'
      tools/perf/build: Split out feature check: 'backtrace'
      tools/perf: Clean up util/include/linux/compiler.h
      tools/perf: Turn strlcpy() into a __weak function
      tools/perf/build: Speed up auto-detection of features by adding a 'test-all' target
      tools/perf/build: Speed up git-version test on re-make
      tools/perf/build: Speed up the final link
      tools/perf: Fix double/triple-build of the feature detection logic during 'make install' et al
      tools/perf/build: Invoke feature-checks 'clean' target from the main Makefile
      tools/perf/build: Speed up auto-detection
      tools/perf/build: Improve printout-of auto-detected features
      tools/perf/build: Automatically build in parallel, based on number of CPUs in the system
      tools/perf/build: Flip Makefile.parallel and Makefile.perf
      tools/perf/build: Standardize the various messages output by parallel make
      tools/perf/build: Split out feature checks: 'liberty', 'liberty-z', 'cplus-demangle'
      tools/perf/build: Remove unused config/feature-tests.mak
      tools/perf/build: Clean up various testcases
      tools/perf/build: Collapse the test-all.c testcase
      tools/perf/build: Pass through all targets to Makefile.perf
      tools/perf/build: Make sure autodep feature binaries honor the O= setting
      tools/perf/build: Exclude MAKEFLAGS from nested invocation
      tools/perf/build: Fix non-canonical directory names in O=
      tools/perf/build: Fix O=/some/dir perf.o type of targets
      tools/perf/build: Harmonize the style of the feature testcases
      tools/perf/build: Pass through LDFLAGS to feature tests
      perf bench sched: Add --threaded option
      perf tools: Fix redirection printouts
      perf tools: Implement summary output for 'make clean'
      tools: Harmonize the various build messages in perf, lib-traceevent, lib-lk
      perf tools: Align perf version output to other build messages
      perf tools: Implement summary output for 'make install'
      tools/perf/build: Fix non-existent build directory handling
      tools/perf/build: Pass through DEBUG parameter
      tools/perf/build: Fix DPACKAGE definitions for the libbfd et al testcases
      tools/perf/build: Simplify the libelf logic
      tools/perf/build: Remove the volatile-register-var feature check
      tools/perf/build: Improve the 'stackprotector' feature test
      tools/perf/build: Simplify the autodep inclusion rule
      perf bench: Change the procps visible command-name of invididual benchmark tests plus cleanups

Jiri Olsa (18):
      tools/perf/build: Clean up feature_print_code()
      perf tools: Remove unused trace-event-* code
      perf tools: Unify page_size usage
      perf tools: Check mmap pages value early
      perf tools: Add possibility to specify mmap size
      perf evlist: Introduce perf_evlist__new_default function
      perf tools: Adding throttle event data struct support
      perf tools: Add missing -ldl for gtk build
      perf tools: Move start conditions to start of the flex file
      perf evlist: Fix perf_evlist__mmap_read event overflow
      perf tools: Separate lbfd check out of NO_DEMANGLE condition
      perf tools: Add data object to handle perf data file
      perf tools: Add perf_data_file__open interface to data object
      perf session: Separating data file properties from session
      perf tools: Add missing data.h into LIB_H headers
      perf tools: Factor sysfs code into generic fs object
      perf fs: Add procfs support
      perf tools: Check maximum frequency rate for record/top

Knut Petersen (1):
      perf: Enforce 1 as lower limit for perf_event_max_sample_rate

Masami Hiramatsu (2):
      perf probe: Support "$vars" meta argument syntax for local variables
      perf probe: Find fentry mcount fuzzed parameter location

Michael Hudson-Doyle (1):
      perf tools: Remove cast of non-variadic function to variadic

Namhyung Kim (19):
      perf tools: Separate out GTK codes to libperf-gtk.so
      perf sort: Fix a memory leak on srcline
      perf annotate: Reuse path from the result of addr2line
      perf hists: Free srcline when freeing hist_entry
      perf annotate: Factor out get/free_srcline()
      perf tools: Do not try to call addr2line on non-binary files
      perf annotate: Pass dso instead of dso_name to get_srcline()
      perf tools: Save failed result of get_srcline()
      perf tools: Fix srcline sort key behavior
      perf callchain: Convert children list to rbtree
      perf tools: Compare dso's also when comparing symbols
      perf tools: Show progress on histogram collapsing
      perf tools: Get current comm instead of last one
      perf tools: Show single option when failed to parse
      perf report: Postpone setting up browser after parsing options
      perf report: Use parse_options_usage() for -s option failure
      perf top: Use parse_options_usage() for -s option failure
      perf stat: Enhance option parse error message
      perf hists: Consolidate __hists__add_*entry()

Oleg Nesterov (14):
      perf: Kill the dead !vma->vm_mm code in perf_event_mmap_event()
      perf: Do not waste PAGE_SIZE bytes for ALIGN(8) in perf_event_mmap_event()
      uprobes: Change the callsite of uprobe_copy_process()
      uprobes: Introduce __create_xol_area()
      uprobes: Teach __create_xol_area() to accept the predefined vaddr
      uprobes: Change uprobe_copy_process() to dup return_instances
      uprobes: Change uprobe_copy_process() to dup xol_area
      uprobes: Teach uprobe_copy_process() to handle CLONE_VFORK
      perf: Factor out strncpy() in perf_event_mmap_event()
      uprobes: Kill module_init() and module_exit()
      uprobes: Introduce arch_uprobe->ixol
      uprobes: Export write_opcode() as uprobe_write_opcode()
      uprobes: Fix the wrong usage of current->utask in uprobe_copy_process()
      uprobes: Fix the memory out of bound overwrite in copy_insn()

Pekka Enberg (1):
      perf list: Show error if tracepoints not available

Peter Zijlstra (17):
      perf/x86/intel: Clean up checkpoint-interrupt bits
      perf/x86/intel: Clean-up/reduce PEBS code
      perf/x86/intel: Remove division from the intel_pmu_drain_pebs_nhm() hot path
      perf/x86/intel: Fix build warning in intel_pmu_drain_pebs_nhm()
      perf/x86: Optimize intel_pmu_pebs_fixup_ip()
      perf: Remove useless atomic_t
      perf: Change zero-padding of strings in perf_event_mmap_event()
      perf/x86: Further optimize copy_from_user_nmi()
      perf: Fix the perf context switch optimization
      perf: Simplify the ring-buffer code
      perf: Add unlikely() to the ring-buffer code
      perf: Optimize perf_output_begin()
      perf: Optimize perf_output_begin() -- lost_event case
      perf: Optimize perf_output_begin() -- address calculation
      perf: Update a stale comment
      perf: Fix arch_perf_out_copy_user default
      tools/perf: Add required memory barriers

Petr Holasek (1):
      perf bench: Fix failing assertions in numa bench

Ralf Baechle (1):
      uprobes: Remove the wrong __weak attribute

Ramkumar Ramachandra (11):
      perf completion: Don't dictate perf install location
      perf completion: Update __ltrim_colon_completions
      perf completion: Strip dependency on _filedir
      perf completion: Strip function_exists ()
      perf completion: Strip dependency on bash-completion
      perf completion: Use more comp words
      perf stat: Don't print bogus data on -e cycles
      perf stat: Don't print bogus data on -e instructions
      perf tools: Ignore 'perf timechart' output file
      perf timechart: Add example in the documentation
      perf trace: Improve the error messages

Ricardo Ribalda Delgado (1):
      perf symbols: Support for Openembedded/Yocto -dbg packages

Roberto Vitillo (1):
      perf tools: Implement addr2line directly using libbfd

Rodrigo Campos (1):
      perf tools: Remove unneeded include

Steven Rostedt (2):
      tools lib traceevent: Add flags NOHANDLE and PRINTRAW to individual events
      tools lib traceevent: Add pevent_print_func_field() helper function

Steven Rostedt (Red Hat) (4):
      tools lib traceevent: Update printk formats when entered
      tools lib traceevent: If %s is a pointer, check printk formats
      tools lib traceevent: Have bprintk output the same as the kernel does
      tools lib traceevent: Check for spaces in character array

Waiman Long (2):
      perf report: Add --max-stack option to limit callchain stack scan
      perf top: Add --max-stack option to limit callchain stack scan

Wei Yang (1):
      perf bench: Fix two warnings

Willy Tarreau (1):
      perf symbols: Add new option --ignore-vmlinux for perf top

Yan, Zheng (2):
      perf/x86/intel/uncore: Add filter support for IvyBridge-EP QPI boxes
      perf/x86/intel: Add Ivy Bridge-EP uncore IRP box support

Yoshihiro YUNOMAE (1):
      tools lib traceevent: Add support for extracting trace_clock in report


 arch/powerpc/include/asm/uprobes.h                 |    8 +-
 arch/x86/include/asm/uprobes.h                     |   12 +-
 arch/x86/kernel/cpu/perf_event.c                   |    4 +-
 arch/x86/kernel/cpu/perf_event.h                   |    6 +
 arch/x86/kernel/cpu/perf_event_intel.c             |   78 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  203 +--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |   31 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |  134 +-
 arch/x86/lib/usercopy.c                            |   43 +-
 arch/x86/mm/fault.c                                |   41 +-
 arch/x86/oprofile/backtrace.c                      |    4 +-
 include/linux/perf_event.h                         |    5 +
 include/linux/uprobes.h                            |   15 +-
 include/uapi/linux/perf_event.h                    |   25 +-
 kernel/events/core.c                               |  156 ++-
 kernel/events/internal.h                           |   35 +-
 kernel/events/ring_buffer.c                        |  101 +-
 kernel/events/uprobes.c                            |  223 +++-
 kernel/fork.c                                      |    2 +-
 kernel/sysctl.c                                    |    1 +
 scripts/package/Makefile                           |    4 +-
 tools/lib/traceevent/Makefile                      |   18 +-
 tools/lib/traceevent/event-parse.c                 |  165 ++-
 tools/lib/traceevent/event-parse.h                 |   14 +-
 tools/perf/.gitignore                              |    1 +
 tools/perf/Documentation/Makefile                  |   79 +-
 tools/perf/Documentation/perf-buildid-cache.txt    |   13 +
 tools/perf/Documentation/perf-kvm.txt              |    4 +-
 tools/perf/Documentation/perf-lock.txt             |    2 +-
 tools/perf/Documentation/perf-record.txt           |   11 +-
 tools/perf/Documentation/perf-report.txt           |   16 +-
 tools/perf/Documentation/perf-stat.txt             |    5 +
 tools/perf/Documentation/perf-timechart.txt        |   15 +-
 tools/perf/Documentation/perf-top.txt              |   15 +-
 tools/perf/Documentation/perf-trace.txt            |   31 +-
 tools/perf/Makefile                                |  848 +-----------
 tools/perf/Makefile.perf                           |  892 +++++++++++++
 tools/perf/arch/x86/include/perf_regs.h            |    6 +-
 tools/perf/arch/x86/util/unwind.c                  |    4 +-
 tools/perf/bash_completion                         |  106 +-
 tools/perf/bench/mem-memcpy-arch.h                 |    2 +-
 tools/perf/bench/mem-memcpy.c                      |    2 +-
 tools/perf/bench/mem-memset-arch.h                 |    2 +-
 tools/perf/bench/mem-memset.c                      |    2 +-
 tools/perf/bench/numa.c                            |   38 +-
 tools/perf/bench/sched-pipe.c                      |  115 +-
 tools/perf/builtin-annotate.c                      |   45 +-
 tools/perf/builtin-bench.c                         |  245 ++--
 tools/perf/builtin-buildid-cache.c                 |  156 ++-
 tools/perf/builtin-buildid-list.c                  |   11 +-
 tools/perf/builtin-diff.c                          |   31 +-
 tools/perf/builtin-evlist.c                        |    7 +-
 tools/perf/builtin-inject.c                        |   46 +-
 tools/perf/builtin-kmem.c                          |   13 +-
 tools/perf/builtin-kvm.c                           |   30 +-
 tools/perf/builtin-list.c                          |   84 +-
 tools/perf/builtin-lock.c                          |  137 +-
 tools/perf/builtin-mem.c                           |    9 +-
 tools/perf/builtin-probe.c                         |   14 +-
 tools/perf/builtin-record.c                        |  168 +--
 tools/perf/builtin-report.c                        |  124 +-
 tools/perf/builtin-sched.c                         |   70 +-
 tools/perf/builtin-script.c                        |  127 +-
 tools/perf/builtin-stat.c                          |  211 ++-
 tools/perf/builtin-timechart.c                     |   14 +-
 tools/perf/builtin-top.c                           |   61 +-
 tools/perf/builtin-trace.c                         | 1403 +++++++++++++++++---
 tools/perf/config/Makefile                         |  371 ++++--
 tools/perf/config/feature-checks/Makefile          |  148 +++
 tools/perf/config/feature-checks/test-all.c        |  111 ++
 tools/perf/config/feature-checks/test-backtrace.c  |   13 +
 tools/perf/config/feature-checks/test-bionic.c     |    6 +
 .../config/feature-checks/test-cplus-demangle.c    |   14 +
 tools/perf/config/feature-checks/test-dwarf.c      |   10 +
 .../config/feature-checks/test-fortify-source.c    |    6 +
 tools/perf/config/feature-checks/test-glibc.c      |    8 +
 .../perf/config/feature-checks/test-gtk2-infobar.c |   11 +
 tools/perf/config/feature-checks/test-gtk2.c       |   10 +
 tools/perf/config/feature-checks/test-hello.c      |    6 +
 tools/perf/config/feature-checks/test-libaudit.c   |   10 +
 tools/perf/config/feature-checks/test-libbfd.c     |   15 +
 .../config/feature-checks/test-libelf-getphdrnum.c |    8 +
 .../perf/config/feature-checks/test-libelf-mmap.c  |    8 +
 tools/perf/config/feature-checks/test-libelf.c     |    8 +
 tools/perf/config/feature-checks/test-libnuma.c    |    9 +
 tools/perf/config/feature-checks/test-libperl.c    |    9 +
 .../config/feature-checks/test-libpython-version.c |   10 +
 tools/perf/config/feature-checks/test-libpython.c  |    8 +
 tools/perf/config/feature-checks/test-libslang.c   |    6 +
 tools/perf/config/feature-checks/test-libunwind.c  |   27 +
 tools/perf/config/feature-checks/test-on-exit.c    |   16 +
 .../feature-checks/test-stackprotector-all.c       |    6 +
 .../config/feature-checks/test-stackprotector.c    |    6 +
 tools/perf/config/feature-checks/test-timerfd.c    |   18 +
 .../feature-checks/test-volatile-register-var.c    |    6 +
 tools/perf/config/feature-tests.mak                |  246 ----
 tools/perf/config/utilities.mak                    |   17 +-
 tools/perf/perf.c                                  |   14 +-
 tools/perf/perf.h                                  |   65 +-
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |    6 +-
 tools/perf/tests/attr/README                       |    6 +-
 tools/perf/tests/attr/test-record-graph-default    |    2 +-
 tools/perf/tests/attr/test-record-graph-dwarf      |    2 +-
 tools/perf/tests/attr/test-record-graph-fp         |    2 +-
 tools/perf/tests/code-reading.c                    |    2 +-
 tools/perf/tests/dso-data.c                        |    1 +
 tools/perf/tests/hists_link.c                      |   14 +-
 tools/perf/tests/parse-events.c                    |    6 +-
 tools/perf/tests/perf-record.c                     |   12 +-
 tools/perf/tests/rdpmc.c                           |    2 -
 tools/perf/tests/sample-parsing.c                  |   11 +-
 tools/perf/tests/task-exit.c                       |   14 +-
 tools/perf/ui/browser.h                            |   32 +-
 tools/perf/ui/browsers/annotate.c                  |   24 +-
 tools/perf/ui/browsers/hists.c                     |   12 +-
 tools/perf/ui/browsers/map.c                       |   40 +-
 tools/perf/ui/browsers/map.h                       |    2 +-
 tools/perf/ui/browsers/scripts.c                   |    8 +-
 tools/perf/ui/gtk/annotate.c                       |   13 +-
 tools/perf/ui/gtk/browser.c                        |    2 +-
 tools/perf/ui/gtk/gtk.h                            |   22 +-
 tools/perf/ui/gtk/progress.c                       |   20 +-
 tools/perf/ui/gtk/setup.c                          |    2 +-
 tools/perf/ui/gtk/util.c                           |    4 +-
 tools/perf/ui/hist.c                               |    2 +-
 tools/perf/ui/progress.c                           |   32 +-
 tools/perf/ui/progress.h                           |   19 +-
 tools/perf/ui/setup.c                              |   61 +-
 tools/perf/ui/stdio/hist.c                         |   14 +-
 tools/perf/ui/tui/progress.c                       |   15 +-
 tools/perf/ui/tui/setup.c                          |    3 +-
 tools/perf/ui/tui/tui.h                            |    6 +
 tools/perf/ui/ui.h                                 |   14 +-
 tools/perf/util/PERF-VERSION-GEN                   |    5 +-
 tools/perf/util/annotate.c                         |   76 +-
 tools/perf/util/annotate.h                         |   26 +-
 tools/perf/util/build-id.c                         |    6 +-
 tools/perf/util/build-id.h                         |    3 +-
 tools/perf/util/cache.h                            |    3 +-
 tools/perf/util/callchain.c                        |  147 +-
 tools/perf/util/callchain.h                        |   11 +-
 tools/perf/util/color.c                            |   11 +-
 tools/perf/util/color.h                            |    2 +-
 tools/perf/util/comm.c                             |  121 ++
 tools/perf/util/comm.h                             |   21 +
 tools/perf/util/cpumap.c                           |    6 +-
 tools/perf/util/data.c                             |  120 ++
 tools/perf/util/data.h                             |   48 +
 tools/perf/util/dso.c                              |   50 +-
 tools/perf/util/dso.h                              |    3 +
 tools/perf/util/event.c                            |   38 +-
 tools/perf/util/event.h                            |   14 +-
 tools/perf/util/evlist.c                           |  249 +++-
 tools/perf/util/evlist.h                           |   19 +-
 tools/perf/util/evsel.c                            |   29 +-
 tools/perf/util/evsel.h                            |   11 +-
 tools/perf/util/fs.c                               |  119 ++
 tools/perf/util/fs.h                               |    7 +
 tools/perf/util/generate-cmdlist.sh                |    4 +-
 tools/perf/util/header.c                           |   22 +-
 tools/perf/util/hist.c                             |   95 +-
 tools/perf/util/hist.h                             |   75 +-
 tools/perf/util/include/dwarf-regs.h               |    2 +-
 tools/perf/util/include/linux/compiler.h           |   19 +-
 tools/perf/util/include/linux/magic.h              |    4 +
 tools/perf/util/intlist.c                          |   23 +-
 tools/perf/util/intlist.h                          |    2 +
 tools/perf/util/machine.c                          |  166 +--
 tools/perf/util/machine.h                          |   29 +-
 tools/perf/util/map.c                              |   50 +-
 tools/perf/util/map.h                              |    7 +
 tools/perf/util/parse-events.c                     |    4 +-
 tools/perf/util/parse-events.l                     |   63 +-
 tools/perf/util/parse-options.c                    |  218 +--
 tools/perf/util/parse-options.h                    |    4 +-
 tools/perf/util/path.c                             |   10 +-
 tools/perf/util/perf_regs.h                        |    4 +-
 tools/perf/util/pmu.c                              |   33 +-
 tools/perf/util/pmu.h                              |    1 +
 tools/perf/util/probe-event.c                      |    5 +-
 tools/perf/util/probe-finder.c                     |  248 +++-
 tools/perf/util/probe-finder.h                     |   15 +-
 tools/perf/util/pstack.h                           |   10 +-
 tools/perf/util/python-ext-sources                 |    2 +-
 tools/perf/util/python.c                           |    8 +-
 tools/perf/util/rblist.c                           |   27 +-
 tools/perf/util/rblist.h                           |    1 +
 tools/perf/util/record.c                           |   71 +
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    4 +-
 tools/perf/util/session.c                          |  278 ++--
 tools/perf/util/session.h                          |   38 +-
 tools/perf/util/sort.c                             |  318 +++--
 tools/perf/util/sort.h                             |    8 +-
 tools/perf/util/srcline.c                          |  265 ++++
 tools/perf/util/strfilter.c                        |   72 +-
 tools/perf/util/strfilter.h                        |   12 +-
 tools/perf/util/symbol-elf.c                       |  607 ++++++++-
 tools/perf/util/symbol-minimal.c                   |   15 +
 tools/perf/util/symbol.c                           |  449 ++++++-
 tools/perf/util/symbol.h                           |   29 +-
 tools/perf/util/sysfs.c                            |   60 -
 tools/perf/util/sysfs.h                            |    6 -
 tools/perf/util/thread.c                           |  137 +-
 tools/perf/util/thread.h                           |   20 +-
 tools/perf/util/top.h                              |    1 +
 tools/perf/util/trace-event-parse.c                |   36 -
 tools/perf/util/trace-event.h                      |    9 -
 tools/perf/util/unwind.h                           |    4 +-
 tools/perf/util/util.c                             |   66 +-
 tools/perf/util/util.h                             |   26 +
 tools/scripts/Makefile.include                     |   23 +-
 212 files changed, 9109 insertions(+), 3939 deletions(-)
 create mode 100644 tools/perf/Makefile.perf
 create mode 100644 tools/perf/config/feature-checks/Makefile
 create mode 100644 tools/perf/config/feature-checks/test-all.c
 create mode 100644 tools/perf/config/feature-checks/test-backtrace.c
 create mode 100644 tools/perf/config/feature-checks/test-bionic.c
 create mode 100644 tools/perf/config/feature-checks/test-cplus-demangle.c
 create mode 100644 tools/perf/config/feature-checks/test-dwarf.c
 create mode 100644 tools/perf/config/feature-checks/test-fortify-source.c
 create mode 100644 tools/perf/config/feature-checks/test-glibc.c
 create mode 100644 tools/perf/config/feature-checks/test-gtk2-infobar.c
 create mode 100644 tools/perf/config/feature-checks/test-gtk2.c
 create mode 100644 tools/perf/config/feature-checks/test-hello.c
 create mode 100644 tools/perf/config/feature-checks/test-libaudit.c
 create mode 100644 tools/perf/config/feature-checks/test-libbfd.c
 create mode 100644 tools/perf/config/feature-checks/test-libelf-getphdrnum.c
 create mode 100644 tools/perf/config/feature-checks/test-libelf-mmap.c
 create mode 100644 tools/perf/config/feature-checks/test-libelf.c
 create mode 100644 tools/perf/config/feature-checks/test-libnuma.c
 create mode 100644 tools/perf/config/feature-checks/test-libperl.c
 create mode 100644 tools/perf/config/feature-checks/test-libpython-version.c
 create mode 100644 tools/perf/config/feature-checks/test-libpython.c
 create mode 100644 tools/perf/config/feature-checks/test-libslang.c
 create mode 100644 tools/perf/config/feature-checks/test-libunwind.c
 create mode 100644 tools/perf/config/feature-checks/test-on-exit.c
 create mode 100644 tools/perf/config/feature-checks/test-stackprotector-all.c
 create mode 100644 tools/perf/config/feature-checks/test-stackprotector.c
 create mode 100644 tools/perf/config/feature-checks/test-timerfd.c
 create mode 100644 tools/perf/config/feature-checks/test-volatile-register-var.c
 delete mode 100644 tools/perf/config/feature-tests.mak
 create mode 100644 tools/perf/ui/tui/tui.h
 create mode 100644 tools/perf/util/comm.c
 create mode 100644 tools/perf/util/comm.h
 create mode 100644 tools/perf/util/data.c
 create mode 100644 tools/perf/util/data.h
 create mode 100644 tools/perf/util/fs.c
 create mode 100644 tools/perf/util/fs.h
 create mode 100644 tools/perf/util/srcline.c
 delete mode 100644 tools/perf/util/sysfs.c
 delete mode 100644 tools/perf/util/sysfs.h

[ Full diff skipped due to lkml size limits. ]
