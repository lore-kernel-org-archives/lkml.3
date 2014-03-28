Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaC2PXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:23:23 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35193 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaC2PXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:23:21 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [RFC PATCH v2 00/29] ktap: A lightweight dynamic tracing tool for Linux
Date: Fri, 28 Mar 2014 10:44:55 -0400
Message-Id: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following set of patches add ktap tracing tool.

v2:
- move kernel module into kernel/trace/ktap/, reviewed by GregKH.
- move include ktap into include/uapi/ktap/
- Some minor cleanup on ktap.c, reviewed by Andi Kleen.

ktap is a new script-based dynamic tracing tool for Linux.
It uses a scripting language and lets the user trace system dynamically.

Highlights features:
* a simple but powerful scripting language
* register-based interpreter (heavily optimized) in Linux kernel
* small and lightweight
* not depend on the GCC toolchain for each script run
* easy to use in embedded environments without debugging info
* support for tracepoint, kprobe, uprobe, function trace, timer, and more
* supported in x86, ARM, PowerPC, MIPS
* safety in sandbox

Simple examples:
1). simplest one-liner command to enable all tracepoints
        ktap -e "trace *:* { print(argstr) }"

2). syscall tracing on target process
        ktap -e "trace syscalls:* { print(argstr) }" -- ls

3). simple syscall tracing
        ktap -e "trace syscalls:* { print(cpu, pid, execname, argstr) }"

4). ftrace
        ktap -e "trace ftrace:function /ip==mutex*/ { print(argstr) }"

5). syscall tracing in histogram style
        var s = {}

        trace syscalls:sys_enter_* {
                s[probename] += 1
        }

        trace_end {
                print_hist(s)
        }

6). kprobe tracing
        trace probe:do_sys_open dfd=%di fname=%dx flags=%cx mode=+4($stack) {
                print("entry:", execname, argstr)
        }

        trace probe:do_sys_open%return fd=$retval {
                print("exit:", execname, argstr)
        }

7). uprobe tracing
        trace probe:/lib/libc.so.6:malloc {
                print("entry:", execname, argstr)
        }

        trace probe:/lib/libc.so.6:malloc%return {
                print("exit:", execname, argstr)
        }

8). stapsdt tracing (userspace static marker)
        trace sdt:/lib64/libc.so.6:lll_futex_wake {
                print("lll_futex_wake", execname, argstr)
        }

        or:

        #trace all static mark in libc
        trace sdt:/lib64/libc.so.6:* {
                print(execname, argstr)
        }

9). timer
        tick-1ms {
                printf("time fired on one cpu\n");
        }

        profile-2s {
                printf("time fired on every cpu\n");
        }


This patchset contains:

1. README and Tutorial
2. ktap kernel module and userspace binary
3. sample scripts
4. test suite

The code can be pull from:
        http://github.com/ktap/linux.git upstream

The merit of putting this software in kernel tree is
to make it more possible to get feedback from users
and thus polish the code.

Thank you.

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>

