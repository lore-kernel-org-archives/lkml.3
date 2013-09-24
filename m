Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3IXAFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:05:14 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:6070 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3IXAFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:05:11 -0400
Message-ID: <1379981085.2060.18.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] ipc: shm and msg fixes
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@parisplace.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Date: Mon, 23 Sep 2013 17:04:45 -0700
In-Reply-To: <CA+55aFzVnivKb=nwzeTjGvi=LvnBLGnr=NZE+Ns6kLSm=WCN4w@mail.gmail.com>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
	 <1379625742.2145.19.camel@buesod1.americas.hpqcorp.net>
	 <1379700524.5434.22.camel@flatline.rdu.redhat.com>
	 <1379788235.2145.48.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwQp6Fm9-Zrn3uue9bFe9tERCbVv5Z-z9r4ZgOmS0VB+Q@mail.gmail.com>
	 <1379918525.2231.0.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFzVnivKb=nwzeTjGvi=LvnBLGnr=NZE+Ns6kLSm=WCN4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 09:54 -0700, Linus Torvalds wrote:
> On Sun, Sep 22, 2013 at 11:42 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >>
> >> More importantly, it's wrong. You do the call_rcu() unconditionally,
> >> but it might not be the last use! You need to do it with the same
> >> logic ipc_rcu_putref(), namely at the dropping of the last reference.
> >
> > This is the way IPC has handled things for a long time, no? Security
> > does not depend on the reference counter, as we unconditionally free
> > security structs.
> 
> Yes, but that was ok back when the logic was idem-potent and you could
> call it multiple times. Modulo races (I didn't check if we held a
> lock).
> 
> You can't do "call_rcu()" more than once, because you'll corrupt the
> rcu list if you do another call_rcu() while the first one is still
> active (and that's a pretty big race window to hit).

Ah, ok understood.

> 
> That said, the old behavior was suspect for another reason too: having
> the security blob go away from under a user sounds like it could cause
> various other problems anyway, so I think the old code was at least
> _prone_ to bugs even if it didn't have catastrophic behavior.

Agreed. This makes a lot of sense, I just wanted to verify that we're
all on the same page with this, as it does change current and well
tested logic. Eric, Manfred, please shout if you see a problem,
otherwise I'd appreciate your ack/reviewed-by.

> 
> (In reality, I suspect the reference count is never elevated in
> practice, so there is only one case that calls the security freeing
> thing, so this may all be pretty much theoretical, but at least from a
> logic standpoint the code clearly makes a big deal about the whole
> refcount and "last user turns off the lights").

Right, this would/should have come up years ago if it were actually
occurring in practice.

> 
> > What you're suggesting, is (i) freeing security will now depend on the
> > refcount (wouldn't this cause cases where we actually never end up
> > freeing?)
> 
> The security layer better not have any refcounted backpointers to the
> shm, so I don't see why that would be a new issue.
> 
> >  and (ii) in the scenarios we actually need to free the
> > security, delay it along with freeing the actual ipc_rcu stuff.
> 
> Well, that's the whole point. The security blob should have the same
> lifetime as the ipc blob it is associated with.
> 
> Getting rid of the security blob before the thing it is supposed to
> protect sounds like  a bug to me. In fact, it's the bug that this
> whole thread has been about. No?
> 
> > If I understand correctly, then we'd have:
> >
> > void ipc_rcu_putref(void *ptr, void (*func)(struct rcu_head *head))
> > {
> >         struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
> >
> >         if (!atomic_dec_and_test(&p->refcount))
> >                 return;
> >
> >         call_rcu(&p->rcu, func);
> > }
> 
> Exactly.

Ok, so here's the code - again I've tested it with LTP on the resources
I have. While I have yet to hit the races we are trying to address, I
just wanted to make sure it doesn't affect in anything else. The changes
are pretty monotonous and affect all forms of IPC - it doesn't make
sense splitting it since we're changing the global putref logic. All in
all, it changes the following pattern (ie: sems):

-     ipc_rcu_putref(sma);
+     ipc_rcu_putref(sma, ipc_rcu_free);

and

-       security_sem_free(sma);
-       ipc_rcu_putref(sma);
+       ipc_rcu_putref(sma, sem_rcu_free);

Note that for ipc/sem.c, it also gets rid of the useless sem_putref(),
which is a straight call to ipc_rcu_putref().

If taken, this should fix shm + msq + sem and I'll backport it to 3.11
for msq + sem and 3.10 for sems.

Thanks!

8<-----------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH] ipc: fix race with LSMs

