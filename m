Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaCDVdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:33:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbaCDUDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 3.13 023/172] ARM: tegra: only run PL310 init on systems with one
Date: Tue,  4 Mar 2014 12:01:47 -0800
Message-Id: <20140304200300.471674461@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-tegra/tegra.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -74,10 +74,20 @@ u32 tegra_uart_config[4] = {
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


