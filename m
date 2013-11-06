Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3KFQ5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:57:38 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:47762 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3KFQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:57:36 -0500
Date: Wed, 6 Nov 2013 11:57:24 -0500 (EST)
From: Jonathan Lebon <jlebon@redhat.com>
To: systemtap@sourceware.org
Cc: linux-kernel@vger.kernel.org, lwn@lwn.net
Message-ID: <2076699967.18511745.1383757044595.JavaMail.root@redhat.com>
In-Reply-To: <1199920528.18511347.1383756982722.JavaMail.root@redhat.com>
Subject: SystemTap 2.4 release
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF25 (Linux)/8.0.3_GA_5664)
Thread-Topic: SystemTap 2.4 release
Thread-Index: 50mNu6p2Th7LCr950Ltoyxjtr2cEfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SystemTap team announces release 2.4, "virtual world"!

  smarter error reporting, better suggestions, virtual machine probing,
  .gnu_debugdata support, improved memory allocation, and more!


= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-2.4.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-2.4 (commit aa7b1e0)

  There have been over 247 commits since the last release.
  There have been over 35 bugs fixed / features added since the last
  release.


= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree

  Further information at http://sourceware.org/systemtap/wiki/


= SystemTap frontend (stap) changes

- Better suggestions are given in many of the semantic errors in which
  alternatives are provided. Additionally, suggestions are now provided
  when plt and trace probes could not be resolved. For example,
  kernel.trace("sched_siwtch") will suggest 'sched_switch'.

- SystemTap is now smarter about error reporting. Errors from the same
  source are considered duplicates and suppressed. A message is
  displayed on exit if any errors/warnings were suppressed.

- SystemTap now supports probing inside virtual machines using the
  libvirt and unix schemes, e.g.

      stap -ve 'probe timer.s(1) { printf("hello!\n") }' \
         --remote=libvirt://MyVirtualMachine

  Virtual machines managed by libvirt can be prepared using stapvirt.
  See stapvirt(1) and the --remote option in stap(1) for more details.

- SystemTap now checks for and uses (when available) the .gnu_debugdata
  section which contains a subset of debuginfo, useful for backtraces
  and function probing


= SystemTap script language changes

- For systems with in-kernel utrace, 'process.end' and 'thread.end'
  probes will hit before the target's parent process is notified of the
  target's death. This matches the behavior of newer kernels without
  in-kernel utrace.


= SystemTap runtime changes

- The stap-server client & server code now enable all SSL/TLS ciphers
  rather than just the "export" subset.

- Statistics aggregate typed objects are now implemented locklessly, if
  the translator finds that they are only ever read (using the foreach /
  @count / etc. constructs) in a probe-begin/end/error.

- SystemTap map variables are now allocated with vmalloc() instead of
  with kmalloc(), which should cause memory to be less fragmented.

- Although SystemTap itself requires elfutils 0.148+, staprun only
  requires elfutils 0.142+, which could be useful with the
  '--disable-translator' configure switch.

