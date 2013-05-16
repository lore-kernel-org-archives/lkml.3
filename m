Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3EPDQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 23:16:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28889 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3EPDQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 23:16:36 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v4 0/9] liblockdep: userspace lockdep
Date: Wed, 15 May 2013 23:15:32 -0400
Message-Id: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.2.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liblockdep is a tiny wrapper built around kernel/lockdep.c. The aim is to
provide the same functionality the kernel gets from lockdep to userspace.

The bulk of the code here is the LD_PRELOAD support which provides users
an easy way to test their code without having to integrate liblockdep into
said code. Simply doing:

        lockdep my_app

Would provide lockdep support to my_app.

There is also a small test suite to test both mutexes and rwlocks, it's
based on the tests in lib/locking-selftest.c.

This entire patch series was reviewed by lockdep maintainers and accepted to
the tip tree previously. It was pulled out so that the potential merge of
liblockdep won't delay the rest of the commits in the tip locking tree.

For some more background about this entire thing, the folks at LWN did
an awesome overview: http://lwn.net/Articles/536363/


Changes from v3:
 - More fixes/suggestions/code from Peter.

Changes from v2:
 - Fix possible build breakage due to recent changes to kernel/lockdep.c

Changes from v1:
 - Addressed Peter's comments.

Sasha Levin (9):
  lockdep: Be nice about building from userspace
  liblockdep: Wrap kernel/lockdep.c to allow usage from userspace
  liblockdep: Add public headers for pthread_mutex_t implementation
  liblockdep: Add pthread_mutex_t test suite
  liblockdep: Add public headers for pthread_rwlock_t implementation
  liblockdep: Add pthread_rwlock_t test suite
  liblockdep: Support using LD_PRELOAD
  liblockdep: Add the 'lockdep' user-space utility
  liblockdep: Add a MAINTAINERS entry

 MAINTAINERS                                        |   5 +
 kernel/lockdep.c                                   |   4 +
 tools/lib/lockdep/Makefile                         | 251 ++++++++++++
 tools/lib/lockdep/common.c                         |  33 ++
 tools/lib/lockdep/include/liblockdep/common.h      |  42 ++
 tools/lib/lockdep/include/liblockdep/mutex.h       |  70 ++++
 tools/lib/lockdep/include/liblockdep/rwlock.h      |  86 ++++
 tools/lib/lockdep/lockdep                          |   3 +
 tools/lib/lockdep/lockdep.c                        |   2 +
 tools/lib/lockdep/lockdep_internals.h              |   1 +
 tools/lib/lockdep/lockdep_states.h                 |   1 +
 tools/lib/lockdep/preload.c                        | 447 +++++++++++++++++++++
 tools/lib/lockdep/rbtree.c                         |   1 +
 tools/lib/lockdep/run_tests.sh                     |  27 ++
 tools/lib/lockdep/tests/AA.c                       |  13 +
 tools/lib/lockdep/tests/ABBA.c                     |  13 +
 tools/lib/lockdep/tests/ABBCCA.c                   |  15 +
 tools/lib/lockdep/tests/ABBCCDDA.c                 |  17 +
 tools/lib/lockdep/tests/ABCABC.c                   |  15 +
 tools/lib/lockdep/tests/ABCDBCDA.c                 |  17 +
 tools/lib/lockdep/tests/ABCDBDDA.c                 |  17 +
 tools/lib/lockdep/tests/WW.c                       |  13 +
 tools/lib/lockdep/tests/common.h                   |  12 +
 tools/lib/lockdep/tests/unlock_balance.c           |  12 +
 tools/lib/lockdep/uinclude/asm/hweight.h           |   0
 tools/lib/lockdep/uinclude/asm/sections.h          |   0
 tools/lib/lockdep/uinclude/linux/bitops.h          |   0
 tools/lib/lockdep/uinclude/linux/compiler.h        |   7 +
 tools/lib/lockdep/uinclude/linux/debug_locks.h     |  12 +
 tools/lib/lockdep/uinclude/linux/delay.h           |   0
 tools/lib/lockdep/uinclude/linux/export.h          |   7 +
 tools/lib/lockdep/uinclude/linux/ftrace.h          |   0
 tools/lib/lockdep/uinclude/linux/gfp.h             |   0
 tools/lib/lockdep/uinclude/linux/hardirq.h         |  11 +
 tools/lib/lockdep/uinclude/linux/hash.h            |   1 +
 tools/lib/lockdep/uinclude/linux/interrupt.h       |   0
 tools/lib/lockdep/uinclude/linux/irqflags.h        |  38 ++
 tools/lib/lockdep/uinclude/linux/kallsyms.h        |  32 ++
 tools/lib/lockdep/uinclude/linux/kern_levels.h     |  25 ++
 tools/lib/lockdep/uinclude/linux/kernel.h          |  37 ++
 tools/lib/lockdep/uinclude/linux/kmemcheck.h       |   8 +
 tools/lib/lockdep/uinclude/linux/linkage.h         |   0
 tools/lib/lockdep/uinclude/linux/list.h            |   1 +
 tools/lib/lockdep/uinclude/linux/lockdep.h         |  55 +++
 tools/lib/lockdep/uinclude/linux/mm_types.h        |   0
 tools/lib/lockdep/uinclude/linux/module.h          |   6 +
 tools/lib/lockdep/uinclude/linux/mutex.h           |   0
 tools/lib/lockdep/uinclude/linux/poison.h          |   1 +
 tools/lib/lockdep/uinclude/linux/prefetch.h        |   6 +
 tools/lib/lockdep/uinclude/linux/proc_fs.h         |   0
 tools/lib/lockdep/uinclude/linux/rbtree.h          |   1 +
 .../lib/lockdep/uinclude/linux/rbtree_augmented.h  |   2 +
 tools/lib/lockdep/uinclude/linux/rcu.h             |  16 +
 tools/lib/lockdep/uinclude/linux/seq_file.h        |   0
 tools/lib/lockdep/uinclude/linux/spinlock.h        |  25 ++
 tools/lib/lockdep/uinclude/linux/stacktrace.h      |  32 ++
 tools/lib/lockdep/uinclude/linux/stringify.h       |   7 +
 tools/lib/lockdep/uinclude/linux/system.h          |   0
 tools/lib/lockdep/uinclude/linux/types.h           |  58 +++
 tools/lib/lockdep/uinclude/linux/util.h            |   0
 tools/lib/lockdep/uinclude/trace/events/lock.h     |   0
 61 files changed, 1505 insertions(+)
 create mode 100644 tools/lib/lockdep/Makefile
 create mode 100644 tools/lib/lockdep/common.c
 create mode 100644 tools/lib/lockdep/include/liblockdep/common.h
 create mode 100644 tools/lib/lockdep/include/liblockdep/mutex.h
 create mode 100644 tools/lib/lockdep/include/liblockdep/rwlock.h
 create mode 100755 tools/lib/lockdep/lockdep
 create mode 100644 tools/lib/lockdep/lockdep.c
 create mode 100644 tools/lib/lockdep/lockdep_internals.h
 create mode 100644 tools/lib/lockdep/lockdep_states.h
 create mode 100644 tools/lib/lockdep/preload.c
 create mode 100644 tools/lib/lockdep/rbtree.c
 create mode 100755 tools/lib/lockdep/run_tests.sh
 create mode 100644 tools/lib/lockdep/tests/AA.c
 create mode 100644 tools/lib/lockdep/tests/ABBA.c
 create mode 100644 tools/lib/lockdep/tests/ABBCCA.c
 create mode 100644 tools/lib/lockdep/tests/ABBCCDDA.c
 create mode 100644 tools/lib/lockdep/tests/ABCABC.c
 create mode 100644 tools/lib/lockdep/tests/ABCDBCDA.c
 create mode 100644 tools/lib/lockdep/tests/ABCDBDDA.c
 create mode 100644 tools/lib/lockdep/tests/WW.c
 create mode 100644 tools/lib/lockdep/tests/common.h
 create mode 100644 tools/lib/lockdep/tests/unlock_balance.c
 create mode 100644 tools/lib/lockdep/uinclude/asm/hweight.h
 create mode 100644 tools/lib/lockdep/uinclude/asm/sections.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/bitops.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/compiler.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/debug_locks.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/delay.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/export.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/ftrace.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/gfp.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/hardirq.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/hash.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/interrupt.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/irqflags.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/kallsyms.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/kern_levels.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/kernel.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/kmemcheck.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/linkage.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/list.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/lockdep.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/mm_types.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/module.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/mutex.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/poison.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/prefetch.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/proc_fs.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/rbtree.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/rbtree_augmented.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/rcu.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/seq_file.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/spinlock.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/stacktrace.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/stringify.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/system.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/types.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/util.h
 create mode 100644 tools/lib/lockdep/uinclude/trace/events/lock.h

-- 
1.8.2.1

