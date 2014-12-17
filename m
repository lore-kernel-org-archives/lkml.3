Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaLQKCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:02:31 -0500
Received: from bay004-omc1s12.hotmail.com ([65.54.190.23]:60467 "EHLO
	BAY004-OMC1S12.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371AbaLQKC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:02:29 -0500
X-TMN: [dsx7T6iheuBv2zUfEvI62HyeaMl+n5LR]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY407-EAS3589D1D6DEF9DBF5FF5D086BD6D0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <jmmahler@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v16 07/12] input: cyapa: add gen3 trackpad device read baseline
Date: Wed, 17 Dec 2014 17:57:28 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AdAZ3xJZKGC4l1rsTmSedU+pGaoqIg==
Content-Language: zh-cn
X-OriginalArrivalTime: 17 Dec 2014 09:57:29.0664 (UTC) FILETIME=[DE97DC00:01D019DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read baseline function supported for gen3 trackpad device,
it can be used through sysfs baseline interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa_gen3.c | 72 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index cd4f1db..92b3d6d 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -765,6 +765,76 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
 	return 0;
 }
 
+static ssize_t cyapa_gen3_show_baseline(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int max_baseline, min_baseline;
+	int tries;
+	int ret;
+
+	ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+	if (ret < 0) {
+		dev_err(dev, "Error reading dev status. err = %d\n", ret);
+		goto out;
+	}
+	if ((ret & CYAPA_DEV_NORMAL) != CYAPA_DEV_NORMAL) {
+		dev_warn(dev, "Trackpad device is busy. device state = 0x%x\n",
+			 ret);
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	ret = cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET,
+			       OP_REPORT_BASELINE_MASK);
+	if (ret < 0) {
+		dev_err(dev, "Failed to send report baseline command. %d\n",
+			ret);
+		goto out;
+	}
+
+	tries = 3;  /* Try for 30 to 60 ms */
+	do {
+		usleep_range(10000, 20000);
+
+		ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+		if (ret < 0) {
+			dev_err(dev, "Error reading dev status. err = %d\n",
+				ret);
+			goto out;
+		}
+		if ((ret & CYAPA_DEV_NORMAL) == CYAPA_DEV_NORMAL)
+			break;
+	} while (--tries);
+
+	if (tries == 0) {
+		dev_err(dev, "Device timed out going to Normal state.\n");
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	ret = cyapa_read_byte(cyapa, CYAPA_CMD_MAX_BASELINE);
+	if (ret < 0) {
+		dev_err(dev, "Failed to read max baseline. err = %d\n", ret);
+		goto out;
+	}
+	max_baseline = ret;
+
+	ret = cyapa_read_byte(cyapa, CYAPA_CMD_MIN_BASELINE);
+	if (ret < 0) {
+		dev_err(dev, "Failed to read min baseline. err = %d\n", ret);
+		goto out;
+	}
+	min_baseline = ret;
+
+	dev_dbg(dev, "Baseline report successful. Max: %d Min: %d\n",
+		max_baseline, min_baseline);
+	ret = scnprintf(buf, PAGE_SIZE, "%d %d\n", max_baseline, min_baseline);
+
+out:
+	return ret;
+}
+
 /*
  * cyapa_get_wait_time_for_pwr_cmd
  *
@@ -1079,6 +1149,8 @@ const struct cyapa_dev_ops cyapa_gen3_ops = {
 	.update_fw = cyapa_gen3_do_fw_update,
 	.bl_deactivate = cyapa_gen3_bl_deactivate,
 
+	.show_baseline = cyapa_gen3_show_baseline,
+
 	.state_parse = cyapa_gen3_state_parse,
 	.operational_check = cyapa_gen3_do_operational_check,
 
-- 
1.9.1

