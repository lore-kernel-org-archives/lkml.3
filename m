Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab3IUSa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 14:30:58 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:13336 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3IUSa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 14:30:56 -0400
Message-ID: <1379788235.2145.48.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] ipc: shm and msg fixes
From: Davidlohr Bueso <davidlohr@hp.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Date: Sat, 21 Sep 2013 11:30:35 -0700
In-Reply-To: <1379700524.5434.22.camel@flatline.rdu.redhat.com>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
	 <1379625742.2145.19.camel@buesod1.americas.hpqcorp.net>
	 <1379700524.5434.22.camel@flatline.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Fri, 2013-09-20 at 14:08 -0400, Eric Paris wrote:
> > > Note that Linus suggested a good alternative to patches 1 and 3: use
> > > kfree_rcu() and delay the freeing of the security structure. I would
> > > much prefer that approach to doing security checks with the lock held,
> > > but I want to leave the patches out and ready in case we go with the
> > > later solution.
> > 
> > Cc'ing selinux/security people - folks, could you please confirm that
> > this change is ok and won't break anything related to security?
> 
> I agree with the approach to delay the freeing and it does not appear to
> be a problem from an SELinux PoV, but I don't necessarily agree with the
> location of the delay.  Why should every LSM be required to know the
> details of that object lifetime?  It seems to me like we might want to
> move this delay up to shm_destroy.  I know that's going to be more code
> then using kfree_rcu(), but it seems like a much better abstraction to
> hide that knowledge away from the LSM.

This patch should only affect selinux, not all LSMs - selinux is the
only user of struct ipc_security_struct (which name IMO is too generic
and misleading). Furthermore, the hooks that are changed are all under
selinux.

> 
> Possibly place the rcu_head in struct kern_ipc_perm?  Then use
> call_rcu() to call the security destroy hook?  You'll have to re-write
> to LSM hook to take an rcu_head, etc, but that shouldn't be a big
> problem.
> 
> Doing it this way, also means you won't break the security model of
> SMACK.  It looks like you'd still have the exact same race with SMACK,
> except they can't be fixed with kfree_rcu().  They are just setting a
> pointer to NULL.  Which could then be dereferenced later.  They don't
> actually do allocation/free.

Yep, I recently noticed that, making this patch's approach invalid. I
was considering adding the rcu head to each ipc mechanism kernel private
data structure (shmid_kernel, sem_array, msg_queue). Then, like you
suggest, delaying the security freeing at the ipc level, but I think
you're right and it makes life easier to just do it at a struct
kern_ipc_perm level.

IPC uses security_xxx_free() at two levels: for freeing the structure
(ie: shm_destroy()) and cleaning up upon error when creating the
structure (ie: newseg()). For both I believe we can actually use RCU.
What do you think of the below change, it is specific for shm, and we'd
need an equivalent for msq and sems.

Thanks.

diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 8d861b2..8b98376 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -21,6 +21,7 @@ struct kern_ipc_perm
 	umode_t		mode; 
 	unsigned long	seq;
 	void		*security;
+	struct rcu_head rcu;
 };
 
 #endif /* _LINUX_IPC_H */
diff --git a/include/linux/security.h b/include/linux/security.h
index 9d37e2b..b537feb 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1860,7 +1860,7 @@ int security_msg_queue_msgsnd(struct msg_queue *msq,
 int security_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 			      struct task_struct *target, long type, int mode);
 int security_shm_alloc(struct shmid_kernel *shp);
-void security_shm_free(struct shmid_kernel *shp);
+void security_shm_free(struct rcu_head *rcu);
 int security_shm_associate(struct shmid_kernel *shp, int shmflg);
 int security_shm_shmctl(struct shmid_kernel *shp, int cmd);
 int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmflg);
@@ -2504,7 +2504,7 @@ static inline int security_shm_alloc(struct shmid_kernel *shp)
 	return 0;
 }
 
-static inline void security_shm_free(struct shmid_kernel *shp)
+static inline void security_shm_free(struct rcu_head *rcu)
 { }
 
 static inline int security_shm_associate(struct shmid_kernel *shp,
diff --git a/ipc/shm.c b/ipc/shm.c
index 2821cdf..208e490 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -208,8 +208,8 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 		user_shm_unlock(file_inode(shp->shm_file)->i_size,
 						shp->mlock_user);
 	fput (shp->shm_file);
-	security_shm_free(shp);
 	ipc_rcu_putref(shp);
+	call_rcu(&(shp)->shm_perm.rcu, security_shm_free);
 }
 
 /*
@@ -566,8 +566,8 @@ no_id:
 		user_shm_unlock(size, shp->mlock_user);
 	fput(file);
 no_file:
-	security_shm_free(shp);
 	ipc_rcu_putref(shp);
+	call_rcu(&(shp)->shm_perm.rcu, security_shm_free);
 	return error;
 }
 
diff --git a/security/security.c b/security/security.c
index 4dc31f4..1568b02 100644
--- a/security/security.c
+++ b/security/security.c
@@ -25,6 +25,7 @@
 #include <linux/mount.h>
 #include <linux/personality.h>
 #include <linux/backing-dev.h>
+#include <linux/shm.h>
 #include <net/flow.h>
 
 #define MAX_LSM_EVM_XATTR	2
@@ -990,8 +991,11 @@ int security_shm_alloc(struct shmid_kernel *shp)
 	return security_ops->shm_alloc_security(shp);
 }
 
-void security_shm_free(struct shmid_kernel *shp)
+void security_shm_free(struct rcu_head *rcu)
 {
+	struct kern_ipc_perm *ipcp = container_of(rcu, struct kern_ipc_perm, rcu);
+	struct shmid_kernel *shp = container_of(ipcp, struct shmid_kernel, shm_perm);
+
 	security_ops->shm_free_security(shp);
 }
 


