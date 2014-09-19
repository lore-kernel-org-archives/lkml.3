Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbaISBsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:48:50 -0400
Received: from bay004-omc1s23.hotmail.com ([65.54.190.34]:56884 "EHLO
	BAY004-OMC1S23.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756627AbaISBrG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:47:06 -0400
X-TMN: [njZ7f88U6TDj9ls5gurwMxaEmwDE5Rkr]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS13F77F70E0A4210C2CC54BDB40@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 08/13] input: cyapa: add gen3 trackpad device baseline and calibrate functions support
Date: Fri, 19 Sep 2014 09:47:05 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/Tq52RSajVrwGwRvWC2CO+BOQbNg==
Content-Language: zh-cn
X-OriginalArrivalTime: 19 Sep 2014 01:47:06.0087 (UTC) FILETIME=[9E028F70:01CFD3AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add report baseline and force calibrate functions supported for gen3
trackpad device, which these functions are supplied through
cyapa core baseline and calibrate interfaces.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa_gen3.c | 135 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 135 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index 5c8ee57..6a0e67a 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -756,6 +756,138 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
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
+	data_reporting_started = false;
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
+			       OP_RECALIBRATION_MASK);
+	if (ret < 0) {
+		dev_err(dev, "Failed to send calibrate command. ret = %d\n",
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
+			dev_err(dev, "Error reading dev status. err = %d\n",
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
+	data_reporting_started = true;
+	return ret < 0 ? ret : count;
+}
+
+static ssize_t cyapa_gen3_show_baseline(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int max_baseline, min_baseline;
+	int tries = 3;
+	int ret;
+
+	data_reporting_started = false;
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
+	data_reporting_started = true;
+	return ret;
+}
+
 /*
  * cyapa_get_wait_time_for_pwr_cmd
  *
@@ -1067,6 +1199,9 @@ const struct cyapa_dev_ops cyapa_gen3_ops = {
 	.update_fw = cyapa_gen3_do_fw_update,
 	.bl_deactivate = cyapa_gen3_bl_deactivate,
 
+	.show_baseline = cyapa_gen3_show_baseline,
+	.calibrate_store = cyapa_gen3_do_calibrate,
+
 	.state_parse = cyapa_gen3_state_parse,
 	.operational_check = cyapa_gen3_do_operational_check,
 
-- 
1.9.1


