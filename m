Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3LLXNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:13:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50281 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3LLXND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:13:03 -0500
Message-ID: <52AA42FD.4040503@codeaurora.org>
Date: Thu, 12 Dec 2013 15:13:01 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/8] regmap: Add support for using regmap over ssbi
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org> <1386718523-2587-4-git-send-email-sboyd@codeaurora.org> <20131210235000.GK11468@sirena.org.uk> <52A7AE1B.3040201@codeaurora.org> <20131211005106.GL11468@sirena.org.uk> <52A7C0C3.2070805@codeaurora.org> <20131211132729.GT11468@sirena.org.uk>
In-Reply-To: <20131211132729.GT11468@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 05:27, Mark Brown wrote:
> On Tue, Dec 10, 2013 at 05:32:51PM -0800, Stephen Boyd wrote:
>
>> Are you suggesting we implement the reg_read/reg_write as global helpers
>> that the config points to and then call regmap_init()? At a quick glance
> Yes, assuming your bus really is limited in the way it seems from the
> code.

Ok, I'm happy to go the reg_read/reg_write way if we can have the
bulk_read and bulk_write operations work. I was trying to mimic the
regmap_mmio code because it seems to do the same things with respect to
bulk operations. Or perhaps this code should live in drivers/mfd/ssbi.c
and then we could return an error from the regmap_init call if
use_single_rw is false?

>
>> it looks like we lose out on regmap_bulk_read() if we do that. There is
>> one driver that will use regmap_bulk_read(), but I suppose we can just
> bulk_read() should decay to individual reads if there isn't a block
> operaton and it's not like the hardware actually supports bulk reads
> anyway.

So regmap_bulk_read() should work if I don't have a map->bus? To make it
work with reg_read/write I had to do this. I'm not sure how to make
bulk_write work.

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 9c021d9..1ccd61b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1897,14 +1897,10 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
        size_t val_bytes = map->format.val_bytes;
        bool vol = regmap_volatile_range(map, reg, val_count);
 
-       if (!map->bus)
-               return -EINVAL;
-       if (!map->format.parse_inplace)
-               return -EINVAL;
        if (reg % map->reg_stride)
                return -EINVAL;
 
-       if (vol || map->cache_type == REGCACHE_NONE) {
+       if (map->bus && map->format.parse_inplace && (vol || map->cache_type == REGCACHE_NONE)) {
                /*
                 * Some devices does not support bulk read, for
                 * them we have a series of single read operations.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

