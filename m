Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaFMSOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:14:01 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:41621 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaFMSN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:13:57 -0400
From: Doug Anderson <dianders@chromium.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, broonie@kernel.org, sjg@chromium.org,
        olof@lixom.net, javier.martinez@collabora.co.uk, ch.naveen@samsung.com,
        swarren@wwwdotorg.org, khilman@linaro.org, ajaynumb@gmail.com,
        rahul.sharma@samsung.com, tushar.b@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: cros_ec: spi: Fix end of transfer on devices with no spi-msg-delay
Date: Fri, 13 Jun 2014 11:13:32 -0700
Message-Id: <1402683213-23120-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cros_ec_spi makes the assumption that a 0-length message will put the
spi chip select back to normal (non cs_toggle mode).  This used to be
the case back on kernel-3.8 on the spi-s3c64xx driver but doesn't
appear to be true anymore.  It seems like it was a pretty questionable
assumption to begin with, so let's fix the code to be more robust.  We
know that a message with a single 0-length segment _will_ put things
back in order.  Change cros_ec_spi to handle this.

This wasn't a problem on the main user of cros_ec_spi upstream (tegra)
because it specified 'google,cros-ec-spi-msg-delay'.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mfd/cros_ec_spi.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 0b8d328..0cbc3db 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -266,18 +266,14 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 		dev_err(ec_dev->dev, "spi transfer failed: %d\n", ret);
 	}
 
-	/* turn off CS */
+	/*
+	 * Turn off CS, possibly adding a delay to ensure the rising edge
+	 * doesn't come too soon after the end of the data.
+	 */
 	spi_message_init(&msg);
-
-	if (ec_spi->end_of_msg_delay) {
-		/*
-		 * Add delay for last transaction, to ensure the rising edge
-		 * doesn't come too soon after the end of the data.
-		 */
-		memset(&trans, 0, sizeof(trans));
-		trans.delay_usecs = ec_spi->end_of_msg_delay;
-		spi_message_add_tail(&trans, &msg);
-	}
+	memset(&trans, 0, sizeof(trans));
+	trans.delay_usecs = ec_spi->end_of_msg_delay;
+	spi_message_add_tail(&trans, &msg);
 
 	final_ret = spi_sync(ec_spi->spi, &msg);
 	ktime_get_ts(&ts);
-- 
2.0.0.526.g5318336

