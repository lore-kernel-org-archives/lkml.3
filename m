Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaCQBsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:48:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36631 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaCQBsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:48:01 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-spi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, Axel Lin <axel.lin@ingics.com>
Subject: [PATCH] spi: sc18is602: Don't be that restrictive with the maximum transfer speed
Date: Sun, 16 Mar 2014 18:47:50 -0700
Message-Id: <1395020870-18107-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 09e99bca8 (spi: sc18is602: Convert to let spi core validate
transfer speed) made the maximum transfer speed much more restrictive
than before. The transfer speed used to be adjusted to 1/4 of the chip
clock rate if a higher transfer speed was requested. Now such transfers are
simply rejected. With default settings, this causes, for example, a transfer
request at 2 mbps to be rejected because the maximum speed with the default
chip clock is 1.843 mbps.

This is unnecessarily restrictive and causes unnecessary failures. Loosen
the limit to accept transfers up to 50% of the clock rate and adjust
the speed as needed when setting up the actualt transfer.

Cc: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
This patch applies to the tip of linux-next.

 drivers/spi/spi-sc18is602.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sc18is602.c b/drivers/spi/spi-sc18is602.c
index 237f2e7..f0e55aa 100644
--- a/drivers/spi/spi-sc18is602.c
+++ b/drivers/spi/spi-sc18is602.c
@@ -297,7 +297,7 @@ static int sc18is602_probe(struct i2c_client *client,
 	master->transfer_one_message = sc18is602_transfer_one;
 	master->dev.of_node = np;
 	master->min_speed_hz = hw->freq / 128;
-	master->max_speed_hz = hw->freq / 4;
+	master->max_speed_hz = hw->freq / 2;
 
 	error = devm_spi_register_master(dev, master);
 	if (error)
-- 
1.7.9.7

