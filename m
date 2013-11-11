Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3KKQ7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:59:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54556 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab3KKQ7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:59:12 -0500
From: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: [PATCH 02/12] mtd: nand: davinci: check required
 ti,davinci-chipselect property
Thread-Topic: [PATCH 02/12] mtd: nand: davinci: check required
 ti,davinci-chipselect property
Thread-Index: AQHO3vrZ4sHrhGoyukSgxUh+/VCT/JogPuIi
Date: Mon, 11 Nov 2013 16:53:17 +0000
Message-ID: <4F5844B3A985794BA902E12C070812375F8CEF@DNCE04.ent.ti.com>
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-3-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384187188-5776-3-git-send-email-ivan.khoronzhuk@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The property "ti,davinci-chipselect" is required. So we have to check
if it is set.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/mtd/nand/davinci_nand.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index d87213f..8e1c88e 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -541,10 +541,14 @@ static struct davinci_nand_pdata
                                GFP_KERNEL);
                pdev->dev.platform_data = pdata;
                if (!pdata)
-                       return NULL;
+                       return ERR_PTR(-ENOMEM);
+
                if (!of_property_read_u32(pdev->dev.of_node,
                        "ti,davinci-chipselect", &prop))
                        pdev->id = prop;
+               else
+                       return ERR_PTR(-EINVAL);
+
                if (!of_property_read_u32(pdev->dev.of_node,
                        "ti,davinci-mask-ale", &prop))
                        pdata->mask_ale = prop;
@@ -598,6 +602,10 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
        nand_ecc_modes_t                ecc_mode;

        pdata = nand_davinci_get_pdata(pdev);
+       if (IS_ERR(pdata)) {
+               return PTR_ERR(pdata);
+       }
+
        /* insist on board-specific configuration */
        if (!pdata)
                return -ENODEV;
--
1.7.9.5

