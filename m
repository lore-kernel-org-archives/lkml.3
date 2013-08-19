Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab3HSJOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:14:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3HSJOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:14:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/5] GFS2: alloc_workqueue() doesn't return an ERR_PTR
Date: Mon, 19 Aug 2013 09:48:06 +0100
Message-Id: <1376902087-7783-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
References: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

alloc_workqueue() returns a NULL on error, it doesn't return an ERR_PTR.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 9435384..544a809 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1838,14 +1838,14 @@ int __init gfs2_glock_init(void)
 
 	glock_workqueue = alloc_workqueue("glock_workqueue", WQ_MEM_RECLAIM |
 					  WQ_HIGHPRI | WQ_FREEZABLE, 0);
-	if (IS_ERR(glock_workqueue))
-		return PTR_ERR(glock_workqueue);
+	if (!glock_workqueue)
+		return -ENOMEM;
 	gfs2_delete_workqueue = alloc_workqueue("delete_workqueue",
 						WQ_MEM_RECLAIM | WQ_FREEZABLE,
 						0);
-	if (IS_ERR(gfs2_delete_workqueue)) {
+	if (!gfs2_delete_workqueue) {
 		destroy_workqueue(glock_workqueue);
-		return PTR_ERR(gfs2_delete_workqueue);
+		return -ENOMEM;
 	}
 
 	register_shrinker(&glock_shrinker);
-- 
1.7.4

