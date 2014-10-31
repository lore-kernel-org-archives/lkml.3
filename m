Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbaJaTUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:20:44 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:61074 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbaJaTTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:19:23 -0400
From: Aditya Kali <adityakali@google.com>
To: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, ebiederm@xmission.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com
Cc: containers@lists.linux-foundation.org, jnagal@google.com,
        Aditya Kali <adityakali@google.com>
Subject: [PATCHv2 3/7] cgroup: add function to get task's cgroup on default hierarchy
Date: Fri, 31 Oct 2014 12:18:57 -0700
Message-Id: <1414783141-6947-4-git-send-email-adityakali@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1414783141-6947-1-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
 <1414783141-6947-1-git-send-email-adityakali@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_task_cgroup() returns the (reference counted) cgroup of the
given task on the default hierarchy.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1d51968..80ed6e0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -579,6 +579,7 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 }
 
 char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
+struct cgroup *get_task_cgroup(struct task_struct *task);
 
 int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 136ecea..50fa8e3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1917,6 +1917,31 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 }
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
+/*
+ * get_task_cgroup - returns the cgroup of the task in the default cgroup
+ * hierarchy.
+ *
+ * @task: target task
+ * This function returns the @task's cgroup on the default cgroup hierarchy. The
+ * returned cgroup has its reference incremented (by calling cgroup_get()). So
+ * the caller must cgroup_put() the obtained reference once it is done with it.
+ */
+struct cgroup *get_task_cgroup(struct task_struct *task)
+{
+	struct cgroup *cgrp;
+
+	mutex_lock(&cgroup_mutex);
+	down_read(&css_set_rwsem);
+
+	cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
+	cgroup_get(cgrp);
+
+	up_read(&css_set_rwsem);
+	mutex_unlock(&cgroup_mutex);
+	return cgrp;
+}
+EXPORT_SYMBOL_GPL(get_task_cgroup);
+
 /* used to track tasks and other necessary states during migration */
 struct cgroup_taskset {
 	/* the src and dst cset list running through cset->mg_node */
-- 
2.1.0.rc2.206.gedb03e5

