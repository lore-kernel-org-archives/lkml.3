Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbaEITdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:33:05 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:42595 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbaEITdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:33:00 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] cgroup: cgroup_idr_lock should be bh
Date: Fri,  9 May 2014 15:32:50 -0400
Message-Id: <1399663975-315-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399663975-315-1-git-send-email-tj@kernel.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_idr_remove() can be invoked from bh leading to lockdep
detecting possible AA deadlock (IN_BH/ON_BH).  Make the lock bh-safe.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 95fc66b..e2ff925 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -203,9 +203,9 @@ static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
 	int ret;
 
 	idr_preload(gfp_mask);
-	spin_lock(&cgroup_idr_lock);
+	spin_lock_bh(&cgroup_idr_lock);
 	ret = idr_alloc(idr, ptr, start, end, gfp_mask);
-	spin_unlock(&cgroup_idr_lock);
+	spin_unlock_bh(&cgroup_idr_lock);
 	idr_preload_end();
 	return ret;
 }
@@ -214,17 +214,17 @@ static void *cgroup_idr_replace(struct idr *idr, void *ptr, int id)
 {
 	void *ret;
 
-	spin_lock(&cgroup_idr_lock);
+	spin_lock_bh(&cgroup_idr_lock);
 	ret = idr_replace(idr, ptr, id);
-	spin_unlock(&cgroup_idr_lock);
+	spin_unlock_bh(&cgroup_idr_lock);
 	return ret;
 }
 
 static void cgroup_idr_remove(struct idr *idr, int id)
 {
-	spin_lock(&cgroup_idr_lock);
+	spin_lock_bh(&cgroup_idr_lock);
 	idr_remove(idr, id);
-	spin_unlock(&cgroup_idr_lock);
+	spin_unlock_bh(&cgroup_idr_lock);
 }
 
 /**
-- 
1.9.0

