Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033Ab3FSBVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:21:31 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:48269 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967Ab3FSBSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:18:51 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 03/11] ipc: drop ipcctl_pre_down
Date: Tue, 18 Jun 2013 18:18:28 -0700
Message-Id: <1371604716-3439-4-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
References: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that sem, msgque and shm, through *_down(), all use the lockless
variant of ipcctl_pre_down(), go ahead and delete it.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/util.c | 21 ++-------------------
 ipc/util.h |  3 ---
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index a0c139f..1893667 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -746,26 +746,10 @@ int ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out)
  * It must be called without any lock held and
  *  - retrieves the ipc with the given id in the given table.
  *  - performs some audit and permission check, depending on the given cmd
- *  - returns the ipc with the ipc lock held in case of success
- *    or an err-code without any lock held otherwise.
+ *  - returns a pointer to the ipc object or otherwise, the corresponding error.
  *
  * Call holding the both the rw_mutex and the rcu read lock.
  */
-struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
-				      struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extra_perm)
-{
-	struct kern_ipc_perm *ipcp;
-
-	ipcp = ipcctl_pre_down_nolock(ns, ids, id, cmd, perm, extra_perm);
-	if (IS_ERR(ipcp))
-		goto out;
-
-	spin_lock(&ipcp->lock);
-out:
-	return ipcp;
-}
-
 struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 					     struct ipc_ids *ids, int id, int cmd,
 					     struct ipc64_perm *perm, int extra_perm)
@@ -782,8 +766,7 @@ struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 
 	audit_ipc_obj(ipcp);
 	if (cmd == IPC_SET)
-		audit_ipc_set_perm(extra_perm, perm->uid,
-				   perm->gid, perm->mode);
+		audit_ipc_set_perm(extra_perm, perm->uid, perm->gid, perm->mode);
 
 	euid = current_euid();
 	if (uid_eq(euid, ipcp->cuid) || uid_eq(euid, ipcp->uid)  ||
diff --git a/ipc/util.h b/ipc/util.h
index b6a6a88..41a6c4d 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -131,9 +131,6 @@ int ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
 struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 					     struct ipc_ids *ids, int id, int cmd,
 					     struct ipc64_perm *perm, int extra_perm);
-struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
-				      struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extra_perm);
 
 #ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
-- 
1.7.11.7

