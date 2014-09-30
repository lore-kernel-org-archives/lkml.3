Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaI3Vj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:39:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32991 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaI3VjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen-Yu Tsai <wens@csie.org>, Wolfram Sang <wsa@the-dreams.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 098/103] i2c: mv64xxx: continue probe when clock-frequency is missing
Date: Tue, 30 Sep 2014 14:31:43 -0700
Message-Id: <1412112708-27356-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

commit 0ce4bc1dbdd911ae1763e2d4ff36bd1b214a59f7 upstream.

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
Acked-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index d52d849..cf89175 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -748,8 +748,7 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 	}
 	tclk = clk_get_rate(drv_data->clk);
 
-	rc = of_property_read_u32(np, "clock-frequency", &bus_freq);
-	if (rc)
+	if (of_property_read_u32(np, "clock-frequency", &bus_freq))
 		bus_freq = 100000; /* 100kHz by default */
 
 	if (!mv64xxx_find_baud_factors(bus_freq, tclk,
-- 
1.9.1

