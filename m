Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbaCDUDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:03:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbaCDUD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.13 080/172] cgroup: fix locking in cgroup_cfts_commit()
Date: Tue,  4 Mar 2014 12:02:44 -0800
Message-Id: <20140304200302.297523696@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 48573a893303986e3b0b2974d6fb11f3d1bb7064 upstream.

cgroup_cfts_commit() walks the cgroup hierarchy that the target
subsystem is attached to and tries to apply the file changes.  Due to
the convolution with inode locking, it can't keep cgroup_mutex locked
while iterating.  It currently holds only RCU read lock around the
actual iteration and then pins the found cgroup using dget().

Unfortunately, this is incorrect.  Although the iteration does check
cgroup_is_dead() before invoking dget(), there's nothing which
prevents the dentry from going away inbetween.  Note that this is
different from the usual css iterations where css_tryget() is used to
pin the css - css_tryget() tests whether the css can be pinned and
fails if not.

The problem can be solved by simply holding cgroup_mutex instead of
RCU read lock around the iteration, which actually reduces LOC.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2845,10 +2845,7 @@ static int cgroup_cfts_commit(struct cft
 	 */
 	update_before = cgroup_serial_nr_next;
 
-	mutex_unlock(&cgroup_mutex);
-
 	/* add/rm files for all cgroups created before */
-	rcu_read_lock();
 	css_for_each_descendant_pre(css, cgroup_css(root, ss)) {
 		struct cgroup *cgrp = css->cgroup;
 
@@ -2857,23 +2854,19 @@ static int cgroup_cfts_commit(struct cft
 
 		inode = cgrp->dentry->d_inode;
 		dget(cgrp->dentry);
-		rcu_read_unlock();
-
 		dput(prev);
 		prev = cgrp->dentry;
 
+		mutex_unlock(&cgroup_mutex);
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
 		if (cgrp->serial_nr < update_before && !cgroup_is_dead(cgrp))
 			ret = cgroup_addrm_files(cgrp, cfts, is_add);
-		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
-
-		rcu_read_lock();
 		if (ret)
 			break;
 	}
-	rcu_read_unlock();
+	mutex_unlock(&cgroup_mutex);
 	dput(prev);
 	deactivate_super(sb);
 	return ret;


