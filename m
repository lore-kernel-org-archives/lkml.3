Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3LCJpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:45:50 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:33631 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3LCJpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:45:46 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com,
        davidlohr@hp.com
Subject: [PATCH v2 0/4] futex: Wakeup optimizations
Date: Tue,  3 Dec 2013 01:45:23 -0800
Message-Id: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1 [https://lkml.org/lkml/2013/11/22/525]:
 - Removed patch "futex: Check for pi futex_q only once".

 - Cleaned up ifdefs for larger hash table.

 - Added a doc patch from tglx that describes the futex 
   ordering guarantees.

 - Improved the lockless plist check for the wake calls.
   Based on the community feedback, the necessary abstractions
   and barriers are added to maintain ordering guarantees.
   Code documentation is also updated.

 - Removed patch "sched,futex: Provide delayed wakeup list".
   Based on feedback from PeterZ, I will look into this as
   a separate issue once the other patches are settled.
 

We have been dealing with a customer database workload on large
12Tb, 240 core 16 socket NUMA system that exhibits high amounts 
of contention on some of the locks that serialize internal futex 
data structures. This workload specially suffers in the wakeup 
paths, where waiting on the corresponding hb->lock can account for 
up to ~60% of the time. The result of such calls can mostly be 
classified as (i) nothing to wake up and (ii) wakeup large amount 
of tasks.

Before these patches are applied, we can see this pathological behavior:

 37.12%  826174  xxx  [kernel.kallsyms] [k] _raw_spin_lock
            --- _raw_spin_lock
             |
             |--97.14%-- futex_wake
             |          do_futex
             |          sys_futex
             |          system_call_fastpath
             |          |
             |          |--99.70%-- 0x7f383fbdea1f
             |          |           yyy

 43.71%  762296  xxx  [kernel.kallsyms] [k] _raw_spin_lock
            --- _raw_spin_lock
             |
             |--53.74%-- futex_wake
             |          do_futex
             |          sys_futex
             |          system_call_fastpath
             |          |
             |          |--99.40%-- 0x7fe7d44a4c05
             |          |           zzz
             |--45.90%-- futex_wait_setup
             |          futex_wait
             |          do_futex
             |          sys_futex
             |          system_call_fastpath
             |          0x7fe7ba315789
             |          syscall


With these patches, contention is practically non existent:

 0.10%     49   xxx  [kernel.kallsyms]   [k] _raw_spin_lock
               --- _raw_spin_lock
                |
                |--76.06%-- futex_wait_setup
                |          futex_wait
                |          do_futex
                |          sys_futex
                |          system_call_fastpath
                |          |
                |          |--99.90%-- 0x7f3165e63789
                |          |          syscall|
                           ...
                |--6.27%-- futex_wake
                |          do_futex
                |          sys_futex
                |          system_call_fastpath
                |          |
                |          |--54.56%-- 0x7f317fff2c05
                ...

Patch 1 is a cleanup.

Patch 2 addresses the well known issue of the global hash table.
By creating a larger and NUMA aware table, we can reduce the false
sharing and collisions, thus reducing the chance of different futexes 
using hb->lock.

Patch 3 documents the futex ordering guarantees.

Patch 4 reduces contention on the corresponding hb->lock by not trying to
acquire it if there are no blocked tasks in the waitqueue.
This particularly deals with point (i) above, where we see that it is not
uncommon for up to 90% of wakeup calls end up returning 0, indicating that no
tasks were woken.

This patchset has also been tested on smaller systems for a variety of
benchmarks, including java workloads, kernel builds and custom bang-the-hell-out-of
hb locks programs. So far, no functional or performance regressions have been seen.
Furthermore, no issues were found when running the different tests in the futextest 
suite: http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/

This patchset applies on top of Linus' tree as of v3.13-rc2 (2e7babfa).

Special thanks to Scott Norton, Tom Vanden, Mark Ray and Aswin Chandramouleeswaran
for help presenting, debugging and analyzing the data.

  futex: Misc cleanups
  futex: Larger hash table
  futex: Document ordering guarantees
  futex: Avoid taking hb lock if nothing to wakeup

 kernel/futex.c | 230 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 194 insertions(+), 36 deletions(-)

-- 
1.8.1.4

