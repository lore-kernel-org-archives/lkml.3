Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaFEM6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:58:14 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:59196 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaFEM6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:58:12 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: netdev@vger.kernel.org
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] stmmac: extend DMA initialization delay to 2.5 seconds
Date: Thu,  5 Jun 2014 16:58:00 +0400
Message-Id: <1401973080-10085-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms existing 100 msecond delay is not enough for DMA block to
recover after reset. This is because MAC DMA waits for all PHY input clocks
to present and depending on the board reset bit deassertion may take much
longer than previously used 100 milliseconds

I have a board that requires more than 2 seconds for DMA to zero "reset" bit.
If for other boards it's still not long enough this value should be extended
once again.

In the same change I convert "mdelay" to "msleep" to make CPU available for
other processes during DMA init delay which is especially useful in case of
delay for a few seconds.

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>

Cc: David S. Miller <davem@davemloft.net>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: Vineet Gupta <vgupta@synopsys.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
index 0c2058a..f713ea7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
@@ -39,11 +39,11 @@ static int dwmac1000_dma_init(void __iomem *ioaddr, int pbl, int fb, int mb,
 	/* DMA SW reset */
 	value |= DMA_BUS_MODE_SFT_RESET;
 	writel(value, ioaddr + DMA_BUS_MODE);
-	limit = 10;
+	limit = 100;
 	while (limit--) {
 		if (!(readl(ioaddr + DMA_BUS_MODE) & DMA_BUS_MODE_SFT_RESET))
 			break;
-		mdelay(10);
+		msleep(25);
 	}
 	if (limit < 0)
 		return -EBUSY;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
index 7d1dce9..043585f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
@@ -41,11 +41,11 @@ static int dwmac100_dma_init(void __iomem *ioaddr, int pbl, int fb, int mb,
 	/* DMA SW reset */
 	value |= DMA_BUS_MODE_SFT_RESET;
 	writel(value, ioaddr + DMA_BUS_MODE);
-	limit = 10;
+	limit = 100;
 	while (limit--) {
 		if (!(readl(ioaddr + DMA_BUS_MODE) & DMA_BUS_MODE_SFT_RESET))
 			break;
-		mdelay(10);
+		msleep(25);
 	}
 	if (limit < 0)
 		return -EBUSY;
-- 
1.9.3

