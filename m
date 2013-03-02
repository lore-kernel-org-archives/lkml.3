Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3CBAQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 19:16:46 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:27698 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab3CBAQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 19:16:43 -0500
Message-ID: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net>
Subject: [RFC PATCH 1/2] ipc: introduce obtaining a lockless ipc object
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Cc: "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 01 Mar 2013 16:16:40 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Through ipc_lock() and, therefore, ipc_lock_check() we currently
return the locked ipc object. This is not necessary for all situations,
thus introduce, analogous, ipc_obtain_object and ipc_obtain_object_check
functions that only mark the RCU read critical region without acquiring
the lock and return the ipc object.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/util.c | 42 ++++++++++++++++++++++++++++++++----------
 ipc/util.h |  2 ++
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 464a8ab..902f282 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -667,6 +667,21 @@ void ipc64_perm_to_ipc_perm (struct ipc64_perm *in, struct ipc_perm *out)
 	out->seq	= in->seq;
 }
 
+struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id)
+{
+	struct kern_ipc_perm *out;
+	int lid = ipcid_to_idx(id);
+
+	rcu_read_lock();
+	out = idr_find(&ids->ipcs_idr, lid);
+	if (!out) {
+		rcu_read_unlock();
+		return ERR_PTR(-EINVAL);
+	}
+
+	return out;
+}
+
 /**
  * ipc_lock - Lock an ipc structure without rw_mutex held
  * @ids: IPC identifier set
@@ -679,18 +694,13 @@ void ipc64_perm_to_ipc_perm (struct ipc64_perm *in, struct ipc_perm *out)
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 {
-	struct kern_ipc_perm *out;
-	int lid = ipcid_to_idx(id);
+	struct kern_ipc_perm *out = ipc_obtain_object(ids, id);
 
-	rcu_read_lock();
-	out = idr_find(&ids->ipcs_idr, lid);
-	if (out == NULL) {
-		rcu_read_unlock();
+	if (!out)
 		return ERR_PTR(-EINVAL);
-	}
 
 	spin_lock(&out->lock);
-	
+
 	/* ipc_rmid() may have already freed the ID while ipc_lock
 	 * was spinning: here verify that the structure is still valid
 	 */
@@ -703,6 +713,18 @@ struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 	return out;
 }
 
+struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id)
+{
+	struct kern_ipc_perm *out = ipc_obtain_object(ids, id);
+
+	if (IS_ERR(out))
+		return out;
+
+	if (ipc_checkid(out, id))
+		return ERR_PTR(-EIDRM);
+	return out;
+}
+
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
@@ -784,7 +806,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 	int err;
 
 	down_write(&ids->rw_mutex);
-	ipcp = ipc_lock_check(ids, id);
+	ipcp = ipc_obtain_object_check(ids, id);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
 		goto out_up;
@@ -801,7 +823,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 		return ipcp;
 
 	err = -EPERM;
-	ipc_unlock(ipcp);
+	rcu_read_unlock();
 out_up:
 	up_write(&ids->rw_mutex);
 	return ERR_PTR(err);
diff --git a/ipc/util.h b/ipc/util.h
index eeb79a1..2c68035 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -123,6 +123,7 @@ void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
+struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
@@ -173,6 +174,7 @@ static inline void ipc_unlock(struct kern_ipc_perm *perm)
 }
 
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
+struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
-- 
1.7.11.7




