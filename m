Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaJMUMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:12:13 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42530 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaJMUMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:12:10 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 2/6] ARM: rockchip: add option to access the pmu via a phandle in smp_operations
Date: Mon, 13 Oct 2014 13:11:58 -0700
Message-Id: <1413231122-1770-3-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com>
References: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko@sntech.de>

Makes it possible to define a rockchip,pmu phandle in the cpus node directly
referencing the pmu syscon instead of searching for specific compatible.

The old way of finding the pmu stays of course available.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v4:
- add rockchip,pmu property into cpus.txt

Changes in v3:
- add this patch

Changes in v2: None

 Documentation/devicetree/bindings/arm/cpus.txt |  9 +++++++++
 arch/arm/mach-rockchip/platsmp.c               | 13 +++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index fc44634..b2aacbe 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -227,6 +227,15 @@ nodes to be present and contain the properties described below.
 			# List of phandles to idle state nodes supported
 			  by this cpu [3].
 
+	- rockchip,pmu
+		Usage: optional for systems that have an "enable-method"
+		       property value of "rockchip,rk3066-smp"
+		       While optional, it is the preferred way to get access to
+		       the cpu-core power-domains.
+		Value type: <phandle>
+		Definition: Specifies the syscon node controlling the cpu core
+			    power domains.
+
 Example 1 (dual-cluster big.LITTLE system 32-bit):
 
 	cpus {
diff --git a/arch/arm/mach-rockchip/platsmp.c b/arch/arm/mach-rockchip/platsmp.c
index 4c36fbf..57b53b3 100644
--- a/arch/arm/mach-rockchip/platsmp.c
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -155,6 +155,19 @@ static int __init rockchip_smp_prepare_pmu(void)
 	struct device_node *node;
 	void __iomem *pmu_base;
 
+	/*
+	 * This function is only called via smp_ops->smp_prepare_cpu().
+	 * That only happens if a "/cpus" device tree node exists
+	 * and has an "enable-method" property that selects the SMP
+	 * operations defined herein.
+	 */
+	node = of_find_node_by_path("/cpus");
+
+	pmu = syscon_regmap_lookup_by_phandle(node, "rockchip,pmu");
+	of_node_put(node);
+	if (!IS_ERR(pmu))
+		return 0;
+
 	pmu = syscon_regmap_lookup_by_compatible("rockchip,rk3066-pmu");
 	if (!IS_ERR(pmu))
 		return 0;
-- 
1.9.1

