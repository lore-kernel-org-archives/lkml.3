Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbaCEO0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:26:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41123 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaCEO00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 084/131] ARM: tegra: only run PL310 init on systems with one
Date: Wed,  5 Mar 2014 14:23:28 +0000
Message-Id: <1394029455-23128-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 8859685785bfafadf9bc922dd3a2278e59886947 upstream.

Fix tegra_init_cache() to check whether the system has a PL310 cache
before touching the PL310 registers. This prevents access to non-existent
registers on Tegra114 and later.

Note for stable kernels:
In <= v3.12, the file to patch is arch/arm/mach-tegra/common.c.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
[ swarren: When applying this to 3.10, there will be a trivial conflict,
  just due to context differences, at the added include of (linux/of.h>) ]
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-tegra/common.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 94a119a..3c405f4 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/of.h>
 #include <linux/reboot.h>
 #include <linux/irqchip.h>
 #include <linux/clk-provider.h>
@@ -82,10 +83,20 @@ void tegra_assert_system_reset(enum reboot_mode mode, const char *cmd)
 static void __init tegra_init_cache(void)
 {
 #ifdef CONFIG_CACHE_L2X0
+	static const struct of_device_id pl310_ids[] __initconst = {
+		{ .compatible = "arm,pl310-cache",  },
+		{}
+	};
+
+	struct device_node *np;
 	int ret;
 	void __iomem *p = IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x3000;
 	u32 aux_ctrl, cache_type;
 
+	np = of_find_matching_node(NULL, pl310_ids);
+	if (!np)
+		return;
+
 	cache_type = readl(p + L2X0_CACHE_TYPE);
 	aux_ctrl = (cache_type & 0x700) << (17-8);
 	aux_ctrl |= 0x7C400001;
-- 
1.9.0

