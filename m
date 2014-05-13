Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbaEMKGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:06:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60796 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760062AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 043/182] mfd: tps65910: Fix possible invalid pointer dereference on regmap_add_irq_chip fail
Date: Tue, 13 May 2014 11:26:35 +0200
Message-Id: <3ddfbfde82ad5c0447ad9064194d8c34a498f3eb.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/tps65910.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index d79277204835..de87eafbeb05 100644
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
1.9.3

