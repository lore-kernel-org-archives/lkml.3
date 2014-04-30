Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbaD3Srs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:47:48 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:60988 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198AbaD3Srq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:47:46 -0400
Date: Wed, 30 Apr 2014 14:47:39 -0400 (EDT)
From: Jonathan Lebon <jlebon@redhat.com>
To: systemtap@sourceware.org
Cc: linux-kernel@vger.kernel.org, lwn@lwn.net
Message-ID: <830924815.13711855.1398883659658.JavaMail.zimbra@redhat.com>
In-Reply-To: <1089889270.13709784.1398883419300.JavaMail.zimbra@redhat.com>
Subject: SystemTap 2.5 release
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF28 (Linux)/8.0.6_GA_5922)
Thread-Topic: SystemTap 2.5 release
Thread-Index: momj3vWSIXpfX/bvff3wCOSrO7odJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SystemTap team announces release 2.5, "boot loot"!

  UEFI/SecureBoot support, boot-time probing, function callee probing,
  improved error messages, better statement probing, improved function
  prologue endings detection, and more!


= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-2.5.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-2.5 (commit 8f0fcd9)

  There have been over 592 commits since the last release.
  There have been over 74 bugs fixed / features added since the last
  release.


= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree

  Further information at http://sourceware.org/systemtap/wiki/


= SystemTap frontend (stap) changes

- SystemTap now supports UEFI/SecureBoot systems, via
  machine-owner-keys maintained by a trusted stap-server on the
  network.  (Key enrollment requires a one-time reboot and BIOS
  conversation.)

- SystemTap is now capable of inserting modules early during the boot
  process on dracut-based systems. See the 'onboot' command in
  systemtap(8) for more information.

- DWARF probes can now use the '.callee[s]' variants, which allow more
  precise function probing. For example, the probe point

    process("myproc").function("foo").callee("bar")

  will fire upon entering bar() from foo(). A '.callees' probe will
  instead place probes on all callees of foo().
    Note that this also means that probe point wildcards should be used
  with more care. For example, use signal.*.return rather than
  signal.*.*, which would also match '.callees'. See stapprobes(3stap)
  for more info. This feature requires at least GCC 4.7.

- New switches have been added to help inspect the contents of installed
  library files:

  stap --dump-functions --> list all library functions and their args
  stap --dump-probe-aliases --> list all library probe aliases

- Statement probes (e.g. process.statement) are now faster to resolve,
  more precise, and work better with inlined functions.

- The heuristic algorithms used to search for function-prologue
  endings were improved, to cover more optimization (or
  lack-of-optimization, or incorrect-debuginfo) cases.  These
  heuristics are necessary to find $context parameters for some
  function-call/entry probes.  We recommend programs be built with
  CFLAGS+=-grecord-gcc-switches to feed information to the heuristics.

- The stap --use-server option now more correctly supports address:port
  type parametrization, for manual use in the absence of avahi.

- SystemTap now falls back on the symbol table for probing
  functions in processes if the debuginfo is not available.

- SystemTap now reports more accurate and succinct errors on type
  mismatches.

- The documentation for the SystemTap initscript service and the
  SystemTap compile-server service have been completely converted from
  README files to man pages (see systemtap(8) and stap-server(8)).

- Suggestions are now provided when markers could not be resolved. For
  example, process("stap").mark("benchmart") will suggest 'benchmark'.

- SystemTap colors can now be turned off by simply setting
  SYSTEMTAP_COLORS to be empty, rather than having to make it invalid.


= SystemTap script language changes

- SystemTap now supports a %( guru_mode == 0 /* or 1 */ %)
  conditional for making dual-use scripts.

- Embedded-C functions may use STAP_RETURN(value) instead of the
  more wordy STAP_RETVALUE assignment followed by a "goto out".
  The macro supports numeric or string values as appropriate.

- The [s]println() function can now be called without any arguments to
  simply print a newline.


= SystemTap runtime changes

- Fixed multiple potential kernel crashes by improving utrace and the
  taskfinder.

- SystemTap now supports backtracing through its own, invoking module.


= SystemTap tapset changes

  argv.stp              support both translate-time and runtime args
  arm64/registers.stp   provide register access on ARM64
  indent.stp            new indent_depth() and thread_indent_depth()
                        functions to track indentation level
  java.stp              new [s]print_java_backtrace() functions to
                        retrieve backtrace in Java probes
  aux_syscalls.stp      new _stp_syscall_nr() function to retrieve
                        syscall number
                        many _*_str() functions have been simplified in
                        the way they translate enum values to strings
  context.stp           better CONFIG_USER_NS support
  nfsd.stp              ditto
  task.stp              ditto + new task_rlimit() function to retrieve
                        resource limits on a specific task
  ioblock.stp           better support for different kernels using
                        @choose_defined()
  ip.stp                ditto
  loadavg.stp           new tapset to retrieve and print load averages
                        in the usual 1-, 5-, and 15-minute span
  rlimit.stp            new tapset with function rlimit_from_str() to
                        retrieve the resource limit code from its string
  scsi.stp              probe scsi.iodone can alias to either a
                        tracepoint or module function
  signal.stp            tolerate NULL from pid2task() when retrieving
                        pid_name
  syscalls.stpm         new macros to help sys
  task_ancestry.stp     new task_ancestry() function to print the
                        parentage of a process
  task_time.stp         new task_start_time() retrieves the start time
                        of a specific task
                        new nsecs_to_string() to convert nanoseconds to
                        human-readable string
  pn.stp                new pnlabel() function to retrieve the name of
                        the fired label in a label probe
  uconversions.stp      new user_ulong() and user_ulong_warn() to
                        retrieve an unsigned long from user-space
  [nd_]syscalls[2].stp  split syscall.fork into syscall.fork,
                        syscall.vfork, and syscall.clone
                        better support for s390x
                        support for preadv/pwritev syscalls

