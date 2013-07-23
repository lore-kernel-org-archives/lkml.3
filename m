Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3GWKQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:16:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39848 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3GWKQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:16:05 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC] regmap: core: allow a virtual range to cover its own data window
Date: Tue, 23 Jul 2013 12:16:02 +0200
Message-Id: <1374574562-29453-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see no reason why a virtual range shouldn't be allowed to cover its
own data window if the page selection register is in the same place
on every page.
For chips which use paged access for all of their registers, but only
when connected via I2C, and which can access the whole register space
directly when connected via SPI, this allows to avoid acrobatics with
the register ranges by simply mapping the I2C ranges over the data
window beginning at 0x0, and then using linear access for the SPI
variant.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

---
I am looking at DA9063, which could use the following range
configuration for the I2C variant:

	struct regmap_range_cfg da9063_i2c_regmap_ranges[] = {
		{
			.range_min = 0x00,
			.range_max = 0x1ff,
			.selector_reg = 0x00,
			.selector_mask = 0x03,
			.selector_shift = 1,
			.window_start = 0x00,
			.window_len = 0x100,
		},
	};

	/* no da9063_spi_regmap_ranges needed */
---
 drivers/base/regmap/regmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 9592058..1205d8c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -687,6 +687,10 @@ skip_format_initialization:
 			unsigned win_max = win_min +
 					   config->ranges[j].window_len - 1;
 
+			/* Allow data window inside its own virtual range */
+			if (j == i)
+				continue;
+
 			if (range_cfg->range_min <= sel_reg &&
 			    sel_reg <= range_cfg->range_max) {
 				dev_err(map->dev,
-- 
1.8.3.2

