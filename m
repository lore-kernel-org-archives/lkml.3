Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaEBPmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:42:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43893 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaEBPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 076/151] mfd: tps65910: Fix possible invalid pointer dereference on regmap_add_irq_chip fail
Date: Fri,  2 May 2014 08:37:44 -0700
Message-Id: <1399045139-4531-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/tps65910.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index c0f608e..2ab9166 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -255,8 +255,10 @@ static int tps65910_irq_init(struct tps65910 *tps65910, int irq,
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

