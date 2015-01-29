Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbbA2IWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:22:37 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50850 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbbA2IJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:09:54 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC/PATCHSET 00/42] perf tools: Speed-up perf report by using multi thread (v2)
Date: Thu, 29 Jan 2015 17:06:41 +0900
Message-Id: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset converts perf report to use multiple threads in order to
speed up the processing on large data files.  I can see a minimum ~30%
of speedup with this change.  The code is still experimental and
contains many rough edges.  But I'd like to share and give some
feedbacks.

The main change in this version is using single data file with an
index table rather than using multiple files.  It seems that single
thread performance was improved by this than previous version but multi
thread performance remains almost same.

The perf report processes (sample) events like below:

  1. preprocess sample to get matching thread/dso/symbol info
  2. insert it to hists rbtree (with callchain tree) based on the info
  3. optionally collapse hist entries that match given sort key(s)
  4. resort hist entries (by overhead) for output
  5. display the hist entries

The stage 1 is a preprocessing and mostly act like a read-only
operation in that it doesn't change a machine state during the sample
processing.  Meta events like fork, comm and mmap can change the
machine/thread state but symbols can be loaded during the processing
(stage 2).

The stage 2 consumes most of the time especially with callchains and
 --children option is enabled.  And this work can be easily patitioned
as each sample is independent to others.  But the resulting hists must
be combined/collapsed to a single global hists before going to further
steps.

The stage 3 is optional and only needed by certain sort keys - but
with stage 2 paralellized, it needs to be done always.

The stage 4 and 5 works on whole hists so must be done serially.

So my approach is like this:

Partially do stage 1 first - but only for meta events that changes
machine state.  To do this I add a dummy tracking event to perf record
and make it collect such meta events only.  They are saved as normal
data and processed before sample events at perf report time.

This also requires to handle multiple sample data concurrently and to
find a corresponding machine state when processing samples.  On a
large profiling session, many tasks were created and exited so pid
might be recycled (even more than once!).  To deal with it, I managed
to have thread, map_groups and comm in time sorted.  The only
remaining thing is symbol loading as it's done lazily when sample
requires it.

With that being done, the stage 2 can be done by multiple threads.  I
also save each sample data (per-cpu or per-thread) in separate files
during record and then merge them into a single data file with an
index table.  On perf report time, each region of sample data will be
processed by each thread.  And symbol loading is protected by a mutex
lock.

For DWARF post-unwinding, dso cache data also needs to be protected by
a lock and this caused a huge contention.  I made it to search the
rbtree speculatively first and then, if it didn't find one, search it
again under the dso lock.  Please take a look at it if it's acceptable.

The patch 1-4 are independent fixes and cleans.  The patch 5-14 are to
support indexing for data file.  With --index option, perf record will
create a intermediate directory and then save meta events and sample
data to separate files.  And finally it'll build an index table and
concatenate the data files.

The patch 15-26 are to manage machine and thread state using timestamp
so that it can be searched when processing samples.  The patch 27-40
are to implement parallel report.  And finally I implemented 'perf
data index' command to build an index table for a given data file.

This patchset didn't change perf record to use multi-thread.  But I
think it can be easily done later if needed.

Note that output has a slight difference to original version when
compared using indexed data file.  But they're mostly unresolved
symbols for callchains.

Here is the result:

This is just elapsed time measured by 'perf stat -r 5'.

The data file was recorded during kernel build with fp callchain and
size is 2.1GB.  The machine has 6 core with hyper-threading enabled
and I got a similar result on my laptop too.

 perf report          --children  --no-children  + --call-graph none
 		   -------------  -------------  -------------------
 current           285.708340593   94.317412961      36.707232978  
 with index        253.322717665   77.079748639      24.892021523
 + --multi-thread  174.037760271   44.717308080       8.300466711


This result is with 7.7GB data file using libunwind for callchain.

 perf report          --children  --no-children  + --call-graph none
 		   -------------  -------------  -------------------
 current           247.070444039  196.393820003       5.068489333
 with index        149.456483830  108.917644447       3.642109876
 + --multi-thread   43.990095636   28.342798882       1.829218561

I guess the speedup of indexed data file came from skipping ordered
event layer.

This result is with same file but using libdw for callchain unwind.

 perf report          --children  --no-children  + --call-graph none
 		   -------------  -------------  -------------------
 current           465.661321115  496.153153039       4.629841428
 with index        445.712762188  462.146612217       3.535147499
 + --multi-thread  215.264706814   29.279996335       1.938137940

On my archlinux system, callchain unwind using libdw is much slower
than libunwind.  I'm using elfutils version 0.160.  Also I don't know
why --children takes less time than --no-children.  Anyway we can see
the --multi-thread performance is much better for each case.


You can get it from 'perf/threaded-v2' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Please take a look and play with it.  Any comments are welcome! :)

Thanks,
Namhyung


Jiri Olsa (1):
  perf tools: Add new perf data command

