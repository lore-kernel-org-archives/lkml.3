Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaFCEGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:06:12 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:53049 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaFCEGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:06:10 -0400
Message-ID: <538D49A7.2010403@huawei.com>
Date: Tue, 3 Jun 2014 12:05:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 3/3] cgroup: set visible flag only after we've mounted the
 default root
References: <538D4956.5050205@huawei.com>
In-Reply-To: <538D4956.5050205@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the failure path, so we won't set the visible flag though
the mount is failed.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index dabc486..0b6b44e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1671,7 +1671,6 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 
 	/* look for a matching existing root */
 	if (!opts.subsys_mask && !opts.none && !opts.name) {
-		cgrp_dfl_root_visible = true;
 		root = &cgrp_dfl_root;
 		cgroup_get(&root->cgrp);
 		ret = 0;
@@ -1770,6 +1769,9 @@ out_free:
 	dentry = kernfs_mount(fs_type, flags, root->kf_root, &new_sb);
 	if (IS_ERR(dentry) || !new_sb)
 		cgroup_put(&root->cgrp);
+	else if (root == &cgrp_dfl_root)
+		cgrp_dfl_root_visible = true;
+
 	return dentry;
 }
 
-- 
1.8.0.2
