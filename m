Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3DODuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:50:22 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:39733 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab3DODuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:50:21 -0400
Date: Sun, 14 Apr 2013 20:50:08 -0700
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, kay@vrfy.org, greg@kroah.com,
        lennart@poettering.net, daniel@zonque.org
Subject: [PATCH UPDATED 4/4] cgroup: implement
 task_cgroup_path_from_hierarchy()
Message-ID: <20130415035008.GM3050@htj.dyndns.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
 <1365964619-14762-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365964619-14762-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kdbus folks want a sane way to determine the cgroup path that a given
task belongs to on a given hierarchy, which is a reasonble thing to
expect from cgroup core.

Implement task_cgroup_path_from_hierarchy().

v2: Dropped unnecessary NULL check on the return value of
    task_cgroup_from_root() as suggested by Li Zefan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Greg Kroah-Hartman <greg@kroah.com>
Acked-by: Li Zefan <lizefan@huawei.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Daniel Mack <daniel@zonque.org>
---
 include/linux/cgroup.h |    2 ++
 kernel/cgroup.c        |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -443,6 +443,8 @@ int cgroup_is_removed(const struct cgrou
 bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor);
 
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
+int task_cgroup_path_from_hierarchy(struct task_struct *task, int hierarchy_id,
+				    char *buf, size_t buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1842,6 +1842,38 @@ out:
 }
 EXPORT_SYMBOL_GPL(cgroup_path);
 
+/**
+ * task_cgroup_path_from_hierarchy - cgroup path of a task on a hierarchy
+ * @task: target task
+ * @hierarchy_id: the hierarchy to look up @task's cgroup from
+ * @buf: the buffer to write the path into
+ * @buflen: the length of the buffer
+ *
+ * Determine @task's cgroup on the hierarchy specified by @hierarchy_id and
+ * copy its path into @buf.  This function grabs cgroup_mutex and shouldn't
+ * be used inside locks used by cgroup controller callbacks.
+ */
+int task_cgroup_path_from_hierarchy(struct task_struct *task, int hierarchy_id,
+				    char *buf, size_t buflen)
+{
+	struct cgroupfs_root *root;
+	struct cgroup *cgrp = NULL;
+	int ret = -ENOENT;
+
+	mutex_lock(&cgroup_mutex);
+
+	root = idr_find(&cgroup_hierarchy_idr, hierarchy_id);
+	if (root) {
+		cgrp = task_cgroup_from_root(task, root);
+		ret = cgroup_path(cgrp, buf, buflen);
+	}
+
+	mutex_unlock(&cgroup_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(task_cgroup_path_from_hierarchy);
+
 /*
  * Control Group taskset
  */
