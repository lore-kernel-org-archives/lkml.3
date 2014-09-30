Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaI3QHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:07:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52277 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaI3QHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:07:06 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <broonie@kernel.org>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH] regmap: Allow read_reg_mask to be 0
Date: Tue, 30 Sep 2014 11:07:00 -0500
Message-ID: <1412093220-24690-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be spi devices that do not require a
register read mask to read the registers.

Currently the code sets the read mask based on
a non-zero value passed in from the driver or if that
value is 0 sets the read mask to 0x80.

A mask of 0 is a valid mask as well.  Create a define
to indicate that the read mask can be zero and separate
out the read flag mask and the write flag mask.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/base/regmap/regmap.c |   11 +++++++----
 include/linux/regmap.h       |    2 ++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 78f43fb..8c0a9b8 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -528,12 +528,15 @@ struct regmap *regmap_init(struct device *dev,
 	INIT_LIST_HEAD(&map->async_free);
 	init_waitqueue_head(&map->async_waitq);
 
-	if (config->read_flag_mask || config->write_flag_mask) {
+	if (config->read_flag_mask == REGMAP_NO_READ_MASK)
+		map->read_flag_mask = 0x00;
+	else if (config->read_flag_mask)
 		map->read_flag_mask = config->read_flag_mask;
-		map->write_flag_mask = config->write_flag_mask;
-	} else if (bus) {
+	else if (bus)
 		map->read_flag_mask = bus->read_flag_mask;
-	}
+
+	if (config->write_flag_mask)
+		map->write_flag_mask = config->write_flag_mask;
 
 	if (!bus) {
 		map->reg_read  = config->reg_read;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index c5ed83f..f1cdfe5 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -18,6 +18,8 @@
 #include <linux/err.h>
 #include <linux/bug.h>
 
+#define REGMAP_NO_READ_MASK		0xff
+
 struct module;
 struct device;
 struct i2c_client;
-- 
1.7.9.5

