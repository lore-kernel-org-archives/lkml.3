Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829Ab3JPRqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:46:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934644Ab3JPRqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 36/50] ipc,shm: make shmctl_nolock lockless
Date: Wed, 16 Oct 2013 10:45:22 -0700
Message-Id: <20131016174402.739583132@linuxfoundation.org>
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

commit c97cb9ccab8c85428ec21eff690642ad2ce1fa8a upstream.

While the INFO cmd doesn't take the ipc lock, the STAT commands do acquire
it unnecessarily.  We can do the permissions and security checks only
holding the rcu lock.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/shm.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -889,27 +889,31 @@ static int shmctl_nolock(struct ipc_name
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
@@ -919,8 +923,9 @@ static int shmctl_nolock(struct ipc_name
 		tbuf.shm_cpid	= shp->shm_cprid;
 		tbuf.shm_lpid	= shp->shm_lprid;
 		tbuf.shm_nattch	= shp->shm_nattch;
-		shm_unlock(shp);
-		if(copy_shmid_to_user (buf, &tbuf, version))
+		rcu_read_unlock();
+
+		if (copy_shmid_to_user(buf, &tbuf, version))
 			err = -EFAULT;
 		else
 			err = result;
@@ -931,7 +936,7 @@ static int shmctl_nolock(struct ipc_name
 	}
 
 out_unlock:
-	shm_unlock(shp);
+	rcu_read_unlock();
 out:
 	return err;
 }


