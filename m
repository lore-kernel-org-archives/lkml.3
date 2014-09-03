Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbaICUpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:45:05 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34620 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbaICUop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:44:45 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>, Addy Ke <addy.ke@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>
Cc: Alexandru Stan <amstan@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] spi/rockchip: Don't warn if SPI is busy but disabled
Date: Wed,  3 Sep 2014 13:44:26 -0700
Message-Id: <1409777067-17422-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409777067-17422-1-git-send-email-dianders@chromium.org>
References: <1409777067-17422-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reference manual from Rockchip claims this about the BSF (SPI Busy
Flag):
* 0 - SPI is idle or disabled
* 1 - SPI is actively transferring data

The above doesn't quite appear to be true.  Specifically I found the
busy bit set when SPI was disabled.  Let's change the WARN_ON() so we
only check the busy bit if the controller was enabled.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/spi/spi-rockchip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 84dbb86..3afc266 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -529,7 +529,8 @@ static int rockchip_spi_transfer_one(
 	int ret = 0;
 	struct rockchip_spi *rs = spi_master_get_devdata(master);
 
-	WARN_ON((readl_relaxed(rs->regs + ROCKCHIP_SPI_SR) & SR_BUSY));
+	WARN_ON(readl_relaxed(rs->regs + ROCKCHIP_SPI_SSIENR) &&
+		(readl_relaxed(rs->regs + ROCKCHIP_SPI_SR) & SR_BUSY));
 
 	if (!xfer->tx_buf && !xfer->rx_buf) {
 		dev_err(rs->dev, "No buffer for transfer\n");
-- 
2.1.0.rc2.206.gedb03e5

