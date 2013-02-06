Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab3BFT7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:59:45 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:63945 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207Ab3BFTun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:43 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 48/77] memstick: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:20 -0800
Message-Id: <1360179649-22465-49-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/memstick.c    | 21 ++++++++++-----------
 drivers/memstick/core/mspro_block.c | 17 +++--------------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 56ff19c..ffcb10a 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -512,18 +512,17 @@ int memstick_add_host(struct memstick_host *host)
 {
 	int rc;
 
-	while (1) {
-		if (!idr_pre_get(&memstick_host_idr, GFP_KERNEL))
-			return -ENOMEM;
+	idr_preload(GFP_KERNEL);
+	spin_lock(&memstick_host_lock);
 
-		spin_lock(&memstick_host_lock);
-		rc = idr_get_new(&memstick_host_idr, host, &host->id);
-		spin_unlock(&memstick_host_lock);
-		if (!rc)
-			break;
-		else if (rc != -EAGAIN)
-			return rc;
-	}
+	rc = idr_alloc(&memstick_host_idr, host, 0, 0, GFP_NOWAIT);
+	if (rc >= 0)
+		host->id = rc;
+
+	spin_unlock(&memstick_host_lock);
+	idr_preload_end();
+	if (rc < 0)
+		return rc;
 
 	dev_set_name(&host->dev, "memstick%u", host->id);
 
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 9729b92..f12b78d 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1213,21 +1213,10 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
 	mutex_lock(&mspro_block_disk_lock);
-	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL)) {
-		mutex_unlock(&mspro_block_disk_lock);
-		return -ENOMEM;
-	}
-
-	rc = idr_get_new(&mspro_block_disk_idr, card, &disk_id);
+	disk_id = idr_alloc(&mspro_block_disk_idr, card, 0, 256, GFP_KERNEL);
 	mutex_unlock(&mspro_block_disk_lock);
-
-	if (rc)
-		return rc;
-
-	if ((disk_id << MSPRO_BLOCK_PART_SHIFT) > 255) {
-		rc = -ENOSPC;
-		goto out_release_id;
-	}
+	if (disk_id < 0)
+		return disk_id;
 
 	msb->disk = alloc_disk(1 << MSPRO_BLOCK_PART_SHIFT);
 	if (!msb->disk) {
-- 
1.8.1

