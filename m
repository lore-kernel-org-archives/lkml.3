Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3EPBIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:08:15 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34823 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3EPBIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:13 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 00/11] sysv mqueue: do not hold the ipc lock unnecessarily
Date: Wed, 15 May 2013 18:07:59 -0700
Message-Id: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset continues the work that began in the sysv ipc semaphore scaling 
series: https://lkml.org/lkml/2013/3/20/546

Just like semaphores used to be, sysv shared memory and msg queues also abuse the ipc
lock, unnecessarily holding it for operations such as permission and security checks. This
patchset mostly deals with mqueues, and while shared mem can be done in a very similar way,
I want to get these patches out in the open first. It also does some pending cleanups,
mostly focused on the two level locking we have in ipc code, taking care of ipc_addid() 
and ipcctl_pre_down_nolock() - yes there are still functions that need to be updated as well.

I have tried to split each patch to be as readable and specific as possible, specially when
shortening the critical regions, going one function at a time.

Patch 1 moves the locking to be explicitly done by the callers of ipc_addid.
It updates msg, sem and shm.

Patches 2-3: are just wrappers around the ipc lock, initially suggested by Linus.

Patch 4 is similar to patch 1, moving the rcu and rw_mutex locking out of
ipcctl_pre_down_nolock so that the callers explicitly deals with them. It updates msg, sem
and shm.

Patch 5 shortens the critical region in msgctl_down(), using the lockless
ipcctl_pre_down() function and only acquiring the ipc lock for RMID and SET commands.

Patch 6 simply moves the what-should-be lockless logic of *_INFO and *_STAT commands
out of msgctl() into a new function, msgctl_lockless().

Patch 7 introduces the necessary wrappers around ipc_obtain_object[_check]()
that will later enable us to separately lookup the ipc object without holding the lock.

Patch 8 updates the previously added msgctl_nolock() to actually be lockless, reducing
the critical region for the STAT commands.

Patch 9 redoes the locking for msgsend().

Patch 10 redoes the locking for msgrcv().

Patch 11 removes the now unused msg_lock and msg_lock_check functions, replaced by
a smarter combination of rcu, ipc_obtain_object and ipc_object_lock.

Davidlohr Bueso (11):
  ipc: move rcu lock out of ipc_addid
  ipc: introduce ipc object locking helpers
  ipc: close open coded spin lock calls
  ipc: move locking out of ipcctl_pre_down_nolock
  ipc,msg: shorten critical region in semctl_down
  ipc,msg: introduce msgctl_nolock
  ipc,msg: introduce lockless functions to obtain the ipc object
  ipc,msg: make msgctl_nolock lockless
  ipc,msg: reduce critical region in msgsnd
  ipc,msg: make shorten critical region in msgrcv
  ipc: remove unused functions

 ipc/msg.c  | 227 ++++++++++++++++++++++++++++++++++++++-----------------------
 ipc/sem.c  |  42 +++++++-----
 ipc/shm.c  |  32 ++++++---
 ipc/util.c |  25 ++-----
 ipc/util.h |  22 ++++--
 5 files changed, 211 insertions(+), 137 deletions(-)

Thanks,
Davidlohr

-- 
1.7.11.7

