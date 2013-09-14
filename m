Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3INA6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 20:58:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38197 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab3INA6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 20:58:01 -0400
Message-ID: <5233B471.40603@ti.com>
Date: Fri, 13 Sep 2013 19:57:21 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>, Jyri Sarah <jsarha@ti.com>,
        Koen Kooi <koen@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v3] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1378839171-14455-1-git-send-email-joelf@ti.com> <5231903F.7080301@ti.com>
In-Reply-To: <5231903F.7080301@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 04:58 AM, Sekhar Nori wrote:
> On Wednesday 11 September 2013 12:22 AM, Joel Fernandes wrote:
>> HWMOD removal for MMC is breaking edma_start as the events are being manually
>> triggered due to unused channel list not being clear.
[..]
> It is better to send one version with all comments fixed. Helps avoid
> confusion.

Ok, here is the final version with all comments fixed, please apply this one:

--->8---
From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH v4] ARM: EDMA: Fix clearing of unused list for DT DMA resources

HWMOD removal for MMC is breaking edma_start as the events are being manually
triggered due to unused channel list not being clear.

This patch fixes the issue, by reading the "dmas" property from the DT node if
it exists and clearing the bits in the unused channel list. For this purpose
we use the of_* helpers to parse the arguments in the dmas phandle list.

Reviewed-by: Sekhar Nori <nsekhar@ti.com>
Reported-by: Balaji T K <balajitk@ti.com>
Cc: Pantel Antoniou <panto@antoniou-consulting.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
Changes since v1, in v2 and v3:
- Reduced indentation of non-of case by returning from of-case
- Using of_* helpers for parsing

Note:
This patch should go into the merge window as it is a critical bug fix.

 arch/arm/common/edma.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 39ad030..43c7b22 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -560,14 +560,33 @@ static int reserve_contiguous_slots(int ctlr, unsigned int
id,
 static int prepare_unused_channel_list(struct device *dev, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	int i, ctlr;
+	int i, count, ctlr;
+	struct of_phandle_args  dma_spec;

+	if (dev->of_node) {
+		count = of_property_count_strings(dev->of_node, "dma-names");
+		if (count < 0)
+			return 0;
+		for (i = 0; i < count; i++) {
+			if (of_parse_phandle_with_args(dev->of_node, "dmas",
+						       "#dma-cells", i,
+						       &dma_spec))
+				continue;
+
+			ctlr = EDMA_CTLR(dma_spec.args[0]);
+			clear_bit(EDMA_CHAN_SLOT(dma_spec.args[0]),
+				  edma_cc[ctlr]->edma_unused);
+		}
+		return 0;
+	}
+
+	/* For non-OF case */
 	for (i = 0; i < pdev->num_resources; i++) {
 		if ((pdev->resource[i].flags & IORESOURCE_DMA) &&
 				(int)pdev->resource[i].start >= 0) {
 			ctlr = EDMA_CTLR(pdev->resource[i].start);
 			clear_bit(EDMA_CHAN_SLOT(pdev->resource[i].start),
-					edma_cc[ctlr]->edma_unused);
+				  edma_cc[ctlr]->edma_unused);
 		}
 	}

-- 
1.8.1.2

