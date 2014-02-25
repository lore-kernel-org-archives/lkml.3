Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaBYLrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:47:22 -0500
Received: from gloria.sntech.de ([95.129.55.99]:33610 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaBYLrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:47:20 -0500
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
Subject: [PATCH v8 2/6] misc: sram: implement reserved sram areas
Date: Tue, 25 Feb 2014 12:46:34 +0100
Message-ID: <8769537.NUv9SMRkyo@phil>
User-Agent: KMail/4.11.5 (Linux/3.12-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <21117503.1c6iOkvYSr@phil>
References: <21117503.1c6iOkvYSr@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements support for defining reserved areas as subnodes,
to keep the genpool from using these.

Suggested-by: Rob Herring <robherring2@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
---
 drivers/misc/sram.c | 125 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 118 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index afe66571..674b0cd 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -24,6 +24,9 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/list.h>
+#include <linux/list_sort.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -36,14 +39,35 @@ struct sram_dev {
 	struct clk *clk;
 };
 
+struct sram_reserve {
+	struct list_head list;
+	u32 start;
+	u32 size;
+};
+
+static int sram_reserve_cmp(void *priv, struct list_head *a,
+					struct list_head *b)
+{
+	struct sram_reserve *ra = list_entry(a, struct sram_reserve, list);
+	struct sram_reserve *rb = list_entry(b, struct sram_reserve, list);
+
+	return ra->start - rb->start;
+}
+
 static int sram_probe(struct platform_device *pdev)
 {
 	void __iomem *virt_base;
 	struct sram_dev *sram;
 	struct resource *res;
-	unsigned long size;
+	struct device_node *np = pdev->dev.of_node, *child;
+	unsigned long size, cur_start, cur_size;
+	struct sram_reserve *rblocks, *block;
+	struct list_head reserve_list;
+	unsigned int nblocks;
 	int ret;
 
+	INIT_LIST_HEAD(&reserve_list);
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	virt_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(virt_base))
@@ -65,19 +89,106 @@ static int sram_probe(struct platform_device *pdev)
 	if (!sram->pool)
 		return -ENOMEM;
 
-	ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
-				res->start, size, -1);
-	if (ret < 0) {
-		if (sram->clk)
-			clk_disable_unprepare(sram->clk);
-		return ret;
+	/*
+	 * We need an additional block to mark the end of the memory region
+	 * after the reserved blocks from the dt are processed.
+	 */
+	nblocks = (np) ? of_get_available_child_count(np) + 1 : 1;
+	rblocks = kmalloc((nblocks) * sizeof(*rblocks), GFP_KERNEL);
+	if (!rblocks) {
+		ret = -ENOMEM;
+		goto err_alloc;
 	}
 
+	block = &rblocks[0];
+	for_each_available_child_of_node(np, child) {
+		struct resource child_res;
+
+		ret = of_address_to_resource(child, 0, &child_res);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"could not get address for node %s\n",
+				child->full_name);
+			goto err_chunks;
+		}
+
+		if (child_res.start < res->start || child_res.end > res->end) {
+			dev_err(&pdev->dev,
+				"reserved block %s outside the sram area\n",
+				child->full_name);
+			ret = -EINVAL;
+			goto err_chunks;
+		}
+
+		block->start = child_res.start - res->start;
+		block->size = resource_size(&child_res);
+		list_add_tail(&block->list, &reserve_list);
+
+		dev_dbg(&pdev->dev, "found reserved block 0x%x-0x%x\n",
+			block->start,
+			block->start + block->size);
+
+		block++;
+	}
+
+	/* the last chunk marks the end of the region */
+	rblocks[nblocks - 1].start = size;
+	rblocks[nblocks - 1].size = 0;
+	list_add_tail(&rblocks[nblocks - 1].list, &reserve_list);
+
+	list_sort(NULL, &reserve_list, sram_reserve_cmp);
+
+	cur_start = 0;
+
+	list_for_each_entry(block, &reserve_list, list) {
+		/* can only happen if sections overlap */
+		if (block->start < cur_start) {
+			dev_err(&pdev->dev,
+				"block at 0x%x starts after current offset 0x%lx\n",
+				block->start, cur_start);
+			ret = -EINVAL;
+			goto err_chunks;
+		}
+
+		/* current start is in a reserved block, so continue after it */
+		if (block->start == cur_start) {
+			cur_start = block->start + block->size;
+			continue;
+		}
+
+		/*
+		 * allocate the space between the current starting
+		 * address and the following reserved block, or the
+		 * end of the region.
+		 */
+		cur_size = block->start - cur_start;
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
+		cur_start = block->start + block->size;
+	}
+
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
1.8.5.3


