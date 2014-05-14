Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaENNMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:12:53 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:61142 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbaENNMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:12:51 -0400
Date: Wed, 14 May 2014 09:12:48 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/9] cgroup: use restart_syscall() for mount retries
Message-ID: <20140514131248.GF28815@htj.dyndns.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
 <1399670015-23463-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399670015-23463-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
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

v2: The original patch forgot to free memory allocated for @opts.
    Fixed.  Caught by Li Zefan.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1681,7 +1681,7 @@ static struct dentry *cgroup_mount(struc
 	ret = parse_cgroupfs_options(data, &opts);
 	if (ret)
 		goto out_unlock;
-retry:
+
 	/* look for a matching existing root */
 	if (!opts.subsys_mask && !opts.none && !opts.name) {
 		cgrp_dfl_root_visible = true;
@@ -1740,8 +1740,8 @@ retry:
 		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			msleep(10);
-			mutex_lock(&cgroup_mutex);
-			goto retry;
+			ret = restart_syscall();
+			goto out_free;
 		}
 
 		ret = 0;
@@ -1772,7 +1772,7 @@ retry:
 
 out_unlock:
 	mutex_unlock(&cgroup_mutex);
-
+out_free:
 	kfree(opts.release_agent);
 	kfree(opts.name);
 
