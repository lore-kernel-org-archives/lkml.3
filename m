Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbaKMNUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:20:33 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48479 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793AbaKMNSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:18:25 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-d2-5464af9f6953
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
Subject: [PATCH v8 4/7] ARM: l2c: Add support for overriding prefetch settings
Date: Thu, 13 Nov 2014 14:18:11 +0100
Message-id: <1415884694-5868-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
References: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xy7rz16eEGPw9r2Lxd9IxdotH8x8z
	W/QuuMpmcbbpDbvF9s4Z7BZT/ixnstj0+BqrxeVdc9gsZi/pZ7GYcX4fk8Xty7wW57ZvYbFY
	e+Quu8XS6xeZLE5d/8xmsWrXH0aL/Ve8HAQ91sxbw+jR0tzD5vH71yRGj29fJ7F4XO7rZfJY
	9D3LY+esu+wed67tYfPYvKTe48qJJlaPvi2rGD0+b5IL4InisklJzcksSy3St0vgyrh4up25
	YItCxcE5t5kaGK9IdTFyckgImEhsOLGCGcIWk7hwbz1bFyMXh5DAUkaJ7z0n2CGcPiaJFbtX
	soJUsQkYSnS97WIDsUUE3CT+rTsE1sEs8JlZ4tKjNUBFHBzCAn4S+1elgNSwCKhKrOtbwg4S
	5hVwl1jRFgKxTE7i/8sVTCA2p4CHxJf1f8DGCwGVtO86zDiBkXcBI8MqRtHU0uSC4qT0XEO9
	4sTc4tK8dL3k/NxNjJCw/7KDcfExq0OMAhyMSjy8H7hTQoRYE8uKK3MPMUpwMCuJ8L5ZCRTi
	TUmsrEotyo8vKs1JLT7EyMTBKdXA6G53X+mMLNNW1s07HBmCbjo2b67YtDNh1tnoYyFrJ5wV
	153lEHDk8yc2LT8RZl+pJeIhSx6I6YYqpEW8kg9cOU1OLNvqlI2aq7z6/H0tSae/KHsJ8z4s
	aeaUa2k38ZR5/kDKdpa9eNSLDUldf4Ttt90RiTnurrtZ8w47q9OuC2GidbMfJccpsRRnJBpq
	MRcVJwIAQVs5VFkCAAA=
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
 arch/arm/mm/cache-l2x0.c                       | 54 ++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

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
index d214be207517..6f9d5a02d053 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1169,6 +1169,8 @@ static void __init l2c310_of_parse(const struct device_node *np,
 	u32 tag[3] = { 0, 0, 0 };
 	u32 filter[2] = { 0, 0 };
 	u32 assoc;
+	u32 prefetch;
+	u32 val;
 	int ret;
 
 	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
@@ -1214,6 +1216,58 @@ static void __init l2c310_of_parse(const struct device_node *np,
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

