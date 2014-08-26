Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbaHZLY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:24:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33950 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534AbaHZLYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:24:25 -0400
From: Mark Brown <broonie@kernel.org>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Tue, 26 Aug 2014 12:24:15 +0100
Message-Id: <1409052255-10601-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.0.rc1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: Fix handling of volatile registers for format_write() chips
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

A previous over-zealous factorisation of code means that we only treat
registers as volatile if they are readable. For most devices this is fine
since normally most registers can be read and volatility implies
readability but for format_write() devices where there is no readback from
the hardware and we use volatility to mean simply uncacheability this means
that we end up treating all registers as cacheble.

A bigger refactoring of the code to clarify this is in order but as a fix
make a minimal change and only check readability when checking volatility
if there is no format_write() operation defined for the device.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bb4502a48be5..44c2df8284d7 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -110,7 +110,7 @@ bool regmap_readable(struct regmap *map, unsigned int reg)
 
 bool regmap_volatile(struct regmap *map, unsigned int reg)
 {
-	if (!regmap_readable(map, reg))
+	if (!map->format.format_write && !regmap_readable(map, reg))
 		return false;
 
 	if (map->volatile_reg)
-- 
2.1.0.rc1

