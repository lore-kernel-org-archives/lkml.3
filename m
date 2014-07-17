Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965252AbaGQQl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:41:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64283 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbaGQQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:39:53 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-7e-53c7fc5699bd
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, santosh.shilimkar@ti.com, tony@atomide.com,
        drake@endlessm.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 3/7] ARM: l2c: Get outer cache .write_sec callback from
 mach_desc only if not NULL
Date: Thu, 17 Jul 2014 18:38:58 +0200
Message-id: <1405615142-21426-4-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
References: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xq7phf44HG3y4qGDxaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtTi3fQuLxdojd9ktXvetYbZY
	P+M1i8WqXX8YLfZf8XLg92hp7mHz+PZ1EovH5b5eJo9F37M8ds66y+5x59oeNo/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGcf7prEXdHNWLNp5gq2B8SJ7FyMnh4SAiUTL
	wwNQtpjEhXvr2boYuTiEBJYySszdcIwFwuljkvi45TYLSBWbgJrE54ZHbCC2iICqxOe2Bewg
	RcwCB5glLmx6AFYkLJAu8aHzF9hYFqCivgsXmUBsXgEnide3pjJBrJOT6N32hhnE5hRwlpi7
	/zHYUCGgmi1tC5gmMPIuYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRES0l93MC49ZnWI
	UYCDUYmH9wfX8WAh1sSy4srcQ4wSHMxKIrzZ94FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGM2X
	yG3V8+rySjKYc+s4syjP/Fx31zUrZgVKnI55nNr/b7HFnxMRB0+eMvhwfBe72fvcjw+dNI9u
	/bL36aP0jvMhOdYJjts8ORpOv9gu2HrIpHTFjglWFWt2O22/5bmyr2/GJrkZPQXfH1svvyB0
	2uODznKZR+x2ET5dWQe7mRdOtO05sCXoQ6ASS3FGoqEWc1FxIgCicTMmRwIAAA==
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

