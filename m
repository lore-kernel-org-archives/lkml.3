Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaDGMRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:17:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32200 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaDGMRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:17:41 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-23-534297629a1a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] regulator: s5m8767: Fix carried over ena_gpio assignment
Date: Mon, 07 Apr 2014 14:15:23 +0200
Message-id: <1396872924-14675-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xK7pJ052CDU6+l7XYOGM9q8XUh0/Y
	LF6/MLQ42/SG3eLblQ4mi8u75rBZzDi/j8li7ZG77BYXV3xhslg/4zWLA5fHzll32T02repk
	8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6MnzvvsRXc46y42HSaqYFxGkcXIyeHhICJxMSN
	K5ghbDGJC/fWs3UxcnEICSxllHi55xULhNPHJLHowykWkCo2AWOJzcuXgFWJCGxklDi4/zAr
	SIJZ4DmjxNPv4V2MHBzCAr4Sx+akgoRZBFQlTnRPByvhFXCXuHBjMhtIiYSAgsScSTYTGLkX
	MDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJmy87GBcfszrEKMDBqMTDG3DAMViINbGs
	uDL3EKMEB7OSCK9hl1OwEG9KYmVValF+fFFpTmrxIUYmDk6pBsZK/iTNLma9ek5VlwOTfurs
	1z+ycVOsc6OP8dHP9T4qnko/2wyOHBXZ807eq5Yn7q9jUo2RwjWF1Q/e3XtScnStjHadoby9
	isWi1z6LrRO62tcIzmZ5d03Wv3TVmvn3EyyfaOpFHCz9YfLFzWPjFxvTEJ7H/373eRya6Drd
	e5ki08ras5y3gpRYijMSDbWYi4oTAZw8s+z5AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During registration of regulators if external control for regulator was
set in DTS the ena_gpio and ena_gpio_flags fields of regulator_config
were set to proper values.

However the same regulator_config was used in next iterations of loop so
the ena_gpio fields carried over to next regulators.

The issue was not observed as ena_gpio is supported only for Buck9
regulator which is often the last regulator parsed from DTS.
Be sure to clear ena_gpio config fields before registering the
regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s5m8767.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index f05badabd69e..92f19a005dc3 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -964,6 +964,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		config.driver_data = s5m8767;
 		config.regmap = iodev->regmap_pmic;
 		config.of_node = pdata->regulators[i].reg_node;
+		config.ena_gpio = config.ena_gpio_flags = 0;
 		if (pdata->regulators[i].ext_control_gpio)
 			s5m8767_regulator_config_ext_control(s5m8767,
 					&pdata->regulators[i], &config);
-- 
1.7.9.5

