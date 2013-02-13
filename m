Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046Ab3BMT1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:27:42 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:56979 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab3BMT0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:26:53 -0500
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com, broonie@opensource.wolfsonmicro.com
Subject: [PATCH V2 3/5] spi: s3c64xx: Added provision for non-gpio i/o's
Date: Wed, 13 Feb 2013 11:25:29 -0800
Message-Id: <1360783531-32654-4-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360783531-32654-1-git-send-email-ks.giri@samsung.com>
References: <1360783531-32654-1-git-send-email-ks.giri@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the drivers supports only the GPIO based i/o pins.
But there are Exynos SoC's that use the same controller with
dedicated i/o pins.

This patch  provides provision to support gpio/dedicated pins.
The decision is made by parsing the "gpios" property in the spi
node.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
changes in v2:
		Removed the gpio quirk. Parse the "gpios" property
		to decide whether  gpio / dedicated i/o lines should
		be used.

 drivers/spi/spi-s3c64xx.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 45bad5d..a8fe876 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1157,6 +1157,9 @@ static int s3c64xx_spi_parse_dt_gpio(struct s3c64xx_spi_driver_data *sdd)
 	struct device *dev = &sdd->pdev->dev;
 	int idx, gpio, ret;
 
+	if (!of_find_property(dev->of_node, "gpios", NULL))
+		return 0;
+
 	/* find gpios for mosi, miso and clock lines */
 	for (idx = 0; idx < 3; idx++) {
 		gpio = of_get_gpio(dev->of_node, idx);
@@ -1183,6 +1186,11 @@ free_gpio:
 static void s3c64xx_spi_dt_gpio_free(struct s3c64xx_spi_driver_data *sdd)
 {
 	unsigned int idx;
+	struct device *dev = &sdd->pdev->dev;
+
+	if (!of_find_property(dev->of_node, "gpios", NULL))
+		return;
+
 	for (idx = 0; idx < 3; idx++)
 		gpio_free(sdd->gpios[idx]);
 }
-- 
1.7.10.4

