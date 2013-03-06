Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3CFXV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:21:57 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:57054 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3CFXV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:21:56 -0500
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] rwsem fast-path write lock stealing
Date: Wed,  6 Mar 2013 15:21:39 -0800
Message-Id: <1362612111-28673-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches extend Alex Shi's work (which added write lock stealing
on the rwsem slow path) in order to provide rwsem write lock stealing
on the fast path (that is, without taking the rwsem's wait_lock).

I initially sent a shorter series shortly before v3.9, however some
patches were doing too much at once which made them confusing to
review. I have now split the series at a smaller granularity;
hope this will help :)

Patches 1-2 are for cleanups:

- Patch 1 replaces the waiter type bitmask with an enumeration
  (as we don't have any other planned uses for the bitmap)

- Patch 2 shortens critical sections in rwsem_down_failed_common() so
  they don't cover more than what is absolutely necessary

Patches 3-5 splits rwsem_down_failed_common() into separate functions
for the read and write sides:

- Patch 3 simply puts two identical copies of rwsem_down_failed_common()
  into rwsem_down_{read,write}_failed (no code changes, in order to
  make the review easier)

- Patch 4 does easy simplifications in rwsem_down_read_failed():
  - We don't need to wake readers queued before us;
  - We don't need to try to steal the lock, and thus we don't need to
    acquire the wait_lock after sleeping.

- Patch 5 does easy simplifications in rwsem_down_write_failed():
  - We don't need to check for !waiter.task since __rwsem_do_wake()
    doesn't remove writers from the wait_list;
  - Since the only way to exit the wait loop is by stealing the write lock,
    the corresponding exit code can be moved after the loop;
  - There is no point releaseing the wait_lock before entering the
    wait loop, as we will need to reacquire it immediately;
  - We don't need to get a reference on the task structure, since the task
    is responsible for removing itself from the wait_list;

Patches 6-9 apply additional optimizations to rwsem_down_write_failed():

- Patch 6 tries write lock stealing more aggressively in order to avoid
  extra checks;

- Patch 7 uses cmpxchg to implement the write lock stealing, instead of
  doing an additive adjustment that might need to be backed out;

- Patch 8 avoids taking the wait_lock if there are already active locks
  when we wake up;

- Patch 9 avoids the initial trylock if there were already active locks
  when we entered rwsem_down_write_failed()

Patches 10-11 wake all readers whenever the first waiter is a reader:

- Patch 10 does this in rwsem-spinlock. This is both for symetry with
  the other rwsem implementation, and because this should result in
  increased parallelism for workloads that mix readers and writers.

- Patch 11 does this in rwsem. This is partly for increased parallelism,
  but the main reason is that it gets rid of a case where __rwsem_do_wake
  assumed that the rwsem lock can't be stolen when it holds the wait_lock
  and the rwsem count indicates there are queued waiters. This assumption
  won't be true after patch 12, so we need to fix __rwsem_do_wake and it
  turns out the easiest fix involves waking all readers.

Patch 12 finally implements rwsem fast path lock stealing for x86 arch.

Michel Lespinasse (12):
  rwsem: make the waiter type an enumeration rather than a bitmask
  rwsem: shorter spinlocked section in rwsem_down_failed_common()
  rwsem: move rwsem_down_failed_common code into rwsem_down_{read,write}_failed
  rwsem: simplify rwsem_down_read_failed
  rwsem: simplify rwsem_down_write_failed
  rwsem: more agressive lock stealing in rwsem_down_write_failed
  rwsem: use cmpxchg for trying to steal write lock
  rwsem: avoid taking wait_lock in rwsem_down_write_failed
  rwsem: skip initial trylock in rwsem_down_write_failed
  rwsem-spinlock: wake all readers when first waiter is a reader
  rwsem: wake all readers when first waiter is a reader
  x86 rwsem: avoid taking slow path when stealing write lock

 arch/x86/include/asm/rwsem.h |  28 +++--
 include/linux/rwsem.h        |   2 +
 lib/rwsem-spinlock.c         |  54 ++++-----
 lib/rwsem.c                  | 272 +++++++++++++++++++------------------------
 4 files changed, 166 insertions(+), 190 deletions(-)

-- 
1.8.1.3
