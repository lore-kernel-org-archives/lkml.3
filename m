Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaAIFlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:41:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16686 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaAIFk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:40:56 -0500
Date: Thu, 9 Jan 2014 08:41:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] regmap: fix a potential leak in regmap_bulk_write()
Message-ID: <20140109054104.GH1265@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static checkers complain that there is an error path where
_regmap_raw_write() fails and we goto out without freeing the "wval"
buffer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 062f59860091..939f9b26d5ee 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1514,7 +1514,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 {
 	int ret = 0, i;
 	size_t val_bytes = map->format.val_bytes;
-	void *wval;
+	void *wval = NULL;
 
 	if (!map->bus)
 		return -EINVAL;
@@ -1555,10 +1555,10 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count);
 	}
 
-	if (val_bytes != 1)
-		kfree(wval);
 
 out:
+	if (val_bytes != 1)
+		kfree(wval);
 	map->unlock(map->lock_arg);
 	return ret;
 }
