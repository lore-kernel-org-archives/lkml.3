Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3BJRck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 12:32:40 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:38883 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3BJRcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 12:32:39 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] bq2415x_charger: Add support for offline and 100mA mode
Date: Sun, 10 Feb 2013 18:32:18 +0100
Message-Id: <1360517538-1022-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Renamed mode BQ2415X_MODE_NONE to BQ2415X_MODE_OFF
  because this mode turning chaging completly off

* Added new mode BQ2415X_MODE_NONE which enable charging
  with maximal current limit 100mA (this is minimal safe
  value for bq2415x chips)

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/bq2415x_charger.c       |   25 ++++++++++++++++++-------
 include/linux/power/bq2415x_charger.h |    3 ++-
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index ee842b3..293b70d 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -734,12 +734,10 @@ static int bq2415x_set_mode(struct bq2415x_device *bq, enum bq2415x_mode mode)
 	int charger = 0;
 	int boost = 0;
 
-	if (mode == BQ2415X_MODE_HOST_CHARGER ||
-		mode == BQ2415X_MODE_DEDICATED_CHARGER)
-			charger = 1;
-
 	if (mode == BQ2415X_MODE_BOOST)
 		boost = 1;
+	else if (mode != BQ2415X_MODE_OFF)
+		charger = 1;
 
 	if (!charger)
 		ret = bq2415x_exec_command(bq, BQ2415X_CHARGER_DISABLE);
@@ -751,6 +749,10 @@ static int bq2415x_set_mode(struct bq2415x_device *bq, enum bq2415x_mode mode)
 		return ret;
 
 	switch (mode) {
+	case BQ2415X_MODE_OFF:
+		dev_dbg(bq->dev, "changing mode to: Offline\n");
+		ret = bq2415x_set_current_limit(bq, 100);
+		break;
 	case BQ2415X_MODE_NONE:
 		dev_dbg(bq->dev, "changing mode to: N/A\n");
 		ret = bq2415x_set_current_limit(bq, 100);
@@ -843,7 +845,7 @@ static void bq2415x_timer_error(struct bq2415x_device *bq, const char *msg)
 	dev_err(bq->dev, "%s\n", msg);
 	if (bq->automode > 0)
 		bq->automode = 0;
-	bq2415x_set_mode(bq, BQ2415X_MODE_NONE);
+	bq2415x_set_mode(bq, BQ2415X_MODE_OFF);
 	bq2415x_set_autotimer(bq, 0);
 }
 
@@ -1136,6 +1138,10 @@ static ssize_t bq2415x_sysfs_set_mode(struct device *dev,
 			return -ENOSYS;
 		bq->automode = 1;
 		mode = bq->reported_mode;
+	} else if (strncmp(buf, "off", 3) == 0) {
+		if (bq->automode > 0)
+			bq->automode = 0;
+		mode = BQ2415X_MODE_OFF;
 	} else if (strncmp(buf, "none", 4) == 0) {
 		if (bq->automode > 0)
 			bq->automode = 0;
@@ -1183,6 +1189,9 @@ static ssize_t bq2415x_sysfs_show_mode(struct device *dev,
 		ret += sprintf(buf+ret, "auto (");
 
 	switch (bq->mode) {
+	case BQ2415X_MODE_OFF:
+		ret += sprintf(buf+ret, "off");
+		break;
 	case BQ2415X_MODE_NONE:
 		ret += sprintf(buf+ret, "none");
 		break;
@@ -1217,6 +1226,8 @@ static ssize_t bq2415x_sysfs_show_reported_mode(struct device *dev,
 		return -EINVAL;
 
 	switch (bq->reported_mode) {
+	case BQ2415X_MODE_OFF:
+		return sprintf(buf, "off\n");
 	case BQ2415X_MODE_NONE:
 		return sprintf(buf, "none\n");
 	case BQ2415X_MODE_HOST_CHARGER:
@@ -1536,8 +1547,8 @@ static int bq2415x_probe(struct i2c_client *client,
 	bq->dev = &client->dev;
 	bq->chip = id->driver_data;
 	bq->name = name;
-	bq->mode = BQ2415X_MODE_NONE;
-	bq->reported_mode = BQ2415X_MODE_NONE;
+	bq->mode = BQ2415X_MODE_OFF;
+	bq->reported_mode = BQ2415X_MODE_OFF;
 	bq->autotimer = 0;
 	bq->automode = 0;
 
diff --git a/include/linux/power/bq2415x_charger.h b/include/linux/power/bq2415x_charger.h
index 97a1665..8dcc0f4 100644
--- a/include/linux/power/bq2415x_charger.h
+++ b/include/linux/power/bq2415x_charger.h
@@ -75,7 +75,8 @@
 
 /* Supported modes with maximal current limit */
 enum bq2415x_mode {
-	BQ2415X_MODE_NONE,		/* unknown or no charger (100mA) */
+	BQ2415X_MODE_OFF,		/* offline mode (charger disabled) */
+	BQ2415X_MODE_NONE,		/* unknown charger (100mA) */
 	BQ2415X_MODE_HOST_CHARGER,	/* usb host/hub charger (500mA) */
 	BQ2415X_MODE_DEDICATED_CHARGER, /* dedicated charger (unlimited) */
 	BQ2415X_MODE_BOOST,		/* boost mode (charging disabled) */
-- 
1.7.10.4

