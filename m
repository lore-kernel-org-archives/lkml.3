Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbbAEMWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:22:01 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44306 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbbAEMTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:19:21 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-8f-54aa81481a9d
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
Subject: [PATCH v11 4/9] ARM: l2c: Add interface to ask hypervisor to configure
 L2C
Date: Mon, 05 Jan 2015 13:19:03 +0100
Message-id: <1420460348-20302-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xK7oejatCDJYv07L4O+kYu8Wj+Y+Z
	LXoXXGWz+Hp4BaPF2aY37BbbO2ewW0z5s5zJYtPja6wWl3fNYbOYvaSfxWLG+X1MFrcv81qc
	276FxWLtkbvsFkuvX2SyePPjLJPFqeuf2SxW7frDaLH/ipeDsMeaeWsYPVqae9g8fv+axOjx
	7eskFo/Lfb1MHou+Z3nsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx/Eb25k8Pm+SC+CN4rJJ
	Sc3JLEst0rdL4MpY8nk1U8Fj/opNM66wNjD28XYxcnJICJhITFjTyQhhi0lcuLeerYuRi0NI
	YCmjxOEtD5kgnD4mia1Tr7CCVLEJGEp0ve1iA7FFBNwk/q07BNbBLDCNRWLTkfPMIAlhgVCJ
	GRtPA3VzcLAIqEqcXsIJEuYV8JD413aTBWKbnMT/lyuYQGxOAU+JpXv3sYPYQkA1Z26tZZ/A
	yLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkhcfN3BuPSY1SFGAQ5GJR5ejxMrQ4RY
	E8uKK3MPMUpwMCuJ8L5KXxUixJuSWFmVWpQfX1Sak1p8iJGJg1OqgdHt7Yke7S49/gj9M8/u
	z73D3MT6u5XVtHjrUUbuhrn1/cF3r+75weRz13l5bmnxsfVrLr554Ou3/6zs/Kl12bdXLGPn
	qi07UC0/ZYG95bkDr7mP5Mk2NCtduLq+nzmZf2ZwQ9wBb09V0yf5kUtXJj0r+jvHZ9ubzgXL
	VwZ83e/4dDGLD9eGO9+VWIozEg21mIuKEwEghAkkaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Because certain secure hypervisor do not allow writes to individual L2C
registers, but rather expect set of parameters to be passed as argument
to secure monitor calls, there is a need to provide an interface for the
L2C driver to ask the firmware to configure the hardware according to
specified parameters. This patch adds such.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/include/asm/outercache.h | 3 +++
 arch/arm/mm/cache-l2x0.c          | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index 891a56b35bcf..563b92fc2f41 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -23,6 +23,8 @@
 
 #include <linux/types.h>
 
+struct l2x0_regs;
+
 struct outer_cache_fns {
 	void (*inv_range)(unsigned long, unsigned long);
 	void (*clean_range)(unsigned long, unsigned long);
@@ -36,6 +38,7 @@ struct outer_cache_fns {
 
 	/* This is an ARM L2C thing */
 	void (*write_sec)(unsigned long, unsigned);
+	void (*configure)(const struct l2x0_regs *);
 };
 
 extern struct outer_cache_fns outer_cache;
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index f9013320c8ce..dcde6086a228 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -110,6 +110,11 @@ static inline void l2c_unlock(void __iomem *base, unsigned num)
 
 static void l2c_configure(void __iomem *base)
 {
+	if (outer_cache.configure) {
+		outer_cache.configure(&l2x0_saved_regs);
+		return;
+	}
+
 	if (l2x0_data->configure)
 		l2x0_data->configure(base);
 
@@ -910,6 +915,7 @@ static int __init __l2c_init(const struct l2c_init_data *data,
 
 	fns = data->outer_cache;
 	fns.write_sec = outer_cache.write_sec;
+	fns.configure = outer_cache.configure;
 	if (data->fixup)
 		data->fixup(l2x0_base, cache_id, &fns);
 
-- 
1.9.2

