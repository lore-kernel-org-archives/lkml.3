Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935299Ab3JPSKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:10:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761510Ab3JPRp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 55/69] ipc,shm: shorten critical region for shmat
Date: Wed, 16 Oct 2013 10:45:04 -0700
Message-Id: <20131016174319.620714481@linuxfoundation.org>
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

commit c2c737a0461e61a34676bd0bd1bc1a70a1b4e396 upstream.

Similar to other system calls, acquire the kern_ipc_perm lock after doing
the initial permission and security checks.

[sasha.levin@oracle.com: dont leave do_shmat with rcu lock held]
Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/shm.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -19,6 +19,9 @@
  * namespaces support
  * OpenVZ, SWsoft Inc.
  * Pavel Emelianov <xemul@openvz.org>
+ *
+ * Better ipc lock (kern_ipc_perm.lock) handling
+ * Davidlohr Bueso <davidlohr.bueso@hp.com>, June 2013.
  */
 
 #include <linux/slab.h>
@@ -1086,10 +1089,11 @@ long do_shmat(int shmid, char __user *sh
 	 * additional creator id...
 	 */
 	ns = current->nsproxy->ipc_ns;
-	shp = shm_lock_check(ns, shmid);
+	rcu_read_lock();
+	shp = shm_obtain_object_check(ns, shmid);
 	if (IS_ERR(shp)) {
 		err = PTR_ERR(shp);
-		goto out;
+		goto out_unlock;
 	}
 
 	err = -EACCES;
@@ -1100,11 +1104,13 @@ long do_shmat(int shmid, char __user *sh
 	if (err)
 		goto out_unlock;
 
+	ipc_lock_object(&shp->shm_perm);
 	path = shp->shm_file->f_path;
 	path_get(&path);
 	shp->shm_nattch++;
 	size = i_size_read(path.dentry->d_inode);
-	shm_unlock(shp);
+	ipc_unlock_object(&shp->shm_perm);
+	rcu_read_unlock();
 
 	err = -ENOMEM;
 	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
@@ -1175,7 +1181,7 @@ out_nattch:
 	return err;
 
 out_unlock:
-	shm_unlock(shp);
+	rcu_read_unlock();
 out:
 	return err;
 }