Namhyung Kim (41):
  perf tools: Support to read compressed module from build-id cache
  perf tools: Do not use __perf_session__process_events() directly
  perf record: Show precise number of samples
  perf header: Set header version correctly
  perf tools: Set attr.task bit for a tracking event
  perf tools: Use a software dummy event to track task/mmap events
  perf tools: Use perf_data_file__fd() consistently
  perf tools: Add rm_rf() utility function
  perf tools: Introduce copyfile_offset() function
  perf tools: Create separate mmap for dummy tracking event
  perf tools: Introduce perf_evlist__mmap_track()
  perf tools: Add HEADER_DATA_INDEX feature
  perf tools: Handle indexed data file properly
  perf record: Add --index option for building index table
  perf report: Skip dummy tracking event
  perf tools: Pass session arg to perf_event__preprocess_sample()
  perf script: Pass session arg to ->process_event callback
  perf tools: Introduce thread__comm_time() helpers
  perf tools: Add a test case for thread comm handling
  perf tools: Use thread__comm_time() when adding hist entries
  perf tools: Convert dead thread list into rbtree
  perf tools: Introduce machine__find*_thread_time()
  perf tools: Add a test case for timed thread handling
  perf tools: Maintain map groups list in a leader thread
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
  perf record: Synthesize COMM event for a command line workload
  perf tools: Fix progress ui to support multi thread
  perf report: Add --multi-thread option and config item
  perf session: Handle index files generally
  perf tools: Convert lseek + read to pread
  perf callchain: Save eh/debug frame offset for dwarf unwind
  perf data: Implement 'index' subcommand

 tools/perf/Documentation/perf-data.txt             |  44 +++
 tools/perf/Documentation/perf-record.txt           |   4 +
 tools/perf/Documentation/perf-report.txt           |   3 +
 tools/perf/Makefile.perf                           |   4 +
 tools/perf/builtin-annotate.c                      |   8 +-
 tools/perf/builtin-data.c                          | 428 +++++++++++++++++++++
 tools/perf/builtin-diff.c                          |  21 +-
 tools/perf/builtin-inject.c                        |   5 +-
 tools/perf/builtin-mem.c                           |   6 +-
 tools/perf/builtin-record.c                        | 261 +++++++++++--
 tools/perf/builtin-report.c                        |  74 +++-
 tools/perf/builtin-script.c                        |  54 ++-
 tools/perf/builtin-timechart.c                     |  10 +-
 tools/perf/builtin-top.c                           |   7 +-
 tools/perf/builtin.h                               |   1 +
 tools/perf/command-list.txt                        |   1 +
 tools/perf/perf.c                                  |   1 +
 tools/perf/perf.h                                  |   2 +
 tools/perf/tests/builtin-test.c                    |  12 +
 tools/perf/tests/dso-data.c                        |   5 +
 tools/perf/tests/dwarf-unwind.c                    |   8 +-
 tools/perf/tests/hists_common.c                    |   3 +-
 tools/perf/tests/hists_cumulate.c                  |   6 +-
 tools/perf/tests/hists_filter.c                    |   5 +-
 tools/perf/tests/hists_link.c                      |  10 +-
 tools/perf/tests/hists_output.c                    |   6 +-
 tools/perf/tests/tests.h                           |   3 +
 tools/perf/tests/thread-comm.c                     |  47 +++
 tools/perf/tests/thread-lookup-time.c              | 180 +++++++++
 tools/perf/tests/thread-mg-share.c                 |   7 +-
 tools/perf/tests/thread-mg-time.c                  |  88 +++++
 tools/perf/ui/browsers/hists.c                     |  30 +-
 tools/perf/ui/gtk/hists.c                          |   3 +
 tools/perf/util/build-id.c                         |   9 +-
 tools/perf/util/build-id.h                         |   2 -
 tools/perf/util/db-export.c                        |   6 +-
 tools/perf/util/db-export.h                        |   4 +-
 tools/perf/util/dso.c                              | 159 +++++---
 tools/perf/util/dso.h                              |   3 +
 tools/perf/util/event.c                            | 106 ++++-
 tools/perf/util/event.h                            |  13 +-
 tools/perf/util/evlist.c                           | 161 ++++++--
 tools/perf/util/evlist.h                           |  22 +-
 tools/perf/util/evsel.c                            |   1 +
 tools/perf/util/evsel.h                            |  15 +
 tools/perf/util/header.c                           |  63 ++-
 tools/perf/util/header.h                           |   3 +
 tools/perf/util/hist.c                             | 121 ++++--
 tools/perf/util/hist.h                             |  12 +-
 tools/perf/util/machine.c                          | 258 +++++++++++--
 tools/perf/util/machine.h                          |  12 +-
 tools/perf/util/map.c                              |   1 +
 tools/perf/util/map.h                              |   2 +
 tools/perf/util/ordered-events.c                   |   4 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   3 +-
 .../util/scripting-engines/trace-event-python.c    |   5 +-
 tools/perf/util/session.c                          | 356 ++++++++++++++---
 tools/perf/util/session.h                          |  11 +-
 tools/perf/util/symbol-elf.c                       |  13 +-
 tools/perf/util/symbol.c                           |  34 +-
 tools/perf/util/thread.c                           | 139 ++++++-
 tools/perf/util/thread.h                           |  28 +-
 tools/perf/util/tool.h                             |  14 +
 tools/perf/util/trace-event-scripting.c            |   3 +-
 tools/perf/util/trace-event.h                      |   3 +-
 tools/perf/util/unwind-libdw.c                     |  11 +-
 tools/perf/util/unwind-libunwind.c                 |  49 ++-
 tools/perf/util/util.c                             |  81 +++-
 tools/perf/util/util.h                             |   2 +
 69 files changed, 2662 insertions(+), 414 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-data.txt
 create mode 100644 tools/perf/builtin-data.c
 create mode 100644 tools/perf/tests/thread-comm.c
 create mode 100644 tools/perf/tests/thread-lookup-time.c
 create mode 100644 tools/perf/tests/thread-mg-time.c

-- 
2.2.2

