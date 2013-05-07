Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab3EGNlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115Ab3EGNln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 067/118] cgroup: fix an off-by-one bug which may trigger BUG_ON()
Date: Tue,  7 May 2013 14:38:33 +0100
Message-Id: <1367933964-1564-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 3ac1707a13a3da9cfc8f242a15b2fae6df2c5f88 upstream.

The 3rd parameter of flex_array_prealloc() is the number of elements,
not the index of the last element.

The effect of the bug is, when opening cgroup.procs, a flex array will
be allocated and all elements of the array is allocated with
GFP_KERNEL flag, but the last one is GFP_ATOMIC, and if we fail to
allocate memory for it, it'll trigger a BUG_ON().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 87fbb45..5168e37 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2079,7 +2079,7 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	if (!group)
 		return -ENOMEM;
 	/* pre-allocate to guarantee space while iterating in rcu read-side. */
-	retval = flex_array_prealloc(group, 0, group_size - 1, GFP_KERNEL);
+	retval = flex_array_prealloc(group, 0, group_size, GFP_KERNEL);
 	if (retval)
 		goto out_free_group_list;
 
-- 
1.8.1.2

