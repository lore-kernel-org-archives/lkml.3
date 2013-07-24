Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3GXKCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:02:42 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:24980 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3GXKCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:02:39 -0400
Message-ID: <51EFA5C7.40504@huawei.com>
Date: Wed, 24 Jul 2013 18:00:39 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v2 3/8] cgroup: implement cgroup_from_id()
References: <51EFA554.6080801@huawei.com>
In-Reply-To: <51EFA554.6080801@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used as a replacement for css_lookup().

There's a difference with cgroup id and css id. cgroup id starts with 0,
while css id starts with 1.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |  2 ++
 kernel/cgroup.c        | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8c107e9..e8eb361 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -553,6 +553,8 @@ int task_cgroup_path_from_hierarchy(struct task_struct *task, int hierarchy_id,
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
+struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id);
+
 /*
  * Control Group taskset, used to pass around set of tasks to cgroup_subsys
  * methods.
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ee3c02e..9b27775 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5536,6 +5536,22 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
 	return css ? css : ERR_PTR(-ENOENT);
 }
 
+/**
+ * cgroup_from_id - lookup cgroup by id
+ * @ss: cgroup subsys to be looked into
+ * @id: the cgroup id
+ *
+ * Returns the cgroup is there's valid one with @id, otherwise returns Null.
+ * Should be called under rcu_readlock().
+ */
+struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
+{
+	rcu_lockdep_assert(rcu_read_lock_held(),
+			   "cgroup_from_id() needs rcu_read_lock()"
+			   " protection");
+	return idr_find(&ss->root->cgroup_idr, id);
+}
+
 #ifdef CONFIG_CGROUP_DEBUG
 static struct cgroup_subsys_state *debug_css_alloc(struct cgroup *cgrp)
 {
-- 
1.8.0.2
