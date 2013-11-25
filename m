Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3KYNqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:46:35 -0500
Received: from atl4mhfb01.myregisteredsite.com ([209.17.115.55]:41407 "EHLO
	atl4mhfb01.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536Ab3KYNqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:46:34 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] i2c-mux-pca954x: Disable mux after 200ms timeout
Date: Mon, 25 Nov 2013 14:43:57 +0100
Message-Id: <1385387037-3710-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leaving the mux enabled causes needless I2C traffic on the downstream
bus. De-selecting after every request causes excess I2C traffic and
switching.

This patch implements a hybrid solution: After 200ms of inactivity,
the mux is disabled.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/i2c/muxes/i2c-mux-pca954x.c |   45 ++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
index a531d80..1241c97 100644
--- a/drivers/i2c/muxes/i2c-mux-pca954x.c
+++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
@@ -41,6 +41,7 @@
 #include <linux/device.h>
 #include <linux/i2c.h>
 #include <linux/i2c-mux.h>
+#include <linux/workqueue.h>
 
 #include <linux/i2c/pca954x.h>
 
@@ -60,7 +61,8 @@ enum pca_type {
 struct pca954x {
 	enum pca_type type;
 	struct i2c_adapter *virt_adaps[PCA954X_MAX_NCHANS];
-
+	struct i2c_client *client;
+	struct delayed_work deselect_work;
 	u8 last_chan;		/* last register value */
 };
 
@@ -168,11 +170,43 @@ static int pca954x_select_chan(struct i2c_adapter *adap,
 	return ret;
 }
 
-static int pca954x_deselect_mux(struct i2c_adapter *adap,
+static void pca954x_deselect_work(struct work_struct *work)
+{
+	struct pca954x *data = container_of(
+				work, struct pca954x, deselect_work.work);
+	/* Use the adapter lock as a mutex because any method that changes
+	 * the mux state will also hold this mutex. If the bus is in use,
+	 * the lock will assure that at least that transaction will
+	 * complete. */
+	i2c_lock_adapter(data->client->adapter);
+	if (data->last_chan != 0) {
+		int res;
+		/* Disable mux */
+		dev_dbg(&client->dev, "deselecting mux\n");
+		data->last_chan = 0;
+		res = pca954x_reg_write(data->client->adapter,
+				data->client, data->last_chan);
+		if (res < 0)
+			dev_err(&client->dev,
+				"%s: pca954x_reg_write failed: %d\n",
+				__func__, res);
+	}
+	i2c_unlock_adapter(data->client->adapter);
+}
+
+static int pca954x_deselect_mux_delayed(struct i2c_adapter *adap,
 				void *client, u32 chan)
 {
 	struct pca954x *data = i2c_get_clientdata(client);
+	/* Setup timer to disable at a later interval */
+	schedule_delayed_work(&data->deselect_work, msecs_to_jiffies(200));
+	return 0;
+}
 
+static int pca954x_deselect_mux_immediate(struct i2c_adapter *adap,
+				void *client, u32 chan)
+{
+	struct pca954x *data = i2c_get_clientdata(client);
 	/* Deselect active channel */
 	data->last_chan = 0;
 	return pca954x_reg_write(adap, client, data->last_chan);
@@ -212,6 +246,8 @@ static int pca954x_probe(struct i2c_client *client,
 
 	data->type = id->driver_data;
 	data->last_chan = 0;		   /* force the first selection */
+	data->client = client;
+	INIT_DELAYED_WORK(&data->deselect_work, pca954x_deselect_work);
 
 	/* Now create an adapter for each channel */
 	for (num = 0; num < chips[data->type].nchans; num++) {
@@ -231,7 +267,8 @@ static int pca954x_probe(struct i2c_client *client,
 			i2c_add_mux_adapter(adap, &client->dev, client,
 				force, num, class, pca954x_select_chan,
 				(pdata && pdata->modes[num].deselect_on_exit)
-					? pca954x_deselect_mux : NULL);
+					? pca954x_deselect_mux_immediate
+					: pca954x_deselect_mux_delayed);
 
 		if (data->virt_adaps[num] == NULL) {
 			ret = -ENODEV;
@@ -264,6 +301,8 @@ static int pca954x_remove(struct i2c_client *client)
 	const struct chip_desc *chip = &chips[data->type];
 	int i;
 
+	cancel_delayed_work_sync(&data->deselect_work);
+
 	for (i = 0; i < chip->nchans; ++i)
 		if (data->virt_adaps[i]) {
 			i2c_del_mux_adapter(data->virt_adaps[i]);
-- 
1.7.9.5

