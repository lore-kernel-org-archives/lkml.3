Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaHTOke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:40:34 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:29704 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaHTOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:40:32 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        Mark Brown <broonie@kernel.org>,
        Himangi Saraogi <himangi774@gmail.com>, <linux-spi@vger.kernel.org>,
        <linux-mips@linux-mips.org>
Subject: [PATCH] SPI: spi-au1550: Fix build problem in au1550_spi_remove
Date: Wed, 20 Aug 2014 15:40:13 +0100
Message-ID: <1408545613-28348-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 2.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 30670539b867 ("spi: au1550: Fix bug in deallocation of memory")
switched from release_resource to release_mem_region to release
memory regions allocated using the request_mem_region. However,
a build problem was introduced due to 'r' being undefined in that
function. We fix this by having 'r' being defined as the platform's
IORESROUCE_MEM region.

This fixes a problem triggered by the db1xxx defconfig in the MIPS tree:

drivers/spi/spi-au1550.c: In function 'au1550_spi_remove':
drivers/spi/spi-au1550.c:948:21: error: 'r' undeclared (first use in this
							function)
release_mem_region(r->start, sizeof(psc_spi_t));

Cc: Mark Brown <broonie@kernel.org>
Cc: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-spi@vger.kernel.org
Cc: linux-mips@linux-mips.org
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
This has only been compile tested
---
 drivers/spi/spi-au1550.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-au1550.c b/drivers/spi/spi-au1550.c
index 40c3d43c9292..f7edb504df78 100644
--- a/drivers/spi/spi-au1550.c
+++ b/drivers/spi/spi-au1550.c
@@ -937,6 +937,7 @@ err_nomem:
 
 static int au1550_spi_remove(struct platform_device *pdev)
 {
+	struct resource *r;
 	struct au1550_spi *hw = platform_get_drvdata(pdev);
 
 	dev_info(&pdev->dev, "spi master remove: bus_num=%d\n",
@@ -945,6 +946,13 @@ static int au1550_spi_remove(struct platform_device *pdev)
 	spi_bitbang_stop(&hw->bitbang);
 	free_irq(hw->irq, hw);
 	iounmap((void __iomem *)hw->regs);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "no mmio resource\n");
+		return -ENODEV;
+	}
+
 	release_mem_region(r->start, sizeof(psc_spi_t));
 
 	if (hw->usedma) {
-- 
2.0.4

