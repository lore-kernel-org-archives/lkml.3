Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3CEJgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:36:15 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:21675 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab3CEJgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:36:11 -0500
Message-ID: <1362476164.2225.52.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH v2 2/4] ipc: introduce obtaining a lockless ipc object
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 05 Mar 2013 01:36:04 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Through ipc_lock() and therefore ipc_lock_check() we currently
return the locked ipc object. This is not necessary for all situations
an can, therefore, incur in unnecessary ipc lock contention.

Introduce, analogous, ipc_obtain_object() and ipc_obtain_object_check()
functions that only lookup and return the ipc object.

Both these functions must be called within the RCU read critical section.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Reviewed-by: Chegu Vinod <chegu_vinod@hp.com>
Acked-by: Michel Lespinasse <walken@google.com>
---
 ipc/util.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++------------
 ipc/util.h |  2 ++
 2 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 464a8ab..65c3d6c 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -668,6 +668,28 @@ void ipc64_perm_to_ipc_perm (struct ipc64_perm *in, struct ipc_perm *out)
 }
 
 /**
+ * ipc_obtain_object
+ * @ids: ipc identifier set
+ * @id: ipc id to look for
+ *
+ * Look for an id in the ipc ids idr and return associated ipc object.
+ *
+ * Call inside the RCU critical section.
+ * The ipc object is *not* locked on exit.
+ */
+struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id)
+{
+	struct kern_ipc_perm *out;
+	int lid = ipcid_to_idx(id);
+
+	out = idr_find(&ids->ipcs_idr, lid);
+	if (!out)
+		return ERR_PTR(-EINVAL);
+
+	return out;
+}
+
+/**
  * ipc_lock - Lock an ipc structure without rw_mutex held
  * @ids: IPC identifier set
  * @id: ipc id to look for
@@ -680,27 +702,50 @@ void ipc64_perm_to_ipc_perm (struct ipc64_perm *in, struct ipc_perm *out)
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
-	int lid = ipcid_to_idx(id);
-
+	
 	rcu_read_lock();
-	out = idr_find(&ids->ipcs_idr, lid);
-	if (out == NULL) {
-		rcu_read_unlock();
-		return ERR_PTR(-EINVAL);
-	}
+	out = ipc_obtain_object(ids, id);
+	if (IS_ERR(out))
+		goto err1;
 
 	spin_lock(&out->lock);
-	
+
 	/* ipc_rmid() may have already freed the ID while ipc_lock
 	 * was spinning: here verify that the structure is still valid
 	 */
-	if (out->deleted) {
-		spin_unlock(&out->lock);
-		rcu_read_unlock();
-		return ERR_PTR(-EINVAL);
-	}
+	if (out->deleted)
+		goto err0;
 
 	return out;
+err0:
+	spin_unlock(&out->lock);
+err1:
+	rcu_read_unlock();
+	return ERR_PTR(-EINVAL);
+}
+
+/**
+ * ipc_obtain_object_check
+ * @ids: ipc identifier set
+ * @id: ipc id to look for
+ *
+ * Similar to ipc_obtain_object() but also checks
+ * the ipc object reference counter.
+ *
+ * Call inside the RCU critical section.
+ * The ipc object is *not* locked on exit.
+ */
+struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id)
+{
+	struct kern_ipc_perm *out = ipc_obtain_object(ids, id);
+
+	if (IS_ERR(out))
+		goto out;
+
+	if (ipc_checkid(out, id))
+		return ERR_PTR(-EIDRM);
+out:
+	return out;
 }
 
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id)
diff --git a/ipc/util.h b/ipc/util.h
index ac1480a..bfc8d4e 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -123,6 +123,7 @@ void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
+struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
@@ -168,6 +169,7 @@ static inline void ipc_unlock(struct kern_ipc_perm *perm)
 }
 
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
+struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
-- 
1.7.11.7







