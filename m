Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaBNJgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:36:40 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:29524 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaBNJgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:36:36 -0500
Message-ID: <52FDE393.6050607@huawei.com>
Date: Fri, 14 Feb 2014 17:36:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cgroup: fix top cgroup refcnt leak
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we mount the same cgroupfs in serveral mount points, and then
umount all of them, kill_sb() will be called only once.

Therefore it's wrong to increment top_cgroup's refcnt when we find
an existing cgroup_root.

Try:
	# mount -t cgroup -o cpuacct xxx /cgroup
	# mount -t cgroup -o cpuacct xxx /cgroup2
	# cat /proc/cgroups | grep cpuacct
	cpuacct 2       1       1
	# umount /cgroup
	# umount /cgroup2
	# cat /proc/cgroups | grep cpuacct
	cpuacct 2       1       1

You'll see cgroupfs will never be freed.

Also move this chunk of code upwards.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 37d94a2..5bfe738 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1498,6 +1498,22 @@ retry:
 		bool name_match = false;
 
 		/*
+		 * A root's lifetime is governed by its top cgroup.  Zero
+		 * ref indicate that the root is being destroyed.  Wait for
+		 * destruction to complete so that the subsystems are free.
+		 * We can use wait_queue for the wait but this path is
+		 * super cold.  Let's just sleep for a bit and retry.
+		 */
+		if (!atomic_read(&root->top_cgroup.refcnt)) {
+			mutex_unlock(&cgroup_mutex);
+			mutex_unlock(&cgroup_tree_mutex);
+			kfree(opts.release_agent);
+			kfree(opts.name);
+			msleep(10);
+			goto retry;
+		}
+
+		/*
 		 * If we asked for a name then it must match.  Also, if
 		 * name matches but sybsys_mask doesn't, we should fail.
 		 * Remember whether name matched.
@@ -1530,22 +1546,6 @@ retry:
 			}
 		}
 
-		/*
-		 * A root's lifetime is governed by its top cgroup.  Zero
-		 * ref indicate that the root is being destroyed.  Wait for
-		 * destruction to complete so that the subsystems are free.
-		 * We can use wait_queue for the wait but this path is
-		 * super cold.  Let's just sleep for a bit and retry.
-		 */
-		if (!atomic_inc_not_zero(&root->top_cgroup.refcnt)) {
-			mutex_unlock(&cgroup_mutex);
-			mutex_unlock(&cgroup_tree_mutex);
-			kfree(opts.release_agent);
-			kfree(opts.name);
-			msleep(10);
-			goto retry;
-		}
-
 		ret = 0;
 		goto out_unlock;
 	}
-- 
1.8.0.2
