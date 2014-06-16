Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaFPVlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:41:08 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:44095 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbaFPVkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:40:20 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] mfd: cros_ec: Check result code from EC messages
Date: Mon, 16 Jun 2014 14:39:59 -0700
Message-Id: <1402954800-28215-10-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1402954800-28215-1-git-send-email-dianders@chromium.org>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Richardson <wfrichar@chromium.org>

Just because the host was able to talk to the EC doesn't mean that the EC
was happy with what it was told. Errors in communincation are not the same
as error messages from the EC itself.

This change lets the EC report its errors separately.

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mfd/cros_ec_i2c.c | 15 +++++++++++----
 drivers/mfd/cros_ec_spi.c | 26 ++++++++++++++------------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
index 5bb32f5..2276096 100644
--- a/drivers/mfd/cros_ec_i2c.c
+++ b/drivers/mfd/cros_ec_i2c.c
@@ -92,11 +92,18 @@ static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
 	}
 
 	/* check response error code */
-	if (i2c_msg[1].buf[0]) {
-		dev_warn(ec_dev->dev, "command 0x%02x returned an error %d\n",
-			 msg->command, i2c_msg[1].buf[0]);
-		ret = -EINVAL;
+	msg->result = i2c_msg[1].buf[0];
+	switch (msg->result) {
+	case EC_RES_SUCCESS:
+		break;
+	case EC_RES_IN_PROGRESS:
+		ret = -EAGAIN;
+		dev_dbg(ec_dev->dev, "command 0x%02x in progress\n",
+			msg->command);
 		goto done;
+	default:
+		dev_warn(ec_dev->dev, "command 0x%02x returned %d\n",
+			 msg->command, msg->result);
 	}
 
 	/* copy response packet payload and compute checksum */
diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 09ca789..4d34f1c 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -289,21 +289,23 @@ static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
 		goto exit;
 	}
 
-	/* check response error code */
 	ptr = ec_dev->din;
-	if (ptr[0]) {
-		if (ptr[0] == EC_RES_IN_PROGRESS) {
-			dev_dbg(ec_dev->dev, "command 0x%02x in progress\n",
-				ec_msg->command);
-			ret = -EAGAIN;
-			goto exit;
-		}
-		dev_warn(ec_dev->dev, "command 0x%02x returned an error %d\n",
-			 ec_msg->command, ptr[0]);
-		debug_packet(ec_dev->dev, "in_err", ptr, len);
-		ret = -EINVAL;
+
+	/* check response error code */
+	ec_msg->result = ptr[0];
+	switch (ec_msg->result) {
+	case EC_RES_SUCCESS:
+		break;
+	case EC_RES_IN_PROGRESS:
+		ret = -EAGAIN;
+		dev_dbg(ec_dev->dev, "command 0x%02x in progress\n",
+			ec_msg->command);
 		goto exit;
+	default:
+		dev_warn(ec_dev->dev, "command 0x%02x returned %d\n",
+			 ec_msg->command, ec_msg->result);
 	}
+
 	len = ptr[1];
 	sum = ptr[0] + ptr[1];
 	if (len > ec_msg->insize) {
-- 
2.0.0.526.g5318336

