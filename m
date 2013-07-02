Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3GBPqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:46:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3GBPqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:46:03 -0400
Date: Tue, 2 Jul 2013 17:46:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 2/3] DMA: shdma: switch all __iomem pointers to void
In-Reply-To: <Pine.LNX.4.64.1307021738500.1965@axis700.grange>
Message-ID: <Pine.LNX.4.64.1307021744480.1965@axis700.grange>
References: <Pine.LNX.4.64.1307021738500.1965@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:N+Ex0X4RtgJR8Tr3DEBXQvesGvQ4lcX+l/oR4gQaYLj
 D22IRGuvDc6mBaUTm5j4RRP/I69iuQyJGxu/q9snvUIUue7Uqv
 VlyP7jtlUiIHqGsyXmSERn5DxfENjsZ9klGfiUhZ3UUym0kic6
 CtJLUbtULU2kp5dOQGxuR9brLLwKGC690fe+w5KPYjjQEka134
 f0s8NwKfKuCXmWMDHaxnEb0WcDCoq9rZBwaQYqHcn3EO1Vy4Iw
 IV6aEzVNq3RUrgJdcApttG+Ze87Wx+jb52Cg5WAUJEgiHoAOqN
 /hawC2po0NGHhf9E2ssdBWpnlldXmpR3mh/SiPxNL42XOYNyYE
 fp2EIIuM9syDCRUc9avd/k57CzJdK6nJ5j2O+ViGtbVsBJXCV2
 4pBglEIwIdAMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the shdma driver __iomem pointers are used to point to hardware
registers.  Using typed pointers like "u32 __iomem *" in this case is
inconvenient, because then offsets, added to such pointers, have to be
devided by sizeof(u32) or similar. Switch the driver to use void
pointers, which avoids this clumsiness.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdma.c |   22 +++++++++++-----------
 drivers/dma/sh/shdma.h |    6 +++---
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index 3083d62..64eb7fb 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -56,22 +56,22 @@ static void channel_clear(struct sh_dmae_chan *sh_dc)
 	struct sh_dmae_device *shdev = to_sh_dev(sh_dc);
 
 	__raw_writel(0, shdev->chan_reg +
-		shdev->pdata->channel[sh_dc->shdma_chan.id].chclr_offset / sizeof(u32));
+		shdev->pdata->channel[sh_dc->shdma_chan.id].chclr_offset);
 }
 
 static void sh_dmae_writel(struct sh_dmae_chan *sh_dc, u32 data, u32 reg)
 {
-	__raw_writel(data, sh_dc->base + reg / sizeof(u32));
+	__raw_writel(data, sh_dc->base + reg);
 }
 
 static u32 sh_dmae_readl(struct sh_dmae_chan *sh_dc, u32 reg)
 {
-	return __raw_readl(sh_dc->base + reg / sizeof(u32));
+	return __raw_readl(sh_dc->base + reg);
 }
 
 static u16 dmaor_read(struct sh_dmae_device *shdev)
 {
-	u32 __iomem *addr = shdev->chan_reg + DMAOR / sizeof(u32);
+	void __iomem *addr = shdev->chan_reg + DMAOR;
 
 	if (shdev->pdata->dmaor_is_32bit)
 		return __raw_readl(addr);
@@ -81,7 +81,7 @@ static u16 dmaor_read(struct sh_dmae_device *shdev)
 
 static void dmaor_write(struct sh_dmae_device *shdev, u16 data)
 {
-	u32 __iomem *addr = shdev->chan_reg + DMAOR / sizeof(u32);
+	void __iomem *addr = shdev->chan_reg + DMAOR;
 
 	if (shdev->pdata->dmaor_is_32bit)
 		__raw_writel(data, addr);
@@ -93,14 +93,14 @@ static void chcr_write(struct sh_dmae_chan *sh_dc, u32 data)
 {
 	struct sh_dmae_device *shdev = to_sh_dev(sh_dc);
 
-	__raw_writel(data, sh_dc->base + shdev->chcr_offset / sizeof(u32));
+	__raw_writel(data, sh_dc->base + shdev->chcr_offset);
 }
 
 static u32 chcr_read(struct sh_dmae_chan *sh_dc)
 {
 	struct sh_dmae_device *shdev = to_sh_dev(sh_dc);
 
-	return __raw_readl(sh_dc->base + shdev->chcr_offset / sizeof(u32));
+	return __raw_readl(sh_dc->base + shdev->chcr_offset);
 }
 
 /*
@@ -244,7 +244,7 @@ static int dmae_set_dmars(struct sh_dmae_chan *sh_chan, u16 val)
 	struct sh_dmae_device *shdev = to_sh_dev(sh_chan);
 	struct sh_dmae_pdata *pdata = shdev->pdata;
 	const struct sh_dmae_channel *chan_pdata = &pdata->channel[sh_chan->shdma_chan.id];
-	u16 __iomem *addr = shdev->dmars;
+	void __iomem *addr = shdev->dmars;
 	unsigned int shift = chan_pdata->dmars_bit;
 
 	if (dmae_is_busy(sh_chan))
@@ -255,8 +255,8 @@ static int dmae_set_dmars(struct sh_dmae_chan *sh_chan, u16 val)
 
 	/* in the case of a missing DMARS resource use first memory window */
 	if (!addr)
-		addr = (u16 __iomem *)shdev->chan_reg;
-	addr += chan_pdata->dmars / sizeof(u16);
+		addr = shdev->chan_reg;
+	addr += chan_pdata->dmars;
 
 	__raw_writew((__raw_readw(addr) & (0xff00 >> shift)) | (val << shift),
 		     addr);
@@ -520,7 +520,7 @@ static int sh_dmae_chan_probe(struct sh_dmae_device *shdev, int id,
 
 	shdma_chan_probe(sdev, schan, id);
 
-	sh_chan->base = shdev->chan_reg + chan_pdata->offset / sizeof(u32);
+	sh_chan->base = shdev->chan_reg + chan_pdata->offset;
 
 	/* set up channel irq */
 	if (pdev->id >= 0)
diff --git a/drivers/dma/sh/shdma.h b/drivers/dma/sh/shdma.h
index 9314e93..06aae6e 100644
--- a/drivers/dma/sh/shdma.h
+++ b/drivers/dma/sh/shdma.h
@@ -28,7 +28,7 @@ struct sh_dmae_chan {
 	struct shdma_chan shdma_chan;
 	const struct sh_dmae_slave_config *config; /* Slave DMA configuration */
 	int xmit_shift;			/* log_2(bytes_per_xfer) */
-	u32 __iomem *base;
+	void __iomem *base;
 	char dev_id[16];		/* unique name per DMAC of channel */
 	int pm_error;
 };
@@ -38,8 +38,8 @@ struct sh_dmae_device {
 	struct sh_dmae_chan *chan[SH_DMAE_MAX_CHANNELS];
 	struct sh_dmae_pdata *pdata;
 	struct list_head node;
-	u32 __iomem *chan_reg;
-	u16 __iomem *dmars;
+	void __iomem *chan_reg;
+	void __iomem *dmars;
 	unsigned int chcr_offset;
 	u32 chcr_ie_bit;
 };
-- 
1.7.2.5