- Under FIPS mode (/proc/sys/crypto/fips_enabled=1), staprun will refuse
  to load SystemTap modules (since these are not normally signed with
  the kernel's build-time keys).  This protection may be suppressed with
  the $STAP_FIPS_OVERRIDE environment variable.


= SystemTap tapset changes

  macros.stpm              new '@MAXSTRINGLEN' macro
  context-caller.stp       use the new '@MAXSTRINGLEN' macro instead of
                           %{ MAXSTRINGLEN %} to avoid problens for
                           unprivileged users
  context-symbols.stp      ditto
  ucontext-symbols.stp     ditto
  ucontext.stp             ditto
  uconversions.stp         ditto and new function
                           user_string_n2_quoted()
  context.stp              fix cmdline_arg() processing
  dentry.stp               new inode_path() function which tries to
                           locate the vfsmount containing an inode
  nd_syscalls.stp          (1) fix syscall.{execve,compat_execve} for
                           older kernels
                           (2) break the 'mmap2' probe alias down into
                           subprobes to better convert 'pgoff'
  syscalls.stp             (1) & (2) as above and
                           (3) fix syscall.accept probe alias
                           optionality
  memory.stp               correct VM_FAULT_MINOR conditional handling
                           and protect __pa() call with
                           virt_addr_valid()
  nfs_proc.stp             update probes to handle removal of NFSv2
  signal.stp               update signal.pending[.return] probe aliases
  registers.stp            on s390, new _stp_get_kernel_stack_param()
                           function to get stack parameters
  aux_syscalls.stp         decode SIGTRAP|0x80 from
                           PTRACE_O_TRACESYSGOOD

- Several syscall tapsets which read user buffers of known length will
  now use user_string_n2_quoted rather than user_string_n_quoted().

- The syscall/nd_syscall tapsets had multiple probes split into
  subprobes to avoid using symname(addr()).

- The s390 syscalls.stp tapset had multiple probes updated to handle
  newer kernels with renamed parameters.


= SystemTap sample scripts

- New samples:

  last_100_frees.stp             log recent free(3) libc calls along
                                 with a userspace backtrace at those
                                 moments
  futexes2.stp                   watches just shared futex syscalls on
                                 the system and prints contention info
                                 on exit
  semop-watch.stp                prints a timed trace of
                                 semop(2)/semtimedop(2) syscalls
  strace.stp                     loosely emulates strace, can be applied
                                 to individual processes (via -c/-x) or
                                 entire system

- Changed samples:

  badname.stp                    update for newer kernels
  eventcount.stp                 add -G lines=NNN option
  tcpdumplike.stp                demonstrates recently added UDP tapset
                                 by also printing out UDP packets
  deviceseeks.stp                handle older kernel's names for sector
                                 size field
  numa_faults.stp                update to tolerate exception now thrown
                                 by addr_to_node() tapset function
  threadstacks.stp               updated for glibc 2.17 changes
                                 regarding pthread stack allocation
  periodic.stp                   tweak to operate without kernel
                                 debuginfo

= Examples of tested kernel versions

  2.6.9 (x86)
  2.6.18 (x86)
  2.6.32 (x86)
  3.10.0 (x86_64)
  3.11.6 (x86_64)


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
  + command line interrupts are slightly mishandled (PR15049)
  + not all registers are made available on 32-bit x86 (PR15136)

  See dyninst/README and the systemtap/dyninst Bugzilla component
  (http://tinyurl.com/stapdyn-PR-list) if you want all the gory
  details about the state of the feature.


= Contributors for this release

  Dave Brolley, David Smith, Frank Ch. Eigler, Jonathan Lebon, Josh
  Stone, Lukas Berk, Mark Wielaard, Martin Cermak*, Masanari Iida,
  Miroslav Franc*, Naresh Kamboju*, Paddie O'Brien*, Serguei Makarov,
  Stan Cox, Timo Juhani Lindfors, Vincent Bernat*, William Cohen

  Special thanks to new contributors, marked with '*' above.
  Special thanks to Jonathan Lebon for compiling these notes.


= Bugs fixed for this release <http://sourceware.org/PR#####>

4331 	systemtap.stress/current.stp need to be updated for s390x
6764 	Execution of probefunc.exp causes system hang on s390 system
9822 	reduce timer load
10088 	on s390x, the translator gets an assertion
11751 	on s390x, externalvar.exp gets libdwfl failures
13078 	investigate qemu virtio-serial channel for talking to stap-sh
13974 	sdt.h is incompatible with clang
14960 	frame size too large for systemtap.examples/process/psig
15625 	unprivileged_embedded_C test confused by stub registers.stp
15663 	Failing to remove the stap kernel modules on kernel 3.9.4
15782 	nss usage bugs - PR_Read returning short results
15788 	tarballs should be PGP signed
15789 	ERROR: couldn't initialize gettimeofday
15793 	Kernel panic when running systemtap's test suite with kernel 3.10.1
15803 	systemtap 2.3 testsuite crashes linux 3.10 sometimes at netdev/enter_netfilter_probe_0
15805 	maps should not be allocated with k*alloc
15865 	nfs_proc.stp needs to be handle NFSv2 support being removed
15866 	on rawhide, the 'signal.pending' and 'signal.pending.return' probe aliases are broken
15872 	on rawhide, we're getting odd client.exp test failures
15874 	the systemtap.base/onoffprobe.exp testcase times out
15875 	the ptrace.exp testcase will fail if 'strace' isn't present on the system
15876 	The ptridx.exp testcase has timeout errors
15881 	unprivileged_myproc.exp test fails on rawhide
15900 	syntax errors in server_locale.exp
15906 	don't try to run modules in kernel-fips mode
15913 	on s390x, nd_syscall testsuite failures when accessing arguments 1 and 6
15928 	the memory1.exp testcase is accessing user memory as kernel memory
15937 	On arm fc19 unable to find $whence argment for kernel.function("sys_llseek").call
15961 	nd_syscall.exp failure on i686
15980 	uprobes MAXSKIPPED not overruled by --suppress-handler-errors
15982 	process.end probes broken on RHEL6
16019 	limit number of similar semantic errors output
16057 	task_dentry_path fails to cross mount points
16058 	syscall.mmap/nd_syscall.mmap probe alias problem
16096 	on i686, the nd_syscall tapset is broken 

