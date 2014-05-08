Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaEHPAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:00:33 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:64496 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbaEHPA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:00:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Wan ZongShun <mcuos.com@gmail.org>,
        Marek Vasut <marek.vasut@gmail.com>, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] i2c/nuc900: fix ancient build error
Date: Thu,  8 May 2014 16:56:22 +0200
Message-Id: <1399560990-1402858-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:vPGV36aVeifuOJ93XJLz2yRmKCZF4IONY19+S485GPE
 SJGN802WxMJk6j6CKWM0Mvdg/G10xvaJFZPPRAO9vkIhjCbH7f
 mlXE0Kl0X3SBtiNowVUdMtP1e3O5E1EbE+I0Mon8qbPsYu0I7o
 kk1ht2S5MmiotT4NoRQVZd0dftabYj6CaDP4AZzsAA7gYXo/qH
 UmdzcsrtwKeddBFZThHCytbqsOvd872XW2AjF5qLHwzdsenG1F
 r5FAXiHlkMFo/0v2fVuNSeMFKTWqz/WJZ/MoV3HeiMaOc+6XvG
 eVyfJpVMmjRU0OdT3Wk6k0zYwVU0o9TFnSCBc6kU80LiYaKBHR
 EXG2RBiHdwYO3A3FL4p2uOn1TGNN0/FmZpUpeMuBx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can tell, this driver must have produced this error
for as long as it has been merged into the mainline kernel, but
it was never part of the normal build tests:

drivers/i2c/busses/i2c-nuc900.c: In function 'nuc900_i2c_probe':
drivers/i2c/busses/i2c-nuc900.c:601:17: error: request for member 'apbfreq' in something not a structure or union
  ret = (i2c->clk.apbfreq)/(pdata->bus_freq * 5) - 1;
                 ^

This is an attempt to get the driver to build and possibly
work correctly, although I do wonder whether we should just
remove it, as it has clearly never worked.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.org>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Baruch Siach <baruch@tkos.co.il>
---
 drivers/i2c/busses/i2c-nuc900.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-nuc900.c b/drivers/i2c/busses/i2c-nuc900.c
index 36394d7..e3e9f95 100644
--- a/drivers/i2c/busses/i2c-nuc900.c
+++ b/drivers/i2c/busses/i2c-nuc900.c
@@ -598,7 +598,7 @@ static int nuc900_i2c_probe(struct platform_device *pdev)
 
 	clk_get_rate(i2c->clk);
 
-	ret = (i2c->clk.apbfreq)/(pdata->bus_freq * 5) - 1;
+	ret = clk_get_rate(i2c->clk)/(pdata->bus_freq * 5) - 1;
 	writel(ret & 0xffff, i2c->regs + DIVIDER);
 
 	/* find the IRQ for this unit (note, this relies on the init call to
-- 
1.8.3.2

