Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab3G3JTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:19:20 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64877 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab3G3JTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:19:17 -0400
X-AuditID: 9c930179-b7c49ae000000e68-bb-51f785126ff0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCHSET 00/17] perf tools: Introduce new 'ftrace' command (v4)
Date: Tue, 30 Jul 2013 18:18:57 +0900
Message-Id: <1375175954-798-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements a front-end tool for kernel's ftrace.  It
uses function_graph tracer by default and normal function tracer is
also supported.  (Of course you need to enable those tracers in your
kernel first.)

v4 changes:
 * use pid instead of tid for -p option (David)
 * not to poll() for reading ftrace pipes (Jiri)
 * rename to create_perf_header() (Jiri)
 * canonicalize directory name (Jiri)
 * show more info when -D option was given (Jiri)
 * update documentation (Jiri)
 * and few more bug fixes

I pushed it out to 'perf/ftrace-v4' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks,
Namhyung


Namhyung Kim (17):
  perf util: Save pid-cmdline mapping into tracing header
  perf util: Add more debug message on failure path
  perf tools: Introduce new 'ftrace' tool
  perf ftrace: Add support for --pid option
  perf ftrace: Add support for -a and -C option
  perf ftrace: Split "live" sub-command
  perf ftrace: Add 'record' sub-command
  perf ftrace: Add 'show' sub-command
  perf ftrace: Add 'report' sub-command
  perf ftrace: Add dump_printf() for low-level debugging
  perf ftrace: Use pager for displaying result
  perf ftrace: Cleanup using ftrace_setup/teardown()
  perf tools: Add document for perf-ftrace command
  perf ftrace: Add a signal handler for SIGSEGV
  perf ftrace: Add --clock option
  perf ftrace: Show leaf-functions as oneliner
  perf ftrace: Tidy up the function graph output of 'show' subcommand

 tools/perf/Documentation/perf-ftrace.txt |  116 ++
 tools/perf/Makefile                      |    1 +
 tools/perf/builtin-ftrace.c              | 1788 ++++++++++++++++++++++++++++++
 tools/perf/builtin.h                     |    1 +
 tools/perf/command-list.txt              |    1 +
 tools/perf/perf.c                        |    1 +
 tools/perf/util/cpumap.c                 |   45 +
 tools/perf/util/cpumap.h                 |    1 +
 tools/perf/util/debug.c                  |    8 +-
 tools/perf/util/debug.h                  |    2 +-
 tools/perf/util/header.c                 |    4 +-
 tools/perf/util/session.c                |    2 +-
 tools/perf/util/trace-event-info.c       |   33 +-
 tools/perf/util/trace-event-parse.c      |   17 +
 tools/perf/util/trace-event-read.c       |   77 +-
 tools/perf/util/trace-event.h            |    1 +
 16 files changed, 2077 insertions(+), 21 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-ftrace.txt
 create mode 100644 tools/perf/builtin-ftrace.c


Following is the original description and example.
-----
It consists of 4 subcommands: live, record, show and report.

'perf ftrace live' just triggers ftrace and relay kernel buffer
contents to stdout.  It does no processing in the tool side.

'perf ftrace record' starts ftrace and saves its result to per-cpu
files and a perf.header file in the perf.data.dir directory.
Recording was done by multiple threads (a thread per cpu) in order not
to miss events overrun.  The perf.header file is compatible to current
perf.data file and contains useful information and sample data.

The sample data were synthesized for each recorded cpu to provide more
information - I'm not sure it's really needed though.

Once you had run 'perf ftrace record', you could play with other
subcommands.

'perf ftrace show' displays function traces like 'live' subcommand or
trace-cmd does.  It's not useful than them at this time but it could
be improved soon.

'perf ftrace report' displays usual 'perf report' style output from
the function trace data.  You can see which function is called most
frequently for example.  Currently it uses 1 as a period value for
each entry but we might use funcgraph_exit->calltime to get proper
overhead later.

