Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaLCQY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:24:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaLCQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:24:55 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>, Jiri Olsa <jolsa@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 0/8] perf tools: Add perf data CTF conversion
Date: Wed,  3 Dec 2014 17:23:54 +0100
Message-Id: <1417623842-14331-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this is follow up on original RFC patchset:
  http://marc.info/?t=140732735600004&r=1&w=2

Basically we are adding 'perf data convert' command to
allow conversion of perf data file into CTF [1] data.

Changes from RFC:
  - able to generate CTF data, that are possible to be displayed under
    tracecompas GUI [3], please check several screenshots in here [4]
  - storing CTF data streams per cpu
  - several cleanups

Examples:
- Catch default perf data (cycles event):
  $ perf record ls
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.012 MB perf.data (~546 samples) ]

- To display converted CTF data run [2]:
  $ babeltrace ./ctf-data/
  [03:19:13.962125533] (+?.?????????) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 1 }
  [03:19:13.962130001] (+0.000004468) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 1 }
  [03:19:13.962131936] (+0.000001935) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 8 }
  [03:19:13.962133732] (+0.000001796) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 114 }
  [03:19:13.962135557] (+0.000001825) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 2087 }
  [03:19:13.962137627] (+0.000002070) cycles: { }, { ip = 0xFFFFFFFF81361938, tid = 20714, pid = 20714, period = 37582 }
  [03:19:13.962161091] (+0.000023464) cycles: { }, { ip = 0xFFFFFFFF8124218F, tid = 20714, pid = 20714, period = 600246 }
  [03:19:13.962517569] (+0.000356478) cycles: { }, { ip = 0xFFFFFFFF811A75DB, tid = 20714, pid = 20714, period = 1325731 }
  [03:19:13.969518008] (+0.007000439) cycles: { }, { ip = 0x34080917B2, tid = 20714, pid = 20714, period = 1144298 }

- To get some nice output in tracecompas GUI [3], please capture sched:*
  and syscall tracepoints like:
  # perf record -e 'sched:*,raw_syscalls:*' -a
  ^C[ perf record: Woken up 0 times to write data ]
  [ perf record: Captured and wrote 412.347 MB perf.data (~18015721 samples) ]

- To convert perf data file run:
  # perf data convert --to-ctf=./ctf 
  [ perf data convert: Converted 'perf.data' into CTF data './ctf' ]
  [ perf data convert: Converted and wrote 408.421 MB (3964792 samples) ]

- To display converted CTF data run [2]:
  # babeltrace ./ctf-data/
  [23:32:20.165354855] (+0.000000507) sched:sched_wakeup: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF810BCA72, perf_tid = 0, perf_pid = 0, perf_id = 462554, perf_period = 1, common_type = 265, ...
  [23:32:20.165359078] (+0.000001181) sched:sched_switch: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF8172A110, perf_tid = 0, perf_pid = 0, perf_id = 462562, perf_period = 1, common_type = 263, ...
  [23:32:20.165364686] (+0.000000328) sched:sched_stat_runtime: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF810C8AE5, perf_tid = 5326, perf_pid = 5326, perf_id = 462610, perf_period = 11380, ...
  [23:32:20.165366067] (+0.000001205) sched:sched_switch: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF8172A110, perf_tid = 5326, perf_pid = 5326, perf_id = 462562, perf_period = 1, common_type  ...
  [23:32:20.165723312] (+0.000001479) sched:sched_stat_runtime: { cpu_id = 2 }, { perf_ip = 0xFFFFFFFF810C8AE5, perf_tid = 11821, perf_pid = 11821, perf_id = 462612, perf_period = 1000265, ...
  [23:32:20.065282391] (+?.?????????) raw_syscalls:sys_enter: { cpu_id = 1 }, { perf_ip = 0xFFFFFFFF810230AF, perf_tid = 26155, perf_pid = 26155, perf_id = 462635, perf_period = 1, ...
  [23:32:20.065286422] (+0.000004031) raw_syscalls:sys_exit: { cpu_id = 1 }, { perf_ip = 0xFFFFFFFF810231D8, perf_tid = 26155, perf_pid = 26155, perf_id = 462639, perf_period = 1, ...

- Or run tracecompass and open the CTF data ;-)

Changes are also reachable in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_ctf_convert

thanks,
jirka

[1] Common Trace Format - http://www.efficios.com/ctf
[2] babeltrace - http://www.efficios.com/babeltrace
[3] Trace compass - http://projects.eclipse.org/projects/tools.tracecompass
[4] screenshots - http://people.redhat.com/~jolsa/tracecompass-perf/


Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Dominique Toupin <dominique.toupin@ericsson.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeremie Galarneau <jgalar@efficios.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
Jiri Olsa (5):
      perf tools: Add feature check for libbabeltrace
      perf tools: Add new perf data command
      perf data: Add perf data to CTF conversion support
      perf data: Enable stream flush within processing
      perf data: Add support for setting ordered_events queue size

Sebastian Andrzej Siewior (3):
      perf data: Add a 'perf' prefix to the generic fields
      perf data: Add tracepoint events fields CTF conversion support
      perf data: Switch to multiple cpu stream files

 tools/perf/Documentation/perf-data.txt                |   40 ++++
 tools/perf/Documentation/perf.txt                     |    7 +-
 tools/perf/Makefile.perf                              |    9 +-
 tools/perf/builtin-data.c                             |  119 ++++++++++
 tools/perf/builtin.h                                  |    1 +
 tools/perf/command-list.txt                           |    1 +
 tools/perf/config/Makefile                            |   24 ++
 tools/perf/config/feature-checks/Makefile             |    8 +-
 tools/perf/config/feature-checks/test-all.c           |    5 +
 tools/perf/config/feature-checks/test-libbabeltrace.c |    8 +
 tools/perf/perf.c                                     |    1 +
 tools/perf/util/data-convert-bt.c                     | 1060 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/data-convert-bt.h                     |    8 +
 tools/perf/util/debug.c                               |    2 +
 tools/perf/util/debug.h                               |    1 +
 15 files changed, 1290 insertions(+), 4 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-data.txt
 create mode 100644 tools/perf/builtin-data.c
 create mode 100644 tools/perf/config/feature-checks/test-libbabeltrace.c
 create mode 100644 tools/perf/util/data-convert-bt.c
 create mode 100644 tools/perf/util/data-convert-bt.h
