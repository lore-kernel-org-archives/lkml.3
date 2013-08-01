Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab3HAV6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:58:53 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:37632 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab3HAVuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:50:10 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/23] cpuset: drop "const" qualifiers from struct cpuset instances
Date: Thu,  1 Aug 2013 17:49:40 -0400
Message-Id: <1375393801-4817-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375393801-4817-1-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset uses "const" qualifiers on struct cpuset in some functions;
however, it doesn't work well when a value derived from returned const
pointer has to be passed to an accessor.  It's C after all.

Drop the "const" qualifiers except for the trivially leaf ones.  This
patch doesn't make any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index be4512b..f737134 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -128,7 +128,7 @@ static inline struct cpuset *task_cs(struct task_struct *task)
 			    struct cpuset, css);
 }
 
-static inline struct cpuset *parent_cs(const struct cpuset *cs)
+static inline struct cpuset *parent_cs(struct cpuset *cs)
 {
 	struct cgroup *pcgrp = cs->css.cgroup->parent;
 
@@ -319,8 +319,7 @@ static struct file_system_type cpuset_fs_type = {
  *
  * Call with callback_mutex held.
  */
-static void guarantee_online_cpus(const struct cpuset *cs,
-				  struct cpumask *pmask)
+static void guarantee_online_cpus(struct cpuset *cs, struct cpumask *pmask)
 {
 	while (!cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
 		cs = parent_cs(cs);
@@ -338,7 +337,7 @@ static void guarantee_online_cpus(const struct cpuset *cs,
  *
  * Call with callback_mutex held.
  */
-static void guarantee_online_mems(const struct cpuset *cs, nodemask_t *pmask)
+static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 {
 	while (!nodes_intersects(cs->mems_allowed, node_states[N_MEMORY]))
 		cs = parent_cs(cs);
@@ -383,7 +382,7 @@ static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
  * alloc_trial_cpuset - allocate a trial cpuset
  * @cs: the cpuset that the trial cpuset duplicates
  */
-static struct cpuset *alloc_trial_cpuset(const struct cpuset *cs)
+static struct cpuset *alloc_trial_cpuset(struct cpuset *cs)
 {
 	struct cpuset *trial;
 
@@ -430,7 +429,7 @@ static void free_trial_cpuset(struct cpuset *trial)
  * Return 0 if valid, -errno if not.
  */
 
-static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
+static int validate_change(struct cpuset *cur, struct cpuset *trial)
 {
 	struct cgroup *cgrp;
 	struct cpuset *c, *par;
@@ -2343,7 +2342,7 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 
 void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
-	const struct cpuset *cpus_cs;
+	struct cpuset *cpus_cs;
 
 	rcu_read_lock();
 	cpus_cs = effective_cpumask_cpuset(task_cs(tsk));
@@ -2416,7 +2415,7 @@ int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
  * callback_mutex.  If no ancestor is mem_exclusive or mem_hardwall
  * (an unusual configuration), then returns the root cpuset.
  */
-static const struct cpuset *nearest_hardwall_ancestor(const struct cpuset *cs)
+static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
 {
 	while (!(is_mem_exclusive(cs) || is_mem_hardwall(cs)) && parent_cs(cs))
 		cs = parent_cs(cs);
@@ -2486,7 +2485,7 @@ static const struct cpuset *nearest_hardwall_ancestor(const struct cpuset *cs)
  */
 int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 {
-	const struct cpuset *cs;	/* current cpuset ancestors */
+	struct cpuset *cs;		/* current cpuset ancestors */
 	int allowed;			/* is allocation in zone z allowed? */
 
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
-- 
1.8.3.1

