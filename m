Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3BCB2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:28:37 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52785 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab3BCBWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:32 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 40/62] power: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:41 -0800
Message-Id: <1359854463-2538-41-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/power/bq2415x_charger.c | 11 +++--------
 drivers/power/bq27x00_battery.c |  9 +++------
 drivers/power/ds2782_battery.c  |  9 ++-------
 3 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index ee842b3..65baf4e 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1505,16 +1505,11 @@ static int bq2415x_probe(struct i2c_client *client,
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
index 36b34ef..75dd6a4 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -793,14 +793,11 @@ static int bq27x00_battery_probe(struct i2c_client *client,
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
index 2fa9b6b..c81f3b4 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -335,17 +335,12 @@ static int ds278x_battery_probe(struct i2c_client *client,
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

