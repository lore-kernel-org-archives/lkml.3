Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaIAO2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:28:40 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:60492 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaIAO2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:28:38 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        linux-sunxi@googlegroups.com, stable@vger.kernel.org
Subject: [PATCH v2] i2c: mv64xxx: continue probe when clock-frequency is missing
Date: Mon,  1 Sep 2014 22:28:13 +0800
Message-Id: <1409581693-15943-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "clock-frequency" DT property is listed as optional, However,
the current code stores the return value of of_property_read_u32 in
the return code of mv64xxx_of_config, but then forgets to clear it
after setting the default value of "clock-frequency". It is then
passed out to the main probe function, resulting in a probe failure
when "clock-frequency" is missing.

This patch checks and then throws away the return value of
of_property_read_u32, instead of storing it and having to clear it
afterwards.

This issue was discovered after the property was removed from all
sunxi DTs.

Fixes: 4c730a06c19bb ("i2c: mv64xxx: Set bus frequency to 100kHz if clock-frequency is not provided")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Cc: stable@vger.kernel.org
Acked-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
Changes in v2:

 - Added Fixes tag, and Acked-bys from Andrew and Maxime.
 - Slightly refined commit message to be clear what we're throwing away.
---
 drivers/i2c/busses/i2c-mv64xxx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 6dc5ded..2f64273 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -746,8 +746,7 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 	}
 	tclk = clk_get_rate(drv_data->clk);
 
-	rc = of_property_read_u32(np, "clock-frequency", &bus_freq);
-	if (rc)
+	if (of_property_read_u32(np, "clock-frequency", &bus_freq))
 		bus_freq = 100000; /* 100kHz by default */
 
 	if (!mv64xxx_find_baud_factors(bus_freq, tclk,
-- 
2.1.0

