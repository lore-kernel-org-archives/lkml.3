Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaEVQsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:48:35 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:58765 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbaEVQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:48:31 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, Florian Fainelli <f.fainelli@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, Li Yang <leoli@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Aida Mynzhasova <aida.mynzhasova@skitlab.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...)
Subject: [PATCH net-next v2 9/9] powerpc/fsl: fsl_soc: remove 'fixed-link' parsing code
Date: Thu, 22 May 2014 09:47:51 -0700
Message-Id: <1400777271-32199-10-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400777271-32199-1-git-send-email-f.fainelli@gmail.com>
References: <1400777271-32199-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parsing and registration of fixed PHY devices was needed with the use of
of_phy_connect_fixed_link() because this function was using the
designated PHY address identifier (first cell of the property) as the
address to bind the PHY on the emulated bus.

Since commit 3be2a49e5c08d268f8af0dd4fe89a24ea8cdc339 ("of: provide a
binding for fixed link PHYs") a new pair of functions has been
introduced which allows for dynamic address allocation of these fixed
PHY devices, but also parses the old 'fixed-link' 5-digit property.

Registration of fixed PHY early in platform code was needed because we
could not issue a fixed MDIO bus re-scan within network drivers. The
fixed PHYs had to be registered before the network drivers would call
of_phy_connect_fixed_link(). All of these caveats are solved now, such
that we can safely remove of_add_fixed_phys() now.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
No changes in v2

 arch/powerpc/sysdev/fsl_soc.c | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 228cf91b91c1..ffd1169ebaab 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -25,7 +25,6 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/phy.h>
-#include <linux/phy_fixed.h>
 #include <linux/spi/spi.h>
 #include <linux/fsl_devices.h>
 #include <linux/fs_enet_pd.h>
@@ -178,37 +177,6 @@ u32 get_baudrate(void)
 EXPORT_SYMBOL(get_baudrate);
 #endif /* CONFIG_CPM2 */
 
-#ifdef CONFIG_FIXED_PHY
-static int __init of_add_fixed_phys(void)
-{
-	int ret;
-	struct device_node *np;
-	u32 *fixed_link;
-	struct fixed_phy_status status = {};
-
-	for_each_node_by_name(np, "ethernet") {
-		fixed_link  = (u32 *)of_get_property(np, "fixed-link", NULL);
-		if (!fixed_link)
-			continue;
-
-		status.link = 1;
-		status.duplex = fixed_link[1];
-		status.speed = fixed_link[2];
-		status.pause = fixed_link[3];
-		status.asym_pause = fixed_link[4];
-
-		ret = fixed_phy_add(PHY_POLL, fixed_link[0], &status);
-		if (ret) {
-			of_node_put(np);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-arch_initcall(of_add_fixed_phys);
-#endif /* CONFIG_FIXED_PHY */
-
 #if defined(CONFIG_FSL_SOC_BOOKE) || defined(CONFIG_PPC_86xx)
 static __be32 __iomem *rstcr;
 
-- 
1.9.1

