Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaG3Upl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:45:41 -0400
Received: from outrelay07.libero.it ([212.52.84.111]:35662 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaG3Upi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:45:38 -0400
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A0C0206.53D9596D.00CF,ss=1,re=0.000,fgs=0
X-libjamoibt: 1823
Message-ID: <53D95AB5.9030500@inwind.it>
Date: Wed, 30 Jul 2014 22:51:01 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jean Delvare <jdelvare@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] therm_windtunnel doesn't work properly on PowerMac G4
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rename the driver name
	therm_ds1775 -> MAC,ds1775
	therm_adm1030 -> MAC,adm1030
Start the background fan control loop from
the devices probing methods.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 drivers/macintosh/therm_windtunnel.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 3b4a157..9583413 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -334,6 +334,15 @@ do_attach( struct i2c_adapter *adapter )
 	return 0;
 }
 
+static void
+try_start_control_loop(void)
+{
+	if (x.thermostat && x.fan && !x.running) {
+		x.running = 1;
+		x.poll_task = kthread_run(control_loop, NULL, "g4fand");
+	}
+}
+
 static int
 do_remove(struct i2c_client *client)
 {
@@ -364,6 +373,7 @@ attach_fan( struct i2c_client *cl )
 	printk("ADM1030 fan controller [@%02x]\n", cl->addr );
 
 	x.fan = cl;
+	try_start_control_loop();
  out:
 	return 0;
 }
@@ -397,6 +407,7 @@ attach_thermostat( struct i2c_client *cl )
 	x.overheat_temp = os_temp;
 	x.overheat_hyst = hyst_temp;
 	x.thermostat = cl;
+	try_start_control_loop();
 out:
 	return 0;
 }
@@ -404,8 +415,8 @@ out:
 enum chip { ds1775, adm1030 };
 
 static const struct i2c_device_id therm_windtunnel_id[] = {
-	{ "therm_ds1775", ds1775 },
-	{ "therm_adm1030", adm1030 },
+	{ "MAC,ds1775", ds1775 },
+	{ "MAC,adm1030", adm1030 },
 	{ }
 };
 
