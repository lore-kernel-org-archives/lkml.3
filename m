Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060AbaKMNSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:18:31 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27097 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773AbaKMNSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:18:24 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-c3-5464af9d9c58
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org, tony@atomide.com,
        drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v8 2/7] ARM: l2c: Add interface to ask hypervisor to configure
 L2C
Date: Thu, 13 Nov 2014 14:18:09 +0100
Message-id: <1415884694-5868-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
References: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xy7pz16eEGHw4pGnxd9IxdotH8x8z
	W/QuuMpmcbbpDbvF9s4Z7BZT/ixnstj0+BqrxeVdc9gsZi/pZ7GYcX4fk8Xty7wW57ZvYbFY
	e+Quu8XS6xeZLE5d/8xmsWrXH0aL/Ve8HAQ91sxbw+jR0tzD5vH71yRGj29fJ7F4XO7rZfJY
	9D3LY+esu+wed67tYfPYvKTe48qJJlaPvi2rGD0+b5IL4InisklJzcksSy3St0vgypg7tZ2l
	4DF/xfTtE5gbGPt4uxg5OSQETCR2fjnPBGGLSVy4t56ti5GLQ0hgKaPEi9N32SGcPiaJRWuX
	sINUsQkYSnS97WIDsUUE3CT+rTsE1sEs8JlZ4tKjNawgCWGBEIkVp5aAFbEIqEo0HZ8BFucV
	cJc4t/QxK8Q6OYn/L1eAreYU8JD4sv4PWFwIqKZ912HGCYy8CxgZVjGKppYmFxQnpeca6hUn
	5haX5qXrJefnbmKEhP6XHYyLj1kdYhTgYFTi4f3AnRIixJpYVlyZe4hRgoNZSYT3zUqgEG9K
	YmVValF+fFFpTmrxIUYmDk6pBsZUr6q5M/1ZNZW/pvznmPaH8e7m66d/Jtz8GhR0Ynml3pXp
	59xLpnVxqq6dU+5uMvUs10XHxP7Hj5b8Y+jQdpv5Sj9rWkHU5Ibp+/iC+P9uUL/y5ZLclWKH
	BeeM/35e9Uo5Z1+PILOEmahIt12qtcLnDTl3cxyWZm3LU2k/IxfDVKwettVI8qYSS3FGoqEW
	c1FxIgDd7nfxWwIAAA==
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
index e5948c5adaa7..d214be207517 100644
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

