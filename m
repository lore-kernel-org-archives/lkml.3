Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab3GWKuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:50:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab3GWKuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:50:18 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v4 11/15] ARM: shmobile: r8a7740: switch DMAC controllers to using device ID data
Date: Tue, 23 Jul 2013 12:50:05 +0200
Message-Id: <1374576609-27748-12-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:20iwP2eJDaFxj8Re74/q6tL+FCgjx/+x/smVVrWsBYs
 puYnCcRIqT1ubKVAugRl3o8i4e6qDLqEqIEh88D4Cy2c1IKn4x
 eClM86U0rg4zOFoY9SrP3g2/8Ba1NHY9TiQgox3+FC0I/mqwtx
 OwBm/1O51jQnxVKg2iFh/fv0NrbDTGfi5A+V8ETaM41STmemn6
 q8G9XNhm63Lgqclr5HfHOLyaGBwuIBJoSfKak8sUxsVxst8ttS
 jltwJfxiEt+h0a7tqUHhIRQKJGhal8ZJrJJ0hAEPQbhLhnRIpg
 CYU/TUGWJkMMABB6WBIlIcNfxsF91F/QAl54+k69A1NAAZ9Uhf
 KGuZKXLs5kp0BKFt/MmYgL4in4Dbib3jRKI6mqdIT8KxFDubot
 3V8PzISQ327+kKrJof4sK3dMGQ+M60nH04=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes DMAC platform data on r8a7740 and switches to using
