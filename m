Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966469Ab3HHUSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:18:23 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:52141 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966197Ab3HHUOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:14:10 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 04/14] cgroup: cgroup_css_from_dir() now should be called with RCU read locked
Date: Thu,  8 Aug 2013 16:13:41 -0400
Message-Id: <1375992831-4650-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup->subsys[] will become RCU protected and thus all cgroup_css()
usages should either be under RCU read lock or cgroup_mutex.  This
patch updates cgroup_css_from_dir() which returns the matching
cgroup_subsys_state given a directory file and subsys_id so that it
requires RCU read lock and updates its sole user
perf_cgroup_connect().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/cgroup.c      | 12 ++++++++++--
 kernel/events/core.c |  3 +++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5c6dd7e..cbb6314 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5616,8 +5616,14 @@ struct cgroup_subsys_state *css_lookup(struct cgroup_subsys *ss, int id)
 }
 EXPORT_SYMBOL_GPL(css_lookup);
 
-/*
- * get corresponding css from file open on cgroupfs directory
+/**
+ * cgroup_css_from_dir - get corresponding css from file open on cgroup dir
+ * @f: directory file of interest
+ * @id: subsystem id of interest
+ *
+ * Must be called under RCU read lock.  The caller is responsible for
+ * pinning the returned css if it needs to be accessed outside the RCU
+ * critical section.
  */
 struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
 {
@@ -5625,6 +5631,8 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
 	struct inode *inode;
 	struct cgroup_subsys_state *css;
 
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
 	inode = file_inode(f);
 	/* check in cgroup filesystem dir */
 	if (inode->i_op != &cgroup_dir_inode_operations)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c199c4f..23261f9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -591,6 +591,8 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 	if (!f.file)
 		return -EBADF;
 
+	rcu_read_lock();
+
 	css = cgroup_css_from_dir(f.file, perf_subsys_id);
 	if (IS_ERR(css)) {
 		ret = PTR_ERR(css);
@@ -617,6 +619,7 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 		ret = -EINVAL;
 	}
 out:
+	rcu_read_unlock();
 	fdput(f);
 	return ret;
 }
-- 
1.8.3.1

