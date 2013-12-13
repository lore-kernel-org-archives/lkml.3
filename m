Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab3LMVhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:37:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42078 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3LMVhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:37:09 -0500
Date: Fri, 13 Dec 2013 13:37:07 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/8] regmap: Add support for using regmap over ssbi
Message-ID: <20131213213707.GO21983@codeaurora.org>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-4-git-send-email-sboyd@codeaurora.org>
 <20131210235000.GK11468@sirena.org.uk>
 <52A7AE1B.3040201@codeaurora.org>
 <20131211005106.GL11468@sirena.org.uk>
 <52A7C0C3.2070805@codeaurora.org>
 <20131211132729.GT11468@sirena.org.uk>
 <52AA42FD.4040503@codeaurora.org>
 <20131213104128.GT11044@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213104128.GT11044@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Mark Brown wrote:
> On Thu, Dec 12, 2013 at 03:13:01PM -0800, Stephen Boyd wrote:
> 
> > > bulk_read() should decay to individual reads if there isn't a block
> > > operaton and it's not like the hardware actually supports bulk reads
> > > anyway.
> 
> > So regmap_bulk_read() should work if I don't have a map->bus? To make it
> > work with reg_read/write I had to do this. I'm not sure how to make
> > bulk_write work.

I came up with this (possibly ugly) patch. It works for my
specific case but I'm not sure if unpacking the val bits into an
unsigned int and passing that to _regmap_write() is sane. What do
you think?

---8<----
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 1ccd61b..333c059 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1514,11 +1514,9 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 {
 	int ret = 0, i;
 	size_t val_bytes = map->format.val_bytes;
-	void *wval;
+	void *wval = NULL;
 
-	if (!map->bus)
-		return -EINVAL;
-	if (!map->format.parse_inplace)
+	if (map->bus && !map->format.parse_inplace)
 		return -EINVAL;
 	if (reg % map->reg_stride)
 		return -EINVAL;
@@ -1528,7 +1526,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	/* No formatting is require if val_byte is 1 */
 	if (val_bytes == 1) {
 		wval = (void *)val;
-	} else {
+	} else if (map->bus) {
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
 			ret = -ENOMEM;
@@ -1538,24 +1536,37 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		for (i = 0; i < val_count * val_bytes; i += val_bytes)
 			map->format.parse_inplace(wval + i);
 	}
-	/*
-	 * Some devices does not support bulk write, for
-	 * them we have a series of single write operations.
-	 */
-	if (map->use_single_rw) {
-		for (i = 0; i < val_count; i++) {
-			ret = _regmap_raw_write(map,
+
+	if (map->bus) {
+		/*
+		 * Some devices does not support bulk write, for
+		 * them we have a series of single write operations.
+		 */
+		if (map->use_single_rw) {
+			for (i = 0; i < val_count; i++) {
+				ret = _regmap_raw_write(map,
 						reg + (i * map->reg_stride),
 						val + (i * val_bytes),
 						val_bytes);
-			if (ret != 0)
-				return ret;
+				if (ret != 0)
+					return ret;
+			}
+		} else {
+			ret = _regmap_raw_write(map, reg, wval,
+						val_bytes * val_count);
 		}
 	} else {
-		ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count);
+		for (i = 0; i < val_count; i++) {
+			unsigned int ival;
+			ival = *(unsigned int *)(val + (i * val_bytes));
+			ret = _regmap_write(map, reg + (i * map->reg_stride),
+					ival);
+			if (ret != 0)
+				goto out;
+		}
 	}
 
-	if (val_bytes != 1)
+	if (val_bytes != 1 && map->bus)
 		kfree(wval);
 
 out:

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
