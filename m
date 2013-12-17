Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3LQNiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:38:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42748 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3LQNiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:38:05 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v4 2/9] mtd: nand: davinci: return ENOMEM if memory allocation is failed
Date: Tue, 17 Dec 2013 15:36:05 +0200
Message-ID: <1387287365-19731-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case when memory allocation is failed the driver should return
ENOMEM instead of ENODEV.

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Taras Kondratiuk <taras@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/mtd/nand/davinci_nand.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 584c1f4..4577fb4 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -541,7 +541,7 @@ static struct davinci_nand_pdata
 				GFP_KERNEL);
 		pdev->dev.platform_data = pdata;
 		if (!pdata)
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 		if (!of_property_read_u32(pdev->dev.of_node,
 			"ti,davinci-chipselect", &prop))
 			pdev->id = prop;
@@ -598,6 +598,9 @@ static int nand_davinci_probe(struct platform_device *pdev)
 	nand_ecc_modes_t		ecc_mode;
 
 	pdata = nand_davinci_get_pdata(pdev);
+	if (IS_ERR(pdata))
+		return PTR_ERR(pdata);
+
 	/* insist on board-specific configuration */
 	if (!pdata)
 		return -ENODEV;
-- 
1.7.9.5

