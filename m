Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbbAVTS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:18:27 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36171 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbbAVTQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:16:41 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 1/7] mfd: cros_ec: Use fixed size arrays to transfer data with the EC
Date: Thu, 22 Jan 2015 20:16:20 +0100
Message-Id: <1421954186-29764-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct cros_ec_command will be used as an ioctl() argument for the
API to control the ChromeOS EC from user-space. So the data structure
has to be 64-bit safe to make it compatible between 32 and 64 avoiding
the need for a compat ioctl interface. Since pointers are self-aligned
to different byte boundaries, use fixed size arrays instead of pointers
for transferring ingoing and outgoing data with the Embedded Controller.

Also, re-arrange struct members by decreasing alignment requirements to
reduce the needing padding size.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Acked-by: Lee Jones <lee.jones@linaro.org>
---

Hello,

I choose EC_PROTO2_MAX_PARAM_SIZE as the maximum length for the input and
output buffers since I see that is what is assumed in the cros_ec driver
that is the maximum lengths. But the downstream kernel has also suppport
for the EC host command protocol v3 even though there is currently no bus
specific code to handle v3 packets. So I wonder if this is a good max len
or if a different size should be used instead.

Best regards,
Javier

Changes since v2: None, added Lee Jones Acked-by tag.

Changes since v1: None, new patch
---
 drivers/i2c/busses/i2c-cros-ec-tunnel.c | 51 +++++++--------------------------
 drivers/input/keyboard/cros_ec_keyb.c   | 13 +++++----
 drivers/mfd/cros_ec.c                   | 15 +++++-----
 include/linux/mfd/cros_ec.h             |  8 +++---
 4 files changed, 29 insertions(+), 58 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
index 875c22ae5400..fa8dedd8c3a2 100644
--- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
+++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
@@ -182,72 +182,41 @@ static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
 	const u16 bus_num = bus->remote_bus;
 	int request_len;
 	int response_len;
-	u8 *request = NULL;
-	u8 *response = NULL;
 	int result;
-	struct cros_ec_command msg;
+	struct cros_ec_command msg = { };
 
 	request_len = ec_i2c_count_message(i2c_msgs, num);
 	if (request_len < 0) {
 		dev_warn(dev, "Error constructing message %d\n", request_len);
-		result = request_len;
-		goto exit;
+		return request_len;
 	}
+
 	response_len = ec_i2c_count_response(i2c_msgs, num);
 	if (response_len < 0) {
 		/* Unexpected; no errors should come when NULL response */
 		dev_warn(dev, "Error preparing response %d\n", response_len);
-		result = response_len;
-		goto exit;
-	}
-
-	if (request_len <= ARRAY_SIZE(bus->request_buf)) {
-		request = bus->request_buf;
-	} else {
-		request = kzalloc(request_len, GFP_KERNEL);
-		if (request == NULL) {
-			result = -ENOMEM;
-			goto exit;
-		}
-	}
-	if (response_len <= ARRAY_SIZE(bus->response_buf)) {
-		response = bus->response_buf;
-	} else {
-		response = kzalloc(response_len, GFP_KERNEL);
-		if (response == NULL) {
-			result = -ENOMEM;
-			goto exit;
-		}
+		return response_len;
 	}
 
-	result = ec_i2c_construct_message(request, i2c_msgs, num, bus_num);
+	result = ec_i2c_construct_message(msg.outdata, i2c_msgs, num, bus_num);
 	if (result)
-		goto exit;
+		return result;
 
 	msg.version = 0;
 	msg.command = EC_CMD_I2C_PASSTHRU;
-	msg.outdata = request;
 	msg.outsize = request_len;
-	msg.indata = response;
 	msg.insize = response_len;
 
 	result = cros_ec_cmd_xfer(bus->ec, &msg);
 	if (result < 0)
-		goto exit;
+		return result;
 
-	result = ec_i2c_parse_response(response, i2c_msgs, &num);
+	result = ec_i2c_parse_response(msg.indata, i2c_msgs, &num);
 	if (result < 0)
