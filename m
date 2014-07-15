Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbaGOXa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:30:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934128AbaGOXOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.15 71/84] cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()
Date: Tue, 15 Jul 2014 16:18:08 -0700
Message-Id: <20140715231715.310198631@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 3a32bd72d77058d768dbb38183ad517f720dd1bc upstream.

We've converted cgroup to kernfs so cgroup won't be intertwined with
vfs objects and locking, but there are dark areas.

Run two instances of this script concurrently:

    for ((; ;))
    {
    	mount -t cgroup -o cpuacct xxx /cgroup
    	umount /cgroup
    }

After a while, I saw two mount processes were stuck at retrying, because
they were waiting for a subsystem to become free, but the root associated
with this subsystem never got freed.

This can happen, if thread A is in the process of killing superblock but
hasn't called percpu_ref_kill(), and at this time thread B is mounting
the same cgroup root and finds the root in the root list and performs
percpu_ref_try_get().

To fix this, we try to increase both the refcnt of the superblock and the
percpu refcnt of cgroup root.

v2:
- we should try to get both the superblock refcnt and cgroup_root refcnt,
  because cgroup_root may have no superblock assosiated with it.
- adjust/add comments.

tj: Updated comments.  Renamed @sb to @pinned_sb.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[lizf: Backported to 3.15:
 - Adjust context
 - s/percpu_tryget_live/atomic_inc_not_zero/]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1484,6 +1484,7 @@ static struct dentry *cgroup_mount(struc
 			 int flags, const char *unused_dev_name,
 			 void *data)
 {
+	struct super_block *pinned_sb = NULL;
 	struct cgroup_subsys *ss;
 	struct cgroup_root *root;
 	struct cgroup_sb_opts opts;
@@ -1584,10 +1585,25 @@ retry:
 		 * destruction to complete so that the subsystems are free.
 		 * We can use wait_queue for the wait but this path is
 		 * super cold.  Let's just sleep for a bit and retry.
+
+		 * We want to reuse @root whose lifetime is governed by its
+		 * ->cgrp.  Let's check whether @root is alive and keep it
+		 * that way.  As cgroup_kill_sb() can happen anytime, we
+		 * want to block it by pinning the sb so that @root doesn't
+		 * get killed before mount is complete.
+		 *
+		 * With the sb pinned, inc_not_zero can reliably indicate
+		 * whether @root can be reused.  If it's being killed,
+		 * drain it.  We can use wait_queue for the wait but this
+		 * path is super cold.  Let's just sleep a bit and retry.
 		 */
-		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
+		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
+		if (IS_ERR(pinned_sb) ||
+		    !atomic_inc_not_zero(&root->cgrp.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			mutex_unlock(&cgroup_tree_mutex);
+			if (!IS_ERR_OR_NULL(pinned_sb))
+				deactivate_super(pinned_sb);
 			msleep(10);
 			mutex_lock(&cgroup_tree_mutex);
 			mutex_lock(&cgroup_mutex);
@@ -1634,6 +1650,16 @@ out_unlock:
 				CGROUP_SUPER_MAGIC, &new_sb);
 	if (IS_ERR(dentry) || !new_sb)
 		cgroup_put(&root->cgrp);
+
+	/*
+	 * If @pinned_sb, we're reusing an existing root and holding an
+	 * extra ref on its sb.  Mount is complete.  Put the extra ref.
+	 */
+	if (pinned_sb) {
+		WARN_ON(new_sb);
+		deactivate_super(pinned_sb);
+	}
+
 	return dentry;
 }
 


