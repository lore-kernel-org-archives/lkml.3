Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab3DQTXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:23:41 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:29491 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3DQTXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:23:39 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v4 0/4]  mutex: Improve mutex performance by doing less atomic-ops & better spinning
Date: Wed, 17 Apr 2013 15:23:10 -0400
Message-Id: <1366226594-5506-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3->v4
 - Merge patch 4 into patch 2
 - Move patch 5 forward to become patch 1

v2->v3
  - Add patch 4 to remove new typedefs introduced in patch 2.
  - Add patch 5 to remove SCHED_FEAT_OWNER_SPIN and move the mutex
    spinning code to mutex.c.

v1->v2
 - Remove the 2 mutex spinner patches and replaced it by another one
   to improve the mutex spinning process.
 - Remove changes made to kernel/mutex.h & localize changes in
   kernel/mutex.c.
 - Add an optional patch to remove architecture specific check in patch
   1.

This patch set is a collection of 4 different mutex related patches
aimed at improving mutex performance especially for system with large
number of CPUs. This is achieved by doing less atomic operations and
better mutex spinning (when the CONFIG_MUTEX_SPIN_ON_OWNER is on).

Patch 1 removes SCHED_FEAT_OWNER_SPIN which was just an earlier hack
for testing purpose. It also moves the mutex spinning code back to
mutex.c.

Patch 2 reduces the number of atomic operations executed. It can
produce dramatic performance improvement in the AIM7 benchmark with
large number of CPUs. For example, there was a more than 3X improvement
in the high_systime workload with a 3.7.10 kernel on an 8-socket
x86-64 system with 80 cores. The 3.8 kernels, on the other hand,
are not mutex limited for that workload anymore. So the performance
improvement is only about 1% for the high_systime workload.

Patch 3 improves the mutex spinning process by reducing contention
among the spinners when competing for the mutex. This is done by
using a MCS lock to put the spinners in a queue so that only the
first spinner will try to acquire the mutex when it is available. This
patch showed significant performance improvement of +30% on the AIM7
fserver and new_fserver workload.

Compared with patches 2&3 in v1, the new patch 3 consistently provided
better performance improvement at high user load (1100-2000) for the
fserver and new_fserver AIM7 workloads. The old patches had around 10%
and less improvement at high user load while the new patch produced
30% better performance for the same workloads.

Patch 4 is an optional one for backing out architecture specific
check in patch 2, if so desired.

Waiman Long (4):
  mutex: Move mutex spinning code from sched/core.c back to mutex.c
  mutex: Make more scalable by doing less atomic operations
  mutex: Queue mutex spinners with MCS lock to reduce cacheline
    contention
  mutex: back out architecture specific check for negative mutex count

 include/linux/mutex.h   |    3 +
 include/linux/sched.h   |    1 -
 kernel/mutex.c          |  151 +++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/core.c     |   45 --------------
 kernel/sched/features.h |    7 --
 5 files changed, 150 insertions(+), 57 deletions(-)

