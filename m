Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab3GQRur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933414Ab3GQRuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:50:44 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [RFC 0/23] perf tool: Add support for multiple data file storage
Date: Wed, 17 Jul 2013 19:49:40 +0200
Message-Id: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this *RFC* adds support for record command to split perf
data file output into multiple files. Each such data file
is fully-fledged and readable upon by any perf command.

This patchset is actually doing 3 essential things:
  1) adds new perf data format version (v3)
  2) adds class/object to handle perf data file
  3) adds record '-M size' option

ad 1) Along the way I realized it'd be much easier to have the
      format simplified. I ended up with just 'DATA' and 'FEATURES'
      sections making the file format more generic.

      The easier/generic format will be for example useful for the
      cpu hotplug notification (and maybe even for ftrace data files
      features?)

      The version 2 should be still readable by perf, while it
      produces data in version 3 from this patchset onwards.

ad 2) I needed to unify perf data file handling to make the -M
      implementation clear.

Loose ends/TODO/ideas.. like:
  - test/fix bugs
  - more automated tests for version 2 data reading so we're
    sure we don't break v2 compatibility.
  - record '-M time'
  - separate work thread to finish the data file (write header),
    while record command continues to poll/read/store to new file
  - perf daemon running on background storing continuously data 
  - perf top storing data on key press

It's reachable here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/file22

thanks for comments,
jirka


Example:
  $ ./perf record -M 100000 -e cycles:u yes > /dev/null
  ^C[ perf record: Woken up 25 times to write data ]
  [ perf record: Captured and wrote 0.630 MB perf-[0-7].data(~27531 samples) ]
  yes: Interrupt
  $ ls -l perf-0000*
  -rw------- 1 jolsa jolsa 111828 Jul 17 18:23 perf-00000.data
  -rw------- 1 jolsa jolsa 115240 Jul 17 18:23 perf-00001.data
  -rw------- 1 jolsa jolsa 112020 Jul 17 18:23 perf-00002.data
  -rw------- 1 jolsa jolsa 112020 Jul 17 18:23 perf-00003.data
  -rw------- 1 jolsa jolsa 112120 Jul 17 18:23 perf-00004.data
  -rw------- 1 jolsa jolsa 112120 Jul 17 18:23 perf-00005.data
  -rw------- 1 jolsa jolsa  18900 Jul 17 18:23 perf-00006.data
  $ ./perf diff perf-0000*
  # Event 'cycles:u'
  #
  # Data files:
  #  [0] perf-00000.data (Baseline)
  #  [1] perf-00001.data
  #  [2] perf-00002.data
  #  [3] perf-00003.data
  #  [4] perf-00004.data
  #  [5] perf-00005.data
  #  [6] perf-00006.data
  #
  # Baseline/0  Delta/1  Delta/2  Delta/3  Delta/4  Delta/5  Delta/6      Shared Object                              Symbol
  # ..........  .......  .......  .......  .......  .......  .......  .................  ..................................
  #
        37.03%   +1.23%   +0.12%   +0.61%   +1.12%   +0.93%   -7.53%  libc-2.15.so       [.] _IO_file_xsputn@@GLIBC_2.2.5
        31.40%   -0.55%   -0.79%   -1.00%   -0.66%   -0.59%   +4.09%  yes                [.] main
        16.36%   -0.18%   +1.39%   +1.07%   +0.66%   +0.23%   +1.72%  libc-2.15.so       [.] __strlen_sse2
        14.66%   -0.61%   -0.81%   -0.58%   -1.18%   -0.26%   +1.66%  libc-2.15.so       [.] fputs_unlocked
         0.24%   +0.34%   +0.27%   +0.08%   +0.24%   -0.12%   +0.35%  yes                [.] fputs_unlocked@plt
         0.12%                     -0.08%   -0.08%   -0.08%           libc-2.15.so       [.] _IO_file_write@@GLIBC_2.2.5
         0.08%                                                        libc-2.15.so       [.] new_do_write
         0.04%                                                        libc-2.15.so       [.] _IO_default_xsputn
  ...



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
Jiri Olsa (23):
      perf tools: Use session->fd instead of passing fd as argument
      perf tools: Remove data_offset seek as it's not needed
      perf tools: Remove attr_offset from perf_header
      perf tools: Introduce feat_offset into perf_header
      perf tests: Add simple session read/write test
      perf doc: Add perf data file documentation
      perf tools: Recognize version number for perf data file
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
      perf tools: Move synthetizing into single function
      perf tools: Add data object to handle perf data file
      perf tools: Add perf_data_file__open interface to data object
      perf tools: Separating data file properties from session
      perf tools: Add multi file '-M' option for record command
      perf tools: Have the process properly sythesized in subsequent data files

 tools/perf/Documentation/perf-data-file-v2.txt | 256 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/Documentation/perf-data-file-v3.txt |  60 ++++++++++++
 tools/perf/Makefile                            |   2 +
 tools/perf/builtin-annotate.c                  |  11 ++-
 tools/perf/builtin-buildid-cache.c             |   8 +-
 tools/perf/builtin-buildid-list.c              |  11 ++-
 tools/perf/builtin-diff.c                      |  19 ++--
 tools/perf/builtin-evlist.c                    |   7 +-
 tools/perf/builtin-inject.c                    |   9 +-
 tools/perf/builtin-kmem.c                      |   7 +-
 tools/perf/builtin-kvm.c                       |   8 +-
 tools/perf/builtin-lock.c                      |   8 +-
 tools/perf/builtin-mem.c                       |   9 +-
 tools/perf/builtin-record.c                    | 400 +++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
 tools/perf/builtin-report.c                    |  18 +++-
 tools/perf/builtin-sched.c                     |   6 +-
 tools/perf/builtin-script.c                    |  16 ++-
 tools/perf/builtin-timechart.c                 |  10 +-
 tools/perf/builtin-top.c                       |   7 +-
 tools/perf/perf.h                              |   2 +-
 tools/perf/tests/builtin-test.c                |   4 +
 tools/perf/tests/session-simple.c              | 275 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                       |   1 +
 tools/perf/util/data.c                         | 120 +++++++++++++++++++++++
 tools/perf/util/data.h                         |  48 +++++++++
 tools/perf/util/evsel.c                        |   5 +
 tools/perf/util/header.c                       | 450 +++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------
 tools/perf/util/header.h                       |  49 +++++++---
 tools/perf/util/session.c                      | 116 ++++++++--------------
 tools/perf/util/session.h                      |  11 +--
 30 files changed, 1501 insertions(+), 452 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-data-file-v2.txt
 create mode 100644 tools/perf/Documentation/perf-data-file-v3.txt
 create mode 100644 tools/perf/tests/session-simple.c
 create mode 100644 tools/perf/util/data.c
 create mode 100644 tools/perf/util/data.h