Currently, IPC mechanisms do security and auditing related checks under
RCU. However, since security modules can free the security structure, for
example, through selinux_[sem,msg_queue,shm]_free_security(), we can race
if the structure is freed before other tasks are done with it, creating a
use-after-free condition. Manfred illustrates this nicely, for instance with
shared mem and selinux:

--> do_shmat calls rcu_read_lock()
--> do_shmat calls shm_object_check().
     Checks that the object is still valid - but doesn't acquire any locks.
     Then it returns.
--> do_shmat calls security_shm_shmat (e.g. selinux_shm_shmat)
--> selinux_shm_shmat calls ipc_has_perm()
--> ipc_has_perm accesses ipc_perms->security

shm_close()
--> shm_close acquires rw_mutex & shm_lock
--> shm_close calls shm_destroy
--> shm_destroy calls security_shm_free (e.g. selinux_shm_free_security)
--> selinux_shm_free_security calls ipc_free_security(&shp->shm_perm)
--> ipc_free_security calls kfree(ipc_perms->security)

This patch delays the freeing of the security structures after all RCU readers
are done. Furthermore it aligns the security life cycle with that of the rest of
IPC - freeing them based on the reference counter. For situations where we need
not free security, the current behavior is kept. Linus states:

"... the old behavior was suspect for another reason too: having
the security blob go away from under a user sounds like it could cause
various other problems anyway, so I think the old code was at least
_prone_ to bugs even if it didn't have catastrophic behavior."

I have tested this patch with IPC testcases from LTP on both my quad-core
laptop and on a 64 core NUMA server. In both cases selinux is enabled, and
tests pass for both voluntary and forced preemption models. While the mentioned
races are theoretical (at least no one as reported them), I wanted to make
sure that this new logic doesn't break anything we weren't aware of.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/msg.c  | 19 +++++++++++++------
 ipc/sem.c  | 34 ++++++++++++++++++----------------
 ipc/shm.c  | 17 ++++++++++++-----
 ipc/util.c | 32 ++++++++++++--------------------
 ipc/util.h | 10 +++++++++-
 5 files changed, 64 insertions(+), 48 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index b0d541d4..9e4310c 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -165,6 +165,15 @@ static inline void msg_rmid(struct ipc_namespace *ns, struct msg_queue *s)
 	ipc_rmid(&msg_ids(ns), &s->q_perm);
 }
 
+static void msg_rcu_free(struct rcu_head *head)
+{
+	struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
+	struct msg_queue *msq = ipc_rcu_to_struct(p);
+
+	security_msg_queue_free(msq);
+	ipc_rcu_free(head);
+}
+
 /**
  * newque - Create a new msg queue
  * @ns: namespace
@@ -189,15 +198,14 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	msq->q_perm.security = NULL;
 	retval = security_msg_queue_alloc(msq);
 	if (retval) {
-		ipc_rcu_putref(msq);
+		ipc_rcu_putref(msq, ipc_rcu_free);
 		return retval;
 	}
 
 	/* ipc_addid() locks msq upon success. */
 	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
 	if (id < 0) {
-		security_msg_queue_free(msq);
-		ipc_rcu_putref(msq);
+		ipc_rcu_putref(msq, msg_rcu_free);
 		return id;
 	}
 
@@ -276,8 +284,7 @@ static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 		free_msg(msg);
 	}
 	atomic_sub(msq->q_cbytes, &ns->msg_bytes);
