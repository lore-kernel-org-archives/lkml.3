Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbbANHQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:16:38 -0500
Received: from mail-bl2on0084.outbound.protection.outlook.com ([65.55.169.84]:23184
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750964AbbANHQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:16:37 -0500
X-Greylist: delayed 894 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 02:16:36 EST
From: Hao Liang <hliang1025@gmail.com>
To: <scott.jiang.linux@gmail.com>, <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Hao.Liang@analog.com>, <adi-buildroot-devel@lists.sourceforge.net>,
        "Hao Liang" <hliang1025@gmail.com>
Subject: [PATCH] BLACKFIN MEDIA DRIVER: rewrite the blackfin style of read/write into common style
Date: Wed, 14 Jan 2015 14:57:33 +0800
Message-ID: <1421218653-16165-1-git-send-email-hliang1025@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130656924998039210;(52f37747-95c3-483a-bd05-08d153b03fac);()
Authentication-Results: spf=softfail (sender IP is 137.71.25.57)
 smtp.mailfrom=hliang1025@gmail.com; 
X-Forefront-Antispam-Report: CIP:137.71.25.57;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(61266001)(47776003)(64706001)(87792001)(50226001)(87572001)(50986999)(87936001)(229853001)(106466001)(76482003)(77156002)(62966003)(33646002)(73972006)(81442002)(83322999)(77096005)(92566002)(55446002)(50466002)(48376002)(105596002)(575784001)(86362001)(46102003)(73392002)(19580395003)(82202001)(36756003)(19580405001)(6806004)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB0746;H:nwd2mta2.analog.com;FPR:;SPF:SoftFail;MLV:sfv;PTR:nwd2mail11.analog.com;MX:1;A:1;LANG:en;
X-DmarcStatus-Test: Failed
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3004003)(3005003);SRVR:CY1PR0301MB0746;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0746;
X-Forefront-PRVS: 04569283F9
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(400003)(401002);SRVR:CY1PR0301MB0746;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2015 07:01:39.3671
 (UTC)
X-MS-Exchange-CrossTenant-Id: 5afe0b00-7697-4969-b663-5eab37d5f47e
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5afe0b00-7697-4969-b663-5eab37d5f47e;Ip=[137.71.25.57]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0746
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hao Liang <hliang1025@gmail.com>
---
 drivers/media/platform/blackfin/ppi.c |   72 ++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
index cff63e5..de4b5c7 100644
--- a/drivers/media/platform/blackfin/ppi.c
+++ b/drivers/media/platform/blackfin/ppi.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
+#include <linux/io.h>
 
 #include <asm/bfin_ppi.h>
 #include <asm/blackfin.h>
@@ -59,10 +60,10 @@ static irqreturn_t ppi_irq_err(int irq, void *dev_id)
 		/* register on bf561 is cleared when read 
 		 * others are W1C
 		 */
-		status = bfin_read16(&reg->status);
+		status = readw(&reg->status);
 		if (status & 0x3000)
 			ppi->err = true;
-		bfin_write16(&reg->status, 0xff00);
+		writew(0xff00, &reg->status);
 		break;
 	}
 	case PPI_TYPE_EPPI:
@@ -70,10 +71,10 @@ static irqreturn_t ppi_irq_err(int irq, void *dev_id)
 		struct bfin_eppi_regs *reg = info->base;
 		unsigned short status;
 
-		status = bfin_read16(&reg->status);
+		status = readw(&reg->status);
 		if (status & 0x2)
 			ppi->err = true;
-		bfin_write16(&reg->status, 0xffff);
+		writew(0xffff, &reg->status);
 		break;
 	}
 	case PPI_TYPE_EPPI3:
@@ -81,10 +82,10 @@ static irqreturn_t ppi_irq_err(int irq, void *dev_id)
 		struct bfin_eppi3_regs *reg = info->base;
 		unsigned long stat;
 
-		stat = bfin_read32(&reg->stat);
+		stat = readl(&reg->stat);
 		if (stat & 0x2)
 			ppi->err = true;
-		bfin_write32(&reg->stat, 0xc0ff);
+		writel(0xc0ff, &reg->stat);
 		break;
 	}
 	default:
@@ -139,26 +140,25 @@ static int ppi_start(struct ppi_if *ppi)
 	case PPI_TYPE_PPI:
 	{
 		struct bfin_ppi_regs *reg = info->base;
-		bfin_write16(&reg->control, ppi->ppi_control);
+		writew(ppi->ppi_control, &reg->control);
 		break;
 	}
 	case PPI_TYPE_EPPI:
 	{
 		struct bfin_eppi_regs *reg = info->base;
-		bfin_write32(&reg->control, ppi->ppi_control);
+		writel(ppi->ppi_control, &reg->control);
 		break;
 	}
 	case PPI_TYPE_EPPI3:
 	{
 		struct bfin_eppi3_regs *reg = info->base;
-		bfin_write32(&reg->ctl, ppi->ppi_control);
+		writel(ppi->ppi_control, &reg->ctl);
 		break;
 	}
 	default:
 		return -EINVAL;
 	}
 
