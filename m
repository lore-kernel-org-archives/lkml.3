Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaF0T6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:58:12 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:40591 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaF0T4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:56:46 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Mark Brown <broonie@kernel.org>
Cc: Vincent Palatin <vpalatin@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Randall Spangler <rspangler@chromium.org>, sjg@chromium.org,
        afaerber@suse.de, stephan@synkhronix.com, olof@lixom.net,
        Doug Anderson <dianders@chromium.org>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] regmap: cache: regcache_hw_init() should use regmap_bulk_read()
Date: Fri, 27 Jun 2014 12:56:11 -0700
Message-Id: <1403898973-19571-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403898973-19571-1-git-send-email-dianders@chromium.org>
References: <1403898973-19571-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We really should be using regmap_bulk_read() in regcache_hw_init().
The regmap_bulk_read() will translate into regmap_raw_read() when
appropriate.  Doing this fixes problems where regmap_smbus() will
crash because they don't implement .read and .write.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/base/regmap/regcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 29b4128..6447486 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -45,7 +45,7 @@ static int regcache_hw_init(struct regmap *map)
 		tmp_buf = kmalloc(map->cache_size_raw, GFP_KERNEL);
 		if (!tmp_buf)
 			return -EINVAL;
-		ret = regmap_raw_read(map, 0, tmp_buf,
+		ret = regmap_bulk_read(map, 0, tmp_buf,
 				      map->num_reg_defaults_raw);
 		map->cache_bypass = cache_bypass;
 		if (ret < 0) {
-- 
2.0.0.526.g5318336

