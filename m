Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbaFKPah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:30:37 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43315 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaFKPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:30:35 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-60-53987618bce6
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>, Robin Holt <holt@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 3/5] ARM: mm: cache-l2x0: Use l2c_write_sec() for LATENCY_CTRL
 registers
Date: Wed, 11 Jun 2014 17:30:10 +0200
Message-id: <1402500612-4778-4-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
References: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xy7oSZTOCDTY3yFj0T+tgtehdcJXN
	YnvnDHaLKX+WM1lsenyN1eLyrjlsFrOX9LNYzDi/j8ni9mVei9d9a5gt1s94zWKxatcfRov9
	V7wceD1amnvYPL59ncTicbmvl8lj56y77B53ru1h89i8pN6jb8sqRo+7118yeRy/sZ3J4/Mm
	uQCuKC6blNSczLLUIn27BK6M6XN3sxZs4q5o/byUvYFxK2cXIyeHhICJRFPHaxYIW0ziwr31
	bCC2kMBSRolFezW7GLmA7D4middXn4Al2ATUJD43PAKzRQRUJT63LWAHKWIW2MsscWbGDcYu
	Rg4OYYEoiV/PxEBqWIBq7s/ZCraAV8BRYu7GT2wQy+Qkere9YQaxOQWcJJ5e7mWEWOwosWr9
	ReYJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoQE75cdjIuPWR1iFOBgVOLh5dCZ
	FizEmlhWXJl7iFGCg1lJhLegcEawEG9KYmVValF+fFFpTmrxIUYmDk6pBkaBbl7b2WmGm6LO
	rZ5b8f1n8Qm+1a2SyeqvnrjsaWpmlbMy+aNy+bHqXGNPF8VTEx8Jqv9bq3J1W5Fw2/bjM3/n
	1bxKdEix1u23WH9j11b75j8h3zf8nv8xeK7xhMZLEgetLFcGdv+zCIow7VkQebdhd+ZrId7C
	l4ttry28dNTjxJbwe+bTt4kqsRRnJBpqMRcVJwIARjgdDjwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation, TAG_LATENCY_CTRL and DATA_LATENCY_CTRL
registers of L2C-310 can be written only in secure mode, so
l2c_write_sec() should be used to change them, instead of plain
writel_relaxed().

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mm/cache-l2x0.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 1695eab..0180eb7 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
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

