Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab3BVSJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:09:23 -0500
Received: from [89.21.227.133] ([89.21.227.133]:62537 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759105Ab3BVSIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:38 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 04/40] Input: atmel_mxt_ts - Implement debug output for messages
Date: Fri, 22 Feb 2013 17:57:51 +0000
Message-Id: <1361555907-19840-5-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debug switch which causes all messages from the touch controller to be
dumped to the dmesg log with a set prefix "MXT MSG:". This is used by Atmel
user-space utilities to debug touch operation. This does impact touch
performance somewhat.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   57 +++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 9cfb124..dad0be9 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -80,6 +80,9 @@
 #define MXT_SPT_MESSAGECOUNT_T44	44
 #define MXT_SPT_CTECONFIG_T46		46
 
+/* MXT_GEN_MESSAGE_T5 object */
+#define MXT_RPTID_NOMSG		0xff
+
 /* MXT_GEN_COMMAND_T6 field */
 #define MXT_COMMAND_RESET	0
 #define MXT_COMMAND_BACKUPNV	1
@@ -257,6 +260,7 @@ struct mxt_data {
 	unsigned int max_x;
 	unsigned int max_y;
 	struct bin_attribute mem_access_attr;
+	bool debug_enabled;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
@@ -329,11 +333,10 @@ static bool mxt_object_writable(unsigned int type)
 	}
 }
 
-static void mxt_dump_message(struct device *dev,
-			     struct mxt_message *message)
+static void mxt_dump_message(struct device *dev, struct mxt_message *message)
 {
-	dev_dbg(dev, "reportid: %u\tmessage: %*ph\n",
-		message->reportid, 7, message->message);
+	dev_dbg(dev, "MXT MSG: %*ph\n",
+		       sizeof(struct mxt_message), message);
 }
 
 static int mxt_check_bootloader(struct i2c_client *client,
@@ -579,6 +582,7 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 	struct device *dev = &data->client->dev;
 	u8 reportid;
 	bool update_input = false;
+	bool handled;
 
 	do {
 		if (mxt_read_message(data, &message)) {
@@ -587,20 +591,24 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 		}
 
 		reportid = message.reportid;
+		handled = false;
 
 		if (reportid == data->T6_reportid) {
 			u8 status = payload[0];
 			unsigned csum = mxt_extract_T6_csum(&payload[1]);
 			dev_dbg(dev, "Status: %02x Config Checksum: %06x\n",
 				status, csum);
+			handled = true;
 		} else if (mxt_is_T9_message(data, &message)) {
 			int id = reportid - data->T9_reportid_min;
 			mxt_input_touchevent(data, &message, id);
 			update_input = true;
-		} else {
-			mxt_dump_message(dev, &message);
+			handled = true;
 		}
-	} while (reportid != 0xff);
+
+		if (!handled || data->debug_enabled)
+			mxt_dump_message(dev, &message);
+	} while (reportid != MXT_RPTID_NOMSG);
 
 	if (update_input) {
 		input_mt_report_pointer_emulation(data->input_dev, false);
@@ -719,7 +727,7 @@ static int mxt_make_highchg(struct mxt_data *data)
 		error = mxt_read_message(data, &message);
 		if (error)
 			return error;
-	} while (message.reportid != 0xff && --count);
+	} while (message.reportid != MXT_RPTID_NOMSG && --count);
 
 	if (!count) {
 		dev_err(dev, "CHG pin isn't cleared\n");
@@ -1122,6 +1130,36 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	return count;
 }
 
+static ssize_t mxt_debug_enable_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int count;
+	char c;
+
+	c = data->debug_enabled ? '1' : '0';
+	count = sprintf(buf, "%c\n", c);
+
+	return count;
+}
+
+static ssize_t mxt_debug_enable_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int i;
+
+	if (sscanf(buf, "%u", &i) == 1 && i < 2) {
+		data->debug_enabled = (i == 1);
+
+		dev_dbg(dev, "%s\n", i ? "debug enabled" : "debug disabled");
+		return count;
+	} else {
+		dev_dbg(dev, "debug_enabled write error\n");
+		return -EINVAL;
+	}
+}
+
 static int mxt_check_mem_access_params(struct mxt_data *data, loff_t off,
 				       size_t *count)
 {
@@ -1176,12 +1214,15 @@ static DEVICE_ATTR(fw_version, S_IRUGO, mxt_fw_version_show, NULL);
 static DEVICE_ATTR(hw_version, S_IRUGO, mxt_hw_version_show, NULL);
 static DEVICE_ATTR(object, S_IRUGO, mxt_object_show, NULL);
 static DEVICE_ATTR(update_fw, S_IWUSR, NULL, mxt_update_fw_store);
+static DEVICE_ATTR(debug_enable, S_IWUSR | S_IRUSR, mxt_debug_enable_show,
+		   mxt_debug_enable_store);
 
 static struct attribute *mxt_attrs[] = {
 	&dev_attr_fw_version.attr,
 	&dev_attr_hw_version.attr,
 	&dev_attr_object.attr,
 	&dev_attr_update_fw.attr,
+	&dev_attr_debug_enable.attr,
 	NULL
 };
 
-- 
1.7.10.4

