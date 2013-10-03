Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3JCMl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:41:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60049 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257Ab3JCMl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:41:26 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH v2] mfd: arizona: Correct handling of device tree gpio defaults
Date: Thu,  3 Oct 2013 13:30:04 +0100
Message-Id: <1380803404-2764-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When settings the gpio defaults from data contained in device tree
all values that fit in 16-bits should be treated literally, any
value greater than 16-bits should cause the chips default to be used
for that gpio pin. A zero value in the gpio default array in pdata
represents that we should leave the default set.

The current code will write zero to the gpio config for all values
greater than 16-bits. Note that this is setting the gpio default to
0x10000, as only the bottom 16-bits will be written to the device, and
zero is treated as don't write anything use chip defaults.

This patch ensure that we handle the gpio default as either an out of
range value or a zero value rather than both one after the other.

Reported-by: Heather Lomond <heather.lomond@wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

Hi,

Added a bit more explanation I hope this is a little clearer.

Thanks,
Charles

 drivers/mfd/arizona-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 5ac3aa4..e13355b 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -540,7 +540,7 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 		for (i = 0; i < ARRAY_SIZE(arizona->pdata.gpio_defaults); i++) {
 			if (arizona->pdata.gpio_defaults[i] > 0xffff)
 				arizona->pdata.gpio_defaults[i] = 0;
-			if (arizona->pdata.gpio_defaults[i] == 0)
+			else if (arizona->pdata.gpio_defaults[i] == 0)
 				arizona->pdata.gpio_defaults[i] = 0x10000;
 		}
 	} else {
-- 
1.7.2.5

