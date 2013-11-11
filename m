Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3KKRLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:11:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45336 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab3KKRLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:11:40 -0500
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
Subject: [PATCH 10/12] mtd: nand: davinci: don't set timings if AEMIF is used
Thread-Topic: [PATCH 10/12] mtd: nand: davinci: don't set timings if AEMIF
 is used
Thread-Index: AQHO3vrjIGD+7RTiekG2UEZPLijDWpogQ8eQ
Date: Mon, 11 Nov 2013 17:10:53 +0000
Message-ID: <4F5844B3A985794BA902E12C070812375F8D53@DNCE04.ent.ti.com>
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-11-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384187188-5776-11-git-send-email-ivan.khoronzhuk@ti.com>
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

If Davinci AEMIF is used we don't need to set timings and bus width.
It is done by AEMIF driver (drivers/memory/davinci-aemfi.c).

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/mtd/nand/davinci_nand.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 4705214..879e915 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -742,27 +742,35 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
                goto err_clk_enable;
        }

+#if !IS_ENABLED(CONFIG_TI_DAVINCI_AEMIF)
        /*
-        * Setup Async configuration register in case we did not boot from
-        * NAND and so bootloader did not bother to set it up.
+        * Setup Async configuration register in case we did not boot
+        * from NAND and so bootloader did not bother to set it up.
         */
-       val = davinci_nand_readl(info, A1CR_OFFSET + info->core_chipsel * 4);
+       val = davinci_nand_readl(info, A1CR_OFFSET +
+                                info->core_chipsel * 4);

-       /* Extended Wait is not valid and Select Strobe mode is not used */
+       /*
+        * Extended Wait is not valid and Select Strobe mode is not
+        * used
+        */
        val &= ~(ACR_ASIZE_MASK | ACR_EW_MASK | ACR_SS_MASK);
        if (info->chip.options & NAND_BUSWIDTH_16)
                val |= 0x1;

-       davinci_nand_writel(info, A1CR_OFFSET + info->core_chipsel * 4, val);
+       davinci_nand_writel(info, A1CR_OFFSET +
+                           info->core_chipsel * 4, val);

        ret = 0;
        if (info->timing)
-               ret = davinci_aemif_setup_timing(info->timing, info->base,
-                                                       info->core_chipsel);
+               ret = davinci_aemif_setup_timing(info->timing,
+                                                info->base,
+                                                info->core_chipsel);
        if (ret < 0) {
                dev_dbg(&pdev->dev, "NAND timing values setup fail\n");
                goto err;
        }
+#endif

        spin_lock_irq(&davinci_nand_lock);

--
1.7.9.5

