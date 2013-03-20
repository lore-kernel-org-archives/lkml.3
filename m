Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3CTURh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:17:37 -0400
Received: from shelob.surriel.com ([74.92.59.67]:38944 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab3CTUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:15:42 -0400
X-Greylist: delayed 1187 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 16:15:42 EDT
From: Rik van Riel <riel@surriel.com>
To: torvalds@linux-foundation.org
Cc: davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        Rik van Riel <riel@surriel.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 5/7] ipc,sem: open code and rename sem_lock
Date: Wed, 20 Mar 2013 15:55:35 -0400
Message-Id: <1363809337-29718-6-git-send-email-riel@surriel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename sem_lock to sem_obtain_lock, so we can introduce a sem_lock
function later that only locks the sem_array and does nothing else.

Open code the locking from ipc_lock in sem_obtain_lock, so we can
introduce finer grained locking for the sem_array in the next patch.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 ipc/sem.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index ff3d4ff..d25f9b6 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -194,14 +194,29 @@ void __init sem_init (void)
  * sem_lock_(check_) routines are called in the paths where the rw_mutex
  * is not held.
  */
-static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id)
+static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns, int id)
 {
-	struct kern_ipc_perm *ipcp = ipc_lock(&sem_ids(ns), id);
+	struct kern_ipc_perm *ipcp;
 
+	rcu_read_lock();
+	ipcp = ipc_obtain_object(&sem_ids(ns), id);
 	if (IS_ERR(ipcp))
-		return (struct sem_array *)ipcp;
+		goto err1;
+
+	spin_lock(&ipcp->lock);
+
+	/* ipc_rmid() may have already freed the ID while sem_lock
+	 * was spinning: verify that the structure is still valid
+	 */
+	if (ipcp->deleted)
+		goto err0;
 
 	return container_of(ipcp, struct sem_array, sem_perm);
+err0:
+	spin_unlock(&ipcp->lock);
+err1:
+	rcu_read_unlock();
+	return ERR_PTR(-EINVAL);
 }
 
 static inline struct sem_array *sem_obtain_object(struct ipc_namespace *ns, int id)
@@ -1562,7 +1577,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		goto out_free;
 	}
 
-	sma = sem_lock(ns, semid);
+	sma = sem_obtain_lock(ns, semid);
 
 	/*
 	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
-- 
1.7.7.6

