Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400AbaBDWPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:15:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933918AbaBDVIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.12 075/133] mfd: max77686: Fix regmap resource leak on driver remove
Date: Tue,  4 Feb 2014 13:07:56 -0800
Message-Id: <20140204210739.150919219@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 74142ffc0b52cfe6f9d2f6f34a5f3eedbfe3ce51 upstream.

The regmap used by max77686 MFD driver was not freed with regmap_exit()
on driver exit. This lead to leak of resources.

Replace regmap_init_i2c() call in driver probe with initialization of
managed register map so the regmap will be properly freed by the device
management code.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/max77686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -103,7 +103,7 @@ static int max77686_i2c_probe(struct i2c
 	max77686->irq_gpio = pdata->irq_gpio;
 	max77686->irq = i2c->irq;
 
-	max77686->regmap = regmap_init_i2c(i2c, &max77686_regmap_config);
+	max77686->regmap = devm_regmap_init_i2c(i2c, &max77686_regmap_config);
 	if (IS_ERR(max77686->regmap)) {
 		ret = PTR_ERR(max77686->regmap);
 		dev_err(max77686->dev, "Failed to allocate register map: %d\n",


