Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3FZW1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:27:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:33289 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab3FZW1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:27:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,947,1363158000"; 
   d="scan'208";a="336051848"
Subject: [PATCH v4 0/5] rwsem: performance enhancements for systems with
 many cores
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@intel.com>,
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
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jun 2013 15:27:50 -0700
Message-ID: <1372285670.22432.140.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a couple more bugs from version 3 of the patchset.

In this patchset, we introduce two optimizations to read write semaphore.
The first optimization reduces cache bouncing of the sem->count field
by doing a pre-read of the sem->count and avoid cmpxchg if possible.
The second optimization introduces similar optimistic spinning logic in
the mutex code for the writer lock acquisition of rw-sem.

Combining the two patches, in testing by Davidlohr Bueso on aim7 workloads
on 8 socket 80 cores system, he saw improvements of
alltests (+14.5%), custom (+17%), disk (+11%), high_systime
(+5%), shared (+15%) and short (+4%), most of them after around 500
users when i_mmap was implemented as rwsem.

Feedbacks on the effectiveness of these tweaks on other workloads
will be appreciated.  Thanks to Peter Hurley and Peter Zijlstra
for reviewing this patchset.

I have left the optimistic spining on write lock acquisition not as a default
option.  I'll like people's opinion to see if it should be on by default
to get more testing. 

Changelog:

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

Tim Chen (1):
  rwsem: do optimistic spinning for writer lock acquisition

 include/asm-generic/rwsem.h |    8 +-
 include/linux/rwsem.h       |    3 +
 init/Kconfig                |    9 ++
 kernel/rwsem.c              |   29 +++++++-
 lib/rwsem.c                 |  175 ++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 199 insertions(+), 25 deletions(-)

-- 
1.7.4.4


