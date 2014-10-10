Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaJJV12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:27:28 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42447 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbaJJV00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:26:26 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] ARM: rockchip: add option to access the pmu via a phandle in smp_operations
Date: Fri, 10 Oct 2014 14:26:07 -0700
Message-Id: <1412976370-14468-4-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412976370-14468-1-git-send-email-kever.yang@rock-chips.com>
References: <1412976370-14468-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes it possible to define a rockchip,pmu phandle in the cpus node directly
referencing the pmu syscon instead of searching for specific compatible.

The old way of finding the pmu stays of course available.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v3:
- add this patch

Changes in v2: None

 arch/arm/mach-rockchip/platsmp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

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

