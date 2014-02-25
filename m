Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaBYKV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:21:29 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:53670 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaBYKVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:21:22 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 2/6] spi: sh-msiof: Move default FIFO sizes to device ID data
Date: Tue, 25 Feb 2014 11:21:09 +0100
Message-Id: <1393323673-2751-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393323673-2751-1-git-send-email-geert@linux-m68k.org>
References: <1393323673-2751-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

As different variants of MSIOF have different FIFO sizes, move the default
FIFO sizes to a new struct sh_msiof_chipdata, pointed to from the device
ID data.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - New

 drivers/spi/spi-sh-msiof.c |   50 ++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index bbe963018e1a..bf389184924d 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 
@@ -29,11 +30,18 @@
 
 #include <asm/unaligned.h>
 
+
+struct sh_msiof_chipdata {
+	u16 tx_fifo_size;
+	u16 rx_fifo_size;
+};
+
 struct sh_msiof_spi_priv {
 	struct spi_bitbang bitbang; /* must be first for spi_bitbang.c */
 	void __iomem *mapbase;
 	struct clk *clk;
 	struct platform_device *pdev;
+	const struct sh_msiof_chipdata *chipdata;
 	struct sh_msiof_spi_info *info;
 	struct completion done;
 	unsigned long flags;
@@ -112,10 +120,6 @@ struct sh_msiof_spi_priv {
 #define STR_REOF	0x00000080 /* Frame Reception End */
 
 
-#define DEFAULT_TX_FIFO_SIZE	64
-#define DEFAULT_RX_FIFO_SIZE	64
-
-
 static u32 sh_msiof_read(struct sh_msiof_spi_priv *p, int reg_offs)
 {
 	switch (reg_offs) {
@@ -659,6 +663,18 @@ static u32 sh_msiof_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
 }
 
 #ifdef CONFIG_OF
+static const struct sh_msiof_chipdata sh_data = {
+	.tx_fifo_size = 64,
+	.rx_fifo_size = 64,
+};
+
+static const struct of_device_id sh_msiof_match[] = {
+	{ .compatible = "renesas,sh-msiof",        .data = &sh_data },
+	{ .compatible = "renesas,sh-mobile-msiof", .data = &sh_data },
+	{},
+};
+MODULE_DEVICE_TABLE(of, sh_msiof_match);
+
 static struct sh_msiof_spi_info *sh_msiof_spi_parse_dt(struct device *dev)
 {
 	struct sh_msiof_spi_info *info;
@@ -693,6 +709,7 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 {
 	struct resource	*r;
 	struct spi_master *master;
+	const struct of_device_id *of_id;
 	struct sh_msiof_spi_priv *p;
 	int i;
 	int ret;
@@ -706,10 +723,15 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 	p = spi_master_get_devdata(master);
 
 	platform_set_drvdata(pdev, p);
-	if (pdev->dev.of_node)
+
+	of_id = of_match_device(sh_msiof_match, &pdev->dev);
+	if (of_id) {
+		p->chipdata = of_id->data;
 		p->info = sh_msiof_spi_parse_dt(&pdev->dev);
-	else
+	} else {
+		p->chipdata = (const void *)pdev->id_entry->driver_data;
 		p->info = dev_get_platdata(&pdev->dev);
+	}
 
 	if (!p->info) {
 		dev_err(&pdev->dev, "failed to obtain device info\n");
@@ -756,11 +778,9 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 	p->pdev = pdev;
 	pm_runtime_enable(&pdev->dev);
 
-	/* The standard version of MSIOF use 64 word FIFOs */
-	p->tx_fifo_size = DEFAULT_TX_FIFO_SIZE;
-	p->rx_fifo_size = DEFAULT_RX_FIFO_SIZE;
-
 	/* Platform data may override FIFO sizes */
+	p->tx_fifo_size = p->chipdata->tx_fifo_size;
+	p->rx_fifo_size = p->chipdata->rx_fifo_size;
 	if (p->info->tx_fifo_override)
 		p->tx_fifo_size = p->info->tx_fifo_override;
 	if (p->info->rx_fifo_override)
@@ -810,18 +830,16 @@ static int sh_msiof_spi_remove(struct platform_device *pdev)
 	return ret;
 }
 
-#ifdef CONFIG_OF
-static const struct of_device_id sh_msiof_match[] = {
-	{ .compatible = "renesas,sh-msiof", },
-	{ .compatible = "renesas,sh-mobile-msiof", },
+static struct platform_device_id spi_driver_ids[] = {
+	{ "spi_sh_msiof",	(kernel_ulong_t)&sh_data },
 	{},
 };
-MODULE_DEVICE_TABLE(of, sh_msiof_match);
-#endif
+MODULE_DEVICE_TABLE(platform, spi_driver_ids);
 
 static struct platform_driver sh_msiof_spi_drv = {
 	.probe		= sh_msiof_spi_probe,
 	.remove		= sh_msiof_spi_remove,
+	.id_table	= spi_driver_ids,
 	.driver		= {
 		.name		= "spi_sh_msiof",
 		.owner		= THIS_MODULE,
-- 
1.7.9.5