-	SSYNC();
 	return 0;
 }
 
@@ -172,19 +172,19 @@ static int ppi_stop(struct ppi_if *ppi)
 	case PPI_TYPE_PPI:
 	{
 		struct bfin_ppi_regs *reg = info->base;
-		bfin_write16(&reg->control, ppi->ppi_control);
+		writew(ppi->ppi_control, &reg->control);
 		break;
 	}
 	case PPI_TYPE_EPPI:
 	{
 		struct bfin_eppi_regs *reg = info->base;
-		bfin_write32(&reg->control, ppi->ppi_control);
+		writel(ppi->ppi_control, &reg->control);
 		break;
 	}
 	case PPI_TYPE_EPPI3:
 	{
 		struct bfin_eppi3_regs *reg = info->base;
-		bfin_write32(&reg->ctl, ppi->ppi_control);
+		writel(ppi->ppi_control, &reg->ctl);
 		break;
 	}
 	default:
@@ -195,7 +195,6 @@ static int ppi_stop(struct ppi_if *ppi)
 	clear_dma_irqstat(info->dma_ch);
 	disable_dma(info->dma_ch);
 
-	SSYNC();
 	return 0;
 }
 
@@ -242,9 +241,9 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 		if (params->ppi_control & DMA32)
 			dma32 = 1;
 
-		bfin_write16(&reg->control, ppi->ppi_control);
-		bfin_write16(&reg->count, samples_per_line - 1);
-		bfin_write16(&reg->frame, params->frame);
+		writew(ppi->ppi_control, &reg->control);
+		writew(samples_per_line - 1, &reg->count);
+		writew(params->frame, &reg->frame);
 		break;
 	}
 	case PPI_TYPE_EPPI:
@@ -255,13 +254,13 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 			|| (params->ppi_control & 0x38000) > DLEN_16)
 			dma32 = 1;
 
-		bfin_write32(&reg->control, ppi->ppi_control);
-		bfin_write16(&reg->line, samples_per_line);
-		bfin_write16(&reg->frame, params->frame);
-		bfin_write16(&reg->hdelay, hdelay);
-		bfin_write16(&reg->vdelay, params->vdelay);
-		bfin_write16(&reg->hcount, hcount);
-		bfin_write16(&reg->vcount, params->height);
+		writel(ppi->ppi_control, &reg->control);
+		writew(samples_per_line, &reg->line);
+		writew(params->frame, &reg->frame);
+		writew(hdelay, &reg->hdelay);
+		writew(params->vdelay, &reg->vdelay);
+		writew(hcount, &reg->hcount);
+		writew(params->height, &reg->vcount);
 		break;
 	}
 	case PPI_TYPE_EPPI3:
@@ -272,15 +271,15 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 			|| (params->ppi_control & 0x70000) > DLEN_16)
 			dma32 = 1;
 
-		bfin_write32(&reg->ctl, ppi->ppi_control);
-		bfin_write32(&reg->line, samples_per_line);
-		bfin_write32(&reg->frame, params->frame);
-		bfin_write32(&reg->hdly, hdelay);
-		bfin_write32(&reg->vdly, params->vdelay);
-		bfin_write32(&reg->hcnt, hcount);
-		bfin_write32(&reg->vcnt, params->height);
+		writel(ppi->ppi_control, &reg->ctl);
+		writel(samples_per_line, &reg->line);
+		writel(params->frame, &reg->frame);
+		writel(hdelay, &reg->hdly);
+		writel(params->vdelay, &reg->vdly);
+		writel(hcount, &reg->hcnt);
+		writel(params->height, &reg->vcnt);
 		if (params->int_mask)
-			bfin_write32(&reg->imsk, params->int_mask & 0xFF);
+			writel(params->int_mask & 0xFF, &reg->imsk);
 		if (ppi->ppi_control & PORT_DIR) {
 			u32 hsync_width, vsync_width, vsync_period;
 
@@ -288,10 +287,10 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 					* params->bpp / params->dlen;
 			vsync_width = params->vsync * samples_per_line;
 			vsync_period = samples_per_line * params->frame;
-			bfin_write32(&reg->fs1_wlhb, hsync_width);
-			bfin_write32(&reg->fs1_paspl, samples_per_line);
-			bfin_write32(&reg->fs2_wlvb, vsync_width);
-			bfin_write32(&reg->fs2_palpf, vsync_period);
+			writel(hsync_width, &reg->fs1_wlhb);
+			writel(samples_per_line, &reg->fs1_paspl);
+			writel(vsync_width, &reg->fs2_wlvb);
+			writel(vsync_period, &reg->fs2_palpf);
 		}
 		break;
 	}
@@ -313,7 +312,6 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 	set_dma_y_count(info->dma_ch, params->height);
 	set_dma_config(info->dma_ch, dma_config);
 
-	SSYNC();
 	return 0;
 }
 
-- 
1.7.9.5

