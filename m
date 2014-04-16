Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161565AbaDPOux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:50:53 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:50457 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161244AbaDPOuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:50:51 -0400
Date: Wed, 16 Apr 2014 10:50:47 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
        eparis@parisplace.org, gregkh@linuxfoundation.org,
        serge.hallyn@ubuntu.com, lennart@poettering.net, kay@vrfy.org
Subject: [PATCH v3 3/3] cgroup: implement cgroup.populated for the default
 hierarchy
Message-ID: <20140416145047.GC1257@htj.dyndns.org>
References: <1397511846-2904-1-git-send-email-tj@kernel.org>
 <1397511846-2904-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397511846-2904-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Renamed to cgroup.populated.  git branch updated accordingly.

Thanks.
------- 8< -------
>From bf3fd307267ce307c4c8ec41834d7bddb6441907 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 16 Apr 2014 10:48:38 -0400

cgroup users often need a way to determine when a cgroup's
subhierarchy becomes empty so that it can be cleaned up.  cgroup
currently provides release_agent for it; unfortunately, this mechanism
is riddled with issues.

* It delivers events by forking and execing a userland binary
  specified as the release_agent.  This is a long deprecated method of
  notification delivery.  It's extremely heavy, slow and cumbersome to
  integrate with larger infrastructure.

* There is single monitoring point at the root.  There's no way to
  delegate management of a subtree.

* The event isn't recursive.  It triggers when a cgroup doesn't have
  any tasks or child cgroups.  Events for internal nodes trigger only
  after all children are removed.  This again makes it impossible to
  delegate management of a subtree.

* Events are filtered from the kernel side.  "notify_on_release" file
  is used to subscribe to or suppress release event.  This is
  unnecessarily complicated and probably done this way because event
  delivery itself was expensive.

This patch implements interface file "cgroup.populated" which can be
used to monitor whether the cgroup's subhierarchy has tasks in it or
not.  Its value is 0 if there is no task in the cgroup and its
descendants; otherwise, 1, and kernfs_notify() notificaiton is
triggers when the value changes, which can be monitored through poll
and [di]notify.

This is a lot ligther and simpler and trivially allows delegating
management of subhierarchy - subhierarchy monitoring can block further
propgation simply by putting itself or another process in the root of
the subhierarchy and monitor events that it's interested in from there
without interfering with monitoring higher in the tree.

v2: Patch description updated as per Serge.

v3: "cgroup.subtree_populated" renamed to "cgroup.populated".  The
    subtree_ prefix was a bit confusing because
    "cgroup.subtree_control" uses it to denote the tree rooted at the
    cgroup sans the cgroup itself while the populated state includes
    the cgroup itself.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Lennart Poettering <lennart@poettering.net>
