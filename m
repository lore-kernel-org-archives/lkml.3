Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab3AQIEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:04:49 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:11398 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759229Ab3AQIEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:04:47 -0500
Message-ID: <50F7B079.50201@huawei.com>
Date: Thu, 17 Jan 2013 16:04:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 4/6] cgroup: remove duplicate RCU free on struct cgroup
References: <50F7B040.2020906@huawei.com>
In-Reply-To: <50F7B040.2020906@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When destroying cgroup, though in cgroup_diput() we've called
synchronize_rcu(), we then still have to free cgroup via call_rcu().

The story is, long ago to fix a race between reading /proc/sched_debug
and freeing cgroup, the code was changed to utilize call_rcu().

Now we've splitted part of cpu cgroup css_alloc/free to css_online/offline,
which makes the race vanish, and this grants us to remove call_rcu().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 23a0ce1..d7fefeb 100644
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
