Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbbALKIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:08:06 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:39131 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbbALKIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:08:02 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-gpio@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] gpio: rcar: Fix error path for devm_kzalloc() failure
Date: Mon, 12 Jan 2015 11:07:58 +0100
Message-Id: <1421057279-16081-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421057279-16081-1-git-send-email-geert+renesas@glider.be>
References: <1421057279-16081-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the call to devm_kzalloc() fails, nothing must be cleant up.
This was missed before because gpio_rcar_probe() had a "return"
statement after the first "goto err0".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: df0c6c80232f2ad4 ("gpio: rcar: Add minimal runtime PM support")
---
 drivers/gpio/gpio-rcar.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-rcar.c b/drivers/gpio/gpio-rcar.c
index 584484e3f1e3cd1d..ca2b6310f8f709d3 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -372,10 +372,8 @@ static int gpio_rcar_probe(struct platform_device *pdev)
 	int ret;
 
 	p = devm_kzalloc(dev, sizeof(*p), GFP_KERNEL);
-	if (!p) {
-		ret = -ENOMEM;
-		goto err0;
-	}
+	if (!p)
+		return -ENOMEM;
 
 	p->pdev = pdev;
 	spin_lock_init(&p->lock);
-- 
1.9.1

