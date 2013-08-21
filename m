Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab3HUJ77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:59:59 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:37734 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3HUJ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:59:56 -0400
Message-ID: <52148F90.7070809@huawei.com>
Date: Wed, 21 Aug 2013 17:59:44 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 05/11] cpuset: inherite ancestor's masks if real_{cpus,mems}_allowed
 become empty
References: <52148F52.0@huawei.com>
In-Reply-To: <52148F52.0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to have separate user-configured masks and effective ones.

At last configured masks can only be changed by writing cpuset.cpus
and cpuset.mems, and they won't be restricted by parent cpuset. While
effective masks reflect cpu/memory hotplug and hierachical restriction.

This is a preparation to make real_{cpus,mems}_allowed to be effective
masks of the cpuset:

- change the effective masks at hotplug: done
- change the effective masks at config change: done
- take on ancestor's mask when the effective mask is empty: done

This won't introduce behavior change.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 72afef4..b7b63dd 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -904,12 +904,14 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
 			    parent->real_cpus_allowed);
 
 		/*
-		 * Skip the whole subtree if the cpumask is not changed, unless
-		 * it's empty, and in this case we need to update tasks to take
-		 * on an ancestor's cpumask.
+		 * If it becomes empty, inherite the effective mask of the
+		 * parent, which is guarantted to have some CPUs.
 		 */
-		if (cpumask_equal(new_cpus, cp->real_cpus_allowed) &&
-		    ((cp == cs) || !cpumask_empty(new_cpus))) {
+		if (cpumask_empty(new_cpus))
+			cpumask_copy(new_cpus, parent->real_cpus_allowed);
+
+		/* Skip the whole subtree if the cpumask is not changed. */
+		if (cpumask_equal(new_cpus, cp->real_cpus_allowed)) {
 			pos_css = css_rightmost_descendant(pos_css);
 			continue;
 		}
@@ -1168,12 +1170,14 @@ static void update_nodemasks_hier(struct cpuset *cs, struct cpuset *trialcs,
 			  parent->real_mems_allowed);
 
 		/*
-		 * Skip the whole subtree if the nodemask is not changed, unless
-		 * it's empty, and in this case we need to update tasks to take
-		 * on an ancestor's nodemask.
+		 * If it becoms empty, inherite the effective mask of the
+		 * parent, which is guaranteed to have some MEMs.
 		 */
-		if (nodes_equal(*new_mems, cp->real_mems_allowed) &&
-		    ((cp == cs) || !nodes_empty(*new_mems))) {
+		if (nodes_empty(*new_mems))
+			*new_mems = parent->real_mems_allowed;
+
+		/* Skip the whole subtree if the nodemask is not changed. */
+		if (nodes_equal(*new_mems, cp->real_mems_allowed)) {
 			pos_css = css_rightmost_descendant(pos_css);
 			continue;
 		}
@@ -2202,8 +2206,13 @@ retry:
 
 	mutex_lock(&callback_mutex);
 	cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, &off_cpus);
+
 	cpumask_andnot(cs->real_cpus_allowed, cs->real_cpus_allowed,
 		       &off_cpus);
+	/* Inherite the effective mask of the parent, if it becomes empty */
+	if (cpumask_empty(cs->real_cpus_allowed))
+		cpumask_copy(cs->real_cpus_allowed,
+			     parent_cs(cs)->real_cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -2218,7 +2227,11 @@ retry:
 
 	mutex_lock(&callback_mutex);
 	nodes_andnot(cs->mems_allowed, cs->mems_allowed, off_mems);
+
 	nodes_andnot(cs->real_mems_allowed, cs->real_mems_allowed, off_mems);
+	/* Inherite the effective mask of the parent, if it becomes empty */
+	if (nodes_empty(cs->real_mems_allowed))
+		cs->real_mems_allowed = parent_cs(cs)->real_mems_allowed;
 	mutex_unlock(&callback_mutex);
 
 	/*
-- 
1.8.0.2
