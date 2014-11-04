Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaKDBRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:17:05 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:32966 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaKDBQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:16:59 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCHSET 0/8] perf tools: Fix build-id matching on vmlinux (v6)
Date: Tue,  4 Nov 2014 10:14:26 +0900
Message-Id: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset addresses possible problem on kernel symbol matching.
Since commit 5b7ba82a7591 ("perf symbols: Load kernel maps before
using"), when perf record process samples to construct build-id table,
it loads kernel map and it replaces dso->long_name.  But perf report
doesn't know about name other than [kernel.kallsyms] it failed to find
existing kernel dso and falls back to running kernel's kallsyms.

So it's possible to report incorrect symbols for kernel functions if
it runs on a different kernel:

Before:

  $ perf report
  # Children      Self  Command  Shared Object      Symbol
  # ........  ........  .......  .................  ...............................
  #
      72.15%     0.00%  swapper  [kernel.kallsyms]  [k] set_curr_task_rt
      72.15%     0.00%  swapper  [kernel.kallsyms]  [k] native_calibrate_tsc
      72.15%     0.00%  swapper  [kernel.kallsyms]  [k] tsc_refine_calibration_work
      71.87%    71.87%  swapper  [kernel.kallsyms]  [k] module_finalize
   ...

After (for the same perf.data):

      72.15%     0.00%  swapper  [kernel.vmlinux]  [k] cpu_startup_entry
      72.15%     0.00%  swapper  [kernel.vmlinux]  [k] arch_cpu_idle
      72.15%     0.00%  swapper  [kernel.vmlinux]  [k] default_idle
      71.87%    71.87%  swapper  [kernel.vmlinux]  [k] native_safe_halt


In this patch, it's now changed to try to search a kernel dso in the
existing dso list which was constructed during build-id table parsing
so it'll always have a build-id.  If not found, search "[kernel.kallsyms]".

The patch 1-2 are to support module compression as some distro
(e.g. Arch) already does it.  The patch 3-5 are cleanup of build-id
handling functions.  The patch 6-7 are the main change of this series
and finally patch 8 is just for suggestion which can be squashed into
the previous patch or simply dropped.

 * changes from v5)
  - keep dsos__hit_all() in util/build-id.c  (Adrian)
  - fix bug in is_kernel_module function  (Jiri)
  - add missing zlib test to test-all.c  (Jiri)
  - move disable_buildid_cache function also


You can get it on 'perf/vmlinux-v6' branch in my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks
Namhyung


Cc: Adrian Hunter <adrian.hunter@intel.com>


Namhyung Kim (8):
  perf tools: Preparation for compressed kernel module support
  perf tools: Add gzip decompression support for kernel module
  perf tools: Rename dsos__write_buildid_table()
  perf build-id: Move build-id related functions to util/build-id.c
  perf tools: Move disable_buildid_cache() to util/build-id.c
  perf record: Do not save pathname in ./debug/.build-id directory for
    vmlinux
  perf tools: Fix build-id matching on vmlinux
  perf tools: Make vmlinux short name more like kallsyms short name

 tools/perf/Makefile.perf                     |   7 +
 tools/perf/builtin-record.c                  |  11 +
 tools/perf/config/Makefile                   |  15 +-
 tools/perf/config/feature-checks/Makefile    |   6 +-
 tools/perf/config/feature-checks/test-all.c  |   5 +
 tools/perf/config/feature-checks/test-zlib.c |   9 +
 tools/perf/util/build-id.c                   | 345 ++++++++++++++++++++++++++
 tools/perf/util/build-id.h                   |  12 +
 tools/perf/util/dso.c                        |  71 ++++++
 tools/perf/util/dso.h                        |   7 +
 tools/perf/util/header.c                     | 353 +--------------------------
 tools/perf/util/header.h                     |   8 +-
 tools/perf/util/machine.c                    |  38 ++-
 tools/perf/util/symbol-elf.c                 |  35 ++-
 tools/perf/util/symbol.c                     |  19 +-
 tools/perf/util/symbol.h                     |   1 +
 tools/perf/util/util.h                       |   6 +-
 tools/perf/util/zlib.c                       |  78 ++++++
 18 files changed, 658 insertions(+), 368 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-zlib.c
 create mode 100644 tools/perf/util/zlib.c

-- 
2.1.2

