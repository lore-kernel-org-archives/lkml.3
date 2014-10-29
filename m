Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbaJ2JZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:25:36 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46382 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbaJ2JXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:23:16 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-e0-5450b1feae47
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org, tony@atomide.com,
        drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v7 3/8] ARM: l2c: Get outer cache .write_sec callback from
 mach_desc only if not NULL
Date: Wed, 29 Oct 2014 10:22:56 +0100
Message-id: <1414574581-2320-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
References: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xy7r/NgaEGKzeKWHxaP5jZoveBVfZ
	LM42vWG32N45g91iyp/lTBabHl9jtbi8aw6bxewl/SwWM87vY7K4fZnX4tz2LSwWa4/cZbdY
	ev0ik8WqXX8YLfZf8XLg91gzbw2jR0tzD5vHt6+TWDwu9/UyeSz6nuWxc9Zddo871/aweWxe
	Uu/Rt2UVo8fnTXIBXFFcNimpOZllqUX6dglcGfe/3GIr+M1ZseDrP6YGxq0cXYycHBICJhLt
	G5cwQ9hiEhfurWfrYuTiEBJYyihxq2UFO0hCSKCPSeLZrzIQm03AUKLrbRcbiC0ikC3x49tk
	FpAGZoE+Zonz03vAJgkLpEs867zKAmKzCKhKvJ94F8jm4OAVcJf4+FoWYpmcxP+XK5hAbE4B
	D4nVF5awQexyl9h4uJttAiPvAkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxgh4fxlB+Pi
	Y1aHGAU4GJV4eDV2+4cIsSaWFVfmHmKU4GBWEuHdYR4QIsSbklhZlVqUH19UmpNafIiRiYNT
	qoGR7z9jWV3VsWui1/JE9h1nZHdNLdUNS1FnTHXn3Vt6ZmePqp9y6p0Jew9OkfHdZtn4eTu7
	rJXN/i8LPXmVjq0U/BJ8ouJ4s4nugQPXv5xqWWJoMS980+E1c1xdm2S/h7/IZo2o+dZnfuxk
	x4eGP1Iez5a/3sSrHpc+M6L//7PwTZ++b/l07IWZEktxRqKhFnNRcSIAqkhKBUUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Certain platforms (i.e. Exynos) might need to set .write_sec callback
from firmware initialization which is happenning in .init_early callback
of machine descriptor. However current code will overwrite the pointer
with whatever is present in machine descriptor, even though it can be
already set earlier. This patch fixes this by making the assignment
conditional, depending on whether current .write_sec callback is NULL.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/kernel/irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 7c81ec428b9b..5acb8aef6f2d 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -108,7 +108,8 @@ void __init init_IRQ(void)
 
 	if (IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_CACHE_L2X0) &&
 	    (machine_desc->l2c_aux_mask || machine_desc->l2c_aux_val)) {
-		outer_cache.write_sec = machine_desc->l2c_write_sec;
+		if (!outer_cache.write_sec)
+			outer_cache.write_sec = machine_desc->l2c_write_sec;
 		ret = l2x0_of_init(machine_desc->l2c_aux_val,
 				   machine_desc->l2c_aux_mask);
 		if (ret)
-- 
1.9.2

