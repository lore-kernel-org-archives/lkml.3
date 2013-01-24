Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3AXGdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:33:10 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:31798 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3AXGc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:32:58 -0500
Message-ID: <5100D53F.1080206@huawei.com>
Date: Thu, 24 Jan 2013 14:31:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 4/6] cgroup: remove duplicate RCU free on struct cgroup
References: <5100D4FE.9080205@huawei.com>
In-Reply-To: <5100D4FE.9080205@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When destroying a cgroup, though in cgroup_diput() we've called
synchronize_rcu(), we then still have to free it via call_rcu().

The story is, long ago to fix a race between reading /proc/sched_debug
and freeing cgroup, the code was changed to utilize call_rcu(). See
commit a47295e6bc42ad35f9c15ac66f598aa24debd4e2 ("cgroups: make
cgroup_path() RCU-safe")

As we've fixed cpu cgroup that cpu_cgroup_offline_css() is used
to unregister a task_group so there won't be concurrent access
to this task_group after synchronize_rcu() in diput(). Now we can
just kfree(cgrp).

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b9a76e2..a39e2b0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -892,7 +892,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		simple_xattrs_free(&cgrp->xattrs);
 
 		ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
-		kfree_rcu(cgrp, rcu_head);
+		kfree(cgrp);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
 		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
-- 
1.8.0.2
