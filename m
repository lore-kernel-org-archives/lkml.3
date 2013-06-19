Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab3FSBVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:21:09 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:5422 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933984Ab3FSBSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:18:53 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 05/11] ipc,shm: make shmctl_nolock lockless
Date: Tue, 18 Jun 2013 18:18:30 -0700
Message-Id: <1371604716-3439-6-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
References: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the INFO cmd doesn't take the ipc lock, the STAT commands do acquire
it unnecessarily. We can do the permissions and security checks only
holding the rcu lock.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/shm.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 3e12398..43a8786 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -882,27 +882,31 @@ static int shmctl_nolock(struct ipc_namespace *ns, int shmid,
 		struct shmid64_ds tbuf;
 		int result;
 
+		rcu_read_lock();
 		if (cmd == SHM_STAT) {
-			shp = shm_lock(ns, shmid);
+			shp = shm_obtain_object(ns, shmid);
 			if (IS_ERR(shp)) {
 				err = PTR_ERR(shp);
-				goto out;
+				goto out_unlock;
 			}
 			result = shp->shm_perm.id;
 		} else {
-			shp = shm_lock_check(ns, shmid);
+			shp = shm_obtain_object_check(ns, shmid);
 			if (IS_ERR(shp)) {
 				err = PTR_ERR(shp);
-				goto out;
+				goto out_unlock;
 			}
 			result = 0;
 		}
+
 		err = -EACCES;
 		if (ipcperms(ns, &shp->shm_perm, S_IRUGO))
 			goto out_unlock;
+
 		err = security_shm_shmctl(shp, cmd);
 		if (err)
 			goto out_unlock;
+
 		memset(&tbuf, 0, sizeof(tbuf));
 		kernel_to_ipc64_perm(&shp->shm_perm, &tbuf.shm_perm);
 		tbuf.shm_segsz	= shp->shm_segsz;
@@ -912,8 +916,9 @@ static int shmctl_nolock(struct ipc_namespace *ns, int shmid,
 		tbuf.shm_cpid	= shp->shm_cprid;
 		tbuf.shm_lpid	= shp->shm_lprid;
 		tbuf.shm_nattch	= shp->shm_nattch;
-		shm_unlock(shp);
-		if(copy_shmid_to_user (buf, &tbuf, version))
+		rcu_read_unlock();
+
+		if (copy_shmid_to_user (buf, &tbuf, version))
 			err = -EFAULT;
 		else
 			err = result;
@@ -924,7 +929,7 @@ static int shmctl_nolock(struct ipc_namespace *ns, int shmid,
 	}
 
 out_unlock:
-	shm_unlock(shp);
+	rcu_read_unlock();
 out:
 	return err;
 }
-- 
1.7.11.7

