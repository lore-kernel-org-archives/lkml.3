Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab3CEJgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:36:19 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:21753 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab3CEJgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:36:16 -0500
Message-ID: <1362476173.2225.53.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH v2 3/4] ipc: introduce lockless pre_down ipcctl
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
Date: Tue, 05 Mar 2013 01:36:13 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various forms of ipc use the ipcctl_pre_down() function to
retrieve an ipc object and check permissions, mostly for IPC_RMID
and IPC_SET commands.

Introduce ipcctl_pre_down_nolock(), a lockless version of this function.
The locking version is maintained, yet modified to call the nolock version,
without affecting its semantics, thus transparent to all ipc callers.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 ipc/util.c | 31 ++++++++++++++++++++++++++-----
 ipc/util.h |  3 +++
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 65c3d6c..6a98e62 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -825,11 +825,28 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 				      struct ipc64_perm *perm, int extra_perm)
 {
 	struct kern_ipc_perm *ipcp;
+
+	ipcp = ipcctl_pre_down_nolock(ns, ids, id, cmd, perm, extra_perm);
+	if (IS_ERR(ipcp))
+		goto out;
+
+	spin_lock(&ipcp->lock);
+out:
+	return ipcp;
+}
+
+struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
+					     struct ipc_ids *ids, int id, int cmd,
+					     struct ipc64_perm *perm, int extra_perm)
+{
 	kuid_t euid;
-	int err;
+	int err = -EPERM;
+	struct kern_ipc_perm *ipcp;
 
 	down_write(&ids->rw_mutex);
-	ipcp = ipc_lock_check(ids, id);
+	rcu_read_lock();
+
+	ipcp = ipc_obtain_object_check(ids, id);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
 		goto out_up;
@@ -838,17 +855,21 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 	audit_ipc_obj(ipcp);
 	if (cmd == IPC_SET)
 		audit_ipc_set_perm(extra_perm, perm->uid,
-					 perm->gid, perm->mode);
+				   perm->gid, perm->mode);
 
 	euid = current_euid();
 	if (uid_eq(euid, ipcp->cuid) || uid_eq(euid, ipcp->uid)  ||
 	    ns_capable(ns->user_ns, CAP_SYS_ADMIN))
 		return ipcp;
 
-	err = -EPERM;
-	ipc_unlock(ipcp);
 out_up:
+	/*
+	 * Unsuccessful lookup, unlock and return
+	 * the corresponding error.
+	 */
+	rcu_read_unlock();
 	up_write(&ids->rw_mutex);
+
 	return ERR_PTR(err);
 }
 
diff --git a/ipc/util.h b/ipc/util.h
index bfc8d4e..13d92fe 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -128,6 +128,9 @@ struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id);
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
 int ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
+struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
+					     struct ipc_ids *ids, int id, int cmd,
+					     struct ipc64_perm *perm, int extra_perm);
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 				      struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm);
-- 
1.7.11.7





