Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3ISVW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:22:29 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:13164 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3ISVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:22:27 -0400
Message-ID: <1379625742.2145.19.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] ipc: shm and msg fixes
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org
Date: Thu, 19 Sep 2013 14:22:22 -0700
In-Reply-To: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-15 at 20:04 -0700, Davidlohr Bueso wrote:
> This patchset deals with the selinux and rmid races Manfred found on
> the ipc scaling work that has been going on. It specifically addresses
> shared mem and msg queues. While semaphores still need updated, I want
> to make sure these are correct first. Also, Manfred had already sent out
> a patchset that deals with a race in sem complex operations. So any changes
> should be on top of his.
> 
> Patches 1 and 2 deal with shared memory.
> Patches 3 and 4 deal with msg queues.
> Specific details about each race and its fix are in the corresponding
> patches.
> 
> Note that Linus suggested a good alternative to patches 1 and 3: use
> kfree_rcu() and delay the freeing of the security structure. I would
> much prefer that approach to doing security checks with the lock held,
> but I want to leave the patches out and ready in case we go with the
> later solution.

Cc'ing selinux/security people - folks, could you please confirm that
this change is ok and won't break anything related to security?

Thanks!


8<-------------------------------------------

From: Davidlohr Bueso <davidlohr@hp.com>
Date: Thu, 19 Sep 2013 09:32:05 -0700
Subject: [PATCH] selinux: rely on rcu to free ipc isec

Currently, IPC mechanisms do security and auditing related checks under
RCU. However, since selinux can free the security structure, through
selinux_[sem,msg_queue,shm]_free_security(), we can race if the structure
is freed before other tasks are done with it, creating a use-after-free
condition. Manfred illustrates this nicely, for example with shared mem:

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

There are two solutions to this: (i) perform the security checking and whatever
IPC operation(s) atomically (that is, with the kern_ipc_perm.lock held), or
(ii) delay the freeing of the isec structure after all RCU readers are done.
This patch takes the second approach, which, at least from a performance perspective,
is more practical than the first as it keeps the IPC critical regions smaller.

I have tested this patch with IPC testcases from LTP on both my quad-core
laptop and on a 64 core NUMA server. In both cases selinux is enabled, and
tests pass for both voluntary and forced preemption models.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 security/selinux/hooks.c          | 9 ++++++++-
 security/selinux/include/objsec.h | 5 +++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a5091ec..179ffe9 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4892,8 +4892,15 @@ static int ipc_alloc_security(struct task_struct *task,
 static void ipc_free_security(struct kern_ipc_perm *perm)
 {
 	struct ipc_security_struct *isec = perm->security;
+
+	/*
+	 * All IPC mechanisms do security and audit
+	 * checking under RCU: wait a grace period before
+	 * freeing isec, otherwise we can run into a
+	 * use-after-free scenario.
+	 */
+	kfree_rcu(isec, rcu);
 	perm->security = NULL;
-	kfree(isec);
 }
 
 static int msg_msg_alloc_security(struct msg_msg *msg)
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index aa47bca..38d17b7 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -70,8 +70,9 @@ struct msg_security_struct {
 };
 
 struct ipc_security_struct {
-	u16 sclass;	/* security class of this object */
-	u32 sid;	/* SID of IPC resource */
+	u16 sclass;	     /* security class of this object */
+	u32 sid;             /* SID of IPC resource */
+	struct rcu_head	rcu; /* rcu struct for selinux based IPC security */
 };
 
 struct netif_security_struct {
-- 
1.7.11.7



