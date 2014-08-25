Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaHYL3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:29:24 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:38442 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753592AbaHYL3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:29:21 -0400
X-IronPort-AV: E=Sophos;i="5.04,396,1406563200"; 
   d="scan'208";a="35035627"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <tj@kernel.org>, <lizefan@huawei.com>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] cgroup: Introduce cgroup_detach_task().
Date: Mon, 25 Aug 2014 19:28:16 +0800
Message-ID: <1408966096-2209-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the only method to detach a task from a cgroup is moving
it to others. It looks not natrual to me.

Inspired by cgroup_subtree_control_write(), this patch introduce allow
user to at-detach a process to/from a cgroup by echo "+/-pid" to
cgroup.procs. In addition, we keep the old method to allow user
echo "pid" without "+/-" to cgroup.procs as a attaching behavior.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/cgroup.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7dc8788..11ef4ac 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2348,6 +2348,43 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	return ret;
 }
 
+/**
+ * cgroup_detach_task - detach a task or a whole threadgroup to a cgroup
+ * @src_cgrp: the cgroup to detach from
+ * @leader: the task or the leader of the threadgroup to be attached
+ * @threadgroup: attach the whole threadgroup?
+ *
+ * Call holding cgroup_mutex and threadgroup_lock of @leader.
+ */
+static int cgroup_detach_task(struct cgroup *src_cgrp __maybe_unused,
+			      struct task_struct *leader, bool threadgroup)
+{
+	LIST_HEAD(preloaded_csets);
+	struct task_struct *task;
+	int ret;
+
+	/* look up all src csets */
+	down_read(&css_set_rwsem);
+	rcu_read_lock();
+	task = leader;
+	do {
+		cgroup_migrate_add_src(task_css_set(task), &cgrp_dfl_root.cgrp,
+				       &preloaded_csets);
+		if (!threadgroup)
+			break;
+	} while_each_thread(leader, task);
+	rcu_read_unlock();
+	up_read(&css_set_rwsem);
+
+	/* prepare dst csets and commit */
+	ret = cgroup_migrate_prepare_dst(&cgrp_dfl_root.cgrp, &preloaded_csets);
+	if (!ret)
+		ret = cgroup_migrate(&cgrp_dfl_root.cgrp, leader, threadgroup);
+
+	cgroup_migrate_finish(&preloaded_csets);
+	return ret;
+}
+
 /*
  * Find the task_struct of the task to attach by vpid and pass it along to the
  * function to attach either it or all tasks in its threadgroup. Will lock
@@ -2361,8 +2398,26 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	struct cgroup *cgrp;
 	pid_t pid;
 	int ret;
+	bool attach;
 
-	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
+	/*
+	 * Parse input - space separated list of subsystem names prefixed
+	 * with either + or -.
+	 */
+	buf = strstrip(buf);
+	if (*buf == '+') {
+		attach = true;
+		buf++;
+	} else if (*buf == '-') {
+		attach = false;
+		buf++;
+	} else {
+		if (!isdigit(*buf))
+			return -EINVAL;
+		attach = true;
+	}
+
+	if (kstrtoint(buf, 0, &pid) || pid < 0)
 		return -EINVAL;
 
 	cgrp = cgroup_kn_lock_live(of->kn);
@@ -2426,7 +2481,10 @@ retry_find_task:
 		}
 	}
 
-	ret = cgroup_attach_task(cgrp, tsk, threadgroup);
+	if (attach)
+		ret = cgroup_attach_task(cgrp, tsk, threadgroup);
+	else
+		ret = cgroup_detach_task(cgrp, tsk, threadgroup);
 
 	threadgroup_unlock(tsk);
 
-- 
1.8.4.2

