Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbaD3ICH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:02:07 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55796 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaD3ICD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:02:03 -0400
From: Toby Smith <toby@tismith.id.au>
To: linus.walleij@linaro.org, gnurou@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Toby Smith <toby@tismith.id.au>
Subject: [PATCH 1/2] gpio: pca953x: return IRQ_NONE when appropriate
Date: Wed, 30 Apr 2014 18:01:40 +1000
Message-Id: <5ca82b7dd4c17ea358a1ea30bb34a3e31828b2b2.1398844809.git.toby@tismith.id.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1398844809.git.toby@tismith.id.au>
References: <cover.1398844809.git.toby@tismith.id.au>
In-Reply-To: <cover.1398844809.git.toby@tismith.id.au>
References: <cover.1398844809.git.toby@tismith.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq handler should return IRQ_NONE or IRQ_HANDLED to report
if we have handled the interrupt.

Signed-off-by: Toby Smith <toby@tismith.id.au>
---
 drivers/gpio/gpio-pca953x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index d550d8e..83cc2c8 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -503,10 +503,11 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 	struct pca953x_chip *chip = devid;
 	u8 pending[MAX_BANK];
 	u8 level;
+	unsigned nhandled = 0;
 	int i;
 
 	if (!pca953x_irq_pending(chip, pending))
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 
 	for (i = 0; i < NBANK(chip); i++) {
 		while (pending[i]) {
@@ -514,10 +515,11 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 			handle_nested_irq(irq_find_mapping(chip->domain,
 							level + (BANK_SZ * i)));
 			pending[i] &= ~(1 << level);
+			nhandled++;
 		}
 	}
 
-	return IRQ_HANDLED;
+	return (nhandled > 0) ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int pca953x_gpio_irq_map(struct irq_domain *d, unsigned int irq,
-- 
1.8.3.2

