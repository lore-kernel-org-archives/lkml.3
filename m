Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaJ0LGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:06:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35498 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaJ0LGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:06:01 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-68-544e271526e6
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v6 3/7] ARM: l2c: Get outer cache .write_sec callback from
 mach_desc only if not NULL
Date: Mon, 27 Oct 2014 12:05:46 +0100
Message-id: <1414407950-3029-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
References: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xK7qi6n4hBge/KFo8mv+Y2aJ3wVU2
	i7NNb9gttnfOYLeY8mc5k8Wmx9dYLS7vmsNmMXtJP4vFjPP7mCxuX+a1OLd9C4vF2iN32S2W
	Xr/IZPG6bw2zxapdfxgt9l/xchDwWDNvDaNHS3MPm8e3r5NYPC739TJ5LPqe5bFz1l12jzvX
	9rB5bF5S79G3ZRWjx/Eb25k8Pm+SC+CO4rJJSc3JLEst0rdL4Mq4/+UWW8FvzooFX/8xNTBu
	5ehi5OSQEDCRaLx7lBHCFpO4cG89WxcjF4eQwFJGidt/prBDOH1MEicuNDODVLEJGEp0ve1i
	A7FFBLIlfnybzAJSxCywilliyoF1rCAJYYF0iQmT7rOD2CwCqhJPj89jAbF5Bdwlzp+exAqx
	Tk7i/8sVTCA2p4CHxOSWmWC2EFDNqg97GScw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpec
	n7uJERLmX3YwLj5mdYhRgINRiYd3xzTfECHWxLLiytxDjBIczEoivI4/gUK8KYmVValF+fFF
	pTmpxYcYmTg4pRoYzf7PnrsmnmFZ9pJDXmt3TArkU3ErueWfsdFArkg91/TrOtHl+xKTVa6x
	N8fJ5hyO5to/9XBR+vor+2ZMnuWcHXl64oyN3TdfRp9ZL2XuLHjmyuHelqP53axzYrqf2Td+
	Tf1gOjflvL7sw5Xvqv+IWNg7iu5ZxrlrdvyFTYWZkokGCjOflnoVKbEUZyQaajEXFScCAALa
	NrdRAgAA
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

