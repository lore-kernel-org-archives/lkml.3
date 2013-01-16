Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3APNYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:24:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39676 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3APNYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:24:14 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] regmap: debugfs: Fix last entry store in the offset cache
Date: Wed, 16 Jan 2013 14:24:11 +0100
Message-Id: <1358342651-19690-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e8d6539c8a94b88fc7ca5d6bdd9eeb0e64b434e4
(regmap: debugfs: Make sure we store the last entry in the offset cache)
causes regmap_debugfs_get_dump_start to unconditionally return base if
the debugfs_off_cache is not empty when the function is called (because
c == NULL). This effectively causes all but the first read from
debugfs/regmap/*/registers to start from register position 0, which
in turn results in infinitely looping debugfs register map output.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/base/regmap/regmap-debugfs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 46a213a..b3369e6 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -114,15 +114,15 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 
 			p += map->debugfs_tot_len;
 		}
-	}
 
-	/* Close the last entry off if we didn't scan beyond it */
-	if (c) {
-		c->max = p - 1;
-		list_add_tail(&c->list,
-			      &map->debugfs_off_cache);
-	} else {
-		return base;
+		/* Close the last entry off if we didn't scan beyond it */
+		if (c) {
+			c->max = p - 1;
+			list_add_tail(&c->list,
+				      &map->debugfs_off_cache);
+		} else {
+			return base;
+		}
 	}
 
 	/*
-- 
1.7.10.4

