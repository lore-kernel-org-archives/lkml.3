Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaBINw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:52:58 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:65413 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaBINw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:52:56 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/16] cgroup: disallow xattr, release_agent and name if sane_behavior
Date: Sun,  9 Feb 2014 08:52:29 -0500
Message-Id: <1391953964-22088-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disallow more mount options if sane_behavior.  Note that xattr used to
generate warning.

While at it, simplify option check in cgroup_mount() and update
sane_behavior comment in cgroup.h.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  6 +++---
 kernel/cgroup.c        | 14 ++++----------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5f2c629..fa415a8 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -225,8 +225,8 @@ enum {
 	 *
 	 * The followings are the behaviors currently affected this flag.
 	 *
-	 * - Mount options "noprefix" and "clone_children" are disallowed.
-	 *   Also, cgroupfs file cgroup.clone_children is not created.
+	 * - Mount options "noprefix", "xattr", "clone_children",
+	 *   "release_agent" and "name" are disallowed.
 	 *
 	 * - When mounting an existing superblock, mount options should
 	 *   match.
@@ -244,7 +244,7 @@ enum {
 	 * - "release_agent" and "notify_on_release" are removed.
 	 *   Replacement notification mechanism will be implemented.
 	 *
-	 * - "xattr" mount option is deprecated.  kernfs always enables it.
+	 * - "cgroup.clone_children" is removed.
 	 *
 	 * - cpuset: tasks will be kept in empty cpusets when hotplug happens
 	 *   and take masks of ancestors with non-empty cpus/mems, instead of
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4c53e90..47160ce 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1224,18 +1224,12 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	if (opts->flags & CGRP_ROOT_SANE_BEHAVIOR) {
 		pr_warning("cgroup: sane_behavior: this is still under development and its behaviors will change, proceed at your own risk\n");
 
-		if (opts->flags & CGRP_ROOT_NOPREFIX) {
-			pr_err("cgroup: sane_behavior: noprefix is not allowed\n");
+		if ((opts->flags & (CGRP_ROOT_NOPREFIX | CGRP_ROOT_XATTR)) ||
+		    opts->cpuset_clone_children || opts->release_agent ||
+		    opts->name) {
+			pr_err("cgroup: sane_behavior: noprefix, xattr, clone_children, release_agent and name are not allowed\n");
 			return -EINVAL;
 		}
-
-		if (opts->cpuset_clone_children) {
-			pr_err("cgroup: sane_behavior: clone_children is not allowed\n");
-			return -EINVAL;
-		}
-
-		if (opts->flags & CGRP_ROOT_XATTR)
-			pr_warning("cgroup: sane_behavior: xattr is always available, flag unnecessary\n");
 	}
 
 	/*
-- 
1.8.5.3

