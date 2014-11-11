Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaKKNZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:25:23 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49299 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKKNZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:25:19 -0500
Message-ID: <54620E51.3020901@gmail.com>
Date: Tue, 11 Nov 2014 14:25:37 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [RESEND][PATCH 1/5] Update drivers names to the ones invoked by i2c-powermac
References: <1407567003-18332-1-git-send-email-kreijack@inwind.it>
In-Reply-To: <1407567003-18332-1-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
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
2.1.0.rc1


