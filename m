Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250Ab3BFTvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:51:09 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:59672 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030179Ab3BFTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:54 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 56/77] power: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:28 -0800
Message-Id: <1360179649-22465-57-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/bq2415x_charger.c | 11 +++--------
 drivers/power/bq27x00_battery.c |  9 +++------
 drivers/power/ds2782_battery.c  |  9 ++-------
 3 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index ca70365..3f00568 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1504,16 +1504,11 @@ static int bq2415x_probe(struct i2c_client *client,
 	}
 
 	/* Get new ID for the new device */
-	ret = idr_pre_get(&bq2415x_id, GFP_KERNEL);
-	if (ret == 0)
-		return -ENOMEM;
-
 	mutex_lock(&bq2415x_id_mutex);
-	ret = idr_get_new(&bq2415x_id, client, &num);
+	num = idr_alloc(&bq2415x_id, client, 0, 0, GFP_KERNEL);
 	mutex_unlock(&bq2415x_id_mutex);
-
-	if (ret < 0)
-		return ret;
+	if (num < 0)
+		return num;
 
 	name = kasprintf(GFP_KERNEL, "%s-%d", id->name, num);
 	if (!name) {
diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 8ccf5d7..26037ca 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -791,14 +791,11 @@ static int bq27x00_battery_probe(struct i2c_client *client,
 	int retval = 0;
 
 	/* Get new ID for the new battery device */
-	retval = idr_pre_get(&battery_id, GFP_KERNEL);
-	if (retval == 0)
-		return -ENOMEM;
 	mutex_lock(&battery_mutex);
-	retval = idr_get_new(&battery_id, client, &num);
+	num = idr_alloc(&battery_id, client, 0, 0, GFP_KERNEL);
 	mutex_unlock(&battery_mutex);
-	if (retval < 0)
-		return retval;
+	if (num < 0)
+		return num;
 
 	name = kasprintf(GFP_KERNEL, "%s-%d", id->name, num);
 	if (!name) {
diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index e7301b3..c09e772 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -395,17 +395,12 @@ static int ds278x_battery_probe(struct i2c_client *client,
 	}
 
 	/* Get an ID for this battery */
-	ret = idr_pre_get(&battery_id, GFP_KERNEL);
-	if (ret == 0) {
-		ret = -ENOMEM;
-		goto fail_id;
-	}
-
 	mutex_lock(&battery_lock);
-	ret = idr_get_new(&battery_id, client, &num);
+	ret = idr_alloc(&battery_id, client, 0, 0, GFP_KERNEL);
 	mutex_unlock(&battery_lock);
 	if (ret < 0)
 		goto fail_id;
+	num = ret;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
-- 
1.8.1

