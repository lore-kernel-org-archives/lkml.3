Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaF0T4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:56:48 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:48065 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaF0T4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:56:46 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Mark Brown <broonie@kernel.org>
Cc: Vincent Palatin <vpalatin@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Randall Spangler <rspangler@chromium.org>, sjg@chromium.org,
        afaerber@suse.de, stephan@synkhronix.com, olof@lixom.net,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mfd: cros_ec: Use the proper size when looking at the cros_ec_i2c result
Date: Fri, 27 Jun 2014 12:56:12 -0700
Message-Id: <1403898973-19571-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403898973-19571-1-git-send-email-dianders@chromium.org>
References: <1403898973-19571-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We know how many bytes the EC should be sending us (which is also the
number of bytes transferred) and also how many bytes the EC actually
wanted to send to us.  When computing the checksum and copying back
data let's make sure we take the lesser of the two of those.  We'll
also complain if the EC tried to send us too many bytes.  The EC
sending us too few bytes is legit for when we send the EC an invalid
command.

This is based on similar code in cros_ec_spi.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mfd/cros_ec_i2c.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
index fd7a546..c0c30f4 100644
--- a/drivers/mfd/cros_ec_i2c.c
+++ b/drivers/mfd/cros_ec_i2c.c
@@ -35,6 +35,7 @@ static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
 	struct i2c_client *client = ec_dev->priv;
 	int ret = -ENOMEM;
 	int i;
+	int len;
 	int packet_len;
 	u8 *out_buf = NULL;
 	u8 *in_buf = NULL;
@@ -97,21 +98,29 @@ static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
 	if (ret)
 		goto done;
 
+	len = in_buf[1];
+	if (len > msg->insize) {
+		dev_err(ec_dev->dev, "packet too long (%d bytes, expected %d)",
+			len, msg->insize);
+		ret = -ENOSPC;
+		goto done;
+	}
+
 	/* copy response packet payload and compute checksum */
 	sum = in_buf[0] + in_buf[1];
-	for (i = 0; i < msg->insize; i++) {
+	for (i = 0; i < len; i++) {
 		msg->indata[i] = in_buf[2 + i];
 		sum += in_buf[2 + i];
 	}
 	dev_dbg(ec_dev->dev, "packet: %*ph, sum = %02x\n",
 		i2c_msg[1].len, in_buf, sum);
-	if (sum != in_buf[2 + msg->insize]) {
+	if (sum != in_buf[2 + len]) {
 		dev_err(ec_dev->dev, "bad packet checksum\n");
 		ret = -EBADMSG;
 		goto done;
 	}
 
-	ret = i2c_msg[1].buf[1];
+	ret = len;
  done:
 	kfree(in_buf);
 	kfree(out_buf);
-- 
2.0.0.526.g5318336

