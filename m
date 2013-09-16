Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3IPQ1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:27:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60617 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3IPQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:27:28 -0400
Message-ID: <5237314D.7080102@ti.com>
Date: Mon, 16 Sep 2013 11:26:53 -0500
From: Joel Fernandes <joelf@ti.com>
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
References: <1378839171-14455-1-git-send-email-joelf@ti.com> <5231903F.7080301@ti.com> <5233B471.40603@ti.com> <5236F00B.5040605@ti.com>
In-Reply-To: <5236F00B.5040605@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 06:48 AM, Sekhar Nori wrote:
> Hi Joel,
> 
> On Saturday 14 September 2013 06:27 AM, Joel Fernandes wrote:
>> From: Joel Fernandes <joelf@ti.com>
>> Subject: [PATCH v4] ARM: EDMA: Fix clearing of unused list for DT DMA resources
>>
>> HWMOD removal for MMC is breaking edma_start as the events are being manually
>> triggered due to unused channel list not being clear.
>>
>> This patch fixes the issue, by reading the "dmas" property from the DT node if
>> it exists and clearing the bits in the unused channel list. For this purpose
>> we use the of_* helpers to parse the arguments in the dmas phandle list.
>>
>> Reviewed-by: Sekhar Nori <nsekhar@ti.com>
>> Reported-by: Balaji T K <balajitk@ti.com>
>> Cc: Pantel Antoniou <panto@antoniou-consulting.com>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>> Changes since v1, in v2 and v3:
>> - Reduced indentation of non-of case by returning from of-case
>> - Using of_* helpers for parsing
>>
>> Note:
>> This patch should go into the merge window as it is a critical bug fix.
> 
> I still cannot find any users of edma in the device tree sources either
> in linux-next or linus/master. Why cannot this wait until v3.13?

I understand this affects only DT users of EDMA. But I get so many private
reports of breakage due to this patch not being there that I think it will save
everyone a lot of pain, specially folks creating integration trees to have this
patch available by default.

Further, EDMA DT enabling is surely to go in for 3.13, so its best if this is
applied in advance here.

I feel we shouldn't leave code intentionally broken just because it is not yet
enabled in DTS, specially when it is about to be enabled in DT. For example, a
potential problem is MMC/SD file system corruption due to DMA failure.

>>  arch/arm/common/edma.c | 23 +++++++++++++++++++++--
>>  1 file changed, 21 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
>> index 39ad030..43c7b22 100644
>> --- a/arch/arm/common/edma.c
>> +++ b/arch/arm/common/edma.c
>> @@ -560,14 +560,33 @@ static int reserve_contiguous_slots(int ctlr, unsigned int
>> id,
>>  static int prepare_unused_channel_list(struct device *dev, void *data)
>>  {
>>  	struct platform_device *pdev = to_platform_device(dev);
>> -	int i, ctlr;
>> +	int i, count, ctlr;
>> +	struct of_phandle_args  dma_spec;
>>
>> +	if (dev->of_node) {
>> +		count = of_property_count_strings(dev->of_node, "dma-names");
>> +		if (count < 0)
>> +			return 0;
>> +		for (i = 0; i < count; i++) {
>> +			if (of_parse_phandle_with_args(dev->of_node, "dmas",
>> +						       "#dma-cells", i,
>> +						       &dma_spec))
>> +				continue;
> 
> This will break for the case where devices on platform bus use non-EDMA
> dma controllers like SDMA or CPPI (DRA7x has both EDMA and SDMA on the
> same chip). You need to do an additional check to make sure the dma
> controller is indeed EDMA. Something like.

Ok, edma is probed earlier so I could never see any problem.
Thanks for pointing this out,

Using the below method is more future-proof than using compatible literal
strings directly. The only problem is the matches table has to be defined
earlier in the sources. What do you think?

                        if (!of_match_node(edma_of_ids, dma_spec.np) {
                                of_node_put(dma_spec.np);
                                continue;
                        }


> 	if(!of_device_is_compatible(dma_spec.np, "ti,edma3"))
> 		continue;
> 
> Don forget to call of_node_put() on dma_spec.np (something that needs to
> be done even with your current code).

Ok, will do.


>> +
>> +			ctlr = EDMA_CTLR(dma_spec.args[0]);
>> +			clear_bit(EDMA_CHAN_SLOT(dma_spec.args[0]),
>> +				  edma_cc[ctlr]->edma_unused);
> 
> We don't support the second controller when using DT and the controller
> number is not really encoded in the argument to edma phandle. So just
> simplify this to:
> 
> 	clear_bit(EDMA_CHAN_SLOT(dma_spec.args[0]), 	
> 		  edma_cc[0]->edma_unused);

I think let's not make that assumption just incase in the future we support more
than one EDMA controller for DT-based boot. Is that ok?

> 
>> +		}
>> +		return 0;
>> +	}
>> +
>> +	/* For non-OF case */
>>  	for (i = 0; i < pdev->num_resources; i++) {
>>  		if ((pdev->resource[i].flags & IORESOURCE_DMA) &&
>>  				(int)pdev->resource[i].start >= 0) {
>>  			ctlr = EDMA_CTLR(pdev->resource[i].start);
>>  			clear_bit(EDMA_CHAN_SLOT(pdev->resource[i].start),
>> -					edma_cc[ctlr]->edma_unused);
>> +				  edma_cc[ctlr]->edma_unused);
> 
> This is a useful change and I am okay with it happening in this
> otherwise unrelated patch, but please mention this in changelog.

Below is the updated version (v5), can you check and let me know if you had any
other comments?

---8<---
From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH v5] ARM: EDMA: Fix clearing of unused list for DT DMA resources

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
Changes since v4:
- Using of_node_put on dma_spec's node pointer.
- Update changelog with minor cleanup information.

Changes since v1, in v2 and v3:
 - Reduced indentation of non-of case by returning from of-case
 - Using of_* helpers for parsing

 arch/arm/common/edma.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 117f955..8b5c6ed 100644
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
@@ -560,14 +565,39 @@ static int reserve_contiguous_slots(int ctlr, unsigned int id,
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
+			ctlr = EDMA_CTLR(dma_spec.args[0]);
+			clear_bit(EDMA_CHAN_SLOT(dma_spec.args[0]),
+				  edma_cc[ctlr]->edma_unused);
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

@@ -1762,11 +1792,6 @@ static int edma_probe(struct platform_device *pdev)
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

