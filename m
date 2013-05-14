Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab3ENKOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:14:06 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43979 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3ENKOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:14:02 -0400
X-AuditID: 9c930197-b7b76ae000003523-23-51920e67df30
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCHSET 00/15] perf tools: Introduce new 'ftrace' command (v2)
Date: Tue, 14 May 2013 19:13:44 +0900
Message-Id: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patchset implements a front-end tool for kernel's ftrace.  It
uses function_graph tracer by default and normal function tracer is
also supported.  (Of course you need to enable those tracers in your
kernel first.)

NOTE: It's in very early stage, so may contain many rough edges.

v2 changes:
 * factor out tracepoint_name_to_path() function
 * rework [re]set_tracing_cpumask() function to work with many cpus
 * fix a deadlock in 'record' path
 * fix a bug regarding to the pager setup
 * add a debug patch for finding segfaults

I pushed it out to 'perf/ftrace-v2' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Following is the original description and example.

----
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
           sleep-11573 [000] 717758.728678862: funcgraph_entry:      finish_task_switch() {
           sleep-11573 [000] 717758.728682155: funcgraph_exit:       }
           sleep-11573 [000] 717758.728683099: funcgraph_entry:      finish_wait() {
           sleep-11573 [000] 717758.728683617: funcgraph_exit:       }
           sleep-11573 [000] 717758.728683993: funcgraph_entry:      pipe_lock() {
           sleep-11573 [000] 717758.728684425: funcgraph_entry:        pipe_lock_nested.isra.
           sleep-11573 [000] 717758.728684863: funcgraph_entry:          mutex_lock() {
           sleep-11573 [000] 717758.728685239: funcgraph_entry:            _cond_resched() {
           sleep-11573 [000] 717758.728685807: funcgraph_exit:             }
           sleep-11573 [000] 717758.728686296: funcgraph_exit:           }
           sleep-11573 [000] 717758.728686757: funcgraph_exit:         }
           sleep-11573 [000] 717758.728687529: funcgraph_exit:       }
           sleep-11573 [000] 717758.728688608: funcgraph_entry:      mutex_unlock() {
           sleep-11573 [000] 717758.728689343: funcgraph_exit:       }
           sleep-11573 [000] 717758.728690685: funcgraph_entry:      __audit_syscall_exit() {
           sleep-11573 [000] 717758.728691499: funcgraph_entry:        path_put() {
           sleep-11573 [000] 717758.728692147: funcgraph_entry:          dput() {
           sleep-11573 [000] 717758.728692845: funcgraph_exit:           }
           sleep-11573 [000] 717758.728693380: funcgraph_entry:          mntput() {
           sleep-11573 [000] 717758.728694021: funcgraph_exit:           }
           sleep-11573 [000] 717758.728694520: funcgraph_exit:         }
           sleep-11573 [000] 717758.728695005: funcgraph_entry:        unroll_tree_refs() {
           sleep-11573 [000] 717758.728695659: funcgraph_exit:         }
           sleep-11573 [000] 717758.728696301: funcgraph_entry:        kfree() {
           sleep-11573 [000] 717758.728697085: funcgraph_exit:         }
           sleep-11573 [000] 717758.728697916: funcgraph_exit:       }


  # perf ftrace report
  # ========
  # captured on: Tue Apr 23 16:43:52 2013
  # hostname : sejong.aot.lge.com
  # os release : 3.6.11-5.fc17.x86_64
  # perf version : 3.9.rc8.gceb5f8
  # arch : x86_64
  # nrcpus online : 12
  # nrcpus avail : 12
  # cpudesc : Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz
  # cpuid : GenuineIntel,6,45,7
  # total memory : 32901952 kB
  # cmdline : /home/namhyung/project/linux/tools/perf/perf ftrace record sleep 0.1 
  # event : name = ftrace:funcgraph_entry, type = 2, config = 0xb, config1 = 0x0, config2 = 0x0
  # event : name = ftrace:funcgraph_exit, type = 2, config = 0xa, config1 = 0x0, config2 = 0x0,
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



Note that this patchset is based on my previous work [1][2].

Any comments are welcome, thanks,
Namhyung


[1] https://lkml.org/lkml/2013/4/11/194
[2] https://lkml.org/lkml/2013/4/15/13


Namhyung Kim (15):
  perf util: Move debugfs/tracing helper functions to util.c
  perf util: Use evsel->name to get tracepoint_paths
  perf util: Save pid-cmdline mapping into tracing header
  perf util: Add more debug message on failure path
  perf tools: Introduce new 'ftrace' tool
  perf ftrace: Add support for --pid option
  perf ftrace: Add support for -a and -C option
  perf ftrace: Split "live" sub-command
  perf ftrace: Add 'record' sub-command
  perf ftrace: Add 'show' sub-command
  perf ftrace: Add 'report' sub-command
  perf ftrace: Use pager for displaying result
  perf ftrace: Cleanup using ftrace_setup/teardown()
  perf tools: Add document for perf-ftrace command
  perf ftrace: Add a signal handler for SIGSEGV

 tools/perf/Documentation/perf-ftrace.txt |  114 ++
 tools/perf/Makefile                      |    1 +
 tools/perf/builtin-ftrace.c              | 1714 ++++++++++++++++++++++++++++++
 tools/perf/builtin.h                     |    1 +
 tools/perf/command-list.txt              |    1 +
 tools/perf/perf.c                        |    1 +
 tools/perf/util/cpumap.c                 |   45 +
 tools/perf/util/cpumap.h                 |    1 +
 tools/perf/util/header.c                 |    4 +-
 tools/perf/util/parse-events.c           |   23 +
 tools/perf/util/parse-events.h           |    1 +
 tools/perf/util/trace-event-info.c       |  103 +-
 tools/perf/util/trace-event-parse.c      |   17 +
 tools/perf/util/trace-event-read.c       |   77 +-
 tools/perf/util/trace-event.h            |    1 +
 tools/perf/util/util.c                   |   59 +
 tools/perf/util/util.h                   |    3 +
 17 files changed, 2092 insertions(+), 74 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-ftrace.txt
 create mode 100644 tools/perf/builtin-ftrace.c

-- 
1.7.11.7

