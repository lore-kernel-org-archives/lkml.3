Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3BCBXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:23:14 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:40944 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab3BCBXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:23:05 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: [PATCH 55/62] cgroup: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:56 -0800
Message-Id: <1359854463-2538-56-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org
Cc: cgroups@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 kernel/cgroup.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6b18c5c..4ee1102 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5272,7 +5272,7 @@ EXPORT_SYMBOL_GPL(free_css_id);
 static struct css_id *get_new_cssid(struct cgroup_subsys *ss, int depth)
 {
 	struct css_id *newid;
-	int myid, error, size;
+	int ret, size;
 
 	BUG_ON(!ss->use_id);
 
@@ -5280,35 +5280,24 @@ static struct css_id *get_new_cssid(struct cgroup_subsys *ss, int depth)
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

