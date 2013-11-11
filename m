Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3KKRNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:13:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55240 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3KKRNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:13:02 -0500
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
Subject: [PATCH 11/12] mtd: nand: davinci: don't request AEMIF address range
Thread-Topic: [PATCH 11/12] mtd: nand: davinci: don't request AEMIF address
 range
Thread-Index: AQHO3vrrQt+2vfDvxUGUP5iWwJ95X5ogRBx3
Date: Mon, 11 Nov 2013 17:12:24 +0000
Message-ID: <4F5844B3A985794BA902E12C070812375F8D64@DNCE04.ent.ti.com>
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-12-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384187188-5776-12-git-send-email-ivan.khoronzhuk@ti.com>
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

The AEMIF driver registers are used to setup timings for each chip
select. The same registers range is used to setup NAND settings.
The AEMIF and NAND drivers not use the same registers in this range.

In case with AEMIF driver, the memory address range is requested
already by AEMIF, so we cannot request it twice, just ioremap.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/mtd/nand/davinci_nand.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 879e915..bb6b7e5 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -639,9 +639,11 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
        if (IS_ERR(vaddr))
                return PTR_ERR(vaddr);

-       base = devm_ioremap_resource(&pdev->dev, res2);
-       if (IS_ERR(base))
-               return PTR_ERR(base);
+       base = devm_ioremap(&pdev->dev, res2->start, resource_size(res2));
+       if (!base) {
+               dev_err(&pdev->dev, "ioremap failed for resource %pR\n", res2);
+               return -EADDRNOTAVAIL;
+       }

        info->dev               = &pdev->dev;
        info->base              = base;
--
1.7.9.5

