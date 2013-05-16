Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3EPBIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:08:16 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:41912 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3EPBIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:13 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 01/11] ipc: move rcu lock out of ipc_addid
Date: Wed, 15 May 2013 18:08:00 -0700
Message-Id: <1368666490-29055-2-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make all callers explicitly take and release the RCU read lock.

This addresses the two level locking seen in newary(), newseg()
and newqueue(). For the last two, explicitly unlock the ipc object
and the rcu lock, instead of calling the custom shm_unlock and
msg_unlock functions. The next patch will deal with the open
coded locking for ->perm.lock

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c  | 9 +++++----
 ipc/sem.c  | 2 ++
 ipc/shm.c  | 7 ++++++-
 ipc/util.c | 4 +---
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index d0c6d96..8270511 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -199,11 +199,11 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 		return retval;
 	}
 
-	/*
-	 * ipc_addid() locks msq
-	 */
+	/* ipc_addid() locks msq upon success. */
+	rcu_read_lock();
 	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
 	if (id < 0) {
+		rcu_read_unlock();
 		security_msg_queue_free(msq);
 		ipc_rcu_putref(msq);
 		return id;
@@ -218,7 +218,8 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	INIT_LIST_HEAD(&msq->q_receivers);
 	INIT_LIST_HEAD(&msq->q_senders);
 
-	msg_unlock(msq);
+	spin_unlock(&msq->q_perm.lock);
+	rcu_read_unlock();
 
 	return msq->q_perm.id;
 }
diff --git a/ipc/sem.c b/ipc/sem.c
index a7e40ed..cee96e6 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -407,8 +407,10 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 		return retval;
 	}
 
+	rcu_read_lock();
 	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
 	if (id < 0) {
+		rcu_read_unlock();
 		security_sem_free(sma);
 		ipc_rcu_putref(sma);
 		return id;
diff --git a/ipc/shm.c b/ipc/shm.c
index 7e199fa..11dec70 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -521,9 +521,11 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (IS_ERR(file))
 		goto no_file;
 
+	rcu_read_lock();
 	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (id < 0) {
 		error = id;
+		rcu_read_unlock();
 		goto no_id;
 	}
 
@@ -535,6 +537,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	shp->shm_nattch = 0;
 	shp->shm_file = file;
 	shp->shm_creator = current;
+
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
 	 * proc-ps tools use this. Changing this will break them.
@@ -543,7 +546,9 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 
 	ns->shm_tot += numpages;
 	error = shp->shm_perm.id;
-	shm_unlock(shp);
+
+	spin_unlock(&shp->shm_perm.lock);
+	rcu_read_unlock();
 	return error;
 
 no_id:
diff --git a/ipc/util.c b/ipc/util.c
index 809ec5e..92f0242 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -246,9 +246,8 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	is returned. The 'new' entry is returned in a locked state on success.
  *	On failure the entry is not locked and a negative err-code is returned.
  *
- *	Called with ipc_ids.rw_mutex held as a writer.
+ *	Called with RCU read lock and writer ipc_ids.rw_mutex held.
  */
- 
 int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 {
 	kuid_t euid;
@@ -266,7 +265,6 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
-	rcu_read_lock();
 	spin_lock(&new->lock);
 
 	id = idr_alloc(&ids->ipcs_idr, new,
-- 
1.7.11.7

