Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3GWKu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:50:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3GWKuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:50:20 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v4 14/15] ARM: shmobile: sh73a0: switch DMAC controllers to using device ID data
Date: Tue, 23 Jul 2013 12:50:08 +0200
Message-Id: <1374576609-27748-15-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:hwK6hogdmEfotUfhd79jEM1rkaQiQHMUAO/dz17gysQ
 BdVcVBb7IDZ8fSUXO9lhRUWENRkKpKuz+GrG80uhJiFpvqW7qD
 iMggaZeIu7UC4QdgwjAXvkUVMPhMERvyU/WwmN6Sv1MAzgJtnr
 uadfdRueNc5cO/eahDZIA1Zx3UnG3q89kaatwNf/dSA+2jOmUV
 72X7N42VEPfXWB4QQYYm051gMCdA//2VHH2JYlKjjC34o2HXPx
 LSjQGVdry7Al00tQkv44sAxvAh0IxKK0MNDdOACAcYedi6z3WY
 xW3wKcMSVZ6C5GB47yCF/uoci+VSaZoXgQJK9SKdfhG1OjXp2K
 udU4Kroysv1KwCtvG/vyicyQDMpkzQCHVQ4Y23icppMWt5u3SZ
 uc5aqChkogUSer5c/XFAZhzANYz7/qKzyo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes DMAC platform data on sh73a0 and switches to using
device ID data.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 arch/arm/mach-shmobile/clock-sh73a0.c |    2 +-
 arch/arm/mach-shmobile/setup-sh73a0.c |  182 +--------------------------------
 2 files changed, 2 insertions(+), 182 deletions(-)

diff --git a/arch/arm/mach-shmobile/clock-sh73a0.c b/arch/arm/mach-shmobile/clock-sh73a0.c
index 1942eae..3a00b49 100644
--- a/arch/arm/mach-shmobile/clock-sh73a0.c
+++ b/arch/arm/mach-shmobile/clock-sh73a0.c
@@ -646,7 +646,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("e6820000.i2c", &mstp_clks[MSTP116]), /* I2C0 */
 	CLKDEV_DEV_ID("sh_mobile_lcdc_fb.0", &mstp_clks[MSTP100]), /* LCDC0 */
 	CLKDEV_DEV_ID("sh-sci.7", &mstp_clks[MSTP219]), /* SCIFA7 */
-	CLKDEV_DEV_ID("sh-dma-engine.0", &mstp_clks[MSTP218]), /* SY-DMAC */
+	CLKDEV_DEV_ID("shdma-sh73a0.0", &mstp_clks[MSTP218]), /* SY-DMAC */
 	CLKDEV_DEV_ID("sh-dma-engine.1", &mstp_clks[MSTP217]), /* MP-DMAC */
 	CLKDEV_DEV_ID("sh-sci.5", &mstp_clks[MSTP207]), /* SCIFA5 */
 	CLKDEV_DEV_ID("sh-sci.8", &mstp_clks[MSTP206]), /* SCIFB */
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index 516c239..2e9f3cc 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -396,183 +396,6 @@ static struct platform_device i2c4_device = {
 	.num_resources	= ARRAY_SIZE(i2c4_resources),
 };
 
