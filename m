Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaIXLHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:07:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19357 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaIXLFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:05:52 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-45-5422a58d1fef
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
        loeliger@gmail.com
Subject: [PATCH v5 4/7] ARM: l2c: Add support for overriding prefetch settings
Date: Wed, 24 Sep 2014 13:05:38 +0200
Message-id: <1411556741-5810-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
References: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xa7q9S5VCDD7PlrN4NP8xs0Xvgqts
	Fmeb3rBbbO+cwW4x5c9yJotNj6+xWlzeNYfNYvaSfhaLGef3MVncvsxrcW77FhaLtUfuslu8
	7lvDbLFq1x9Gi/1XvBz4PVqae9g8vn2dxOJxua+XyWPR9yyPnbPusnvcubaHzWPzknqPvi2r
	GD2O39jO5PF5k1wAVxSXTUpqTmZZapG+XQJXxqFnk9kLlklXLJtv08B4QayLkZNDQsBEYuGj
	fUwQtpjEhXvr2boYuTiEBJYySux+85IZwuljknhyoZsRpIpNwFCi620XG4gtIpAt8ePbZBaQ
	ImaBVmaJx0++sYIkhAX8JJb/PA7WwCKgKrH69zIWEJtXwF3i/eYzbBDr5CT+v1wBtppTwEPi
	8eN/QPUcQNvcJZo2uUxg5F3AyLCKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyScv+5gXHrM
	6hCjAAejEg/vRHGlECHWxLLiytxDjBIczEoivK96gEK8KYmVValF+fFFpTmpxYcYmTg4pRoY
	/QQdWlUtrj6/l3ZI92LfjF8bOc8bctpsjb9cvatBxuJHK897n7Uzbf4uCGMKVat/+4V981vh
	6T/YPBUkkya3ZT1f2D7lg3pRaE7A/ntvNog8MZ+vKuCfsLPbWCq30jI8U+6W152M+ZfPJYgt
	qVw8dz2rw9RbibzcuSkSSadfvlZMvhURu8hAiaU4I9FQi7moOBEAAtpmREUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Firmware on certain boards (e.g. ODROID-U3) can leave incorrect L2C prefetch
settings configured in registers leading to crashes if L2C is enabled
without overriding them. This patch introduces bindings to enable
prefetch settings to be specified from DT and necessary support in the
driver.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 Documentation/devicetree/bindings/arm/l2cc.txt | 10 +++++++
 arch/arm/mm/cache-l2x0.c                       | 39 ++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
index af527ee111c2..3443d2d76788 100644
--- a/Documentation/devicetree/bindings/arm/l2cc.txt
+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
@@ -47,6 +47,16 @@ Optional properties:
 - cache-id-part: cache id part number to be used if it is not present
   on hardware
 - wt-override: If present then L2 is forced to Write through mode
+- arm,double-linefill : Override double linefill enable setting. Enable if
+  non-zero, disable if zero.
+- arm,double-linefill-incr : Override double linefill on INCR read. Enable
+  if non-zero, disable if zero.
+- arm,double-linefill-wrap : Override double linefill on WRAP read. Enable
+  if non-zero, disable if zero.
+- arm,prefetch-drop : Override prefetch drop enable setting. Enable if non-zero,
+  disable if zero.
+- arm,prefetch-offset : Override prefetch offset value. Valid values are
+  0-7, 15, 23, and 31.
 
 Example:
 
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 84c6c55ab896..af90a6ff6b49 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1059,6 +1059,8 @@ static void __init l2c310_of_parse(const struct device_node *np,
 	u32 data[3] = { 0, 0, 0 };
 	u32 tag[3] = { 0, 0, 0 };
 	u32 filter[2] = { 0, 0 };
+	u32 prefetch;
+	u32 val;
 
 	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
 	if (tag[0] && tag[1] && tag[2])
@@ -1083,6 +1085,43 @@ static void __init l2c310_of_parse(const struct device_node *np,
 		l2x0_saved_regs.filter_start = (filter[0] & ~(SZ_1M - 1))
 					| L310_ADDR_FILTER_EN;
 	}
+
+	prefetch = l2x0_saved_regs.prefetch_ctrl;
+
+	if (!of_property_read_u32(np, "arm,double-linefill", &val)) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL;
+	}
+
+	if (!of_property_read_u32(np, "arm,double-linefill-incr", &val)) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
+	}
+
+	if (!of_property_read_u32(np, "arm,double-linefill-wrap", &val)) {
+		if (!val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
+	}
+
+	if (!of_property_read_u32(np, "arm,prefetch-drop", &val)) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_PREFETCH_DROP;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_PREFETCH_DROP;
+	}
+
+	if (!of_property_read_u32(np, "arm,prefetch-offset", &val)) {
+		prefetch &= ~L310_PREFETCH_CTRL_OFFSET_MASK;
+		prefetch |= val & L310_PREFETCH_CTRL_OFFSET_MASK;
+	}
+
+	l2x0_saved_regs.prefetch_ctrl = prefetch;
 }
 
 static const struct l2c_init_data of_l2c310_data __initconst = {
-- 
1.9.2