-	security_msg_queue_free(msq);
-	ipc_rcu_putref(msq);
+	ipc_rcu_putref(msq, msg_rcu_free);
 }
 
 /*
@@ -717,7 +724,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 		rcu_read_lock();
 		ipc_lock_object(&msq->q_perm);
 
-		ipc_rcu_putref(msq);
+		ipc_rcu_putref(msq, ipc_rcu_free);
 		if (msq->q_perm.deleted) {
 			err = -EIDRM;
 			goto out_unlock0;
diff --git a/ipc/sem.c b/ipc/sem.c
index 69b6a21..19c8b98 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -243,6 +243,15 @@ static void merge_queues(struct sem_array *sma)
 	}
 }
 
+static void sem_rcu_free(struct rcu_head *head)
+{
+	struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
+	struct sem_array *sma = ipc_rcu_to_struct(p);
+
+	security_sem_free(sma);
+	ipc_rcu_free(head);
+}
+
 /*
  * If the request contains only one semaphore operation, and there are
  * no complex transactions pending, lock only the semaphore involved.
@@ -374,12 +383,7 @@ static inline struct sem_array *sem_obtain_object_check(struct ipc_namespace *ns
 static inline void sem_lock_and_putref(struct sem_array *sma)
 {
 	sem_lock(sma, NULL, -1);
-	ipc_rcu_putref(sma);
-}
-
-static inline void sem_putref(struct sem_array *sma)
-{
-	ipc_rcu_putref(sma);
+	ipc_rcu_putref(sma, ipc_rcu_free);
 }
 
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
@@ -458,14 +462,13 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	sma->sem_perm.security = NULL;
 	retval = security_sem_alloc(sma);
 	if (retval) {
-		ipc_rcu_putref(sma);
+		ipc_rcu_putref(sma, ipc_rcu_free);
 		return retval;
 	}
 
 	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
 	if (id < 0) {
-		security_sem_free(sma);
-		ipc_rcu_putref(sma);
+		ipc_rcu_putref(sma, sem_rcu_free);
 		return id;
 	}
 	ns->used_sems += nsems;
@@ -1047,8 +1050,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 
 	wake_up_sem_queue_do(&tasks);
 	ns->used_sems -= sma->sem_nsems;
-	security_sem_free(sma);
-	ipc_rcu_putref(sma);
+	ipc_rcu_putref(sma, sem_rcu_free);
 }
 
 static unsigned long copy_semid_to_user(void __user *buf, struct semid64_ds *in, int version)
@@ -1292,7 +1294,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 			rcu_read_unlock();
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if(sem_io == NULL) {
-				sem_putref(sma);
+				ipc_rcu_putref(sma, ipc_rcu_free);
 				return -ENOMEM;
 			}
 
@@ -1328,20 +1330,20 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		if(nsems > SEMMSL_FAST) {
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if(sem_io == NULL) {
-				sem_putref(sma);
+				ipc_rcu_putref(sma, ipc_rcu_free);
 				return -ENOMEM;
 			}
 		}
 
 		if (copy_from_user (sem_io, p, nsems*sizeof(ushort))) {
-			sem_putref(sma);
+			ipc_rcu_putref(sma, ipc_rcu_free);
 			err = -EFAULT;
 			goto out_free;
 		}
 
 		for (i = 0; i < nsems; i++) {
 			if (sem_io[i] > SEMVMX) {
-				sem_putref(sma);
+				ipc_rcu_putref(sma, ipc_rcu_free);
 				err = -ERANGE;
 				goto out_free;
 			}
@@ -1629,7 +1631,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	/* step 2: allocate new undo structure */
 	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
 	if (!new) {
-		sem_putref(sma);
+		ipc_rcu_putref(sma, ipc_rcu_free);
 		return ERR_PTR(-ENOMEM);
 	}
 
diff --git a/ipc/shm.c b/ipc/shm.c
index 2821cdf..d697396 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -167,6 +167,15 @@ static inline void shm_lock_by_ptr(struct shmid_kernel *ipcp)
 	ipc_lock_object(&ipcp->shm_perm);
 }
 
