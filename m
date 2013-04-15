Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3DOUkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:40:22 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56643 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3DOUkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:40:20 -0400
Date: Mon, 15 Apr 2013 13:40:16 -0700
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, glommer@parallels.com, vgoyal@redhat.com
Subject: [PATCH v2 4/4] memcg: force use_hierarchy if sane_behavior
Message-ID: <20130415204016.GA19531@mtj.dyndns.org>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
 <1365808259-31073-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365808259-31073-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

v2: Explain that mem_cgroup_bind() doesn't have to worry about
    children as suggested by Michal Hocko.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Acked-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Applying to cgroup/for-3.10.

Thanks!

 include/linux/cgroup.h |    3 +++
 mm/memcontrol.c        |   17 +++++++++++++++++
 2 files changed, 20 insertions(+)

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
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5814,6 +5814,7 @@ static struct cftype mem_cgroup_files[]
 	},
 	{
 		.name = "use_hierarchy",
+		.flags = CFTYPE_INSANE,
 		.write_u64 = mem_cgroup_hierarchy_write,
 		.read_u64 = mem_cgroup_hierarchy_read,
 	},
@@ -6784,6 +6785,21 @@ static void mem_cgroup_move_task(struct
 }
 #endif
 
+/*
+ * Cgroup retains root cgroups across [un]mount cycles making it necessary
+ * to verify sane_behavior flag on each mount attempt.
+ */
+static void mem_cgroup_bind(struct cgroup *root)
+{
+	/*
+	 * use_hierarchy is forced with sane_behavior.  cgroup core
+	 * guarantees that @root doesn't have any children, so turning it
+	 * on for the root memcg is enough.
+	 */
+	if (cgroup_sane_behavior(root))
+		mem_cgroup_from_cont(root)->use_hierarchy = true;
+}
+
 struct cgroup_subsys mem_cgroup_subsys = {
 	.name = "memory",
 	.subsys_id = mem_cgroup_subsys_id,
@@ -6794,6 +6810,7 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.attach = mem_cgroup_move_task,
+	.bind = mem_cgroup_bind,
 	.base_cftypes = mem_cgroup_files,
 	.early_init = 0,
 	.use_id = 1,
