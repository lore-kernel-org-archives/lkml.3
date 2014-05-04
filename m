Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaEDQvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:51:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaEDPl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.14 048/158] mfd: tps65910: Fix possible invalid pointer dereference on regmap_add_irq_chip fail
Date: Sun,  4 May 2014 11:39:17 -0400
Message-Id: <20140504154036.520950454@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 483e2dfdbc94751430e41db9973985f5b054d322 upstream.

Fixes: 4aab3fadad32 ("mfd: tps65910: Move interrupt implementation code to mfd file")

tps65910_irq_init() sets 'tps65910->chip_irq' before calling
regmap_add_irq_chip(). If the regmap_add_irq_chip() call fails in
memory allocation of regmap_irq_chip_data members then:

1. The 'tps65910->chip_irq' will still hold some value
2. 'tps65910->irq_data' will be pointing to already freed memory
   (because regmap_add_irq_chip() will free it on error)

This results in invalid memory access during driver remove because the
tps65910_irq_exit() tests whether 'tps65910->chip_irq' is not zero.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/tps65910.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -255,8 +255,10 @@ static int tps65910_irq_init(struct tps6
 	ret = regmap_add_irq_chip(tps65910->regmap, tps65910->chip_irq,
 		IRQF_ONESHOT, pdata->irq_base,
 		tps6591x_irqs_chip, &tps65910->irq_data);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_warn(tps65910->dev, "Failed to add irq_chip %d\n", ret);
+		tps65910->chip_irq = 0;
+	}
 	return ret;
 }
 