- The types of the parameters in many syscall probe aliases are now more
  accurate (located in [nd_]syscalls[2].stp)

- The argv tapset now merges translate-time and run-time positional
  arguments, so all of these work:

  stap -e 'probe oneshot {println(argv[1]," ",argv[2])}' hello world

  stap -e 'probe oneshot {println(argv[1]," ",argv[2])}' \
       -G argv_1=hello -G argv_2=world

  staprun hello.ko argv_1=hello argv_2=world

- A new probe alias "oneshot" allows a single quick script fragment to run,
  then exit.

- Some struct-sockaddr fields are now individually decoded for
  socket-related syscalls:
  probe syscall.connect { println (uaddr_af, ":", uaddr_ip) }

- The kprocess.exec probe has been updated to use syscall.execve, which
  allows access to the new process' arguments (through the new 'argstr'
  or 'args' variables) as well as giving better support across kernel
  versions. Note also that the 'filename' variable now holds the
  filename (quoted), or the address (unquoted) if it couldn't be
  retrieved.

- The following tapset variables and functions are now deprecated:
  - The 'clone_flags', 'stack_start', 'stack_size',
    'parent_tid_uaddr', and 'child_tid_uaddr' variables in the
    'syscall.fork' and 'nd_syscall.fork' probe aliases. 
  - The '_sendflags_str()' and '_recvflags_str()' functions have been
    deprecated in favor of the new '_msg_flags_str()' function.
  - The 'flags' and 'flags_str' variables in the 'syscall.accept' and
    'nd_syscall.accept' probe alias.


= SystemTap sample scripts

- New samples:

  python2.stp              tapset example for python2
  python3.stp              tapset example for python3
  pyexample.stp            uses python tapset to print backtraces and
                           variable values
  connect_stat.stp         prints a task's ancestry whenever it attempts
                           to connect() to an IP address
  nfsd-recent.stp          tracks all nfsd server operations and reports
                           clients who made recent requests
  procmod_watcher.stp      monitors all calls to fork(), exec(), exit(),
                           init_module(), and delete_module() and prints
                           their info
  pstree.stp               generates a process diagram in DOT form (e.g.
                           can be useful to monitor a 'make' command)
  rlimit_nofile.stp        watches for processes that fail to allocate a
                           file descriptor
  2048.stp                 play the classic game like never before, all
                           in kernel space!

- Changed samples:

  interrupts-by-dev.stp    print column headers once
  last_100_frees.stp       guard against 32-bit libc on 64 systems
  mutex-contention.stp     ditto
  pfiles.stp               support CONFIG_USER_NS
  schedtimes.stp           general cleanup and support for newer kernels


= Examples of tested kernel versions

  2.6.18 (RHEL5 x86)
  2.6.18 (RHEL5 x86_64)
  2.6.32 (RHEL6 x86)
  2.6.32 (RHEL6 x86_64)
  3.10.0 (RHEL7 x86_64)
  3.13.0 (Ubuntu 14.04 x86_64)
  3.13.9 (Fedora 19 x86_64)
  3.15-rc2 (Fedora Rawhide x86_64)


= Known issues with this release

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards (PR2725). Issues have also been
  reported with a possible relationship to the CONFIG_KPROBES_ON_FTRACE
  code (RHBZ1093152).

- 32-on-64 bit userspace unwinding is truncated on older kernels, such
  as 2.6.32 (PR15757)

