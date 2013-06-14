Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab3FNDSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 23:18:35 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:33463 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3FNDSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 23:18:34 -0400
Message-ID: <51BA8B83.8090607@huawei.com>
Date: Fri, 14 Jun 2013 11:18:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cpuset: rename cont to cgrp
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cont is short for container. control group was named process container
at first, but then people found container already has a meaning in
linux kernel.

Clean up the leftover variable name @cont.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3be9597..171fe5c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -116,9 +116,9 @@ struct cpuset {
 };
 
 /* Retrieve the cpuset for a cgroup */
-static inline struct cpuset *cgroup_cs(struct cgroup *cont)
+static inline struct cpuset *cgroup_cs(struct cgroup *cgrp)
 {
-	return container_of(cgroup_subsys_state(cont, cpuset_subsys_id),
+	return container_of(cgroup_subsys_state(cgrp, cpuset_subsys_id),
 			    struct cpuset, css);
 }
 
@@ -433,7 +433,7 @@ static void free_trial_cpuset(struct cpuset *trial)
 
 static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 {
-	struct cgroup *cont;
+	struct cgroup *cgrp;
 	struct cpuset *c, *par;
 	int ret;
 
@@ -441,7 +441,7 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 
 	/* Each of our child cpusets must be a subset of us */
 	ret = -EBUSY;
-	cpuset_for_each_child(c, cont, cur)
+	cpuset_for_each_child(c, cgrp, cur)
 		if (!is_cpuset_subset(c, trial))
 			goto out;
 
@@ -462,7 +462,7 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 	 * overlap
 	 */
 	ret = -EINVAL;
-	cpuset_for_each_child(c, cont, par) {
+	cpuset_for_each_child(c, cgrp, par) {
 		if ((is_cpu_exclusive(trial) || is_cpu_exclusive(c)) &&
 		    c != cur &&
 		    cpumask_intersects(trial->cpus_allowed, c->cpus_allowed))
@@ -1759,13 +1759,13 @@ static size_t cpuset_sprintf_memlist(char *page, struct cpuset *cs)
 	return count;
 }
 
-static ssize_t cpuset_common_file_read(struct cgroup *cont,
+static ssize_t cpuset_common_file_read(struct cgroup *cgrp,
 				       struct cftype *cft,
 				       struct file *file,
 				       char __user *buf,
 				       size_t nbytes, loff_t *ppos)
 {
-	struct cpuset *cs = cgroup_cs(cont);
+	struct cpuset *cs = cgroup_cs(cgrp);
 	cpuset_filetype_t type = cft->private;
 	char *page;
 	ssize_t retval = 0;
@@ -1795,9 +1795,9 @@ out:
 	return retval;
 }
 
-static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
+static u64 cpuset_read_u64(struct cgroup *cgrp, struct cftype *cft)
 {
-	struct cpuset *cs = cgroup_cs(cont);
+	struct cpuset *cs = cgroup_cs(cgrp);
 	cpuset_filetype_t type = cft->private;
 	switch (type) {
 	case FILE_CPU_EXCLUSIVE:
@@ -1826,9 +1826,9 @@ static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
 	return 0;
 }
 
-static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
+static s64 cpuset_read_s64(struct cgroup *cgrp, struct cftype *cft)
 {
-	struct cpuset *cs = cgroup_cs(cont);
+	struct cpuset *cs = cgroup_cs(cgrp);
 	cpuset_filetype_t type = cft->private;
 	switch (type) {
 	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
@@ -1940,14 +1940,14 @@ static struct cftype files[] = {
 
 /*
  *	cpuset_css_alloc - allocate a cpuset css
- *	cont:	control group that the new cpuset will be part of
+ *	cgrp:	control group that the new cpuset will be part of
  */
 
-static struct cgroup_subsys_state *cpuset_css_alloc(struct cgroup *cont)
+static struct cgroup_subsys_state *cpuset_css_alloc(struct cgroup *cgrp)
 {
 	struct cpuset *cs;
 
-	if (!cont->parent)
+	if (!cgrp->parent)
 		return &top_cpuset.css;
 
 	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
@@ -2042,9 +2042,9 @@ static void cpuset_css_offline(struct cgroup *cgrp)
  * will call rebuild_sched_domains_locked().
  */
 
-static void cpuset_css_free(struct cgroup *cont)
+static void cpuset_css_free(struct cgroup *cgrp)
 {
-	struct cpuset *cs = cgroup_cs(cont);
+	struct cpuset *cs = cgroup_cs(cgrp);
 
 	free_cpumask_var(cs->cpus_allowed);
 	kfree(cs);
-- 
1.8.0.2
