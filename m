Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3CTURR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:17:17 -0400
Received: from shelob.surriel.com ([74.92.59.67]:38947 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab3CTUPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:15:47 -0400
From: Rik van Riel <riel@surriel.com>
To: torvalds@linux-foundation.org
Cc: davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH 3/7] ipc: introduce lockless pre_down ipcctl
Date: Wed, 20 Mar 2013 15:55:33 -0400
Message-Id: <1363809337-29718-4-git-send-email-riel@surriel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

Various forms of ipc use the ipcctl_pre_down() function to
retrieve an ipc object and check permissions, mostly for IPC_RMID
and IPC_SET commands.

Introduce ipcctl_pre_down_nolock(), a lockless version of this function.
The locking version is maintained, yet modified to call the nolock version,
without affecting its semantics, thus transparent to all ipc callers.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 ipc/util.c |   31 ++++++++++++++++++++++++++-----
 ipc/util.h |    3 +++
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
1.7.7.6

