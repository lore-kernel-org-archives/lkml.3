Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab3EGNqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:46:08 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40358 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350Ab3EGNqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:05 -0400
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: Alex Shi <alex.shi@intel.com>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/14] rwsem fast-path write lock stealing
Date: Tue,  7 May 2013 06:45:48 -0700
Message-Id: <1367934362-10433-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, I would like you to take this for v3.10.

These patches extend Alex Shi's work (which added write lock stealing
on the rwsem slow path) in order to provide rwsem write lock stealing
on the fast path (that is, without taking the rwsem's wait_lock).

I have unfortunately been unable to push this through -next before due
to Ingo Molnar / David Howells / Peter Zijlstra being busy with other
things. However, this has gotten some attention from Rik van Riel and
Davidlohr Bueso who both commented that they felt this was ready for
v3.10, and Ingo Molnar has said that he was OK with me pushing directly
to you. So, here goes :)


Davidlohr got the following test results from pgbench running on a
quad-core laptop:

| db_size | clients  |  tps-vanilla   |   tps-rwsem  |
+---------+----------+----------------+--------------+
| 160 MB   |       1 |           5803 |         6906 | + 19.0%
| 160 MB   |       2 |          13092 |        15931 |
| 160 MB   |       4 |          29412 |        33021 |
| 160 MB   |       8 |          32448 |        34626 |
| 160 MB   |      16 |          32758 |        33098 |
| 160 MB   |      20 |          26940 |        31343 | + 16.3%
| 160 MB   |      30 |          25147 |        28961 |
| 160 MB   |      40 |          25484 |        26902 |
| 160 MB   |      50 |          24528 |        25760 |
------------------------------------------------------
| 1.6 GB   |       1 |           5733 |         7729 | + 34.8%
| 1.6 GB   |       2 |           9411 |        19009 | + 101.9%
| 1.6 GB   |       4 |          31818 |        33185 |
| 1.6 GB   |       8 |          33700 |        34550 |
| 1.6 GB   |      16 |          32751 |        33079 |
| 1.6 GB   |      20 |          30919 |        31494 |
| 1.6 GB   |      30 |          28540 |        28535 |
| 1.6 GB   |      40 |          26380 |        27054 |
| 1.6 GB   |      50 |          25241 |        25591 |
------------------------------------------------------
| 7.6 GB   |       1 |           5779 |         6224 |
| 7.6 GB   |       2 |          10897 |        13611 | + 24.9%
| 7.6 GB   |       4 |          32683 |        33108 |
| 7.6 GB   |       8 |          33968 |        34712 |
| 7.6 GB   |      16 |          32287 |        32895 |
| 7.6 GB   |      20 |          27770 |        31689 | + 14.1%
| 7.6 GB   |      30 |          26739 |        29003 |
| 7.6 GB   |      40 |          24901 |        26683 |
| 7.6 GB   |      50 |          17115 |        25925 | + 51.5%
------------------------------------------------------

(Davidlohr also has one additional patch which further improves throughput,
though I will ask him to send it directly to you as I have suggested some
minor changes).


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

Patch 14 is a small additional cleanup by Davidlohr Bueso:
"Drop the signed. Just long. It's cleaner."

Davidlohr Bueso (1):
  rwsem: no need for explicit signed longs

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
 lib/rwsem-spinlock.c         |  38 +++----
 lib/rwsem.c                  | 240 +++++++++++++++++++++----------------------
 3 files changed, 153 insertions(+), 153 deletions(-)

Changes from v2:

- Patches 1-13 are unmodified (except for some comments being modified in
  response to code reviews on v2).

- Patch 14 is new as suggested by Peter Hurley and Davidlohr Bueso.

Changes from v1 to v2:

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
1.8.2.1

