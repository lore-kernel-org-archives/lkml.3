Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3HKSE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 14:04:26 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:52915 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab3HKR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:59:46 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Dan Williams <djbw@fb.com>, Jaroslav Kysela <perex@perex.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 01/18] dmaengine: PL08x: Refactor pl08x_getbytes_chan() to lower indentation
Date: Sun, 11 Aug 2013 19:59:13 +0200
Message-Id: <1376243970-6489-2-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further patch will introduce support for PL080S, which requires some
things to be done conditionally, thus increasing indentation level of
some functions even more.

This patch reduces indentation level of pl08x_getbytes_chan() function
by inverting several conditions and returning from function wherever
possible.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c | 53 ++++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 06fe45c..6a12392 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -469,47 +469,52 @@ static inline u32 get_bytes_in_cctl(u32 cctl)
 /* The channel should be paused when calling this */
 static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 {
+	struct pl08x_lli *llis_va;
 	struct pl08x_phy_chan *ch;
+	dma_addr_t llis_bus;
 	struct pl08x_txd *txd;
-	size_t bytes = 0;
+	size_t bytes;
+	int index;
+	u32 clli;
 
 	ch = plchan->phychan;
 	txd = plchan->at;
 
+	if (!ch || !txd)
+		return 0;
+
 	/*
 	 * Follow the LLIs to get the number of remaining
 	 * bytes in the currently active transaction.
 	 */
-	if (ch && txd) {
-		u32 clli = readl(ch->base + PL080_CH_LLI) & ~PL080_LLI_LM_AHB2;
+	clli = readl(ch->base + PL080_CH_LLI) & ~PL080_LLI_LM_AHB2;
 
-		/* First get the remaining bytes in the active transfer */
-		bytes = get_bytes_in_cctl(readl(ch->base + PL080_CH_CONTROL));
+	/* First get the remaining bytes in the active transfer */
+	bytes = get_bytes_in_cctl(readl(ch->base + PL080_CH_CONTROL));
 
-		if (clli) {
-			struct pl08x_lli *llis_va = txd->llis_va;
-			dma_addr_t llis_bus = txd->llis_bus;
-			int index;
+	if (!clli)
+		return bytes;
 
-			BUG_ON(clli < llis_bus || clli >= llis_bus +
+	llis_va = txd->llis_va;
+	llis_bus = txd->llis_bus;
+
+	BUG_ON(clli < llis_bus || clli >= llis_bus +
 				sizeof(struct pl08x_lli) * MAX_NUM_TSFR_LLIS);
 
-			/*
-			 * Locate the next LLI - as this is an array,
-			 * it's simple maths to find.
-			 */
-			index = (clli - llis_bus) / sizeof(struct pl08x_lli);
+	/*
+	 * Locate the next LLI - as this is an array,
+	 * it's simple maths to find.
+	 */
+	index = (clli - llis_bus) / sizeof(struct pl08x_lli);
 
-			for (; index < MAX_NUM_TSFR_LLIS; index++) {
-				bytes += get_bytes_in_cctl(llis_va[index].cctl);
+	for (; index < MAX_NUM_TSFR_LLIS; index++) {
+		bytes += get_bytes_in_cctl(llis_va[index].cctl);
 
-				/*
-				 * A LLI pointer of 0 terminates the LLI list
-				 */
-				if (!llis_va[index].lli)
-					break;
-			}
-		}
+		/*
+		 * A LLI pointer of 0 terminates the LLI list
+		 */
+		if (!llis_va[index].lli)
+			break;
 	}
 
 	return bytes;
-- 
1.8.3.2

