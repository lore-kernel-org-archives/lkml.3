Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964994Ab3GLNpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:45:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808Ab3GLNoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:44:04 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 5/8] ARM: shmobile: r8a7740: switch DMAC controllers to using device ID data
Date: Fri, 12 Jul 2013 15:43:55 +0200
Message-Id: <1373636638-18496-6-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
References: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:A86v2b+nSiAtrHxnBX2vaJNQGoYmN4B37Bbo0AutNtD
 0ajceOA0gJPHF0kk1VCHiPdb9MygFamQgmW4Kmo46XpUo5y050
 BxMZ35sMTbMBLpHH7A907+lrXyQcyGa4+SIYzZNBmkRg2nQtIx
 /ckp2/DUxbc9vXFx2ZPktdUdK3A2gu6l+7LNXNu3w5NVNMtfV9
 DsZm/bPyLot5dCFQ/9+lrGNYcQma4+BmmerFsNVgya+PCpEvuW
 hHX6BF+zgEgNvAsoxHmhMIl6a1xeEvi/kmW7SJD8a4Uue08RTh
 svuwdKhYZQ4w361+SYl37urhrPzj+9qQuvibDTeycFPHPa+aE7
 5tOUlYtvQ8ijbzBSX24lh1AMLuI8gEab7gMw/Zki9+yfc9XLoN
 pmvA8N7pjmlGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes DMAC platform data on r8a7740 and switches to using
device ID data.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

Simon: this patch should only be applied after DMA driver changes, 
otherwise DMA on r8a7740 will be broken. We can delay this patch 
for one more kernel version, there is no rush with it, unless we 
want to enable DMA DT on r8a7740 ASAP.

 arch/arm/mach-shmobile/clock-r8a7740.c |    6 +-
 arch/arm/mach-shmobile/setup-r8a7740.c |  106 +-------------------------------
 2 files changed, 6 insertions(+), 106 deletions(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
index 7fd32d6..0abe58a 100644
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

