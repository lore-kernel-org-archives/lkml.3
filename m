Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaJJIWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:22:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35770 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaJJIWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:22:16 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-14-543797360000
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH fixes 1/2] mfd: max77693: Use proper regmap for handling MUIC
 interrupts
Date: Fri, 10 Oct 2014 10:22:01 +0200
Message-id: <1412929322-21908-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xa7pm081DDN7t47HYOGM9q8X1L89Z
	LV6/MLQ42/SG3eL+16OMFpd3zWGzWHvkLrvF7cYVbBanu1ktFmx8xOjA5XHn2h42j3knAz36
	tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY9+6x+wFXzgr3jb/ZmxgXMDRxcjJISFgInF80zZW
	CFtM4sK99WxdjFwcQgJLGSVWfVvABOH0MUlcnP2DGaSKTcBYYvPyJWBVIgK7GSW+7V0EVsUs
	cJdRovnue8YuRg4OYYEoiWnfCkAaWARUJXY/W88EYvMKuEt8PLUXap2cxMljk1knMHIvYGRY
	xSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESNl93MC49ZnWIUYCDUYmH94KMeYgQa2JZcWXu
	IUYJDmYlEV59U6AQb0piZVVqUX58UWlOavEhRiYOTqkGRtO+H2kHnLlUNDSmcYlHCYXazJTu
	vzKdU37/x8VsrRMb7S+sux/sFNG7IUHYl5/35c980y/9U3f2u9S+5Sv8/swwUf0/T4Plx3cl
	RoJ++p4pStpJx/fvrfH4cO5vwwrr9FbutPsyLwulv6ceDheVbDr8yV1TsPmY/5boFZabLovn
	2toaGFoosRRnJBpqMRcVJwIAKbxyNfkBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupts coming from Maxim77693 MUIC block (MicroUSB Interface
Controller) were not handled at all because wrong regmap was used for
MUIC's regmap_irq_chip.

The MUIC component of Maxim 77693 uses different I2C address thus second
regmap is created and used by max77693 extcon driver. The registers for
MUIC interrupts are also in that block and should be handled by that
second regmap.

However the regmap irq chip for MUIC was configured with default regmap
which could not read MUIC registers.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
---
 drivers/mfd/max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 2277a11b6629..4b54da1ff7ab 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -243,7 +243,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 		goto err_irq_charger;
 	}
 
-	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
+	ret = regmap_add_irq_chip(max77693->regmap_muic, max77693->irq,
 				IRQF_ONESHOT | IRQF_SHARED |
 				IRQF_TRIGGER_FALLING, 0,
 				&max77693_muic_irq_chip,
-- 
1.9.1

