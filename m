Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbaCDVTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:19:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbaCDUD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.13 079/172] cgroup: fix error return from cgroup_create()
Date: Tue,  4 Mar 2014 12:02:43 -0800
Message-Id: <20140304200302.266514611@linuxfoundation.org>
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

commit b58c89986a77a23658682a100eb15d8edb571ebb upstream.

cgroup_create() was returning 0 after allocation failures.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4348,7 +4348,7 @@ static long cgroup_create(struct cgroup
 	struct cgroup *cgrp;
 	struct cgroup_name *name;
 	struct cgroupfs_root *root = parent->root;
-	int err = 0;
+	int err;
 	struct cgroup_subsys *ss;
 	struct super_block *sb = root->sb;
 
@@ -4358,8 +4358,10 @@ static long cgroup_create(struct cgroup
 		return -ENOMEM;
 
 	name = cgroup_alloc_name(dentry);
-	if (!name)
+	if (!name) {
+		err = -ENOMEM;
 		goto err_free_cgrp;
+	}
 	rcu_assign_pointer(cgrp->name, name);
 
 	/*
@@ -4367,8 +4369,10 @@ static long cgroup_create(struct cgroup
 	 * a half-baked cgroup.
 	 */
 	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 1, 0, GFP_KERNEL);
-	if (cgrp->id < 0)
+	if (cgrp->id < 0) {
+		err = -ENOMEM;
 		goto err_free_name;
+	}
 
 	/*
 	 * Only live parents can have children.  Note that the liveliness


