Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbaEIVQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:16:55 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:53462 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbaEIVNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:13:40 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/9] cgroup: use restart_syscall() for mount retries
Date: Fri,  9 May 2014 17:13:27 -0400
Message-Id: <1399670015-23463-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_mount() uses dumb delay-and-retry logic to wait for cgroup_root
which is being destroyed.  The retry currently loops inside
cgroup_mount() proper.  This patch makes it return with
restart_syscall() instead so that retry travels out to userland
boundary.

This slightly simplifies the logic and more importantly makes the
retry logic behave better when the wait for some reason becomes
lengthy or infinite by allowing the operation to be suspended or
terminated from userland.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3083c5a..2755f33 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1681,7 +1681,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	ret = parse_cgroupfs_options(data, &opts);
 	if (ret)
 		goto out_unlock;
-retry:
+
 	/* look for a matching existing root */
 	if (!opts.subsys_mask && !opts.none && !opts.name) {
 		cgrp_dfl_root_visible = true;
@@ -1740,8 +1740,7 @@ retry:
 		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			msleep(10);
-			mutex_lock(&cgroup_mutex);
-			goto retry;
+			return ERR_PTR(restart_syscall());
 		}
 
 		ret = 0;
-- 
1.9.0

