Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935072Ab3JPRv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:51:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934682Ab3JPRqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 32/50] ipc,shm: introduce lockless functions to obtain the ipc object
Date: Wed, 16 Oct 2013 10:45:18 -0700
Message-Id: <20131016174402.213558025@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit 8b8d52ac382b17a19906b930cd69e2edb0aca8ba upstream.

This is the third and final patchset that deals with reducing the amount
of contention we impose on the ipc lock (kern_ipc_perm.lock).  These
changes mostly deal with shared memory, previous work has already been
done for semaphores and message queues:

  http://lkml.org/lkml/2013/3/20/546 (sems)
  http://lkml.org/lkml/2013/5/15/584 (mqueues)

With these patches applied, a custom shm microbenchmark stressing shmctl
doing IPC_STAT with 4 threads a million times, reduces the execution
time by 50%.  A similar run, this time with IPC_SET, reduces the
execution time from 3 mins and 35 secs to 27 seconds.

Patches 1-8: replaces blindly taking the ipc lock for a smarter
combination of rcu and ipc_obtain_object, only acquiring the spinlock
when updating.

Patch 9: renames the ids rw_mutex to rwsem, which is what it already was.

Patch 10: is a trivial mqueue leftover cleanup

Patch 11: adds a brief lock scheme description, requested by Andrew.

This patch:

Add shm_obtain_object() and shm_obtain_object_check(), which will allow us
to get the ipc object without acquiring the lock.  Just as with other
forms of ipc, these functions are basically wrappers around
ipc_obtain_object*().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/shm.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -124,6 +124,26 @@ void __init shm_init (void)
 				IPC_SHM_IDS, sysvipc_shm_proc_show);
 }
 
+static inline struct shmid_kernel *shm_obtain_object(struct ipc_namespace *ns, int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object(&shm_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct shmid_kernel, shm_perm);
+}
+
+static inline struct shmid_kernel *shm_obtain_object_check(struct ipc_namespace *ns, int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object_check(&shm_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct shmid_kernel, shm_perm);
+}
+
 /*
  * shm_lock_(check_) routines are called in the paths where the rw_mutex
  * is not necessarily held.


