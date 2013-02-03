Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3BCBWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:22:44 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56870 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3BCBWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:35 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Rodolfo Giometti <giometti@enneenne.com>
Subject: [PATCH 41/62] pps: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:42 -0800
Message-Id: <1359854463-2538-42-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

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

