Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3IOJub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:50:31 -0400
Received: from gnurou.org ([207.192.72.5]:40425 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab3IOJu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:50:29 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Sep 2013 05:50:29 EDT
From: Alexandre Courbot <acourbot@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: gnurou@gmail.com, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v6 4/5] ARM: tegra: set CPU reset handler with firmware op
Date: Sun, 15 Sep 2013 18:40:27 +0900
Message-Id: <1379238028-7960-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379238028-7960-1-git-send-email-acourbot@nvidia.com>
References: <1379238028-7960-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a firmware operation to set the CPU reset handler and only resort to
doing it ourselves if there is none defined.

This supports the booting of secondary CPUs on devices using a TrustZone
secure monitor.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/reset.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
index 6964117..fc9cf03 100644
--- a/arch/arm/mach-tegra/reset.c
+++ b/arch/arm/mach-tegra/reset.c
@@ -21,6 +21,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
+#include <asm/firmware.h>
 
 #include "iomap.h"
 #include "irammap.h"
@@ -65,6 +66,7 @@ static void __init tegra_cpu_reset_handler_enable(void)
 	void __iomem *iram_base = IO_ADDRESS(TEGRA_IRAM_RESET_BASE);
 	const u32 reset_address = TEGRA_IRAM_RESET_BASE +
 						tegra_cpu_reset_handler_offset;
+	int err;
 
 	BUG_ON(is_enabled);
 	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
@@ -72,9 +74,18 @@ static void __init tegra_cpu_reset_handler_enable(void)
 	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
 			tegra_cpu_reset_handler_size);
 
-	tegra_cpu_reset_handler_set(reset_address);
-
-	is_enabled = true;
+	err = call_firmware_op(set_cpu_boot_addr, 0, reset_address);
+	switch (err) {
+	case -ENOSYS:
+		tegra_cpu_reset_handler_set(reset_address);
+		/* pass-through */
+	case 0:
+		is_enabled = true;
+		break;
+	default:
+		pr_crit("Cannot set CPU reset handler: %d\n", err);
+		BUG();
+	}
 }
 
 void __init tegra_cpu_reset_handler_init(void)
-- 
1.8.4

