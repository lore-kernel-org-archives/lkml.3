Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657Ab3JPSL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:11:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761489Ab3JPRp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 53/69] ipc,shm: shorten critical region for shmctl
Date: Wed, 16 Oct 2013 10:45:02 -0700
Message-Id: <20131016174319.371003199@linuxfoundation.org>
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

commit 2caacaa82a51b78fc0c800e206473874094287ed upstream.

With the *_INFO, *_STAT, IPC_RMID and IPC_SET commands already optimized,
deal with the remaining SHM_LOCK and SHM_UNLOCK commands.  Take the
shm_perm lock after doing the initial auditing and security checks.  The
rest of the logic remains unchanged.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/shm.c |   49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -940,10 +940,8 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 	int err, version;
 	struct ipc_namespace *ns;
 
-	if (cmd < 0 || shmid < 0) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (cmd < 0 || shmid < 0)
+		return -EINVAL;
 
 	version = ipc_parse_version(&cmd);
 	ns = current->nsproxy->ipc_ns;
@@ -954,36 +952,40 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 	case SHM_STAT:
 	case IPC_STAT:
 		return shmctl_nolock(ns, shmid, cmd, version, buf);
+	case IPC_RMID:
+	case IPC_SET:
+		return shmctl_down(ns, shmid, cmd, buf, version);
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
 		struct file *shm_file;
 
-		shp = shm_lock_check(ns, shmid);
+		rcu_read_lock();
+		shp = shm_obtain_object_check(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
-			goto out;
+			goto out_unlock1;
 		}
 
 		audit_ipc_obj(&(shp->shm_perm));
+		err = security_shm_shmctl(shp, cmd);
+		if (err)
+			goto out_unlock1;
 
+		ipc_lock_object(&shp->shm_perm);
 		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
 			kuid_t euid = current_euid();
 			err = -EPERM;
 			if (!uid_eq(euid, shp->shm_perm.uid) &&
 			    !uid_eq(euid, shp->shm_perm.cuid))
-				goto out_unlock;
+				goto out_unlock0;
 			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK))
-				goto out_unlock;
+				goto out_unlock0;
 		}
 
-		err = security_shm_shmctl(shp, cmd);
-		if (err)
-			goto out_unlock;
-
 		shm_file = shp->shm_file;
 		if (is_file_hugepages(shm_file))
-			goto out_unlock;
+			goto out_unlock0;
 
 		if (cmd == SHM_LOCK) {
 			struct user_struct *user = current_user();
@@ -992,32 +994,31 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 				shp->shm_perm.mode |= SHM_LOCKED;
 				shp->mlock_user = user;
 			}
-			goto out_unlock;
+			goto out_unlock0;
 		}
 
 		/* SHM_UNLOCK */
 		if (!(shp->shm_perm.mode & SHM_LOCKED))
-			goto out_unlock;
+			goto out_unlock0;
 		shmem_lock(shm_file, 0, shp->mlock_user);
 		shp->shm_perm.mode &= ~SHM_LOCKED;
 		shp->mlock_user = NULL;
 		get_file(shm_file);
-		shm_unlock(shp);
+		ipc_unlock_object(&shp->shm_perm);
+		rcu_read_unlock();
 		shmem_unlock_mapping(shm_file->f_mapping);
+
 		fput(shm_file);
-		goto out;
-	}
-	case IPC_RMID:
-	case IPC_SET:
-		err = shmctl_down(ns, shmid, cmd, buf, version);
 		return err;
+	}
 	default:
 		return -EINVAL;
 	}
 
-out_unlock:
-	shm_unlock(shp);
-out:
+out_unlock0:
+	ipc_unlock_object(&shp->shm_perm);
+out_unlock1:
+	rcu_read_unlock();
 	return err;
 }
 


