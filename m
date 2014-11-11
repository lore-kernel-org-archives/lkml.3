Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaKKOSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:18:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaKKOSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:18:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151462"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 00/25] perf tools: Introduce an abstraction for Instruction Tracing
Date: Tue, 11 Nov 2014 16:16:38 +0200
Message-Id: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have separated out some more preparatory patches for Intel PT.
The first 3 patches are small fixes, but the rest introduce
an abstraction for Instruction tracing.

The abstraction has two separate aspects:
	1. recording Instruction Trace data
	2. processing Instruction Trace data

Recording consists of mmapping a separate buffer and copying
the data into the perf.data file.  The buffer is an AUX area
buffer although the details of the AUX area are not implemented
because the kernel support is pending.  The data is written
preceded by a new user event PERF_RECORD_ITRACE.  The data is
too big to fit in the event but follows immediately afterward.
Session processing has to skip to get to the next event header
in a similar fashion to the existing PERF_RECORD_HEADER_TRACING_DATA
event.  The main recording patches are:

      perf evlist: Add initial support for mmapping an Instruction Trace buffer
      perf tools: Add user events for Instruction Tracing
      perf tools: Add support for Instruction Trace recording
      perf record: Add basic Instruction Tracing support

Processing consists of providing hooks in session processing
to enable an Instruction Trace decoder to see all the events
and deliver synthesized events transparently into the event
stream.  The main processing patch is:

      perf session: Add hooks to allow transparent decoding of Instruction Tracing data


Adrian Hunter (25):
      perf tools: Do not poll events that use the system_wide flag
      perf tools: Add perf-read-vdso32 and perf-read-vdsox32 to .gitignore
      perf tools: Only override the default :tid comm entry
      perf header: Add Instruction Tracing feature
      perf evlist: Add initial support for mmapping an Instruction Trace buffer
      perf tools: Add user events for Instruction Tracing
      perf tools: Add support for Instruction Trace recording
      perf record: Add basic Instruction Tracing support
      perf record: Extend -m option for Instruction Tracing mmap pages
      perf tools: Add a user event for Instruction Tracing errors
      perf session: Add hooks to allow transparent decoding of Instruction Tracing data
      perf session: Add Instruction Tracing options
      perf itrace: Add helpers for Instruction Tracing errors
      perf itrace: Add helpers for queuing Instruction Tracing data
      perf itrace: Add a heap for sorting Instruction Tracing queues
      perf itrace: Add processing for Instruction Tracing events
      perf itrace: Add a hashtable for caching decoded instructions
      perf tools: Add member to struct dso for an instruction cache
      perf script: Add Instruction Tracing support
      perf script: Always allow fields 'addr' and 'cpu' for itrace
      perf report: Add Instruction Tracing support
      perf inject: Re-pipe Instruction Tracing events
      perf inject: Add Instruction Tracing support
      perf tools: Add Instruction Tracing index
      perf tools: Hit all build ids when Instruction Tracing

 tools/perf/.gitignore                    |    2 +
 tools/perf/Documentation/perf-inject.txt |   27 +
 tools/perf/Documentation/perf-record.txt |    2 +
 tools/perf/Documentation/perf-report.txt |   28 +
 tools/perf/Documentation/perf-script.txt |   28 +
 tools/perf/Makefile.perf                 |    2 +
 tools/perf/builtin-buildid-list.c        |    9 +
 tools/perf/builtin-inject.c              |  157 +++-
 tools/perf/builtin-record.c              |  173 +++-
 tools/perf/builtin-report.c              |   12 +
 tools/perf/builtin-script.c              |   39 +-
 tools/perf/perf.h                        |    2 +
 tools/perf/util/dso.c                    |    2 +
 tools/perf/util/dso.h                    |    3 +
 tools/perf/util/event.c                  |    3 +
 tools/perf/util/event.h                  |   38 +
 tools/perf/util/evlist.c                 |   80 +-
 tools/perf/util/evlist.h                 |    6 +
 tools/perf/util/header.c                 |   36 +
 tools/perf/util/header.h                 |    1 +
 tools/perf/util/itrace.c                 | 1255 ++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h                 |  447 +++++++++++
 tools/perf/util/record.c                 |   11 +-
 tools/perf/util/session.c                |  148 +++-
 tools/perf/util/session.h                |    6 +
 tools/perf/util/thread.c                 |    5 +-
 tools/perf/util/tool.h                   |   10 +-
 27 files changed, 2481 insertions(+), 51 deletions(-)
 create mode 100644 tools/perf/util/itrace.c
 create mode 100644 tools/perf/util/itrace.h


Regards
Adrian