+static void shm_rcu_free(struct rcu_head *head)
+{
+	struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
+	struct shmid_kernel *shp = ipc_rcu_to_struct(p);
+
+	security_shm_free(shp);
+	ipc_rcu_free(head);
+}
+
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
 {
 	ipc_rmid(&shm_ids(ns), &s->shm_perm);
@@ -208,8 +217,7 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 		user_shm_unlock(file_inode(shp->shm_file)->i_size,
 						shp->mlock_user);
 	fput (shp->shm_file);
-	security_shm_free(shp);
-	ipc_rcu_putref(shp);
+	ipc_rcu_putref(shp, shm_rcu_free);
 }
 
 /*
@@ -497,7 +505,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	shp->shm_perm.security = NULL;
 	error = security_shm_alloc(shp);
 	if (error) {
-		ipc_rcu_putref(shp);
+		ipc_rcu_putref(shp, ipc_rcu_free);
 		return error;
 	}
 
@@ -566,8 +574,7 @@ no_id:
 		user_shm_unlock(size, shp->mlock_user);
 	fput(file);
 no_file:
-	security_shm_free(shp);
-	ipc_rcu_putref(shp);
+	ipc_rcu_putref(shp, shm_rcu_free);
 	return error;
 }
 
diff --git a/ipc/util.c b/ipc/util.c
index e829da9..fdb8ae7 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -474,11 +474,6 @@ void ipc_free(void* ptr, int size)
 		kfree(ptr);
 }
 
-struct ipc_rcu {
-	struct rcu_head rcu;
-	atomic_t refcount;
-} ____cacheline_aligned_in_smp;
-
 /**
  *	ipc_rcu_alloc	-	allocate ipc and rcu space 
  *	@size: size desired
@@ -505,27 +500,24 @@ int ipc_rcu_getref(void *ptr)
 	return atomic_inc_not_zero(&p->refcount);
 }
 
-/**
- * ipc_schedule_free - free ipc + rcu space
- * @head: RCU callback structure for queued work
- */
-static void ipc_schedule_free(struct rcu_head *head)
-{
-	vfree(container_of(head, struct ipc_rcu, rcu));
-}
-
-void ipc_rcu_putref(void *ptr)
+void ipc_rcu_putref(void *ptr, void (*func)(struct rcu_head *head))
 {
 	struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
 
 	if (!atomic_dec_and_test(&p->refcount))
 		return;
 
-	if (is_vmalloc_addr(ptr)) {
-		call_rcu(&p->rcu, ipc_schedule_free);
-	} else {
-		kfree_rcu(p, rcu);
-	}
+	call_rcu(&p->rcu, func);
+}
+
+void ipc_rcu_free(struct rcu_head *head)
+{
+	struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
+
+	if (is_vmalloc_addr(p))
+		vfree(p);
+	else
+		kfree(p);
 }
 
 /**
diff --git a/ipc/util.h b/ipc/util.h
index c5f3338b..f2f5036 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -47,6 +47,13 @@ static inline void msg_exit_ns(struct ipc_namespace *ns) { }
 static inline void shm_exit_ns(struct ipc_namespace *ns) { }
 #endif
 
+struct ipc_rcu {
+	struct rcu_head rcu;
+	atomic_t refcount;
+} ____cacheline_aligned_in_smp;
+
+#define ipc_rcu_to_struct(p)  ((void *)(p+1))
+
 /*
  * Structure that holds the parameters needed by the ipc operations
  * (see after)
@@ -120,7 +127,8 @@ void ipc_free(void* ptr, int size);
  */
 void* ipc_rcu_alloc(int size);
 int ipc_rcu_getref(void *ptr);
-void ipc_rcu_putref(void *ptr);
+void ipc_rcu_putref(void *ptr, void (*func)(struct rcu_head *head));
+void ipc_rcu_free(struct rcu_head *head);
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
 struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id);
-- 
1.7.11.7



