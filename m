Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3DNShv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 14:37:51 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:39440 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3DNShN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 14:37:13 -0400
X-Greylist: delayed 156364 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Apr 2013 14:37:12 EDT
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, kay@vrfy.org, greg@kroah.com,
        lennart@poettering.net, daniel@zonque.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] cgroup: make hierarchy_id use cyclic idr
Date: Sun, 14 Apr 2013 11:36:58 -0700
Message-Id: <1365964619-14762-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365964619-14762-1-git-send-email-tj@kernel.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to be able to lookup a hierarchy from its id and cyclic
allocation is a whole lot simpler with idr.  Convert to idr and use
idr_alloc_cyclc().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e15bdb7..75d85e8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -242,8 +242,7 @@ static int root_count;
  * rules as other root ops - both cgroup_mutex and cgroup_root_mutex for
  * writes, either for reads.
  */
-static DEFINE_IDA(hierarchy_ida);
-static int next_hierarchy_id;
+static DEFINE_IDR(cgroup_hierarchy_idr);
 
 /* dummytop is a shorthand for the dummy hierarchy's top cgroup */
 #define dummytop (&rootnode.top_cgroup)
@@ -1458,27 +1457,16 @@ static void init_cgroup_root(struct cgroupfs_root *root)
 
 static int cgroup_init_root_id(struct cgroupfs_root *root)
 {
-	int ret;
+	int id;
 
 	lockdep_assert_held(&cgroup_mutex);
 	lockdep_assert_held(&cgroup_root_mutex);
 
-	do {
-		if (!ida_pre_get(&hierarchy_ida, GFP_KERNEL))
-			return -ENOMEM;
-		/* Try to allocate the next unused ID */
-		ret = ida_get_new_above(&hierarchy_ida, next_hierarchy_id,
-					&root->hierarchy_id);
-		if (ret == -ENOSPC)
-			/* Try again starting from 0 */
-			ret = ida_get_new(&hierarchy_ida, &root->hierarchy_id);
-		if (!ret) {
-			next_hierarchy_id = root->hierarchy_id + 1;
-		} else if (ret != -EAGAIN) {
-			/* Can only get here if the 31-bit IDR is full ... */
-			BUG_ON(ret);
-		}
-	} while (ret);
+	id = idr_alloc_cyclic(&cgroup_hierarchy_idr, root, 2, 0, GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	root->hierarchy_id = id;
 	return 0;
 }
 
@@ -1488,7 +1476,7 @@ static void cgroup_exit_root_id(struct cgroupfs_root *root)
 	lockdep_assert_held(&cgroup_root_mutex);
 
 	if (root->hierarchy_id) {
-		ida_remove(&hierarchy_ida, root->hierarchy_id);
+		idr_remove(&cgroup_hierarchy_idr, root->hierarchy_id);
 		root->hierarchy_id = 0;
 	}
 }
-- 
1.8.1.4

