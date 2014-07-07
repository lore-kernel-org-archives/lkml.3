Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaGGSwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:52:07 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:1835 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaGGSwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:52:05 -0400
From: Jason Low <jason.low2@hp.com>
To: peterz@infradead.org, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, Waiman.Long@hp.com,
        davidlohr@hp.com, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, riel@redhat.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, hpa@zytor.com, tim.c.chen@linux.intel.com,
        konrad.wilk@oracle.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, jason.low2@hp.com
Subject: [PATCH 0/4] MCS spinlocks: Cancellable MCS spinlock rework
Date: Mon,  7 Jul 2014 11:50:15 -0700
Message-Id: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Jason Low (4):
  MCS spinlocks: Rename optimistic_spin_queue to optimistic_spin_node
  MCS spinlocks: Convert osq lock to atomic_t to reduce overhead
  MCS spinlocks: Micro-optimize osq_unlock()
  rwsem: Reduce the size of struct rw_semaphore

 include/linux/mutex.h         |    4 +-
 include/linux/osq_lock.h      |   19 ++++++++++++
 include/linux/rwsem.h         |   11 +++----
 kernel/locking/mcs_spinlock.c |   62 ++++++++++++++++++++++++++++++----------
 kernel/locking/mcs_spinlock.h |    9 +++--
 kernel/locking/mutex.c        |    2 +-
 kernel/locking/rwsem-xadd.c   |    2 +-
 7 files changed, 79 insertions(+), 30 deletions(-)
 create mode 100644 include/linux/osq_lock.h

