Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbaFYNiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:38:23 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30113 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaFYNiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:38:19 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-91-53aad0c818a1
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 2/6] ARM: Get outer cache .write_sec callback from mach_desc
 only if not NULL
Date: Wed, 25 Jun 2014 15:37:27 +0200
Message-id: <1403703451-12233-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
References: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xK7onLqwKNmjrMrd4NP8xs0Xvgqts
	Fts7Z7BbTPmznMli0+NrrBaXd81hs5i9pJ/FYsb5fUwWty/zWqw9cpfd4nXfGmaL9TNes1is
	2vWH0WL/FS8HPo+W5h42j29fJ7F4XO7rZfJY9D3LY+esu+wed67tYfPYvKTeo2/LKkaP4ze2
	M3l83iQXwBXFZZOSmpNZllqkb5fAlXG8bxp7QTdnxaKdJ9gaGC+ydzFyckgImEicO/uVCcIW
	k7hwbz1bFyMXh5DAUkaJj53fmCCcPiaJRXNvsYJUsQmoSXxueMQGYosIqEp8blvADlLELNDA
	InGl9TpYQlggSaLl4XKwFSxARY9mPwdq5uDgFXCS6F1qDbFNTqJ32xtmEJtTwFniwrw/YPOF
	gErmPTnCOIGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkDD+uoNx6TGrQ4wCHIxK
	PLwBPKuChVgTy4orcw8xSnAwK4nwuu8HCvGmJFZWpRblxxeV5qQWH2Jk4uCUamDkmR2m+eje
	DwkXrZz8ay0B51rlN3ReL+3yCfXoXuqyqd0zYuGuicteeJm+XqQZtq7qhPWSrpsL/oYs+LdH
	rLco8FP7tYyIcyzl0pyJGXILBC6KHvjMrJDmefX6yyW6C5yTlF+4ffvAI2wu0LQx1Vbeh/Mg
	08obUtWaG+dzy21e81HCeuZOX1YlluKMREMt5qLiRADkoZlPQQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain platforms (i.e. Exynos) might need to set .write_sec callback
from firmware initialization which is happenning in .init_early callback
of machine descriptor. However current code will overwrite the pointer
with whatever is present in machine descriptor, even though it can be
already set earlier. This patch fixes this by making the assignment
conditional, depending on whether current .write_sec callback is NULL.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/kernel/irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 2c42576..e7383b9 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -125,7 +125,8 @@ void __init init_IRQ(void)
 
 	if (IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_CACHE_L2X0) &&
 	    (machine_desc->l2c_aux_mask || machine_desc->l2c_aux_val)) {
-		outer_cache.write_sec = machine_desc->l2c_write_sec;
+		if (!outer_cache.write_sec)
+			outer_cache.write_sec = machine_desc->l2c_write_sec;
 		ret = l2x0_of_init(machine_desc->l2c_aux_val,
 				   machine_desc->l2c_aux_mask);
 		if (ret)
-- 
1.9.3

