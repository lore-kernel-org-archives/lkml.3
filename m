Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab3HAVuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:50:20 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:48795 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab3HAVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:50:16 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/23] cgroup: add subsystem pointer to cgroup_subsys_state
Date: Thu,  1 Aug 2013 17:49:43 -0400
Message-Id: <1375393801-4817-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375393801-4817-1-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, given a cgroup_subsys_state, there's no way to find out
which subsystem the css is for, which we'll need to convert the cgroup
controller API to primarily use @css instead of @cgroup.  This patch
adds cgroup_subsys_state->ss which points to the subsystem the @css
belongs to.

While at it, remove the comment about accessing @css->cgroup to
determine the hierarchy.  cgroup core will provide API to traverse
hierarchy of css'es and we don't want subsystems to directly walk
cgroup hierarchies anymore.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 9 ++++-----
 kernel/cgroup.c        | 1 +
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1938292..9c2f9d7 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -66,13 +66,12 @@ enum cgroup_subsys_id {
 
 /* Per-subsystem/per-cgroup state maintained by the system. */
 struct cgroup_subsys_state {
-	/*
-	 * The cgroup that this subsystem is attached to. Useful
-	 * for subsystems that want to know about the cgroup
-	 * hierarchy structure
-	 */
+	/* the cgroup that this css is attached to */
 	struct cgroup *cgroup;
 
+	/* the cgroup subsystem that this css is attached to */
+	struct cgroup_subsys *ss;
+
 	/* reference count - access via css_[try]get() and css_put() */
 	struct percpu_ref refcnt;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9d5af91..fad5498 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4179,6 +4179,7 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
 			       struct cgroup *cgrp)
 {
 	css->cgroup = cgrp;
+	css->ss = ss;
 	css->flags = 0;
 	css->id = NULL;
 	if (cgrp == cgroup_dummy_top)
-- 
1.8.3.1

