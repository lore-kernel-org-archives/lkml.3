Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaHLGku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:40:50 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:41148 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaHLGks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:40:48 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCHSET 00/13] perf tools: Fix vmlinux search path initialization
Date: Tue, 12 Aug 2014 15:40:32 +0900
Message-Id: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently, when perf reports kernel symbols, it tries to look up the
sample ip from kallsyms/vmlinux in the build-id cache, and then a
running kernel.  This can be a problem if it's recorded on a different
kernel and failed to find it from the build-id cache for some reason.

We can fix it by using --symfs option but it's annoying for user to do
it always.  As we already have the kernel version info in the
perf.data file, it'd be better to change it to use the info to search
the correct file automatically.

Minchan Kim reported this during his kernel work.  And this patchset
fixes it by using the recorded kernel info.

The patch 1 and 2 are independent fixes so can be applied separately.
The patch 3 to 12 are preparation for the patch 13 which move
symbol__init() after creating a session.


Before:

  $ perf report
  ...
  # Samples: 4K of event 'cpu-clock'
  # Event count (approx.): 1067250000
  #
  # Overhead  Command     Shared Object      Symbol
  # ........  ..........  .................  ..............................
      71.87%     swapper  [kernel.kallsyms]  [k] recover_probed_instruction

After:

  # Overhead  Command     Shared Object      Symbol
  # ........  ..........  .................  ....................
      71.87%     swapper  [kernel.kallsyms]  [k] native_safe_halt


You can also get it from 'perf/vmlinux-v1' branch on my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome.

Thanks,
Namhyung


Namhyung Kim (13):
  perf script: Fix possible memory leaks
  perf tools: Fix a memory leak in vmlinux_path__init()
  perf annotate: Move session handling out of __cmd_annotate()
  perf buildid-cache: Move session handling into cmd_buildid_cache()
  perf inject: Move session handling out of __cmd_inject()
  perf kmem: Move session handling out of __cmd_kmem()
  perf kvm: Move call to symbol__init() after creating session
  perf lock: Move call to symbol__init() after creating session
  perf sched: Move call to symbol__init() after creating session
  perf script: Move call to symbol__init() after creating session
  perf timechart: Move call to symbol__init() after creating session
  perf trace: Move call to symbol__init() after creating session
  perf tools: Check recorded kernel version when finding vmlinux

 tools/perf/builtin-annotate.c      | 75 ++++++++++++++++++++------------------
 tools/perf/builtin-buildid-cache.c | 37 +++++++++++--------
 tools/perf/builtin-diff.c          |  2 +-
 tools/perf/builtin-inject.c        | 31 +++++++++-------
 tools/perf/builtin-kmem.c          | 49 ++++++++++++++-----------
 tools/perf/builtin-kvm.c           |  6 +--
 tools/perf/builtin-lock.c          |  3 +-
 tools/perf/builtin-mem.c           |  2 +-
 tools/perf/builtin-record.c        |  2 +-
 tools/perf/builtin-report.c        |  2 +-
 tools/perf/builtin-sched.c         |  3 +-
 tools/perf/builtin-script.c        | 40 ++++++++++++--------
 tools/perf/builtin-timechart.c     |  4 +-
 tools/perf/builtin-top.c           |  2 +-
 tools/perf/builtin-trace.c         |  8 ++--
 tools/perf/tests/builtin-test.c    |  2 +-
 tools/perf/util/probe-event.c      |  2 +-
 tools/perf/util/symbol.c           | 26 ++++++++-----
 tools/perf/util/symbol.h           |  3 +-
 19 files changed, 172 insertions(+), 127 deletions(-)

-- 
2.0.0

