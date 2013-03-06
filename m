Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3CFWPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:15:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab3CFWPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:15:50 -0500
Date: Wed, 6 Mar 2013 17:14:43 -0500
From: Rik van Riel <riel@redhat.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 6/4] ipc: open code and rename sem_lock
Message-ID: <20130306171443.6a1ee9d6@cuia.bos.redhat.com>
In-Reply-To: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
index efb49e7..d92ba32 100644
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
+	write_lock(&ipcp->lock);
+
+	/* ipc_rmid() may have already freed the ID while write_lock
+	 * was spinning: verify that the structure is still valid
+	 */
+	if (ipcp->deleted)
+		goto err0;
 
 	return container_of(ipcp, struct sem_array, sem_perm);
+err0:
+	write_unlock(&ipcp->lock);
+err1:
+	rcu_read_unlock();
+	return ERR_PTR(-EINVAL);
 }
 
 static inline struct sem_array *sem_obtain_object(struct ipc_namespace *ns, int id)
@@ -1558,7 +1573,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		goto out_free;
 	}
 
-	sma = sem_lock(ns, semid);
+	sma = sem_obtain_lock(ns, semid);
 
 	/*
 	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.

