Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030266Ab3BFTvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:51:14 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:41426 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030199Ab3BFTu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:56 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Rodolfo Giometti <giometti@enneenne.com>
Subject: [PATCH 57/77] pps: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:29 -0800
Message-Id: <1360179649-22465-58-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
---
 drivers/pps/kapi.c |  2 +-
 drivers/pps/pps.c  | 36 ++++++++++++++----------------------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index f197e8e..cdad4d9 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -102,7 +102,7 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 		goto pps_register_source_exit;
 	}
 
-	/* These initializations must be done before calling idr_get_new()
+	/* These initializations must be done before calling idr_alloc()
 	 * in order to avoid reces into pps_event().
 	 */
 	pps->params.api_version = PPS_API_VERS;
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 2420d5a..de8e663 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -290,29 +290,21 @@ int pps_register_cdev(struct pps_device *pps)
 	dev_t devt;
 
 	mutex_lock(&pps_idr_lock);
-	/* Get new ID for the new PPS source */
-	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
-		mutex_unlock(&pps_idr_lock);
-		return -ENOMEM;
-	}
-
-	/* Now really allocate the PPS source.
-	 * After idr_get_new() calling the new source will be freely available
-	 * into the kernel.
+	/*
+	 * Get new ID for the new PPS source.  After idr_alloc() calling
+	 * the new source will be freely available into the kernel.
 	 */
-	err = idr_get_new(&pps_idr, pps, &pps->id);
-	mutex_unlock(&pps_idr_lock);
-
-	if (err < 0)
-		return err;
-
-	pps->id &= MAX_IDR_MASK;
-	if (pps->id >= PPS_MAX_SOURCES) {
-		pr_err("%s: too many PPS sources in the system\n",
-					pps->info.name);
-		err = -EBUSY;
-		goto free_idr;
+	err = idr_alloc(&pps_idr, pps, 0, PPS_MAX_SOURCES, GFP_KERNEL);
+	if (err < 0) {
+		if (err == -ENOSPC) {
+			pr_err("%s: too many PPS sources in the system\n",
+			       pps->info.name);
+			err = -EBUSY;
+		}
+		goto out_unlock;
 	}
+	pps->id = err;
+	mutex_unlock(&pps_idr_lock);
 
 	devt = MKDEV(MAJOR(pps_devt), pps->id);
 
@@ -345,8 +337,8 @@ del_cdev:
 free_idr:
 	mutex_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
+out_unlock:
 	mutex_unlock(&pps_idr_lock);
-
 	return err;
 }
 
-- 
1.8.1

