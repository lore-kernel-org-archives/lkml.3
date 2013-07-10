Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3GJKK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:10:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58117 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3GJKKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:10:25 -0400
Date: Wed, 10 Jul 2013 12:09:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH v2 3/3] DMA: shdma: support the new CHCLR register layout
Message-ID: <Pine.LNX.4.64.1307101204310.6609@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:JjpsI1h1XRmol4sxxSaZHgzMfTQeVBXwI0jVMaoy6T0
 lazdt9XOWNRo5fjA9zNvcoidHVwuhVxtDQkB1YlWq5jbwFl2T3
 +lVMAJ7WkexxNDeMQG3/b6EYdh1yCgP7net2wPVq5C/W5rPKWV
 f2oFXT2osvERuU7FNP5UsrkGeMycfGIjNTAGsBPnzJac3Y6WsZ
 MHQlJfH/foOlRoyaNywP0VeQCPYo5pbCsxRjtsJf7IaCr0fGvy
 5N4YVgy97GV9kUQlxeQcjYQxSuD0A/RcuQP0sKt5fTT8pAnpoO
 qyRIW/zwdiky/mt3K0hLY1Qzr3qRYujLpbdadU6Io7xCwfx/uK
 1NKubvNnDLTAO2FBqswQuQ8axc0+OA8rDYgPqgzQ1SFKHkZZGP
 nxILX4cViJa4g==
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

v2: remove merge order dependency. This version can be merged without 
requiring platforms to adjust their platform data. Only new SoCs with 
bitwise CHCLR layouts will have to use new platform data fields.

 drivers/dma/sh/shdma.c |   14 ++++++++++++--
 include/linux/sh_dma.h |   34 +++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index 1d45aed..5153af1 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -49,12 +49,22 @@
 static DEFINE_SPINLOCK(sh_dmae_lock);
 static LIST_HEAD(sh_dmae_devices);
 
+/*
+ * Different DMAC implementations provide different ways to clear DMA channels:
+ * (1) none - no CHCLR registers are available
+ * (2) one CHCLR register per channel - 0 has to be written to it to clear
+ *     channel buffers
+ * (3) one CHCLR per several channels - 1 has to be written to the bit,
+ *     corresponding to the specific channel to reset it
+ */
 static void channel_clear(struct sh_dmae_chan *sh_dc)
 {
 	struct sh_dmae_device *shdev = to_sh_dev(sh_dc);
+	const struct sh_dmae_channel *chan_pdata = shdev->pdata->channel +
+		sh_dc->shdma_chan.id;
+	u32 val = shdev->pdata->chclr_bitwise ? 1 << chan_pdata->chclr_bit : 0;
 
-	__raw_writel(0, shdev->chan_reg +
-		shdev->pdata->channel[sh_dc->shdma_chan.id].chclr_offset);
+	__raw_writel(val, shdev->chan_reg + chan_pdata->chclr_offset);
 }
 
 static void sh_dmae_writel(struct sh_dmae_chan *sh_dc, u32 data, u32 reg)
diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index 4e83f3e..776ed9d 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -33,13 +33,44 @@ struct sh_dmae_slave_config {
 	char		mid_rid;
 };
 
+/**
+ * struct sh_dmae_channel - DMAC channel platform data
+ * @offset:		register offset within the main IOMEM resource
+ * @dmars:		channel DMARS register offset
+ * @chclr_offset:	channel CHCLR register offset
+ * @dmars_bit:		channel DMARS field offset within the register
+ * @chclr_bit:		bit position, to be set to reset the channel
+ */
 struct sh_dmae_channel {
 	unsigned int	offset;
 	unsigned int	dmars;
-	unsigned int	dmars_bit;
 	unsigned int	chclr_offset;
+	unsigned char	dmars_bit;
+	unsigned char	chclr_bit;
 };
 
+/**
+ * struct sh_dmae_pdata - DMAC platform data
+ * @slave:		array of slaves
+ * @slave_num:		number of slaves in the above array
+ * @channel:		array of DMA channels
+ * @channel_num:	number of channels in the above array
+ * @ts_low_shift:	shift of the low part of the TS field
+ * @ts_low_mask:	low TS field mask
+ * @ts_high_shift:	additional shift of the high part of the TS field
+ * @ts_high_mask:	high TS field mask
+ * @ts_shift:		array of Transfer Size shifts, indexed by TS value
+ * @ts_shift_num:	number of shifts in the above array
+ * @dmaor_init:		DMAOR initialisation value
+ * @chcr_offset:	CHCR address offset
+ * @chcr_ie_bit:	CHCR Interrupt Enable bit
+ * @dmaor_is_32bit:	DMAOR is a 32-bit register
+ * @needs_tend_set:	the TEND register has to be set
+ * @no_dmars:		DMAC has no DMARS registers
+ * @chclr_present:	DMAC has one or several CHCLR registers
+ * @chclr_bitwise:	channel CHCLR registers are bitwise
+ * @slave_only:		DMAC cannot be used for MEMCPY
+ */
 struct sh_dmae_pdata {
 	const struct sh_dmae_slave_config *slave;
 	int slave_num;
@@ -59,6 +90,7 @@ struct sh_dmae_pdata {
 	unsigned int needs_tend_set:1;
 	unsigned int no_dmars:1;
 	unsigned int chclr_present:1;
+	unsigned int chclr_bitwise:1;
 	unsigned int slave_only:1;
 };
 
-- 
1.7.2.5

