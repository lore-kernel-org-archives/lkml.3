Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaA1PcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:32:19 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:36990 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1PcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:32:15 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] cgroup: fix error return value in cgroup_mount()
Date: Tue, 28 Jan 2014 10:32:02 -0500
Message-Id: <1390923125-4369-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390923125-4369-1-git-send-email-tj@kernel.org>
References: <1390923125-4369-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cgroup_mount() fails to allocate an id for the root, it didn't
set ret before jumping to unlock_drop ending up returning 0 after a
failure.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 kernel/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2f46ba..364aeb22 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1566,10 +1566,10 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		mutex_lock(&cgroup_mutex);
 		mutex_lock(&cgroup_root_mutex);
 
-		root_cgrp->id = idr_alloc(&root->cgroup_idr, root_cgrp,
-					   0, 1, GFP_KERNEL);
-		if (root_cgrp->id < 0)
+		ret = idr_alloc(&root->cgroup_idr, root_cgrp, 0, 1, GFP_KERNEL);
+		if (ret < 0)
 			goto unlock_drop;
+		root_cgrp->id = ret;
 
 		/* Check for name clashes with existing mounts */
 		ret = -EBUSY;
-- 
1.8.5.3