Jovi Zhangwei (29):
  ktap: add tools/ktap/README.md file
  ktap: add ktap tutorial(tools/ktap/doc/tutorial.md)
  ktap: add sample scripts(tools/ktap/samples/*)
  ktap: add basic ktap types definition(include/uapi/ktap/ktap_types.h)
  ktap: add bytecode definition(include/uapi/ktap/ktap_bc.h)
  ktap: add ktap_arch.h and error header file(include/uapi/ktap/)
  ktap: add kernel module main entry(kernel/trace/ktap/ktap.[c|h])
  ktap: add bytecode reader(kernel/trace/ktap/kp_bcread.[c|h])
  ktap: add bytecode execution engine(kernel/trace/ktap/kp_vm.[c|h])
  ktap: add string handling
    code(kernel/trace/ktap/kp_[str|mempool].[c|h])
  ktap: add table handling code(kernel/trace/ktap/kp_tab.[c|h])
  ktap: add generic object handling code(kernel/trace/ktap/kp_obj.[c|h])
  ktap: add ring buffer handling
    code(kernel/trace/ktap/kp_transport.[c|h])
  ktap: add events management(kernel/trace/ktap/kp_events.[c|h])
  ktap: add built-in functions and library(kernel/trace/ktap/lib_*.c)
  ktap: add amalgamation build(kernel/trace/ktap/amalg.c)
  ktap: add Makefile for kernel module(kernel/trace/ktap/Makefile)
  ktap: add Kconfig(kernel/trace/ktap/Kconfig)
  ktap: add main file for ktap binary(tools/ktap/kp_main.c)
  ktap: add compiler(tools/ktap/kp_[lex|parse].[c|h])
  ktap: add symbol handling code(tools/ktap/symbol.[c|h])
  ktap: add events parse code(tools/ktap/kp_parse_events.c)
  ktap: add ring buffer reader(tools/ktap/kp_reader.c)
  ktap: add bytecode writer(tools/ktap/kp_bcwrite.c)
  ktap: add userspace util(tools/ktap/kp_util.c)
  ktap: add userspace binary Makefile(tools/ktap/Makefile)
  ktap: add testsuite and benchmark(tools/ktap/test/*)
  ktap: add vim syntax file(tools/ktap/vim/*)
  ktap: add COPYRIGHT file(tools/ktap/COPYRIGHT)

 include/uapi/ktap/ktap_arch.h                      |   33 +
 include/uapi/ktap/ktap_bc.h                        |  369 +++
 include/uapi/ktap/ktap_err.h                       |   11 +
 include/uapi/ktap/ktap_errmsg.h                    |  135 +
 include/uapi/ktap/ktap_types.h                     |  462 +++
 kernel/trace/ktap/Kconfig                          |   21 +
 kernel/trace/ktap/Makefile                         |   50 +
 kernel/trace/ktap/amalg.c                          |   37 +
 kernel/trace/ktap/kp_bcread.c                      |  429 +++
 kernel/trace/ktap/kp_bcread.h                      |    6 +
 kernel/trace/ktap/kp_events.c                      |  832 ++++++
 kernel/trace/ktap/kp_events.h                      |   71 +
 kernel/trace/ktap/kp_mempool.c                     |   94 +
 kernel/trace/ktap/kp_mempool.h                     |    8 +
 kernel/trace/ktap/kp_obj.c                         |  281 ++
 kernel/trace/ktap/kp_obj.h                         |   19 +
 kernel/trace/ktap/kp_str.c                         |  360 +++
 kernel/trace/ktap/kp_str.h                         |   13 +
 kernel/trace/ktap/kp_tab.c                         |  842 ++++++
 kernel/trace/ktap/kp_tab.h                         |   59 +
 kernel/trace/ktap/kp_transport.c                   |  649 ++++
 kernel/trace/ktap/kp_transport.h                   |   13 +
 kernel/trace/ktap/kp_vm.c                          | 1754 +++++++++++
 kernel/trace/ktap/kp_vm.h                          |   43 +
 kernel/trace/ktap/ktap.c                           |  255 ++
 kernel/trace/ktap/ktap.h                           |  176 ++
 kernel/trace/ktap/lib_ansi.c                       |  142 +
 kernel/trace/ktap/lib_base.c                       |  407 +++
 kernel/trace/ktap/lib_kdebug.c                     |  195 ++
 kernel/trace/ktap/lib_net.c                        |  107 +
 kernel/trace/ktap/lib_table.c                      |   58 +
 kernel/trace/ktap/lib_timer.c                      |  210 ++
 tools/ktap/COPYRIGHT                               |   63 +
 tools/ktap/Makefile                                |  130 +
 tools/ktap/README.md                               |  149 +
 tools/ktap/doc/tutorial.md                         |  666 +++++
 tools/ktap/kp_bcwrite.c                            |  375 +++
 tools/ktap/kp_lex.c                                |  552 ++++
 tools/ktap/kp_lex.h                                |   94 +
 tools/ktap/kp_main.c                               |  443 +++
 tools/ktap/kp_parse.c                              | 3139 ++++++++++++++++++++
 tools/ktap/kp_parse.h                              |    4 +
 tools/ktap/kp_parse_events.c                       |  798 +++++
 tools/ktap/kp_reader.c                             |  106 +
 tools/ktap/kp_symbol.c                             |  360 +++
 tools/ktap/kp_symbol.h                             |   50 +
 tools/ktap/kp_util.c                               |  646 ++++
 tools/ktap/kp_util.h                               |  120 +
 tools/ktap/samples/ansi/ansi_color_demo.kp         |   22 +
 tools/ktap/samples/basic/backtrace.kp              |    6 +
 tools/ktap/samples/basic/event_trigger.kp          |   27 +
 tools/ktap/samples/basic/event_trigger_ftrace.kp   |   27 +
 tools/ktap/samples/basic/ftrace.kp                 |    8 +
 tools/ktap/samples/basic/function_time.kp          |   62 +
 tools/ktap/samples/basic/kretprobe.kp              |    6 +
 tools/ktap/samples/basic/memcpy_memset.kp          |   23 +
 tools/ktap/samples/game/tetris.kp                  |  297 ++
 tools/ktap/samples/helloworld.kp                   |    3 +
 tools/ktap/samples/interrupt/hardirq_time.kp       |   25 +
 tools/ktap/samples/interrupt/softirq_time.kp       |   24 +
 tools/ktap/samples/io/kprobes-do-sys-open.kp       |   20 +
 tools/ktap/samples/io/traceio.kp                   |   61 +
 tools/ktap/samples/mem/kmalloc-stack.kp            |   12 +
 tools/ktap/samples/mem/kmem_count.kp               |   29 +
 tools/ktap/samples/network/tcp_ipaddr.kp           |   20 +
 tools/ktap/samples/profiling/function_profiler.kp  |   41 +
 .../profiling/kprobe_all_kernel_functions.kp       |   13 +
 tools/ktap/samples/profiling/stack_profile.kp      |   27 +
 tools/ktap/samples/schedule/sched_transition.kp    |    5 +
 tools/ktap/samples/schedule/schedtimes.kp          |  131 +
 tools/ktap/samples/syscalls/errinfo.kp             |  145 +
 tools/ktap/samples/syscalls/execve.kp              |    9 +
 tools/ktap/samples/syscalls/opensnoop.kp           |   31 +
 tools/ktap/samples/syscalls/sctop.kp               |   13 +
 tools/ktap/samples/syscalls/syscalls.kp            |    6 +
 tools/ktap/samples/syscalls/syscalls_count.kp      |   54 +
 .../samples/syscalls/syscalls_count_by_proc.kp     |   22 +
 tools/ktap/samples/syscalls/syslatl.kp             |   33 +
 tools/ktap/samples/syscalls/syslist.kp             |   31 +
 tools/ktap/samples/tracepoints/eventcount.kp       |  210 ++
 .../ktap/samples/tracepoints/eventcount_by_proc.kp |   57 +
 tools/ktap/samples/tracepoints/raw_tracepoint.kp   |   15 +
 tools/ktap/samples/tracepoints/tracepoints.kp      |    6 +
 tools/ktap/samples/userspace/gcc_unwind.kp         |    9 +
 tools/ktap/samples/userspace/glibc_func_hist.kp    |   44 +
 tools/ktap/samples/userspace/glibc_sdt.kp          |   11 +
 tools/ktap/samples/userspace/glibc_trace.kp        |   11 +
 tools/ktap/samples/userspace/malloc_free.kp        |   20 +
 tools/ktap/samples/userspace/malloc_size_hist.kp   |   22 +
 tools/ktap/samples/userspace/pthread.kp            |    8 +
 tools/ktap/test/README                             |   69 +
 tools/ktap/test/arithmetic.t                       |  109 +
 tools/ktap/test/benchmark/cmp_neq.sh               |  158 +
 tools/ktap/test/benchmark/cmp_profile.sh           |   54 +
 tools/ktap/test/benchmark/cmp_table.sh             |  112 +
 tools/ktap/test/benchmark/sembench.c               |  556 ++++
 tools/ktap/test/cli-arg.t                          |   25 +
 tools/ktap/test/concat.t                           |   21 +
 tools/ktap/test/count.t                            |   25 +
 tools/ktap/test/deadloop.t                         |   37 +
 tools/ktap/test/fibonacci.t                        |   42 +
 tools/ktap/test/function.t                         |   78 +
 tools/ktap/test/if.t                               |   32 +
 tools/ktap/test/kprobe.t                           |   82 +
 tools/ktap/test/kretprobe.t                        |   35 +
 tools/ktap/test/len.t                              |   27 +
 tools/ktap/test/lib/Test/ktap.pm                   |  128 +
 tools/ktap/test/looping.t                          |   46 +
 tools/ktap/test/one-liner.t                        |   48 +
 tools/ktap/test/pairs.t                            |   52 +
 tools/ktap/test/stack_overflow.t                   |   22 +
 tools/ktap/test/syntax-err.t                       |   19 +
 tools/ktap/test/table.t                            |   81 +
 tools/ktap/test/time.t                             |   59 +
 tools/ktap/test/timer.t                            |   65 +
 tools/ktap/test/tracepoint.t                       |   53 +
 tools/ktap/test/util/reindex                       |   61 +
 tools/ktap/test/zerodivide.t                       |   21 +
 tools/ktap/vim/ftdetect/ktap.vim                   |    3 +
 tools/ktap/vim/syntax/ktap.vim                     |  106 +
 120 files changed, 19708 insertions(+)
 create mode 100644 include/uapi/ktap/ktap_arch.h
 create mode 100644 include/uapi/ktap/ktap_bc.h
 create mode 100644 include/uapi/ktap/ktap_err.h
 create mode 100644 include/uapi/ktap/ktap_errmsg.h
 create mode 100644 include/uapi/ktap/ktap_types.h
 create mode 100644 kernel/trace/ktap/Kconfig
 create mode 100644 kernel/trace/ktap/Makefile
 create mode 100644 kernel/trace/ktap/amalg.c
 create mode 100644 kernel/trace/ktap/kp_bcread.c
 create mode 100644 kernel/trace/ktap/kp_bcread.h
 create mode 100644 kernel/trace/ktap/kp_events.c
 create mode 100644 kernel/trace/ktap/kp_events.h
 create mode 100644 kernel/trace/ktap/kp_mempool.c
 create mode 100644 kernel/trace/ktap/kp_mempool.h
 create mode 100644 kernel/trace/ktap/kp_obj.c
 create mode 100644 kernel/trace/ktap/kp_obj.h
 create mode 100644 kernel/trace/ktap/kp_str.c
 create mode 100644 kernel/trace/ktap/kp_str.h
 create mode 100644 kernel/trace/ktap/kp_tab.c
 create mode 100644 kernel/trace/ktap/kp_tab.h
 create mode 100644 kernel/trace/ktap/kp_transport.c
 create mode 100644 kernel/trace/ktap/kp_transport.h
 create mode 100644 kernel/trace/ktap/kp_vm.c
 create mode 100644 kernel/trace/ktap/kp_vm.h
 create mode 100644 kernel/trace/ktap/ktap.c
 create mode 100644 kernel/trace/ktap/ktap.h
 create mode 100644 kernel/trace/ktap/lib_ansi.c
 create mode 100644 kernel/trace/ktap/lib_base.c
 create mode 100644 kernel/trace/ktap/lib_kdebug.c
 create mode 100644 kernel/trace/ktap/lib_net.c
 create mode 100644 kernel/trace/ktap/lib_table.c
 create mode 100644 kernel/trace/ktap/lib_timer.c
 create mode 100644 tools/ktap/COPYRIGHT
 create mode 100644 tools/ktap/Makefile
 create mode 100644 tools/ktap/README.md
 create mode 100644 tools/ktap/doc/tutorial.md
 create mode 100644 tools/ktap/kp_bcwrite.c
 create mode 100644 tools/ktap/kp_lex.c
 create mode 100644 tools/ktap/kp_lex.h
 create mode 100644 tools/ktap/kp_main.c
 create mode 100644 tools/ktap/kp_parse.c
 create mode 100644 tools/ktap/kp_parse.h
 create mode 100644 tools/ktap/kp_parse_events.c
 create mode 100644 tools/ktap/kp_reader.c
 create mode 100644 tools/ktap/kp_symbol.c
 create mode 100644 tools/ktap/kp_symbol.h
 create mode 100644 tools/ktap/kp_util.c
 create mode 100644 tools/ktap/kp_util.h
 create mode 100644 tools/ktap/samples/ansi/ansi_color_demo.kp
 create mode 100644 tools/ktap/samples/basic/backtrace.kp
 create mode 100644 tools/ktap/samples/basic/event_trigger.kp
 create mode 100644 tools/ktap/samples/basic/event_trigger_ftrace.kp
 create mode 100644 tools/ktap/samples/basic/ftrace.kp
 create mode 100644 tools/ktap/samples/basic/function_time.kp
 create mode 100644 tools/ktap/samples/basic/kretprobe.kp
 create mode 100644 tools/ktap/samples/basic/memcpy_memset.kp
 create mode 100644 tools/ktap/samples/game/tetris.kp
 create mode 100644 tools/ktap/samples/helloworld.kp
 create mode 100644 tools/ktap/samples/interrupt/hardirq_time.kp
 create mode 100644 tools/ktap/samples/interrupt/softirq_time.kp
 create mode 100644 tools/ktap/samples/io/kprobes-do-sys-open.kp
 create mode 100644 tools/ktap/samples/io/traceio.kp
 create mode 100644 tools/ktap/samples/mem/kmalloc-stack.kp
 create mode 100644 tools/ktap/samples/mem/kmem_count.kp
 create mode 100644 tools/ktap/samples/network/tcp_ipaddr.kp
 create mode 100644 tools/ktap/samples/profiling/function_profiler.kp
 create mode 100644 tools/ktap/samples/profiling/kprobe_all_kernel_functions.kp
 create mode 100644 tools/ktap/samples/profiling/stack_profile.kp
 create mode 100644 tools/ktap/samples/schedule/sched_transition.kp
 create mode 100644 tools/ktap/samples/schedule/schedtimes.kp
 create mode 100644 tools/ktap/samples/syscalls/errinfo.kp
 create mode 100644 tools/ktap/samples/syscalls/execve.kp
 create mode 100644 tools/ktap/samples/syscalls/opensnoop.kp
 create mode 100644 tools/ktap/samples/syscalls/sctop.kp
 create mode 100644 tools/ktap/samples/syscalls/syscalls.kp
 create mode 100644 tools/ktap/samples/syscalls/syscalls_count.kp
 create mode 100644 tools/ktap/samples/syscalls/syscalls_count_by_proc.kp
 create mode 100644 tools/ktap/samples/syscalls/syslatl.kp
 create mode 100644 tools/ktap/samples/syscalls/syslist.kp
 create mode 100644 tools/ktap/samples/tracepoints/eventcount.kp
 create mode 100644 tools/ktap/samples/tracepoints/eventcount_by_proc.kp
 create mode 100644 tools/ktap/samples/tracepoints/raw_tracepoint.kp
 create mode 100644 tools/ktap/samples/tracepoints/tracepoints.kp
 create mode 100644 tools/ktap/samples/userspace/gcc_unwind.kp
 create mode 100644 tools/ktap/samples/userspace/glibc_func_hist.kp
 create mode 100644 tools/ktap/samples/userspace/glibc_sdt.kp
 create mode 100644 tools/ktap/samples/userspace/glibc_trace.kp
 create mode 100644 tools/ktap/samples/userspace/malloc_free.kp
 create mode 100644 tools/ktap/samples/userspace/malloc_size_hist.kp
 create mode 100644 tools/ktap/samples/userspace/pthread.kp
 create mode 100644 tools/ktap/test/README
 create mode 100644 tools/ktap/test/arithmetic.t
 create mode 100644 tools/ktap/test/benchmark/cmp_neq.sh
 create mode 100644 tools/ktap/test/benchmark/cmp_profile.sh
 create mode 100644 tools/ktap/test/benchmark/cmp_table.sh
 create mode 100644 tools/ktap/test/benchmark/sembench.c
 create mode 100644 tools/ktap/test/cli-arg.t
 create mode 100644 tools/ktap/test/concat.t
 create mode 100644 tools/ktap/test/count.t
 create mode 100644 tools/ktap/test/deadloop.t
 create mode 100644 tools/ktap/test/fibonacci.t
 create mode 100644 tools/ktap/test/function.t
 create mode 100644 tools/ktap/test/if.t
 create mode 100644 tools/ktap/test/kprobe.t
 create mode 100644 tools/ktap/test/kretprobe.t
 create mode 100644 tools/ktap/test/len.t
 create mode 100644 tools/ktap/test/lib/Test/ktap.pm
 create mode 100644 tools/ktap/test/looping.t
 create mode 100644 tools/ktap/test/one-liner.t
 create mode 100644 tools/ktap/test/pairs.t
 create mode 100644 tools/ktap/test/stack_overflow.t
 create mode 100644 tools/ktap/test/syntax-err.t
 create mode 100644 tools/ktap/test/table.t
 create mode 100644 tools/ktap/test/time.t
 create mode 100644 tools/ktap/test/timer.t
 create mode 100644 tools/ktap/test/tracepoint.t
 create mode 100755 tools/ktap/test/util/reindex
 create mode 100644 tools/ktap/test/zerodivide.t
 create mode 100644 tools/ktap/vim/ftdetect/ktap.vim
 create mode 100644 tools/ktap/vim/syntax/ktap.vim

-- 
1.8.3.1

