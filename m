Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbbAEMT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:19:27 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43476 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbbAEMTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:19:20 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-89-54aa8147d1cc
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
Subject: [PATCH v11 2/9] ARM: l2c: use l2c_write_sec() for restoring latency
 and filter regs
Date: Mon, 05 Jan 2015 13:19:01 +0100
Message-id: <1420460348-20302-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xK7rujatCDNoOslv8nXSM3eLR/MfM
	Fr0LrrJZfD28gtHibNMbdovtnTPYLab8Wc5ksenxNVaLy7vmsFnMXtLPYjHj/D4mi9uXeS3O
	bd/CYrH2yF12i6XXLzJZvPlxlsni1PXPbBardv1htNh/xctB2GPNvDWMHi3NPWwev39NYvT4
	9nUSi8flvl4mj0Xfszx2zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/iN7UwenzfJBfBGcdmk
	pOZklqUW6dslcGW0PzzCWrCFt2LphI9MDYxt3F2MnBwSAiYS/VO+MUPYYhIX7q1nA7GFBJYy
	SkzZ5NvFyAVk9zFJbPy1hgkkwSZgKNH1tgusSETATeLfukNsIEXMAtNYJDYdOQ82SVggTuL0
	ul6wIhYBVYkzU9vAbF4BD4mONxvYIbbJSfx/uQJsKKeAp8TSvfvYITZ7SJy5tZZ9AiPvAkaG
	VYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghcfF1B+PSY1aHGAU4GJV4eD1OrAwRYk0sK67M
	PcQowcGsJML7Kn1ViBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGhVvEkgx8pno7vn9sn3DU+LjI
	Np7mYL2AhOzb3A0vtdL4s7OC3G99sGDn+rw2ad3m7V9uHtI4MH9PynOBL/m3Ts6cY3Y5R8ss
	ZuUCa7+rRndYN4TNCVwUFJjoPrfwo2zr3Ogdgtp6+/XtI+z/775r+b4u9YPUs1vVIZ8CuKfP
	dN7u1im6+Uu5EktxRqKhFnNRcSIAslh4s2kCAAA=
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
---
 arch/arm/mm/cache-l2x0.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 5e65ca8dea62..0aeeaa95c42d 100644
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
-- 
1.9.2

