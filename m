Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3BFWMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:12:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37515 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab3BFWMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:12:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 00/11] lockdep: LD_PRELOAD support
Date: Wed,  6 Feb 2013 17:11:23 -0500
Message-Id: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds in LD_PRELOAD support for liblockdep.

We store lockdep_map in an rb-tree and hook the pthread_mutex/
pthread_rwlock calls, allowing us to add lockdep testing on
any program without touching it's source code.

The first couple of patches remove the need for lockdep_init
and lockdep_set_thread, as well as some fixes for several
tests.

The other patches add rbtree and LD_PRELOAD support, along
with testing for that.

The last patch adds a small script that wraps all of it, making
testing really simple:

	liblockdep perf [perf command line]

There is a case where it won't work well: some programs, such
as firefox, hook malloc() and add a pthread_mutex lock in the
allocation path, which recurses back into our liblockdep code.

To solve that I'm planning to add a local cache to allocate
from when liblockdep detects recursion onto itself, but that's
outside of the scope of this patch.

Instead of taking the perf in this series another option would
be to just revert the existing perf patch from me in core/locking,
which would mean perf would just work with the new LD_PRELOAD
feature.


Sasha Levin (11):
  liblockdep: remove the need for liblockdep_init
  liblockdep: remove the need for liblockdep_set_thread
  perf: stop using liblockdep_init and liblockdep_set_thread
  liblockdep: fix AA test
  liblockdep: correct the ABCDBCDA test
  liblockdep: rbtree support
  liblockdep: prevent multiple declarations of CALLER_ADDR0
  liblockdep: keep headers declarations even if lib is disabled
  liblockdep: support using LD_PRELOAD
  liblockdep: add tests for the LD_PRELOAD feature
  liblockdep: preload helper

 tools/lib/lockdep/Makefile                         |  16 +-
 tools/lib/lockdep/common.c                         |  10 +-
 tools/lib/lockdep/include/liblockdep/common.h      |   5 +-
 tools/lib/lockdep/include/liblockdep/mutex.h       |   4 +-
 tools/lib/lockdep/include/liblockdep/rwlock.h      |   4 +-
 tools/lib/lockdep/lockdep                          |   3 +
 tools/lib/lockdep/preload.c                        | 184 +++++++++++++++++++++
 tools/lib/lockdep/rbtree.c                         |   1 +
 tools/lib/lockdep/run_tests.sh                     |  12 ++
 tools/lib/lockdep/tests/AA.c                       |   5 +-
 tools/lib/lockdep/tests/ABBA.c                     |   3 -
 tools/lib/lockdep/tests/ABBCCA.c                   |   3 -
 tools/lib/lockdep/tests/ABBCCDDA.c                 |   3 -
 tools/lib/lockdep/tests/ABCABC.c                   |   3 -
 tools/lib/lockdep/tests/ABCDBCDA.c                 |  13 +-
 tools/lib/lockdep/tests/ABCDBDDA.c                 |   3 -
 tools/lib/lockdep/tests/WW.c                       |   3 -
 tools/lib/lockdep/tests/unlock_balance.c           |   3 -
 tools/lib/lockdep/uinclude/linux/kernel.h          |   2 +
 tools/lib/lockdep/uinclude/linux/lockdep.h         |   5 +-
 tools/lib/lockdep/uinclude/linux/rbtree.h          |   1 +
 .../lib/lockdep/uinclude/linux/rbtree_augmented.h  |   2 +
 tools/perf/builtin-sched.c                         |   2 -
 tools/perf/builtin-top.c                           |   4 -
 tools/perf/config/feature-tests.mak                |   1 -
 tools/perf/perf.c                                  |   3 -
 tools/perf/util/liblockdep.h                       |   2 -
 27 files changed, 236 insertions(+), 64 deletions(-)
 create mode 100755 tools/lib/lockdep/lockdep
 create mode 100644 tools/lib/lockdep/preload.c
 create mode 100644 tools/lib/lockdep/rbtree.c
 create mode 100644 tools/lib/lockdep/uinclude/linux/rbtree.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/rbtree_augmented.h

-- 
1.8.1.2

