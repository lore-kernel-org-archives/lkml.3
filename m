Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaF1NXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:23:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50249 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaF1NXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:23:24 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Markus Pargmann <mpa@pengutronix.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Fix debugfs-file 'registers' mode
Date: Sat, 28 Jun 2014 15:23:11 +0200
Message-Id: <1403961791-15376-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro "REGMAP_ALLOW_WRITE_DEBUGFS" can be used to enable write
support on the registers file in the debugfs. The mode of the file is
fixed to 0400 so it is not possible to write the file ever.

This patch fixes the mode by setting it to the correct value depending
on the macro.

Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---

Hi,

as the kconfig option will probably not be merged, I extracted the mode fix of
my previous patch.

Regards,

Markus

 drivers/base/regmap/regmap-debugfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 45d812c0ea77..f45a0a0e0371 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -512,7 +512,14 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 			    map, &regmap_reg_ranges_fops);
 
 	if (map->max_register || regmap_readable(map, 0)) {
-		debugfs_create_file("registers", 0400, map->debugfs,
+		unsigned int registers_mode;
+
+		if (IS_ENABLED(REGMAP_ALLOW_WRITE_DEBUGFS))
+			registers_mode = 0600;
+		else
+			registers_mode = 0400;
+
+		debugfs_create_file("registers", registers_mode, map->debugfs,
 				    map, &regmap_map_fops);
 		debugfs_create_file("access", 0400, map->debugfs,
 				    map, &regmap_access_fops);
-- 
2.0.0

