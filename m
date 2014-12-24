Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaLXHYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:24:33 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39497 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaLXHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:51 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC/PATCHSET 00/37] perf tools: Speed-up perf report by using multi thread (v1)
Date: Wed, 24 Dec 2014 16:14:56 +0900
Message-Id: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset converts perf report to use multiple threads in order to
speed up the processing on large data files.  I can see a minimum 40%
of speedup with this change.  The code is still experimental, little
bit outdated and contains many rough edges.  But I'd like to share and
give some feedbacks.

The perf report processes (sample) events like below:

  1. preprocess sample to get matching thread/dso/symbol info
  2. insert it to hists rbtree (with callchain tree) based on the info
  3. optionally collapse hist entries that match given sort key(s)
  4. resort hist entries (by overhead) for output
  5. display the hist entries

The stage 1 is a preprocessing and mostly act like a read-only
operation during the sample processing.  Meta events like fork, comm
and mmap can change the machine/thread state but symbols can be loaded
during the processing (stage 2).

The stage 2 consumes most of the time especially with callchains and
 --children option is enabled.  And this work can be easily patitioned
as each sample is independent to others.  But the resulting hists must
be combined/collapsed to a single global hists before going to further
steps.

The stage 3 is optional and only needed by certain sort keys - but
with stage 2 paralellized, it needs to be done anyway.

The stage 4 and 5 works on whole hists so must be done serially.

So my approach is like this:

Partially do stage 1 first - but only for meta events that changes
machine state.  To do this I add a dummy tracking event to perf record
and make it collect such meta events only.  They are saved in a
separate file (perf.header) and processed before sample events at perf
report time.

This also requires to handle multiple files and to find a
corresponding machine state when processing samples.  On a large
profiling session, many tasks were created and exited so pid might be
recycled (even more than once!).  To deal with it, I managed to have
thread, map_groups and comm in time sorted.  The only remaining thing
is symbol loading as it's done lazily when sample requires it.

With that being done, the stage 2 can be done by multiple threads.  I
also save each sample data (per-cpu or per-thread) in separate files
during record.  On perf report time, each file will be processed by
each thread.  And symbol loading is protected by a mutex lock.

For DWARF post-unwinding, dso cache data also needs to be protected by
a lock and this causes a huge contention.  I just added a front cache
that can be accessed without the lock but this should be improved IMHO.

The patch 1-10 are to support multi-file data recording.  With
 -M/--multi option, perf record will create a directory (named
'perf.data.dir' by default - but maybe renamed 'perf.data' for
transparent conversion later) and save meta events to perf.header file
and sample events to perf.data.<n> file).  It'd be better considering
file format change Jiri suggested [1].

The patch 11-20 are to manage machine and thread state using timestamp
so that it can be searched when processing samples.  The patch 21-35
are to implement parallel report.  And finally I implemented 'perf
data split' command to convert a single data file into a multi-file
format.

This patchset didn't change perf record to use multi-thread.  But I
think it can be easily done later if needed.

Note that output has a slight difference to original version when
compared using splitted data file.  But they're mostly unresolved
symbols for callchains.

Here is the result:

This is just elapsed (real) time measured by shell 'time' function.

The data file was recorded during kernel build with fp callchain and
size is 2.1GB.  The machine has 6 core with hyper-threading enabled
and I got a similar result on my laptop too.

 time perf report  --children  --no-children  + --call-graph none
 		   ----------  -------------  -------------------
 current            4m43.260s      1m32.779s            0m35.866s            
 patched            4m43.710s      1m29.695s            0m33.995s
 --multi-thread     2m46.265s      0m45.486s             0m7.570s


This result is with 7.7GB data file using libunwind for callchain.

 time perf report  --children  --no-children  + --call-graph none
 		   ----------  -------------  -------------------
 current            3m51.762s      3m10.451s             0m4.695s            
 patched            2m26.030s      1m49.846s             0m4.105s
 --multi-thread     0m49.217s      0m35.106s             0m1.457s

Note that the single thread performance improvement in patched version
is due to changes in the patch 33-35.


This result is with same file but using libdw for callchain unwind.

 time perf report  --children  --no-children  + --call-graph none
 		   ----------  -------------  -------------------
 current           10m22.472s     11m42.290s             0m4.758s            
 patched           10m10.625s     11m45.480s             0m4.162s
 --multi-thread     3m47.332s      3m35.235s             0m1.755s

On my archlinux system, callchain unwind using libdw is much slower
than libunwind.  I'm using elfutils version 0.160.  Also I don't know
why --children takes less time than --no-children.  Anyway we can see
the --multi-thread performance is much better for each case.


You can get it from 'perf/threaded-v1' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Please take a look and play with it.  Any comments are welcome! :)

Thanks,
Namhyung


[1] https://lkml.org/lkml/2013/9/1/20


Jiri Olsa (1):
  perf tools: Add new perf data command

