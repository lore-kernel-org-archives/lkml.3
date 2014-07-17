Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154AbaGQQlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:41:25 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56771 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934286AbaGQQjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:39:54 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c3-53c7fc572bda
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, santosh.shilimkar@ti.com, tony@atomide.com,
        drake@endlessm.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 4/7] ARM: l2c: Add support for overriding prefetch settings
Date: Thu, 17 Jul 2014 18:38:59 +0200
Message-id: <1405615142-21426-5-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
References: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xq7rhf44HG6xcwW7xaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtTi3fQuLxdojd9ktXvetYbZY
	P+M1i8WqXX8YLfZf8XLg92hp7mHz+PZ1EovH5b5eJo9F37M8ds66y+5x59oeNo/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGds3z2UpWCtVcXnZMtYGxseiXYycHBICJhIz
	2/rZIGwxiQv31gPZXBxCAksZJfZdfs4M4fQxSTz+towFpIpNQE3ic8MjsA4RAVWJz20L2EGK
	mAUOMEtc2PQArEhYwE9i5fLXYEUsQEXTJp5hBrF5BZwkGjZvgFonJ9G77Q1YnFPAWWLu/sdg
	cSGgmi1tC5gmMPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRES0l92MC4+ZnWIUYCD
	UYmHt/PzsWAh1sSy4srcQ4wSHMxKIrzZ948HC/GmJFZWpRblxxeV5qQWH2Jk4uCUamDMuR6U
	0qDDE/il3CJefLtS6sutzZcr93vaKc/4oLZX7c+rjcsqqtef5Li3pl4u/8s567ALLk/Wrkr4
	vurmBPkNOv8UHnxK7Q/PXDLhxp7wH8cbY09aemxIj3g7hS9kl/Gu7VNWnbI4XDK75denY73Z
	L+8xfy47LvVHvirPeHtYhS7zDnXxgioZJZbijERDLeai4kQA6EGwLEcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firmware on certain boards (e.g. ODROID-U3) can leave incorrect L2C prefetch
settings configured in registers leading to crashes if L2C is enabled
without overriding them. This patch introduces bindings to enable
prefetch settings to be specified from DT and necessary support in the
driver.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 Documentation/devicetree/bindings/arm/l2cc.txt | 10 +++++++
 arch/arm/mm/cache-l2x0.c                       | 39 ++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
index af527ee..3443d2d 100644
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
index 21a625a0..6274803 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1055,6 +1055,8 @@ static void __init l2c310_of_parse(const struct device_node *np,
 	u32 data[3] = { 0, 0, 0 };
 	u32 tag[3] = { 0, 0, 0 };
 	u32 filter[2] = { 0, 0 };
+	u32 prefetch;
+	u32 val;
 
 	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
 	if (tag[0] && tag[1] && tag[2])
@@ -1079,6 +1081,43 @@ static void __init l2c310_of_parse(const struct device_node *np,
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
1.9.3

