Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaJVIp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:45:57 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9713 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaJVIpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:45:50 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-5d-54476ebc1491
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 1/3] extcon: max77693: Remove left-over code after
 switching to regmap irq chip
Date: Wed, 22 Oct 2014 10:45:38 +0200
Message-id: <1413967540-27626-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t/xq7p78txDDM4+47PYOGM9q8X1L89Z
	LV6/MLQ42/SG3eL+16OMFpd3zWGzWHvkLrvF7cYVbBanu1kdOD3uXNvD5jHvZKBH35ZVjB6f
	N8kFsERx2aSk5mSWpRbp2yVwZez9f5O54JRwxanLm9gaGGcLdDFyckgImEhs/ziVDcIWk7hw
	bz2QzcUhJLCUUeLOrp+sEE4fk0TTueXMIFVsAsYSm5cvAasSEdjNKPFt7yImEIdZ4CijxPTe
	t0wgVcICGRLTJp5mAbFZBFQl9p24DRbnFXCXWPtlNxPEPjmJk8cms05g5F7AyLCKUTS1NLmg
	OCk910ivODG3uDQvXS85P3cTIyRcvu5gXHrM6hCjAAejEg+vA5t7iBBrYllxZe4hRgkOZiUR
	3nvpQCHelMTKqtSi/Pii0pzU4kOMTBycUg2Mq5fr+E64sOeFaN32CdrK11r1l783tpDTjkrc
	vOvWTg72/WUMxRP2ROx8Ms3n6lwef21nmcvvg9orVVbtfNtm+W0Zl7Zi4aRHUh0N/iwGH56t
	LH3kvG5x6OfVHkos5oGHPrz78+Oo2bGNHnmrb39IYOf78Pd19jIT5W1ca448/tv1Y1/9eoYJ
	DUosxRmJhlrMRcWJANEGXPn1AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before switching to regmap irq chip the extcon driver parsed some
initialization data (from platform data or defaults hard coded in the
driver) and adjusted interrupt masks to the init data (code was located
in max77693-irq.c).

However commit 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
removed the max77693-irq.c and replaced whole interrupt handling with
regmap irq chip. Thus the part responsible for using adjusted interrupt
masks disappeared.

Remove left-over code as this is now useless and it is doing nothing.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max77693.c     | 21 +--------------------
 include/linux/mfd/max77693-private.h |  3 ---
 2 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 490e27475bac..863d088c9bdd 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1201,28 +1201,9 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < num_init_data; i++) {
-		enum max77693_irq_source irq_src
-				= MAX77693_IRQ_GROUP_NR;
-
 		regmap_write(info->max77693->regmap_muic,
 				init_data[i].addr,
 				init_data[i].data);
-
-		switch (init_data[i].addr) {
-		case MAX77693_MUIC_REG_INTMASK1:
-			irq_src = MUIC_INT1;
-			break;
-		case MAX77693_MUIC_REG_INTMASK2:
-			irq_src = MUIC_INT2;
-			break;
-		case MAX77693_MUIC_REG_INTMASK3:
-			irq_src = MUIC_INT3;
-			break;
-		}
-
-		if (irq_src < MAX77693_IRQ_GROUP_NR)
-			info->max77693->irq_masks_cur[irq_src]
-				= init_data[i].data;
 	}
 
 	if (pdata && pdata->muic_data) {
@@ -1259,7 +1240,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Set initial path for UART */
-	 max77693_muic_set_path(info, info->path_uart, true);
+	max77693_muic_set_path(info, info->path_uart, true);
 
 	/* Check revision number of MUIC device*/
 	ret = regmap_read(info->max77693->regmap_muic,
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 08dae01258b9..bad716a659d3 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -439,9 +439,6 @@ struct max77693_dev {
 
 	int irq;
 	int irq_gpio;
-	struct mutex irqlock;
-	int irq_masks_cur[MAX77693_IRQ_GROUP_NR];
-	int irq_masks_cache[MAX77693_IRQ_GROUP_NR];
 };
 
 enum max77693_types {
-- 
1.9.1

