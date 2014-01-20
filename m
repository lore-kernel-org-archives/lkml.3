Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaATPoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:44:21 -0500
Received: from gloria.sntech.de ([95.129.55.99]:36605 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaATPoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:44:19 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: arm@kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: [PATCH v7 3/7] misc: sram: implement mmio-sram-reserved option
Date: Mon, 20 Jan 2014 16:43:44 +0100
Message-ID: <2232854.mna0r8nSuv@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <4970034.fqvMoHdOyd@phil>
References: <4970034.fqvMoHdOyd@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements support for the mmio-sram-reserved option to keep the
genpool from using these areas.

Suggested-by: Rob Herring <robherring2@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
---
 drivers/misc/sram.c |  121 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 113 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index afe66571..8681961 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -36,13 +36,23 @@ struct sram_dev {
 	struct clk *clk;
 };
 
+struct sram_reserve {
+	u32 start;
+	u32 size;
+};
+
 static int sram_probe(struct platform_device *pdev)
 {
 	void __iomem *virt_base;
 	struct sram_dev *sram;
 	struct resource *res;
-	unsigned long size;
-	int ret;
+	struct device_node *np = pdev->dev.of_node;
+	unsigned long size, cur_start, cur_size;
+	int reserved_size = 0;
+	struct sram_reserve *rblocks;
+	unsigned int nblocks;
+	int ret = 0;
+	int i;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	virt_base = devm_ioremap_resource(&pdev->dev, res);
@@ -65,19 +75,114 @@ static int sram_probe(struct platform_device *pdev)
 	if (!sram->pool)
 		return -ENOMEM;
 
-	ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
-				res->start, size, -1);
-	if (ret < 0) {
-		if (sram->clk)
-			clk_disable_unprepare(sram->clk);
-		return ret;
+	if (np) {
+		reserved_size = of_property_count_u32_elems(np,
+							"mmio-sram-reserved");
+
+		/* mmio-sram-reserved is optional, so its absence is no error */
+		if (reserved_size < 0)
+			reserved_size = 0;
+
+		if (reserved_size % 2) {
+			dev_warn(&pdev->dev, "wrong number of arguments in mmio-sram-reserved\n");
+			reserved_size = 0;
+		}
+	}
+
+	/*
+	 * We need an additional block to mark the end of the memory region
+	 * after the reserved blocks from the dt are processed.
+	 */
+	nblocks = reserved_size / 2 + 1;
+	rblocks = kmalloc((nblocks) * sizeof(*rblocks), GFP_KERNEL);
+	if (!rblocks) {
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	cur_start = 0;
+	for (i = 0; i < nblocks - 1; i++) {
+		/* checked the property exists above so can skip return vals */
+		of_property_read_u32_index(np, "mmio-sram-reserved",
+					   2 * i, &rblocks[i].start);
+		of_property_read_u32_index(np, "mmio-sram-reserved",
+					   2 * i + 1, &rblocks[i].size);
+
+		if (rblocks[i].start < cur_start) {
+			dev_err(&pdev->dev,
+				"unsorted reserved list (0x%x before current 0x%lx)\n",
+				rblocks[i].start, cur_start);
+			ret = -EINVAL;
+			goto err_chunks;
+		}
+
+		if (rblocks[i].start >= size) {
+			dev_err(&pdev->dev,
+				"reserved block at 0x%x outside the sram size 0x%lx\n",
+				rblocks[i].start, size);
+			ret = -EINVAL;
+			goto err_chunks;
+		}
+
+		if (rblocks[i].start + rblocks[i].size > size) {
+			dev_warn(&pdev->dev,
+				 "reserved block at 0x%x to large, trimming\n",
+				 rblocks[i].start);
+			rblocks[i].size = size - rblocks[i].start;
+		}
+
+		cur_start = rblocks[i].start + rblocks[i].size;
+
+		dev_dbg(&pdev->dev, "found reserved block 0x%x-0x%x\n",
+			rblocks[i].start,
+			rblocks[i].start + rblocks[i].size);
+	}
+
+	/* the last chunk marks the end of the region */
+	rblocks[nblocks - 1].start = size;
+	rblocks[nblocks - 1].size = 0;
+
+	cur_start = 0;
+	for (i = 0; i < nblocks; i++) {
+		/* current start is in a reserved block, so continue after it */
+		if (rblocks[i].start == cur_start) {
+			cur_start = rblocks[i].start + rblocks[i].size;
+			continue;
+		}
+
+		/*
+		 * allocate the space between the current starting
+		 * address and the following reserved block, or the
+		 * end of the region.
+		 */
+		cur_size = rblocks[i].start - cur_start;
+
+		dev_dbg(&pdev->dev, "adding chunk 0x%lx-0x%lx\n",
+			cur_start, cur_start + cur_size);
+		ret = gen_pool_add_virt(sram->pool,
+				(unsigned long)virt_base + cur_start,
+				res->start + cur_start, cur_size, -1);
+		if (ret < 0)
+			goto err_chunks;
+
+		/* next allocation after this reserved block */
+		cur_start = rblocks[i].start + rblocks[i].size;
 	}
 
+	kfree(rblocks);
+
 	platform_set_drvdata(pdev, sram);
 
 	dev_dbg(&pdev->dev, "SRAM pool: %ld KiB @ 0x%p\n", size / 1024, virt_base);
 
 	return 0;
+
+err_chunks:
+	kfree(rblocks);
+err_alloc:
+	if (sram->clk)
+		clk_disable_unprepare(sram->clk);
+	return ret;
 }
 
 static int sram_remove(struct platform_device *pdev)
-- 
1.7.10.4


