Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaJZJiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 05:38:50 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34859 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaJZJit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 05:38:49 -0400
Message-ID: <1414316325.4290.3.camel@phoenix>
Subject: [PATCH 2/3] soc: ti: knav_qmss_queue: Fix unbalanced locking in
 knav_pool_create()
From: Axel Lin <axel.lin@ingics.com>
To: Santosh Shilimkar <ssantosh@kernel.org>
Cc: Sandeep Nair <sandeep_n@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Sun, 26 Oct 2014 17:38:45 +0800
In-Reply-To: <1414316264.4290.2.camel@phoenix>
References: <1414316264.4290.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't call mutex_unlock() in the error patch if the mutex_lock() is not called.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/soc/ti/knav_qmss_queue.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 0a2c863..d66aaf2 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -785,7 +785,7 @@ void *knav_pool_create(const char *name,
 		dev_err(kdev->dev, "out of descs in region(%d) for pool(%s)\n",
 			region_id, name);
 		ret = -ENOMEM;
-		goto err;
+		goto err_unlock;
 	}
 
 	/* Region maintains a sorted (by region offset) list of pools
@@ -815,15 +815,16 @@ void *knav_pool_create(const char *name,
 		dev_err(kdev->dev, "pool(%s) create failed: fragmented desc pool in region(%d)\n",
 			name, region_id);
 		ret = -ENOMEM;
-		goto err;
+		goto err_unlock;
 	}
 
 	mutex_unlock(&knav_dev_lock);
 	kdesc_fill_pool(pool);
 	return pool;
 
-err:
+err_unlock:
 	mutex_unlock(&knav_dev_lock);
+err:
 	kfree(pool->name);
 	devm_kfree(kdev->dev, pool);
 	return ERR_PTR(ret);
-- 
1.9.1



