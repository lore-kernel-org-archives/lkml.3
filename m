Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3BCBaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:30:05 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35933 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3BCBWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:18 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 32/62] memstick: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:33 -0800
Message-Id: <1359854463-2538-33-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alex Dubov <oakad@yahoo.com>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

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

