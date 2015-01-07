Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbbAGLai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:30:38 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60126 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbAGLae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:30:34 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-a3-54ad18d72f78
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
Subject: [PATCH v12 2/9] ARM: l2c: use l2c_write_sec() for restoring latency
 and filter regs
Date: Wed, 07 Jan 2015 12:30:17 +0100
Message-id: <1420630224-8887-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
References: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xq7rXJdaGGKxYKWrxd9IxdotH8x8z
	W/QuuMpm8fXwCkaLs01v2C22d85gt5jyZzmTxabH11gtLu+aw2Yxe0k/i8WM8/uYLG5f5rU4
	t30Li8XaI3fZLZZev8hk8ebHWSaLU9c/s1ms2vWH0WL/FS8HYY8189YwerQ097B5/P41idHj
	29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj+M3tjN5fN4kF8AbxWWT
	kpqTWZZapG+XwJVx+90vtoKPkhX7e/6wNTDOEu1i5OSQEDCRuNK9kQXCFpO4cG89WxcjF4eQ
	wFJGiVdzv4AlhAT6mCReHpUAsdkEDCW63naxgdgiAm4S/9YdAmtgFpjGIrHpyHlmkISwQJzE
	6oO3GUFsFgFViRX7ZzKB2LwC7hIvVsyE2iYn8f/lCrA4p4CHxJ3zy5gglrlLLJi4km0CI+8C
	RoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCFx8WUH4+JjVocYBTgYlXh4C/rWhAixJpYV
	V+YeYpTgYFYS4X3zCyjEm5JYWZValB9fVJqTWnyIkYmDU6qBcb7blBXBvmrFXozXe92yQ5VL
	CvpEDVWXHFw9p3vree+j0/evP19/5ciuHvNXLPEbO0PS5Ow4f3rkzHHOv+SmmjlPMWYhx4ti
	hu27bHb5sr5nTbSR7vvgXnM1+czj+HuRv9laziZ/N9u/e0Ve17wlsfx1Fy8uuKs0T6TUxlC+
	LcLjL5vS0ROuSizFGYmGWsxFxYkAbDbOR2kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All four register for latency and filter settings cannot be written in
non-secure mode and they should go through l2c_write_sec(). More on this
can be found in CoreLink Level 2 Cache Controller L2C-310 Technical
Reference Manual, 3.2. Register summary, table 3.1. This have been checked
the TRM for r3p3, but it should be uniform for all revisions.

Reported-by: Nishanth Menon <nm@ti.com>
Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Nishanth Menon <nm@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mm/cache-l2x0.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 5e65ca8dea62..b83c401ca50c 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -623,14 +623,14 @@ static void l2c310_resume(void)
 		unsigned revision;
 
 		/* restore pl310 setup */
-		writel_relaxed(l2x0_saved_regs.tag_latency,
-			       base + L310_TAG_LATENCY_CTRL);
-		writel_relaxed(l2x0_saved_regs.data_latency,
-			       base + L310_DATA_LATENCY_CTRL);
-		writel_relaxed(l2x0_saved_regs.filter_end,
-			       base + L310_ADDR_FILTER_END);
-		writel_relaxed(l2x0_saved_regs.filter_start,
-			       base + L310_ADDR_FILTER_START);
+		l2c_write_sec(l2x0_saved_regs.tag_latency, base,
+			      L310_TAG_LATENCY_CTRL);
+		l2c_write_sec(l2x0_saved_regs.data_latency, base,
+			      L310_DATA_LATENCY_CTRL);
+		l2c_write_sec(l2x0_saved_regs.filter_end, base,
+			      L310_ADDR_FILTER_END);
+		l2c_write_sec(l2x0_saved_regs.filter_start, base,
+			      L310_ADDR_FILTER_START);
 
 		revision = readl_relaxed(base + L2X0_CACHE_ID) &
 				L2X0_CACHE_ID_RTL_MASK;
@@ -1135,28 +1135,28 @@ static void __init l2c310_of_parse(const struct device_node *np,
 
 	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
 	if (tag[0] && tag[1] && tag[2])
-		writel_relaxed(
+		l2c_write_sec(
 			L310_LATENCY_CTRL_RD(tag[0] - 1) |
 			L310_LATENCY_CTRL_WR(tag[1] - 1) |
 			L310_LATENCY_CTRL_SETUP(tag[2] - 1),
-			l2x0_base + L310_TAG_LATENCY_CTRL);
+			l2x0_base, L310_TAG_LATENCY_CTRL);
 
 	of_property_read_u32_array(np, "arm,data-latency",
 				   data, ARRAY_SIZE(data));
 	if (data[0] && data[1] && data[2])
-		writel_relaxed(
+		l2c_write_sec(
 			L310_LATENCY_CTRL_RD(data[0] - 1) |
 			L310_LATENCY_CTRL_WR(data[1] - 1) |
 			L310_LATENCY_CTRL_SETUP(data[2] - 1),
-			l2x0_base + L310_DATA_LATENCY_CTRL);
+			l2x0_base,  L310_DATA_LATENCY_CTRL);
 
 	of_property_read_u32_array(np, "arm,filter-ranges",
 				   filter, ARRAY_SIZE(filter));
 	if (filter[1]) {
-		writel_relaxed(ALIGN(filter[0] + filter[1], SZ_1M),
-			       l2x0_base + L310_ADDR_FILTER_END);
-		writel_relaxed((filter[0] & ~(SZ_1M - 1)) | L310_ADDR_FILTER_EN,
-			       l2x0_base + L310_ADDR_FILTER_START);
+		l2c_write_sec(ALIGN(filter[0] + filter[1], SZ_1M),
+			      l2x0_base, L310_ADDR_FILTER_END);
+		l2c_write_sec((filter[0] & ~(SZ_1M - 1)) | L310_ADDR_FILTER_EN,
+			      l2x0_base, L310_ADDR_FILTER_START);
 	}
 
 	ret = l2x0_cache_size_of_parse(np, aux_val, aux_mask, &assoc, SZ_512K);
-- 
1.9.2

