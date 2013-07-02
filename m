Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3GBPiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:38:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63704 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3GBPiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:38:08 -0400
Date: Tue, 2 Jul 2013 17:37:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH] DMA: shdma: fix CHCLR register address calculation
Message-ID: <Pine.LNX.4.64.1307021733280.1965@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:rQbIwGp8xqxoC0KnPjvYDt+gz5URqlv6wQls5vdN0Mc
 Z6yLIUu27OFM7R5y2w4d6IM+T/VevCPAN35ns7nutcw256BQSs
 +d8BzTiWS+D17vWDSR3J2s+X/X9BmCcg7Kw8XdyfbPbEnm+exd
 2VqNv3tJ0BW3gTys5Zk/J/0P6D8wvJzQ+ZufJygvE07wWFzZJO
 wcDUKd06suaA8nHSmPS/sZ26PDeFj/UgHPUWxgdkqkvHjj/s3J
 U7ySagPUF/ckoN2TclisO+SSMELmhnCEiRibIafhEEUFq9A4Zb
 rXvDSgKMllTcds46MeezOF2JR7YMpFz7ykaMzCX79G9e5q0IQI
 e5MmPe4g8mCYDS7VLRdFUTFHy9dLre5vqBwTttXH/dxru0P2wF
 pIuKQBQvuSNxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct sh_dmae_device::chan_reg is a pointer to u32, therefore when adding
offsets to it care should be taken to add offsets in sizeof(u32) units, not
in bytes. This patch corrects such a bug. While at it we also remove the
redundant parameter of the affected function.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

This is a theoretical fix, I don't have a test-case for it, but the 
original calculation does seem to be buggy to me. Reviews and tests are 
welcome.

 drivers/dma/sh/shdma.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index 98b2693..c7950be 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -51,12 +51,12 @@
 static DEFINE_SPINLOCK(sh_dmae_lock);
 static LIST_HEAD(sh_dmae_devices);
 
-static void chclr_write(struct sh_dmae_chan *sh_dc, u32 data)
+static void channel_clear(struct sh_dmae_chan *sh_dc)
 {
 	struct sh_dmae_device *shdev = to_sh_dev(sh_dc);
 
-	__raw_writel(data, shdev->chan_reg +
-		     shdev->pdata->channel[sh_dc->shdma_chan.id].chclr_offset);
+	__raw_writel(0, shdev->chan_reg +
+		shdev->pdata->channel[sh_dc->shdma_chan.id].chclr_offset / sizeof(u32));
 }
 
 static void sh_dmae_writel(struct sh_dmae_chan *sh_dc, u32 data, u32 reg)
@@ -135,7 +135,7 @@ static int sh_dmae_rst(struct sh_dmae_device *shdev)
 		for (i = 0; i < shdev->pdata->channel_num; i++) {
 			struct sh_dmae_chan *sh_chan = shdev->chan[i];
 			if (sh_chan)
-				chclr_write(sh_chan, 0);
+				channel_clear(sh_chan);
 		}
 	}
 
-- 
1.7.2.5

