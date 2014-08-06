Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaHFVFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:05:16 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:44573 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaHFVFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:05:13 -0400
From: Goffredo Baroncelli <kreijack@gmail.com>
X-Google-Original-From: Goffredo Baroncelli <kreijack@inwind.it>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/5] Update drivers names to the ones invoked by i2c-powermac
Date: Wed,  6 Aug 2014 21:04:59 +0000
Message-Id: <1407359103-6012-2-git-send-email-kreijack@inwind.it>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1407359103-6012-1-git-send-email-kreijack@inwind.it>
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update drivers names to the ones invoked by i2c-powermac:
- therm_ds1775 -> MAC,ds1775
- therm_adm1030 -> MAC,adm1030
The background fan control loop is started from
the devices probing methods.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 drivers/macintosh/therm_windtunnel.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 3b4a157..a64a06f 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -334,6 +334,23 @@ do_attach( struct i2c_adapter *adapter )
 	return 0;
 }
 
+static void
+try_start_control_loop(void)
+{
+
+	mutex_lock(&x.lock);
+	if (!x.thermostat || !x.fan || x.running) {
+		mutex_unlock(&x.lock);
+		return;
+	}
+
+	x.running = 1;
+	mutex_unlock(&x.lock);
+
+	x.poll_task = kthread_run(control_loop, NULL, "g4fand");
+
+}
+
 static int
 do_remove(struct i2c_client *client)
 {
@@ -364,6 +381,7 @@ attach_fan( struct i2c_client *cl )
 	printk("ADM1030 fan controller [@%02x]\n", cl->addr );
 
 	x.fan = cl;
+	try_start_control_loop();
  out:
 	return 0;
 }
@@ -397,6 +415,7 @@ attach_thermostat( struct i2c_client *cl )
 	x.overheat_temp = os_temp;
 	x.overheat_hyst = hyst_temp;
 	x.thermostat = cl;
+	try_start_control_loop();
 out:
 	return 0;
 }
@@ -404,8 +423,8 @@ out:
 enum chip { ds1775, adm1030 };
 
 static const struct i2c_device_id therm_windtunnel_id[] = {
-	{ "therm_ds1775", ds1775 },
-	{ "therm_adm1030", adm1030 },
+	{ "MAC,ds1775", ds1775 },
+	{ "MAC,adm1030", adm1030 },
 	{ }
 };
 
-- 
2.0.1

