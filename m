Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3KGFLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:11:03 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27415 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188Ab3KGFK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:10:59 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] ARM: l2x0: add prefetch and power ctrl registers configuration support
Date: Thu, 7 Nov 2013 13:07:52 +0800
Message-ID: <1383800872-7982-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_02:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060290
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PL310 supports Prefetch offset/control register from r2p0 and Power
control register from r3p0. This patch adds the support to configure
these two registers if there are. The dt binding document is also updated.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 Documentation/devicetree/bindings/arm/l2cc.txt |  4 ++++
 arch/arm/mm/cache-l2x0.c                       | 19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
index c0c7626..32cd08c 100644
--- a/Documentation/devicetree/bindings/arm/l2cc.txt
+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
@@ -39,6 +39,10 @@ Optional properties:
 - arm,filter-ranges : <start length> Starting address and length of window to
   filter. Addresses in the filter window are directed to the M1 port. Other
   addresses will go to the M0 port.
+- arm,prefetch-ctrl : The value for Prefetch Offset/Control Register if there
+  is. This is a single cell.
+- arm,pwr-ctrl : The value for Power Control Register if there is. This is a
+  single cell.
 - interrupts : 1 combined interrupt.
 - cache-id-part: cache id part number to be used if it is not present
   on hardware
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 447da6f..8f536ea 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -704,6 +704,8 @@ static void __init pl310_of_setup(const struct device_node *np,
 	u32 data[3] = { 0, 0, 0 };
 	u32 tag[3] = { 0, 0, 0 };
 	u32 filter[2] = { 0, 0 };
+	u32 l2x0_revision = readl_relaxed(l2x0_base + L2X0_CACHE_ID) &
+		L2X0_CACHE_ID_RTL_MASK;
 
 	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
 	if (tag[0] && tag[1] && tag[2])
@@ -730,6 +732,23 @@ static void __init pl310_of_setup(const struct device_node *np,
 		writel_relaxed((filter[0] & ~(SZ_1M - 1)) | L2X0_ADDR_FILTER_EN,
 			       l2x0_base + L2X0_ADDR_FILTER_START);
 	}
+
+	if (l2x0_revision >= L2X0_CACHE_ID_RTL_R2P0) {
+		u32 prefetch_ctrl = 0;
+
+		of_property_read_u32(np, "arm,prefetch-ctrl",
+				     &prefetch_ctrl);
+		if (prefetch_ctrl)
+			writel_relaxed(prefetch_ctrl, l2x0_base +
+					L2X0_PREFETCH_CTRL);
+		if (l2x0_revision >= L2X0_CACHE_ID_RTL_R3P0) {
+			u32 pwr_ctrl = 0;
+			of_property_read_u32(np, "arm,pwr-ctrl", &pwr_ctrl);
+			if (pwr_ctrl)
+				writel_relaxed(pwr_ctrl, l2x0_base +
+						L2X0_POWER_CTRL);
+		}
+	}
 }
 
 static void __init pl310_save(void)
-- 
1.8.4.2

