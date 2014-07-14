Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbaGNR2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:28:15 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:39891 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaGNR2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:28:04 -0400
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Waiman Long <waiman.long@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott Norton <scott.norton@hp.com>, Dave Chinner <david@fromorbit.com>,
        Jason Low <jason.low2@hp.com>
Subject: [PATCH v2 0/5] MCS spinlocks: Cancellable MCS spinlock rework
Date: Mon, 14 Jul 2014 10:27:47 -0700
Message-Id: <1405358872-3732-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
- Added a patch which uses function + macro for initializing the osq lock
  as suggested by Steven.
- Improved the way we initialize struct rw_semaphore fields with the
  init macro in patch 5 as suggested by Peter.

The main purpose of this patchset is to reduce the size of the
cancellable MCS spinlock and reduce the overhead of rwsem
(currently the largest lock in the kernel).

The overhead of the cancellable MCS lock is a pointer to a per-cpu  node
structure which requires 64 bits on 64 bit systems. Instead of a pointer
to the per-cpu node, we can instead store the CPU # corresponding to the
node in atomic_t. This reduces the overhead by 32 bits on 64 bit systems.

This then opens the opportunity to reduce the size of the rw_semaphore
structure (one of the current users of this MCS lock) by moving around some
of its fields. Due to padding, we would reduce the size of that structure
by 64 bits (on 64 bit systems). This makes it more in line with the size
of the mutex structure.

Jason Low (5):
  MCS spinlocks: Rename optimistic_spin_queue to optimistic_spin_node
  MCS spinlocks: Convert osq lock to atomic_t to reduce overhead
  MCS spinlocks: Introduce and use init macro and function for osq
    locks
  MCS spinlocks: Micro-optimize osq_unlock()
  rwsem: Reduce the size of struct rw_semaphore

 include/linux/mutex.h         |    4 +-
 include/linux/osq_lock.h      |   27 +++++++++++++++++
 include/linux/rwsem.h         |   28 +++++++----------
 kernel/locking/mcs_spinlock.c |   64 ++++++++++++++++++++++++++++++----------
 kernel/locking/mcs_spinlock.h |    9 +++--
 kernel/locking/mutex.c        |    2 +-
 kernel/locking/rwsem-xadd.c   |    2 +-
 7 files changed, 96 insertions(+), 40 deletions(-)
 create mode 100644 include/linux/osq_lock.h

