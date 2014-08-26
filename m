Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbaHZOSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:18:15 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23792 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657AbaHZOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:18:12 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-dc-53fc971f369b
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v4 3/7] ARM: l2c: Get outer cache .write_sec callback from
 mach_desc only if not NULL
Date: Tue, 26 Aug 2014 16:17:56 +0200
Message-id: <1409062680-15906-4-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
In-reply-to: <1409062680-15906-1-git-send-email-t.figa@samsung.com>
References: <1409062680-15906-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xK7ry0/8EG8xYI2HxaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtTi3fQuLxdojd9ktXvetYbZY
	P+M1i8WqXX8YLfZf8XLg92hp7mHz+PZ1EovH5b5eJo9F37M8ds66y+5x59oeNo/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGY/aT7IUdHNWfHzymqWB8SJ7FyMnh4SAiUT7
	uxesELaYxIV769m6GLk4hASWMkq0vPjMCOH0MUlc2XeKCaSKTUBN4nPDIzYQW0RAVeJz2wKw
	ScwCB5gl2lcGgNjCAukSvzdvYwGxWYBqVs44BjSIg4NXwEli6Z5oiGVyEqs27gMbySngLLHn
	Sx8ziC0EVPJk/z72CYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEhPOXHYyLj1kd
	YhTgYFTi4f1Q8jtYiDWxrLgy9xCjBAezkgjvj6Q/wUK8KYmVValF+fFFpTmpxYcYmTg4pRoY
	jW1mn17mWcpj22cu1iK0f39PKusudz6ZTxcTM9wTFvWY5//e/f7M7i2JVWJ3v3slfdk8pTxn
	jtwq/3W6QhosUc6R15dmvZuxRHqXmfnz0J97OBmuxK79f7V0P9vVVZlPmgXW/rk5XdTtqXWJ
	zsH4hLKU787LLryenXT/YJSpz6x5LHyaymVBSizFGYmGWsxFxYkAn6SyqkUCAAA=
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
2.0.4

