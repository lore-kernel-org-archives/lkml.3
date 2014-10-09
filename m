Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbaJIJE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:04:28 -0400
Received: from mail-by2on0122.outbound.protection.outlook.com ([207.46.100.122]:2368
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755456AbaJIJDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:03:42 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <dp@opensource.wolfsonmicro.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 6/6] regmap: cache: Fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Thu, 9 Oct 2014 17:02:57 +0800
Message-ID: <1412845377-17134-7-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(87936001)(99396003)(120916001)(76482002)(21056001)(77156001)(89996001)(88136002)(19580395003)(104166001)(6806004)(68736004)(69596002)(85852003)(87286001)(19580405001)(84676001)(44976005)(64706001)(48376002)(50466002)(93916002)(86362001)(4396001)(50226001)(105606002)(26826002)(81156004)(106466001)(97736003)(36756003)(102836001)(80022003)(46102003)(62966002)(20776003)(47776003)(92726001)(92566001)(229853001)(107046002)(50986999)(85306004)(2351001)(110136001)(31966008)(95666004)(76176999)(104016003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0622;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0622;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When all the registers are volatile(unlikely, but logically and mostly
will happen for some 'device' who has very few registers), then the
count will be euqal to 0, then kmalloc() will return ZERO_SIZE_PTR,
which equals to ((void *)16).

So this patch fix this with just doing the zero check before calling
kmalloc(). If the count == 0, so we can make sure that all the registers
are volatile, so no cache is need.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regcache.c | 50 ++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index a06bcd2..f373c35 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -36,6 +36,23 @@ static int regcache_hw_init(struct regmap *map)
 	if (!map->num_reg_defaults_raw)
 		return -EINVAL;
 
+	/* calculate the size of reg_defaults */
+	for (count = 0, i = 0; i < map->num_reg_defaults_raw; i++)
+		if (!regmap_volatile(map, i * map->reg_stride))
+			count++;
+
+	/* all registers are volatile, so just bypass */
+	if (!count) {
+		map->cache_bypass = true;
+		return 0;
+	}
+
+	map->num_reg_defaults = count;
+	map->reg_defaults = kmalloc_array(count, sizeof(struct reg_default),
+					  GFP_KERNEL);
+	if (!map->reg_defaults)
+		return -ENOMEM;
+
 	if (!map->reg_defaults_raw) {
 		u32 cache_bypass = map->cache_bypass;
 		dev_warn(map->dev, "No cache defaults, reading back from HW\n");
@@ -43,33 +60,21 @@ static int regcache_hw_init(struct regmap *map)
 		/* Bypass the cache access till data read from HW*/
 		map->cache_bypass = 1;
 		tmp_buf = kmalloc(map->cache_size_raw, GFP_KERNEL);
-		if (!tmp_buf)
-			return -ENOMEM;
+		if (!tmp_buf) {
+			ret = -ENOMEM;
+			goto err_free;
+		}
 		ret = regmap_raw_read(map, 0, tmp_buf,
 				      map->num_reg_defaults_raw);
 		map->cache_bypass = cache_bypass;
-		if (ret < 0) {
-			kfree(tmp_buf);
-			return ret;
-		}
+		if (ret < 0)
+			goto err_cache_free;
+
 		map->reg_defaults_raw = tmp_buf;
 		map->cache_free = 1;
 	}
 
-	/* calculate the size of reg_defaults */
-	for (count = 0, i = 0; i < map->num_reg_defaults_raw; i++)
-		if (!regmap_volatile(map, i * map->reg_stride))
-			count++;
-
-	map->reg_defaults = kmalloc_array(count, sizeof(struct reg_default),
-					  GFP_KERNEL);
-	if (!map->reg_defaults) {
-		ret = -ENOMEM;
-		goto err_free;
-	}
-
 	/* fill the reg_defaults */
-	map->num_reg_defaults = count;
 	for (i = 0, j = 0; i < map->num_reg_defaults_raw; i++) {
 		if (regmap_volatile(map, i * map->reg_stride))
 			continue;
@@ -81,9 +86,10 @@ static int regcache_hw_init(struct regmap *map)
 
 	return 0;
 
+err_cache_free:
+	kfree(tmp_buf);
 err_free:
-	if (map->cache_free)
-		kfree(map->reg_defaults_raw);
+	kfree(map->reg_defaults);
 
 	return ret;
 }
@@ -147,6 +153,8 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 		ret = regcache_hw_init(map);
 		if (ret < 0)
 			return ret;
+		if (map->cache_bypass)
+			return 0;
 	}
 
 	if (!map->max_register)
-- 
2.1.0.27.g96db324