- The dyninst backend is still very much a prototype, with a number
  of issues, limitations, and general teething woes. For instance:
  + lack of support for multiarch/cross-instrumentation
  + tapset functions are still incomplete relative to what is supported
    when the kernel backend is active
  + exception handling becomes completely broken in programs
    instrumented by the current version of dyninst (PR14702)
  + command line interrupts are slightly mishandled (PR15049)
  + not all registers are made available on 32-bit x86 (PR15136)

  See dyninst/README and the systemtap/dyninst Bugzilla component
  (http://tinyurl.com/stapdyn-PR-list) if you want all the gory
  details about the state of the feature.


= Contributors for this release

  Aaron Tomlin*, Brent Baude*, Dave Brolley, David Juran*, David Smith,
  Fahad Arshad*, Frank Ch. Eigler, Jonathan Lebon, Josh Stone, Lukas
  Berk, Mark Wielaard, Martin Cermak, Masatake YAMATO*, Miroslav Franc,
  Negreanu Marius Adrian, Peter Kjellström*, Quentin Barnes*, Robin
  Hack*, Stan Cox, Tomoki Sekiyama, Torsten Polle, Victor Kamensky*,
  William Cohen

  Special thanks to new contributors, marked with '*' above.
  Special thanks to Jonathan Lebon for compiling these notes.


= Bugs fixed for this release <http://sourceware.org/PR#####>

1133     support .callees probe pattern extension
2035     investigate boot-time probing
5154     aux_syscalls lookup tables needlessly included
6941     better prologue heuristics needed for userspace (non-regparm)
10208    Support probing glibc synthesized syscall wrappers
10300    Provide more macros for embedded-C functions
11113    utrace changes in 2.6.32 kernel cause task_finder.c/itrace.c compile errors
13420    prologue detection fails for function parameters in unoptimized (-g only, no -O) code
14223    perf probes fail if not root
14436    warn about use of $vars (e.g. in return probes) with unoptimized object code with poor VTA
15219    syscall.exp failures on RHEL5, RHEL6, and rawhide
15781    improve pass-2 function suggestions
15807    need more serious workload program for examples vice -c sleep 0.2
15907    listing probe lines gives odd results
15999    symbol-table-based fallback for foo.function() should resolve $$vars etc.
16097    improve error message on array type mismatch
16129    intermittent RCU/sleep warnings from perf probes / utrace_death handlers
16132    staprun/stapio confused by presence of traceN files
16162    plt addresses are incorrect for prelinked libraries
16165    @perf operator in error msgs is corrupted
16166    stap -vvv causes SIGSEGV when using @perf operator
16175    on ppc64, getting mmap syscall and nd_syscall testsuite failures
16176    on ia32, the trunc nd_syscall.exp subtest fails
16184    The rt_sigprocmask syscall subtest fails
16187    the 'sendfile' syscall.exp/nd_syscall.exp test fails
16207    on rawhide, we're getting more syscall.exp failures
16247    Some examples don't work on RHEL5
16248    pfiles example fails to build on RHEL7
16276    resource limits interfering with buildrun.cxx make -j
16278    orphaned stapsh goes to 100% CPU after stap closing
16307    ubuntu 12.04 /bin/kill no likey new kill -SIG -- -[exp_pid]
16309    SELinux prevents stap-serverd from opening the current dir when spawning processes
16311    need to add pwritev() syscall support to the syscall/nd_syscall tapsets
16312    need to add preadv() syscall support to the syscall/nd_syscall tapsets
16319    on sysvinit systems, virtio-serial port hotplugging fails
16326    client.exp and local stap-server interactions
16342    stap --list-servers lists spurious line when having two stap-serverd instances
16378    in-kernel utrace problem with 2.6.32: implicit declaration of function 'do_each_thread' in task_finder.c
16406    pass-5 build-id mismatch when -c cmd has same name as module
16448    adapt stap-prep for el7
16460    on ia64, the syscall.unlink probe alias has compile errors
16471    the server_concurrency.exp testcase has problems
16472    long chain of nested function calls consumes a lot of empty whitespace due to thread_indent() function
16473    rlimit.exp: adjust for weak symbols
16476    netfilter API changed for linux 3.13
16478    stap -l process.function.label listing not just labels
16514    String comparation doesn't work in kprocess.exec probe.
16540    the scsi tapset could use the scsi tracepoints
16541    nfsd tapset has errors
16542    the rpc tapset has errors
16555    on rawhide, we're getting errors in the task.stp tapset
16557    on RHEL5, the vm.mmap probe alias needs help
16570    the syscall.exp and nd_syscall.exp testcases take too long
16580    syscall.socket and syscall.socketpair should decode the 'protocol' argument
16603    time loss-of-synchrony on fluctuating-cpufreq unsynchronized-tsc boxes
16615    don't require access to dwarf_query in has_single_line_record()
16616    the 'servername' convenience variable returned by the rpc tapset can be NULL
16633    odd 'stap -L' behavior
16636    pwritev/preadv syscall testsuite bug on RHEL5
16659    On kernels >= 3.13, the __ip_sock_daddr() tapset function no longer compiles
16660    On kernels >= 3.14, the ioblock.request 'sector' variable is broken
16665    [PATCH] - DRAFT - Add new functions for resource limits investigation of task_struct.
16666    Symtab functionality needs a strip -g testcase
16667    need to add clone() syscall support to the syscall/nd_syscall tapsets
16676    Inconsistently-biased addresses for ET_EXEC
16697    inode-uprobes cleanup race
16718    kernel crash in  _stp_copy_from_user()
16719    systemtap runs hold vmlinux file descriptor open
16725    stap should warn when system wide process probes are used with --runtime=dyninst
16726    RFE: provide a way to retrieve tapset function types
16730    stap -L '**' displays non-public probe points
16766    possible kernel crash after failed initialization & flight-recorder mode
16806    kernel crash during repeated module insertion
16829    Trigger STAPBM_VERBOSE=true automatically when -v's are specified with java probes
16884    [nd_]syscall.shmctl and [nd_]syscall.compat_shmctl provide different variables
