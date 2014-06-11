Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbaFKPcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:32:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52789 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbaFKPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:30:35 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5c-539876170749
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>, Robin Holt <holt@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 2/5] ARM: Get outer cache .write_sec callback from mach_desc
 only if not NULL
Date: Wed, 11 Jun 2014 17:30:09 +0200
Message-id: <1402500612-4778-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
References: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xy7riZTOCDX5MMrDon9bBatG74Cqb
	xfbOGewWU/4sZ7LY9Pgaq8XlXXPYLGYv6WexmHF+H5PF7cu8Fq/71jBbrJ/xmsVi1a4/jBb7
	r3g58Hq0NPeweXz7OonF43JfL5PHzll32T3uXNvD5rF5Sb1H35ZVjB53r79k8jh+YzuTx+dN
	cgFcUVw2Kak5mWWpRfp2CVwZx/umsRd0c1Ys2nmCrYHxInsXIyeHhICJxOv+XjYIW0ziwr31
	QDYXh5DAUkaJg3+3QTl9TBIndu5gAaliE1CT+NzwCKxDREBV4nPbAnaQImaBvcwSZ2bcYARJ
	CAvES5w6eRxsBQtQ0aJjt4FsDg5eAUeJGTczILbJSfRue8MMYnMKOEk8vdwL1ioEVLJq/UXm
	CYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEhO+XHYyLj1kdYhTgYFTi4eXQmRYs
	xJpYVlyZe4hRgoNZSYS3oHBGsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGbr8STgmrczyeYfcu
	PZ9x0bjkxR+345t3HZqx/QiDWOnrNXuCA2/H9j8WfBsjxBgX3qiqIjZjV6Yim8WmKZutt8nc
	nHvzy6u4qQsum1hujWB+sCWvfXqg85ZpTPZ67/U52qWtaly3q85w5VVfIzLR593sV1ErXknX
	r5VtUMvYe0NfSuZL7j9fJZbijERDLeai4kQADBJWoT0CAAA=
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

