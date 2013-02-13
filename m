Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156Ab3BMS74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:59:56 -0500
Received: from nat-pool-14-rdu.redhat.com ([66.187.233.208]:23716 "EHLO
	voip-10-15-18-81.yyz.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756988Ab3BMS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:59:54 -0500
X-Greylist: delayed 1410 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 13:59:54 EST
From: Serguei Makarov <smakarov@voip-10-15-18-81.yyz.redhat.com>
Message-Id: <201302131859.r1DIxghE012777@voip-10-15-18-81.yyz.redhat.com>
Date: Wed, 13 Feb 2013 13:59:42 -0500
To: systemtap@sourceware.org
Subject: systemtap release 2.1
Cc: lwn@lwn.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The systemtap team announces release 2.1!

perf event probe improvements, dyninst backend improvements,
error:: and warning:: man pages, bundled emacs/vim editor modes,
customizable aggregate array sorting, optional time limit suppression,
experimental compiled regex support


= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-2.1.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-2.1 (commit addec81)

  There have been over 400 commits since the last release.
  There have been over 40 bugs/features fixed since the last release.


= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree
  Further information at http://sourceware.org/systemtap/wiki/


= Systemtap frontend (stap) changes

- EMACS and VIM editor modes for systemtap source files are included / updated.

- The translator now eliminates duplicate tapset files between its
  preferred directory (as configured during the build with --prefix=/
  or specified with the -I /path option), and files it may find under
  $XDG_DATA_DIRS.  This should eliminate a class of conflicts between
  parallel system- and hand-built systemtap installations.

- The translator accepts a --suppress-time-limits option, which defeats
  time-related constraints, to allows probe handlers to run for indefinite
  periods.  It requires the guru mode (-g) flag to work.  Add the earlier
  --suppress-handler-errors flag for a gung-ho "just-keep-going" attitude.

- Some error messages and warnings now refer to additional information
  that is found in man pages.  These are generally named
  error::FOO or warning::BAR (in the 7stap man page section)
  and may be read via
     % man error::FOO
     % man warning::BAR


= Systemtap script language changes

- Perf event probes may now be read on demand. The counter probe is
  defined using the counter-name part: 
  probe perf.type(0).config(0).counter("NAME").  The counter is
  read in a user space probe using @perf("NAME"), e.g.
   process("PROCESS").statement("func@file") {stat <<< @perf("NAME")} 

- Perf event probes may now be bound to a specific task using the
  process-name part:  probe perf.type(0).config(0).process("NAME") { }
  If the probed process name is not specified, then it is inferred
  from the -c CMD argument.  

- The foreach looping construct can now sort aggregate arrays by the user's
  choice of aggregating function.  Previously, @count was implied.  e.g.:
     foreach ([x,y] in array @sum +) { println(@sum(array[x,y])) } 

- Proof of concept support for regular expression matching has been added:
     if ("aqqqqqb" =~ "q*b") { ... }
     if ("abc" !~ "q*b") { ... }

  The eventual aim is to support roughly the same functionality as
  the POSIX Extended Regular Expressions implemented by glibc.
  Currently missing features include extraction of the matched string
  and subexpressions, and named character classes ([:alpha:], [:digit:], &c).

  Special thanks go to the re2c project, whose public domain code this
  functionality has been based on. For more info on re2c, see:
     http://sourceforge.net/projects/re2c/


= Systemtap runtime changes

- The dyninst backend has improved in several aspects:
  - The runtime now allows much more concurrency when probing multithreaded
    processes, and will also follow probes across forks.
  - Several new probe types are now supported, including timers, function
    return, and process.begin/end and process.thread.begin/end.
  - Semaphores for SDT probes are now set properly.
  - Attaching to existing processes with -x PID now works.


= Systemtap tapset changes

- New tapsets:
  choose_defined.stpm  add @choose_defined() macro

- Added/changed tapsets for dyninst:
  ctime.stp            ctime() returns "<invalid time>" when an error occurs
  context.stp          add support for print_regs()

- Changed tapsets:
  nfs_proc.stp         account for separate nfsv2/3/4 kernel modules
  context.stp          add ppfunc() to parse the function name from pp()
  netfilter.stp        fix error in decoding of ar_tha and ar_tpa fields
    
- The folowing tapset variables are deprecated in release 2.1 and may
  be removed in a future version:
  - The 'send2queue' variable in the 'signal.send' probe.
  - The 'oldset_addr' and 'regs' variables in the 'signal.handle' probe.

- The following tapset probes are deprecated in release 2.1 and may
  be removed in a future version:
  - signal.send.return
  - signal.handle.return


= Systemtap sample scripts

- Tracing examples were updated to use ppfunc() instead of probefunc().

- New samples:
  perf.stp              use perf.counter to access performance counters
  regex.stp             report opened files whose names match a given regex
  threadstacks.stp      override default new-pthread stack sizes
  mutex_contention.stp  pthread mutex contention analysis
  ltrace.stp            uprobes-based ltrace demo
  block.stp             stapgames Breakout demo using input/output devices
  eater.stp             stapgames Snake demo using input/output devices
  lifegame.stp          stapgames Game of Life demo using input/output devices
  pingpong.stp          stapgames Pong demo using input/output devices

- Changed samples:
  deviceseeks.stp   switch to using ioblock_trace.request probe point


= Examples of tested kernel versions

3.8.0-rc (x86_64)
3.7.0 (x86_64, i686)
3.6.2 (x86_64)
3.4.0 (armv7l)
2.6.32 (x86_64, i686, ppc64, s390x)
2.6.18 (x86_64, i686, ia64)
2.6.9 (i686, ppc64)


= Known issues with this release

- The regular expression support is still experimental and incomplete; in particular:
  + Support for named character classes is missing. (PR15064)
  + Support for extracting matched strings and substrings is missing. (PR15065)

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.  (PR2725)

- The dyninst backend is still a work in progress. Current issues:
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

Alexander Lochmann, Daniel Tschan*, Dave Brolley, David Smith,
Frank Ch. Eigler, Jiri Horky*, Josh Stone, Jóhann B. Guðmundsson*,
Lukas Berk, Lukáš Hejtmánek*, Mark Wielaard, Masami Hiramatsu,
Nathan Scott, Rich Megginson*, Rüdiger Sonderfeld*, Serguei Makarov,
Stan Cox, Tom Tromey, Tomoki Sekiyama*, William Cohen

Special thanks to new contributors, marked with '*' above.
Special thanks to the authors of the re2c project (http://re2c.sourceforge.net).


= Bugs fixed for this release <http://sourceware.org/PR#####>

 1887  write emacs/vim editor mode for script language
 6697  need more access_ok() checks in runtime/tapsets
11334  regular expression string matching
11576  per-process perf events
11955  signal tapsets don't match 
12022  Allow foreach to order iterations for aggregates on @min @max and @avg operators
12231  reading perfctr events
12443  XDG_DATA_DIRS conflict between preinstalled and hand-built stap
12642  utrace: taskfinder misses events when main thread does not go through at least one quiesce
13022  probe module("*").function("*") does not work on arm
14178  Add a pure-userspace runtime mode
14245  Support debugfs mounted 0700
14390  separate process.**.return tests and mark UNSUPPORTED 
14555  tolerate /proc/sys/kernel/kptr_restrict=2
14571  Make stapdyn multithreaded
14659  task_finder2 breaks ptrace apps
14701  stapdyn needs timer probe support
14705  stapdyn needs to set SDT semaphores
14707  Support stapdyn -x PID
14709  Support process.function.return in stapdyn
14712  VM_EXECUTABLE went to heaven
14714  stap flag for bigger --suppress-handler-errors hammer
14731  regression in buildok/thirty.stp
14735  stapdyn needs timing ('-t') support
14742  more complete dwz / DW_TAG_partial_unit support
14774  process.statement("*@file:*") probes don't match all functions
14781  kmem_cache conflict leads to panic & badness
14794  autoconf auto-enable dyninst if possible
14795  add stapgames
14804  Kernel panic when running hello world stap script
14820  hang when running semok/nodwf01.stp
14842  Old "-kelf" and "--ignore-dwarf" command line options should be removed
14883  let probefunc() not fail - or fail more informatively, on non-uprobes kernels
14900  collision between tapset locals and user globals: contexts
14929  staperrors man page
14949  cannot use systemtap on linux 3.7 intel x86_64
14957  foreach_aggrsort.exp test hangs on i686 rhel5 system
14997  DW_OP_rot mistranslation
15031  stapdyn needs a _stp_print_binary() runtime function
15059  session.print_error called frequently from listing_mode
15074  pthread_stacks.exp problems
15080  The kernel function 'signal_wake_up' is gone
15087  netfilter.arp tapset probes duplicate source/target addresses 
15101  [PATCH] Stap sefaults when calling NSS_shutdown() which was not previously initialized
15112  Can't connect to stap-server via IPv6 raw hex addresses
15123  workaround for bad debuginfo for -mfentry
