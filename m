Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab3GaBwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 21:52:51 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:45973 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3GaBwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 21:52:49 -0400
Message-ID: <51F86DA3.6050406@huawei.com>
Date: Wed, 31 Jul 2013 09:51:31 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v4 3/8] cgroup: implement cgroup_from_id()
References: <51F86D69.2030907@huawei.com>
In-Reply-To: <51F86D69.2030907@huawei.com>
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

v4:
- also check if cggroup_mutex is held.
- make it an inline function.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/cgroup.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8c107e9..4ef8452 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -720,6 +720,24 @@ static inline struct cgroup* task_cgroup(struct task_struct *task,
 	return task_subsys_state(task, subsys_id)->cgroup;
 }
 
+/**
+ * cgroup_from_id - lookup cgroup by id
+ * @ss: cgroup subsys to be looked into
+ * @id: the cgroup id
+ *
+ * Returns the cgroup if there's valid one with @id, otherwise returns NULL.
+ * Should be called under rcu_read_lock().
+ */
+static inline struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
+{
+#ifdef CONFIG_PROVE_RCU
+	rcu_lockdep_assert(rcu_read_lock_held() ||
+			   lockdep_is_held(&cgroup_mutex),
+			   "cgroup_from_id() needs proper protection");
+#endif
+	return idr_find(&ss->root->cgroup_idr, id);
+}
+
 struct cgroup *cgroup_next_sibling(struct cgroup *pos);
 
 /**
-- 
1.8.0.2