Namhyung Kim (36):
  perf tools: Set attr.task bit for a tracking event
  perf record: Use a software dummy event to track task/mmap events
  perf tools: Use perf_data_file__fd() consistently
  perf tools: Add multi file interface to perf_data_file
  perf tools: Create separate mmap for dummy tracking event
  perf tools: Introduce perf_evlist__mmap_multi()
  perf tools: Do not use __perf_session__process_events() directly
  perf tools: Handle multi-file session properly
  perf record: Add -M/--multi option for multi file recording
  perf report: Skip dummy tracking event
  perf tools: Introduce thread__comm_time() helpers
  perf tools: Add a test case for thread comm handling
  perf tools: Use thread__comm_time() when adding hist entries
  perf tools: Convert dead thread list into rbtree
  perf tools: Introduce machine__find*_thread_time()
  perf tools: Add a test case for timed thread handling
  perf tools: Maintain map groups list in a leader thread
  perf tools: Remove thread when map groups initialization failed
  perf tools: Introduce thread__find_addr_location_time() and friends
  perf tools: Add a test case for timed map groups handling
  perf tools: Protect dso symbol loading using a mutex
  perf tools: Protect dso cache tree using dso->lock
  perf tools: Protect dso cache fd with a mutex
  perf session: Pass struct events stats to event processing functions
  perf hists: Pass hists struct to hist_entry_iter functions
  perf tools: Move BUILD_ID_SIZE definition to perf.h
  perf report: Parallelize perf report using multi-thread
  perf tools: Add missing_threads rb tree
  perf top: Always creates thread in the current task tree.
  perf tools: Fix progress ui to support multi thread
  perf record: Show total size of multi file data
  perf report: Add --multi-thread option and config item
  perf tools: Add front cache for dso data access
  perf tools: Convert lseek + read to pread
  perf callchain: Save eh/debug frame offset for dwarf unwind
  perf data: Implement 'split' subcommand

 tools/perf/Documentation/perf-data.txt   |  43 ++++
 tools/perf/Documentation/perf-record.txt |   5 +
 tools/perf/Documentation/perf-report.txt |   3 +
 tools/perf/Makefile.perf                 |   4 +
 tools/perf/builtin-annotate.c            |   5 +-
 tools/perf/builtin-data.c                | 298 ++++++++++++++++++++++++++
 tools/perf/builtin-diff.c                |   8 +-
 tools/perf/builtin-inject.c              |   9 +-
 tools/perf/builtin-record.c              |  65 ++++--
 tools/perf/builtin-report.c              | 107 ++++++++--
 tools/perf/builtin-script.c              |   5 +-
 tools/perf/builtin-top.c                 |   9 +-
 tools/perf/builtin.h                     |   1 +
 tools/perf/command-list.txt              |   1 +
 tools/perf/perf.c                        |   1 +
 tools/perf/perf.h                        |   2 +
 tools/perf/tests/builtin-test.c          |  12 ++
 tools/perf/tests/dso-data.c              |   5 +
 tools/perf/tests/dwarf-unwind.c          |  10 +-
 tools/perf/tests/hists_common.c          |   3 +-
 tools/perf/tests/hists_cumulate.c        |   4 +-
 tools/perf/tests/hists_filter.c          |   3 +-
 tools/perf/tests/hists_link.c            |   6 +-
 tools/perf/tests/hists_output.c          |   4 +-
 tools/perf/tests/tests.h                 |   3 +
 tools/perf/tests/thread-comm.c           |  47 +++++
 tools/perf/tests/thread-lookup-time.c    | 180 ++++++++++++++++
 tools/perf/tests/thread-mg-share.c       |   7 +-
 tools/perf/tests/thread-mg-time.c        |  88 ++++++++
 tools/perf/ui/browsers/hists.c           |  10 +-
 tools/perf/ui/gtk/hists.c                |   3 +
 tools/perf/util/build-id.c               |   9 +-
 tools/perf/util/build-id.h               |   2 -
 tools/perf/util/data.c                   | 188 ++++++++++++++++-
 tools/perf/util/data.h                   |  17 ++
 tools/perf/util/dso.c                    | 192 ++++++++++++-----
 tools/perf/util/dso.h                    |   5 +
 tools/perf/util/event.c                  |  85 ++++++--
 tools/perf/util/event.h                  |   6 +-
 tools/perf/util/evlist.c                 | 151 ++++++++++++--
 tools/perf/util/evlist.h                 |  22 +-
 tools/perf/util/evsel.c                  |   1 +
 tools/perf/util/evsel.h                  |  15 ++
 tools/perf/util/hist.c                   | 121 +++++++----
 tools/perf/util/hist.h                   |  12 +-
 tools/perf/util/machine.c                | 251 +++++++++++++++++++---
 tools/perf/util/machine.h                |  12 +-
 tools/perf/util/map.c                    |   1 +
 tools/perf/util/map.h                    |   2 +
 tools/perf/util/ordered-events.c         |   4 +-
 tools/perf/util/session.c                | 347 ++++++++++++++++++++++++++-----
 tools/perf/util/session.h                |   8 +-
 tools/perf/util/symbol.c                 |  34 ++-
 tools/perf/util/thread.c                 | 140 ++++++++++++-
 tools/perf/util/thread.h                 |  28 ++-
 tools/perf/util/tool.h                   |  17 ++
 tools/perf/util/unwind-libdw.c           |  11 +-
 tools/perf/util/unwind-libunwind.c       |  49 +++--
 tools/perf/util/util.c                   |  43 ++++
 tools/perf/util/util.h                   |   1 +
 60 files changed, 2381 insertions(+), 344 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-data.txt
 create mode 100644 tools/perf/builtin-data.c
 create mode 100644 tools/perf/tests/thread-comm.c
 create mode 100644 tools/perf/tests/thread-lookup-time.c
 create mode 100644 tools/perf/tests/thread-mg-time.c

-- 
2.1.3

