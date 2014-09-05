Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaIEVwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:52:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbaIEVwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:52:12 -0400
Message-Id: <201409052152.s85Lq41a018278@int-mx09.intmail.prod.int.phx2.redhat.com>
From: "Josh Stone" <jistone@redhat.com>
Date: Fri, 05 Sep 2014 14:52:04 -0700
To: systemtap@sourceware.org
Subject: SystemTap 2.6 release
Cc: linux-kernel@vger.kernel.org, lwn@lwn.net
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SystemTap team announces release 2.6, "My god. It's full of probes!"

  DWARF type support for integer expressions, on-the-fly probe
  arming/disarming, support for multiple scripts, DWARF process(PID)
  probes, PLT return probes, .nearest probes, .statement lineno ranges
  and enumerations, improved listing mode


= Where to get it

  https://sourceware.org/systemtap/ - our project page
  https://sourceware.org/systemtap/ftp/releases/systemtap-2.6.tar.gz
  https://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-2.6 (commit 7682e51d2e11)

  There have been over 465 commits since the last release.
  There have been over 47 bugs fixed / features added since the last
  release.


= How to build it

  See the README and NEWS files at
  https://sourceware.org/git/?p=systemtap.git;a=tree

  Further information at https://sourceware.org/systemtap/wiki/


= SystemTap frontend (stap) changes

- SystemTap now accepts additional scripts through the new -E SCRIPT
  option.  There still needs to be a main script specified through -e or
  file in order to provide an additional script. This makes it feasible
  to have scripts in the $HOME/.systemtap/rc file.  For example:

  -E 'probe begin, end, error { log("systemtap script " . pn()) }'
  -E 'probe timer.s(30) { error ("timeout") }

  The -E SCRIPT option can also be used in listing mode (-l/-L), such
  that probe points for the additional scripts will not be listed, but
  other parts of the script are still available, such as macros or
  aliases.

- DWARF process probes can now be bound to a specific process using the
  form:

  process(PID).function("*")

- process("PATH").library("PATH").plt("NAME").return probes are now
  supported.

- SystemTap now asserts that the PID provided for a process probe
  corresponds to a running process.

- While in listing mode (-l/-L), probes printed are now more consistent
  and precise.

- Statement probes now support enumerated linenos to probe discontiguous
  linenos using the form:

  process.statement("foo@file.c:3,5-7,9")

- statement("*@file:NNN").nearest probes are now available to let
  SystemTap translate the probe to the nearest probe-able line to the
  given one if necessary.


= SystemTap script language changes

- Integer expressions which are derived from DWARF values, like context
  $vars, @cast, and @var, will now carry that type information into
  subsequent reads. Such expressions can now use "->" and "[]"
  operators, as can local variables which were assigned such values.
  Example usage:

  foo = $param->foo; printf("x:%d y:%d\n", foo->x, foo->y)
  printf("my value is %d\n", ($type == 42 ? $foo : $bar)->value)
  printf("my parent pid is %d\n", task_parent(task_current())->tgid)

- SystemTap now supports array slicing within foreach loop conditions,
  delete statements and membership tests. Wildcards are represented by
  "*". Examples of the expressions are:

  foreach ([a,b,c] in val[*,2,*])
  delete val[*, 2, *]
  [*, 2, *] in val


= SystemTap runtime changes

- SystemTap now supports on-the-fly arming/disarming of certain probe
  types: kprobes, uprobes, and timer.*s(NUM) probes. For example, this
  probe

  probe kernel.function("vfs_read") if (i > 4) { ... }

  will automatically register/unregister the associated kprobe on
  vfs_read whenever the value of the condition changes (as some probe
  handler modifies 'i').  This allows us to avoid probe overhead when
  we're not interested.  If the arming capability is not
  relevant/useful, nest the condition in the normal probe handler:

  probe kernel.function("vfs_read") { if (i > 4) { ... } }

- Statement counting is now suppressed in the generated c code for
  probes that are non-recursive and loop-free. Statement counting can be
  turned back on in unoptimize mode (-u).

- SystemTap now supports SDT probes with operands that refer to symbols.


= SystemTap tapset changes

  init.stp              new tapset with an 'init' probe alias which
                        triggers as early as possible at runtime
  ia64/registers.stp    support for ia64 dwarfless register access
  linux/context.stp     support for kernels without CONFIG_USER_NS
  linux/conversions.stp new kernel_string_quoted() function analogous to
                        user_string_quoted()
  linux/dentry.stp      fix possible infinite loop in task_dentry_path()
  linux/nfsd.stp        fix build errors on 32-bit platforms
  linux/syscalls.stp    use kernel_string_quoted() in execve syscall for
                        consistency
  linux/nd_syscalls.stp ditto

  container_of.stpm     new macros container_of() and
                        module_container_of() to retrieve the structure
                        containing a particular element
  offsetof.stpm         new macros offsetof() and module_offset_of() to
                        retrieve the offset of a member in a struct
  type_defined.stpm     new macros type_defined(),
                        type_member_defined(), module_type_defined(),
                        module_type_member_defined() to check if a
                        type/member is defined

