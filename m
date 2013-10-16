Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761758Ab3JPSVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:21:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab3JPRpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 30/69] ipc: move rcu lock out of ipc_addid
Date: Wed, 16 Oct 2013 10:44:39 -0700
Message-Id: <20131016174316.575976556@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit dbfcd91f06f0e2d5564b2fd184e9c2a43675f9ab upstream.

This patchset continues the work that began in the sysv ipc semaphore
scaling series, see

  https://lkml.org/lkml/2013/3/20/546

Just like semaphores used to be, sysv shared memory and msg queues also
abuse the ipc lock, unnecessarily holding it for operations such as
permission and security checks.

This patchset mostly deals with mqueues, and while shared mem can be
done in a very similar way, I want to get these patches out in the open
first.  It also does some pending cleanups, mostly focused on the two
level locking we have in ipc code, taking care of ipc_addid() and
ipcctl_pre_down_nolock() - yes there are still functions that need to be
updated as well.

This patch:

Make all callers explicitly take and release the RCU read lock.

This addresses the two level locking seen in newary(), newseg() and
newqueue().  For the last two, explicitly unlock the ipc object and the
rcu lock, instead of calling the custom shm_unlock and msg_unlock
functions.  The next patch will deal with the open coded locking for
->perm.lock

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c  |    7 +++----
 ipc/shm.c  |    5 ++++-
 ipc/util.c |    3 +--
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -199,9 +199,7 @@ static int newque(struct ipc_namespace *
 		return retval;
 	}
 
-	/*
-	 * ipc_addid() locks msq
-	 */
+	/* ipc_addid() locks msq upon success. */
 	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
 	if (id < 0) {
 		security_msg_queue_free(msq);
@@ -218,7 +216,8 @@ static int newque(struct ipc_namespace *
 	INIT_LIST_HEAD(&msq->q_receivers);
 	INIT_LIST_HEAD(&msq->q_senders);
 
-	msg_unlock(msq);
+	spin_unlock(&msq->q_perm.lock);
+	rcu_read_unlock();
 
 	return msq->q_perm.id;
 }
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -535,6 +535,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_nattch = 0;
 	shp->shm_file = file;
 	shp->shm_creator = current;
+
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
 	 * proc-ps tools use this. Changing this will break them.
@@ -543,7 +544,9 @@ static int newseg(struct ipc_namespace *
 
 	ns->shm_tot += numpages;
 	error = shp->shm_perm.id;
-	shm_unlock(shp);
+
+	spin_unlock(&shp->shm_perm.lock);
+	rcu_read_unlock();
 	return error;
 
 no_id:
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -246,9 +246,8 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	is returned. The 'new' entry is returned in a locked state on success.
  *	On failure the entry is not locked and a negative err-code is returned.
  *
- *	Called with ipc_ids.rw_mutex held as a writer.
+ *	Called with writer ipc_ids.rw_mutex held.
  */
- 
 int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 {
 	kuid_t euid;


