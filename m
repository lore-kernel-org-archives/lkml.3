Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3LSRX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:23:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3LSRX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:23:27 -0500
From: Rafael Aquini <aquini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] ipc: change kern_ipc_perm.deleted type to bool
Date: Thu, 19 Dec 2013 15:23:02 -0200
Message-Id: <2376eb01a06ca5e9ea68955f65ac1913929d41a1.1387416739.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct kern_ipc_perm.deleted is meant to be used as a boolean toogle, and
the changes introduced by this patch are just to make the case explicit.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
---
* a quick sidenote: this patch goes on top of the recently posted
[PATCH v3] ipc: introduce ipc_valid_object() helper to sort out IPC_RMID races

 include/linux/ipc.h | 2 +-
 ipc/sem.c           | 2 +-
 ipc/util.c          | 6 +++---
 ipc/util.h          | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 8d861b2..9d84942 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -11,7 +11,7 @@
 struct kern_ipc_perm
 {
 	spinlock_t	lock;
-	int		deleted;
+	bool		deleted;
 	int		id;
 	key_t		key;
 	kuid_t		uid;
diff --git a/ipc/sem.c b/ipc/sem.c
index 5972e60..1659cd9 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -394,7 +394,7 @@ static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns,
 	/* ipc_rmid() may have already freed the ID while sem_lock
 	 * was spinning: verify that the structure is still valid
 	 */
-	if (!ipcp->deleted)
+	if (ipc_valid_object(ipcp))
 		return container_of(ipcp, struct sem_array, sem_perm);
 
 	sem_unlock(sma, *locknum);
diff --git a/ipc/util.c b/ipc/util.c
index 3ae17a4..9dc67fa 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -286,7 +286,7 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 	idr_preload(GFP_KERNEL);
 
 	spin_lock_init(&new->lock);
-	new->deleted = 0;
+	new->deleted = false;
 	rcu_read_lock();
 	spin_lock(&new->lock);
 
@@ -447,7 +447,7 @@ void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 
 	ids->in_use--;
 
-	ipcp->deleted = 1;
+	ipcp->deleted = true;
 
 	return;
 }
@@ -657,7 +657,7 @@ struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 	/* ipc_rmid() may have already freed the ID while ipc_lock
 	 * was spinning: here verify that the structure is still valid
 	 */
-	if (!out->deleted)
+	if (ipc_valid_object(out))
 		return out;
 
 	spin_unlock(&out->lock);
diff --git a/ipc/util.h b/ipc/util.h
index d05b708..a1cbc3a 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -195,7 +195,7 @@ static inline void ipc_unlock(struct kern_ipc_perm *perm)
  */
 static inline bool ipc_valid_object(struct kern_ipc_perm *perm)
 {
-	return perm->deleted == 0;
+	return !perm->deleted;
 }
 
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
-- 
1.8.3.1