- Many of the arrays which were previously initialized in a begin(-1)
  probe now use the new init probe alias instead.

- More work was done to improve the types of the parameters in many
  syscall probe aliases ([nd_|aux_]syscalls[2].stp).

- Many tapsets were simplified by using the new autocast feature.


= SystemTap sample scripts

- Changed samples:

  eventcount.stp           more sorting options
  inodewatch.stp           use ppfunc() rather than probefunc()
  inodewatch2.stp          ditto
  traceio2.stp             ditto
  mutex-contention.stp     ditto
  fntimes.stp              ditto
  functioncallcount.stp    ditto
  autofs4.stp              use new .nearest probe
  perf.stp                 ditto
  ltrace.stp               add perf.return functionality using new plt
                           return probe
  syscalls_by_pid.stp      use nd_syscall instead of syscall
  syscalls_by_proc.stp     ditto
  latencytap.stp           more explanations added and code refactored


= Examples of tested kernel versions

  2.6.9 (RHEL 4 x86)
  2.6.18 (RHEL 5 x86 and x86_64)
  2.6.32 (RHEL 6 x86 and x86_64)
  3.10.0 (RHEL 7 x86_64)
  3.15.10 (Fedora 20 x86_64)


= Known issues with this release

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.  (PR2725)

- 32-on-64 bit userspace unwinding is truncated on older kernels, such
  as 2.6.32 (PR15757)

- The dyninst backend is still very much a prototype, with a number
  of issues, limitations, and general teething woes. For instance:
  + lack of support for multiarch/cross-instrumentation
  + tapset functions are still incomplete relative to what is supported
    when the kernel backend is active
  + exception handling becomes completely broken in programs
    instrumented by the current version of dyninst (PR14702)
  + not all registers are made available on 32-bit x86 (PR15136)

  See dyninst/README and the systemtap/dyninst Bugzilla component
  (http://tinyurl.com/stapdyn-PR-list) if you want all the gory
  details about the state of the feature.


= Contributors for this release

  Abegail Jakop*, Brian Chrisman*, David Smith, Frank Ch. Eigler,
  Honggyu Kim*, Jonathan Lebon, Josh Stone, Lukas Berk, Mark Wielaard,
  Martin Cermak, Stan Cox, Stefan Hajnoczi*, Tetsuo Handa*, William Cohen,
  Yaakov Selkowitz*

  Special thanks to new contributors, marked with '*' above.
  Special thanks to Jonathan and Abegail for compiling these notes.


= Bugs fixed for this release <https://sourceware.org/PR#####>

6897  stap should assert valid PIDs for process(PID) probes
6971  nd_syscalls.stp tapset broken on ia64
10603 Probing *@srcfile:line yields strange results
10995 on-the-fly enabled/disabled probes
12333 array slice operations
13296 inaccessible sdt.h operands of the form   symbol(%reg)
14509 Reshuffled chain error messages are misleading for DWARF-search-failures
14737 plt.return probes
14825 dtrace .d parser can't handle compact input
15049 stapdyn mishandling interrupts
15942 support abbreviated process.* probes with stap -x PID
16300 suppress statement-counting protections in loop-free non-recursive probe handlers
16443 typos in the beginners guide
16844 Adapt to tracepoint API changes in 3.15
16861 probes aren't re-registered after module reload
16894 SIGSEGV upon using stap -c commands with ||, &&, etc...
16913 systemtap-testsuite.aarch64 requires prelink
16914 probe syscall.* fails with compilation error
16941 fix listing mode inconsistencies
16951 dtrace regression
16955 blacklisting requires better feedback
16956 nd_syscall.* tapset shouldn't rely on @cast() against kernel debuginfo
16960 today's fresh bits do not work correctly on RHEL6
16991 infinite loop in task_dentry_path
17027 pr16806.exp fails on RHEL6 like systems
17041 cast-scope.exp fails on s390x
17052 race between _stp_ctl_work_callback and _stp_runtime_contexts_free
17073 SystemTap doesn't support module given by full path
17101 [rfe] timeout for stap
17120 tcl testsuite error in gtod.exp/prcwildcard.exp
17121 tcl testsuite error in listing_mode.exp
17127 systemtap sometimes fails to hook targets on busy systems
17131 process(PID).{function, plt, mark} does not limit probe to specified process
17155 systemtap.examples/profiling/functioncallcount.stp failures on x86_64
17178 syscall/nd_syscall test failures on f20
17181 systemtap has problems attaching to resumed processes
17182 sdt_misc V3_uprobe --types failure
17191 upstream head systemtap doesn't build on el6 (license issue)
17216 perf.hw counters misbehaviour
17232 runtime control message race condition: STP_EXIT while STP_STARTing
17242 tapsets should avoid delayed-init globals
17249 module-init functions crashable & not probeable past 3.8
17260 stp_print_flush reentrancy deadlock
17274 procfs_write.exp, the beaker killer
17275 on s390x, buildok/memory-all-probes.stp fails
17301 optim_arridx.exp affected by testsuite's timeout feature
17333 userspace probing by pid broken
