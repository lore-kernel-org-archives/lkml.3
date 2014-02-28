Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaB1Rnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:43:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbaB1Rne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:34 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 00/19 V2] perf, c2c: Add new tool to analyze cacheline contention on NUMA systems
Date: Fri, 28 Feb 2014 12:42:49 -0500
Message-Id: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of NUMA systems, came the possibility of remote memory accesses.
Combine those remote memory accesses with contention on the remote node (ie a modified
cacheline) and you have a possibility for very long latencies.  These latencies can
bottleneck a program.

The program added by these patches, helps detect the situation where two nodes are
'tugging' on the same _data_ cacheline.  The term used through out this program and
the various changelogs is called a HITM.  This means nodeX went to read a cacheline
and it was discovered to be loaded in nodeY's LLC cache (hence the cacheHIT). The 
remote cacheline was also in a 'M'odified state thus creating a 'HIT M' for hit in
a modified state.  HITMs can happen locally and remotely.  This program's interest
is mainly in remote HITMs as they cause the longest latencies.

Why a program has a remote HITM derives from how the two nodes are 'sharing' the
cacheline.  Is the sharing intentional ("true") or unintentional ("false").  We have seen
lots of "false" sharing cases, which lead to simple solutions such as seperating the data
onto different cachelines.  

This tool does not distinguish between 'true' or 'false' sharing, instead it just points to
the more expensive sharing situations under the current workload.  It is up to the user
to understand what the workload is doing to determine whether a problem exists or not and
how to report it.

The data output is verbose and there are lots of data tables that interprit the latencies
and data addresses in different ways to help see where bottlenecks might be lying.

Most of this idea, work and calculations were done by Dick Fowles.  My work mainly
includes porting it to perf.  Joe Mario has contributed greatly with ideas to make the
output more informative based on his usage of the tool.  Joe has found a handful of
bottlenecks using various industry benchmarks and has worked with developers to fix
them.

I would also like to thank Stephane Eranian for his early help and guidance on 
navigating the differences between the current perf tool and how similar tools
looked at HP.  And also his tireless work in getting the MMAP2 interface to stick.

Also thanks to Arnaldo and Jiri Olso for their help in suggestions for this tool.

I also have a test program that generated a controlled number of HITMs that we used
frequently to validate our early work (the Intel docs were not always clear which
bits had to be set and some arches do not work well).  I would like to add it, but
didn't know how (nor did I spend any serious time looking either).

This program has been tested primarily on Intel's Ivy Bridge platforms.  The Sandy Bridge
platforms had some quirks that were fixed on Ivy Bridge.  We haven't tried Haswell as
that has a re-worked latency event implementation.

A handful of patches include re-enabling MMAP2 support and some fixes to perf itself.  One
in particular hacks up how standard deviation is calculated.  It works with our calculations
but may break other tools expectations.  Feedback is welcomed.

Comemnts, feedback, anything else welcomed.

V2: updated to latest perf/core branch 1029f9fedf87fa6
    switched to hist_entry based on Jiri O's suggestion
    dropped latency analyze for now until this patchset is accepted
    little fixes and tweaks

Signed-off-by: Don Zickus <dzickus@redhat.com>

Arnaldo Carvalho de Melo (2):
  perf c2c: Shared data analyser
  perf c2c: Dump raw records, decode data_src bits

Don Zickus (19):
  Revert "perf: Disable PERF_RECORD_MMAP2 support"
  perf, machine: Use map as success in ip__resolve_ams
  perf, session: Change header.misc dump from decimal to hex
  perf, stat: FIXME Stddev calculation is incorrect
  perf, callchain: Add generic callchain print handler for stdio
  perf, c2c: Rework setup code to prepare for features
  perf, c2c: Add rbtree sorted on mmap2 data
  perf, c2c: Add stats to track data source bits and cpu to node maps
  perf, c2c: Sort based on hottest cache line
  perf, c2c: Display cacheline HITM analysis to stdout
  perf, c2c: Add callchain support
  perf, c2c: Output summary stats
  perf, c2c: Dump rbtree for debugging
  perf, c2c: Fixup tid because of perf map is broken
  perf, c2c: Add symbol count table
  perf, c2c: Add shared cachline summary table
  perf, c2c: Add framework to analyze latency and display summary stats
  perf, c2c: Add selected extreme latencies to output cacheline stats
    table
  perf, c2c: Add summary latency table for various parts of caches

 kernel/events/core.c                |    4 -
 tools/perf/Documentation/perf-c2c.c |   22 +
 tools/perf/Makefile.perf            |    1 +
 tools/perf/builtin-c2c.c            | 2963 +++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                |    1 +
 tools/perf/perf.c                   |    1 +
 tools/perf/ui/stdio/hist.c          |   37 +
 tools/perf/util/event.c             |   36 +-
 tools/perf/util/evlist.c            |   37 +
 tools/perf/util/evlist.h            |    7 +
 tools/perf/util/evsel.c             |    1 +
 tools/perf/util/hist.h              |    4 +
 tools/perf/util/machine.c           |    2 +-
 tools/perf/util/session.c           |    2 +-
 tools/perf/util/stat.c              |    3 +-
 15 files changed, 3097 insertions(+), 24 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-c2c.c
 create mode 100644 tools/perf/builtin-c2c.c

-- 
1.7.11.7

Arnaldo Carvalho de Melo (2):
  perf c2c: Shared data analyser
  perf c2c: Dump raw records, decode data_src bits

Don Zickus (17):
  Revert "perf: Disable PERF_RECORD_MMAP2 support"
  perf, sort:  Add physid sorting based on mmap2 data
  perf, sort:  Allow unique sorting instead of combining hist_entries
  perf: Allow ability to map cpus to nodes easily
  perf, kmem: Utilize the new generic cpunode_map
  perf: Fix stddev calculation
  perf, callchain: Add generic callchain print handler for stdio
  perf, c2c: Rework setup code to prepare for features
  perf, c2c: Add in sort on physid
  perf, c2c: Add stats to track data source bits and cpu to node maps
  perf, c2c: Sort based on hottest cache line
  perf, c2c: Display cacheline HITM analysis to stdout
  perf, c2c: Add callchain support
  perf, c2c: Output summary stats
  perf, c2c: Dump rbtree for debugging
  perf, c2c: Add symbol count table
  perf, c2c: Add shared cachline summary table

 kernel/events/core.c                |    4 -
 tools/perf/Documentation/perf-c2c.c |   22 +
 tools/perf/Makefile.perf            |    1 +
 tools/perf/builtin-c2c.c            | 1787 +++++++++++++++++++++++++++++++++++
 tools/perf/builtin-kmem.c           |   78 +-
 tools/perf/builtin-report.c         |    2 +-
 tools/perf/builtin.h                |    1 +
 tools/perf/perf.c                   |    1 +
 tools/perf/ui/stdio/hist.c          |   37 +
 tools/perf/util/cpumap.c            |  150 +++
 tools/perf/util/cpumap.h            |   35 +
 tools/perf/util/event.c             |   36 +-
 tools/perf/util/evsel.c             |    1 +
 tools/perf/util/hist.c              |   10 +-
 tools/perf/util/hist.h              |    5 +
 tools/perf/util/sort.c              |  149 +++
 tools/perf/util/sort.h              |    4 +
 tools/perf/util/stat.c              |   13 +
 tools/perf/util/stat.h              |    1 +
 19 files changed, 2236 insertions(+), 101 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-c2c.c
 create mode 100644 tools/perf/builtin-c2c.c

-- 
1.7.11.7

