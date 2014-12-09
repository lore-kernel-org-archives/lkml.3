Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaLIJN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:13:59 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38458 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaLIJN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:13:56 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 08/12] input: cyapa: add gen3 trackpad device force re-calibrate function support
Date: Tue,  9 Dec 2014 17:11:40 +0800
Message-Id: <1418116304-11392-9-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
References: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add force re-calibrate function supported for gen3 trackpad device,
it can be used through sysfs calibrate interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa_gen3.c | 58 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index 3b2ad88..c654109 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -754,6 +754,63 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
 	return 0;
 }
 
+static ssize_t cyapa_gen3_do_calibrate(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int tries = 20;  /* max recalibration timeout 2s. */
+	int ret;
+
+	ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+	if (ret < 0) {
+		dev_err(dev, "Error reading dev status: %d\n", ret);
+		goto out;
+	}
+	if ((ret & CYAPA_DEV_NORMAL) != CYAPA_DEV_NORMAL) {
+		dev_warn(dev, "Trackpad device is busy, device state: 0x%02x\n",
+			 ret);
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	ret = cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET,
+			       OP_RECALIBRATION_MASK);
+	if (ret < 0) {
+		dev_err(dev, "Failed to send calibrate command: %d\n",
+			ret);
+		goto out;
+	}
+
+	do {
+		/*
+		 * For this recalibration, the max time will not exceed 2s.
+		 * The average time is approximately 500 - 700 ms, and we
+		 * will check the status every 100 - 200ms.
+		 */
+		usleep_range(100000, 200000);
+
+		ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+		if (ret < 0) {
+			dev_err(dev, "Error reading dev status: %d\n",
+				ret);
+			goto out;
+		}
+		if ((ret & CYAPA_DEV_NORMAL) == CYAPA_DEV_NORMAL)
+			break;
+	} while (--tries);
+
+	if (tries == 0) {
+		dev_err(dev, "Failed to calibrate. Timeout.\n");
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+	dev_dbg(dev, "Calibration successful.\n");
+
+out:
+	return ret < 0 ? ret : count;
+}
+
 static ssize_t cyapa_gen3_show_baseline(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -1137,6 +1194,7 @@ const struct cyapa_dev_ops cyapa_gen3_ops = {
 	.bl_deactivate = cyapa_gen3_bl_deactivate,
 
 	.show_baseline = cyapa_gen3_show_baseline,
+	.calibrate_store = cyapa_gen3_do_calibrate,
 
 	.state_parse = cyapa_gen3_state_parse,
 	.operational_check = cyapa_gen3_do_operational_check,
-- 
1.9.1