-static const struct sh_dmae_slave_config sh73a0_dmae_slaves[] = {
-	{
-		.slave_id	= SHDMA_SLAVE_SCIF0_TX,
-		.addr		= 0xe6c40020,
-		.chcr		= CHCR_TX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x21,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF0_RX,
-		.addr		= 0xe6c40024,
-		.chcr		= CHCR_RX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x22,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF1_TX,
-		.addr		= 0xe6c50020,
-		.chcr		= CHCR_TX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x25,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF1_RX,
-		.addr		= 0xe6c50024,
-		.chcr		= CHCR_RX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x26,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF2_TX,
-		.addr		= 0xe6c60020,
-		.chcr		= CHCR_TX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x29,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF2_RX,
-		.addr		= 0xe6c60024,
-		.chcr		= CHCR_RX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x2a,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF3_TX,
-		.addr		= 0xe6c70020,
-		.chcr		= CHCR_TX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x2d,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF3_RX,
-		.addr		= 0xe6c70024,
-		.chcr		= CHCR_RX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x2e,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF4_TX,
-		.addr		= 0xe6c80020,
-		.chcr		= CHCR_TX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x39,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF4_RX,
-		.addr		= 0xe6c80024,
-		.chcr		= CHCR_RX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x3a,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF5_TX,
-		.addr		= 0xe6cb0020,
-		.chcr		= CHCR_TX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x35,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF5_RX,
-		.addr		= 0xe6cb0024,
-		.chcr		= CHCR_RX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x36,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF6_TX,
-		.addr		= 0xe6cc0020,
-		.chcr		= CHCR_TX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x1d,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF6_RX,
-		.addr		= 0xe6cc0024,
-		.chcr		= CHCR_RX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x1e,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF7_TX,
-		.addr		= 0xe6cd0020,
-		.chcr		= CHCR_TX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x19,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF7_RX,
-		.addr		= 0xe6cd0024,
-		.chcr		= CHCR_RX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x1a,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF8_TX,
-		.addr		= 0xe6c30040,
-		.chcr		= CHCR_TX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x3d,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SCIF8_RX,
-		.addr		= 0xe6c30060,
-		.chcr		= CHCR_RX(XMIT_SZ_8BIT),
-		.mid_rid	= 0x3e,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI0_TX,
-		.addr		= 0xee100030,
-		.chcr		= CHCR_TX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xc1,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI0_RX,
-		.addr		= 0xee100030,
-		.chcr		= CHCR_RX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xc2,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI1_TX,
-		.addr		= 0xee120030,
-		.chcr		= CHCR_TX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xc9,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI1_RX,
-		.addr		= 0xee120030,
-		.chcr		= CHCR_RX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xca,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI2_TX,
-		.addr		= 0xee140030,
-		.chcr		= CHCR_TX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xcd,
-	}, {
-		.slave_id	= SHDMA_SLAVE_SDHI2_RX,
-		.addr		= 0xee140030,
-		.chcr		= CHCR_RX(XMIT_SZ_16BIT),
-		.mid_rid	= 0xce,
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
-#define DMAE_CHANNEL(_offset)					\
-	{							\
-		.offset         = _offset - 0x20,		\
-		.dmars          = _offset - 0x20 + 0x40,	\
-	}
-
-static const struct sh_dmae_channel sh73a0_dmae_channels[] = {
-	DMAE_CHANNEL(0x8000),
-	DMAE_CHANNEL(0x8080),
-	DMAE_CHANNEL(0x8100),
-	DMAE_CHANNEL(0x8180),
-	DMAE_CHANNEL(0x8200),
-	DMAE_CHANNEL(0x8280),
-	DMAE_CHANNEL(0x8300),
-	DMAE_CHANNEL(0x8380),
-	DMAE_CHANNEL(0x8400),
-	DMAE_CHANNEL(0x8480),
-	DMAE_CHANNEL(0x8500),
-	DMAE_CHANNEL(0x8580),
-	DMAE_CHANNEL(0x8600),
-	DMAE_CHANNEL(0x8680),
-	DMAE_CHANNEL(0x8700),
-	DMAE_CHANNEL(0x8780),
-	DMAE_CHANNEL(0x8800),
-	DMAE_CHANNEL(0x8880),
-	DMAE_CHANNEL(0x8900),
-	DMAE_CHANNEL(0x8980),
-};
-
-static struct sh_dmae_pdata sh73a0_dmae_platform_data = {
-	.slave          = sh73a0_dmae_slaves,
-	.slave_num      = ARRAY_SIZE(sh73a0_dmae_slaves),
-	.channel        = sh73a0_dmae_channels,
-	.channel_num    = ARRAY_SIZE(sh73a0_dmae_channels),
-	.ts_low_shift   = TS_LOW_SHIFT,
-	.ts_low_mask    = TS_LOW_BIT << TS_LOW_SHIFT,
-	.ts_high_shift  = TS_HI_SHIFT,
-	.ts_high_mask   = TS_HI_BIT << TS_HI_SHIFT,
-	.ts_shift       = dma_ts_shift,
-	.ts_shift_num   = ARRAY_SIZE(dma_ts_shift),
-	.dmaor_init     = DMAOR_DME,
-};
-
 static struct resource sh73a0_dmae_resources[] = {
 	DEFINE_RES_MEM(0xfe000020, 0x89e0),
 	{
@@ -590,13 +413,10 @@ static struct resource sh73a0_dmae_resources[] = {
 };
 
 static struct platform_device dma0_device = {
-	.name		= "sh-dma-engine",
+	.name		= "shdma-sh73a0",
 	.id		= 0,
 	.resource	= sh73a0_dmae_resources,
 	.num_resources	= ARRAY_SIZE(sh73a0_dmae_resources),
-	.dev		= {
-		.platform_data	= &sh73a0_dmae_platform_data,
-	},
 };
 
 /* MPDMAC */
-- 
1.7.2.5

