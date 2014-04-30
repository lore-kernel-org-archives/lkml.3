Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbaD3RqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:46:10 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41524 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259AbaD3Rof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:44:35 -0400
From: Doug Anderson <dianders@chromium.org>
To: lee.jones@linaro.org, swarren@nvidia.com, wsa@the-dreams.de
Cc: abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/7] mfd: cros_ec: spi: Add mutex to cros_ec_spi
Date: Wed, 30 Apr 2014 10:44:05 -0700
Message-Id: <1398879850-9111-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1398879850-9111-1-git-send-email-dianders@chromium.org>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main transfer function for cros_ec_spi can be called by more than
one client at a time.  Make sure that those clients don't stomp on
each other by locking the bus for the duration of the transfer
function.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Simon Glass <sjg@chromium.org>
Tested-by: Andrew Bresticker <abrestic@chromium.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v3: None
Changes in v2: None

 drivers/mfd/cros_ec_spi.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index c185eb6..a2a605d 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -65,11 +65,13 @@
  *	if no record
  * @end_of_msg_delay: used to set the delay_usecs on the spi_transfer that
  *      is sent when we want to turn off CS at the end of a transaction.
+ * @lock: mutex to ensure only one user of cros_ec_command_spi_xfer at a time
  */
 struct cros_ec_spi {
 	struct spi_device *spi;
 	s64 last_transfer_ns;
 	unsigned int end_of_msg_delay;
+	struct mutex lock;
 };
 
 static void debug_packet(struct device *dev, const char *name, u8 *ptr,
@@ -208,6 +210,13 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 	int ret = 0, final_ret;
 	struct timespec ts;
 
+	/*
+	 * We have the shared ec_dev buffer plus we do lots of separate spi_sync
+	 * calls, so we need to make sure only one person is using this at a
+	 * time.
+	 */
+	mutex_lock(&ec_spi->lock);
+
 	len = cros_ec_prepare_tx(ec_dev, ec_msg);
 	dev_dbg(ec_dev->dev, "prepared, len=%d\n", len);
 
@@ -260,7 +269,7 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 		ret = final_ret;
 	if (ret < 0) {
 		dev_err(ec_dev->dev, "spi transfer failed: %d\n", ret);
-		return ret;
+		goto exit;
 	}
 
 	/* check response error code */
@@ -269,14 +278,16 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 		dev_warn(ec_dev->dev, "command 0x%02x returned an error %d\n",
 			 ec_msg->cmd, ptr[0]);
 		debug_packet(ec_dev->dev, "in_err", ptr, len);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto exit;
 	}
 	len = ptr[1];
 	sum = ptr[0] + ptr[1];
 	if (len > ec_msg->in_len) {
 		dev_err(ec_dev->dev, "packet too long (%d bytes, expected %d)",
 			len, ec_msg->in_len);
-		return -ENOSPC;
+		ret = -ENOSPC;
+		goto exit;
 	}
 
 	/* copy response packet payload and compute checksum */
@@ -293,10 +304,14 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 		dev_err(ec_dev->dev,
 			"bad packet checksum, expected %02x, got %02x\n",
 			sum, ptr[len + 2]);
-		return -EBADMSG;
+		ret = -EBADMSG;
+		goto exit;
 	}
 
-	return 0;
+	ret = 0;
+exit:
+	mutex_unlock(&ec_spi->lock);
+	return ret;
 }
 
 static void cros_ec_spi_dt_probe(struct cros_ec_spi *ec_spi, struct device *dev)
@@ -327,6 +342,7 @@ static int cros_ec_spi_probe(struct spi_device *spi)
 	if (ec_spi == NULL)
 		return -ENOMEM;
 	ec_spi->spi = spi;
+	mutex_init(&ec_spi->lock);
 	ec_dev = devm_kzalloc(dev, sizeof(*ec_dev), GFP_KERNEL);
 	if (!ec_dev)
 		return -ENOMEM;
-- 
1.9.1.423.g4596e3a