---
 include/linux/cgroup.h | 15 ++++++++++++
 kernel/cgroup.c        | 65 ++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ada2392..4b38e2d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -154,6 +154,14 @@ struct cgroup {
 	/* the number of attached css's */
 	int nr_css;
 
+	/*
+	 * If this cgroup contains any tasks, it contributes one to
+	 * populated_cnt.  All children with non-zero popuplated_cnt of
+	 * their own contribute one.  The count is zero iff there's no task
+	 * in this cgroup or its subtree.
+	 */
+	int populated_cnt;
+
 	atomic_t refcnt;
 
 	/*
@@ -166,6 +174,7 @@ struct cgroup {
 	struct cgroup *parent;		/* my parent */
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
 	struct kernfs_node *control_kn;	/* kn for "cgroup.subtree_control" */
+	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
 
 	/*
 	 * Monotonically increasing unique serial number which defines a
@@ -264,6 +273,12 @@ enum {
 	 *
 	 * - "cgroup.clone_children" is removed.
 	 *
+	 * - "cgroup.subtree_populated" is available.  Its value is 0 if
+	 *   the cgroup and its descendants contain no task; otherwise, 1.
+	 *   The file also generates kernfs notification which can be
+	 *   monitored through poll and [di]notify when the value of the
+	 *   file changes.
+	 *
 	 * - If mount is requested with sane_behavior but without any
 	 *   subsystem, the default unified hierarchy is mounted.
 	 *
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7986aa6..2412cb7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -411,6 +411,43 @@ static struct css_set init_css_set = {
 
 static int css_set_count	= 1;	/* 1 for init_css_set */
 
+/**
+ * cgroup_update_populated - updated populated count of a cgroup
+ * @cgrp: the target cgroup
+ * @populated: inc or dec populated count
+ *
+ * @cgrp is either getting the first task (css_set) or losing the last.
+ * Update @cgrp->populated_cnt accordingly.  The count is propagated
+ * towards root so that a given cgroup's populated_cnt is zero iff the
+ * cgroup and all its descendants are empty.
+ *
+ * @cgrp's interface file "cgroup.populated" is zero if
+ * @cgrp->populated_cnt is zero and 1 otherwise.  When @cgrp->populated_cnt
+ * changes from or to zero, userland is notified that the content of the
+ * interface file has changed.  This can be used to detect when @cgrp and
+ * its descendants become populated or empty.
+ */
+static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
+{
+	lockdep_assert_held(&css_set_rwsem);
+
+	do {
+		bool trigger;
+
+		if (populated)
+			trigger = !cgrp->populated_cnt++;
+		else
+			trigger = !--cgrp->populated_cnt;
+
+		if (!trigger)
+			break;
+
+		if (cgrp->populated_kn)
+			kernfs_notify(cgrp->populated_kn);
+		cgrp = cgrp->parent;
+	} while (cgrp);
+}
+
 /*
  * hash table for cgroup groups. This improves the performance to find
  * an existing css_set. This hash doesn't (currently) take into
@@ -456,10 +493,13 @@ static void put_css_set_locked(struct css_set *cset, bool taskexit)
 		list_del(&link->cgrp_link);
 
 		/* @cgrp can't go away while we're holding css_set_rwsem */
-		if (list_empty(&cgrp->cset_links) && notify_on_release(cgrp)) {
-			if (taskexit)
-				set_bit(CGRP_RELEASABLE, &cgrp->flags);
-			check_for_release(cgrp);
+		if (list_empty(&cgrp->cset_links)) {
+			cgroup_update_populated(cgrp, false);
+			if (notify_on_release(cgrp)) {
+				if (taskexit)
+					set_bit(CGRP_RELEASABLE, &cgrp->flags);
+				check_for_release(cgrp);
+			}
 		}
 
 		kfree(link);
@@ -668,7 +708,11 @@ static void link_css_set(struct list_head *tmp_links, struct css_set *cset,
 	link = list_first_entry(tmp_links, struct cgrp_cset_link, cset_link);
 	link->cset = cset;
 	link->cgrp = cgrp;
+
+	if (list_empty(&cgrp->cset_links))
+		cgroup_update_populated(cgrp, true);
 	list_move(&link->cset_link, &cgrp->cset_links);
+
 	/*
 	 * Always add links to the tail of the list so that the list
 	 * is sorted by order of hierarchy creation
@@ -2643,6 +2687,12 @@ err_undo_css:
 	goto out_unlock;
 }
 
+static int cgroup_populated_show(struct seq_file *seq, void *v)
+{
+	seq_printf(seq, "%d\n", (bool)seq_css(seq)->cgroup->populated_cnt);
+	return 0;
+}
+
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 				 size_t nbytes, loff_t off)
 {
@@ -2809,6 +2859,8 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 
 	if (cft->seq_show == cgroup_subtree_control_show)
 		cgrp->control_kn = kn;
+	else if (cft->seq_show == cgroup_populated_show)
+		cgrp->populated_kn = kn;
 	return 0;
 }
 
@@ -3918,6 +3970,11 @@ static struct cftype cgroup_base_files[] = {
 		.seq_show = cgroup_subtree_control_show,
 		.write_string = cgroup_subtree_control_write,
 	},
+	{
+		.name = "cgroup.populated",
+		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
+		.seq_show = cgroup_populated_show,
+	},
 
 	/*
 	 * Historical crazy stuff.  These don't have "cgroup."  prefix and
-- 
1.9.0

