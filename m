Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3ANJYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:24:17 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:43234 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3ANJYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:24:15 -0500
Message-ID: <50F3CE8E.5000402@huawei.com>
Date: Mon, 14 Jan 2013 17:23:26 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Colin Cross <ccross@google.com>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/2] cgroup: remove synchronize_rcu() from cgroup_attach_{task|proc}()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These 2 syncronize_rcu()s make attaching a task to a cgroup
quite slow, and it can't be ignored in some situations.

A real case from Colin Cross: Android uses cgroups heavily to
manage thread priorities, putting threads in a background group
with reduced cpu.shares when they are not visible to the user,
and in a foreground group when they are. Some RPCs from foreground
threads to background threads will temporarily move the background
thread into the foreground group for the duration of the RPC.
This results in many calls to cgroup_attach_task.

In cgroup_attach_task() it's task->cgroups that is protected by RCU,
and put_css_set() calls kfree_rcu() to free it.

If we remove this synchronize_rcu(), there can be threads in RCU-read
sections accessing their old cgroup via current->cgroups with
concurrent rmdir operation, but this is safe.

 # time for ((i=0; i<50; i++)) { echo $$ > /mnt/sub/tasks; echo $$ > /mnt/tasks; }

real    0m2.524s
user    0m0.008s
sys     0m0.004s

With this patch:

real    0m0.004s
user    0m0.004s
sys     0m0.000s

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5262d9..67b0fa0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1974,7 +1974,6 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 			ss->attach(cgrp, &tset);
 	}
 
-	synchronize_rcu();
 out:
 	if (retval) {
 		for_each_subsys(root, ss) {
@@ -2143,7 +2142,6 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	/*
 	 * step 5: success! and cleanup
 	 */
-	synchronize_rcu();
 	retval = 0;
 out_put_css_set_refs:
 	if (retval) {
-- 
1.8.0.2
