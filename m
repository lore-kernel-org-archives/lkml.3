Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3LQCau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:30:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35373 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3LQCas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:30:48 -0500
Date: Mon, 16 Dec 2013 18:30:47 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] regmap: Allow regmap_bulk_write() to work for "no-bus"
 regmaps
Message-ID: <20131217023047.GC31766@codeaurora.org>
References: <1386718523-2587-4-git-send-email-sboyd@codeaurora.org>
 <20131210235000.GK11468@sirena.org.uk>
 <52A7AE1B.3040201@codeaurora.org>
 <20131211005106.GL11468@sirena.org.uk>
 <52A7C0C3.2070805@codeaurora.org>
 <20131211132729.GT11468@sirena.org.uk>
 <52AA42FD.4040503@codeaurora.org>
 <20131213104128.GT11044@sirena.org.uk>
 <20131213213707.GO21983@codeaurora.org>
 <20131216210153.GA3185@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216210153.GA3185@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap_bulk_write() should decay to performing individual writes
if we're using a "no-bus" regmap. Unfortunately, it returns an
error because there is no map->bus pointer. Fix it.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

On 12/16, Mark Brown wrote:
> On Fri, Dec 13, 2013 at 01:37:07PM -0800, Stephen Boyd wrote:
> 
> > I came up with this (possibly ugly) patch. It works for my
> > specific case but I'm not sure if unpacking the val bits into an
> > unsigned int and passing that to _regmap_write() is sane. What do
> > you think?
> 
> It's not lovely but it's about as good as it gets.  I'd probaly just
> drop the raw single write case so it's simpler - just either raw write
> the lot or write a register at a time with unpacking (and so refactor
> the the loop that does the in place formatting into the raw case only
> and not bother for the single write).

Ok how about this?

 drivers/base/regmap/regmap.c | 43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 1ccd61b..12b80f6 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1514,21 +1514,30 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 {
 	int ret = 0, i;
 	size_t val_bytes = map->format.val_bytes;
-	void *wval;
 
-	if (!map->bus)
-		return -EINVAL;
-	if (!map->format.parse_inplace)
+	if (map->bus && !map->format.parse_inplace)
 		return -EINVAL;
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
 	map->lock(map->lock_arg);
+	/*
+	 * Some devices don't support bulk write, for
+	 * them we have a series of single write operations.
+	 */
+	if (!map->bus || map->use_single_rw) {
+		for (i = 0; i < val_count; i++) {
+			unsigned int ival;
 
-	/* No formatting is require if val_byte is 1 */
-	if (val_bytes == 1) {
-		wval = (void *)val;
+			ival = *(unsigned int *)(val + (i * val_bytes));
+			ret = _regmap_write(map, reg + (i * map->reg_stride),
+					ival);
+			if (ret != 0)
+				goto out;
+		}
 	} else {
+		void *wval;
+
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
 			ret = -ENOMEM;
@@ -1537,27 +1546,11 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		}
 		for (i = 0; i < val_count * val_bytes; i += val_bytes)
 			map->format.parse_inplace(wval + i);
-	}
-	/*
-	 * Some devices does not support bulk write, for
-	 * them we have a series of single write operations.
-	 */
-	if (map->use_single_rw) {
-		for (i = 0; i < val_count; i++) {
-			ret = _regmap_raw_write(map,
-						reg + (i * map->reg_stride),
-						val + (i * val_bytes),
-						val_bytes);
-			if (ret != 0)
-				return ret;
-		}
-	} else {
+
 		ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count);
-	}
 
-	if (val_bytes != 1)
 		kfree(wval);
-
+	}
 out:
 	map->unlock(map->lock_arg);
 	return ret;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
