Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab3BFUA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:00:56 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41079 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207Ab3BFUAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:00:50 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: [PATCH 37/77] i2c: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:09 -0800
Message-Id: <1360179649-22465-38-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: linux-i2c@vger.kernel.org
---
 drivers/i2c/i2c-core.c | 45 ++++++++++-----------------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 66a30f7..795c916 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -935,25 +935,16 @@ out_list:
  */
 int i2c_add_adapter(struct i2c_adapter *adapter)
 {
-	int	id, res = 0;
-
-retry:
-	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
-		return -ENOMEM;
+	int res;
 
 	mutex_lock(&core_lock);
-	/* "above" here means "above or equal to", sigh */
-	res = idr_get_new_above(&i2c_adapter_idr, adapter,
-				__i2c_first_dynamic_bus_num, &id);
+	res = idr_alloc(&i2c_adapter_idr, adapter,
+			__i2c_first_dynamic_bus_num, 0, GFP_KERNEL);
 	mutex_unlock(&core_lock);
-
-	if (res < 0) {
-		if (res == -EAGAIN)
-			goto retry;
+	if (res < 0)
 		return res;
-	}
 
-	adapter->nr = id;
+	adapter->nr = res;
 	return i2c_register_adapter(adapter);
 }
 EXPORT_SYMBOL(i2c_add_adapter);
@@ -984,33 +975,17 @@ EXPORT_SYMBOL(i2c_add_adapter);
 int i2c_add_numbered_adapter(struct i2c_adapter *adap)
 {
 	int	id;
-	int	status;
 
 	if (adap->nr == -1) /* -1 means dynamically assign bus id */
 		return i2c_add_adapter(adap);
-	if (adap->nr & ~MAX_IDR_MASK)
-		return -EINVAL;
-
-retry:
-	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
-		return -ENOMEM;
 
 	mutex_lock(&core_lock);
-	/* "above" here means "above or equal to", sigh;
-	 * we need the "equal to" result to force the result
-	 */
-	status = idr_get_new_above(&i2c_adapter_idr, adap, adap->nr, &id);
-	if (status == 0 && id != adap->nr) {
-		status = -EBUSY;
-		idr_remove(&i2c_adapter_idr, id);
-	}
+	id = idr_alloc(&i2c_adapter_idr, adap, adap->nr, adap->nr + 1,
+		       GFP_KERNEL);
 	mutex_unlock(&core_lock);
-	if (status == -EAGAIN)
-		goto retry;
-
-	if (status == 0)
-		status = i2c_register_adapter(adap);
-	return status;
+	if (id < 0)
+		return id == -ENOSPC ? -EBUSY : id;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(i2c_add_numbered_adapter);
 
-- 
1.8.1

