Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbaJ2J1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:27:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26453 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbaJ2JXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:23:14 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-e6-5450b1ffddac
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
Subject: [PATCH v7 5/8] ARM: l2c: Add support for overriding prefetch settings
Date: Wed, 29 Oct 2014 10:22:58 +0100
Message-id: <1414574581-2320-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
References: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xy7r/NwaEGJyZrmvxaP5jZoveBVfZ
	LM42vWG32N45g91iyp/lTBabHl9jtbi8aw6bxewl/SwWM87vY7K4fZnX4tz2LSwWa4/cZbdY
	ev0ik8WqXX8YLfZf8XLg91gzbw2jR0tzD5vHt6+TWDwu9/UyeSz6nuWxc9Zddo871/aweWxe
	Uu/Rt2UVo8fnTXIBXFFcNimpOZllqUX6dglcGYu7TjEXXFeo+LDsOksD43upLkZODgkBE4ml
	u3exQ9hiEhfurWfrYuTiEBJYyijR3LSGEcLpY5K4OPU3WBWbgKFE19suNhBbRCBb4se3ySwg
	RcwCfcwS56f3MIMkhAX8JLquPmcCsVkEVCU+b50MZvMKuEvs+72YDWKdnMT/lyvA4pwCHhKr
	LywBiwsB1Ww83M02gZF3ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQkP6yg3HxMatD
	jAIcjEo8vBq7/UOEWBPLiitzDzFKcDArifDuMA8IEeJNSaysSi3Kjy8qzUktPsTIxMEp1cCY
	pFnwPaGVYf8p9ZjA1ZMEJjpLnnti+vFo2aQ7k+9l7X3XkRD9S+u12a/9if8zzZ8pe/wU0Ygy
	nbHd36JqxZf7i0N1QheXM39XvrDHRD7Bm9HMNb1mK3Mo9zoW4aiL4dfP9e6/mvBg8d0Tl/YL
	6F0PC3mzNFfu8XLWRpU5khsjrt2MkZ+49dFcJZbijERDLeai4kQAYdx/+0cCAAA=
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
[mszyprow: rebased onto v3.18-rc1, added error message when prefetch related
 dt property has been provided without any value]
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
index 83b36f3b415c..ae417ddb05ed 100644
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
 		       assoc);
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
+		pr_err("L2C-310 OF arm,double-linefill property value is missing\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,double-linefill-incr", &val);
+	if (ret == 0) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
+	} else if (ret != -EINVAL) {
+		pr_err("L2C-310 OF arm,double-linefill-incr property value is missing\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,double-linefill-wrap", &val);
+	if (ret == 0) {
+		if (!val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
+	} else if (ret != -EINVAL) {
+		pr_err("L2C-310 OF arm,double-linefill-wrap property value is missing\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,prefetch-drop", &val);
+	if (ret == 0) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_PREFETCH_DROP;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_PREFETCH_DROP;
+	} else if (ret != -EINVAL) {
+		pr_err("L2C-310 OF arm,prefetch-drop property value is missing\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,prefetch-offset", &val);
+	if (ret == 0) {
+		prefetch &= ~L310_PREFETCH_CTRL_OFFSET_MASK;
+		prefetch |= val & L310_PREFETCH_CTRL_OFFSET_MASK;
+	} else if (ret != -EINVAL) {
+		pr_err("L2C-310 OF arm,prefetch-offset property value is missing\n");
+	}
+
+	l2x0_saved_regs.prefetch_ctrl = prefetch;
 }
 
 static const struct l2c_init_data of_l2c310_data __initconst = {
-- 
1.9.2

