Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab3HAV4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:56:52 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:52100 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab3HAVuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:50:24 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/23] cgroup: add cgroup->dummy_css
Date: Thu,  1 Aug 2013 17:49:49 -0400
Message-Id: <1375393801-4817-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375393801-4817-1-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup subsystem API is being converted to use css
(cgroup_subsys_state) as the main handle, which makes things a bit
awkward for subsystem agnostic core features - the "cgroup.*"
interface files and various iterations - a bit awkward as they don't
have a css to use.

This patch adds cgroup->dummy_css which has NULL ->ss and whose only
role is pointing back to the cgroup.  This will be used to support
subsystem agnostic features on the coming css based API.

css_parent() is updated to handle dummy_css's.  Note that css will
soon grow its own ->parent field and css_parent() will be made
trivial.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 11 ++++++++++-
 kernel/cgroup.c        |  9 +++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2e0e9e2..085ca93 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -225,6 +225,9 @@ struct cgroup {
 	struct list_head pidlists;
 	struct mutex pidlist_mutex;
 
+	/* dummy css with NULL ->ss, points back to this cgroup */
+	struct cgroup_subsys_state dummy_css;
+
 	/* For css percpu_ref killing and RCU-protected deletion */
 	struct rcu_head rcu_head;
 	struct work_struct destroy_work;
@@ -669,7 +672,13 @@ struct cgroup_subsys_state *css_parent(struct cgroup_subsys_state *css)
 {
 	struct cgroup *parent_cgrp = css->cgroup->parent;
 
-	return parent_cgrp ? parent_cgrp->subsys[css->ss->subsys_id] : NULL;
+	if (!parent_cgrp)
+		return NULL;
+
+	if (css->ss)
+		return parent_cgrp->subsys[css->ss->subsys_id];
+	else
+		return &parent_cgrp->dummy_css;
 }
 
 /**
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b413e22..bb87c9f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1365,6 +1365,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
+	cgrp->dummy_css.cgroup = cgrp;
 	INIT_LIST_HEAD(&cgrp->event_list);
 	spin_lock_init(&cgrp->event_list_lock);
 	simple_xattrs_init(&cgrp->xattrs);
@@ -2278,7 +2279,7 @@ static struct cgroup_subsys_state *cgroup_file_css(struct cfent *cfe)
 
 	if (cft->ss)
 		return cgrp->subsys[cft->ss->subsys_id];
-	return NULL;
+	return &cgrp->dummy_css;
 }
 
 /* A buffer size big enough for numbers or short strings */
@@ -2460,7 +2461,7 @@ static int cgroup_file_open(struct inode *inode, struct file *file)
 	 * unpinned either on open failure or release.  This ensures that
 	 * @css stays alive for all file operations.
 	 */
-	if (css && !css_tryget(css))
+	if (css->ss && !css_tryget(css))
 		return -ENODEV;
 
 	if (cft->read_map || cft->read_seq_string) {
@@ -2470,7 +2471,7 @@ static int cgroup_file_open(struct inode *inode, struct file *file)
 		err = cft->open(inode, file);
 	}
 
-	if (css && err)
+	if (css->ss && err)
 		css_put(css);
 	return err;
 }
@@ -2484,7 +2485,7 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
 
 	if (cft->release)
 		ret = cft->release(inode, file);
-	if (css)
+	if (css->ss)
 		css_put(css);
 	return ret;
 }
-- 
1.8.3.1

