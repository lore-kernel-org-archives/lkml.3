Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaICUoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:44:46 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40377 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaICUon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:44:43 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>, Addy Ke <addy.ke@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>
Cc: Alexandru Stan <amstan@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] spi/rockchip: Fix the wait_for_idle() timeout
Date: Wed,  3 Sep 2014 13:44:25 -0700
Message-Id: <1409777067-17422-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409777067-17422-1-git-send-email-dianders@chromium.org>
References: <1409777067-17422-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wait_for_idle() could get unlucky and timeout too quickly.
Specifically, the old calculation was effectively:
  timeout = jiffies + 1;
  if (jiffies >= timeout) print warning;

>From the above it should be obvious that if jiffies ticks in just the
wrong place then we'll have an effective timeout of 0.

Fix this by effectively changing the above ">=" to a ">".  That gives
us an extra jiffy to finish.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/spi/spi-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index cd0e08b0..84dbb86 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -220,7 +220,7 @@ static inline void wait_for_idle(struct rockchip_spi *rs)
 	do {
 		if (!(readl_relaxed(rs->regs + ROCKCHIP_SPI_SR) & SR_BUSY))
 			return;
-	} while (time_before(jiffies, timeout));
+	} while (!time_after(jiffies, timeout));
 
 	dev_warn(rs->dev, "spi controller is in busy state!\n");
 }
-- 
2.1.0.rc2.206.gedb03e5

