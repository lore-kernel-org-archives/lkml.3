Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbaA1XzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:55:09 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:55150 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbaA1XzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:55:05 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/13] cgroup: introduce cgroup_init/exit_cftypes()
Date: Tue, 28 Jan 2014 18:54:41 -0500
Message-Id: <1390953285-16360-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390953285-16360-1-git-send-email-tj@kernel.org>
References: <1390953285-16360-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out cft->ss initialization into cgroup_init_cftypes() from
cgroup_add_cftypes() and add cft->ss clearing to cgroup_rm_cftypes()
through cgroup_exit_cftypes().

This doesn't make any meaningful difference now but the two new
functions will be expanded during kernfs transition.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a800e56..5c35f00 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2761,6 +2761,22 @@ static int cgroup_cfts_commit(struct cftype *cfts, bool is_add)
 	return ret;
 }
 
+static void cgroup_exit_cftypes(struct cftype *cfts)
+{
+	struct cftype *cft;
+
+	for (cft = cfts; cft->name[0] != '\0'; cft++)
+		cft->ss = NULL;
+}
+
+static void cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
+{
+	struct cftype *cft;
+
+	for (cft = cfts; cft->name[0] != '\0'; cft++)
+		cft->ss = ss;
+}
+
 /**
  * cgroup_add_cftypes - add an array of cftypes to a subsystem
  * @ss: target cgroup subsystem
@@ -2778,15 +2794,13 @@ static int cgroup_cfts_commit(struct cftype *cfts, bool is_add)
 int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	struct cftype_set *set;
-	struct cftype *cft;
 	int ret;
 
 	set = kzalloc(sizeof(*set), GFP_KERNEL);
 	if (!set)
 		return -ENOMEM;
 
-	for (cft = cfts; cft->name[0] != '\0'; cft++)
-		cft->ss = ss;
+	cgroup_init_cftypes(ss, cfts);
 
 	cgroup_cfts_prepare();
 	set->cfts = cfts;
@@ -2811,6 +2825,7 @@ EXPORT_SYMBOL_GPL(cgroup_add_cftypes);
  */
 int cgroup_rm_cftypes(struct cftype *cfts)
 {
+	struct cftype *found = NULL;
 	struct cftype_set *set;
 
 	if (!cfts || !cfts[0].ss)
@@ -2822,13 +2837,14 @@ int cgroup_rm_cftypes(struct cftype *cfts)
 		if (set->cfts == cfts) {
 			list_del(&set->node);
 			kfree(set);
-			cgroup_cfts_commit(cfts, false);
-			return 0;
+			found = cfts;
+			break;
 		}
 	}
 
-	cgroup_cfts_commit(NULL, false);
-	return -ENOENT;
+	cgroup_cfts_commit(found, false);
+	cgroup_exit_cftypes(cfts);
+	return found ? 0 : -ENOENT;
 }
 
 /**
@@ -4587,6 +4603,8 @@ int __init cgroup_init(void)
 	if (err)
 		return err;
 
+	cgroup_init_cftypes(NULL, cgroup_base_files);
+
 	for_each_subsys(ss, i) {
 		if (!ss->early_init)
 			cgroup_init_subsys(ss);
-- 
1.8.5.3

