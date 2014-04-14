Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaDNVho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:37:44 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:49182 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaDNVhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:37:31 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/12] cgroup: prepare migration path for unified hierarchy
Date: Mon, 14 Apr 2014 17:37:09 -0400
Message-Id: <1397511430-2673-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397511430-2673-1-git-send-email-tj@kernel.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unified hierarchy implementation would require re-migrating tasks onto
the same cgroup on the default hierarchy to reflect updated effective
csses.  Update cgroup_migrate_prepare_dst() so that it accepts NULL as
the destination cgrp.  When NULL is specified, the destination is
considered to be the cgroup on the default hierarchy associated with
each css_set.

After this change, the identity check in cgroup_migrate_add_src()
isn't sufficient for noop detection as the associated csses may change
without any cgroup association changing.  The only way to tell whether
a migration is noop or not is testing whether the source and
destination csets are identical.  The noop check in
cgroup_migrate_add_src() is removed and cset identity test is added to
cgroup_migreate_prepare_dst().  If it's detected that source and
destination csets are identical, the cset is removed removed from
@preloaded_csets and all the migration nodes are cleared which makes
cgroup_migrate() ignore the cset.

Also, make the function append the destination css_sets to
@preloaded_list so that destination css_sets always come after source
css_sets.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 888e037..c7b8509 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1902,10 +1902,6 @@ static void cgroup_migrate_add_src(struct css_set *src_cset,
 
 	src_cgrp = cset_cgroup_from_root(src_cset, dst_cgrp->root);
 
-	/* nothing to do if this cset already belongs to the cgroup */
-	if (src_cgrp == dst_cgrp)
-		return;
-
 	if (!list_empty(&src_cset->mg_preload_node))
 		return;
 
@@ -1920,13 +1916,14 @@ static void cgroup_migrate_add_src(struct css_set *src_cset,
 
 /**
  * cgroup_migrate_prepare_dst - prepare destination css_sets for migration
- * @dst_cgrp: the destination cgroup
+ * @dst_cgrp: the destination cgroup (may be %NULL)
  * @preloaded_csets: list of preloaded source css_sets
  *
  * Tasks are about to be moved to @dst_cgrp and all the source css_sets
  * have been preloaded to @preloaded_csets.  This function looks up and
- * pins all destination css_sets, links each to its source, and put them on
- * @preloaded_csets.
+ * pins all destination css_sets, links each to its source, and append them
+ * to @preloaded_csets.  If @dst_cgrp is %NULL, the destination of each
+ * source css_set is assumed to be its cgroup on the default hierarchy.
  *
  * This function must be called after cgroup_migrate_add_src() has been
  * called on each migration source css_set.  After migration is performed
@@ -1937,19 +1934,34 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 				      struct list_head *preloaded_csets)
 {
 	LIST_HEAD(csets);
-	struct css_set *src_cset;
+	struct css_set *src_cset, *tmp_cset;
 
 	lockdep_assert_held(&cgroup_mutex);
 
 	/* look up the dst cset for each src cset and link it to src */
-	list_for_each_entry(src_cset, preloaded_csets, mg_preload_node) {
+	list_for_each_entry_safe(src_cset, tmp_cset, preloaded_csets, mg_preload_node) {
 		struct css_set *dst_cset;
 
-		dst_cset = find_css_set(src_cset, dst_cgrp);
+		dst_cset = find_css_set(src_cset,
+					dst_cgrp ?: src_cset->dfl_cgrp);
 		if (!dst_cset)
 			goto err;
 
 		WARN_ON_ONCE(src_cset->mg_dst_cset || dst_cset->mg_dst_cset);
+
+		/*
+		 * If src cset equals dst, it's noop.  Drop the src.
+		 * cgroup_migrate() will skip the cset too.  Note that we
+		 * can't handle src == dst as some nodes are used by both.
+		 */
+		if (src_cset == dst_cset) {
+			src_cset->mg_src_cgrp = NULL;
+			list_del_init(&src_cset->mg_preload_node);
+			put_css_set(src_cset, false);
+			put_css_set(dst_cset, false);
+			continue;
+		}
+
 		src_cset->mg_dst_cset = dst_cset;
 
 		if (list_empty(&dst_cset->mg_preload_node))
@@ -1958,7 +1970,7 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 			put_css_set(dst_cset, false);
 	}
 
-	list_splice(&csets, preloaded_csets);
+	list_splice_tail(&csets, preloaded_csets);
 	return 0;
 err:
 	cgroup_migrate_finish(&csets);
-- 
1.9.0

