Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaH1XoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:44:09 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61292 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaH1XoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:44:06 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>, Addy Ke <addy.ke@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>
Cc: "Jeffy.Chen" <jeffy.chen@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, amstan@chromium.org,
        Doug Anderson <dianders@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] spi/rockchip: Avoid accidentally turning off the clock
Date: Thu, 28 Aug 2014 16:43:48 -0700
Message-Id: <1409269428-24680-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If our client is requesting a clock that is above the maximum clock
then the following division will result in 0:
  rs->max_freq / rs->speed

We'll then program 0 into the SPI_BAUDR register.  The Rockchip TRM
says: "If the value is 0, the serial output clock (sclk_out) is
disabled."

It's much better to end up with the fastest possible clock rather than
a clock that is off, so enforce a minimum value.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/spi/spi-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 6321326..cd0e08b0 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -499,7 +499,7 @@ static void rockchip_spi_config(struct rockchip_spi *rs)
 	}
 
 	/* div doesn't support odd number */
-	div = rs->max_freq / rs->speed;
+	div = max_t(u32, rs->max_freq / rs->speed, 1);
 	div = (div + 1) & 0xfffe;
 
 	spi_enable_chip(rs, 0);
-- 
2.1.0.rc2.206.gedb03e5

