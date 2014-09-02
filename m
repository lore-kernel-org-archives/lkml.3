Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaIBK5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:57:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50772 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaIBK5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:57:11 -0400
Message-ID: <5405A27A.3090605@huawei.com>
Date: Tue, 2 Sep 2014 18:56:58 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/2] cgroup: Delay the clearing of cgrp->kn->priv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run these two scripts concurrently:

    for ((; ;))
    {
        mkdir /cgroup/sub
        rmdir /cgroup/sub
    }

    for ((; ;))
    {
        echo $$ > /cgroup/sub/cgroup.procs
        ech $$ > /cgce 6f2e0c38c2108a74 ]---
    }

A kernel bug will be triggered:

BUG: unable to handle kernel NULL pointer dereference at 00000038
IP: [<c10bbd69>] cgroup_put+0x9/0x80
...
Call Trace:
 [<c10bbe19>] cgroup_kn_unlock+0x39/0x50
 [<c10bbe91>] cgroup_kn_lock_live+0x61/0x70
 [<c10be3c1>] __cgroup_procs_write.isra.26+0x51/0x230
 [<c10be5b2>] cgroup_tasks_write+0x12/0x20
 [<c10bb7b0>] cgroup_file_write+0x40/0x130
 [<c11aee71>] kernfs_fop_write+0xd1/0x160
 [<c1148e58>] vfs_write+0x98/0x1e0
 [<c114934d>] SyS_write+0x4d/0xa0
 [<c16f656b>] sysenter_do_call+0x12/0x12

We clear cgrp->kn->priv in the end of cgroup_rmdir(), but another
concurrent thread can access kn->priv after the clearing.

We should move the clearing to css_release_work_fn(). At that time
no one is holding reference to the cgroup and no one can gain a new
reference to access it.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---

Toralf, Thanks for reporting the bug. I'm not able to repy to your email,
because I was kicked out of the cgroup mailing list so didn't receive
emails from mailing list for a week.

---
 kernel/cgroup.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1c56924..e03fc62 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4185,6 +4185,15 @@ static void css_release_work_fn(struct work_struct *work)
 
 	mutex_unlock(&cgroup_mutex);
 
+	/*
+	 * There are two control paths which try to determine cgroup from
+	 * dentry without going through kernfs - cgroupstats_build() and
+	 * css_tryget_online_from_dir().  Those are supported by RCU
+	 * protecting clearing of cgrp->kn->priv backpointer.
+	 */
+	if (!ss && cgroup_parent(cgrp))
+		RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
+
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
 
@@ -4601,16 +4610,6 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 
 	cgroup_kn_unlock(kn);
 
-	/*
-	 * There are two control paths which try to determine cgroup from
-	 * dentry without going through kernfs - cgroupstats_build() and
-	 * css_tryget_online_from_dir().  Those are supported by RCU
-	 * protecting clearing of cgrp->kn->priv backpointer, which should
-	 * happen after all files under it have been removed.
-	 */
-	if (!ret)
-		RCU_INIT_POINTER(*(void __rcu __force **)&kn->priv, NULL);
-
 	cgroup_put(cgrp);
 	return ret;
 }
-- 
1.8.0.2

