Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3IQObo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:31:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56170 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab3IQObl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:31:41 -0400
Message-ID: <52386733.8010807@ti.com>
Date: Tue, 17 Sep 2013 09:29:07 -0500
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
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v3] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1378839171-14455-1-git-send-email-joelf@ti.com> <5231903F.7080301@ti.com> <5233B471.40603@ti.com> <5236F00B.5040605@ti.com> <5237314D.7080102@ti.com> <5237E3C3.8050602@ti.com> <5237EAF3.70505@ti.com> <5237F147.1020302@ti.com>
In-Reply-To: <5237F147.1020302@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 01:05 AM, Sekhar Nori wrote:
[..]
>>> mixed messages. In short, we aim for consistency with situation today,
>>> not tomorrow.
>>
>> What you're asking to do infact breaks consistency with the rest of the code.
> 
> Well, ideally we support second CC even with DT to be consistent all
> around. Since that has not happened, I don't want the code to pretend
> that it it supports the second channel controller with DT that too only
> in parts of code.

Ok, I agree that the bindings don't talk about encoding a controller number in
the channel provided from DT so it shouldn't assume that without binding
updates. Following this suggestion, I've update the patch to the below:

---8<---
From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH v6] ARM: EDMA: Fix clearing of unused list for DT DMA resources

HWMOD removal for MMC is breaking edma_start as the events are being manually
triggered due to unused channel list not being clear.

The above issue is fixed by reading the "dmas" property from the DT node if it
exists and clearing the bits in the unused channel list if the dma controller
used by any device is EDMA. For this purpose we use the of_* helpers to parse
the arguments in the dmas phandle list.

Also introduced is a minor clean up of a checkpatch error in old code.

Reviewed-by: Sekhar Nori <nsekhar@ti.com>
Reported-by: Balaji T K <balajitk@ti.com>
Cc: Pantel Antoniou <panto@antoniou-consulting.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
Changes since initial version:
- Using of_node_put on dma_spec's node pointer.
- Update changelog with minor cleanup information.
- For DT-case, set controller number as 0.
- Reduced indentation of non-of case by returning from of-case
- Using of_* helpers for parsing

 arch/arm/common/edma.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 117f955..8e1a024 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -269,6 +269,11 @@ static const struct edmacc_param dummy_paramset = {
 	.ccnt = 1,
 };

+static const struct of_device_id edma_of_ids[] = {
+	{ .compatible = "ti,edma3", },
+	{}
+};
+
 /*****************************************************************************/

 static void map_dmach_queue(unsigned ctlr, unsigned ch_no,
@@ -560,14 +565,38 @@ static int reserve_contiguous_slots(int ctlr, unsigned int id,
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
+			if (!of_match_node(edma_of_ids, dma_spec.np)) {
+				of_node_put(dma_spec.np);
+				continue;
+			}
+
+			clear_bit(EDMA_CHAN_SLOT(dma_spec.args[0]),
+				  edma_cc[0]->edma_unused);
+			of_node_put(dma_spec.np);
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

@@ -1762,11 +1791,6 @@ static int edma_probe(struct platform_device *pdev)
 	return 0;
 }

-static const struct of_device_id edma_of_ids[] = {
-	{ .compatible = "ti,edma3", },
-	{}
-};
-
 static struct platform_driver edma_driver = {
 	.driver = {
 		.name	= "edma",
-- 
1.8.1.2


