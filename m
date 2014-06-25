Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbaFYNiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:38:24 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57284 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaFYNiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:38:20 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-58-53aad0c9770e
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 3/6] ARM: mm: cache-l2x0: Use l2c_write_sec() for
 LATENCY_CTRL registers
Date: Wed, 25 Jun 2014 15:37:28 +0200
Message-id: <1403703451-12233-4-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
References: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xK7onL6wKNvjZLG3xaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtVh75C67xeu+NcwW62e8ZrFY
	tesPo8X+K14OfB4tzT1sHt++TmLxuNzXy+Sx6HuWx85Zd9k97lzbw+axeUm9R9+WVYwex29s
	Z/L4vEkugCuKyyYlNSezLLVI3y6BK2PWmqesBQsEKlYdu8vSwLiKt4uRk0NCwETi3sMtTBC2
	mMSFe+vZQGwhgaWMEo93xHQxcgHZfUwSn88eBkuwCahJfG54BGaLCKhKfG5bwA5SxCzQwCJx
	pfU6WEJYIFZi/vkOZhCbBajoW8tadhCbV8BJYs2dZ8wQ2+Qkere9AbM5BZwlLsz7wwqx2Uli
	3pMjjBMYeRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAnjLzsYFx+zOsQowMGoxMMb
	wLMqWIg1say4MvcQowQHs5IIr/t+oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGWX0RVTdMVFTv
	Pj6jpyxn7Kw1qcRlnuP/Y0wqywr/ufb+3vdDIFe2p3nylVWLxT/c1M8xzLe8e/Xv1Vtyj61/
	+b8rKQ1MK3yhuCT2cPiJfY+XOjL/Xn+jxEy49N/ddBG5ycez90/7FiSzMMfq+oT9K7vS1PRc
	3x2fO7G57X9vfOPyi5368qneSizFGYmGWsxFxYkAerWEUUECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation, TAG_LATENCY_CTRL and DATA_LATENCY_CTRL
registers of L2C-310 can be written only in secure mode, so
l2c_write_sec() should be used to change them, instead of plain
writel_relaxed().

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mm/cache-l2x0.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 478566b..6600fd9 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -622,10 +622,10 @@ static void l2c310_resume(void)
 		unsigned revision;
 
 		/* restore pl310 setup */
-		writel_relaxed(l2x0_saved_regs.tag_latency,
-			       base + L310_TAG_LATENCY_CTRL);
-		writel_relaxed(l2x0_saved_regs.data_latency,
-			       base + L310_DATA_LATENCY_CTRL);
+		l2c_write_sec(l2x0_saved_regs.tag_latency,
+			       base, L310_TAG_LATENCY_CTRL);
+		l2c_write_sec(l2x0_saved_regs.data_latency,
+			       base, L310_DATA_LATENCY_CTRL);
 		writel_relaxed(l2x0_saved_regs.filter_end,
 			       base + L310_ADDR_FILTER_END);
 		writel_relaxed(l2x0_saved_regs.filter_start,
@@ -1024,20 +1024,20 @@ static void __init l2c310_of_parse(const struct device_node *np,
 
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
+			l2x0_base, L310_DATA_LATENCY_CTRL);
 
 	of_property_read_u32_array(np, "arm,filter-ranges",
 				   filter, ARRAY_SIZE(filter));
-- 
1.9.3

