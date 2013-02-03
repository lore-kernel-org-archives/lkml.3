Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3BCBVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:21:55 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62516 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3BCBVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:41 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>, Dan Williams <djbw@fb.com>
Subject: [PATCH 12/62] dmaengine: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:13 -0800
Message-Id: <1359854463-2538-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dan Williams <djbw@fb.com>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/dma/dmaengine.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index a815d44..381aa2c 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -667,18 +667,14 @@ static int get_dma_id(struct dma_device *device)
 {
 	int rc;
 
- idr_retry:
-	if (!idr_pre_get(&dma_idr, GFP_KERNEL))
-		return -ENOMEM;
 	mutex_lock(&dma_list_mutex);
-	rc = idr_get_new(&dma_idr, NULL, &device->dev_id);
-	mutex_unlock(&dma_list_mutex);
-	if (rc == -EAGAIN)
-		goto idr_retry;
-	else if (rc != 0)
-		return rc;
 
-	return 0;
+	rc = idr_alloc(&dma_idr, NULL, 0, 0, GFP_KERNEL);
+	if (rc >= 0)
+		device->dev_id = rc;
+
+	mutex_unlock(&dma_list_mutex);
+	return rc < 0 ? rc : 0;
 }
 
 /**
-- 
1.8.1

