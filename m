Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3AVXNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:13:54 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63555 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab3AVXNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:13:50 -0500
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/6] fast queue spinlocks
Date: Tue, 22 Jan 2013 15:13:29 -0800
Message-Id: <1358896415-28569-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to propose a fast queue spinlock implementation, which could
be used on selected spinlocks instead of the default ticket spinlock.

I understand that in the past, such proposals have been defeated by
two main arguments:
- That it is generally preferable to use smart algorithms that can avoid
  lock contention altogether, rather than spending effort on the lock
  itself to deal with the contention, and
- That the lightly contended case matters more to real workloads than the
  highly contended case, and that the most well known scalable spinlock
  algorithms tend to be relatively slow in the lightly contended case.

I am hoping for a different result this time around based on the following
counter-arguments:
- There are situations where the lock contention is directly driven by user
  events, with little opportunity to reduce it in-kernel. One example might
  be when the user requests that the kernel acquires or releases semaphores
  on its behalf using sysv IPC APIs - it is hard to imagine how the kernel
  could mitigate spinlock contention issues for the user.
- More importantly, the queue spinlock implementation I am proposing
  seems to behave well both under light and heavy contention. It uses one
  single atomic opearation on the lock side, and (on x86) only a single
  memory store on the unlock side, with fairly short code sections on
  both sides, and just compares well with the ticket spinlock on the
  benchmarks I have tried.
To be clear, I am not proposing replacing every ticket spinlock usage with
queue spinlocks; I am only proposing to have both APIs available and pick
them as appropriate for each use case.

In order to have concrete examples, I have converted two spinlocks to
the proposed queue spinlock API:
- The IPC object spinlock, which protects each individually allocated
  IPC message queue, IPC shared memory segment or IPC semaphore array.
- The network qdisc busylock, which if I understand correctly seems to
  be a way to prevent multiple network writers starving the thread that
  wants to actually dequeue packets to send them on the wire.
