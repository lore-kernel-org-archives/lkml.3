Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbaKMNTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:19:40 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27097 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbaKMNS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:18:26 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-2f-5464af9f99ed
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
Subject: [PATCH v8 3/7] ARM: l2c: Get outer cache .write_sec callback from
 mach_desc only if not NULL
Date: Thu, 13 Nov 2014 14:18:10 +0100
Message-id: <1415884694-5868-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
References: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xy7rz16eEGOxbzGLxd9IxdotH8x8z
	W/QuuMpmcbbpDbvF9s4Z7BZT/ixnstj0+BqrxeVdc9gsZi/pZ7GYcX4fk8Xty7wW57ZvYbFY
	e+Quu8XS6xeZLE5d/8xmsWrXH0aL/Ve8HAQ91sxbw+jR0tzD5vH71yRGj29fJ7F4XO7rZfJY
	9D3LY+esu+wed67tYfPYvKTe48qJJlaPvi2rGD0+b5IL4InisklJzcksSy3St0vgyrj/5RZb
	wW/OigVf/zE1MG7l6GLk5JAQMJG4ceYTG4QtJnHh3nowW0hgKaPE5J1SXYxcQHYfk8Sa9mVg
	CTYBQ4mut11gtoiAm8S/dYfYQIqYBT4zS1x6tIYVJCEskC5xYM0GMJtFQFXi69tW5i5GDg5e
	AXeJA6vqIZbJSfx/uYIJxOYU8JD4sv4PK8Rid4n2XYcZJzDyLmBkWMUomlqaXFCclJ5rpFec
	mFtcmpeul5yfu4kREvZfdzAuPWZ1iFGAg1GJh/cDd0qIEGtiWXFl7iFGCQ5mJRHeNyuBQrwp
	iZVVqUX58UWlOanFhxiZODilGhgnXtx1e0nh7BVsrsWSl8tmTi2YWvWrJuvcsdCUmWtjDpu3
	7lFtlm/U27Nsr3sC+0S9Nu8Ff+WvF4bNiHYplbwasOgQQ6uf7Tnboq8X+luV2J/fFKre9F81
	vFhH+NcPpxN3c9+GJZ8pWyIVyXev8+ZvlQA21kwt5mnWOryyVvF3DqpNO7gxNU+JpTgj0VCL
	uag4EQAU+zM3WQIAAA==
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

