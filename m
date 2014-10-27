Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaJ0LGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:06:08 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14311 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaJ0LGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:06:01 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-6a-544e271609dd
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
Subject: [PATCH v6 4/7] ARM: l2c: Add support for overriding prefetch settings
Date: Mon, 27 Oct 2014 12:05:47 +0100
Message-id: <1414407950-3029-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
References: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xK7pi6n4hBreX8Fs8mv+Y2aJ3wVU2
	i7NNb9gttnfOYLeY8mc5k8Wmx9dYLS7vmsNmMXtJP4vFjPP7mCxuX+a1OLd9C4vF2iN32S2W
	Xr/IZPG6bw2zxapdfxgt9l/xchDwWDNvDaNHS3MPm8e3r5NYPC739TJ5LPqe5bFz1l12jzvX
	9rB5bF5S79G3ZRWjx/Eb25k8Pm+SC+CO4rJJSc3JLEst0rdL4MqYcai+4LFCRee3fywNjP+l
	uhg5OSQETCTu7nvMCmGLSVy4t56ti5GLQ0hgKaPEk01dLCAJIYE+JomLV/xBbDYBQ4mut11s
	ILaIQLbEj2+TWUAamAVWMUtMObAOaBIHh7CAn8SzO5YgNSwCqhLvpxxhBrF5Bdwltm69yQKx
	TE7i/8sVTCA2p4CHxOSWmUwQu9wlVn3YyziBkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k
	/NxNjJAA/7KDcfExq0OMAhyMSjy8O6b5hgixJpYVV+YeYpTgYFYS4XX8CRTiTUmsrEotyo8v
	Ks1JLT7EyMTBKdXA6KMh8ezAnw3dk2ac2NeakfP9wry6n77AoN7OvTDvyuXD7CFvTjzJS274
	JswSNuHnBu59Eb8O/5kfcmqZwMHM8l3+8uqWOUdcJJYtsl10zmvat+Ip2/L4Q9PVupRTvBjX
	/i5mWP750sfeAz8aHq6qbLpybHPv0ZU/trbNqLlwZVdhsvAyMz71aiWW4oxEQy3mouJEANPF
	qWZOAgAA
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
[mszyprow: rebased onto v3.18-rc1, added error messages when property value
 is missing]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 Documentation/devicetree/bindings/arm/l2cc.txt | 10 +++++
 arch/arm/mm/cache-l2x0.c                       | 55 ++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
index 292ef7ca3058..0dbabe9a6b0a 100644
--- a/Documentation/devicetree/bindings/arm/l2cc.txt
+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
@@ -57,6 +57,16 @@ Optional properties:
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
index ad981894de73..69cfa8359ed3 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1163,6 +1163,9 @@ static void __init l2c310_of_parse(const struct device_node *np,
 	u32 tag[3] = { 0, 0, 0 };
 	u32 filter[2] = { 0, 0 };
 	u32 assoc;
+	u32 prefetch;
+	u32 val;
+	int ret;
 
 	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
 	if (tag[0] && tag[1] && tag[2])
@@ -1204,6 +1207,58 @@ static void __init l2c310_of_parse(const struct device_node *np,
 		pr_err("PL310 OF: %d calculated, only 8 and 16 legal\n", assoc);
 		break;
 	}
+
+	prefetch = l2x0_saved_regs.prefetch_ctrl;
+
+	ret = of_property_read_u32(np, "arm,double-linefill", &val);
+	if (ret == 0) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL;
+	} else if (ret != -EINVAL) {
+		pr_err("PL310 OF: missing value for arm,double-linefill property\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,double-linefill-incr", &val);
+	if (ret == 0) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
+	} else if (ret != -EINVAL) {
+		pr_err("PL310 OF: missing value for arm,double-linefill-incr property\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,double-linefill-wrap", &val);
+	if (ret == 0) {
+		if (!val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
+	} else if (ret != -EINVAL) {
+		pr_err("PL310 OF: missing value for arm,double-linefill-wrap property\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,prefetch-drop", &val);
+	if (ret == 0) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_PREFETCH_DROP;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_PREFETCH_DROP;
+	} else if (ret != -EINVAL) {
+		pr_err("PL310 OF: missing value for arm,prefetch-drop property\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,prefetch-offset", &val);
+	if (ret == 0) {
+		prefetch &= ~L310_PREFETCH_CTRL_OFFSET_MASK;
+		prefetch |= val & L310_PREFETCH_CTRL_OFFSET_MASK;
+	} else if (ret != -EINVAL) {
+		pr_err("PL310 OF: missing value for arm,prefetch-offset property\n");
+	}
+
+	l2x0_saved_regs.prefetch_ctrl = prefetch;
 }
 
 static const struct l2c_init_data of_l2c310_data __initconst = {
-- 
1.9.2

