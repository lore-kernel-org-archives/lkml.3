Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3BCBXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:23:08 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50520 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab3BCBXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:23:03 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>
Subject: [PATCH 54/62] ipc: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:55 -0800
Message-Id: <1359854463-2538-55-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

The new interface doesn't directly translate to the way idr_pre_get()
was used around ipc_addid() as preloading disables preemption.  From
my cursory reading, it seems like we should be able to do all
allocation from ipc_addid(), so I moved it there.  Can you please
check whether this would be okay?  If this is wrong and ipc_addid()
should be allowed to be called from non-sleepable context, I'd suggest
allocating id itself in the outer functions and later install the
pointer using idr_replace().

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 ipc/util.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 74e1d9c..91ce0bc 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -252,7 +252,7 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 {
 	kuid_t euid;
 	kgid_t egid;
-	int id, err;
+	int id;
 	int next_id = ids->next_id;
 
 	if (size > IPCMNI)
@@ -261,17 +261,21 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
+	idr_preload(GFP_KERNEL);
+
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
 	rcu_read_lock();
 	spin_lock(&new->lock);
 
-	err = idr_get_new_above(&ids->ipcs_idr, new,
-				(next_id < 0) ? 0 : ipcid_to_idx(next_id), &id);
-	if (err) {
+	id = idr_alloc(&ids->ipcs_idr, new,
+		       (next_id < 0) ? 0 : ipcid_to_idx(next_id), 0,
+		       GFP_NOWAIT);
+	idr_preload_end();
+	if (id < 0) {
 		spin_unlock(&new->lock);
 		rcu_read_unlock();
-		return err;
+		return id;
 	}
 
 	ids->in_use++;
@@ -307,19 +311,10 @@ static int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
 		struct ipc_ops *ops, struct ipc_params *params)
 {
 	int err;
-retry:
-	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
-
-	if (!err)
-		return -ENOMEM;
 
 	down_write(&ids->rw_mutex);
 	err = ops->getnew(ns, params);
 	up_write(&ids->rw_mutex);
-
-	if (err == -EAGAIN)
-		goto retry;
-
 	return err;
 }
 
@@ -375,9 +370,7 @@ static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
 {
 	struct kern_ipc_perm *ipcp;
 	int flg = params->flg;
-	int err;
-retry:
-	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
+	int err = 0;
 
 	/*
 	 * Take the lock as a writer since we are potentially going to add
@@ -413,9 +406,6 @@ retry:
 	}
 	up_write(&ids->rw_mutex);
 
-	if (err == -EAGAIN)
-		goto retry;
-
 	return err;
 }
 
-- 
1.8.1

