Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaJVBQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:16:15 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:42177 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaJVBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:16:13 -0400
From: Puthikorn Voravootivat <puthik@chromium.org>
To: linux-pm@vger.kernel.org
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        David Riley <davidriley@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Puthikorn Voravootivat <puthik@chromium.org>
Subject: [PATCH] bq27x00_battery: Call power_supply_changed only when capacity changed
Date: Tue, 21 Oct 2014 18:15:37 -0700
Message-Id: <1413940537-29766-1-git-send-email-puthik@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current driver, power_supply_changed() is called whenever any of
the battery attribute changed. This causes kernel to increases the
'/sys/power/wakeup_count' and make suspend not working correctly.

This patch change this behavior to call power_supply_changed()
only when the battery capacity changed.

Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
Reviewed-by: David Riley <davidriley@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
---
 drivers/power/bq27x00_battery.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index e3bacfe..7ab3de0 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -493,10 +493,11 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 			di->charge_design_full = bq27x00_battery_read_ilmd(di);
 	}
 
-	if (memcmp(&di->cache, &cache, sizeof(cache)) != 0) {
-		di->cache = cache;
+	if (di->cache.capacity != cache.capacity)
 		power_supply_changed(&di->bat);
-	}
+
+	if (memcmp(&di->cache, &cache, sizeof(cache)) != 0)
+		di->cache = cache;
 
 	di->last_update = jiffies;
 }
-- 
2.1.0.rc2.206.gedb03e5

