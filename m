Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaLQKDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:03:31 -0500
Received: from bay004-omc1s27.hotmail.com ([65.54.190.38]:62197 "EHLO
	BAY004-OMC1S27.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbaLQKD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:03:28 -0500
X-TMN: [mN+ITJHlswirJfOIvoN1HoMDRbRuP8zs]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY407-EAS935B813BC07121616D15F1BD6D0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <jmmahler@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v16 08/12] input: cyapa: add gen3 trackpad device force
Date: Wed, 17 Dec 2014 17:57:35 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AdAZ3y3Ee+v5nHWkT1SHYN44dAAQPw==
Content-Language: zh-cn
X-OriginalArrivalTime: 17 Dec 2014 09:57:36.0831 (UTC) FILETIME=[E2DD74F0:01D019DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add force re-calibrate function supported for gen3 trackpad device,
it can be used through sysfs calibrate interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa_gen3.c | 59 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index 92b3d6d..7351fce 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -765,6 +765,64 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
 	return 0;
 }
 
+static ssize_t cyapa_gen3_do_calibrate(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int tries;
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
+	tries = 20;  /* max recalibration timeout 2s. */
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
@@ -1150,6 +1208,7 @@ const struct cyapa_dev_ops cyapa_gen3_ops = {
 	.bl_deactivate = cyapa_gen3_bl_deactivate,
 
 	.show_baseline = cyapa_gen3_show_baseline,
+	.calibrate_store = cyapa_gen3_do_calibrate,
 
 	.state_parse = cyapa_gen3_state_parse,
 	.operational_check = cyapa_gen3_do_operational_check,
-- 
1.9.1

