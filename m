Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3LMROL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:14:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54298 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3LMROJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:14:09 -0500
Date: Fri, 13 Dec 2013 09:14:07 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] regmap: Allow regmap_bulk_read() to work for "no-bus"
 regmaps
Message-ID: <20131213171407.GN21983@codeaurora.org>
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

regmap_bulk_read() should decay to performing individual reads if
we're using a "no-bus" regmap. Unfortunately, it returns an
error because there is no map->bus pointer. Fix it.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

On 12/13/13 02:41, Mark Brown wrote:
> On Thu, Dec 12, 2013 at 03:13:01PM -0800, Stephen Boyd wrote:
>
>>> bulk_read() should decay to individual reads if there isn't a block
>>> operaton and it's not like the hardware actually supports bulk reads
>>> anyway.
>
>> So regmap_bulk_read() should work if I don't have a map->bus? To make it
>> work with reg_read/write I had to do this. I'm not sure how to make
>> bulk_write work.
>
> Yes, I'd expect the operation to work.  Your changes below are mostly
> fine (we should add an additional check for values that aren't integer
> numbers of bytes, I can add that) - can you send as a signed off patch
> please and I'll apply?

Here you go. Do you have any suggestions on how to make regmap_bulk_write()
work?

 drivers/base/regmap/regmap.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 9c021d9..1ccd61b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1897,14 +1897,10 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 	size_t val_bytes = map->format.val_bytes;
 	bool vol = regmap_volatile_range(map, reg, val_count);
 
-	if (!map->bus)
-		return -EINVAL;
-	if (!map->format.parse_inplace)
-		return -EINVAL;
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	if (vol || map->cache_type == REGCACHE_NONE) {
+	if (map->bus && map->format.parse_inplace && (vol || map->cache_type == REGCACHE_NONE)) {
 		/*
 		 * Some devices does not support bulk read, for
 		 * them we have a series of single read operations.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

