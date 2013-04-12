Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3DLXLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:11:20 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:47500 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3DLXLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:11:15 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, glommer@parallels.com, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] memcg: force use_hierarchy if sane_behavior
Date: Fri, 12 Apr 2013 16:10:59 -0700
Message-Id: <1365808259-31073-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365808259-31073-1-git-send-email-tj@kernel.org>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn on use_hierarchy by default if sane_behavior is specified and
don't create .use_hierarchy file.

It is debatable whether to remove .use_hierarchy file or make it ro as
the former could make transition easier in certain cases; however, the
behavior changes which will be gated by sane_behavior are intensive
including changing basic meaning of certain control knobs in a few
controllers and I don't really think keeping this piece would make
things easier in any noticeable way, so let's remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/cgroup.h |  3 +++
 mm/memcontrol.c        | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9c300ad..c562e33 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -269,6 +269,9 @@ enum {
 	 *
 	 * - Remount is disallowed.
 	 *
+	 * - memcg: use_hierarchy is on by default and the cgroup file for
+	 *   the flag is not created.
+	 *
 	 * The followings are planned changes.
 	 *
 	 * - release_agent will be disallowed once replacement notification
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9715c0c..a651131 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5814,6 +5814,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "use_hierarchy",
+		.flags = CFTYPE_INSANE,
 		.write_u64 = mem_cgroup_hierarchy_write,
 		.read_u64 = mem_cgroup_hierarchy_read,
 	},
@@ -6784,6 +6785,17 @@ static void mem_cgroup_move_task(struct cgroup *cont,
 }
 #endif
 
+/*
+ * Cgroup retains root cgroups across [un]mount cycles making it necessary
+ * to verify sane_behavior flag on each mount attempt.
+ */
+static void mem_cgroup_bind(struct cgroup *root)
+{
+	/* use_hierarchy is forced with sane_behavior */
+	if (cgroup_sane_behavior(root))
+		mem_cgroup_from_cont(root)->use_hierarchy = true;
+}
+
 struct cgroup_subsys mem_cgroup_subsys = {
 	.name = "memory",
 	.subsys_id = mem_cgroup_subsys_id,
@@ -6794,6 +6806,7 @@ struct cgroup_subsys mem_cgroup_subsys = {
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.attach = mem_cgroup_move_task,
+	.bind = mem_cgroup_bind,
 	.base_cftypes = mem_cgroup_files,
 	.early_init = 0,
 	.use_id = 1,
-- 
1.8.1.4

