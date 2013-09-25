Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3IYWKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:10:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:28802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3IYWKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:10:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,981,1371106800"; 
   d="scan'208";a="383568205"
Subject: [PATCH v6 0/6] rwsem: performance optimizations
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Sep 2013 15:10:28 -0700
Message-ID: <1380147028.3467.62.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fixed a missing file and fixed various style issues for
version 6 of this patchset. We will like to have it merged if
there are no objections.

In this patchset, we introduce two categories of optimizations to read
write semaphore.  The first four patches from Alex Shi reduce cache
bouncing of the sem->count field by doing a pre-read of the sem->count
and avoid cmpxchg if possible.

The last two patches introduce similar optimistic spinning logic as the
mutex code for the writer lock acquisition of rwsem. This addresses the
general 'mutexes out perform writer-rwsems' situations that has been
seen in more than one case.  Users now need not worry about performance
issues when choosing between these two locking mechanisms.

Without these optimizations, Davidlohr Bueso saw a -8% regression to
aim7's shared and high_systime workloads when he switched i_mmap_mutex
to rwsem.  Tests were on 8 socket 80 cores system.  With the patchset,
he got significant improvements to the aim7 suite instead of regressions:

alltests (+16.3%), custom (+20%), disk (+19.5%), high_systime (+7%),
shared (+18.4%) and short (+6.3%).

Tim Chen also got a +5% improvements to exim mail server workload on a
40 core system.

Thanks to Ingo Molnar, Peter Hurley and Peter Zijlstra for reviewing
this patchset.

Regards,
Tim Chen

Changelog:

v6:
1. Fix missing mcslock.h file.
2. Fix various code style issues.

v5:
1. Try optimistic spinning before we put the writer on the wait queue
to avoid bottlenecking at wait queue.  This provides 5% boost to exim workload
and between 2% to 8% boost to aim7. 
2. Put MCS locking code into its own mcslock.h file for better reuse
between mutex.c and rwsem.c
3. Remove the configuration RWSEM_SPIN_ON_WRITE_OWNER and make the 
operations default per Ingo's suggestions.

v4:
1. Fixed a bug in task_struct definition in rwsem_can_spin_on_owner
2. Fix another typo for RWSEM_SPIN_ON_WRITE_OWNER config option

v3:
1. Added ACCESS_ONCE to sem->count access in rwsem_can_spin_on_owner.
2. Fix typo bug for RWSEM_SPIN_ON_WRITE_OWNER option in init/Kconfig

v2:
1. Reorganize changes to down_write_trylock and do_wake into 4 patches and fixed
   a bug referencing &sem->count when sem->count is intended.
2. Fix unsafe sem->owner de-reference in rwsem_can_spin_on_owner.
the option to be on for more seasoning but can be turned off should it be detrimental.
3. Various patch comments update

Alex Shi (4):
  rwsem: check the lock before cpmxchg in down_write_trylock
  rwsem: remove 'out' label in do_wake
  rwsem: remove try_reader_grant label do_wake
  rwsem/wake: check lock before do atomic update

Tim Chen (2):
  MCS Lock: Restructure the MCS lock defines and locking code into its
    own file
  rwsem: do optimistic spinning for writer lock acquisition

 include/asm-generic/rwsem.h |    8 +-
 include/linux/mcslock.h     |   58 +++++++++++
 include/linux/rwsem.h       |    6 +-
 kernel/mutex.c              |   58 ++----------
 kernel/rwsem.c              |   19 ++++-
 lib/rwsem.c                 |  228 +++++++++++++++++++++++++++++++++++++-----
 6 files changed, 292 insertions(+), 85 deletions(-)
 create mode 100644 include/linux/mcslock.h

-- 
1.7.4.4


