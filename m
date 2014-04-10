Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbaDJTW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:22:26 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39820 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaDJTWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:22:24 -0400
From: Matt Porter <mporter@linaro.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Arnd Bergmann <arnd@arndb.de>, Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] hwrng: bcm2835: fix oops when rng h/w is accessed during registration
Date: Thu, 10 Apr 2014 15:22:10 -0400
Message-Id: <1397157730-31161-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "d9e7972 hwrng: add randomness to system from rng sources"
exposed a bug in the bcm2835-rng driver resulting in boot failure
on Raspberry Pi due to the following oops:

[   28.261523] BUG: soft lockup - CPU#0 stuck for 23s! [swapper:1]
[   28.271058]
[   28.275958] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0+ #11
[   28.285374] task: db480000 ti: db484000 task.ti: db484000
[   28.294279] PC is at bcm2835_rng_read+0x28/0x48
[   28.302276] LR is at hwrng_register+0x1a8/0x238
.
.
.

The RNG h/w is not completely initialized and enabled before
hwrng_register() is called and so the bcm2835_rng_read() fails.
Fix this by making the warmup/enable writes before registering
the RNG source with the hwrng core.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 drivers/char/hw_random/bcm2835-rng.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 8c3b255..e900961 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -61,18 +61,18 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	}
 	bcm2835_rng_ops.priv = (unsigned long)rng_base;
 
+	/* set warm-up count & enable */
+	__raw_writel(RNG_WARMUP_COUNT, rng_base + RNG_STATUS);
+	__raw_writel(RNG_RBGEN, rng_base + RNG_CTRL);
+
 	/* register driver */
 	err = hwrng_register(&bcm2835_rng_ops);
 	if (err) {
 		dev_err(dev, "hwrng registration failed\n");
 		iounmap(rng_base);
-	} else {
+	} else
 		dev_info(dev, "hwrng registered\n");
 
-		/* set warm-up count & enable */
-		__raw_writel(RNG_WARMUP_COUNT, rng_base + RNG_STATUS);
-		__raw_writel(RNG_RBGEN, rng_base + RNG_CTRL);
-	}
 	return err;
 }
 
-- 
1.8.4