Example below:

  # perf ftrace record sleep 0.1
  # ls -l perf.data.dir
  total 5568
  -rw-r--r--. 1 root root 3514375 Apr 23 16:43 perf.header
  -rw-r--r--. 1 root root   90112 Apr 23 16:43 trace-cpu0.buf
  -rw-r--r--. 1 root root       0 Apr 23 16:43 trace-cpu1.buf
  -rw-r--r--. 1 root root 2093056 Apr 23 16:43 trace-cpu2.buf
  -rw-r--r--. 1 root root       0 Apr 23 16:43 trace-cpu3.buf

  # perf ftrace show
  overriding event (11) ftrace:funcgraph_entry with new print handler
  overriding event (10) ftrace:funcgraph_exit with new print handler
    0)   0.065 us |  __fsnotify_parent();
    0)            |  fsnotify() {
    0)   0.060 us |    __srcu_read_lock();
    0)   0.040 us |    __srcu_read_unlock();
    0)   0.652 us |  }
    0)   0.040 us |  fput();
    0)            |  __audit_syscall_exit() {
    0)            |    path_put() {
    0)   0.037 us |      dput();
    0)   0.032 us |      mntput();
    0)   0.563 us |    }
    0)   0.035 us |    unroll_tree_refs();
    0)   0.035 us |    kfree();
    0)   1.284 us |  }
    0)            |  __audit_syscall_entry() {
    0)   0.029 us |    current_kernel_time();
    0)   0.239 us |  }
    0)            |  sys_write() {
    0)   0.155 us |    fget_light();
    0)            |    vfs_write() {
    0)            |      rw_verify_area() {
    0)            |        security_file_permission() {
    0)            |          selinux_file_permission() {
    0)            |            file_has_perm() {
    0)            |              inode_has_perm.isra.31.constprop.61() {
    0)   0.181 us |                avc_has_perm_flags();
    0)   0.405 us |              }
    0)   0.629 us |            }
    0)   1.024 us |          }
    0)   1.247 us |        }
    0)   1.596 us |      }
    0)            |      do_sync_write() {

  # perf ftrace report
  # ========
  # captured on: Tue Jul 30 18:02:34 2013
  # hostname : sejong.aot.lge.com
  # os release : 3.9.10-100.fc17.x86_64
  # perf version : 3.11.rc1.gcdd406
  # arch : x86_64
  # nrcpus online : 12
  # nrcpus avail : 12
  # cpudesc : Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz
  # cpuid : GenuineIntel,6,45,7
  # total memory : 32901840 kB
  # cmdline : /home/namhyung/project/linux/tools/perf/perf ftrace record sleep 0.1 
  # event : name = ftrace:funcgraph_entry, type = 2, config = 0xb, config1 = 0x0,
  # event : name = ftrace:funcgraph_exit, type = 2, config = 0xa, config1 = 0x0,
  # HEADER_CPU_TOPOLOGY info available, use -I to display
  # HEADER_NUMA_TOPOLOGY info available, use -I to display
  # ========
  #
  # Samples: 22K of event 'ftrace:funcgraph_entry'
  # Event count (approx.): 22433
  #
  # Overhead  Command      Shared Object                          Symbol
  # ........  .......  .................  ..............................
  #
       7.90%    sleep  [kernel.kallsyms]  [k] _cond_resched                             
       4.57%    sleep  [kernel.kallsyms]  [k] ebitmap_get_bit                           
       3.50%    sleep  [kernel.kallsyms]  [k] __phys_addr                               
       3.12%    sleep  [kernel.kallsyms]  [k] _raw_spin_lock                            
       3.09%    sleep  [kernel.kallsyms]  [k] kmem_cache_free                           
       2.93%    sleep  [kernel.kallsyms]  [k] __slab_free                               
       2.86%    sleep  [kernel.kallsyms]  [k] __tlb_remove_page                         
       2.35%    sleep  [kernel.kallsyms]  [k] vm_normal_page                            
       2.33%    sleep  [kernel.kallsyms]  [k] page_remove_rmap                          
       1.87%    sleep  [kernel.kallsyms]  [k] mutex_unlock               


-- 
1.7.11.7

