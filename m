Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3HKSAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 14:00:06 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51748 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab3HKR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:59:58 -0400
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
Subject: [PATCH 06/18] dmaengine: PL08x: Add support for different maximum transfer size
Date: Sun, 11 Aug 2013 19:59:18 +0200
Message-Id: <1376243970-6489-7-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PL080S has separate register to store transfer size in, allowing single
transfer to be much larger than in standard PL080.

This patch makes the amba-pl08x driver aware of this and removes writing
transfer size to reserved bits of CH_CONTROL register on PL080S, which
was not a problem witn transfer sizes fitting the original bitfield
of PL080, but now would overwrite other fields.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/amba-pl08x.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 75915be..4e4c3df 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -115,6 +115,7 @@ struct vendor_data {
 	bool dualmaster;
 	bool nomadik;
 	bool pl080s;
+	u32 max_transfer_size;
 };
 
 /**
@@ -783,6 +784,7 @@ static inline u32 pl08x_cctl_bits(u32 cctl, u8 srcwidth, u8 dstwidth,
 		break;
 	}
 
+	tsize &= PL080_CONTROL_TRANSFER_SIZE_MASK;
 	retbits |= tsize << PL080_CONTROL_TRANSFER_SIZE_SHIFT;
 	return retbits;
 }
@@ -1050,7 +1052,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			 * MIN(buswidths)
 			 */
 			max_bytes_per_lli = bd.srcbus.buswidth *
-				PL080_CONTROL_TRANSFER_SIZE_MASK;
+						pl08x->vd->max_transfer_size;
 			dev_vdbg(&pl08x->adev->dev,
 				"%s max bytes per lli = %zu\n",
 				__func__, max_bytes_per_lli);
@@ -2152,6 +2154,7 @@ static struct vendor_data vendor_pl080 = {
 	.config_offset = PL080_CH_CONFIG,
 	.channels = 8,
 	.dualmaster = true,
+	.max_transfer_size = PL080_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct vendor_data vendor_nomadik = {
@@ -2159,18 +2162,21 @@ static struct vendor_data vendor_nomadik = {
 	.channels = 8,
 	.dualmaster = true,
 	.nomadik = true,
+	.max_transfer_size = PL080_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct vendor_data vendor_pl080s = {
 	.config_offset = PL080S_CH_CONFIG,
 	.channels = 8,
 	.pl080s = true,
+	.max_transfer_size = PL080S_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct vendor_data vendor_pl081 = {
 	.config_offset = PL080_CH_CONFIG,
 	.channels = 2,
 	.dualmaster = false,
+	.max_transfer_size = PL080_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct amba_id pl08x_ids[] = {
-- 
1.8.3.2

