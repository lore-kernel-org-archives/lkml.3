Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaJ0LI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:08:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35498 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaJ0LF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:05:59 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-ef-544e27140858
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
Subject: [PATCH v6 2/7] ARM: l2c: Add interface to ask hypervisor to configure
 L2C
Date: Mon, 27 Oct 2014 12:05:45 +0100
Message-id: <1414407950-3029-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
References: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xK7oi6n4hBrvaTS0ezX/MbNG74Cqb
	xdmmN+wW2ztnsFtM+bOcyWLT42usFpd3zWGzmL2kn8Vixvl9TBa3L/NanNu+hcVi7ZG77BZL
	r19ksnjdt4bZYtWuP4wW+694OQh4rJm3htGjpbmHzePb10ksHpf7epk8Fn3P8tg56y67x51r
	e9g8Ni+p9+jbsorR4/iN7UwenzfJBXBHcdmkpOZklqUW6dslcGV8+y5T8Ji/4tjS+UwNjH28
	XYwcHBICJhLfnzB2MXICmWISF+6tZ+ti5OIQEljKKLHrwDRWCKePSWLiiQ6wKjYBQ4mut11s
	ILaIQLbEj2+TWUCKmAVWMUtMObCOFSQhLBAisenVWmYQm0VAVWLX1yPsINt4Bdwlbt7Rgdgm
	J/H/5QomEJtTwENicstMMFsIqGTVh72MExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P
	3cQICfCvOxiXHrM6xCjAwajEwzuh2DdEiDWxrLgy9xCjBAezkgiv40+gEG9KYmVValF+fFFp
	TmrxIUYmDk6pBsbb5auuzd52hXHtFf45XZP4MxP+pHe90dQ7cfVIek5F/umV7xfsf3Pi4N+f
	UUfn3c59Wrph30SNyxkXTx47zqWUxPvxZ4BF1BfOSDfTaTlXxeUNf3Qx/tJafygtyy7OIuVW
	uLrT6YhX1spf3K8EKjzizbIw7Ey+XN4RYWiqbMHkz6q/8IXjhUglluKMREMt5qLiRAAPzUyH
	TgIAAA==
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
index 4286ee9bb3bd..ad981894de73 100644
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

