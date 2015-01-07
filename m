Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbbAGLcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:32:31 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61569 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbbAGLaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:30:35 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b6-54ad18d99434
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v12 5/9] ARM: l2c: Get outer cache .write_sec callback from
 mach_desc only if not NULL
Date: Wed, 07 Jan 2015 12:30:20 +0100
Message-id: <1420630224-8887-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
References: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xq7o3JdaGGJz8pG3xd9IxdotH8x8z
	W/QuuMpm8fXwCkaLs01v2C22d85gt5jyZzmTxabH11gtLu+aw2Yxe0k/i8WM8/uYLG5f5rU4
	t30Li8XaI3fZLZZev8hk8ebHWSaLU9c/s1ms2vWH0WL/FS8HYY8189YwerQ097B5/P41idHj
	29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj+M3tjN5fN4kF8AbxWWT
	kpqTWZZapG+XwJVxv/Msa8EXroqXM3+xNDDO5+xi5OSQEDCRWPL2PAuELSZx4d56ti5GLg4h
	gaWMEr+ONjNDOH1MEn/717KDVLEJGEp0ve1iA7FFBNwk/q07BNbBLDCNRWLTkfNAHRwcwgIZ
	EhsOC4LUsAioSrx9fZEVxOYVcJc4feUM1DY5if8vVzCB2JwCHhJ3zi8Ds4WAahZMXMk2gZF3
	ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQuPiyg3HxMatDjAIcjEo8vAV9a0KEWBPL
	iitzDzFKcDArifC++QUU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMiaWrhCXfFxQ1Ef970zpp7r
	FGPkY39dc3nRuFC8i+ltkLHmizWrvvdfXG1dlbMw7f8x/fKlO1vjT60tlMt9bhaxcC23yq9U
	Yf025WCGmD/Zn2a9/pJm+t4m2/X5spthWREplv8sOTwCLgjM9ln0vsGs4U6w+pKVuwxfZ/+P
	W2/Sb+oqn7TnmBJLcUaioRZzUXEiAOsv46hpAgAA
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
Tested-by: Nishanth Menon <nm@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/kernel/irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index ad857bada96c..350f188c92d2 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -109,7 +109,8 @@ void __init init_IRQ(void)
 
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

