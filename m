Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab3BFTy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:54:26 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39678 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3BFTvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:19 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [PATCH 71/77] cgroup: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:43 -0800
Message-Id: <1360179649-22465-72-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org
Cc: cgroups@vger.kernel.org
---
 kernel/cgroup.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 525c508..29f9e11 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5284,7 +5284,7 @@ EXPORT_SYMBOL_GPL(free_css_id);
 static struct css_id *get_new_cssid(struct cgroup_subsys *ss, int depth)
 {
 	struct css_id *newid;
-	int myid, error, size;
+	int ret, size;
 
 	BUG_ON(!ss->use_id);
 
@@ -5292,35 +5292,24 @@ static struct css_id *get_new_cssid(struct cgroup_subsys *ss, int depth)
 	newid = kzalloc(size, GFP_KERNEL);
 	if (!newid)
 		return ERR_PTR(-ENOMEM);
-	/* get id */
-	if (unlikely(!idr_pre_get(&ss->idr, GFP_KERNEL))) {
-		error = -ENOMEM;
-		goto err_out;
-	}
+
+	idr_preload(GFP_KERNEL);
 	spin_lock(&ss->id_lock);
 	/* Don't use 0. allocates an ID of 1-65535 */
-	error = idr_get_new_above(&ss->idr, newid, 1, &myid);
+	ret = idr_alloc(&ss->idr, newid, 1, CSS_ID_MAX + 1, GFP_NOWAIT);
 	spin_unlock(&ss->id_lock);
+	idr_preload_end();
 
 	/* Returns error when there are no free spaces for new ID.*/
-	if (error) {
-		error = -ENOSPC;
+	if (ret < 0)
 		goto err_out;
-	}
-	if (myid > CSS_ID_MAX)
-		goto remove_idr;
 
-	newid->id = myid;
+	newid->id = ret;
 	newid->depth = depth;
 	return newid;
-remove_idr:
-	error = -ENOSPC;
-	spin_lock(&ss->id_lock);
-	idr_remove(&ss->idr, myid);
-	spin_unlock(&ss->id_lock);
 err_out:
 	kfree(newid);
-	return ERR_PTR(error);
+	return ERR_PTR(ret);
 
 }
 
-- 
1.8.1