I picked these two locks because I knew of situations where they get
contended; additionally I wanted to have examples of one lock that gets
taken in process context and one that can be taken in softirq context,
in order to demonstrate that the proposed spinlock can deal with the
resulting reentrancy issues. I am not very familiar with either the
sysv IPC or the networking code, however I know that these areas have
been looked at by competent people so I assume there are no obvious
ways to avoid contention on these two spinlocks (but feel free to
propose better examples if I'm wrong :)

The first 3 patches are a bit of a strawman, as they introduce a classic
MCS queue lock implementation and convert the IPC and qdisc spinlocks
to use the corresponding locking API. I expect this might be rejected
since MCS spinlocks have some higher cost than ticket based ones under
light contention; however I consider this a useful step as it lets us
implement most of the mechanical changes to convert our two spinlocks
to the proposed queue spinlock API.

Patch 4 implements my proposed fast queue spinlock algorithm, which
seems to performs better than MCS at all contention levels and is
competitive with ticket spinlocks at low contention levels. This comes
with a few limitations, mostly due to the fact that spinlocks must point
to a dynamically allocated ticket structure - so they can't have a static
initializer, they may be inappropriate for short lived objects, the init
function may fail, and they need to be explicitly destroyed before the
object they're in is freed.

Patches 5-6 convert the IPC and qdisc spinlocks to deal with the API
limitations introduced by the fast queue spinlock algorithm in patch 4.

Michel Lespinasse (6):
  kernel: implement queue spinlock API
  net: convert qdisc busylock to use queue spinlock API
  ipc: convert ipc objects to use queue spinlock API
  kernel: faster queue spinlock implementation
  net: qdisc busylock updates to account for queue spinlock api change
  ipc: object locking updates to account for queue spinlock api change

 arch/x86/include/asm/queue_spinlock.h |   20 +++++
 include/asm-generic/queue_spinlock.h  |    7 ++
 include/linux/ipc.h                   |    9 +--
 include/linux/msg.h                   |    2 +-
 include/linux/queue_spinlock.h        |  113 +++++++++++++++++++++++++++++
 include/linux/shm.h                   |    2 +-
 include/net/sch_generic.h             |    3 +-
 init/main.c                           |    2 +
 ipc/msg.c                             |   61 +++++++++-------
 ipc/namespace.c                       |    8 ++-
 ipc/sem.c                             |  115 +++++++++++++++++-------------
 ipc/shm.c                             |   95 ++++++++++++++-----------
 ipc/util.c                            |  122 +++++++++++++++++++++-----------
 ipc/util.h                            |   25 ++++---
 kernel/Makefile                       |    2 +-
 kernel/queue_spinlock.c               |  125 +++++++++++++++++++++++++++++++++
 net/core/dev.c                        |    9 ++-
 net/sched/sch_generic.c               |   19 +++--
 18 files changed, 546 insertions(+), 193 deletions(-)
 create mode 100644 arch/x86/include/asm/queue_spinlock.h
 create mode 100644 include/asm-generic/queue_spinlock.h
 create mode 100644 include/linux/queue_spinlock.h
 create mode 100644 kernel/queue_spinlock.c


Now for the obligatory benchmarks:


First, testing IPC locking using rik's semop_test benchmark:

On 4 socket AMD Barcelona system (16 cores total):
1 thread (no contention): ~5.38 Mop/s queue spinlock vs ~5.45 baseline (-1%)
2 threads:                ~1.47 Mop/s queue spinlock vs ~1.48 baseline
4 threads:                ~1.57 Mop/s queue spinlock vs ~1.21 baseline (+30%)
8 threads:                ~1.41 Mop/s queue spinlock vs ~0.83 baseline (+70%)
16 threads:               ~1.40 Mop/s queue spinlock vs ~0.47 baseline (+200%)
For comparison, rik's proportional backoff (v3) gets ~1.18 Mop/s at 16 threads

On 2 socket Intel Sandybridge system (16 cores / 32 threads total):
1 thread (no contention): ~8.36 Mop/s queue spinlock vs ~8.25 baseline (+1%)
2 threads: results are noisy there, from ~5 to ~6.5 Mops/s with either trees
4 threads: ~4.5 to ~5.8 Mops/s queue spinlock (noisy), ~5.5 baseline
8 threads: ~4.3 to ~5 Mops/s queue spinlock, ~4.1 to ~4.2 baseline
16 threads: ~3.2 to ~3.6 Mops/s queue spinlock, ~1.5 to ~2.4 baseline
32 threads: ~2.7 to ~3.2 Mops/s queue spinlock, ~1.5 to ~1.9 baseline
For comparison, rik's proposal gets ~1.75 to ~2.1 at 32 threads

Basically for semop_test, the data is noisy on one of the test machines but
the queue spinlock is never measurably slower than the ticket spinlock,
except by 1% in the uncontended case on the AMD system (and it's 1% faster
in the uncontended case on the other system, so I'd call it a draw :)


32 instances of netperf -t UDP_STREAM -H <server> -- -m 128 on a 32
hypercores machine (2 sandybridge sockets) and htb root qdisc:
~650 to ~680 Mbps total with baseline 3.7
~895 to ~915 Mbps total with fast queue spinlock
~860 to ~890 Mbps total with rik's proportional backoff (v3)


Additionally I will attach (as a reply to this email) graphs showing total
spinlock throughput for a microbenchmark consisting of N threads doing
lock/unlock operations in a tight loop. We can see that the proposed
fast queue spinlock is comparable to ticket spinlocks for low number
of threads, scales much better for high number of threads, and is always
faster than the MCS strawman proposal (which did have the issue of being
kinda slow at around 2-3 threads).
mach1 is a 4 socket AMD Barcelona system (16 cores total)
mach2 is a 2 socket Intel Westmere system (12 cores / 24 threads total)
mach3 is a 2 socket Intel Sandybridge system (16 cores / 32 threads total)

-- 
1.7.7.3
