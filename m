Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab3DOOia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:38:30 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:38340 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3DOOi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:38:27 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH 0/3 v2] mutex: Improve mutex performance by doing less atomic-ops & better spinning
Date: Mon, 15 Apr 2013 10:37:56 -0400
Message-Id: <1366036679-9702-1-git-send-email-Waiman.Long@hp.com>
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

v1->v2
 - Remove the 2 mutex spinner patches and replaced it by another one
   to improve the mutex spinning process.
 - Remove changes made to kernel/mutex.h & localize changes in 
   kernel/mutex.c.
 - Add an optional patch to remove architecture specific check in patch
   1.

This patch set is a collection of 3 different mutex related patches
aimed at improving mutex performance especially for system with large
number of CPUs. This is achieved by doing less atomic operations and
better mutex spinning (when the CONFIG_MUTEX_SPIN_ON_OWNER is on).

The first patch reduces the number of atomic operations executed. It
can produce dramatic performance improvement in the AIM7 benchmark
with large number of CPUs. For example, there was a more than 3X
improvement in the high_systime workload with a 3.7.10 kernel on
an 8-socket x86-64 system with 80 cores. The 3.8 kernels, on the
other hand, are not mutex limited for that workload anymore. So the
performance improvement is only about 1% for the high_systime workload.

Patches 2 improves the mutex spinning process by reducing contention
among the spinners when competing for the mutex. This is done by
using a MCS lock to put the spinners in a queue so that only the
first spinner will try to acquire the mutex when it is available. This
patch showed significant performance improvement of +30% on the AIM7
fserver and new_fserver workload.

The last patch is an optional one for backing out architecture specific
check in patch 1, if so desired.

Waiman Long (3):
  mutex: Make more scalable by doing less atomic operations
  mutex: Queue mutex spinners with MCS lock to reduce cacheline
    contention
  mutex: back out architecture specific check for negative mutex count

 include/linux/mutex.h |    3 ++
 include/linux/sched.h |    3 ++
 kernel/mutex.c        |   92 ++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/core.c   |   24 +++++++++++--
 4 files changed, 115 insertions(+), 7 deletions(-)

