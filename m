Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaDXIxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:53:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46609 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaDXIxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 077/182] mfd: tps65910: Fix possible invalid pointer dereference on regmap_add_irq_chip fail
Date: Thu, 24 Apr 2014 09:50:02 +0100
Message-Id: <1398329507-5911-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/tps65910.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index d792772..de87eaf 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -254,8 +254,10 @@ static int tps65910_irq_init(struct tps65910 *tps65910, int irq,
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
 
-- 
1.9.1

