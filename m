Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab3GDBwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:52:49 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:2865 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab3GDBws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:52:48 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 0/4] seqlock: Add new blocking reader type & use rwlock
Date: Wed,  3 Jul 2013 21:52:14 -0400
Message-Id: <1372902738-30693-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During some perf-record sessions of the kernel running the high_systime
workload of the AIM7 benchmark, it was found that quite a large portion
of the spinlock contention was due to the perf_event_mmap_event()
function itself. This perf kernel function calls d_path() which,
in turn, call path_get() and dput() indirectly. These 3 functions
were the hottest functions shown in the perf-report output of
the _raw_spin_lock() function in an 8-socket system with 80 cores
(hyperthreading off) with a 3.10-rc1 kernel:

-  13.91%           reaim  [kernel.kallsyms]     [k] _raw_spin_lock
   - _raw_spin_lock
      + 35.54% path_get
      + 34.85% dput
      + 19.49% d_path

In fact, the output of the "perf record -s -a" (without call-graph)
showed:

 13.37%           reaim  [kernel.kallsyms]     [k] _raw_spin_lock
  7.61%              ls  [kernel.kallsyms]     [k] _raw_spin_lock
  3.54%            true  [kernel.kallsyms]     [k] _raw_spin_lock

Without using the perf monitoring tool, the actual execution profile
will be quite different. In fact, with this patch set and my other
lockless reference count update patch applied, the output of the same
"perf record -s -a" command became:

  2.82%           reaim  [kernel.kallsyms]     [k] _raw_spin_lock
  1.11%              ls  [kernel.kallsyms]     [k] _raw_spin_lock
  0.26%            true  [kernel.kallsyms]     [k] _raw_spin_lock

So the time spent on _raw_spin_lock() function went down from 24.52%
to 4.19%. It can be seen that the performance data collected by the
perf-record command can be heavily skewed in some cases on a system
with a large number of CPUs. This set of patches enables the perf
command to give a more accurate and reliable picture of what is really
happening in the system. At the same time, they can also improve the
general performance of systems especially those with a large number
of CPUs.

The d_path() function takes the following two locks:

1. dentry->d_lock [spinlock] from dget()/dget_parent()/dput()
2. rename_lock    [seqlock]  from d_path()

This set of patches address the rename_lock bottleneck by changing the
way seqlock is implemented so that we can optionally use a read/write
lock as the underlying implementation instead of the default spinlock.

Incidentally, this patch also provides slight 5% performance boost
over just the the lockless reference count update patch in the short
workload of the AIM7 benchmark running on a 8-socket 80-core DL980
machine on a 3.10-based kernel. There were still a few percentage
points of contention in d_path() and getcwd syscall left due to their
use of the rename_lock.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (4):
  seqlock: Add a new blocking reader type
  dcache: Use blocking reader seqlock when protected data are not
    changed
  seqlock: Allow the use of rwlock in seqlock
  dcache: Use rwlock as the underlying lock in rename_lock

 fs/dcache.c             |   28 ++++----
 include/linux/seqlock.h |  167 ++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 158 insertions(+), 37 deletions(-)

