Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3G2NMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:12:12 -0400
Received: from gloria.sntech.de ([95.129.55.99]:41256 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593Ab3G2NMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:12:09 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 2/6] misc: sram: add ability to mark sram sections as reserved
Date: Mon, 29 Jul 2013 15:12:24 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
References: <201307291510.31679.heiko@sntech.de>
In-Reply-To: <201307291510.31679.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307291512.25126.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SoCs need parts of their sram for special purposes. So while being part
of the peripheral, it should not be part of the genpool controlling the sram.

Therefore add an option mmio-sram-reserved to keep arbitrary portions of the
sram from being part of the pool.

Suggested-by: Rob Herring <robherring2@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
---
Philipp: I didn't carry the ack, because the loop changed significantly again.
So if it looks ok, could you re-ack it please?

 Documentation/devicetree/bindings/misc/sram.txt |    8 ++
 drivers/misc/sram.c                             |  101 +++++++++++++++++++++--
 2 files changed, 101 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/misc/sram.txt b/Documentation/devicetree/bindings/misc/sram.txt
index 4d0a00e..3b7a5c1 100644
--- a/Documentation/devicetree/bindings/misc/sram.txt
+++ b/Documentation/devicetree/bindings/misc/sram.txt
@@ -8,9 +8,17 @@ Required properties:
 
 - reg : SRAM iomem address range
 
+Optional properties:
+
+- mmio-sram-reserved: ordered list of reserved chunks inside the sram that
+  should not be used by the OS.
+  Format is <base size>, <base size>, ...; with base being relative to the
+  reg property base.
+
 Example:
 
 sram: sram@5c000000 {
 	compatible = "mmio-sram";
 	reg = <0x5c000000 0x40000>; /* 256 KiB SRAM at address 0x5c000000 */
+	mmio-sram-reserved = <0x0 0x100>; /* reserve 0x5c000000-0x5c000100 */
 };
diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index afe66571..b3ceefb 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -36,13 +36,23 @@ struct sram_dev {
 	struct clk *clk;
 };
 
+struct sram_reserve {
+	unsigned long start;
+	unsigned long size;
+};
+
 static int sram_probe(struct platform_device *pdev)
 {
 	void __iomem *virt_base;
 	struct sram_dev *sram;
 	struct resource *res;
-	unsigned long size;
-	int ret;
+	unsigned long size, cur_start, cur_size;
+	const __be32 *reserved_list = NULL;
+	int reserved_size = 0;
+	struct sram_reserve *rblocks;
+	unsigned int nblocks;
+	int ret = 0;
+	int i;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	virt_base = devm_ioremap_resource(&pdev->dev, res);
@@ -65,19 +75,94 @@ static int sram_probe(struct platform_device *pdev)
 	if (!sram->pool)
 		return -ENOMEM;
 
-	ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
-				res->start, size, -1);
-	if (ret < 0) {
-		if (sram->clk)
-			clk_disable_unprepare(sram->clk);
-		return ret;
+	if (pdev->dev.of_node) {
+		reserved_list = of_get_property(pdev->dev.of_node,
+						"mmio-sram-reserved",
+						&reserved_size);
+		if (reserved_list) {
+			reserved_size /= sizeof(*reserved_list);
+			if (!reserved_size || reserved_size % 2) {
+				dev_warn(&pdev->dev, "wrong number of arguments in mmio-sram-reserved\n");
+				reserved_list = NULL;
+				reserved_size = 0;
+			}
+		}
 	}
 
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
+	for (i = 0; i < nblocks - 1; i++) {
+		rblocks[i].start = be32_to_cpu(*reserved_list++);
+		rblocks[i].size = be32_to_cpu(*reserved_list++);
+
+		dev_dbg(&pdev->dev, "found reserved block 0x%lx-0x%lx\n",
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
+		/* catch unsorted list entries */
+		if (rblocks[i].start < cur_start) {
+			dev_err(&pdev->dev,
+				"unsorted reserved list (0x%lx before current 0x%lx)\n",
+				rblocks[i].start, cur_start);
+			ret = -EINVAL;
+			goto err_chunks;
+		}
+
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
1.7.10.4

