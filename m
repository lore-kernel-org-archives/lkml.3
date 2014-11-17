Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaKQLvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:51:23 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45475 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaKQLsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:48:40 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-25-5469e09484be
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
Subject: [PATCH v9 2/7] ARM: l2c: Add interface to ask hypervisor to configure
 L2C
Date: Mon, 17 Nov 2014 12:48:24 +0100
Message-id: <1416224909-4290-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1416224909-4290-1-git-send-email-m.szyprowski@samsung.com>
References: <1416224909-4290-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xK7pTHmSGGMxsULX4O+kYu8Wj+Y+Z
	LXoXXGWzONv0ht1ie+cMdospf5YzWWx6fI3V4vKuOWwWs5f0s1jMOL+PyeL2ZV6Lc9u3sFis
	PXKX3WLp9YtMFqeuf2azWLXrD6PF/iteDoIea+atYfRoae5h8/j9axKjx7evk1g8Lvf1Mnks
	+p7lsXPWXXaPO9f2sHlsXlLvceVEE6tH35ZVjB6fN8kF8ERx2aSk5mSWpRbp2yVwZcyd2s5S
	8Ji/Yvr2CcwNjH28XYycHBICJhKzV6xmh7DFJC7cW8/WxcjFISSwlFHi0NWTTBBOH5PEmWfr
	mUCq2AQMJbredrGB2CICbhL/1h0C62AW+MwscenRGtYuRg4OYYEQiTuTLUBqWARUJTr39jGC
	2LwC7hI/p59igtgmJ/H/5Qowm1PAQ+Lb9wNsIK1CQDWtjzgnMPIuYGRYxSiaWppcUJyUnmuk
	V5yYW1yal66XnJ+7iRES9l93MC49ZnWIUYCDUYmH90BRZogQa2JZcWXuIUYJDmYlEd6Yi0Ah
	3pTEyqrUovz4otKc1OJDjEwcnFINjB2PlFNz7C849cwRyMuav/yx4Ie9q+fvWcaodddrgaNx
	pP+DfZ+7VCuOLLDu0Ml/cEk5SLzlVJ1huWiauZiR3cZvnL9miRlpnJqYs9TPaqvTjhX6l1ym
	J5S8a7nxKmrd640LAqfM2ftwQm2T/4HlPwPnlR+4rfhd5fLf05IvOY5u6FmQF7jr+HwlluKM
	REMt5qLiRACfIYPnWQIAAA==
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

