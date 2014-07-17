Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934859AbaGQQl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:41:58 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56771 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaGQQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:39:53 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c1-53c7fc55d499
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
Subject: [PATCH v3 2/7] ARM: l2c: Add interface to ask hypervisor to configure
 L2C
Date: Thu, 17 Jul 2014 18:38:57 +0200
Message-id: <1405615142-21426-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
References: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xq7qhf44HG+w/ZG7xaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtTi3fQuLxdojd9ktXvetYbZY
	P+M1i8WqXX8YLfZf8XLg92hp7mHz+PZ1EovH5b5eJo9F37M8ds66y+5x59oeNo/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGaevrWMsuM9T0fIwuIHxKFcXIyeHhICJxPZb
	v1kgbDGJC/fWs3UxcnEICSxllOh/doEFwuljkvj27Q0zSBWbgJrE54ZHbCC2iICqxOe2Bewg
	RcwCB5glLmx6ADZKWCBE4uzfM4wgNgtQUeOpXrBmXgEnieUds5kh1slJ9G6DGMop4Cwxd/9j
	sKFCQDVb2hYwTWDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJKC/7GBcfMzqEKMA
	B6MSD2/n52PBQqyJZcWVuYcYJTiYlUR4s+8fDxbiTUmsrEotyo8vKs1JLT7EyMTBKdXA6M/U
	c1sh14fhz+Zdn8O3fWJZcaKVZcHFX2F6S6YGhM3xDGK09W7u/qsWysc5cfHezAI+PZ+NCdWP
	z8b9mrcj9VMh/1vu8Merlh2dp7qH4+4Wh10Pu9m+7I32+n2T8bWJ6ZIHp+6wl/47/EllzxXN
	Ak1n7eeHJ89xjF9UZW+7q+luuHhpifjhG0osxRmJhlrMRcWJABIFMXdGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because certain secure hypervisor do not allow writes to individual L2C
registers, but rather expect set of parameters to be passed as argument
to secure monitor calls, there is a need to provide an interface for the
L2C driver to ask the firmware to configure the hardware according to
specified parameters. This patch adds such.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/include/asm/outercache.h | 3 +++
 arch/arm/mm/cache-l2x0.c          | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index 891a56b..563b92f 100644
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
index 385c047..21a625a0 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -109,6 +109,11 @@ static inline void l2c_unlock(void __iomem *base, unsigned num)
 
 static void l2c_configure(void __iomem *base)
 {
+	if (outer_cache.configure) {
+		outer_cache.configure(&l2x0_saved_regs);
+		return;
+	}
+
 	if (l2x0_data->configure)
 		l2x0_data->configure(base);
 
-- 
1.9.3

