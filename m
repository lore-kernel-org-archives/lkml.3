Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3K1IKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:10:14 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18940 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3K1IKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:10:00 -0500
X-AuditID: cbfec7f4-b7fea6d0000026ac-62-5296fa54b89d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/5] rtc: s5m: Fix unsuccesful IRQ request during probe
Date: Thu, 28 Nov 2013 09:09:40 +0100
Message-id: <1385626183-22990-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t/xK7qhv6YFGdzQslhy8Sq7xdSHT9gs
	nt3ay2Tx+oWhxdmmN+wW978eZbT4dqWDyeLyrjlsFmuP3GW32N/ZwWhxupvV4uKKL0wOPB47
	Z91l99gz8SSbx6ZVnWwed67tYfM4dLiD0WPeyUCPvi2rGD2mz/vJ5PF5k1wAZxSXTUpqTmZZ
	apG+XQJXxslv19gKVnJUXG3/ztrA+J6ti5GTQ0LAROLjjN1MELaYxIV764HiXBxCAksZJTY/
	+c0M4fQxSbR+esEKUsUmYCyxefkSsCoRgblMEtPfnmUEcZgFdjFKvP25ixGkSljAS2LRtEYW
	EJtFQFVi8eEusH28Au4Stw6eArI5gPYpSMyZZAMS5hTwkNgzfx/YAiGgkp+f57BNYORdwMiw
	ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkVL/sYFx8zOoQowAHoxIP7wHNaUFCrIllxZW5
	hxglOJiVRHgVioFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGCfd5xUXXXEvbPX7lpf9p9S2hJw1
	aeLqrtSbfnTmJBt2xmjXNSUptvc3dyZ5duV+vP6Nbfqj+49fT0yZqt5+1+dsUcxkroc6bet9
	GHf9mMa2P09iks6RFDuHvYsvne8pevBCxd/deqK12TLtiRqXKrM8U862eZ9jMXfQv2+/anN6
	odmMw64+x5RYijMSDbWYi4oTAfiPtkQzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probe failed for rtc-s5m:
	s5m-rtc s5m-rtc: Failed to request alarm IRQ: 12: -22
	s5m-rtc: probe of s5m-rtc failed with error -22

Fix rtc-s5m interrupt request by using regmap_irq_get_virq() for mapping
the IRQ.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/rtc-s5m.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 088cf3a..66686d9 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -548,11 +548,13 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 
 	switch (pdata->device_type) {
 	case S5M8763X:
-		info->irq = s5m87xx->irq_base + S5M8763_IRQ_ALARM0;
+		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
+				S5M8763_IRQ_ALARM0);
 		break;
 
 	case S5M8767X:
-		info->irq = s5m87xx->irq_base + S5M8767_IRQ_RTCA1;
+		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
+				S5M8767_IRQ_RTCA1);
 		break;
 
 	default:
-- 
1.7.9.5

