Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbaJ2JXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:23:21 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46382 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbaJ2JXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:23:11 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-de-5450b1fd6509
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org, tony@atomide.com,
        drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v7 2/8] ARM: l2c: Add interface to ask hypervisor to configure
 L2C
Date: Wed, 29 Oct 2014 10:22:55 +0100
Message-id: <1414574581-2320-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
References: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xy7p/NwaEGHzcqGfxaP5jZoveBVfZ
	LM42vWG32N45g91iyp/lTBabHl9jtbi8aw6bxewl/SwWM87vY7K4fZnX4tz2LSwWa4/cZbdY
	ev0ik8WqXX8YLfZf8XLg91gzbw2jR0tzD5vHt6+TWDwu9/UyeSz6nuWxc9Zddo871/aweWxe
	Uu/Rt2UVo8fnTXIBXFFcNimpOZllqUX6dglcGd++yxQ85q84tnQ+UwNjH28XIyeHhICJxJym
	uYwQtpjEhXvr2boYuTiEBJYySky4tJoFJCEk0Mck8eJ5GYjNJmAo0fW2iw3EFhHIlvjxbTIL
	SAOzQB+zxPnpPcwgCWGBEIllZ5rAbBYBVYn902axgti8Au4SPV+PQW2Tk/j/cgUTiM0p4CGx
	+sISNohl7hIbD3ezTWDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJJy/7GBcfMzq
	EKMAB6MSD6/Gbv8QIdbEsuLK3EOMEhzMSiK8O8wDQoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUw
	ymQ9klaa9SPS+s2yQ5Gm1eYxp2dd+FMvHb/DuPxV+cMfUhXhdit3Hr9gLs/Y3D3n6VvFrTXC
	nxkbThtcPh9jfHzJ333lPPu8tFaqn3KLMuSUZRN8ybLth1qcYUmlkaC0iMUMs4tdh88emn5o
	XonIQ5anDa2KAalT3O5e/KF58Pd/mRb9P7eKlFiKMxINtZiLihMBIkd1xkUCAAA=
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

