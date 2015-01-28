Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbbA1EN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:13:28 -0500
Received: from mail.kernel.org ([198.145.29.136]:36609 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759122AbbA1EN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:13:26 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 02/91] regmap: Fix handling of volatile registers for format_write() chips
Date: Wed, 28 Jan 2015 12:06:11 +0800
Message-Id: <1422418236-12852-4-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index ca72d1f..e554542 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -48,7 +48,7 @@ bool regmap_readable(struct regmap *map, unsigned int reg)
 
 bool regmap_volatile(struct regmap *map, unsigned int reg)
 {
-	if (!regmap_readable(map, reg))
+	if (!map->format.format_write && !regmap_readable(map, reg))
 		return false;
 
 	if (map->volatile_reg)
-- 
1.9.1

