Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3COKye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:54:34 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60209 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3COKyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:54:33 -0400
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/13] rwsem fast-path write lock stealing
Date: Fri, 15 Mar 2013 03:54:16 -0700
Message-Id: <1363344869-15732-1-git-send-email-walken@google.com>
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

Patches 10-11 are updates to the __rwsem_do_wake function:

- Patch 10 has simple structure cleanups that don't change the code behavior

- Patch 11 adds generic support for fastpath write lock stealing, by
  removing assumptions the function did about rwsem acquisitions being
  prevented when the rwsem count value indicates there are queued waiters.

Patch 12 fixes a race condition Peter Hurley noticed in reviewing v1 of
this patch series, which resulted in readers sometimes blocking instead
of executing in parallel with other existing readers.

Patch 13 finally implements rwsem fast path lock stealing for x86 arch.

Michel Lespinasse (13):
  rwsem: make the waiter type an enumeration rather than a bitmask
  rwsem: shorter spinlocked section in rwsem_down_failed_common()
  rwsem: move rwsem_down_failed_common code into rwsem_down_{read,write}_failed
  rwsem: simplify rwsem_down_read_failed
  rwsem: simplify rwsem_down_write_failed
  rwsem: more agressive lock stealing in rwsem_down_write_failed
  rwsem: use cmpxchg for trying to steal write lock
  rwsem: avoid taking wait_lock in rwsem_down_write_failed
  rwsem: skip initial trylock in rwsem_down_write_failed
  rwsem: simplify __rwsem_do_wake
  rwsem: implement support for write lock stealing on the fastpath
  rwsem: do not block readers at head of queue if other readers are active
  x86 rwsem: avoid taking slow path when stealing write lock

 arch/x86/include/asm/rwsem.h |  28 +++--
 lib/rwsem-spinlock.c         |  40 +++-----
 lib/rwsem.c                  | 239 +++++++++++++++++++++----------------------
 3 files changed, 154 insertions(+), 153 deletions(-)

Changes since v1:

- Patches 1-9 are unchanged and Patch 13 are unchanged from prior submission.

- v1 series made a change to ordering of reader wakeups which proved more
  controversial than I had anticipated. I reverted this part of the series.
  Patches 10-11 are new and imlement (well, in Patch 11) the minimal changes
  required for supporting fastpath write lock stealing without modifying the
  ordering of reader wakeups (This results in longer code than with the
  prior proposal, though).

- Patch 12 is new, fixing a race condition Peter Hurley noticed while
  reviewing v1 which could result in reduced parallelism between readers.

-- 
1.8.1.3
