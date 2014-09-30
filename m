Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaI3Vpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:45:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32893 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaI3Vi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 081/103] regmap: Fix handling of volatile registers for format_write() chips
Date: Tue, 30 Sep 2014 14:31:26 -0700
Message-Id: <1412112708-27356-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 5844a8b9d98ec11ce1d77610daacf3f0a0e14715 upstream.

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
Tested-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c2e0021..f8214ec 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -105,7 +105,7 @@ bool regmap_readable(struct regmap *map, unsigned int reg)
 
 bool regmap_volatile(struct regmap *map, unsigned int reg)
 {
-	if (!regmap_readable(map, reg))
+	if (!map->format.format_write && !regmap_readable(map, reg))
 		return false;
 
 	if (map->volatile_reg)
-- 
1.9.1

