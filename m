Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbbAEMVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:21:17 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44743 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbbAEMTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:19:22 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-09-54aa8148ad77
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
Subject: [PATCH v11 5/9] ARM: l2c: Get outer cache .write_sec callback from
 mach_desc only if not NULL
Date: Mon, 05 Jan 2015 13:19:04 +0100
Message-id: <1420460348-20302-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xK7oejatCDC6cZ7f4O+kYu8Wj+Y+Z
	LXoXXGWz+Hp4BaPF2aY37BbbO2ewW0z5s5zJYtPja6wWl3fNYbOYvaSfxWLG+X1MFrcv81qc
	276FxWLtkbvsFkuvX2SyePPjLJPFqeuf2SxW7frDaLH/ipeDsMeaeWsYPVqae9g8fv+axOjx
	7eskFo/Lfb1MHou+Z3nsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx/Eb25k8Pm+SC+CN4rJJ
	Sc3JLEst0rdL4Mr4dWY6e8FvzopVs78zNjBu5ehi5OSQEDCR2LuniwXCFpO4cG89WxcjF4eQ
	wFJGiY4/e1ghnD4miZdHD7ODVLEJGEp0ve1iA7FFBNwk/q07BNbBLDCNRWLTkfPMIAlhgQyJ
	VWsXMHYxcnCwCKhKrHnpBhLmFfCQePX+CdQ2OYn/L1cwgdicAp4SS/fuA5svBFRz5tZa9gmM
	vAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihMTFlx2Mi49ZHWIU4GBU4uH1OLEyRIg1
	say4MvcQowQHs5II76v0VSFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGHPe6bQuX/XhcWFObmwg
	h+GqniS/iS6PbNRkJcUfaZ2bwTw7Msdjn0eRUefUDzVtLOl7M/NPyBrHJbjPVZIzLbxjf3av
	nM/p7FDF8pbOr87LZj6/ckeoQDleuuKC1aWuS1dsQs6LbjAOrg8/a7+MsesFV2vwWbZ7xmJN
	rIFu7ll9VzfN9hRRYinOSDTUYi4qTgQA7LmTjWkCAAA=
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

