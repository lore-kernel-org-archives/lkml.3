Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3GBPqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:46:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51401 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3GBPqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:46:09 -0400
Date: Tue, 2 Jul 2013 17:46:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 3/3] DMA: shdma: support the new CHCLR register layout
In-Reply-To: <Pine.LNX.4.64.1307021738500.1965@axis700.grange>
Message-ID: <Pine.LNX.4.64.1307021745140.1965@axis700.grange>
References: <Pine.LNX.4.64.1307021738500.1965@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ajDgb5x6JW2Gd/ZL1HYHChvjFRetAcyi2S1OTqbq0t8
 hBi/BVN9TWwjZImiss6LiuXfRAuiuNgNn4PnjvAsE24nRPWpcZ
 ylwXwq0YTx7s8O1ceg2zrYL814ANWX9y6/8j2/zN2HjSQoqeUb
 zjtVJwiosc5GLilLMT8TatV/bFPrTQKalKvlG7epH34Av8zkhV
 GqWJAZUNE3gXkhFHjAyUGpDuUGavSIlTIrvqM+Xh/EovbS/vM2
 nBeHQpPT40AgWQIeIjzoG8QwXcnBH0N+9R1sbpm/SKLLIL2U1+
 MEd8dary7zTclMLzfgkrYucdnpiZEuVxPFp44Ab9h9jdxDfjxW
 0zKXkju+NAg6irP4zqNHDcyk8qaKU2K8MImgfrRO1zvDtSbMp7
 174aa/SGnieCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On newer r-car SoCs the CHCLR register only contains one bit per channel,
to which a 1 has to be written to reset the channel. Older SoC versions had
one CHCLR register per channel, to which a 0 must be written to reset the
channel and clear its buffers. This patch adds support for the newer
layout.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdma.c |    6 ++++--
 include/linux/sh_dma.h |   12 +++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index 64eb7fb..883a4de 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -54,9 +54,11 @@ static LIST_HEAD(sh_dmae_devices);
 static void channel_clear(struct sh_dmae_chan *sh_dc)
 {
 	struct sh_dmae_device *shdev = to_sh_dev(sh_dc);
+	const struct sh_dmae_channel *chan_pdata = shdev->pdata->channel +
+		sh_dc->shdma_chan.id;
+	u32 val = chan_pdata->chclr_bit < 0 ? 0 : 1 << chan_pdata->chclr_bit;
 
-	__raw_writel(0, shdev->chan_reg +
-		shdev->pdata->channel[sh_dc->shdma_chan.id].chclr_offset);
+	__raw_writel(val, shdev->chan_reg + chan_pdata->chclr_offset);
 }
 
 static void sh_dmae_writel(struct sh_dmae_chan *sh_dc, u32 data, u32 reg)
diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index 4e83f3e..9316a1d 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -33,11 +33,21 @@ struct sh_dmae_slave_config {
 	char		mid_rid;
 };
 
+/**
+ * struct sh_dmae_channel - DMAC channel platform data
+ * @offset:		register offset within the main IOMEM resource
+ * @dmars:		channel DMARS register offset
+ * @chclr_offset:	channel CHCLR register offset
+ * @dmars_bit:		channel DMARS field offset within the register
+ * @chclr_bit:		> 0: bit position, to be set to reset the channel
+ *			< 0: CHCLR has to be cleared to clear channel's buffers
+ */
 struct sh_dmae_channel {
 	unsigned int	offset;
 	unsigned int	dmars;
-	unsigned int	dmars_bit;
 	unsigned int	chclr_offset;
+	unsigned char	dmars_bit;
+	signed char	chclr_bit;
 };
 
 struct sh_dmae_pdata {
-- 
1.7.2.5

