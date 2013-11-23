Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3KWA4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 19:56:53 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:25374 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3KWA4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 19:56:47 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com, davidlohr@hp.com
Subject: [PATCH 0/5] futex: Wakeup optimizations
Date: Fri, 22 Nov 2013 16:56:32 -0800
Message-Id: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Patches 1 & 2 are cleanups and micro optimizations.

Patch 3 addresses the well known issue of the global hash table.
By creating a larger and NUMA aware table, we can reduce the false
sharing and collisions, thus reducing the chance of different futexes 
using hb->lock.

Patch 4 reduces contention on the corresponding hb->lock by not trying to
acquire it if there are no blocked tasks in the waitqueue.
This particularly deals with point (i) above, where we see that it is not
uncommon for up to 90% of wakeup calls end up returning 0, indicating that no
tasks were woken.

Patch 5 resurrects a two year old idea from Peter Zijlstra to delay
the waking of the blocked tasks to be done without holding the hb->lock:
https://lkml.org/lkml/2011/9/14/118

This is useful for locking primitives that can effect multiple wakeups
per operation and want to avoid the futex's internal spinlock contention by
delaying the wakeups until we've released the hb->lock.
This particularly deals with point (ii) above, where we can observe that
in occasions the wake calls end up waking 125 to 200 waiters in what we believe 
are RW locks in the application.

This patchset has also been tested on smaller systems for a variety of
benchmarks, including java workloads, kernel builds and custom bang-the-hell-out-of
hb locks programs. So far, no functional or performance regressions have been seen.
Furthermore, no issues were found when running the different tests in the futextest 
suite: http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/

This patchset applies on top of Linus' tree as of v3.13-rc1.

Special thanks to Scott Norton, Tom Vanden and Mark Ray for help presenting, 
debugging and analyzing the data.

  futex: Misc cleanups
  futex: Check for pi futex_q only once
  futex: Larger hash table
  futex: Avoid taking hb lock if nothing to wakeup
  sched,futex: Provide delayed wakeup list

 include/linux/sched.h |  41 ++++++++++++++++++
 kernel/futex.c        | 113 +++++++++++++++++++++++++++-----------------------
 kernel/sched/core.c   |  19 +++++++++
 3 files changed, 122 insertions(+), 51 deletions(-)

-- 
1.8.1.4