-		goto exit;
+		return result;
 
 	/* Indicate success by saying how many messages were sent */
-	result = num;
-exit:
-	if (request != bus->request_buf)
-		kfree(request);
-	if (response != bus->response_buf)
-		kfree(response);
-
-	return result;
+	return num;
 }
 
 static u32 ec_i2c_functionality(struct i2c_adapter *adap)
diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
index ffa989f2c785..769f8f7f62b7 100644
--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -148,16 +148,19 @@ static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
 
 static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, uint8_t *kb_state)
 {
+	int ret;
 	struct cros_ec_command msg = {
-		.version = 0,
 		.command = EC_CMD_MKBP_STATE,
-		.outdata = NULL,
-		.outsize = 0,
-		.indata = kb_state,
 		.insize = ckdev->cols,
 	};
 
-	return cros_ec_cmd_xfer(ckdev->ec, &msg);
+	ret = cros_ec_cmd_xfer(ckdev->ec, &msg);
+	if (ret < 0)
+		return ret;
+
+	memcpy(kb_state, msg.indata, ckdev->cols);
+
+	return 0;
 }
 
 static irqreturn_t cros_ec_keyb_irq(int irq, void *data)
diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
index fc0c81ef04ff..c872e1b0eaf8 100644
--- a/drivers/mfd/cros_ec.c
+++ b/drivers/mfd/cros_ec.c
@@ -74,15 +74,11 @@ int cros_ec_cmd_xfer(struct cros_ec_device *ec_dev,
 	ret = ec_dev->cmd_xfer(ec_dev, msg);
 	if (msg->result == EC_RES_IN_PROGRESS) {
 		int i;
-		struct cros_ec_command status_msg;
-		struct ec_response_get_comms_status status;
+		struct cros_ec_command status_msg = { };
+		struct ec_response_get_comms_status *status;
 
-		status_msg.version = 0;
 		status_msg.command = EC_CMD_GET_COMMS_STATUS;
-		status_msg.outdata = NULL;
-		status_msg.outsize = 0;
-		status_msg.indata = (uint8_t *)&status;
-		status_msg.insize = sizeof(status);
+		status_msg.insize = sizeof(*status);
 
 		/*
 		 * Query the EC's status until it's no longer busy or
@@ -98,7 +94,10 @@ int cros_ec_cmd_xfer(struct cros_ec_device *ec_dev,
 			msg->result = status_msg.result;
 			if (status_msg.result != EC_RES_SUCCESS)
 				break;
-			if (!(status.flags & EC_COMMS_STATUS_PROCESSING))
+
+			status = (struct ec_response_get_comms_status *)
+				 status_msg.indata;
+			if (!(status->flags & EC_COMMS_STATUS_PROCESSING))
 				break;
 		}
 	}
diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
index 0e166b92f5b4..71675b14b5ca 100644
--- a/include/linux/mfd/cros_ec.h
+++ b/include/linux/mfd/cros_ec.h
@@ -38,20 +38,20 @@ enum {
 /*
  * @version: Command version number (often 0)
  * @command: Command to send (EC_CMD_...)
- * @outdata: Outgoing data to EC
  * @outsize: Outgoing length in bytes
- * @indata: Where to put the incoming data from EC
  * @insize: Max number of bytes to accept from EC
  * @result: EC's response to the command (separate from communication failure)
+ * @outdata: Outgoing data to EC
+ * @indata: Where to put the incoming data from EC
  */
 struct cros_ec_command {
 	uint32_t version;
 	uint32_t command;
-	uint8_t *outdata;
 	uint32_t outsize;
-	uint8_t *indata;
 	uint32_t insize;
 	uint32_t result;
+	uint8_t outdata[EC_PROTO2_MAX_PARAM_SIZE];
+	uint8_t indata[EC_PROTO2_MAX_PARAM_SIZE];
 };
 
 /**
-- 
2.1.3

