Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030182Ab3BFUG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:06:28 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:65131 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab3BFTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:04 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Dan Williams <djbw@fb.com>
Subject: [PATCH 27/77] dmaengine: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:39:59 -0800
Message-Id: <1360179649-22465-28-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dan Williams <djbw@fb.com>
---
 drivers/dma/dmaengine.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 242b8c0..b2728d6 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -686,18 +686,14 @@ static int get_dma_id(struct dma_device *device)
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

