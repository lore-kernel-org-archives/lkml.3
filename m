Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943Ab3FSBSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:18:49 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:44457 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSBSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:18:47 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 00/11] sysv ipc shared mem optimizations
Date: Tue, 18 Jun 2013 18:18:25 -0700
Message-Id: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third and final patchset that deals with reducing the
amount of contention we impose on the ipc lock (kern_ipc_perm.lock).
These changes mostly deal with shared memory, previous work has already
been done for semaphores and message queues:

http://lkml.org/lkml/2013/3/20/546 (sems)
http://lkml.org/lkml/2013/5/15/584 (mqueues)

With these patches applied, a custom shm microbenchmark stressing shmctl
doing IPC_STAT with 4 threads a million times, reduces the execution time by 50%.
A similar run, this time with IPC_SET, reduces the execution time from 3 mins and
35 secs to 27 seconds.

Patches 1-8: replaces blindly taking the ipc lock for a smarter combination
of rcu and ipc_obtain_object, only acquiring the spinlock when updating.

Patch 9: renames the ids rw_mutex to rwsem, which is what it already was.

Patch 10: is a trivial mqueue leftover cleanup

Patch 11: adds a brief lock scheme description, requested by Andrew.

This patchset applies on top of linux-next (3.10.0-rc6-next-20130618).

Davidlohr Bueso (11):
  ipc,shm: introduce lockless functions to obtain the ipc object
  ipc,shm: shorten critical region in shmctl_down
  ipc: drop ipcctl_pre_down
  ipc,shm: introduce shmctl_nolock
  ipc,shm: make shmctl_nolock lockless
  ipc,shm: shorten critical region for shmctl
  ipc,shm: cleanup do_shmat pasta
  ipc,shm: shorten critical region for shmat
  ipc: rename ids->rw_mutex
  ipc,msg: drop msg_unlock
  ipc: document general ipc locking scheme

 include/linux/ipc_namespace.h |   2 +-
 ipc/msg.c                     |  25 +++--
 ipc/namespace.c               |   4 +-
 ipc/sem.c                     |  24 ++---
 ipc/shm.c                     | 239 ++++++++++++++++++++++++++----------------
 ipc/util.c                    |  57 +++++-----
 ipc/util.h                    |   7 +-
 7 files changed, 199 insertions(+), 159 deletions(-)

-- 
1.7.11.7

