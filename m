Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab3HMCab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:30:31 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9009 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab3HMCa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:30:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 12 Aug 2013 19:28:33 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Joseph Lo <josephl@nvidia.com>, Jassi Brar <jassisinghbrar@gmail.com>
CC: <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 4/5] ARM: tegra: set CPU reset handler with firmware op
Date: Tue, 13 Aug 2013 11:29:51 +0900
Message-ID: <1376360992-1508-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376360992-1508-1-git-send-email-acourbot@nvidia.com>
References: <1376360992-1508-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a firmware operation to set the CPU reset handler and only resort to
doing it ourselves if there is none defined.

This supports the booting of secondary CPUs on devices using a TrustZone
secure monitor.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
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
1.8.3.4

