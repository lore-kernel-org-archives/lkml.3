Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbaGSIaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 04:30:20 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35124 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaGSIaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 04:30:17 -0400
Date: Sat, 19 Jul 2014 14:00:10 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] mfd: core: Use devm_kzalloc
Message-ID: <20140719083010.GA2882@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of devm_kzalloc instead of the
corresponding unmanaged version and does away with the kfrees in the
probe and remove functions. Also, a label is done away with.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/mfd/tps6105x.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/tps6105x.c b/drivers/mfd/tps6105x.c
index b5dfa6e..5de95c2 100644
--- a/drivers/mfd/tps6105x.c
+++ b/drivers/mfd/tps6105x.c
@@ -141,7 +141,7 @@ static int tps6105x_probe(struct i2c_client *client,
 	int ret;
 	int i;
 
-	tps6105x = kmalloc(sizeof(*tps6105x), GFP_KERNEL);
+	tps6105x = devm_kmalloc(&client->dev, sizeof(*tps6105x), GFP_KERNEL);
 	if (!tps6105x)
 		return -ENOMEM;
 
@@ -154,7 +154,7 @@ static int tps6105x_probe(struct i2c_client *client,
 	ret = tps6105x_startup(tps6105x);
 	if (ret) {
 		dev_err(&client->dev, "chip initialization failed\n");
-		goto fail;
+		return ret;
 	}
 
 	/* Remove warning texts when you implement new cell drivers */
@@ -187,16 +187,8 @@ static int tps6105x_probe(struct i2c_client *client,
 		tps6105x_cells[i].pdata_size = sizeof(*tps6105x);
 	}
 
-	ret = mfd_add_devices(&client->dev, 0, tps6105x_cells,
-			      ARRAY_SIZE(tps6105x_cells), NULL, 0, NULL);
-	if (ret)
-		goto fail;
-
-	return 0;
-
-fail:
-	kfree(tps6105x);
-	return ret;
+	return mfd_add_devices(&client->dev, 0, tps6105x_cells,
+			       ARRAY_SIZE(tps6105x_cells), NULL, 0, NULL);
 }
 
 static int tps6105x_remove(struct i2c_client *client)
@@ -210,7 +202,6 @@ static int tps6105x_remove(struct i2c_client *client)
 		TPS6105X_REG0_MODE_MASK,
 		TPS6105X_MODE_SHUTDOWN << TPS6105X_REG0_MODE_SHIFT);
 
-	kfree(tps6105x);
 	return 0;
 }
 
-- 
1.9.1