device ID data.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 arch/arm/mach-shmobile/clock-r8a7740.c |    6 +-
 arch/arm/mach-shmobile/setup-r8a7740.c |  106 +-------------------------------
 2 files changed, 6 insertions(+), 106 deletions(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
index f4265e5..f32a22d 100644
--- a/arch/arm/mach-shmobile/clock-r8a7740.c
+++ b/arch/arm/mach-shmobile/clock-r8a7740.c
@@ -575,9 +575,9 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh-sci.5",		&mstp_clks[MSTP207]),
 	CLKDEV_DEV_ID("e6cb0000.sci",		&mstp_clks[MSTP207]),
 	CLKDEV_DEV_ID("sh-dma-engine.3",	&mstp_clks[MSTP214]),
-	CLKDEV_DEV_ID("sh-dma-engine.2",	&mstp_clks[MSTP216]),
-	CLKDEV_DEV_ID("sh-dma-engine.1",	&mstp_clks[MSTP217]),
-	CLKDEV_DEV_ID("sh-dma-engine.0",	&mstp_clks[MSTP218]),
+	CLKDEV_DEV_ID("shdma-r8a7740.2",	&mstp_clks[MSTP216]),
+	CLKDEV_DEV_ID("shdma-r8a7740.1",	&mstp_clks[MSTP217]),
+	CLKDEV_DEV_ID("shdma-r8a7740.0",	&mstp_clks[MSTP218]),
 	CLKDEV_DEV_ID("sh-sci.7",		&mstp_clks[MSTP222]),
 	CLKDEV_DEV_ID("e6cd0000.sci",		&mstp_clks[MSTP222]),
 	CLKDEV_DEV_ID("sh-sci.6",		&mstp_clks[MSTP230]),
diff --git a/arch/arm/mach-shmobile/setup-r8a7740.c b/arch/arm/mach-shmobile/setup-r8a7740.c
index 84c5bb6..01dcb3b 100644
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@ -542,97 +542,6 @@ static struct platform_device *r8a7740_early_devices[] __initdata = {
 };
 
 /* DMA */
-static const struct sh_dmae_slave_config r8a7740_dmae_slaves[] = {
-	{
-		.slave_id	= SHDMA_SLAVE_SDHI0_TX,
-		.addr		= 0xe6850030,
-		.chcr		= CHCR_TX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xc1,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI0_RX,
-		.addr		= 0xe6850030,
-		.chcr		= CHCR_RX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xc2,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI1_TX,
-		.addr		= 0xe6860030,
-		.chcr		= CHCR_TX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xc9,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI1_RX,
-		.addr		= 0xe6860030,
-		.chcr		= CHCR_RX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xca,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI2_TX,
-		.addr		= 0xe6870030,
-		.chcr		= CHCR_TX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xcd,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI2_RX,
-		.addr		= 0xe6870030,
-		.chcr		= CHCR_RX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xce,
-	}, {
-		.slave_id	= SHDMA_SLAVE_FSIA_TX,
-		.addr		= 0xfe1f0024,
-		.chcr		= CHCR_TX(XMIT_SZ_32BIT),
-		.mid_rid	= 0xb1,
-	}, {
-		.slave_id	= SHDMA_SLAVE_FSIA_RX,
-		.addr		= 0xfe1f0020,
-		.chcr		= CHCR_RX(XMIT_SZ_32BIT),
-		.mid_rid	= 0xb2,
-	}, {
-		.slave_id	= SHDMA_SLAVE_FSIB_TX,
-		.addr		= 0xfe1f0064,
-		.chcr		= CHCR_TX(XMIT_SZ_32BIT),
-		.mid_rid	= 0xb5,
-	}, {
-		.slave_id	= SHDMA_SLAVE_MMCIF_TX,
-		.addr		= 0xe6bd0034,
-		.chcr		= CHCR_TX(XMIT_SZ_32BIT),
-		.mid_rid	= 0xd1,
-	}, {
-		.slave_id	= SHDMA_SLAVE_MMCIF_RX,
-		.addr		= 0xe6bd0034,
-		.chcr		= CHCR_RX(XMIT_SZ_32BIT),
-		.mid_rid	= 0xd2,
-	},
-};
-
-#define DMA_CHANNEL(a, b, c)			\
-{						\
-	.offset		= a,			\
-	.dmars		= b,			\
-	.dmars_bit	= c,			\
-	.chclr_offset	= (0x220 - 0x20) + a	\
-}
-
-static const struct sh_dmae_channel r8a7740_dmae_channels[] = {
-	DMA_CHANNEL(0x00, 0, 0),
-	DMA_CHANNEL(0x10, 0, 8),
-	DMA_CHANNEL(0x20, 4, 0),
-	DMA_CHANNEL(0x30, 4, 8),
-	DMA_CHANNEL(0x50, 8, 0),
-	DMA_CHANNEL(0x60, 8, 8),
-};
-
-static struct sh_dmae_pdata dma_platform_data = {
-	.slave		= r8a7740_dmae_slaves,
-	.slave_num	= ARRAY_SIZE(r8a7740_dmae_slaves),
-	.channel	= r8a7740_dmae_channels,
-	.channel_num	= ARRAY_SIZE(r8a7740_dmae_channels),
-	.ts_low_shift	= TS_LOW_SHIFT,
-	.ts_low_mask	= TS_LOW_BIT << TS_LOW_SHIFT,
-	.ts_high_shift	= TS_HI_SHIFT,
-	.ts_high_mask	= TS_HI_BIT << TS_HI_SHIFT,
-	.ts_shift	= dma_ts_shift,
-	.ts_shift_num	= ARRAY_SIZE(dma_ts_shift),
-	.dmaor_init	= DMAOR_DME,
-	.chclr_present	= 1,
-};
-
 /* Resource order important! */
 static struct resource r8a7740_dmae0_resources[] = {
 	{
@@ -718,33 +627,24 @@ static struct resource r8a7740_dmae2_resources[] = {
 };
 
 static struct platform_device dma0_device = {
-	.name		= "sh-dma-engine",
+	.name		= "shdma-r8a7740",
 	.id		= 0,
 	.resource	= r8a7740_dmae0_resources,
 	.num_resources	= ARRAY_SIZE(r8a7740_dmae0_resources),
-	.dev		= {
-		.platform_data	= &dma_platform_data,
-	},
 };
 
 static struct platform_device dma1_device = {
-	.name		= "sh-dma-engine",
+	.name		= "shdma-r8a7740",
 	.id		= 1,
 	.resource	= r8a7740_dmae1_resources,
 	.num_resources	= ARRAY_SIZE(r8a7740_dmae1_resources),
-	.dev		= {
-		.platform_data	= &dma_platform_data,
-	},
 };
 
 static struct platform_device dma2_device = {
-	.name		= "sh-dma-engine",
+	.name		= "shdma-r8a7740",
 	.id		= 2,
 	.resource	= r8a7740_dmae2_resources,
 	.num_resources	= ARRAY_SIZE(r8a7740_dmae2_resources),
-	.dev		= {
-		.platform_data	= &dma_platform_data,
-	},
 };
 
 /* USB-DMAC */
-- 
1.7.2.5

