Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaALXbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 18:31:43 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:12380 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALXbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 18:31:40 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com, davidlohr@hp.com
Subject: [PATCH v6 0/5] futex: Wakeup optimizations
Date: Sun, 12 Jan 2014 15:31:21 -0800
Message-Id: <1389569486-25487-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v5 [https://lkml.org/lkml/2014/1/2/178]:
 - Added latest review tags

 - Removed redundant CONFIG_SMP ifdef in futex_get_mm()

 - Updated comments per Darren's suggestions.

Changes from v3/v4 [http://lkml.org/lkml/2013/12/19/627]:
 - Almost completely redid patch 4, based on suggestions
   by Linus. Instead of adding an atomic counter to keep
   track of the plist size, couple the list's head empty
   call with a check to see if the hb lock is locked.
   This solves the race that motivated the use of the new
   atomic field.

 - Fix grammar in patch 3

 - Fix SOB tags.

Changes from v2 [http://lwn.net/Articles/575449/]:
 - Reordered SOB tags to reflect me as primary author.

 - Improved ordering guarantee comments for patch 4.

 - Rebased patch 4 against Linus' tree (this patch didn't
   apply after the recent futex changes/fixes).

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

 37.12%  826174  xxx  [kernel.kallsyms] [k] _raw_spin_lock
            --- _raw_spin_lock
             |
             |--97.14%-- futex_wake
             |          do_futex
             |          sys_futex
             |          system_call_fastpath
             |          |
             |          |--99.70%-- 0x7f383fbdea1f
             |          |           yyy

 43.71%  762296  xxx  [kernel.kallsyms] [k] _raw_spin_lock
            --- _raw_spin_lock
             |
             |--53.74%-- futex_wake
             |          do_futex
             |          sys_futex
             |          system_call_fastpath
             |          |
             |          |--99.40%-- 0x7fe7d44a4c05
             |          |           zzz
             |--45.90%-- futex_wait_setup
             |          futex_wait
             |          do_futex
             |          sys_futex
             |          system_call_fastpath
             |          0x7fe7ba315789
             |          syscall


With these patches, contention is practically non existent:

 0.10%     49   xxx  [kernel.kallsyms]   [k] _raw_spin_lock
               --- _raw_spin_lock
                |
                |--76.06%-- futex_wait_setup
                |          futex_wait
                |          do_futex
                |          sys_futex
                |          system_call_fastpath
                |          |
                |          |--99.90%-- 0x7f3165e63789
                |          |          syscall|
                           ...
                |--6.27%-- futex_wake
                |          do_futex
                |          sys_futex
                |          system_call_fastpath
                |          |
                |          |--54.56%-- 0x7f317fff2c05
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

Patch 5 silences a gcc warning msg.

This patchset has also been tested on smaller systems for a variety of
benchmarks, including java workloads, kernel builds and custom bang-the-hell-out-of
hb locks programs. So far, no functional or performance regressions have been seen.
Furthermore, no issues were found when running the different tests in the futextest 
suite: http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/

This patchset applies on top of Linus' tree as of v3.13-rc6 (9a0bb296)

Special thanks to Scott Norton, Tom Vanden, Mark Ray and Aswin Chandramouleeswaran
for help presenting, debugging and analyzing the data.

  futex: Misc cleanups
  futex: Larger hash table
  futex: Document ordering guarantees
  futex: Avoid taking hb lock if nothing to wakeup
  futex: Silence uninitialized warnings

 kernel/futex.c | 205 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 163 insertions(+), 42 deletions(-)

-- 
1.8.1.4

