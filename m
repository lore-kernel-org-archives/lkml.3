Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710AbaJ3L0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:26:09 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59728 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113AbaJ3LVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:25 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-3c-54521f32cbf1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFT v3 05/14] regulator: max77802: Don't ignore return value of
 current opmode
Date: Thu, 30 Oct 2014 12:20:44 +0100
Message-id: <1414668053-31370-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xq7pG8kEhBs/XcFhsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK6D+5k71gFmdF06OFLA2MB9i7
	GDk5JARMJI7fnsYGYYtJXLi3Hsjm4hASWMoo0TP3CyOE08ckMf1bNwtIFZuAscTm5UvAqkQE
	Opkleg72MoM4zAKrmSR+XjkF5HBwCAtESTzcKwTSwCKgKjF5/T+wFbwC7hJ7lq6BWi0ncfLY
	ZFYQm1PAQ2LNx3ZWkFYhoJp737QnMPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRES
	4F92MC4+ZnWIUYCDUYmH12FjQIgQa2JZcWXuIUYJDmYlEd7VYkEhQrwpiZVVqUX58UWlOanF
	hxiZODilGhiVNtncU3XjS581QevqRFFf+3mt5QrnSqIC9l4qY41N0z4lxaNlGvCk2vDGnW+H
	6mZW8BRPjW6MEpld/6H4u8e3a/MWJR7NS7baxuKdHvrU6tkt9y2vu9ZGXy5uEWFRmXNR5Pfn
	J6/Slx5w/b9tdZv22VcvReatkZtR7MSsuyTuWppC5KZTGZOUWIozEg21mIuKEwG2MnSwTgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of regmap_read() of current opmode for regulator was
silently ignored and whatever happened to be in 'val' variable was used
as new opmode. This could lead to using bogus opmode.

Don't ignore what regmap_read() returns. If it fails just fall back to
normal opmode.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77802.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index b9958d927297..60daca2028e9 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -606,7 +606,13 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 		config.of_node = pdata->regulators[i].of_node;
 
 		ret = regmap_read(iodev->regmap, regulators[i].enable_reg, &val);
-		val = val >> shift & MAX77802_OPMODE_MASK;
+		if (ret < 0) {
+			dev_warn(&pdev->dev,
+				"cannot read current mode for %d\n", i);
+			val = MAX77802_OPMODE_NORMAL;
+		} else {
+			val = val >> shift & MAX77802_OPMODE_MASK;
+		}
 
 		/*
 		 * If the regulator is disabled and the system warm rebooted,
-- 
1.9.1

