Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3BAEs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:48:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23324 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3BAEs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:48:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: paulus@samba.org, acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 0/7] liblock: userspace lockdep
Date: Thu, 31 Jan 2013 23:47:31 -0500
Message-Id: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a userspace lock correctnes validator into
tools/lib/liblock.

There are no changes to any kernel code whatsoever, lockdep is
being used as is.

First 6 patches are the liblock implementation, the last one is
an example of liblock being used on an existing codebase.


Sasha Levin (7):
  liblock: wrap kernel/lockdep.c to allow usage from userspace
  liblock: public headers for mutex implementation
  liblock: mutex test suite
  liblock: public headers for rwlock implementation
  liblock: rwlock test suite
  liblock: add a MAINTAINERS entry
  perf: integrate liblock support into perf

 MAINTAINERS                                    |   5 +
 tools/lib/liblock/Makefile                     | 247 +++++++++++++++++++++++++
 tools/lib/liblock/common.c                     |  22 +++
 tools/lib/liblock/include/liblock/common.h     |  42 +++++
 tools/lib/liblock/include/liblock/mutex.h      |  62 +++++++
 tools/lib/liblock/include/liblock/rwlock.h     |  78 ++++++++
 tools/lib/liblock/lockdep.c                    |   2 +
 tools/lib/liblock/lockdep_internals.h          |   1 +
 tools/lib/liblock/lockdep_states.h             |   1 +
 tools/lib/liblock/run_tests.sh                 |  16 ++
 tools/lib/liblock/tests/AA.c                   |  16 ++
 tools/lib/liblock/tests/ABBA.c                 |  16 ++
 tools/lib/liblock/tests/ABBCCA.c               |  18 ++
 tools/lib/liblock/tests/ABBCCDDA.c             |  20 ++
 tools/lib/liblock/tests/ABCABC.c               |  18 ++
 tools/lib/liblock/tests/ABCDBCDA.c             |  20 ++
 tools/lib/liblock/tests/ABCDBDDA.c             |  20 ++
 tools/lib/liblock/tests/WW.c                   |  16 ++
 tools/lib/liblock/tests/common.h               |  11 ++
 tools/lib/liblock/tests/unlock_balance.c       |  15 ++
 tools/lib/liblock/uinclude/asm/hweight.h       |   0
 tools/lib/liblock/uinclude/asm/sections.h      |   0
 tools/lib/liblock/uinclude/linux/bitops.h      |   0
 tools/lib/liblock/uinclude/linux/compiler.h    |   7 +
 tools/lib/liblock/uinclude/linux/debug_locks.h |  12 ++
 tools/lib/liblock/uinclude/linux/delay.h       |   0
 tools/lib/liblock/uinclude/linux/export.h      |   7 +
 tools/lib/liblock/uinclude/linux/ftrace.h      |   0
 tools/lib/liblock/uinclude/linux/gfp.h         |   0
 tools/lib/liblock/uinclude/linux/hardirq.h     |  11 ++
 tools/lib/liblock/uinclude/linux/hash.h        |   1 +
 tools/lib/liblock/uinclude/linux/interrupt.h   |   0
 tools/lib/liblock/uinclude/linux/irqflags.h    |  38 ++++
 tools/lib/liblock/uinclude/linux/kallsyms.h    |  32 ++++
 tools/lib/liblock/uinclude/linux/kernel.h      |  34 ++++
 tools/lib/liblock/uinclude/linux/kmemcheck.h   |   8 +
 tools/lib/liblock/uinclude/linux/linkage.h     |   0
 tools/lib/liblock/uinclude/linux/list.h        |   1 +
 tools/lib/liblock/uinclude/linux/lockdep.h     |  58 ++++++
 tools/lib/liblock/uinclude/linux/mm_types.h    |   0
 tools/lib/liblock/uinclude/linux/module.h      |   6 +
 tools/lib/liblock/uinclude/linux/mutex.h       |   0
 tools/lib/liblock/uinclude/linux/poison.h      |   1 +
 tools/lib/liblock/uinclude/linux/prefetch.h    |   6 +
 tools/lib/liblock/uinclude/linux/proc_fs.h     |   0
 tools/lib/liblock/uinclude/linux/rcu.h         |  16 ++
 tools/lib/liblock/uinclude/linux/seq_file.h    |   0
 tools/lib/liblock/uinclude/linux/spinlock.h    |  25 +++
 tools/lib/liblock/uinclude/linux/stacktrace.h  |  31 ++++
 tools/lib/liblock/uinclude/linux/stringify.h   |   7 +
 tools/lib/liblock/uinclude/linux/system.h      |   0
 tools/lib/liblock/uinclude/linux/types.h       |  58 ++++++
 tools/lib/liblock/uinclude/linux/util.h        |   0
 tools/lib/liblock/uinclude/trace/events/lock.h |   0
 tools/perf/Makefile                            |  22 +++
 tools/perf/builtin-sched.c                     |  31 ++--
 tools/perf/builtin-top.c                       |  19 +-
 tools/perf/config/feature-tests.mak            |  12 ++
 tools/perf/perf.c                              |   4 +
 tools/perf/ui/browser.c                        |  21 ++-
 tools/perf/ui/browsers/annotate.c              |  10 +-
 tools/perf/ui/setup.c                          |   4 +-
 tools/perf/ui/tui/helpline.c                   |   4 +-
 tools/perf/ui/tui/progress.c                   |   4 +-
 tools/perf/ui/tui/setup.c                      |   4 +-
 tools/perf/ui/tui/util.c                       |   4 +-
 tools/perf/ui/ui.h                             |   3 +-
 tools/perf/util/annotate.c                     |   6 +-
 tools/perf/util/annotate.h                     |   3 +-
 tools/perf/util/evsel.c                        |   2 +-
 tools/perf/util/hist.c                         |   8 +-
 tools/perf/util/hist.h                         |   3 +-
 tools/perf/util/liblock.h                      |  17 ++
 73 files changed, 1128 insertions(+), 58 deletions(-)
 create mode 100644 tools/lib/liblock/Makefile
 create mode 100644 tools/lib/liblock/common.c
 create mode 100644 tools/lib/liblock/include/liblock/common.h
 create mode 100644 tools/lib/liblock/include/liblock/mutex.h
 create mode 100644 tools/lib/liblock/include/liblock/rwlock.h
 create mode 100644 tools/lib/liblock/lockdep.c
 create mode 100644 tools/lib/liblock/lockdep_internals.h
 create mode 100644 tools/lib/liblock/lockdep_states.h
 create mode 100755 tools/lib/liblock/run_tests.sh
 create mode 100644 tools/lib/liblock/tests/AA.c
 create mode 100644 tools/lib/liblock/tests/ABBA.c
 create mode 100644 tools/lib/liblock/tests/ABBCCA.c
 create mode 100644 tools/lib/liblock/tests/ABBCCDDA.c
 create mode 100644 tools/lib/liblock/tests/ABCABC.c
 create mode 100644 tools/lib/liblock/tests/ABCDBCDA.c
 create mode 100644 tools/lib/liblock/tests/ABCDBDDA.c
 create mode 100644 tools/lib/liblock/tests/WW.c
 create mode 100644 tools/lib/liblock/tests/common.h
 create mode 100644 tools/lib/liblock/tests/unlock_balance.c
 create mode 100644 tools/lib/liblock/uinclude/asm/hweight.h
 create mode 100644 tools/lib/liblock/uinclude/asm/sections.h
 create mode 100644 tools/lib/liblock/uinclude/linux/bitops.h
 create mode 100644 tools/lib/liblock/uinclude/linux/compiler.h
 create mode 100644 tools/lib/liblock/uinclude/linux/debug_locks.h
 create mode 100644 tools/lib/liblock/uinclude/linux/delay.h
 create mode 100644 tools/lib/liblock/uinclude/linux/export.h
 create mode 100644 tools/lib/liblock/uinclude/linux/ftrace.h
 create mode 100644 tools/lib/liblock/uinclude/linux/gfp.h
 create mode 100644 tools/lib/liblock/uinclude/linux/hardirq.h
 create mode 100644 tools/lib/liblock/uinclude/linux/hash.h
 create mode 100644 tools/lib/liblock/uinclude/linux/interrupt.h
 create mode 100644 tools/lib/liblock/uinclude/linux/irqflags.h
 create mode 100644 tools/lib/liblock/uinclude/linux/kallsyms.h
 create mode 100644 tools/lib/liblock/uinclude/linux/kernel.h
 create mode 100644 tools/lib/liblock/uinclude/linux/kmemcheck.h
 create mode 100644 tools/lib/liblock/uinclude/linux/linkage.h
 create mode 100644 tools/lib/liblock/uinclude/linux/list.h
 create mode 100644 tools/lib/liblock/uinclude/linux/lockdep.h
 create mode 100644 tools/lib/liblock/uinclude/linux/mm_types.h
 create mode 100644 tools/lib/liblock/uinclude/linux/module.h
 create mode 100644 tools/lib/liblock/uinclude/linux/mutex.h
 create mode 100644 tools/lib/liblock/uinclude/linux/poison.h
 create mode 100644 tools/lib/liblock/uinclude/linux/prefetch.h
 create mode 100644 tools/lib/liblock/uinclude/linux/proc_fs.h
 create mode 100644 tools/lib/liblock/uinclude/linux/rcu.h
 create mode 100644 tools/lib/liblock/uinclude/linux/seq_file.h
 create mode 100644 tools/lib/liblock/uinclude/linux/spinlock.h
 create mode 100644 tools/lib/liblock/uinclude/linux/stacktrace.h
 create mode 100644 tools/lib/liblock/uinclude/linux/stringify.h
 create mode 100644 tools/lib/liblock/uinclude/linux/system.h
 create mode 100644 tools/lib/liblock/uinclude/linux/types.h
 create mode 100644 tools/lib/liblock/uinclude/linux/util.h
 create mode 100644 tools/lib/liblock/uinclude/trace/events/lock.h
 create mode 100644 tools/perf/util/liblock.h

-- 
1.8.1.1

