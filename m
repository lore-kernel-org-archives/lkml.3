Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3HKSAB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 14:00:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50062 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3HKR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:59:53 -0400
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
Subject: [PATCH 04/18] dmaengine: PL08x: Move LLI dumping code into separate function
Date: Sun, 11 Aug 2013 19:59:16 +0200
Message-Id: <1376243970-6489-5-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactors debugging code that dumps LLI entries by moving it
into separate function, which is stubbed when VERBOSE_DEBUG is not
selected. This allows us to get rid of the ugly ifdef from the body of
pl08x_fill_llis_for_desc().

No functional change is introduced by this patch.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/dma/amba-pl08x.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index d3399c2..1fa05d6 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -814,6 +814,29 @@ static inline void prep_byte_width_lli(struct pl08x_driver_data *pl08x,
 	(*total_bytes) += len;
 }
 
+#ifdef VERBOSE_DEBUG
+static void pl08x_dump_lli(struct pl08x_driver_data *pl08x,
+			   const u32 *llis_va, int num_llis)
+{
+	int i;
+
+	dev_vdbg(&pl08x->adev->dev,
+		"%-3s %-9s  %-10s %-10s %-10s %s\n",
+		"lli", "", "csrc", "cdst", "clli", "cctl");
+	for (i = 0; i < num_llis; i++) {
+		dev_vdbg(&pl08x->adev->dev,
+			"%3d @%p: 0x%08x 0x%08x 0x%08x 0x%08x\n",
+			i, llis_va, llis_va[PL080_LLI_SRC],
+			llis_va[PL080_LLI_DST], llis_va[PL080_LLI_LLI],
+			llis_va[PL080_LLI_CCTL]);
+		llis_va += pl08x->lli_words;
+	}
+}
+#else
+static inline void pl08x_dump_lli(struct pl08x_driver_data *pl08x,
+				  const u32 *llis_va, int num_llis) {}
+#endif
+
 /*
  * This fills in the table of LLIs for the transfer descriptor
  * Note that we assume we never have to change the burst sizes
@@ -1033,23 +1056,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	/* The final LLI element shall also fire an interrupt. */
 	last_lli[PL080_LLI_CCTL] |= PL080_CONTROL_TC_IRQ_EN;
 
-#ifdef VERBOSE_DEBUG
-	{
-		int i;
-
-		dev_vdbg(&pl08x->adev->dev,
-			 "%-3s %-9s  %-10s %-10s %-10s %s\n",
-			 "lli", "", "csrc", "cdst", "clli", "cctl");
-		for (i = 0; i < num_llis; i++) {
-			dev_vdbg(&pl08x->adev->dev,
-				 "%3d @%p: 0x%08x 0x%08x 0x%08x 0x%08x\n",
-				 i, llis_va, llis_va[PL080_LLI_SRC],
-				 llis_va[PL080_LLI_DST], llis_va[PL080_LLI_LLI],
-				 llis_va[PL080_LLI_CCTL]);
-			llis_va += pl08x->lli_words;
-		}
-	}
-#endif
+	pl08x_dump_lli(pl08x, llis_va, num_llis);
 
 	return num_llis;
 }
-- 
1.8.3.2

