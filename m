Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3IAKhE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:37:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077Ab3IAKhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:37:00 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCHv2 00/25] perf tool: Add support for multiple data file storage
Date: Sun,  1 Sep 2013 12:36:11 +0200
Message-Id: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending the support for multiple file storage. Initial
RFC is here:
http://marc.info/?l=linux-kernel&m=137408381902423&w=2

v2 changes:
  - reworked perf mmap size setup to be able to get
    the mmap size value easily later
  - added perf.data read/write test for v2 and v3
    for both endianity
  - added record '-M time' support

It's reachable here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/core_file

thanks,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
Jiri Olsa (25):
      perf tools: Check mmap pages value early
      perf tools: Add possibility to specify mmap size
      perf tools: Introduce perf_evlist__new_default function
      perf tools: Adding throttle event data struct support
      perf tests: Add simple session read/write test
      perf tests: Add session reading test for little endian perf data
      perf tests: Add session reading test for big endian perf data
      perf doc: Add perf data file documentation
      perf tools: Introduce perf data file version CHECK macro
      perf tools: Introduce swap_features function
      perf tools: Introduce swap_header function
      perf tools: Separate version 2 specific perf data header bits
      perf tools: Using evlist as a holder for event_desc feature
      perf tools: Introduce perf.data version 3 format
      perf tools: Add perf data version 3 header swap
      perf tools: Add perf data version 3 header read
      perf tools: Add perf.data version 3 header write
      perf tools: Get rid of post_processing_offset in record command
      perf tools: Move synthesizing into single function
      perf tools: Add perf_data_file__open interface to data object
      perf tools: Separating data file properties from session
      perf tests: Add session reading test for little endian perf data v3
      perf tests: Add session reading test for big endian perf data v3
      perf tools: Add multi file '-M' option for record command
      perf tools: Have the process properly sythesized in subsequent data files

 tools/perf/Documentation/perf-data-file-v2.txt | 265 ++++++++++++++++++++++++++++++++++
 tools/perf/Documentation/perf-data-file-v3.txt |  63 ++++++++
 tools/perf/Documentation/perf-kvm.txt          |   4 +-
 tools/perf/Documentation/perf-record.txt       |  18 ++-
 tools/perf/Documentation/perf-top.txt          |   4 +-
 tools/perf/Documentation/perf-trace.txt        |   4 +-
 tools/perf/Makefile                            |   6 +
 tools/perf/builtin-annotate.c                  |  11 +-
 tools/perf/builtin-buildid-cache.c             |   8 +-
 tools/perf/builtin-buildid-list.c              |  11 +-
 tools/perf/builtin-diff.c                      |  19 ++-
 tools/perf/builtin-evlist.c                    |   7 +-
 tools/perf/builtin-inject.c                    |  10 +-
 tools/perf/builtin-kmem.c                      |   7 +-
 tools/perf/builtin-kvm.c                       |  18 ++-
 tools/perf/builtin-lock.c                      |   8 +-
 tools/perf/builtin-mem.c                       |   9 +-
 tools/perf/builtin-record.c                    | 484 ++++++++++++++++++++++++++++++++++++++++++++------------------
 tools/perf/builtin-report.c                    |  18 ++-
 tools/perf/builtin-sched.c                     |   6 +-
 tools/perf/builtin-script.c                    |  17 ++-
 tools/perf/builtin-timechart.c                 |  10 +-
 tools/perf/builtin-top.c                       |  12 +-
 tools/perf/builtin-trace.c                     |  13 +-
 tools/perf/perf.h                              |  15 +-
 tools/perf/tests/builtin-test.c                |   4 +
 tools/perf/tests/perf-record.c                 |  12 +-
 tools/perf/tests/perf.data.v2.be.h             | 265 ++++++++++++++++++++++++++++++++++
 tools/perf/tests/perf.data.v2.le.h             | 219 ++++++++++++++++++++++++++++
 tools/perf/tests/perf.data.v3.be.h             | 258 +++++++++++++++++++++++++++++++++
 tools/perf/tests/perf.data.v3.le.h             | 212 +++++++++++++++++++++++++++
 tools/perf/tests/session-simple.c              | 658 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/task-exit.c                   |  14 +-
 tools/perf/tests/tests.h                       |   1 +
 tools/perf/util/data.c                         | 120 ++++++++++++++++
 tools/perf/util/data.h                         |  48 +++++++
 tools/perf/util/event.h                        |   7 +
 tools/perf/util/evlist.c                       |  78 ++++++++--
 tools/perf/util/evlist.h                       |   9 +-
 tools/perf/util/evsel.c                        |  24 ++++
 tools/perf/util/header.c                       | 446 +++++++++++++++++++++++++++++++++------------------------
 tools/perf/util/header.h                       |  31 +++-
 tools/perf/util/python.c                       |   7 -
 tools/perf/util/session.c                      | 138 ++++++++----------
 tools/perf/util/session.h                      |  11 +-
 tools/perf/util/util.c                         |  25 ++++
 tools/perf/util/util.h                         |  14 ++
 47 files changed, 3137 insertions(+), 511 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-data-file-v2.txt
 create mode 100644 tools/perf/Documentation/perf-data-file-v3.txt
 create mode 100644 tools/perf/tests/perf.data.v2.be.h
 create mode 100644 tools/perf/tests/perf.data.v2.le.h
 create mode 100644 tools/perf/tests/perf.data.v3.be.h
 create mode 100644 tools/perf/tests/perf.data.v3.le.h
 create mode 100644 tools/perf/tests/session-simple.c
 create mode 100644 tools/perf/util/data.c
 create mode 100644 tools/perf/util/data.h
